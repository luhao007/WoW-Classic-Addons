if BG.IsBlackListPlayer then return end
local AddonName, ns = ...

local LibBG = ns.LibBG
local L = ns.L

local RR = ns.RR
local NN = ns.NN
local RN = ns.RN
local Size = ns.Size
local RGB = ns.RGB
local RGB_16 = ns.RGB_16
local GetClassRGB = ns.GetClassRGB
local SetClassCFF = ns.SetClassCFF
local GetText_T = ns.GetText_T
local FrameDongHua = ns.FrameDongHua
local FrameHide = ns.FrameHide
local AddTexture = ns.AddTexture
local GetItemID = ns.GetItemID

local Width = ns.Width
local Height = ns.Height
local Maxb = ns.Maxb
local Maxi = ns.Maxi
local HopeMaxn = ns.HopeMaxn
local HopeMaxb = ns.HopeMaxb
local HopeMaxi = ns.HopeMaxi

local pt = print
local RealmId = GetRealmID()
local player = UnitName("player")

BG.Init(function()
    local sending = {}
    local sendDone = {}
    local sendingCount = {}
    local notShowSendingText = {}

    local function UpdateGuildFrame(frame)
        if IsInRaid(1) then
            frame:SetWidth(1)
            frame:Hide()
        elseif IsInGuild() then
            local numTotal, numOnline, numOnlineAndMobile = GetNumGuildMembers()
            frame.text:SetFormattedText(frame.title2, (Size(frame.table) .. "/" .. numOnline))
            frame:SetWidth(frame.text:GetWidth() + 10)
            frame:Show()
        end
    end

    local function UpdateAddonFrame(frame)
        if IsInRaid(1) then
            local count = 0
            for name in pairs(frame.table) do
                if BG.raidRosterName[name] then
                    count = count + 1
                end
            end
            frame.text:SetFormattedText(frame.title2, (count .. "/" .. GetNumGroupMembers()))
            frame:SetWidth(frame.text:GetWidth() + 10)
            frame:Show()
        else
            wipe(frame.table)
            frame:Hide()
        end
    end
    local function Guild_OnEnter(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(self.title, 0, 1, 0)
        GameTooltip:AddLine(" ")
        local ii = 0
        for i = 1, GetNumGuildMembers() do
            local name, rankName, rankIndex, level, classDisplayName, zone,
            publicNote, officerNote, isOnline, status, class, achievementPoints,
            achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(i)
            name = strsplit("-", name)
            if isOnline then
                if ii > 40 then
                    GameTooltip:AddLine("......")
                    break
                end
                ii = ii + 1
                local line = 2
                local Ver = self.table[name] or L["无"]
                local r, g, b = GetClassColor(class)
                GameTooltip:AddDoubleLine(name, Ver, r, g, b, 1, 1, 1)
                if Ver == L["无"] then
                    local alpha = 0.3
                    if _G["GameTooltipTextLeft" .. (ii + line)] then
                        _G["GameTooltipTextLeft" .. (ii + line)]:SetAlpha(alpha)
                    end
                    if _G["GameTooltipTextRight" .. (ii + line)] then
                        _G["GameTooltipTextRight" .. (ii + line)]:SetAlpha(alpha)
                    end
                end
            end
        end
        GameTooltip:Show()
    end

    local function Addon_OnEnter(self)
        self.isOnEnter = true

        local line = 2
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(self.title, 0, 1, 0)
        if self.isAuciton then
            GameTooltip:AddLine(L["需全团安装拍卖WA，没安装的人将会看不到拍卖窗口"], 0.5, 0.5, 0.5, true)
            line = line + 1
        end
        GameTooltip:AddLine(" ")
        local raid = BG.PaiXuRaidRosterInfo()
        for i, v in ipairs(raid) do
            local Ver = self.table[v.name]
            if not Ver then
                if v.online then
                    Ver = L["无"]
                else
                    Ver = L["未知"]
                end
            end

            if self.isAuciton then
                if sending[v.name] then
                    Ver = L["正在接收拍卖WA"]
                end
                if sendDone[v.name] then
                    Ver = L["接收完毕，但未导入"]
                end
            end

            local vip = self.table2[v.name] and AddTexture("VIP") or ""
            local role = ""
            local y
            if v.rank == 2 then
                role = role .. AddTexture("interface/groupframe/ui-group-leadericon", y)
            elseif v.rank == 1 then
                role = role .. AddTexture("interface/groupframe/ui-group-assistanticon", y)
            end
            if v.isML then
                role = role .. AddTexture("interface/groupframe/ui-group-masterlooter", y)
            end
            local c1, c2, c3 = GetClassRGB(v.name)
            GameTooltip:AddDoubleLine(v.name .. role .. vip, Ver, c1, c2, c3, 1, 1, 1)
            if Ver == L["无"] or Ver == L["未知"] then
                local alpha = 0.4
                if _G["GameTooltipTextLeft" .. (i + line)] then
                    _G["GameTooltipTextLeft" .. (i + line)]:SetAlpha(alpha)
                end
                if _G["GameTooltipTextRight" .. (i + line)] then
                    _G["GameTooltipTextRight" .. (i + line)]:SetAlpha(alpha)
                end
            end
        end
        GameTooltip:Show()
    end

    local function UpdateOnEnter(self)
        if self and self.isOnEnter then
            self:GetScript("OnEnter")(self)
        end
    end

    ------------------团长开始拍卖UI------------------
    do
        BiaoGe.Auction = BiaoGe.Auction or {}
        if BG.IsVanilla then
            BiaoGe.Auction.money = BiaoGe.Auction.money or 1
            BiaoGe.Auction.fastMoney = BiaoGe.Auction.fastMoney or { 100, 300, 500, 1000, 2000 }
        else
            BiaoGe.Auction.money = BiaoGe.Auction.money or 1000
            BiaoGe.Auction.fastMoney = BiaoGe.Auction.fastMoney or { 1000, 2000, 3000, 5000, 10000 }
        end
        BiaoGe.Auction.duration = BiaoGe.Auction.duration or 30
        BiaoGe.Auction.mod = BiaoGe.Auction.mod or "normal"

        local function ClearAllFocus(f)
            f.Edit1:ClearFocus()
            f.Edit2:ClearFocus()
            LibBG:CloseDropDownMenus()
        end
        local function item_OnEnter(self)
            if BG.ButtonIsInRight(self) then
                GameTooltip:SetOwner(self, "ANCHOR_LEFT", 0, 0)
            else
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
            end
            GameTooltip:ClearLines()
            GameTooltip:SetItemByID(self.itemID)
            GameTooltip:Show()
            self.isOnEnter = true
            if self.isIcon then
                self.owner.lastIcon = self
                if not self.isChooseTex then
                    self.isChooseTex = self:CreateTexture()
                    self.isChooseTex:SetAllPoints()
                    self.isChooseTex:SetColorTexture(1, 1, 1, .2)
                    self.isChooseTex:Hide()
                end
                self.isChooseTex:Show()
            end
        end
        local function item_OnLeave(self)
            GameTooltip_Hide()
            self.isOnEnter = nil
            if self.isIcon then
                self.owner.lastIcon = nil
                self.isChooseTex:Hide()
            end
        end
        local function Start_OnClick(self)
            BG.PlaySound(1)
            local money = self.money or tonumber(BiaoGe.Auction.money)
            local _duration = tonumber(BiaoGe.Auction.duration)
            local duration = _duration and _duration > 0 and _duration
            local mod = BiaoGe.Auction.mod
            if not (money and duration) then return end
            local t = 0
            for i, itemID in ipairs(self.itemIDs) do
                BG.After(t, function()
                    local text = "StartAuction," .. GetTime() .. "," .. itemID .. "," ..
                        money .. "," .. duration .. ",," .. mod
                    C_ChatInfo.SendAddonMessage("BiaoGeAuction", text, "RAID")
                end)
                t = t + 0.2
            end
            self:GetParent():Hide()
        end
        local function OnTextChanged(self)
            BiaoGe.Auction[self._type] = self:GetText()
        end
        local function OnEnterPressed(self)
            if self.num == 1 then
                self:GetParent().Edit2:SetFocus()
            else
                Start_OnClick(self:GetParent().bt)
            end
        end
        local function Edit_OnEnter(self)
            if BG.ButtonIsInRight(self) then
                GameTooltip:SetOwner(self, "ANCHOR_LEFT", 0, 0)
            else
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
            end
            GameTooltip:ClearLines()
            GameTooltip:AddLine(self:GetText(), 1, 1, 1, true)
            GameTooltip:AddLine(L["最后20秒有人出价时，拍卖时间会重置到20秒"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end

        function BG.StartAuction(link, bt, isNotAuctioned, notAlt, isRightButton)
            if BiaoGe.options["autoAuctionStart"] ~= 1 and not notAlt then return end
            if not link then return end
            if not BG.IsML then return end
            local link = BG.Copy(link)
            local itemIDs = {}
            if type(link) == "table" then
                itemIDs = link
            else
                itemIDs[1] = GetItemID(link)
            end
            if BG.StartAucitonFrame then BG.StartAucitonFrame:Hide() end
            GameTooltip:Hide()
            local name, link, quality, level, _, itemType, itemSubType, _, itemEquipLoc, Texture,
            _, classID, subclassID, bindType = GetItemInfo(itemIDs[1])

            local mainFrame
            local mainFrameWidth = 250
            local mainFrameHeight = 145
            local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
            do
                f:SetBackdrop({
                    bgFile = "Interface/ChatFrame/ChatFrameBackground",
                    edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                    edgeSize = 2,
                })
                f:SetBackdropColor(0.3, 0.3, 0.3, 0.8)
                f:SetBackdropBorderColor(0, 0, 0, 1)
                f:SetSize(mainFrameWidth, mainFrameHeight)
                if bt then
                    if isNotAuctioned then
                        f:SetPoint("TOP", bt, "BOTTOM", 10, 0)
                    else
                        f:SetPoint("BOTTOM", bt, "TOP", 0, 0)
                    end
                else
                    local x, y = GetCursorPosition()
                    x, y = x / UIParent:GetEffectiveScale(), y / UIParent:GetEffectiveScale()
                    f:SetPoint("BOTTOM", UIParent, "BOTTOMLEFT", x + 10, y + 10)
                end
                f:SetFrameStrata("DIALOG")
                f:SetFrameLevel(300)
                f:SetClampedToScreen(true)
                f:SetToplevel(true)
                f:EnableMouse(true)
                f:SetMovable(true)
                f:SetScript("OnMouseUp", function(self)
                    f:StopMovingOrSizing()
                    f:SetScript("OnUpdate", nil)
                end)
                f:SetScript("OnMouseDown", function(self)
                    f:StartMoving()
                    ClearAllFocus(f)

                    f.time = 0
                    f:SetScript("OnUpdate", function(self, time)
                        f.time = f.time + time
                        if f.time >= 0.2 then
                            f.time = 0
                            if f.itemFrame.isOnEnter then
                                GameTooltip:Hide()
                                f.itemFrame:GetScript("OnEnter")(f.itemFrame)
                            elseif f.lastIcon then
                                GameTooltip:Hide()
                                f.lastIcon:GetScript("OnEnter")(f.lastIcon)
                            end
                        end
                    end)
                end)
                mainFrame = f
                BG.StartAucitonFrame = mainFrame

                f.CloseButton = CreateFrame("Button", nil, f, "UIPanelCloseButton")
                f.CloseButton:SetFrameLevel(f.CloseButton:GetParent():GetFrameLevel() + 50)
                f.CloseButton:SetPoint("TOPRIGHT", f, 0, 0)
                f.CloseButton:SetSize(35, 35)
            end

            -- 装备显示
            do
                local f = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
                f:SetPoint("TOPLEFT", f:GetParent(), "TOPLEFT", 2, -2)
                f:SetPoint("BOTTOMRIGHT", f:GetParent(), "TOPRIGHT", -2, -35)
                f:SetFrameLevel(f:GetParent():GetFrameLevel() + 10)
                f.itemID = itemIDs[1]
                f:SetScript("OnMouseUp", function(self)
                    mainFrame:GetScript("OnMouseUp")(mainFrame)
                end)
                f:SetScript("OnMouseDown", function(self)
                    mainFrame:GetScript("OnMouseDown")(mainFrame)
                end)
                mainFrame.itemFrame = f
                -- 黑色背景
                local s = CreateFrame("StatusBar", nil, f)
                s:SetAllPoints()
                s:SetFrameLevel(s:GetParent():GetFrameLevel() - 5)
                s:SetStatusBarTexture("Interface/ChatFrame/ChatFrameBackground")
                s:SetStatusBarColor(0, 0, 0, 0.8)

                local icons = {}
                for i, itemID in ipairs(itemIDs) do
                    local name, link, quality, level, _, itemType, itemSubType, _, itemEquipLoc, Texture,
                    _, classID, subclassID, bindType = GetItemInfo(itemID)

                    -- 图标
                    local r, g, b = GetItemQualityColor(quality)
                    local ftex = CreateFrame("Frame", nil, f, "BackdropTemplate")
                    ftex:SetBackdrop({
                        edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                        edgeSize = 1.5,
                    })
                    ftex:SetBackdropBorderColor(r, g, b, 1)
                    if i == 1 then
                        ftex:SetPoint("TOPLEFT", 0, 0)
                    else
                        ftex:SetPoint("TOPLEFT", icons[i - 1], "TOPRIGHT", 3, 0)
                    end
                    ftex:SetSize(f:GetHeight() - 2, f:GetHeight() - 2)
                    ftex.itemID = itemID
                    tinsert(icons, ftex)

                    ftex.isIcon = true
                    ftex.owner = mainFrame
                    ftex:SetScript("OnEnter", item_OnEnter)
                    ftex:SetScript("OnLeave", item_OnLeave)
                    ftex:SetScript("OnMouseUp", function(self)
                        mainFrame:GetScript("OnMouseUp")(mainFrame)
                    end)
                    ftex:SetScript("OnMouseDown", function(self)
                        mainFrame:GetScript("OnMouseDown")(mainFrame)
                    end)

                    ftex.tex = ftex:CreateTexture(nil, "BACKGROUND")
                    ftex.tex:SetAllPoints()
                    ftex.tex:SetTexture(Texture)
                    ftex.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                    -- 装备等级
                    local t = ftex:CreateFontString()
                    t:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
                    t:SetPoint("BOTTOM", ftex, "BOTTOM", 0, 1)
                    t:SetText(level)
                    t:SetTextColor(r, g, b)
                    -- 装绑
                    if bindType == 2 then
                        local t = ftex:CreateFontString()
                        t:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        t:SetPoint("TOP", ftex, 0, -2)
                        t:SetText(L["装绑"])
                        t:SetTextColor(0, 1, 0)
                    end
                end

                if #itemIDs == 1 then
                    -- 装备名称
                    local t = f:CreateFontString()
                    t:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
                    t:SetPoint("TOPLEFT", icons[1], "TOPRIGHT", 2, -2)
                    t:SetWidth(f:GetWidth() - f:GetHeight() - 10)
                    t:SetText(link:gsub("%[", ""):gsub("%]", ""))
                    t:SetJustifyH("LEFT")
                    t:SetWordWrap(false)
                    -- 装备类型
                    local t = f:CreateFontString()
                    t:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
                    t:SetPoint("BOTTOMLEFT", icons[1], "BOTTOMRIGHT", 2, 1)
                    t:SetHeight(12)

                    if _G[itemEquipLoc] then
                        if classID == 2 then
                            t:SetText(itemSubType)
                        else
                            t:SetText(_G[itemEquipLoc] .. " " .. itemSubType)
                        end
                    else
                        t:SetText("")
                    end
                    t:SetJustifyH("LEFT")
                end
            end

            local width = 90
            -- 起拍价、拍卖时长
            do
                local t = mainFrame:CreateFontString()
                t:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
                t:SetSize(width, 20)
                t:SetPoint("TOPLEFT", mainFrame.itemFrame, "BOTTOMLEFT", 8, -2)
                t:SetJustifyH("LEFT")
                t:SetWordWrap(false)
                t:SetText(L["|cffFFD100拍卖时长(秒)"])
                mainFrame.Text1 = t

                local edit = CreateFrame("EditBox", nil, mainFrame, "InputBoxTemplate")
                edit:SetSize(width, 20)
                edit:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 3, 0)
                edit._type = "duration"
                edit.num = 1
                edit:SetText(BiaoGe.Auction[edit._type])
                edit:SetAutoFocus(false)
                edit:SetNumeric(true)
                edit:SetScript("OnTextChanged", OnTextChanged)
                edit:SetScript("OnEnterPressed", OnEnterPressed)
                edit:SetScript("OnEnter", Edit_OnEnter)
                edit:SetScript("OnLeave", GameTooltip_Hide)
                mainFrame.Edit1 = edit

                local t = f:CreateFontString()
                t:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
                t:SetSize(width, 20)
                t:SetPoint("TOPLEFT", mainFrame.Text1, "BOTTOMLEFT", 0, -20)
                t:SetJustifyH("LEFT")
                t:SetWordWrap(false)
                t:SetText(L["|cffFFD100起拍价|r"])
                mainFrame.Text2 = t

                local edit = CreateFrame("EditBox", nil, mainFrame, "InputBoxTemplate")
                edit:SetSize(width, 20)
                edit:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 3, 0)
                edit._type = "money"
                edit.num = 2
                edit:SetText(BiaoGe.Auction[edit._type])
                edit:SetAutoFocus(false)
                edit:SetNumeric(true)
                edit:SetScript("OnTextChanged", OnTextChanged)
                edit:SetScript("OnEnterPressed", OnEnterPressed)
                mainFrame.Edit2 = edit
            end

            -- 拍卖模式
            do
                local t = f:CreateFontString()
                t:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
                t:SetSize(width, 20)
                t:SetPoint("LEFT", mainFrame.Text1, "RIGHT", 25, 0)
                t:SetJustifyH("LEFT")
                t:SetText(L["|cffFFD100拍卖模式|r"])
                mainFrame.Text3 = t

                local tbl = {
                    normal = L["正常模式"],
                    anonymous = L["匿名模式"],
                }

                local dropDown = LibBG:Create_UIDropDownMenu(nil, mainFrame)
                dropDown:SetScale(0.95)
                dropDown:SetPoint("TOPLEFT", mainFrame.Text3, "BOTTOMLEFT", -17, 2)
                LibBG:UIDropDownMenu_SetText(dropDown, tbl[BiaoGe.Auction.mod])
                dropDown.Text:SetJustifyH("LEFT")
                LibBG:UIDropDownMenu_SetWidth(dropDown, width + 5)
                LibBG:UIDropDownMenu_SetAnchor(dropDown, 0, 0, "BOTTOM", dropDown, "TOP")
                mainFrame.dropDown = dropDown
                BG.dropDownToggle(dropDown)
                LibBG:UIDropDownMenu_Initialize(dropDown, function(self, level)
                    ClearAllFocus(mainFrame)
                    local info = LibBG:UIDropDownMenu_CreateInfo()
                    info.text = L["正常模式"]
                    info.arg1 = "normal"
                    info.func = function(self, arg1, arg2)
                        BiaoGe.Auction.mod = arg1
                        LibBG:UIDropDownMenu_SetText(dropDown, tbl[BiaoGe.Auction.mod])
                    end
                    if info.arg1 == BiaoGe.Auction.mod then
                        info.checked = true
                    end
                    LibBG:UIDropDownMenu_AddButton(info)

                    local info = LibBG:UIDropDownMenu_CreateInfo()
                    info.text = L["匿名模式"]
                    info.arg1 = "anonymous"
                    info.tooltipTitle = L["匿名模式"]
                    info.tooltipText = L["拍卖过程中不会显示当前出价最高人是谁。拍卖结束后才会知晓"]
                    info.tooltipOnButton = true
                    info.func = function(self, arg1, arg2)
                        BiaoGe.Auction.mod = arg1
                        LibBG:UIDropDownMenu_SetText(dropDown, tbl[BiaoGe.Auction.mod])
                    end
                    if info.arg1 == BiaoGe.Auction.mod then
                        info.checked = true
                    end
                    LibBG:UIDropDownMenu_AddButton(info)
                end)
            end

            -- 开始拍卖
            do
                local bt= BG.CreateButton(mainFrame)
                bt:SetSize(width + 19, 25)
                bt:SetPoint("TOPLEFT", mainFrame.Text3, "BOTTOMLEFT", -1, -35)
                bt.itemIDs = itemIDs
                bt:SetText(L["开始拍卖"])
                mainFrame.bt = bt
                bt:SetScript("OnClick", Start_OnClick)
                if isRightButton and BiaoGeVIP and BiaoGeVIP.auction then
                    local _duration = tonumber(BiaoGe.Auction.duration)
                    local duration = _duration and _duration > 0 and _duration
                    if duration then
                        local tbl = {}
                        for _, FB in pairs(BG.FBtable) do
                            if FB == BG.FB1 then
                                tinsert(tbl, 1, FB)
                            else
                                tinsert(tbl, FB)
                            end
                        end
                        local itemID = itemIDs[1]
                        for _, FB in ipairs(tbl) do
                            local money = BiaoGeVIP.auction[FB].money[itemID]
                            if money then
                                bt.money = money
                                Start_OnClick(bt)
                                break
                            end
                        end
                    end
                end
            end

            -- 底部文字
            if BiaoGe.options["fastMoney"] == 1 then
                local tex = mainFrame:CreateTexture()
                tex:SetPoint("TOPLEFT", mainFrame, "BOTTOMLEFT", 2, 22)
                tex:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -2, 2)
                tex:SetColorTexture(0.2, 0.2, 0.2, 1)

                local buttons = {}
                local function CreateButton()
                    local bt = CreateFrame("Button", nil, f)
                    bt:SetSize(50, 20)
                    if #buttons == 0 then
                        bt:SetPoint("BOTTOMLEFT", mainFrame, 0, 2)
                    else
                        bt:SetPoint("BOTTOMLEFT", buttons[#buttons], "BOTTOMRIGHT", 0, 0)
                    end
                    if BiaoGe.Auction.fastMoney[#buttons + 1] == "" then
                        bt:Hide()
                    end
                    local t = bt:CreateFontString()
                    t:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                    t:SetWidth(bt:GetWidth())
                    t:SetPoint("CENTER")
                    t:SetText(20000)
                    t:SetText(BiaoGe.Auction.fastMoney[#buttons + 1])
                    t:SetTextColor(1, 0.82, 0)
                    t:SetWordWrap(false)
                    bt:SetFontString(t)
                    tinsert(buttons, bt)
                    bt:SetScript("OnClick", function(self)
                        BG.PlaySound(1)
                        local money = bt:GetText()
                        mainFrame.Edit2:SetText(money)
                        BiaoGe.Auction.money = money
                        Start_OnClick(mainFrame.bt)
                    end)
                    bt:SetScript("OnEnter", function(self)
                        t:SetTextColor(1, 1, 1)
                        if t:GetStringWidth() > bt:GetWidth() then
                            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
                            GameTooltip:ClearLines()
                            GameTooltip:AddLine(t:GetText(), 1, 0.82, 0, true)
                            GameTooltip:Show()
                        end
                    end)
                    bt:SetScript("OnLeave", function(self)
                        t:SetTextColor(1, .82, 0)
                        GameTooltip:Hide()
                    end)
                end
                for i = 1, #BiaoGe.Auction.fastMoney do
                    CreateButton()
                end
            else
                mainFrame:SetHeight(mainFrameHeight - 20)
            end
            --[[             do
                local tex = mainFrame:CreateTexture()
                tex:SetPoint("TOPLEFT", mainFrame, "BOTTOMLEFT", 2, 22)
                tex:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -2, 2)
                tex:SetColorTexture(0.2, 0.2, 0.2, 1)

                local auction = CreateFrame("Frame", nil, mainFrame)
                auction:SetSize(1, 20)
                auction:SetPoint("LEFT", tex, "LEFT", 0, 0)
                auction.title = L["拍卖WA版本"]
                auction.title2 = L["拍卖：%s"]
                auction.table = BG.raidAuctionVersion
                auction.isAuciton = true
                auction:SetScript("OnEnter", Addon_OnEnter)
                auction.text = auction:CreateFontString()
                auction.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
                auction.text:SetPoint("CENTER")
                auction.text:SetTextColor(0.7, 0.7, 0.7)
                mainFrame.auction = auction
                UpdateAddonFrame(auction)

                auction:SetScript("OnMouseUp", function(self)
                    mainFrame:GetScript("OnMouseUp")(mainFrame)
                end)
                auction:SetScript("OnMouseDown", function(self)
                    mainFrame:GetScript("OnMouseDown")(mainFrame)
                end)
                auction:SetScript("OnLeave", function(self)
                    GameTooltip:Hide()
                    self.isOnEnter = false
                end)
            end ]]
        end

        -- ALT点击背包生效
        hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
            if not IsAltKeyDown() then return end
            local link = C_Container.GetContainerItemLink(self:GetParent():GetID(), self:GetID())
            BG.StartAuction(link, self, nil, nil, button == "RightButton")
        end)
    end
    ------------------插件版本------------------
    do
        BG.guildBiaoGeVersion = {}
        BG.guildClass = {}
        BG.raidBiaoGeVersion = {}
        BG.raidAuctionVersion = {}
        BG.raidBiaoGeVIPVersion = {}

        -- 会员插件
        local guild = CreateFrame("Frame", nil, BG.MainFrame)
        do
            guild:SetSize(1, 20)
            guild:SetPoint("LEFT", BG.ButtonAd, "RIGHT", 0, 0)
            guild:Hide()
            guild.title = L["BiaoGe版本"] .. "(" .. GUILD .. ")"
            guild.title2 = GUILD .. L["插件：%s"]
            guild.table = BG.guildBiaoGeVersion
            guild.isGuild = true
            guild:SetScript("OnEnter", Guild_OnEnter)
            BG.GameTooltip_Hide(guild)
            guild.text = guild:CreateFontString()
            guild.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
            guild.text:SetPoint("LEFT")
            guild.text:SetTextColor(RGB(BG.g1))
            BG.ButtonGuildVer = guild
        end

        -- 团员插件
        local addon = CreateFrame("Frame", nil, BG.MainFrame)
        do
            addon:SetSize(1, 20)
            addon:SetPoint("LEFT", BG.ButtonGuildVer, "RIGHT", 0, 0)
            addon:Hide()
            addon.title = L["BiaoGe版本"] .. "(" .. RAID .. ")"
            addon.title2 = L["插件：%s"]
            addon.table = BG.raidBiaoGeVersion
            addon.table2 = BG.raidBiaoGeVIPVersion
            addon.isAddon = true
            addon:SetScript("OnEnter", Addon_OnEnter)
            addon.text = addon:CreateFontString()
            addon.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
            addon.text:SetPoint("LEFT")
            addon.text:SetTextColor(RGB(BG.g1))
            BG.ButtonRaidVer = addon
            addon:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
                self.isOnEnter = false
            end)
        end

        -- 拍卖WA
        local auction = CreateFrame("Frame", nil, BG.MainFrame)
        do
            auction:SetSize(1, 20)
            auction:SetPoint("LEFT", addon, "RIGHT", 0, 0)
            auction:Hide()
            auction.title = L["拍卖WA版本"]
            auction.title2 = L["拍卖：%s"]
            auction.table = BG.raidAuctionVersion
            auction.table2 = BG.raidBiaoGeVIPVersion
            auction.isAuciton = true
            auction:SetScript("OnEnter", Addon_OnEnter)
            auction.text = auction:CreateFontString()
            auction.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
            auction.text:SetPoint("LEFT")
            auction.text:SetTextColor(RGB(BG.g1))
            BG.ButtonRaidAuction = auction
            auction:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
                self.isOnEnter = false
            end)
        end

        local f = CreateFrame("Frame")
        f:RegisterEvent("GROUP_ROSTER_UPDATE")
        f:RegisterEvent("GUILD_ROSTER_UPDATE")
        f:RegisterEvent("CHAT_MSG_SYSTEM")
        f:RegisterEvent("CHAT_MSG_ADDON")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:SetScript("OnEvent", function(self, event, ...)
            if event == "GROUP_ROSTER_UPDATE" then
                BG.After(1, function()
                    if IsInRaid(1) then
                        C_ChatInfo.SendAddonMessage("BiaoGe", "MyVer-" .. BG.ver, "RAID")
                    else
                        UpdateAddonFrame(addon)
                        UpdateAddonFrame(auction)
                    end
                    UpdateGuildFrame(guild)
                end)
            elseif event == "GUILD_ROSTER_UPDATE" then
                BG.After(1, function()
                    for i = 1, GetNumGuildMembers() do
                        local name, rankName, rankIndex, level, classDisplayName, zone,
                        publicNote, officerNote, isOnline, status, class, achievementPoints,
                        achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(i)
                        if name then
                            name = strsplit("-", name)
                            if not isOnline then
                                BG.guildBiaoGeVersion[name] = nil
                                BG.guildClass[name] = nil
                            else
                                BG.guildClass[name] = class
                            end
                        end
                    end
                    UpdateGuildFrame(guild)
                end)
            elseif event == "CHAT_MSG_SYSTEM" then -- 如果团队里有人退出，就删掉
                local text = ...
                local leave = ERR_RAID_MEMBER_REMOVED_S:gsub("%%s", "(.+)")
                local name = strmatch(text, leave)
                if name then
                    name = strsplit("-", name)
                    BG.raidBiaoGeVersion[name] = nil
                    BG.raidAuctionVersion[name] = nil
                    BG.raidBiaoGeVIPVersion[name] = nil
                    UpdateAddonFrame(addon)
                    UpdateAddonFrame(auction)
                end
            elseif event == "CHAT_MSG_ADDON" then
                local prefix, msg, distType, senderFullName = ...
                local sender = strsplit("-", senderFullName)
                if prefix == "BiaoGe" and distType == "GUILD" then
                    if strfind(msg, "MyVer") then
                        local _, version = strsplit("-", msg)
                        BG.guildBiaoGeVersion[sender] = version
                        UpdateGuildFrame(guild)
                    end
                elseif prefix == "BiaoGe" and distType == "RAID" then -- 插件版本
                    if msg == "VersionCheck" then
                        C_ChatInfo.SendAddonMessage("BiaoGe", "MyVer-" .. BG.ver, "RAID")
                    elseif strfind(msg, "MyVer") then
                        local _, version = strsplit("-", msg)
                        BG.raidBiaoGeVersion[sender] = version
                        UpdateAddonFrame(addon)
                    end
                elseif prefix == "BiaoGeAuction" and distType == "RAID" then -- 拍卖版本
                    local arg1, version = strsplit(",", msg)
                    if arg1 == "MyVer" then
                        BG.raidAuctionVersion[sender] = version
                        UpdateAddonFrame(auction)
                        if sendDone[sender] then
                            sendDone[sender] = nil
                            if not notShowSendingText[sender] and sendingCount[sender] <= 2 then
                                BG.SendSystemMessage(format(BG.STC_g1(L["%s已成功导入拍卖WA。"]), SetClassCFF(sender)))
                            end
                            UpdateOnEnter(BG.ButtonRaidAuction)
                            UpdateOnEnter(BG.StartAucitonFrame)
                        end
                    end
                elseif prefix == "BiaoGeVIP" and distType == "RAID" then -- VIP版本
                    if strfind(msg, "MyVer") then
                        local _, version = strsplit("-", msg)
                        BG.raidBiaoGeVIPVersion[sender] = version
                    end
                end
            elseif event == "PLAYER_ENTERING_WORLD" then
                local isLogin, isReload = ...
                if not (isLogin or isReload) then return end
                C_Timer.After(3, function()
                    if IsInRaid(1) then
                        C_ChatInfo.SendAddonMessage("BiaoGe", "VersionCheck", "RAID")
                        C_ChatInfo.SendAddonMessage("BiaoGeAuction", "VersionCheck", "RAID")
                    end
                end)
            end
        end)
    end
    ------------------给拍卖WA设置关注和心愿------------------
    function BG.HookCreateAuction(f)
        -- 关注
        if not f.itemFrame2.guanzhu then
            local t = f.itemFrame2:CreateFontString()
            t:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
            t:SetPoint("LEFT", f.itemFrame2.itemTypeText, "RIGHT", 2, 0)
            t:SetText(L["<关注>"])
            t:SetTextColor(RGB(BG.b1))
            f.itemFrame2.guanzhu = t
        end
        f.itemFrame2.guanzhu:Hide()
        for _, FB in ipairs(BG.GetAllFB()) do
            for b = 1, Maxb[FB] do
                for i = 1, BG.Maxi do
                    local zb = BG.Frame[FB]["boss" .. b]["zhuangbei" .. i]
                    if zb and f.itemID == GetItemID(zb:GetText()) and BiaoGe[FB]["boss" .. b]["guanzhu" .. i] then
                        f.itemFrame2.guanzhu:Show()
                        BG.After(0.5, function()
                            f.autoFrame:Show()
                        end)
                        break
                    end
                end
                if f.itemFrame2.guanzhu:IsVisible() then break end
            end
            if f.itemFrame2.guanzhu:IsVisible() then break end
        end
        -- 心愿
        if not f.itemFrame2.hope then
            local t = f.itemFrame2:CreateFontString()
            t:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
            t:SetPoint("LEFT", f.itemFrame2.guanzhu, "RIGHT", 2, 0)
            t:SetText(L["<心愿>"])
            t:SetTextColor(0, 1, 0)
            f.itemFrame2.hope = t
        end
        f.itemFrame2.hope:Hide()
        for _, FB in ipairs(BG.GetAllFB()) do
            for n = 1, HopeMaxn[FB] do
                for b = 1, HopeMaxb[FB] do
                    for i = 1, HopeMaxi do
                        local zb = BG.HopeFrame[FB]["nandu" .. n]["boss" .. b]["zhuangbei" .. i]
                        if zb and f.itemID == GetItemID(zb:GetText()) then
                            local hope = f.itemFrame2.hope
                            hope:ClearAllPoints()
                            if f.itemFrame2.guanzhu:IsVisible() then
                                hope:SetPoint("LEFT", f.itemFrame2.guanzhu, "RIGHT", 2, 0)
                            else
                                hope:SetPoint("LEFT", f.itemFrame2.itemTypeText, "RIGHT", 2, 0)
                            end
                            hope:Show()
                            BG.After(0.5, function()
                                f.autoFrame:Show()
                            end)
                            break
                        end
                    end
                    if f.itemFrame2.hope:IsVisible() then break end
                end
                if f.itemFrame2.hope:IsVisible() then break end
            end
            if f.itemFrame2.hope:IsVisible() then break end
        end
        if f.itemFrame2.guanzhu:IsVisible() or f.itemFrame2.hope:IsVisible() then
            if not f.highlight then
                local function Create()
                    local f1, f2
                    f1 = BG.CreateHighLightAnim(f)
                    f1:SetFrameLevel(120)
                    f.highlight = f1
                    f1:SetScript("OnEnter", function(self)
                        f1.flashGroup:Stop()
                        f2.flashGroup:Stop()
                        f1:Hide()
                        f2:Hide()
                    end)

                    f2 = BG.CreateHighLightAnim(f.autoFrame)
                    f2:SetFrameLevel(120)
                    f2:SetScript("OnEnter", f1:GetScript("OnEnter"))
                end
                Create()
            end
        end
        -- 过滤
        f.filter = nil
        local num = BiaoGe.FilterClassItemDB[RealmId][player].chooseID
        if num then
            local name, link, quality, level, _, _, _, _, EquipLoc, Texture, _, typeID, subclassID, bindType = GetItemInfo(f.itemID)
            if BG.FilterAll(f.itemID, typeID, EquipLoc, subclassID) then
                f.filter = true
                if not (f.player and f.player == UnitName("player")) then
                    f:SetBackdropColor(unpack(BGA.aura_env.backdropColor_filter))
                    f:SetBackdropBorderColor(unpack(BGA.aura_env.backdropBorderColor_filter))
                    f.autoFrame:SetBackdropColor(unpack(BGA.aura_env.backdropColor_filter))
                    f.autoFrame:SetBackdropBorderColor(unpack(BGA.aura_env.backdropBorderColor_filter))

                    f.hide:SetNormalFontObject(_G.BGA.FontDis15)
                    f.cancel:SetNormalFontObject(_G.BGA.FontDis15)
                    f.autoTextButton:SetNormalFontObject(_G.BGA.FontDis15)
                    f.logTextButton:SetNormalFontObject(_G.BGA.FontDis15)
                end
            end
        end

        tinsert(BG.auctionLogFrame.auctioning, f.itemID)
        BG.UpdateAuctioning()
    end

    ------------------拍卖WA字符串------------------
    local wa
    -- WA字符串
    wa = [[
!WA:2!S33AZXXXrcA77dxe4(YE(IWF4U7dtmxiRzmhmAaabTKosglEtybqWfyO5TNcgJgGPhGE5GPND6EijKm3GIYu8HenPEqjkjkljkjlAzlszABk(ukI9xad9tWlMbaFsrC)cUmRQ6URQ6Q6hdaLFSlcsGz6oRSQkRSYkRmZkRV74F)L)(v((vo9)7MwTCQzw3O5m7V4utU3XUI5cw1NZQvZfm(UZUGvnRM)K)tWpn2wft7g1kVsrJJ6uQQvZLl7uQrjhZLnkvzL6Lx2CHsol10WEjRAvw5kl0Y2XAze2V3xBVu5kwh5FCMQvTnC(F(DUr56lSKvZ9zzw3z(rgBVfhB2VEblOuwhP(ChXSHXZ0iL(6I(TVBJ)o)Ay)nQu2Xy(wK)8V6IQXQSOXsdJDMN5eonnxCrJM279h2K9XF1WoR0Wy4w1nD(tTSnkvU2rkVITtZwgpZFYU18gh2OUZCTQw18O3O0idnxXsZvCOzlol55xzeR6vmDmTQB)G)BZJTtJMNWUHrTAtwXUNtGOdX7ZmlqvmS7XdF7RPbGVzNBFJn1uxPc0GRwTi0iAUNXMAFJV)PE1w1znUEUb0))NAvFbhZdB0F56R04)AzYNlsF)0wvm(TFNg)pusLOFywKyvPXpupHSMXILxyLsvRzz1CP)FhYWOXqqFybNzld9SLE1Y1nxg)u9DmRTt5MoJ)VAu22yoNMg1x0zP)Zp47pCDR6gFDLwnjqvcjNnTnaYDf7tGGIDThKB4LlBwF8hSnOapi3d69b5FWJ9GCZx1SUP9sYp(Rl3YbymMPbH02ZWvmSx4OFV)4Q3)YRF8t(n37Tx)Lo3A)6BV6TFPnU8L7PNoF2hDGH6CPR3(DUs7x5sR9BU(3CVxETx)QRENFrNFXh351Vj88nU4x1(8Vs7tDN1E7FENx6CTp3B05MNUZZJq25gFq7RDM1)WtcVIIHox6lx7JUZQ36CRENxKc8(N8F74Ny9R)fum15SND9R)XhyiaJRD33IwgkkaOA)RorNF5Lzp8lUXA3980xb4AyZYwty058V6Q39Mqf3(8xF17(Xq1aTvkmeSc4a6sVZFOZB85RFTpV99Vi0F75W9NFq4V0wZgN6v24kV7638KR)vNQVvV1P68M3CvGM8vVZ6FWlV29(1TFX3cWXqtvCBRDIB3(u3TZzVu7Z)(aqqDcW1(63U9jV6gVWvPiBTp9nBF(pKcdwnBhQMbAFUxO3bHFHKKZ((RE3VO9Tpz778R6863E1BDN(kuaW0aqf37GWV0btbeBd41O78bV4Q3)1AF(F)Q36SR)jVkuQnE7lS(BE(oV8z24vVgTuSwk5jyP7hl9lFgk6PDakrBnG8adTN9SWik8Q1V2xU29VgGG2x40BC8ta4gH)9VhIJ(aCqhtw9(Vp2wjLO9h9PRE)FbdLKNaTp3X97S2DUY6N5gyPHE6BVXPox7NhjVTp5h3(SxDTx)UFZ9EhOzT2D)5y996xdqdTzbmeBC8NVZPFJ1)Kt0(6VhmI2(Jo1n4M499gUQvDNg)DJ308zt9p0QCfykt5ufl2CfQiX983)m)F)0J)D(oFVRaskM1yrK7))(p4bF)Vg(68Lx4qlcIORxz(LmmxCjNN)pbZsSWPMlCaZkoln8qWxhUMv5k3SPzDe0g)G5THpvZy4MLnR8QO4O6G8NMlnVt5AGyOFWSl3QMJzpZUqTY22)GhmApxPIjiPBb4PR8dFWFpurnTmxaE(nWYYq6Z81M1bbb1xWGmvVNxfrEPMw1m6zyuUbIhsDvdQRAlnST5ZAGpRjk5c6q74b)OFWjQyvYg7ll9G(6zyqgGZp8vHhrLK)mZt)7X)U)x(MAwluUwQYGSLu7I8Nsg1pCkRMPEUJ1d(18q3bEtACcs6E6PkruPvDcO5NWW5NA0CVTwodippBpPGFAA40Qz9uow1BT88gnXxaDR8avCHLWVKdqvMhPY2EK8WVYMoBwSUk0Jr9k90Jz1u1TCsvAI8dpXqPCwYOobLSVVlSj5)98J3eL5tFSrnBdY7aui1YC7eztTZDj)ogMiV1R687fKVITm8VUONvMHArOdtJYCXgIy51a0tUhZkgzYkGxFuogUYLs8qEZtU)6nbowBhJMdvRg5r2AXfJ4iGmCb)mcV3V04)9Pgmwb8JUp1J1G(QEOmhdvPIv9rwQC96g1qUeQeyw3oDpJucENZK1RALFw3MowIPnSTlVObDv6mbWu2E6HYwofGtyw7YgoW045RzK55owUupNp1bMXuX4OaqUSLziGLl1HmwjRhycSLu(XmcaGD(JLLW)LbyoMcRByyk1UGE0ZUuXdKMJ7yQNo9q1CCL8FMZT(lC)1E93RZfpD6dIea8DBC3FzNx7ScVZTOTp)N25YNHTk3PFJ1oZVU9R98Tp9lUXjphSWl8QoV7lSXBDH2NNS8jrUofVScE5lTXf)c1f83Ew(cU(V)d9Q0oV)T7CURjiD(SxTdih91VD7ZFP2x5x2(uNNU2cTUq4FT32d(2VWTB)sxSZjFja(1V2zb47CR3HbVBvGDhyDeQq6V63SXXFV1)8xOZf)d0LjOOfB5sW8PFfadGFegps0LV66F5Rblfqwq7RG1U7C33EDy1NB)Eqz1HCSu37wIL6lx)EFQqPuvD7E3PGEAQDUtkE8)Qx750F8Q35ozA)YFv7lCUSSAt8zEuHlF8n(nxculQnSq8zoNqNN8QoVX9w7I3eELuJWRG4q7NDg4dR)h)cyueWGuXPaaFGcaGhoERGmnk4gqfXU7Rqby9p8Dx7MpV3R(zluT64JpkOBbFhawH(N1KcVpa8DdkabrIxFqjg86a6kotTbspNQvAqKqzpLGjiQ2zk6qvNR(bTV35tT7GisbeE0vs7Grrj1N)mRp7dBFRBrldBUd)t8WahQz4H)jUG9CnD67y0XV2374T)KxI8GupIDkEkj8vMcFV5nHPDKNydarrSloGr8nEJxkioO0Bkoay68wNaMw6JdVogv117(ADE33J1XiWV2F8c4tePWGQOf68hFEaIaJrYVIRR(Jpg9fKpY3(d8c(ARqbePDo9fw9oFuqol(3QKZIcWQ3(ZBFTBQSSRFJVW7vCn2DWgxau3(SVh5bin9rei87Gr4vcKiLLoZKNYYEIibIdwvKjUcgGyrfAI6MRrIjv(OpaQeosfRhcsOY0dhj0Lkry(OZ1(03Kx0s7BFtC5NZ((mSrw4e3(5hDQ1)W7ZlJz1B9Ryq61bj7LH1xo7Lw7noR)8TF3fHjqSzA)UlcteKi)0riEYp7jEGr4azaq)SN8tYEHA)vVWAx4f5jfRF1pZ75YlPbZMVW1x)uFkSUlV0eCg6fFp85V0fLKSqhvdwe)NhOibbwjy7E3Omky5soW9x9Z)DUfKFPqUo9gV(Z3(AV9Q36ZyTlU(9g)I3G9k99M2x4xqvqA1Vc3BkSFAD9V2F5lldPhAPMc40)gyXy2Qfx)1HLVXLkj78KvJ3cv(HcaApIRF(o)2pGUNxCpXx(4WovP6Z4Tzv02eWgtjRjdLfgZHEeQoehfWVnZAgFmTzGebVMXBDcwZa6o3(3qBgejt(nd4RRDcfnd45qZOZLFb6k)yZ4QFgFZGsTfiib4kvYpc1v7p)88gvaOdUIw8Ejs75EPBH)M7D6hX(BU3zOq79npCFJpa0g1BaHHZB8QEpuGlNzDb0km8lWU(vV0gV8pNBkNpasV6F74pp954hexVLFL2a14xcDkqqJyL(zW4a(qvKtFG5OO8aV6TofRfEHFRczFN7IRERpLxWKNWU2VX1AF8xssoLV1LqiiMtIVW4R9rG7R5rGunZlTuQM78k3Hx4PIAMVWkQzxeq2dVObcMDIHZSKXrZLAOAnwQmDhx0T210OcU5oQ1bSBnpfS(YLQFEOwSPHrDfWnqUuBNhU5R1YqbydMl1oY6V7DAD6zAc4RqnUJSPESu9p4GeiCRppyipqgkwT5be(DzyC3poPJRY4cPivpd)umqGLULCx7zec8c7DxIUpNHZiOjNgz8XZGMgpxkQTZZLcTOuw3gh(fsBZToqy9SMaL0wkxkI1RCldfrsMPGbdqu2FDtAvNHcy2G9hLqJ1SOXmOvpXTiKMfW8L2TrqlVqBGdCIvdQzSGtMTNl1eUKc8nzifmR)w)fq)pBH0PYNNHd4dKNd)nTRYGCJgEfmh9JAh2OWWA6Edx92BkyFcBCQZ3tflYBidBel21h0uMBM9V3rFQjlMFI5kvCYItnwPz2xXjNzVLM5PsbffTG7RFTnEVFFNlEAPs3pu6b3Xtm4tmqkL)Gv85o1A35tKl9eZo2y7fR70unHt7)QzhBuYlO6ZN2N)M82dm5Of3d86b6RG)d3ZytoXEkcpTVcdYJO9n2qfHE00JbVQFE4NC0XgF2HMEm3xoG)7mQSOXCMploe1FEoSHgSTstRgJWgZFUufYX(x(DK6ybbCyRMvmA6dEFeboa49PcAcCLQAwZXGcEEqCI3)hiIkqxbLQQWbo)JRVHnP90gKc4jOfg4EINagFWUF2OAEEfVGsIaAY5zTqd2HwVZ32R(qmTzDZPTQBSsX5rt)5BvoKd7ZppAdJR)X01oPkJXR3LNEom1E4EOhEEUudqBBqdlh3tHDRdpRqGNpyb6lO)kqzWNpOYxoyb3ssbrrrPVq1RRBwlNl6X)4(2J5pp)ZEZvV)R5opxumv6jSQvPVhpns0iML1QUd9rcw627PqrgPPrzhd8rzs7(sFXwzvxUNewqa9pcviioEN)X7h(DiGtQH5ko0EhDOzhTuXX()uS04ZS3IqV8XbXzmpyNMB1vPE2OM2sDmYtKRqYdtE3IumXEL)eh9qNKoLI(ZGb6pdQQQgS76pdMO(ZGH3FgmwdstGQti1TyplaNb9XDbhiTGIDoMuNWaEZ23oYsMogs9n2ZKR1dqFCY7BScgy6f(VWaoU9nfQ2noj0c2lvZtqbupL5qxN5Psk(crn7ATSNMv4N3LVVq8qcLawZvJB4dcva(IDMAqTOLw8dbfgE6tIkH3lO)vV9XJ8JW9wGi17G(6I620peXXlfuQZ8rWHc3nBfuLRQWiVjQ0bS9GumbUI6hk05ouwvqu22ba5qKMynuzB4xIaI0ccuOYsPfBOU)CipC0hbdP61LJWZRt8TC3FMh4)oKiymQR8N5PiPZt4rpuqQJ6ThmP9SW67tzuguhqqpDgBKkD8zpJQZ(EbLAZKM(O0b8bPlO7YxxcADPCmfJeOWBStp1dHgzgTTsIlPLF90tLTRA90iMAwb1PyETL4pwfABLvunmgPBxOQgCQFnf3tGUZK2twhRLm9j1o5MtaBfcKBmbgJbtBGZ1SZKv90e6MwAwU(HYLc4HjHLaYgFyJASnV1p7V5s9SGsG5szvhJSTCIZtShfA7aESqFYAcJJ4MLwE(YoZcpbAtqdsIYygyMw9aox39h222GjZ2nQzccS7fu91FFKb7vLf0tvbQiDBLaGKcaacfrjaUujSb5sWuciHicqrjMkbHsGbyyuA9a5cJAqWrgacYaKsaOdAaiQg9ehfbGydNQPp0buYiTgSq4yjmbQ7p8mg(FjaShlWti(8pVzDBJMoQMpLlv5GCeaNfDmf2uPA2lntcbwKaGYlxMRci95WXnDACCWPU1b8(axWwmhaaFGwemelaTmMELFkixKS8roYFCd5d4DZo0KJkjYKihjxkOxvpLzJYMGWdXyjHxscteDvq49y1RKQm(Fpz5zdstQMFbmENQ9KZTK1rYKv6DyyyHQxnClhqlHNCKAgLXqGHewR2rbnOTfbWmPloZ(abeBh0WQ3(5c(d5LH9AlCbRZdP2sbPMcJuRzPeqAjlYAaT2gVP1Ye59cRjkVkG7QuUyMGhO7jGkuxq3vXsktKaIslY5msPIMlB0m)qvHjIOAqErPJizsxJQAz3HgOLOuxyCeQ0m1hPM5chkJTrTQ8QAwLAgWQ5TosDJMUujKLCULlxR2bmRxX6iQSHOxDadxdBUibq7mvfB0WMkiyZ0gJkqLeBF2aXQKVN5dZsqFXDFez48VPy1kV6yOZQIAMLsnqdJ9pyptMbx103Awlgfil0QztJ6oe7jrJuoLG5y1iCqKK7OHIS8keSmwfthLKLa9syFBltQZ(vbViW4yiATYm(ghnhVnrZQd3rjlXhqbXitn24fHjEvH5E(Ft0UPBdv(RxglgmlBpKWBf4y6n1aXPwgEMIfNz6zXwVFn5(1EfQlClDdQfN5XZiqY6SCfrz32hsbcqbpJlexCk1j1GxEcehLKqEv(My2igoOjAZ0QEd4PzuwM8u7rec2HpHBacN5LaInFPIGE73yezi6xCrn5Qy(fJFZbGfAe6HC(YnJcziiDzhrfpKi6cJNr8DI4IxcdzVBdvZ5PmwzuyLkLAhLevVC)jSfVe0LuEraDf0t7e(ceCft)v6cuTD)cME6NOF9sx3JhMSzYYvbIe7UsXpLWiUsN6QiWkDkbtCLoLGWVkMsa4w1sX7JXQw9pWwZIvjtm)w0kdYllj89VfxAawKvUPOdYTLQBAKQw6Gzc6WxeCRCfIiKQYT2qHTYLg2Qg1fWM4WTS(nHIX)6zbPy2T(wALQqw0iQ1Q0uu(9s7TjtQXyHXMzQpwDhI9pjVCF1kVYCy0tKHlmmcBhNKshZDC6AXDYKCsrePBtGZMSSQ5y2ahjNblBguj7H27i7zMzlfqJwbQquLoiVJlfHVKeE2PmRBy7BpHq3PmFHhQsfSO8lc7k(b(hU0D2OkNM4KJkcJ6Q6yIPqcCoDytl9KdTU7gFt2XeqZMUJff2unsZT)vcRQPnJB2vllfm9JqulsHHwIqIqsnMeTECp9y(wM0dH(tUa1Xiqn5OI2CkKzZHyznVo4FZpVwfZf22r9qiAsNvjhUoEsnNeoDmK6KA0nNkoScgK)xQRgg)UIb9P4vwxXyV6Ph)7gUIaHNTsgd3U9)lYMFSv45EDcuLJt8Ccr(MO0zUky3P6BWORG05j)Kwhs5DmQlM7nvFBpN33K0trvLyYC3ong0Hptl6tBEW8lJ7mJ8is0AKriU5ZXbiZV2eQQ6LduUTBoN6(xUny9R(eJzJtzu(WgHnB03g68vaBJUkQGFIzz4F1Zq6POViQ0kxQscHdn5BKO6yBPv6SFkvABKcZZC6xWELki8sAH6LuiG9TqqTMfWEV(yNRgOnBSkW3ML4rn6J(xaUGirjl0CvQdnd0cX1nua3ebTUusoAivWiRP6hrpKhWoO)8gnI1nzBA4WCBAiqeMQY7Ih(P77GisP13oPFp4wsqY(UGx2)b7rFK2iZ0YikrX5q)MkQeWqsuEoGYemZ2WtFexaoaHI3KrcR5qN1QGY7wh9ku2TeITqJrhn3JRhbyGdQ2pmmsmcq0ELIbCqhNPYT46J6j)vLDNZ7tnXrGrmikbKfMNU)j3xzSNk84UjcGW9GNmnlvTZlzBL2TQAGWTP02qebBbkCayEsGen8ktoAgQuE4BtoA2W26czJhJyv3PPvnnB(apcmTAAB1mt6jrAF1Yly8y0N8ytwNK)LKIWb9k85nooPQ3cnMHNiGy)HNip2GlnuTA7bgHQHJsbNiOckkvOMz9dP1omyXmC2JPTJvt2CDLOweMGK3ymRHY(kVCSI1CJyvAL0q)x7pCv3Sw2WPReJWejDnauzcJCIqhj9ugOmXMk6hydO66UPYlAXzgXZN7MkBaJc1c9iyLV5wOPzdNmPNPo1swP5IPc68sJALByBur0eAiMCa1wyVur8(10atEySybXDzjMQGPFK8dunTFJgwvXjRQiNfdVoFe9yEfqbOLYLA5YKe3cPRbIyH1FMU8r)PLR1Yq2MP0IqY8mP(ry5uBcuszZC4aUCYVjTt84iPEXiIux2PWb1TcxYltvM2UKN49LDPk6sZQpoV8h9Ck70YE4YIU3Lp56iFGGYgmU1uU6yyvtFUNjQc53r2yf5AvZ7rYWa4j4zhjGzO1ukTr5E)fceb)H2)(B6rN(2AhD8p6bD7OJIZxH(qJrzJjJVSJkGKdpyqxC1xwIH9StNvhM4fJeAWpjmZUqCI2hf(bnSUr6c2rqaKBf9wi)G6Ai6fI7TKN2ERQwP2odwrAFjnYOu4s9OCbUY2K)svc(B2)y0mh9mMeevoHYdoGEjeEf23fAXYHx4rgS3bJrFIiTrLSL)f8iiRxuIJq47jKOrYgEbuCMOumYWTZlxVV6wBHKACiM5HUdC1bMD1ieEQVdlgQc6BtI5BhYbQgENFmhZo6XuJtXLqUu3G1kJTRBovPrtf)zmjosIvY8OrXv5FaLjTbCsAPtzHI8KFcnfmgZY)0UQ1FqYmr0yD9VL0pcECHIGFaD0d61hx)84BpXitJseZmAIh5exgYCESUb9Ytu9kTSjIttzj6NynbvRUpXBcQQmLvuZo1WpNwdH4BNHXGPUl3HUUzCsXZc8aXqjxrgdqBWLhiqZPl6swJqoud8c1CvTpDXGo)OEPzQpTvlBdI9iKSDTNnM8x)3d20zZOjJHg7QC)nIJXLQQObS)gjS6zkub1mzQXsLRVOrL4u7AmpSwZFswAIKsS1yu9D6o5jiZmbPrp7TAEQhhq(9PP9RNCutBsYgvrWl6RiqCxNurfKVIPDvvbsEyWN3b6iavlQSfz8JDgLuOG7EqffAS6kiqA7Ps6sY7ql)rYDPEOmEJpDXyt3ZFOD4ljdDIzi0n1GKe9uH3he79XONhpQECPnrrx8xBrBIjlNQULclwhdYvS4NJdVmNL4Jhpm6ejjYOOtD5HtOjfzqSfQuAIu(dSKHrnMrcRyuZrizCX8Fj6(s3UebgCdbsox0d0TLoqQNwRxq1UIqsClMG4Fg0e3GY(SoYVu(8wL3(4zBYi6Kt5GJH63ViO4Yo7rRJuOKcF3Pq3YQG)usCGBemlriri9cKJqd(JqtGOXjaF6MinluhnukAhnO3V)jj4UcLJmVbAij9ERTuoxxol5TCk6YrRmoNMhvm9KuEcVZahvZjx7LYFwCJyXsee)wPBareN5Areir(zDrxJaq)X3uac8TIeqwfMdBmmM4OcMtMZnYLAXCPMNgUmirKxssW(zqHhELNzHgLUrsxK1Xqo2HtPPFscPJCU1tmJh0KKv37IWnn0u)7d7ao1FoBSpAVD5C2)CozXVLPEPhrgE1k7ew5vjXj7dJGI3F4s1UFL9Mj77LQGPvUcSe6N7kWpe8WjBiMud4OkQxvfD2)iK2HsJ0lPyHgxe4KA37I2JvwPKwp(2Eb6rFkBtHnoRGdxXyEadHOFHX4A6dPXDbtqefHuzsl1tz7eFO(dQtV2HAnwHq0rrQKv0nH0oxlsvaTx1po25sehUt7LSKMylKSU)4wl0I3D5He67c2vtHyp6v3c3hZBrVDWu8O8K6iiZml5brsVynHIzTCM(ke8e6dVFNkJArHUW4MW(FgEINonPxuApTSNhq5iwlBmd9WbOQnDqmXMugZ8lH44UiIvdGRLgDhG0g2qHI0pvOhpMQ5B5BMXG7h27yOQdmHlDi3fp2vk)49lowBw3f5HsDqO2G2nGu8YJw0p4wL(EjXv9w(enmprsBswWLLJp2Feszyrz8MW9WtOxDiDJNNQYFelfcnan5K1SAkRIt2FOjN1Skzy2mTg1yzt1UCpe27fzLQHEZDM5)NWeVCWu6iFXCtjjjUGbZNojebs5IKewEhwsMI6HTCPEUucZmZ5N)5cJpdyYCzgBMo1X0H((3sXVGMJKLmx2QcrB1Y1TQVYYWc4PvLxM2mt2uC7jjP2wSPN8z1)JfAYBAZ0GdXrWXVPkkN8yQd6WemuRfF8rfvWrUKiPqz8m11sVuJTUtgwsW1wqBmoYZijFxnzoIUPOjtMMsuKiPAsyi4uOem(SfXYSLWRSLZK0vChbwZytTI3wYQEBfR8Xl7s0z84bRleFVZI(zhlUDcjDo9vytc1UywqPsXZFOxELHAXgQS0DVlgXBAvoLHqvnDQziVsHQB4PSrvqpVnXNy1zPzcsldas2tOuu5pI4LkBuCFrPPuk8CLxhgPs5NYOQdnhS0yPYz6tpGKJrsSGCAZkvQzObu2WGCoUtftSh9o0oQyzixeVzc8MjOHsOBWgIFNczwTDJiDtyaODTNG0XivI6yApL1chICtZitciYpu6yVawJZBe2DUsOMQZlNgZhfTODl8V0B5V6neMiO44jixGSHVBzER2eBFS8TQlXi4f92Sx0wN8JlUoAFsZlQccX4SgEan4u6trfIavCEw49KCKvHSDa5lCCQHntfec(fwVkS6qEPnHiCIuM0zZibui1R8S5W7B4eveqUoNaccPIqPbrIFH8ndTmX(mh5XXsze7A(vByoXiLR7qSil9YUM3pjAncMNMpCLut6)uaM8((kqpA6AxfiyvDhxbt6CEGSNcjwYp)JhEWtMuNiiuonrEVMucD2WZj0v1NnQW8tTI47Wtn(ajOknHiyiPDt1BTqhIPSFpTjEC1pOx477J4EhmHC(cX4PVxO6Rh)mE3MXBt9QZBteEeDhhfF1MCItY4LozTuYsOwEdVy8rIwBpuU1skNHRkjfhRiWxh6uEEtssqbNOPuoGEqwhw66UphLCOiOl1nRt394)CeRmDyqFPzAoN5ZQ(eU0vjdnQ0oQlumJfDjez9X1rELRBUCMgKJ7oTG0pNheS7ysg9C9tl7fobEeDWbV38hiBGhh1SmPPcYIM7nLtpQfg7DUV8ltHaejFXXyZRpqspd4hJ(bwVmBu1XMYzXrneaRXdQlq8N3eaBMqavtaaVXziVMrx6HBfd2bCM6XsVlEmH7B3tD)ox8ZDVeYKpBY09sPWPRbs6wCwubxjVEgxxRhaIjT)PM2MKT6eoUaDGivRrGtLwejYlFhKfO7On20JB0ig7yuxAlGcoPt)M6eBqHU)Ii6PckFMG(P6OoZFuj0nGf5MW4Nb5THynUlEzU8AIpjoWIQsjtgLti1f(zAU3Q1MUJ06EuL7Fm0LftwtkC8ljxtB2ulox22Hfsyb6iFBnqjAjiT5AXeqB9I2qDdPHwjjzenbT94oq(N)R38q5s0e8Js7WtFwvjejBriWuLKnuKS36IX1oPmRlO6yQiAmafj2Ua1H6ZnuKve7CBO8KoPOHeYzEkq1zrj6f9o)jcIDI9XikM9u192iUGn869C9WqcK)UO7P5O201dFsDi5ZsGM1P9sSDQuXk0vQLZA(YjXA1gCFt5JJUXphr4RJU3FhjYRgjZZgj07gDRJmEi4mJK7qJe5uJe5ydDo3qtaA4XWQ4sDql)AxZPwqtAW3Jpv7noMc(0aAwfbFQ6G0mAgA53wgFAIyY7cmiZ4hBuOEYWU3DNp7dBF5RYtUcMuh(2EAHg2bTtliC6XEErao6O8(n3uNGl)WVmzOBrCZTxzTja5)cypKQ0mwNkaA37KgLtJGSOzeZl6FJ4ESrBsKrFiUQcnsde1noIO5fctXrxGt5PpLEXYCWgYHqjqKC7wQDlOahFmySt9HGHY2PhSj7YVKVXSZDfEDUfhd)6JJF3wuWq5pc)xqtFsmRoNHlv3ttYlEHLUBg2ZnAbXxujhYGsInNU1HF(9fYTFS7xs6PQLZVl07tyAYD5FUv5AMoR4DDcxI2TkUsdd6NMR180VWEZy)ZTmBaYyZLcNM3Qj9nK79wKwy3AEVppVz9kfPhq5jOPvu6TkmxkVKnbgBlbYQe4lCjEQ4B4J7Pcre4tEsTt6Gj5uanO0qQsJiKnKlgCHrc6GaRjqg19hG6T3uRER7U2fF5nE3RqEah3GV0Fwc9I4rT0K)qnYDyUf0nK7kASm0xCmsRjY4Ze8ozE(fXt)bgNZC5Uvyslb1(FcXaEvlxVs6GxQW4LzZwdwixII7s6UfYdYJ1DhwGTGZjGmkI31ojMm9feaOZ2gQUUAtG3Dd4zxXA13fV6DVlfRuDXihXmfXELNOkFjv8HJgzog6lnYh4pjaMKB0B8p8NWkmO4XPC9i7mojA22s1N4Xka9ldxc7Ify3IpKFgiUAxGWbx2DLYdWbYCpsUst3nF(YUtlHAvZe2aLC5K5Ttmbqay2)uK59T8nqEc9oHwcq3wgs64Aet4YB1xwf3b4QCmkxhiAF0jionuQojHn9TeDh0RJs4vtWLCmy4x14EWPFxPrsjZ76o4etSL94RPQRPFT1N0d2gP8AloMGqelagqg57p84GiMDuzp8xQB8WFa77YD3VPpIW09JMKXDu)iDneQkO58aiAmQlZcQ0u2bCrC87S8iqOvJBTJ0O9E)MVrh271e3krksrku2cv5QQrOgLIWItvSEPcoYhMcvbpt)fkecS6x(v6GaSJq1hoaEdMwWusT4oHSBosLWrT9HM2NhlgvP0D0z(ThszupCkbe3yzFdwqdGud4b9kwC7eeahlNY1ksf8LF7AQUaNHbP2I0eYixOKgLn6K2g)8cr4ROWxl(FoI1ryP1EgzJfRq4x6LdhSGiYN29J4GmSLOOOANUbWKB1uiuHoU0dQjAvyswnIkdYwfJYZIGdumlf(SHemuBfbaBCcc2O6Cru04l12fsPiPQB2JmVE)HlMssFHO2N8w1EL362VC82ZSKKY)c5yh6Th6(WlOGFS8TFDiReQnisDdoHDf06lQ2uOppTW2dvSvK4jCnIyax12jc5cfsze5Q8MhwMHNpuU7xBkuo8m7DGkJHpL1LxwFpKAlSOPFZSLB5b1eNZDtCRkEBjngTROsgXH2Y0ZvlD(o4zYJNqtjmeUm0yx9QVhUvLgytk6KUhU7EugUiNePaE8RufYXcFWEltl9KQP(wX6FhlMvVSw7der50FfWhtT3Ju37qCuijb7e21WHKIgoD7ncJJkRe37JRaiX8nSQWhkHrOuGfo9cbe0v8XHkHjnnz2v0N(dBDuEg2jR3Of(SO1xZnlTr0IOkxikaBzaVst6xQh7cVGyd6AK9)Jvdk61zQT7ueBcUaT3wGybZfuiYaHiADsm8c4dCRGdeoz3nW3ledWgJsXr8RMW5TEex87NoNUi7pBeiHyjR910W2welIrJxSWcFX5d6(OkmjH26wy2xJScfpki(Lw6fHisooBlXq4aQkRKL7Qx9HmJ60uUFqYq)dgdfHfyh8I(QaA5YKErFdt(fZRVsi0bJDl9szzV2TSPn9wBOzzZkvjRnayVYklSKXchQxYhtRPgKcdWqeOmFaXjuonEPj4flADJA0xeTiL5vkGaKLir1NxRGhCZm93VkOJFaycWRo(yN3Pl2HdTVdfzEhv9bV5bKzNXDERc(imEDJVoM(TmretJ6x9SAQcQB3NJHmSQadJ8UijCU1CiIIeJERSruCxHrYzv7SXz8kpJCI)rBqF0BVP68ANB17Fzz7KGV4SxQ95F)eoLHVX43mPCkjkf2qlI3HLtDPoWsMogblfJ3VsSYOsZR52jRxbJHGhZzC)PYLZ7MjIqS4NhYndFENqchsqK9JlxkoDmPLLE5gtlh3lj3qFc9LW5sdDgll5finxD(WwDLpFhOViHVMQa7lgBLIcA45iPr0l9sP6F3XxY2WRix52sTJcHXwYtX2syoN1yrtmFToUvtcJIDM0dvFf0ajBnmHJqY8wjKn0RqXKruV8u5DCdOvKD03UBtpLk)GoVtGtCISzYM3jw7muLHS)BF(9OoCg)5KXn4oy9c3DrMKivmI)8BNnr8ws7EF7dko7xfZMQD83Fmy(U2N3((x8)qmlvmBOl(tjvBfSPjGbuidjfo)NGWYP4lxcx8wUSClLZ7)Tp8KT)Ot15sF5AF0DE46)n1zOMQ8AmjKWBunQgq)dS07XGEf0JgcsD1jzZ4GvPA9iXiNCqjmYPqx1Ou2tiCbcLzjXrtzi8miccWPunegfAbK00RB9qZwI3zemjE37vgqg9K2ZTKzvNNYyfYvNriEDJfJ6qtEeA6FhkZWwLBwHfnFH7Vo0w4etxne0GomW4JpiJ3thzjllBJHTokSIgEMhYKnz3fUEiAssWSofWlKHCPGQ8UzL0VhbeI10Qwm65JIgXB)nWq6pce)W2VxkopkAu3Zl65emZftGv)H7NKOqjw8Q9ZV86g39vw)m3y9x4L78wxVN4ypnsfLE4Hg5PMy2z2)E5pFkHyCn2RiwY3ftfCp4vfYpyun88ZJ32Xawe2h278LDE)tP9EBIDwo(hONCeQteyhJKahvnAFT7Jtmw)leNoTLFWc6xD4Jj1s4dSbVRkQ(ccVkpAQnfTjvOa(TuErq3LXGvDe(UigZZy4qKhBEo3cQnQ34EVl6y)vlqJybeTmfYt840tG)I(jPcqsW6K4n3LN7yrXfBUaxC8lXntvxzTp7mRDNprLF5c9(XpcpX1VspXP0gXyZs6qw0Nuri6BsohwkEHaRwKtRjyjGZ3OuJ1U7RWVNe)tPfW7RlTafnLkguR(sGFlPKlP9Ye0TKKEtGlYGyCkJ1joKrmc1VLEmvTVW5w7t(8K6S3UY7UQ3gdJPItD0(fPyoChHBr)quvspyEFDZXnclS)KlA3A(mPFKNgqF60zD)6bPFvQu)Kw2oMvxzpzstAIYTeqaWbAwUHS3s1nTg(eE0CvXi3(lUrNlFgEg5HNGE5inrE2kuJac7Du9m3JGiEjYvatvnkEj7u(rbr3ScQG1(vjw9rhA2IhyMzFQhvPBSOb22G5sjNA4fwb4rrA4JcTeaDUFKmkcKWggv82KzHTCVTPzazjqH)kupfYlLv5KJ1(D3T9V8L(ZLexXjiIRKk6cvQLiOte6BabZ1uAINM)iVEqLPdi2XDvJ4tXPtChO2yKBR8lxGgI)fyPEug21nUpQtNwZDIsOZMdzcRsXNcZCp(RU(1(GoV5n78UFGe7HTSYIZ5u2PL9WLBQqvC7yksuuhl7qvWs8jkkj3g2TdBZ8sfZRF4nPmU6QQdr8bafrx)Dib50MWEMo6pTCTwg2K1alWFWsStGPOMVmcNT6bZZ8Rx9(VfmyUXB(hK3XGBYVNDigcFEVa0DZkKbqGuKtGdVEgTzqHr2afnKm3JaLrUlk8Dz7MrJBk1wmdth(hbfNJPe5NOGSzzjgKZ999pO0RxIi8cFJWwq5t1wDTb6uDOM9ASIHqLAR1PwsHCyipamMmqSmGdX(t8x3E8x0PXWyuAl)(BeBBVT1OO321VuMYT6hQaz)BTpuFh)7i30kUhX2kVDcvoTi4Lkyelcj0o8s8DBnncHO9GFfo6OO8n3OG1He9xihKbnKKwqdSwOaKlRmp1IZEfVx0s0ey5QpIjXu5hrnrwgPksk8fY(xhtrcmJqyir11TP6r54FdCkZ7LKPRj6c5mQ54BD3fNknMB3FHygf62e3mMHF2E2IBZB53RNA3EaEW6JXTgzxZre5fgzO24pXvNUPwXlPi0LCHpCyaFyW79WMTlBKzf24WSPzuFNPOSqDU6h0(ENp1UXXC1cgf6tU3EOrSAl)LmQ2DDU(x(ATp5h35dEXKFQduSYxihcbHtDGSNUM1ZEBbUXOfE7aIQwlDYecDrzT78v4sRNQ(upX(8me(zzi6ZXqSosbkVObZ2tYorbkU46ddfeD)pWsgg1c2k8FxKnIGfwYD6j9SiSvCoee10CfTN5dI6MNpHXceIHyea98HkJ)2yfJbEnbPdRge0YuAN7Xi0JSQvjye4gDme94jjIhZBOGQcpUKdn93LU30QITixi0hEob25R)13MIn9QS0(76vQS8B4n0qAZVCjjQnLUO52sIFy)7cpXiIczGp77)ximWQm8HFdNZkuf(Rsw5T9FWkVLYkhKtUBci4eXmhUr68AzHPmHIdcLlGcIT5kDVY2zqkw2vemWDlZQUqJtr)KtDHeeLVHQKrISvZ8YgErz0wemr)O4OmfvedgchUI7n2iJeWygM9SZPuv(XNaptm1AR(cNwN2m6U8Ej3JAbTLT8vSRy4O6M3xfVkF9DT8ESSoKqoKvCpqQGqrBWltdZLjXNTSzLzTWyyNKLCZsFhMTF8ARJ30Azem4L9iKPyz(tio8BOecCld6d8QyM9s9JT15CaAw5mp6EGx(OCVCKALxUHrLIwaVJHrDU9mihxS956AkYlkA1Ge)kYfyARdtoZJspMEtYXLRlz5VsRgizZwXJE604ULz0vsXtFqYLiw(NG5oEnXEOhpBpEEioSKSPINLxjBJgGE6(piuJWWMktZY2pVMIY2oVG5zQQ5KWbuFmQrChd8yozeHXomWUOMNkRamEhcdY3YKEK9muXstp3eLgA0rNzVramgbA7R0SZmxXXMT0(33OdvCSikX(MAO)ra2X2luIj37eLoWmZo1OruMPNz0jhFsOuZveQGsqlCVtmwGcjkNeFKI7I0dtMeLpFEblmBqjwGEss9EDXqsJMgvnpAUulBVyo8WC6qZ222WiGrZXBvR2EP8D5LsY5OvHjffnBCGeLU2uypxMuR5I9Ld)D)KFpa53BN87bj)EhKF)Jrx)600UrntGCKlnPLMvb(OT4CqLwU2YcfQ30Y9Na5UESXqOAcP3DC(JljH8wsIBxTjozDkUmqS3DFg2h1MtyLVBbrsXw4ThQ3nuWK2Jb9gAY4pUP09azRtn3TakTmm5MayxHF)uj)JRpmyx0cEzdD6Ox0zWtPCqFsIxDbdn6ElgeZM(MPzhrtwxZno3tUSUJpVno6XKp)TcZTNAWrWDRFQW21bSx(Xxe(b1bVVBYablABavOa8JvFT6UPUigOnS))L31tRnrquCd5Iu8u1lIxkresGsLKATkuk2wJ0inQSTyliL0SB2nz12SR7UnT2spyWBEtXVa5IGhZPEZd(fqe)K0pboV5n7MjzNzZUnHOG5uYKz3D23mZBE))N0suWafDnIqweXCjlEIkliy(4ufYH0tLUcQjvJEes0aq458ZrRGNz3zLEnbMyNHKACgpx2LDMWwJyCxbHaIiaNbb0NWa1WGFag4qCm5JHh9W0ZtD8YFgMRYqjU4RFK2Wm3XDgEp(t(j2hiMI(Y3PT4s6uuKRGxmkKweAvqwYu0Rilb2LUNlZsuVCg0g47ZLZaI)brZkdDqQS9kkpJiurMlrTXl5itX4yYjXtu)RmP9xzcm2Ni1SwUXg)Fmp2NmhamkcSivafyeZlntKRV4IaeUeLAyPqq8tNaOcEjjDcIi1ccIgqbXIgNcr9Jagr6BB2MdALyqKhYJOSRjTAykL1nAMN(JxXHuJDnG43C4DcNrfuCC6VBC2Dz43tSclmS(fzzzojNhhlUzlEg)egTbKrflVzZfgFOscdJyEQaAnLspU4tuwPCXkBvQCXeDkbNDJqfYnYLCEydr83ldlU(mxLuwCqZOS5GYRXnKMgfwAz5yBLJPfwWUOq)EzPHYF4O2fCjc)RCpahtmmKfK328nHIEpGg(8Fy9ml3Omh3DiBaG2HNc2)FbYvJThXQZeHcBEyOgS96L28ffvgI69JY6Pixm5)4VKRN(VxPQjJqdrUpAez)i8TyCRR4GRjFPUJRjSzqx7njtkUKI1HLFh5zXZsH2PwWOu0zucIzREMJuK9vhBOQNepyi9uOqJoX2YvMntbqETUjzoZ0vrFFRQ1eBFuGNFwwFbgG(9oxKwhDcrcc)OkeVhKmpcfFITeJGlJAJqEi69Fbu5S(Xf4gRTLYgu9W8BrH2Ie2VKl1JTNjFK1yJGkosP4bgtBsRhhUezS5tYkAl3TutxBDnVmj4ekzQ637Xiefneuq77lGhHPi7meohaFhAbJcftTIDfajtQqOHviSM03RTbORK5j63u116qhnDvZdSTC86CORV7xB8l3gvRzD0op3WWv3lD7Jy5zBB)eUvvZQPHz9PuOLr40DC0Rtwab8SwfolVTg5grUbn3RtnD3QEatr9gDzJUsKlwn)8ZV4dUN9TemI1yF5NZ21ON)atBFB5VD2o6AMax00k0WP59xqts1Mv3NXD9ZREIL1bPCEngn)RcbQqhplTw4FF1w)iJzn7RVe67RLrz6NPvH5w4tG)zOk8PIQ1zpnHsTg7fSSvnfGQEbr1Kgwo0Z1aYG6MRbr8U9n8PeWG2p0AAu4qZADpzBN3UE9Cg5VFzIIRWarVrhcPHOke4uXP6Itcu17EAQuPs3XW8yww6(HR11Sjsci9DkNJXzQ1F0XkF7kKpt7QUWC5lm3dNU1V35p)
    ]]
    -- 更新记录
    local updateTbl = {
        L["v2.5：拍卖金额超过1万时会进行缩写。ALT+点击折叠时，会对全部拍卖窗口折叠"],
        L["v2.4：3千-5千的加价幅度改为100，3万-5万的加价幅度改为1000"],
        L["v2.3：拍卖框体右上角的隐藏按钮改为折叠按钮"],
        L["v2.2：按加价时，可以直接把出价设置为合适的价格"],
        L["v2.1：如果你的出价太低时，出价框显示为红色"],
        L["v2.0：重做进入动画；按组合键时可以发送或观察装备"],
        -- L["v1.9：增加一个绿色钩子，用来表示你是否已经拥有该物品"],
        -- L["v1.8：增加出价记录；UI缩小了一点；提高了最小加价幅度"],
        -- L["v1.7：增加自动出价功能"],
        -- L["v1.6：增加显示正在拍卖的装备类型"],
        -- L["v1.5：拍卖价格为100~3000的加价幅度现在为100一次"],
        -- L["v1.4：增加一个开始拍卖时的动画效果"],
        -- L["v1.3：修复有部分玩家不显示拍卖界面的问题；当你是出价最高者时的高亮效果更加显眼"],
        -- L["v1.2：现在物品分配者也可以开始拍卖装备了"],
    }
    do
        local function OnClick(self)
            if self.frame and self.frame:IsVisible() then
                self.frame:Hide()
            else
                local f = CreateFrame("Frame", nil, self, "BackdropTemplate")
                f:SetBackdrop({
                    bgFile = "Interface/ChatFrame/ChatFrameBackground",
                    insets = { left = 3, right = 3, top = 3, bottom = 3 }
                })
                f:SetBackdropColor(0, 0, 0, 1)
                f:SetBackdropBorderColor(1, 1, 1, 0.6)
                f:SetPoint("TOPLEFT", BG.MainFrame, "TOPLEFT", 0, -20)
                f:SetPoint("BOTTOMRIGHT", BG.MainFrame, "BOTTOMRIGHT", 0, 0)
                f:SetFrameLevel(310)
                f:EnableMouse(true)
                self.frame = f
                local edit = CreateFrame("EditBox", nil, f)
                edit:SetWidth(f:GetWidth())
                edit:SetAutoFocus(true)
                edit:EnableMouse(true)
                edit:SetTextInsets(5, 20, 5, 10)
                edit:SetMultiLine(true)
                edit:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
                edit:SetText(wa)
                edit:HighlightText()
                edit:SetCursorPosition(0)
                self.edit = edit
                local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
                scroll:SetWidth(f:GetWidth() - 10)
                scroll:SetHeight(f:GetHeight() - 10)
                scroll:SetPoint("CENTER")
                scroll.ScrollBar.scrollStep = BG.scrollStep
                BG.CreateSrollBarBackdrop(scroll.ScrollBar)
                BG.HookScrollBarShowOrHide(scroll)
                scroll:SetScrollChild(edit)
                edit:SetScript("OnEscapePressed", function()
                    f:Hide()
                end)
            end

            BG.PlaySound(1)
        end
        local function OnEnter(self)
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
            GameTooltip:ClearLines()
            GameTooltip:AddLine(self:GetText(), 1, 1, 1, true)
            GameTooltip:AddDoubleLine(L["拍卖WA版本"], BGA.ver)
            GameTooltip:AddLine(" ", 1, 0, 0, true)
            GameTooltip:AddLine(L["全新的拍卖方式，不再通过传统的聊天栏来拍卖装备，而是使用新的UI来拍卖。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(" ", 1, 0, 0, true)
            GameTooltip:AddLine(L["|cffFFFFFF安装WA：|r此WA是团员端，用于接收团长发出的拍卖消息，没安装的团员显示不了拍卖UI。请团长安装该WA字符串后发给团员安装。如果团员已经安装了BiaoGe插件，可以不用安装该WA。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(" ", 1, 0, 0, true)
            GameTooltip:AddLine(L["|cffFFFFFF拍卖教程：|r团长/物品分配者ALT+点击表格/背包/聊天框的装备来打开拍卖面板，填写起拍价、拍卖时长、拍卖模式即可开始拍卖。可同时拍卖多件装备。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(" ", 1, 0, 0, true)
            GameTooltip:AddLine(L["更新记录："], 1, 1, 1, true)
            for i, text in ipairs(updateTbl) do
                GameTooltip:AddLine(text, 1, 0.82, 0, true)
            end
            GameTooltip:Show()
        end

        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetPoint("LEFT", BG.ButtonMove, "RIGHT", BG.TopLeftButtonJianGe, 0)
        bt:SetNormalFontObject(BG.FontGreen15)
        bt:SetDisabledFontObject(BG.FontDis15)
        bt:SetHighlightFontObject(BG.FontWhite15)
        bt:SetText(L["拍卖WA"])
        bt:SetSize(bt:GetFontString():GetWidth(), 20)
        BG.SetTextHighlightTexture(bt)
        bt:SetScript("OnClick", OnClick)
        bt:SetScript("OnEnter", OnEnter)
        BG.GameTooltip_Hide(bt)
        BG.ButtonAucitonWA = bt
    end

    -- WA链接版本提醒
    local function ChangSendLink(self, event, msg, player, l, cs, t, flag, channelId, ...)
        if not _G.BGA.ver then
            return false, msg, player, l, cs, t, flag, channelId, ...
        end
        msg = msg:gsub("(%[WeakAuras:.+<BiaoGe>拍卖%s-v(%d+%.%d+)%])", function(wa, ver)
            ver = tonumber(ver)
            local myver = tonumber(_G.BGA.ver:match("v(%d+%.%d+)"))
            if ver then
                if myver and myver >= ver then
                    return wa .. "  " .. format(BG.STC_g1(L["（你当前版本是%s，无需下载）"]), _G.BGA.ver)
                else
                    return wa
                end
            end
        end)
        return false, msg, player, l, cs, t, flag, channelId, ...
    end

    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", ChangSendLink)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChangSendLink)

    ------------------正在发送WA------------------
    do
        hooksecurefunc(C_ChatInfo, "SendAddonMessage", function(prefix, msg, channel, player)
            local done, total, displayName, ver = strsplit(" ", msg)
            if not (prefix == "WeakAurasProg" and displayName:find("<BiaoGe>拍卖")) then return end
            if not sending[player] then
                sending[player] = true
                sendingCount[player] = sendingCount[player] or 0
                sendingCount[player] = sendingCount[player] + 1
                if sendingCount[player] > 2 then
                    if not notShowSendingText[player] then
                        notShowSendingText[player] = true
                        BG.SendSystemMessage(format(L["由于%s多次点击WA链接，不再提示他的相关文本了。"], SetClassCFF(player)))
                    end
                else
                    BG.SendSystemMessage(format(L["%s正在接收拍卖WA。"], SetClassCFF(player)))
                end
                UpdateOnEnter(BG.ButtonRaidAuction)
                UpdateOnEnter(BG.StartAucitonFrame)
            end
            if done == total then
                sending[player] = nil
                sendDone[player] = true
                UpdateOnEnter(BG.ButtonRaidAuction)
                UpdateOnEnter(BG.StartAucitonFrame)
            end
        end)
    end
end)
