if BG.IsBlackListPlayer then return end
local AddonName, ns = ...

local pt = print

BG.Init(function()
    local aura = aura_env or {}
    aura.ver = "v2.5"

    function aura.GetVerNum(str)
        return tonumber(string.match(str, "v(%d+%.%d+)")) or 0
    end

    if not _G.BGA then
        _G.BGA = {}
        _G.BGA.Frames = {}
    else
        if aura.GetVerNum(aura.ver) <= aura.GetVerNum(_G.BGA.ver) then
            return
        end

        if _G.BGA.AuctionMainFrame then
            _G.BGA.AuctionMainFrame:Hide()
        end
        if _G.BGA.Event then
            _G.BGA.Event:UnregisterAllEvents()
        end
        if _G.BGA.Frames then
            wipe(_G.BGA.Frames)
        end
    end
    _G.BGA.ver = aura.ver
    _G.BGA.aura_env = aura

    aura.AddonChannel = "BiaoGeAuction"
    C_ChatInfo.RegisterAddonMessagePrefix(aura.AddonChannel)

    local L = setmetatable({}, {
        __index = function(table, key)
            return tostring(key)
        end
    })

    if (GetLocale() == "zhTW") then
        L["Alt+点击才能生效"] = "Alt+點擊才能生效"
        L["只有团长或物品分配者有权限取消拍卖"] = "只有團長或物品分配者有權限取消拍賣"
        L["根据你的出价动态改变增减幅度"] = "根據你的出價動態改變增減幅度"
        L["长按可以快速调整价格"] = "長按可以快速調整價格"
        L["在输入框使用滚轮也可快速调整价格"] = "在輸入框使用滾輪也可快速調整價格"
        L[">> 你 <<"] = ">> 你 <<"
        L["別人(匿名)"] = "別人(匿名)"
        L["需高于当前价格"] = "需高於當前價格"
        L["需高于或等于起拍价"] = "需高於或等於起拍價"
        L["取消拍卖"] = "取消拍賣"
        L["装绑"] = "裝綁"
        L["|cffFFD100当前价格：|r"] = "|cffFFD100當前價格：|r"
        L["|cffFFD100起拍价：|r"] = "|cffFFD100起拍價：|r"
        L["|cffFFD100出价最高者：|r"] = "|cffFFD100出價最高者：|r"
        L["|cffFFD100< 匿名模式 >|r"] = "|cffFFD100< 匿名模式 >|r"
        L["出价"] = "出價"
        L["正常模式"] = "正常模式"
        L["匿名模式"] = "匿名模式"
        L["{rt1}拍卖开始{rt1} %s 起拍价：%s 拍卖时长：%ss %s"] = "{rt1}拍賣開始{rt1} %s 起拍價：%s 拍賣時長：%ss %s"
        L["拍卖结束"] = "拍賣結束"
        L["|cffFF0000流拍：|r"] = "|cffFF0000流拍：|r"
        L["{rt7}流拍{rt7} %s"] = "{rt7}流拍{rt7} %s"
        L["|cff00FF00成交价：|r"] = "|cff00FF00成交價：|r"
        L["|cff00FF00买家：|r"] = "|cff00FF00買家：|r"
        L["{rt6}拍卖成功{rt6} %s %s %s"] = "{rt6}拍賣成功{rt6} %s %s %s"
        L["拍卖取消"] = "拍賣取消"
        L["{rt7}拍卖取消{rt7} %s"] = "{rt7}拍賣取消{rt7} %s"
        L["滚轮：快速调整价格"] = "滾輪：快速調整價格"
        L["长按：快速调整价格"] = "長按：快速調整價格"
        L["点击：复制当前价格并增加"] = "點擊：複製當前價格並增加"
        L["折叠"] = "折疊"
        L["展开"] = "展開"
        L["拍卖成功"] = "拍賣成功"
        L["流拍"] = "流拍"
        L["设置心理价格"] = "設置心理價格"
        L["开启自动出价"] = "開啟自動出價"
        L["取消自动出价"] = "取消自動出價"
        L["自动出价"] = "自動出價"
        L[">>正在自动出价<<"] = ">>正在自動出價<<"
        L["心理价格锁定中"] = "心理價格鎖定中"
        L["取消自动出价后才能修改。"] = "取消自動出價後才能修改。"
        L["如果别人出价比你高时，自动帮你出价，每次加价为最低幅度，出价不会高于你设定的心理价格。"] = "如果別人出價比你高時，自動幫你出價，每次加價為最低幅度，出價不會高於你設定的心理價格。"
        L["心理价格"] = "心理價格"
        L["最小加价幅度为%s"] = "最小加價幅度为%s"
        L["（%s）"] = "（%s）"
        L["没有人出价"] = "沒有人出價"
        L["出价记录"] = "出價記錄"
        L["记录"] = "記錄"
        L["、"] = "、"
        L["匿名"] = "匿名"
        L["出价设为："] = "出價設為："
        L["心理价格："] = "心理價格："
        L["万"] = "萬"
        L["点击：单个展开"] = "點擊：單個展開"
        L["ALT+点击：全部展开"] = "ALT+點擊：全部展開"
        L["点击：单个折叠"] = "點擊：單個摺疊"
        L["ALT+点击：全部折叠"] = "ALT+點擊：全部摺疊"
    end

    function aura.RGB(hex, Alpha)
        local red = string.sub(hex, 1, 2)
        local green = string.sub(hex, 3, 4)
        local blue = string.sub(hex, 5, 6)

        red = tonumber(red, 16) / 255
        green = tonumber(green, 16) / 255
        blue = tonumber(blue, 16) / 255

        if Alpha then
            return red, green, blue, Alpha
        else
            return red, green, blue
        end
    end

    function aura.SetClassCFF(name, player, type)
        if type then return name end
        local _, class
        if player then
            _, class = UnitClass(player)
        else
            _, class = UnitClass(name)
        end
        local colorname = ""
        if class then
            local color = select(4, GetClassColor(class))
            colorname = "|c" .. color .. name .. "|r"
            return colorname, color
        else
            return name, ""
        end
    end

    -- 常量
    do
        aura.sound1 = SOUNDKIT.GS_TITLE_OPTION_OK -- 按键音效
        aura.sound2 = 569593                      -- 升级音效
        aura.GREEN1 = "00FF00"
        aura.RED1 = "FF0000"

        aura.WIDTH = 310
        aura.HEIGHT = 105
        aura.REPEAT_TIME = 20
        aura.HIDEFRAME_TIME = 3
        aura.edgeSize = 2.5
        aura.backdropColor = { 0, 0, 0, .6 }
        aura.backdropBorderColor = { 1, 1, 0, 1 }
        aura.backdropColor_filter = { .5, .5, .5, .3 }
        aura.backdropBorderColor_filter = { .5, .5, .5, 1 }
        aura.barColor_filter = { .5, .5, .5, .8 }
        aura.backdropColor_IsMe = { aura.RGB("009900", .6) }
        aura.backdropBorderColor_IsMe = { 0, 1, 0, 1 }
        aura.raidRosterInfo = {}

        aura.MiniMoneyTbl = {
            -- 小于该价格时，每次加价幅度，最低加价幅度
            { 30, 1, 1 },
            { 100, 10, 1 },
            { 5000, 100, 100 },
            { 10000, 500, 100 },
            { 50000, 1000, 500 },
            { 100000, 5000, 500 },
            { nil, 10000, 1000 },
        }
    end

    -- 字体
    do
        local color = "Gold18" -- BGA.FontGold18
        _G.BGA.FontGold18 = CreateFont("BGA.Font" .. color)
        _G.BGA.FontGold18:SetTextColor(1, 0.82, 0)
        _G.BGA.FontGold18:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")

        local color = "Dis18" -- BGA.FontDis18
        _G.BGA.FontDis18 = CreateFont("BGA.Font" .. color)
        _G.BGA.FontDis18:SetTextColor(.5, .5, .5)
        _G.BGA.FontDis18:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
        local color = "Dis15" -- BGA.FontDis15
        _G.BGA.FontDis15 = CreateFont("BGA.Font" .. color)
        _G.BGA.FontDis15:SetTextColor(.5, .5, .5)
        _G.BGA.FontDis15:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")

        local color = "Green15" -- BGA.FontGreen15
        _G.BGA.FontGreen15 = CreateFont("BGA.Font" .. color)
        _G.BGA.FontGreen15:SetTextColor(0, 1, 0)
        _G.BGA.FontGreen15:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")

        local color = "white15" -- BGA.Fontwhite15
        _G.BGA.FontWhite15 = CreateFont("BGA.Font" .. color)
        _G.BGA.FontWhite15:SetTextColor(1, 1, 1)
        _G.BGA.FontWhite15:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
    end

    function aura.FormatNumber(num)
        if not tonumber(num) then return num end
        num = tostring(num)
        local len = strlen(num)
        if len < 5 then return num end
        local k = num:sub(-4, -1)
        local w = num:sub(1, -5)
        if tonumber(k) == 0 then
            return w .. L["万"]
        else
            for i = 1, 4 do
                local len = strlen(k)
                local last = k:sub(len, len)
                if last == "0" then
                    k = k:sub(1, len - 1)
                else
                    break
                end
            end
            return w .. "." .. k .. L["万"]
        end
    end

    function aura.IsRaidLeader(player)
        if not player then
            player = UnitName("player")
        end
        if player == aura.raidLeader then
            return true
        end
    end

    function aura.IsML(player)
        if not player then
            player = UnitName("player")
        end
        if (player == aura.raidLeader) or (player == aura.ML) then
            return true
        end
    end

    function aura.UpdateRaidRosterInfo()
        wipe(aura.raidRosterInfo)
        aura.raidLeader = nil
        aura.ML = nil
        if IsInRaid(1) then
            for i = 1, GetNumGroupMembers() do
                local name, rank, subgroup, level, class2, class, zone, online,
                isDead, role, isML, combatRole = GetRaidRosterInfo(i)
                if name then
                    name = strsplit("-", name)
                    local a = {
                        name = name,
                        rank = rank,
                        subgroup = subgroup,
                        level = level,
                        class2 = class2,
                        class = class,
                        zone = zone,
                        online = online,
                        isDead = isDead,
                        role = role,
                        isML = isML,
                        combatRole = combatRole
                    }
                    table.insert(aura.raidRosterInfo, a)
                    if rank == 2 then
                        aura.raidLeader = name
                    end
                    if isML then
                        aura.ML = name
                    end
                end
            end

            C_ChatInfo.SendAddonMessage(aura.AddonChannel, "MyVer" .. "," .. aura.ver, "RAID")
        end
        for i, f in ipairs(_G.BGA.Frames) do
            if not f.IsEnd and aura.IsML() then
                f.cancel:Show()
                f.autoTextButton:ClearAllPoints()
                f.autoTextButton:SetPoint("TOP", 45, -2)
            else
                f.cancel:Hide()
                f.autoTextButton:ClearAllPoints()
                f.autoTextButton:SetPoint("TOP", 0, -2)
            end
        end
    end

    function aura.GetAuctioningFromRaid()
        if not IsInRaid(1) then return end
        aura.canGetAuctioning = true
        C_ChatInfo.SendAddonMessage(aura.AddonChannel, "GetAuctioning", "RAID")
        C_Timer.After(1, function()
            aura.canGetAuctioning = false
        end)
    end

    function aura.Hide_OnClick(self)
        local f = self.owner
        if f.IsSmallWindow then
            local function SetBigWindos(f)
                -- if f.isAuto then return end
                f.IsSmallWindow = false
                f.hide:SetText(L["折叠"])

                if aura.IsML() then
                    f.cancel:Show()
                else
                    f.cancel:Hide()
                end
                f.autoTextButton:Show()
                f.logTextButton:Show()
                f.currentMoneyFrame:Show()
                f.topMoneyFrame:Show()
                if not f.IsEnd then
                    f.myMoneyEdit:Show()
                end
                f.itemFrame2:Show()

                f:SetSize(aura.WIDTH, aura.HEIGHT)
                f.itemFrame:ClearAllPoints()
                f.itemFrame:SetPoint("TOPLEFT", f, "TOPLEFT", aura.edgeSize + 1, -f.hide:GetHeight() - 3)
                f.itemFrame:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -aura.edgeSize, -55)
                f.itemFrame.iconFrame:ClearAllPoints()
                f.itemFrame.iconFrame:SetPoint("TOPLEFT", f.itemFrame, "TOPLEFT", 0, 0)
                f.itemFrame.iconFrame:SetPoint("BOTTOMRIGHT", f.itemFrame, "TOPLEFT", f.itemFrame:GetHeight(), -f.itemFrame:GetHeight())
                f.itemFrame.iconFrame:SetBackdropBorderColor(unpack(f.itemFrame.iconFrame.color))
                f.itemFrame.itemNameText:ClearAllPoints()
                f.itemFrame.itemNameText:SetPoint("TOPLEFT", f.itemFrame.iconFrame, "TOPRIGHT", 2, -2)
                f.itemFrame.bg:ClearAllPoints()
                f.itemFrame.bg:SetAllPoints()
                f.bar:ClearAllPoints()
                f.bar:SetPoint("TOPLEFT", f.itemFrame.iconFrame, "TOPRIGHT", 0, 0)
                f.bar:SetPoint("BOTTOMRIGHT", f.itemFrame, "BOTTOMRIGHT", 0, 0)
            end
            if IsAltKeyDown() then
                for i, f in ipairs(_G.BGA.Frames) do
                    SetBigWindos(f)
                end
            else
                SetBigWindos(f)
            end
        else
            local function SetSmallWindos(f)
                if f.isAuto then return end
                f.IsSmallWindow = true
                f.hide:SetText(L["展开"])

                f.autoFrame:Hide()
                f.cancel:Hide()
                f.autoTextButton:Hide()
                f.logTextButton:Hide()
                f.currentMoneyFrame:Hide()
                f.topMoneyFrame:Hide()
                f.myMoneyEdit:Hide()
                f.itemFrame2:Hide()

                f:SetSize(aura.WIDTH, 23)
                f.itemFrame:ClearAllPoints()
                f.itemFrame:SetAllPoints()
                f.itemFrame.iconFrame:ClearAllPoints()
                f.itemFrame.iconFrame:SetPoint("TOPLEFT", aura.edgeSize, -aura.edgeSize)
                f.itemFrame.iconFrame:SetPoint("BOTTOMRIGHT", f.itemFrame, "TOPLEFT", f.itemFrame:GetHeight() - aura.edgeSize, -f.itemFrame:GetHeight() + aura.edgeSize)
                f.itemFrame.iconFrame:SetBackdropBorderColor(1, 1, 1, 0)
                f.itemFrame.itemNameText:ClearAllPoints()
                f.itemFrame.itemNameText:SetPoint("LEFT", f.itemFrame.iconFrame, "RIGHT", 2, 0)
                f.itemFrame.bg:ClearAllPoints()
                f.itemFrame.bg:SetPoint("TOPLEFT", aura.edgeSize, -aura.edgeSize)
                f.itemFrame.bg:SetPoint("BOTTOMRIGHT", -aura.edgeSize, aura.edgeSize)
                f.bar:ClearAllPoints()
                f.bar:SetPoint("TOPLEFT", f.itemFrame.iconFrame, "TOPRIGHT", 0, 0)
                f.bar:SetPoint("BOTTOMRIGHT", f.itemFrame, "BOTTOMRIGHT", -aura.edgeSize, aura.edgeSize)
            end
            if IsAltKeyDown() then
                for i, f in ipairs(_G.BGA.Frames) do
                    SetSmallWindos(f)
                end
            else
                SetSmallWindos(f)
            end
        end
        aura.UpdateAllOnEnters()
        PlaySound(aura.sound1)
    end

    function aura.Hide_OnEnter(self)
        local f = self.owner
        if aura.IsRight(self) then
            GameTooltip:SetOwner(f, "ANCHOR_LEFT", 0, 0)
        else
            GameTooltip:SetOwner(f, "ANCHOR_RIGHT", 0, 0)
        end
        GameTooltip:ClearLines()
        if f.IsSmallWindow then
            GameTooltip:AddLine(L["展开"], 1, 1, 1, true)
            GameTooltip:AddLine(L["点击：单个展开"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["ALT+点击：全部展开"], 1, 0.82, 0, true)
        else
            GameTooltip:AddLine(L["折叠"], 1, 1, 1, true)
            GameTooltip:AddLine(L["点击：单个折叠"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["ALT+点击：全部折叠"], 1, 0.82, 0, true)
        end
        GameTooltip:Show()
        self.isOnEnter = true
    end

    function aura.Cancel_OnClick(self)
        if IsAltKeyDown() then
            C_ChatInfo.SendAddonMessage(aura.AddonChannel, "CancelAuction" .. "," ..
                self.owner.auctionID, "RAID")
            PlaySound(aura.sound1)
        end
    end

    function aura.Cancel_OnEnter(self)
        local f = self.owner
        if aura.IsRight(self) then
            GameTooltip:SetOwner(f, "ANCHOR_LEFT", 0, 0)
        else
            GameTooltip:SetOwner(f, "ANCHOR_RIGHT", 0, 0)
        end
        GameTooltip:ClearLines()
        GameTooltip:AddLine(self:GetText(), 1, 1, 1, true)
        GameTooltip:AddLine(L["Alt+点击才能生效"], 1, 0.82, 0, true)
        GameTooltip:AddLine(L["只有团长或物品分配者有权限取消拍卖"], 0.5, 0.5, 0.5, true)
        GameTooltip:Show()
    end

    function aura.LogTextButton_OnEnter(self)
        self.isOnEnter = true
        local f = self.owner
        if aura.IsRight(self) then
            GameTooltip:SetOwner(f, "ANCHOR_LEFT", 0, 0)
        else
            GameTooltip:SetOwner(f, "ANCHOR_RIGHT", 0, 0)
        end
        GameTooltip:ClearLines()
        GameTooltip:AddLine(L["出价记录"], 1, 1, 1, true)

        if #f.logs == 0 then
            GameTooltip:AddLine(L["没有人出价"], .5, .5, .5, true)
        elseif #f.logs > 15 then
            GameTooltip:AddLine("......", .5, .5, .5, true)
            for i = #f.logs - 14, #f.logs do
                GameTooltip:AddLine(i .. L["、"] .. f.logs[i].money .. format(L["（%s）"], f.logs[i].player), 1, .82, 0, true)
            end
        else
            for i = 1, #f.logs do
                GameTooltip:AddLine(i .. L["、"] .. f.logs[i].money .. format(L["（%s）"], f.logs[i].player), 1, .82, 0, true)
            end
        end
        GameTooltip:Show()
    end

    function aura.LogTextButton_OnLeave(self)
        self.isOnEnter = false
        GameTooltip:Hide()
    end

    function aura.JiaJian(money, fudu, _type)
        if _type == "+" then
            return money + fudu
        elseif _type == "-" then
            if money - fudu > 0 then
                return money - fudu
            elseif (money == fudu) and money ~= 1 then
                return money - 10
            else
                return 0
            end
        end
    end

    function aura.Addmoney(money, _type)
        local money = tonumber(money) or 0
        local fudu
        for i, v in ipairs(aura.MiniMoneyTbl) do
            if not v[1] or money < v[1] then
                fudu = v[2]
                break
            end
        end
        return aura.JiaJian(money, fudu, _type), fudu
    end

    function aura.TooSmall(self)
        local myMoney = tonumber(self:GetText()) or 0
        local currentMoney = self.owner.money
        local money = myMoney - currentMoney
        for i, v in ipairs(aura.MiniMoneyTbl) do
            if not v[1] or currentMoney < v[1] then
                if money < v[3] then
                    return v[3]
                else
                    return false
                end
            end
        end
    end

    function aura.IsRight(self)
        if self.owner:GetCenter() > UIParent:GetCenter() then
            return true
        end
    end

    function aura.itemOnEnter(self)
        local f = self.owner
        if f.IsSmallWindow then return end
        if aura.IsRight(self) then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT", 0, 0)
        else
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
        end
        GameTooltip:ClearLines()
        GameTooltip:SetItemByID(self.itemID)
        GameTooltip:Show()
        if IsControlKeyDown() then
            SetCursor("Interface/Cursor/Inspect")
        end
        self.isOnEnter = true
        aura.itemIsOnEnter = true
        if BG then
            if BG.Show_AllHighlight then
                BG.Show_AllHighlight(self.link)
            end
            if BG.SetHistoryMoney then
                BG.SetHistoryMoney(self.itemID)
            end
        end
    end

    function aura.itemOnLeave(self)
        GameTooltip:Hide()
        self.isOnEnter = false
        aura.itemIsOnEnter = false
        SetCursor(nil)
        if BG then
            if BG.Hide_AllHighlight then
                BG.Hide_AllHighlight()
            end
            if BG.HideHistoryMoney then
                BG.HideHistoryMoney()
            end
        end
    end

    function aura.Auctioning(f, duration)
        f.bar:Show()
        local t = 0
        f.bar:SetScript("OnUpdate", function(self, elapsed)
            t = t + elapsed
            local remaining = tonumber(format("%.3f", duration - t))
            local a = remaining / duration
            local _, max = f.bar:GetMinMaxValues()
            local v = a * max
            f.bar:SetValue(v)
            if remaining <= 10 then
                if f.filter and not (f.player and f.player == UnitName("player")) then
                    f.bar:SetStatusBarColor(unpack(BGA.aura_env.barColor_filter))
                else
                    f.bar:SetStatusBarColor(1, 0, 0, 0.6)
                end
                f.remainingTime:SetTextColor(1, 0, 0)
                f.remainingTime:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
            else
                if f.filter and not (f.player and f.player == UnitName("player")) then
                    f.bar:SetStatusBarColor(unpack(BGA.aura_env.barColor_filter))
                else
                    f.bar:SetStatusBarColor(1, 1, 0, 0.6)
                end
                f.remainingTime:SetTextColor(1, 1, 1)
                f.remainingTime:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
            end
            f.remainingTime:SetText((format("%d", remaining) + 1) .. "s")
            f.remaining = remaining

            if remaining <= 0 then
                f.myMoneyEdit:Hide()
                f.remainingTime:SetText("0s")
            end
            if remaining <= -0.5 then
                f.bar:SetScript("OnUpdate", nil)

                f.remainingTime:Hide()
                f.bar:Hide()
                f.IsEnd = true
                f.cancel:Hide()

                local t = f.itemFrame2:CreateFontString()
                t:SetFont(STANDARD_TEXT_FONT, 30, "OUTLINE")
                t:SetPoint("TOPRIGHT", f.itemFrame, "BOTTOMRIGHT", -10, -5)

                if f.player and f.player ~= "" then
                    t:SetText(L["拍卖成功"])
                    t:SetTextColor(0, 1, 0)
                    f.currentMoneyText:SetText(L["|cff00FF00成交价：|r"] .. f.money)
                    if f.player == UnitName("player") then
                        f.topMoneyText:SetText(L["|cff00FF00买家：|r"] .. "|cff" .. aura.GREEN1 .. L[">> 你 <<"])
                    else
                        f.topMoneyText:SetText(L["|cff00FF00买家：|r"] .. f.colorplayer)
                    end

                    if BG then
                        BG.sendMoneyLog = BG.sendMoneyLog or {}
                        BG.sendMoneyLog[f.itemID] = f.logs2
                    end

                    if aura.IsRaidLeader() then
                        SendChatMessage(format(L["{rt6}拍卖成功{rt6} %s %s %s"], f.link, f.player, f.money), "RAID")
                    end
                else
                    t:SetText(L["流拍"])
                    t:SetTextColor(1, 0, 0)
                    f.currentMoneyText:SetText(L["|cffFF0000流拍：|r"] .. f.money)
                    f.topMoneyText:SetText("")

                    if aura.IsRaidLeader() then
                        SendChatMessage(format(L["{rt7}流拍{rt7} %s"], f.link), "RAID")
                    end
                end

                C_Timer.After(aura.HIDEFRAME_TIME, function()
                    aura.UpdateFrame(f)
                end)
            end
        end)
    end

    function aura.currentMoney_OnMouseDown(self)
        self.owner:GetScript("OnMouseDown")(_G.BGA.AuctionMainFrame)
    end

    function aura.currentMoney_OnMouseUp(self)
        local f = self.owner
        f:GetScript("OnMouseUp")(_G.BGA.AuctionMainFrame)
    end

    function aura.myMoney_OnTextChanged(self)
        local f = self.owner
        local money = tonumber(self:GetText()) or 0
        if f.start then
            if money < f.money then
                self:SetTextColor(1, 0, 0)
                f.ButtonSendMyMoney:Disable()
                if f.player ~= UnitName("player") then
                    f.ButtonSendMyMoney.disf:Show()
                    f.ButtonSendMyMoney.disf.text = L["需高于或等于起拍价"]
                end
            else
                self:SetTextColor(1, 1, 1)
                f.ButtonSendMyMoney:Enable()
                f.ButtonSendMyMoney.disf:Hide()
            end
        elseif money <= f.money then
            f.ButtonSendMyMoney:Disable()
            if f.player ~= UnitName("player") then
                self:SetTextColor(1, 0, 0)
                f.ButtonSendMyMoney.disf:Show()
                f.ButtonSendMyMoney.disf.text = L["需高于当前价格"]
            else
                self:SetTextColor(1, 1, 1)
            end
        elseif aura.TooSmall(self) then
            self:SetTextColor(1, 0, 0)
            f.ButtonSendMyMoney:Disable()
            f.ButtonSendMyMoney.disf:Show()
            f.ButtonSendMyMoney.disf.text = format(L["最小加价幅度为%s"], aura.TooSmall(self))
        else
            self:SetTextColor(1, 1, 1)
            f.ButtonSendMyMoney:Enable()
            f.ButtonSendMyMoney.disf:Hide()
        end
        if money <= f.money then
            f.ButtonJian:Disable()
        else
            f.ButtonJian:Enable()
        end
        aura.UpdateAllOnEnters()
    end

    function aura.myMoney_OnMouseWheel(self, delta)
        local _type = "-"
        if delta == 1 then
            _type = "+"
        end
        if _type == "-" then
            local f = self.owner
            local myMoney = tonumber(self:GetText())
            if myMoney and myMoney <= f.money then
                return
            end
        end
        self:SetText(aura.Addmoney(self:GetText(), _type))
    end

    function aura.myMoney_OnEnter(self)
        GameTooltip:SetOwner(self.owner, "ANCHOR_BOTTOM", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(aura.FormatNumber(self:GetText()), 1, 1, 1)
        GameTooltip:AddLine(L["滚轮：快速调整价格"], 1, 0.82, 0, true)
        GameTooltip:Show()
        self.isOnEnter = true
    end

    function aura.OnLeave(self)
        GameTooltip_Hide()
        self.isOnEnter = false
    end

    function aura.JiaJian_OnEnter(self)
        local f = self.owner
        local myMoney = tonumber(self.edit:GetText()) or 0
        local _, fudu = aura.Addmoney(myMoney, self._type)
        GameTooltip:SetOwner(f, "ANCHOR_BOTTOM", 0, 0)
        GameTooltip:ClearLines()
        if not f.start and not f.IsEnd and f.player ~= UnitName("player") and self._type == "+" and myMoney <= f.money then
            GameTooltip:AddLine(L["出价设为："] .. "|cffffffff" .. aura.FormatNumber(aura.Addmoney(f.money, "+")), 1, 0.82, 0, true)
        else
            local r, g, b = 1, 0, 0
            if self._type == "+" then
                r, g, b = 0, 1, 0
            end
            GameTooltip:AddLine(self._type .. " " .. aura.FormatNumber(fudu), r, g, b, true)
            GameTooltip:AddLine(L["根据你的出价动态改变增减幅度"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["长按：快速调整价格"], 1, 0.82, 0, true)
        end
        GameTooltip:Show()
        self.isOnEnter = true
    end

    function aura.JiaJian_OnClick(self)
        local f = self.owner
        local myMoney = tonumber(self.edit:GetText()) or 0
        if not f.start and not f.IsEnd and f.player ~= UnitName("player") and self._type == "+" and myMoney <= f.money then
            self.edit:SetText(aura.Addmoney(f.money, "+"))
        else
            self.edit:SetText(aura.Addmoney(myMoney, self._type))
        end
        aura.UpdateAllOnEnters()
        PlaySound(aura.sound1)
    end

    function aura.JiaJian_OnMouseDown(self)
        local t = 0
        local t_do = 0.5
        self:SetScript("OnUpdate", function(self, elapsed)
            t = t + elapsed
            if not self:IsEnabled() then
                self:SetScript("OnUpdate", nil)
                return
            end
            if t >= t_do then
                t = t_do - 0.1
                self.edit:SetText(aura.Addmoney(self.edit:GetText(), self._type))
                aura.JiaJian_OnEnter(self)
            end
        end)
    end

    function aura.JiaJian_OnMouseUp(self)
        self:SetScript("OnUpdate", nil)
    end

    function aura.SendMyMoney_OnClick(self)
        local f = self.owner
        if f.ButtonSendMyMoney:IsEnabled() then
            local money = tonumber(f.myMoneyEdit:GetText()) or 0
            C_ChatInfo.SendAddonMessage(aura.AddonChannel, "SendMyMoney" .. "," ..
                f.auctionID .. "," .. money, "RAID")
            f.myMoneyEdit:ClearFocus()
            PlaySound(aura.sound1)

            if not f.start and BiaoGe and BiaoGe.options and BiaoGe.options.Sound then
                local num = random(10)
                if num <= 1 then
                    PlaySoundFile(BG["sound_HusbandComeOn" .. BiaoGe.options.Sound], "Master")
                end
            end
        end
    end

    function aura.SetMoney(f, money, player)
        if not f.IsSmallWindow then
            f.updateFrame:Show()
            f.autoFrame.updateFrame:Show()
        end

        f.money = money
        f.currentMoneyText:SetText(L["|cffFFD100当前价格：|r"] .. aura.FormatNumber(money))
        f.player = player
        f.colorplayer = aura.SetClassCFF(player)
        f.myMoneyEdit:Show()
        f.start = false
        if player == UnitName("player") then
            f.topMoneyText:SetText(L["|cffFFD100出价最高者：|r"] .. "|cff" .. aura.GREEN1 .. L[">> 你 <<"])
            f:SetBackdropColor(unpack(aura.backdropColor_IsMe))
            f:SetBackdropBorderColor(unpack(aura.backdropBorderColor_IsMe))
            f.autoFrame:SetBackdropColor(unpack(aura.backdropColor_IsMe))
            f.autoFrame:SetBackdropBorderColor(unpack(aura.backdropBorderColor_IsMe))
            f.hide:SetNormalFontObject(_G.BGA.FontGreen15)
            f.cancel:SetNormalFontObject(_G.BGA.FontGreen15)
            f.autoTextButton:SetNormalFontObject(_G.BGA.FontGreen15)
            f.logTextButton:SetNormalFontObject(_G.BGA.FontGreen15)
            tinsert(f.logs, { money = money, player = "|cff" .. aura.GREEN1 .. L["你"] .. "|r" })
            tinsert(f.logs2, { money = money, player = "|cff" .. aura.GREEN1 .. L["你"] .. "|r" })
        else
            if f.mod == "anonymous" then
                f.topMoneyText:SetText(L["|cffFFD100出价最高者：|r"] .. L["別人(匿名)"])
                tinsert(f.logs, { money = money, player = L["匿名"] })
            else
                f.topMoneyText:SetText(L["|cffFFD100出价最高者：|r"] .. f.colorplayer)
                tinsert(f.logs, { money = money, player = f.colorplayer })
            end
            tinsert(f.logs2, { money = money, player = f.colorplayer })
            if f.filter then
                f:SetBackdropColor(unpack(aura.backdropColor_filter))
                f:SetBackdropBorderColor(unpack(aura.backdropBorderColor_filter))
                f.autoFrame:SetBackdropColor(unpack(aura.backdropColor_filter))
                f.autoFrame:SetBackdropBorderColor(unpack(aura.backdropBorderColor_filter))
                f.hide:SetNormalFontObject(_G.BGA.FontDis15)
                f.cancel:SetNormalFontObject(_G.BGA.FontDis15)
                f.autoTextButton:SetNormalFontObject(_G.BGA.FontDis15)
                f.logTextButton:SetNormalFontObject(_G.BGA.FontDis15)
            else
                f:SetBackdropColor(unpack(aura.backdropColor))
                f:SetBackdropBorderColor(unpack(aura.backdropBorderColor))
                f.autoFrame:SetBackdropColor(unpack(aura.backdropColor))
                f.autoFrame:SetBackdropBorderColor(unpack(aura.backdropBorderColor))
                f.hide:SetNormalFontObject(_G.BGA.FontGreen15)
                f.cancel:SetNormalFontObject(_G.BGA.FontGreen15)
                f.autoTextButton:SetNormalFontObject(_G.BGA.FontGreen15)
                f.logTextButton:SetNormalFontObject(_G.BGA.FontGreen15)
            end
            C_Timer.After(.5, function()
                aura.AutoSendMyMoney(f)
            end)
        end
        aura.myMoney_OnTextChanged(f.myMoneyEdit)

        if f.isAuto and f.money >= f.autoMoney then
            f.autoTitleText:SetText(L["设置心理价格"])
            f.autoTitleText:SetTextColor(1, .82, 0)
            f.isAutoTex:Hide()
            f.autoButton:SetText(L["开启自动出价"])
            f.autoButton:Enable()
            f.autoMoneyEdit.Left:SetAlpha(1)
            f.autoMoneyEdit.Right:SetAlpha(1)
            f.autoMoneyEdit.Middle:SetAlpha(1)
            f.isAuto = false
            f.autoTextButton:SetText(L["自动出价"])
            f.autoTextButton:SetWidth(f.autoTextButton:GetFontString():GetWidth())
            f.autoMoneyEdit:SetTextColor(1, 1, 1)
            f.autoMoneyEdit:SetEnabled(true)
            f.autoMoneyEdit.isLocked = false
            f.hide:Enable()
        end

        aura.UpdateAutoButton(f)
        aura.UpdateAllOnEnters()

        if (f.remaining or 0) <= aura.REPEAT_TIME then
            aura.Auctioning(f, aura.REPEAT_TIME)
        end
    end

    function aura.SendMyMoney_OnEnter(self)
        local f = self.owner
        GameTooltip:SetOwner(self.owner, "ANCHOR_BOTTOM", 0, 0)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(self.text, 1, 0, 0, true)
        GameTooltip:Show()
    end

    function aura.UpdateAllOnEnters()
        for i, f in ipairs(_G.BGA.Frames) do
            if f.myMoneyEdit.isOnEnter then
                aura.myMoney_OnEnter(f.myMoneyEdit)
            end
            if f.ButtonJian.isOnEnter then
                aura.JiaJian_OnEnter(f.ButtonJian)
            end
            if f.ButtonJia.isOnEnter then
                aura.JiaJian_OnEnter(f.ButtonJia)
            end
            if f.logTextButton.isOnEnter then
                f.logTextButton:GetScript("OnEnter")(f.logTextButton)
            end
            if f.autoMoneyEdit.isOnEnter then
                aura.AutoEdit_OnEnter(f.autoMoneyEdit)
            end
            if f.hide.isOnEnter then
                aura.Hide_OnEnter(f.hide)
            end
        end
    end

    function aura.UpdateAllFrames()
        for i, f in ipairs(_G.BGA.Frames) do
            if f.showCantClickFrame and not f.IsSmallWindow then
                f.cantClickFrame:Show()
                f.cantClickFrame.t = 0
                f.cantClickFrame:SetScript("OnUpdate", function(self, elapsed)
                    self.t = self.t + elapsed
                    if self.t >= .8 then
                        self:SetScript("OnUpdate", nil)
                        self:Hide()
                    end
                end)
            end

            f:ClearAllPoints()
            if i == 1 then
                f:SetPoint("TOPLEFT", _G.BGA.AuctionMainFrame, "TOPLEFT", 0, 0)
            else
                f:SetPoint("TOPLEFT", _G.BGA.Frames[i - 1], "BOTTOMLEFT", 0, -5)
            end
        end
    end

    function aura.UpdateFrame(f)
        local t = 1
        f:SetScript("OnUpdate", function(self, elapsed)
            t = t - elapsed
            if t >= 0 then
                f:SetAlpha(t)
            else
                for i, _f in ipairs(_G.BGA.Frames) do
                    if i < f.num then
                        _f.showCantClickFrame = false
                    else
                        _f.showCantClickFrame = true
                    end
                end
                f:SetScript("OnUpdate", nil)
                tremove(_G.BGA.Frames, f.num)
                f:Hide()
                _G.BGA.AuctionMainFrame:StopMovingOrSizing()
                for i, f in ipairs(_G.BGA.Frames) do
                    f.num = i
                end
                aura.UpdateAllFrames()
            end
        end)
    end

    function aura.anim(parent)
        parent.alltime = 0.5
        parent.t = 0.5
        parent:SetScale(3)
        parent:SetScript("OnUpdate", function(self, t)
            self.t = self.t - t
            if self.t <= 0 then self.t = 0 end
            self:SetScale(1 + self.t / self.alltime)
            if self.t <= 0 then
                self:SetScript("OnUpdate", nil)
            end
        end)
    end

    function aura.OnEditFocusGained(self)
        aura.lastFocus = self
        self:HighlightText()
    end

    -- 自动出价函数
    do
        function aura.AutoText_OnClick(self)
            self.owner.autoFrame:SetShown(not self.owner.autoFrame:IsVisible())
            self.owner.autoFrame.isClicked = true
            PlaySound(aura.sound1)
        end

        function aura.Auto_OnTextChanged(self)
            local f = self.owner
            local money = tonumber(self:GetText()) or 0
            f.autoMoney = money
            aura.UpdateAutoButton(self)
            aura.UpdateAllOnEnters()
        end

        function aura.AutoEdit_OnEnter(self)
            local f = self.owner
            GameTooltip:SetOwner(f.autoFrame, "ANCHOR_BOTTOM", 0, 0)
            GameTooltip:ClearLines()
            if self.isLocked then
                local money = self:GetText()
                if tonumber(money) then
                    GameTooltip:AddLine(L["心理价格锁定中"] .. format(L["（%s）"], aura.FormatNumber(money)), 1, 0, 0, true)
                else
                    GameTooltip:AddLine(L["心理价格锁定中"], 1, 0, 0, true)
                end
                GameTooltip:AddLine(L["取消自动出价后才能修改。"], 1, 0.82, 0, true)
            else
                local money = self:GetText()
                if tonumber(money) then
                    GameTooltip:AddLine(L["自动出价"], 1, 1, 1, true)
                    GameTooltip:AddLine(L["心理价格："] .. aura.FormatNumber(money), 1, 1, 1, true)
                else
                    GameTooltip:AddLine(L["自动出价"], 1, 1, 1, true)
                end
                GameTooltip:AddLine(L["如果别人出价比你高时，自动帮你出价，每次加价为最低幅度，出价不会高于你设定的心理价格。"], 1, 0.82, 0, true)
            end
            GameTooltip:Show()
            self.isOnEnter = true
        end

        function aura.UpdateAutoButton(self)
            local f = self.owner or self
            f.autoButton:Enable()
            f.autoButton.disf:Hide()
            if f.autoMoney == 0 then
                f.autoButton:Disable()
                f.autoButton.disf:Hide()
            elseif f.start then
                if f.autoMoney < f.money then
                    f.autoButton.onEnterText = L["心理价格需高于或等于起拍价"]
                    f.autoButton:Disable()
                    f.autoButton.disf:Show()
                end
            elseif f.autoMoney <= f.money then
                f.autoButton.onEnterText = L["心理价格需高于当前价格"]
                f.autoButton:Disable()
                f.autoButton.disf:Show()
            end
        end

        function aura.AutoButton_OnClick(self)
            local f = self.owner
            if f.isAuto then
                f.isAuto = false
                f.autoTitleText:SetText(L["设置心理价格"])
                f.autoTitleText:SetTextColor(1, .82, 0)
                f.isAutoTex:Hide()
                f.autoButton:SetText(L["开启自动出价"])
                f.autoMoneyEdit.Left:SetAlpha(1)
                f.autoMoneyEdit.Right:SetAlpha(1)
                f.autoMoneyEdit.Middle:SetAlpha(1)
                f.autoTextButton:SetText(L["自动出价"])
                f.autoTextButton:SetWidth(f.autoTextButton:GetFontString():GetWidth())
                f.autoMoneyEdit:SetTextColor(1, 1, 1)
                f.autoMoneyEdit:SetEnabled(true)
                f.autoMoneyEdit.isLocked = false
                f.hide:Enable()
            else
                f.isAuto = true
                f.autoTitleText:SetText(L["心理价格"])
                f.autoTitleText:SetTextColor(0, 1, 0)
                f.isAutoTex:Show()
                f.autoButton:SetText(L["取消自动出价"])
                f.autoMoneyEdit:ClearFocus()
                f.autoMoneyEdit.Left:SetAlpha(f.autoMoneyEdit.alpha)
                f.autoMoneyEdit.Right:SetAlpha(f.autoMoneyEdit.alpha)
                f.autoMoneyEdit.Middle:SetAlpha(f.autoMoneyEdit.alpha)
                f.autoTextButton:SetText(L[">>正在自动出价<<"])
                f.autoTextButton:SetWidth(f.autoTextButton:GetFontString():GetWidth())
                f.autoMoneyEdit:SetTextColor(0, 1, 0)
                f.autoMoneyEdit:SetEnabled(false)
                f.autoMoneyEdit.isLocked = true
                aura.AutoSendMyMoney(f)
                f.hide:Disable()
            end
            aura.UpdateAllOnEnters()
            PlaySound(aura.sound1)
        end

        function aura.AutoButton_OnEnter(self)
            local f = self.owner
            GameTooltip:SetOwner(f.autoFrame, "ANCHOR_BOTTOM", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(f.autoButton.onEnterText, 1, 0, 0, true)
            GameTooltip:Show()
        end

        function aura.AutoSendMyMoney(f)
            if not f.isAuto then return end
            if f.player and f.player == UnitName("player") then return end

            local newmoney
            if f.start then
                newmoney = f.money
            else
                newmoney = aura.Addmoney(f.money, "+")
                if newmoney > f.autoMoney and f.money < f.autoMoney then
                    newmoney = f.autoMoney
                end
            end

            if newmoney <= f.autoMoney then
                C_ChatInfo.SendAddonMessage(aura.AddonChannel, "SendMyMoney" .. "," ..
                    f.auctionID .. "," .. newmoney, "RAID")
            end
        end
    end

    function aura.CreateAuction(auctionID, itemID, money, duration, player, mod, notAfter)
        for i, f in ipairs(_G.BGA.Frames) do
            if f.auctionID == auctionID then
                return
            end
        end

        local name, link, quality, level, _, itemType, itemSubType, _, itemEquipLoc, Texture, _, classID, subclassID, bindType = GetItemInfo(itemID)
        if not link then
            if not notAfter then
                C_Timer.After(0.5, function()
                    aura.CreateAuction(auctionID, itemID, money, duration - 0.5, player, mod, true)
                end)
            end
            return
        end
        local AuctionFrame

        -- 主界面
        do
            local f = CreateFrame("Frame", nil, _G.BGA.AuctionMainFrame, "BackdropTemplate")
            f:SetBackdrop({
                bgFile = "Interface/ChatFrame/ChatFrameBackground",
                edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                edgeSize = aura.edgeSize,
            })
            f:SetBackdropColor(unpack(aura.backdropColor))
            f:SetBackdropBorderColor(unpack(aura.backdropBorderColor))
            f:SetSize(aura.WIDTH, aura.HEIGHT)
            if #_G.BGA.Frames == 0 then
                f:SetPoint("TOP", 0, 0)
            else
                f:SetPoint("TOP", _G.BGA.Frames[#_G.BGA.Frames], "BOTTOM", 0, -5)
            end
            f:EnableMouse(true)
            f.auctionID = auctionID
            f.itemID = itemID
            f.link = link
            f.mod = mod
            f.num = #_G.BGA.Frames + 1
            f.logs = {}
            f.logs2 = {}
            AuctionFrame = f
            tinsert(_G.BGA.Frames, f)
            f:SetScript("OnMouseUp", function(self)
                local mainFrame = _G.BGA.AuctionMainFrame
                mainFrame:StopMovingOrSizing()
                if _G.BiaoGe and _G.BiaoGe.point then
                    _G.BiaoGe.point.Auction = { mainFrame:GetPoint(1) }
                end
                mainFrame:SetScript("OnUpdate", nil)
            end)

            f:SetScript("OnMouseDown", function(self)
                local mainFrame = _G.BGA.AuctionMainFrame
                mainFrame:StartMoving()
                if aura.lastFocus then
                    aura.lastFocus:ClearFocus()
                end
                mainFrame.time = 0
                mainFrame:SetScript("OnUpdate", function(self, time)
                    mainFrame.time = mainFrame.time + time
                    if mainFrame.time >= 0.2 then
                        mainFrame.time = 0
                        for _, f in ipairs(_G.BGA.Frames) do
                            if f.itemFrame.isOnEnter then
                                GameTooltip:Hide()
                                f.itemFrame:GetScript("OnEnter")(f.itemFrame)
                            end
                            if f.autoFrame:IsVisible() then
                                f.autoFrame:GetScript("OnShow")(f.autoFrame)
                            end
                        end
                    end
                end)
            end)

            f.cantClickFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
            f.cantClickFrame:SetAllPoints()
            f.cantClickFrame:SetFrameLevel(200)
            f.cantClickFrame:EnableMouse(true)
            C_Timer.After(.6, function()
                f.cantClickFrame:Hide()
            end)

            f.updateFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
            f.updateFrame:SetBackdrop({
                bgFile = "Interface/ChatFrame/ChatFrameBackground",
            })
            f.updateFrame:SetBackdropColor(1, 1, 1, .4)
            f.updateFrame:SetAllPoints()
            f.updateFrame:SetFrameLevel(150)
            f.updateFrame.alpha = .5
            f.updateFrame.totalTime = .4
            f.updateFrame:Hide()
            f.updateFrame:SetScript("OnShow", function(self)
                self.time = 0
                self:SetScript("OnUpdate", function(self, time)
                    self.time = self.time + time
                    local alpha = self.alpha - self.time / self.totalTime * self.alpha
                    if alpha < 0 then alpha = 0 end
                    self:SetAlpha(alpha)
                    f.autoFrame.updateFrame:SetAlpha(alpha)
                    if self:GetAlpha() <= 0 then
                        self:SetScript("OnUpdate", nil)
                        self:Hide()
                        f.autoFrame.updateFrame:Hide()
                    end
                end)
            end)
        end
        -- 自动出价
        do
            local f = CreateFrame("Frame", nil, AuctionFrame, "BackdropTemplate")
            do
                f:SetBackdrop({
                    bgFile = "Interface/ChatFrame/ChatFrameBackground",
                    edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                    edgeSize = aura.edgeSize,
                })
                f:SetBackdropColor(unpack(aura.backdropColor))
                f:SetBackdropBorderColor(unpack(aura.backdropBorderColor))
                f:SetSize(120, 73)
                f:EnableMouse(true)
                f:Hide()
                f.owner = AuctionFrame
                AuctionFrame.autoFrame = f
                f:SetScript("OnShow", function(self)
                    f:ClearAllPoints()
                    if aura.IsRight(self) then
                        f:SetPoint("BOTTOMRIGHT", AuctionFrame, "BOTTOMLEFT", 2, 0)
                    else
                        f:SetPoint("BOTTOMLEFT", AuctionFrame, "BOTTOMRIGHT", -2, 0)
                    end
                end)
                f:SetScript("OnMouseUp", function(self)
                    AuctionFrame:GetScript("OnMouseUp")(_G.BGA.AuctionMainFrame)
                end)
                f:SetScript("OnMouseDown", function(self)
                    AuctionFrame:GetScript("OnMouseDown")(_G.BGA.AuctionMainFrame)
                end)

                AuctionFrame.cantClickFrame.autoFrame = CreateFrame("Frame", nil, AuctionFrame.cantClickFrame, "BackdropTemplate")
                AuctionFrame.cantClickFrame.autoFrame:SetPoint("TOPLEFT", f, 0, 0)
                AuctionFrame.cantClickFrame.autoFrame:SetPoint("BOTTOMRIGHT", f, 0, 0)
                AuctionFrame.cantClickFrame.autoFrame:EnableMouse(true)
                C_Timer.After(.6, function()
                    AuctionFrame.cantClickFrame.autoFrame:Hide()
                end)

                f.updateFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
                f.updateFrame:SetBackdrop({
                    bgFile = "Interface/ChatFrame/ChatFrameBackground",
                })
                f.updateFrame:SetBackdropColor(1, 1, 1, .3)
                f.updateFrame:SetAllPoints()
                f.updateFrame:SetFrameLevel(150)
                f.updateFrame:Hide()
            end

            local t = f:CreateFontString()
            do
                t:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
                t:SetPoint("TOP", 0, -8)
                t:SetTextColor(1, 0.82, 0)
                t:SetText(L["设置心理价格"])
                AuctionFrame.autoTitleText = t
            end

            local edit = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
            do
                edit:SetSize(f:GetWidth() - 30, 20)
                edit:SetPoint("BOTTOM", 2, 27)
                edit:SetAutoFocus(false)
                edit:SetNumeric(true)
                edit.owner = AuctionFrame
                edit.alpha = .3
                AuctionFrame.autoMoney = 0
                AuctionFrame.autoMoneyEdit = edit
                edit:SetScript("OnTextChanged", aura.Auto_OnTextChanged)
                edit:SetScript("OnEnterPressed", aura.AutoButton_OnClick)
                edit:SetScript("OnEnter", aura.AutoEdit_OnEnter)
                edit:SetScript("OnLeave", aura.OnLeave)
                edit:SetScript("OnEditFocusGained", aura.OnEditFocusGained)

                local f = CreateFrame("Frame", nil, edit)
                f:SetPoint("RIGHT", 12, 2)
                f:SetSize(25, 25)
                f:Hide()
                AuctionFrame.isAutoTex = f
                local tex = f:CreateTexture()
                tex:SetAllPoints()
                tex:SetTexture("interface/raidframe/readycheck-ready")
                tex:SetAlpha(1)
            end

            local bt = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
            do
                bt:SetPoint("BOTTOM", 0, 5)
                bt:SetSize(f:GetWidth() - 20, 22)
                bt:SetText(L["开启自动出价"])
                bt:Disable()
                bt.owner = AuctionFrame
                AuctionFrame.autoButton = bt
                bt:SetScript("OnClick", aura.AutoButton_OnClick)

                local disf = CreateFrame("Frame", nil, AuctionFrame.autoButton)
                disf:SetAllPoints()
                disf:Hide()
                disf.dis = true
                disf.owner = AuctionFrame
                disf:SetScript("OnEnter", aura.AutoButton_OnEnter)
                disf:SetScript("OnLeave", GameTooltip_Hide)
                AuctionFrame.autoButton.disf = disf
            end
        end
        -- 操作
        do
            -- 折叠
            local bt = CreateFrame("Button", nil, AuctionFrame)
            bt:SetNormalFontObject(_G.BGA.FontGreen15)
            bt:SetHighlightFontObject(_G.BGA.FontWhite15)
            bt:SetDisabledFontObject(_G.BGA.FontDis15)
            bt:SetPoint("TOPRIGHT", -aura.edgeSize - 1, -2)
            bt:SetText(L["折叠"])
            bt:SetSize(bt:GetFontString():GetWidth(), 18)
            bt:SetFrameLevel(bt:GetParent():GetFrameLevel() + 15)
            bt.owner = AuctionFrame
            bt:SetScript("OnClick", aura.Hide_OnClick)
            bt:SetScript("OnEnter", aura.Hide_OnEnter)
            bt:SetScript("OnLeave", aura.OnLeave)
            AuctionFrame.hide = bt

            -- 取消拍卖
            local bt = CreateFrame("Button", nil, AuctionFrame)
            bt:SetNormalFontObject(_G.BGA.FontGreen15)
            bt:SetHighlightFontObject(_G.BGA.FontWhite15)
            bt:SetDisabledFontObject(_G.BGA.FontDis15)
            bt:SetPoint("TOPLEFT", aura.edgeSize + 60, -2)
            bt:SetText(L["取消拍卖"])
            bt:SetSize(bt:GetFontString():GetWidth(), 18)
            bt:RegisterForClicks("AnyUp")
            bt.owner = AuctionFrame
            bt:SetScript("OnClick", aura.Cancel_OnClick)
            bt:SetScript("OnEnter", aura.Cancel_OnEnter)
            bt:SetScript("OnLeave", GameTooltip_Hide)
            AuctionFrame.cancel = bt
            if aura.IsML() then
                bt:Show()
            else
                bt:Hide()
            end

            -- 自动出价
            local bt = CreateFrame("Button", nil, AuctionFrame)
            bt:SetNormalFontObject(_G.BGA.FontGreen15)
            bt:SetHighlightFontObject(_G.BGA.FontWhite15)
            bt:SetDisabledFontObject(_G.BGA.FontDis15)
            bt:SetText(L["自动出价"])
            bt:SetSize(bt:GetFontString():GetWidth(), 18)
            bt:RegisterForClicks("AnyUp")
            bt.owner = AuctionFrame
            AuctionFrame.autoTextButton = bt
            bt:SetScript("OnClick", aura.AutoText_OnClick)
            if aura.IsML() then
                bt:SetPoint("TOP", 45, -2)
            else
                bt:SetPoint("TOP", 0, -2)
            end

            -- 记录
            local bt = CreateFrame("Button", nil, AuctionFrame)
            bt:SetNormalFontObject(_G.BGA.FontGreen15)
            bt:SetHighlightFontObject(_G.BGA.FontWhite15)
            bt:SetDisabledFontObject(_G.BGA.FontDis15)
            bt:SetPoint("TOPLEFT", aura.edgeSize + 1, -2)
            bt:SetText(L["记录"])
            bt:SetSize(bt:GetFontString():GetWidth(), 18)
            bt.owner = AuctionFrame
            AuctionFrame.logTextButton = bt
            bt:SetScript("OnEnter", aura.LogTextButton_OnEnter)
            bt:SetScript("OnLeave", aura.LogTextButton_OnLeave)
        end
        -- 装备显示
        do
            local f = CreateFrame("Frame", nil, AuctionFrame, "BackdropTemplate")
            f:SetPoint("TOPLEFT", f:GetParent(), "TOPLEFT", aura.edgeSize + 1, -AuctionFrame.hide:GetHeight() - 3)
            f:SetPoint("BOTTOMRIGHT", f:GetParent(), "TOPRIGHT", -aura.edgeSize, -55)
            f:SetFrameLevel(f:GetParent():GetFrameLevel() + 10)
            f.owner = AuctionFrame
            f.itemID = itemID
            f.link = link
            f:SetScript("OnEnter", aura.itemOnEnter)
            f:SetScript("OnLeave", aura.itemOnLeave)
            f:SetScript("OnMouseUp", function(self)
                AuctionFrame:GetScript("OnMouseUp")(_G.BGA.AuctionMainFrame)
            end)
            f:SetScript("OnMouseDown", function(self)
                if IsShiftKeyDown() then
                    if not GetCurrentKeyBoardFocus() then
                        ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
                    end
                    ChatEdit_InsertLink(link)
                elseif IsControlKeyDown() then
                    DressUpItemLink(link)
                else
                    AuctionFrame:GetScript("OnMouseDown")(_G.BGA.AuctionMainFrame)
                end
            end)
            AuctionFrame.itemFrame = f
            local f2 = CreateFrame("Frame", nil, f)
            AuctionFrame.itemFrame2 = f2
            -- 黑色背景
            local tex = f:CreateTexture(nil, "BACKGROUND")
            tex:SetAllPoints()
            tex:SetColorTexture(0, 0, 0, 0.5)
            AuctionFrame.itemFrame.bg = tex
            -- 图标
            local r, g, b = GetItemQualityColor(quality)
            local ftex = CreateFrame("Frame", nil, f, "BackdropTemplate")
            ftex:SetBackdrop({
                edgeFile = "Interface/ChatFrame/ChatFrameBackground",
                edgeSize = 2,
            })
            ftex:SetBackdropBorderColor(r, g, b, 1)
            ftex:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
            ftex:SetPoint("BOTTOMRIGHT", f, "TOPLEFT", f:GetHeight(), -f:GetHeight())
            ftex.tex = ftex:CreateTexture(nil, "BACKGROUND")
            ftex.tex:SetAllPoints()
            ftex.tex:SetTexture(Texture)
            ftex.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            ftex.color = { r, g, b }
            AuctionFrame.itemFrame.iconFrame = ftex
            -- 装备等级
            local t = f2:CreateFontString()
            t:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
            t:SetPoint("BOTTOM", ftex, "BOTTOM", 0, 1)
            t:SetText(level)
            t:SetTextColor(r, g, b)
            AuctionFrame.itemFrame.levelText = t
            -- 装绑
            if bindType == 2 then
                local t = f2:CreateFontString()
                t:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                t:SetPoint("TOP", ftex, 0, -2)
                t:SetText(L["装绑"])
                t:SetTextColor(0, 1, 0)
                AuctionFrame.itemFrame.bindTypeText = t
            end
            -- 装备名称
            local t = f:CreateFontString()
            t:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
            t:SetPoint("TOPLEFT", ftex, "TOPRIGHT", 2, -2)
            t:SetWidth(f:GetWidth() - f:GetHeight() - 50)
            t:SetText(link:gsub("%[", ""):gsub("%]", ""))
            t:SetJustifyH("LEFT")
            t:SetWordWrap(false)
            AuctionFrame.itemFrame.itemNameText = t
            -- 已有
            if BG and BG.GetItemCount and BG.GetItemCount(itemID) ~= 0 or GetItemCount(itemID, true) ~= 0 then
                local tex = f2:CreateTexture(nil, 'ARTWORK')
                tex:SetSize(15, 15)
                tex:SetPoint('LEFT', t, 'LEFT', t:GetWrappedWidth(), 0)
                tex:SetTexture("interface/raidframe/readycheck-ready")
                AuctionFrame.itemFrame.havedTex = tex
            end
            -- 装备类型
            local t = f2:CreateFontString()
            t:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
            t:SetPoint("BOTTOMLEFT", ftex, "BOTTOMRIGHT", 2, 2)
            t:SetHeight(13)
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
            AuctionFrame.itemFrame.itemTypeText = t

            -- 倒计时条
            local s = CreateFrame("StatusBar", nil, f)
            s:SetPoint("TOPLEFT", ftex, "TOPRIGHT", 0, 0)
            s:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
            s:SetFrameLevel(s:GetParent():GetFrameLevel())
            s:SetStatusBarTexture("Interface/ChatFrame/ChatFrameBackground")
            s:SetStatusBarColor(1, 1, 0, 0.6)
            s:SetMinMaxValues(0, 1000)
            s.owner = AuctionFrame
            AuctionFrame.bar = s

            -- 剩余时间
            local remainingTime = f2:CreateFontString()
            remainingTime:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")
            remainingTime:SetPoint("RIGHT", f, "RIGHT", -5, 0)
            remainingTime:SetTextColor(1, 1, 1)
            AuctionFrame.remainingTime = remainingTime
        end
        -- 价格
        do
            local textwidth = 190
            local buttonwidth = 25
            local height = 22
            -- 当前价格
            local f = CreateFrame("Frame", nil, AuctionFrame)
            f:SetSize(textwidth, 20)
            f:SetPoint("TOPLEFT", AuctionFrame.itemFrame, "BOTTOMLEFT", 3, -3)
            f:SetScript("OnMouseDown", aura.currentMoney_OnMouseDown)
            f:SetScript("OnMouseUp", aura.currentMoney_OnMouseUp)
            f.owner = AuctionFrame
            local t = f:CreateFontString()
            t:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            t:SetAllPoints()
            t:SetJustifyH("LEFT")
            if player and player ~= "" then
                t:SetText(L["|cffFFD100当前价格：|r"] .. aura.FormatNumber(money))
                AuctionFrame.start = false
            else
                t:SetText(L["|cffFFD100起拍价：|r"] .. aura.FormatNumber(money))
                AuctionFrame.start = true
            end
            local currentMoneyText = f
            AuctionFrame.currentMoneyFrame = f
            AuctionFrame.currentMoneyText = t
            AuctionFrame.money = money
            -- 出价最高者
            local f = CreateFrame("Frame", nil, currentMoneyText)
            f:SetSize(textwidth, height)
            f:SetPoint("TOPLEFT", currentMoneyText, "BOTTOMLEFT", 0, 0)
            local t = f:CreateFontString()
            t:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            t:SetAllPoints()
            t:SetJustifyH("LEFT")
            if player then
                AuctionFrame.player = player
                AuctionFrame.colorplayer = aura.SetClassCFF(player)
            end
            if player and player ~= "" then
                if player == UnitName("player") then
                    t:SetText(L["|cffFFD100出价最高者：|r"] .. "|cff" .. aura.GREEN1 .. L[">> 你 <<"])
                    AuctionFrame:SetBackdropColor(unpack(aura.backdropColor_IsMe))
                    AuctionFrame:SetBackdropBorderColor(unpack(aura.backdropBorderColor_IsMe))
                    AuctionFrame.autoFrame:SetBackdropColor(unpack(aura.backdropColor_IsMe))
                    AuctionFrame.autoFrame:SetBackdropBorderColor(unpack(aura.backdropBorderColor_IsMe))
                else
                    if mod == "anonymous" then
                        t:SetText(L["|cffFFD100出价最高者：|r"] .. L["別人(匿名)"])
                    else
                        t:SetText(L["|cffFFD100出价最高者：|r"] .. AuctionFrame.colorplayer)
                    end
                    AuctionFrame:SetBackdropColor(unpack(aura.backdropColor))
                    AuctionFrame:SetBackdropBorderColor(unpack(aura.backdropBorderColor))
                    AuctionFrame.autoFrame:SetBackdropColor(unpack(aura.backdropColor))
                    AuctionFrame.autoFrame:SetBackdropBorderColor(unpack(aura.backdropBorderColor))
                end
            elseif mod == "anonymous" then
                t:SetText(L["|cffFFD100< 匿名模式 >|r"])
            end
            AuctionFrame.topMoneyFrame = f
            AuctionFrame.topMoneyText = t

            -- 输入框
            local edit = CreateFrame("EditBox", nil, currentMoneyText, "InputBoxTemplate")
            edit:SetSize(AuctionFrame:GetRight() - currentMoneyText:GetRight() - 3, 20)
            edit:SetPoint("TOPLEFT", currentMoneyText, "TOPRIGHT", 0, 0)
            edit:SetText(money)
            edit:SetAutoFocus(false)
            edit:SetNumeric(true)
            edit.owner = AuctionFrame
            edit:SetScript("OnTextChanged", aura.myMoney_OnTextChanged)
            edit:SetScript("OnEnterPressed", aura.SendMyMoney_OnClick)
            edit:SetScript("OnMouseWheel", aura.myMoney_OnMouseWheel)
            edit:SetScript("OnEnter", aura.myMoney_OnEnter)
            edit:SetScript("OnLeave", aura.OnLeave)
            edit:SetScript("OnEditFocusGained", aura.OnEditFocusGained)
            AuctionFrame.myMoneyEdit = edit
            -- 减
            local bt = CreateFrame("Button", nil, edit, "UIPanelButtonTemplate")
            bt:SetSize(buttonwidth, 22)
            bt:SetPoint("TOPLEFT", edit, "BOTTOMLEFT", -5, 0)
            bt:SetNormalFontObject(_G.BGA.FontGold18)
            bt:SetDisabledFontObject(_G.BGA.FontDis18)
            bt.owner = AuctionFrame
            bt.edit = edit
            bt._type = "-"
            bt:SetText(bt._type)
            bt:SetScript("OnMouseDown", aura.JiaJian_OnMouseDown)
            bt:SetScript("OnMouseUp", aura.JiaJian_OnMouseUp)
            bt:SetScript("OnClick", aura.JiaJian_OnClick)
            bt:SetScript("OnEnter", aura.JiaJian_OnEnter)
            bt:SetScript("OnLeave", aura.OnLeave)
            AuctionFrame.ButtonJian = bt
            -- 加
            local bt = CreateFrame("Button", nil, edit, "UIPanelButtonTemplate")
            bt:SetSize(buttonwidth, 22)
            bt:SetPoint("LEFT", AuctionFrame.ButtonJian, "RIGHT", 0, 0)
            bt:SetNormalFontObject(_G.BGA.FontGold18)
            bt:SetDisabledFontObject(_G.BGA.FontDis18)
            bt.owner = AuctionFrame
            bt.edit = edit
            bt._type = "+"
            bt:SetText(bt._type)
            bt:SetScript("OnMouseDown", aura.JiaJian_OnMouseDown)
            bt:SetScript("OnMouseUp", aura.JiaJian_OnMouseUp)
            bt:SetScript("OnClick", aura.JiaJian_OnClick)
            bt:SetScript("OnEnter", aura.JiaJian_OnEnter)
            bt:SetScript("OnLeave", aura.OnLeave)
            AuctionFrame.ButtonJia = bt
            -- 出价
            local bt = CreateFrame("Button", nil, edit, "UIPanelButtonTemplate")
            bt:SetPoint("TOPLEFT", AuctionFrame.ButtonJia, "TOPRIGHT", 0, 0)
            bt:SetPoint("BOTTOMRIGHT", edit, "BOTTOMRIGHT", 0, -height)
            bt:SetText(L["出价"])
            bt.owner = AuctionFrame
            bt.edit = edit
            bt.itemID = itemID
            AuctionFrame.ButtonSendMyMoney = bt
            bt:SetScript("OnClick", aura.SendMyMoney_OnClick)

            local f = CreateFrame("Frame", nil, bt)
            f:SetAllPoints()
            f:Hide()
            f.dis = true
            f.owner = AuctionFrame
            f:SetScript("OnEnter", aura.SendMyMoney_OnEnter)
            f:SetScript("OnLeave", GameTooltip_Hide)
            AuctionFrame.disf = f
            bt.disf = f

            aura.myMoney_OnTextChanged(AuctionFrame.myMoneyEdit)
        end

        aura.anim(AuctionFrame)
        aura.Auctioning(AuctionFrame, duration)

        if BG and BG.HookCreateAuction then
            BG.HookCreateAuction(AuctionFrame)
        end
    end

    aura.UpdateRaidRosterInfo()
    aura.GetAuctioningFromRaid()

    -- 主界面
    do
        local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        f:SetSize(aura.WIDTH, aura.HEIGHT)
        f:SetFrameStrata('HIGH')
        f:SetClampedToScreen(true)
        f:SetFrameLevel(100)
        f:SetToplevel(true)
        f:SetMovable(true)
        f:SetScale(BiaoGe and BiaoGe.options and BiaoGe.options["autoAuctionScale"] or 0.95)
        _G.BGA.AuctionMainFrame = f

        if _G.BiaoGe and _G.BiaoGe.point and _G.BiaoGe.point.Auction then
            _G.BiaoGe.point.Auction[2] = nil
            f:SetPoint(unpack(_G.BiaoGe.point.Auction))
        else
            f:SetPoint("TOPRIGHT", -100, -200)
        end
    end

    _G.BGA.Event = CreateFrame("Frame")
    _G.BGA.Event:RegisterEvent("CHAT_MSG_ADDON")
    _G.BGA.Event:RegisterEvent("GROUP_ROSTER_UPDATE")
    _G.BGA.Event:RegisterEvent("PLAYER_ENTERING_WORLD")
    _G.BGA.Event:RegisterEvent("MODIFIER_STATE_CHANGED")
    _G.BGA.Event:SetScript("OnEvent", function(self, event, ...)
        if event == "CHAT_MSG_ADDON" then
            local prefix, msg, distType, senderFullName = ...
            if prefix ~= aura.AddonChannel then return end
            local arg1, arg2, arg3, arg4, arg5, arg6, arg7 = strsplit(",", msg)
            local sender, realm = strsplit("-", senderFullName)
            if arg1 == "SendMyMoney" and distType == "RAID" then
                local auctionID = tonumber(arg2)
                local money = tonumber(arg3)
                for i, f in ipairs(_G.BGA.Frames) do
                    if not f.IsEnd and f.auctionID == auctionID then
                        if f.start then
                            if money >= f.money then
                                aura.SetMoney(f, money, sender)
                                return
                            end
                        elseif money > f.money then
                            aura.SetMoney(f, money, sender)
                            return
                        end
                    end
                end
            elseif arg1 == "StartAuction" and distType == "RAID" then
                local auctionID = tonumber(arg2)
                local itemID = tonumber(arg3)
                local money = tonumber(arg4)
                local duration = tonumber(arg5)
                local player = arg6
                local mod = arg7
                aura.CreateAuction(auctionID, itemID, money, duration, player, mod)

                if aura.IsRaidLeader() then
                    local tbl = {
                        normal = L["正常模式"],
                        anonymous = L["匿名模式"],
                    }

                    local _, link = GetItemInfo(itemID)
                    if link then
                        SendChatMessage(format(L["{rt1}拍卖开始{rt1} %s 起拍价：%s 拍卖时长：%ss %s"],
                            link, money, duration, (tbl[mod] and "<" .. tbl[mod] .. ">" or "")), "RAID_WARNING")
                    else
                        C_Timer.After(0.5, function()
                            local _, link = GetItemInfo(itemID)
                            if link then
                                SendChatMessage(format(L["{rt1}拍卖开始{rt1} %s 起拍价：%s 拍卖时长：%ss %s"],
                                    link, money, duration, (tbl[mod] and "<" .. tbl[mod] .. ">" or "")), "RAID_WARNING")
                            end
                        end)
                    end
                end
            elseif arg1 == "CancelAuction" and distType == "RAID" then
                local auctionID = tonumber(arg2)
                for i, f in ipairs(_G.BGA.Frames) do
                    if f.auctionID == auctionID and not f.IsEnd then
                        local t = f.itemFrame2:CreateFontString()
                        t:SetFont(STANDARD_TEXT_FONT, 30, "OUTLINE")
                        t:SetPoint("TOPRIGHT", f.itemFrame, "BOTTOMRIGHT", -10, -5)
                        t:SetText(L["拍卖取消"])
                        t:SetTextColor(1, 0, 0)

                        f.remainingTime:Hide()
                        f.bar:Hide()
                        f.IsEnd = true
                        f.myMoneyEdit:Hide()
                        f.cancel:Hide()

                        if aura.IsRaidLeader() then
                            SendChatMessage(format(L["{rt7}拍卖取消{rt7} %s"], f.link), "RAID")
                        end

                        C_Timer.After(aura.HIDEFRAME_TIME, function()
                            aura.UpdateFrame(f)
                        end)
                        return
                    end
                end
            elseif arg1 == "GetAuctioning" and distType == "RAID" and sender ~= UnitName("player") then
                for i, f in ipairs(_G.BGA.Frames) do
                    if (not f.IsEnd) and f.remaining and f.remaining >= 2 then
                        local text = "Auctioning" .. "," .. f.auctionID .. "," .. f.itemID .. "," .. f.money ..
                            "," .. (f.remaining) .. "," .. (f.player or "") .. "," .. (f.mod or "")
                        C_ChatInfo.SendAddonMessage(aura.AddonChannel, text, "WHISPER", senderFullName)
                    end
                end
            elseif arg1 == "Auctioning" and distType == "WHISPER" and sender ~= UnitName("player") then
                local auctionID = tonumber(arg2)
                local itemID = tonumber(arg3)
                local money = tonumber(arg4)
                local duration = tonumber(arg5)
                local player = arg6
                local mod = arg7

                for i, f in ipairs(_G.BGA.Frames) do
                    if f.auctionID == auctionID then
                        return
                    end
                end

                aura.CreateAuction(auctionID, itemID, money, duration, player, mod)
            elseif arg1 == "VersionCheck" and distType == "RAID" then
                C_ChatInfo.SendAddonMessage(aura.AddonChannel, "MyVer" .. "," .. aura.ver, "RAID")
            end
        elseif event == "GROUP_ROSTER_UPDATE" then
            C_Timer.After(0.5, function()
                aura.UpdateRaidRosterInfo()
            end)
        elseif event == "PLAYER_ENTERING_WORLD" then
            local isLogin, isReload = ...
            if not (isLogin or isReload) then return end
            C_Timer.After(0.5, function()
                aura.UpdateRaidRosterInfo()
            end)
            C_Timer.After(2, function()
                aura.GetAuctioningFromRaid()
            end)
        elseif event == "MODIFIER_STATE_CHANGED" then
            local mod, type = ...
            if (mod == "LCTRL" or mod == "RCTRL") then
                if type == 1 then
                    if aura.itemIsOnEnter then
                        SetCursor("Interface/Cursor/Inspect")
                    end
                else
                    SetCursor(nil)
                end
            end
        end
    end)
end)

--[[
/run C_ChatInfo.SendAddonMessage("BiaoGeAuction","StartAuction,"..GetTime()..",".."50011"..",".."5000"..",".."60","RAID")
 ]]
