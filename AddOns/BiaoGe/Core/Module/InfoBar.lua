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

local Maxb = ns.Maxb
local Maxi = ns.Maxi

local pt = print
local realmID = GetRealmID()
local player = UnitName("player")
local realmName = GetRealmName()

--最后更新时间：25/3/18 22:00
local AFDtbl = {
    -- 1200
    "wlk怀旧-范沃森-Selendis",
    -- 600
    "露露缇娅",
    "陈",
    -- 360
    -- "",
    "卧龙草船借箭-龙牙",
    "依然不低调",
    "匕首岭-麻生成实",
    "Funny",
    "全能小霸王",
    "龙之召唤<破冰>粥糟-粥枣",
    -- 180
    -- "",
    "三藏骑猪",
    "光",
    "铁血II-书香",
    "铁血II-书香秘密",
    "寒脊山小径-起点-花舞",
    "霜语-丑死我了", -- 满心欢喜
    "伊梅尔达",
    "超级小奶爸",
    "水晶之牙-Rich Only",
    -- 90
    "超能力领域-展开",
    "小戆戆",
}
-- 30
local tbl = {
    -- "",
    -- "",
    -- "",
    -- "",
    -- "",
    -- "",
    -- "",
    -- "",
    -- "",
    -- "",
    -- "",
}
for _, name in ipairs(tbl) do
    tinsert(AFDtbl, name)
end

do
    local tbl = {
        "天天好快乐",
        "北执南念",
        "兜兜里好多糖",
        "萌城少年",
        "林栎熙",
        "Sakple",
        "satraxx",
        "猜猜",
        "zzzz。llll",
        "奈斯丶",
        "红石头",
        "毛哥",
        "奶油先生",
        "橘子棒冰",
        "范克瑞斯-钻石武力-夜月琉璃",
        "Venko",
        "猫猫",
        "Lin",
        "乘风随风",
        "jiang",
        "星河-堕落兵团-维希度斯",
        "智妍大姐姐",
        "阿多尼斯冰雪",
        "智妍大姐姐",
        "晚风",
        "yuuu",
        "tetelook",
        "加丁-KISS-Glivec",
        "Kayekiah",
        "BananaCream",
        "不吃牛蛙",
        "飞",
        "灰烬使者-天災公会",
        "银鞍照白马",
        "范克瑞斯-狮王之傲-丿路西法",
        "邵拉达",
        "大白",
        "yyf",
        "辛迪加<辛艾萨莉>小家猫卡琳娜",
        "xxx794665",
        "沙滩",
        "范克瑞斯-逝去的青春-丶黑炭",
        "那個尐仙",
        "不懂英语小明",
        "叶凡 - 龙牙",
        "Sr",
        "碧玉矿洞-八汤",
        "憋大招",
        "龙之召唤-天府一街",
        "灰烬使者部落-Revenger公会",
        "清华大学校草-无畏",
        "风涧",
        "大大大怪兽",
        "霜语-旺仔尛馒头（部落）",
        "严羽幻",
        "吉安娜-吕小骑",
        "橙贰胖-巴罗夫",
        "長門有希",
        "大鸟甩甩",
        "爱萝莉的格雷福斯",
        "<狮心>圣火喵喵教---阿壶金团",
        "我是读书人",
        "比格沃斯-面包",
        "咖啡",
        "欧黄",
        "DemonClin",
        "龙之召唤-不是芋圆",
        "Endearment",
        "糖果与火焰山-死亡猎手",
        "收藏家",
        "阡陌小熊",
        "肝坚强",
        "老年呆贼",
        "有才",
        "不再留恋",
        "拉萨",
        "青椒回锅肉",
        "匕首岭-冷疯-逐风工会",
        "硬汉-晨时微凉丶",
        "咩咩米",
        "奥金斧-Shameles",
        "千夕",
        "鸟窝",
        "Veda",
        "无畏-多拂朗明哥-PatrickStar",
        "安德",
        "夏天冷",
        "假寐的死神",
        "Choo",
        "遇见",
        "五郎八卦棍",
        "龙之召唤-轻舟",
        "抹茶慕斯-奥罗-白雪公主",
        "弑神死骑",
        "DarkAlexPPP",
        "狮心董卓",
        "萨弗拉斯-魔剑美神",
        "W",
        "漫漫",
        "lyl",
        "比格沃斯",
        "koy_czq",
        "HappyM0802",
        "龙之召唤-面包金团",
        "死亡猎手-memory",
        "makabakas",
        "斯内克",
        "灰烬使者-小手勾勾",
        "布朗熊",
        "老周不想取名",
        "埃提耶什-<夜宴>-正夏",
        "单脚跳",
        "霜语-猫空半日-萬神殿",
        "铁血-诺诺吖",
        "法尔班克斯-<骚年远征军>-雪见月十九",
        "水晶之牙-Equipo Octavo",
        "维系度斯-你看我牛牛吗",
        "关青龙",
        "灰灰丶",
        "好好学习",
        "吉安娜小蜡烛",
        "大栓",
        "兜兜里好多糖",
        "伽蓝",
        "龙之召唤-承筱诺",
        "龙之召唤-鼓励团结有爱",
        "龙之召唤-阿多尼斯冰雪",
        -- 没有名字
        L["以及多个没有留名的爱发电用户"],
    }
    for _, name in ipairs(tbl) do
        tinsert(AFDtbl, name)
    end
end


BG.Init(function()
    local lastBt
    local hight = 25
    -- 角色总览
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(20, hight)
        if lastBt then
            bt:SetPoint("RIGHT", lastBt, "LEFT", -10, 0)
        else
            bt:SetPoint("BOTTOMRIGHT", -10, 1)
        end
        bt:SetNormalFontObject(BG.FontYellow13)
        bt:SetHighlightFontObject(BG.FontWhite13)
        bt:SetText("|A:classicon-" .. string.lower(select(2, UnitClass("player"))) .. ":0:0|a" .. L["角色总览"])
        bt:SetWidth(bt:GetFontString():GetStringWidth())
        BG.ButtonRoleOverview = bt
        lastBt = bt
        bt:SetScript("OnEnter", function(self)
            BG.SetFBCD(self)
        end)
        bt:SetScript("OnLeave", function(self)
            if BG.FBCDFrame and not BG.FBCDFrame.click then
                BG.FBCDFrame:Hide()
            end
        end)
        bt:SetScript("OnMouseUp", function(self, button)
            if button == "LeftButton" then
                if IsControlKeyDown() then
                    BG.SetFBCD(nil, nil, true)
                end
            elseif button == "RightButton" then
                ns.InterfaceOptionsFrame_OpenToCategory("|cff00BFFFBiaoGe|r")
                BG.MainFrame:Hide()
            end
            BG.PlaySound(1)
        end)
    end

    -- 提交BUG
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(20, hight)
        if lastBt then
            bt:SetPoint("RIGHT", lastBt, "LEFT", -10, 0)
        else
            bt:SetPoint("BOTTOMRIGHT", -10, 1)
        end
        bt:SetNormalFontObject(BG.FontYellow13)
        bt:SetHighlightFontObject(BG.FontWhite13)
        bt.title = AddTexture("Interface\\AddOns\\BiaoGe\\Media\\icon\\icon") .. L["交流群"]
        bt.title2 = AddTexture("Interface\\AddOns\\BiaoGe\\Media\\icon\\icon") .. L["有报错！"]
        bt:SetText(bt.title)
        bt:SetWidth(bt:GetFontString():GetStringWidth())
        BG.ButtonBug = bt
        lastBt = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(L["BiaoGe沟通交流群"], 1, 1, 1, true)
            GameTooltip:AddLine(L["Q群："] .. "322785325", 1, 0.82, 0, true)
            GameTooltip:AddLine(L["密码：金团表格"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["（点击复制Q群）"], 1, 0.82, 0, true)
            GameTooltip:Show()

            if self.hasError then
                local e = self.errors
                local gameVer = GetBuildInfo()
                if BG.IsVanilla_Sod then
                    gameVer = gameVer .. " sod"
                end
                BiaoGeTooltip2:SetOwner(GameTooltip, "ANCHOR_TOPLEFT", 0, 0)
                BiaoGeTooltip2:ClearLines()
                BiaoGeTooltip2:AddLine(L["报错"], 1, 0, 0, true)
                BiaoGeTooltip2:AddLine(L["请你把该报错截图发给作者"], 1, 0.82, 0, true)
                BiaoGeTooltip2:AddLine(L["版本："] .. ns.ver, 1, 0.82, 0, true)
                BiaoGeTooltip2:AddLine(L["游戏："] .. gameVer, 1, 0.82, 0, true)
                BiaoGeTooltip2:AddLine(L["时间："] .. e.time, 1, 0.82, 0, true)
                BiaoGeTooltip2:AddLine(L["错误："] .. e.counter .. "x " .. e.message, .5, .5, .5, true)
                if e.stack then
                    BiaoGeTooltip2:AddLine(L["栈："] .. e.stack, .5, .5, .5, true)
                end
                BiaoGeTooltip2:Show()
            end
        end)
        bt:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
            BiaoGeTooltip2:Hide()
        end)
        bt:SetScript("OnClick", function(self)
            BG.PlaySound(1)
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            ChatEdit_ChooseBoxForSend():SetText("322785325")
            ChatEdit_ChooseBoxForSend():HighlightText()
        end)
        bt:SetScript("OnShow", function(self)
            BG.After(1, function()
                if BugGrabberDB and BugGrabberDB.errors then
                    for i, e in next, BugGrabberDB.errors do
                        if BugGrabberDB.session == e.session and e.message:find("BiaoGe") then
                            self.hasError = true
                            self.errors = {
                                time = e.time,
                                message = e.message,
                                stack = e.stack,
                                locals = e.locals,
                                counter = e.counter,
                            }
                            self:SetNormalFontObject(BG.FontRed13)
                            self:SetText(self.title2)
                            self:SetScript("OnShow", nil)
                            BG.MainFrame.ErrorText:SetText(L["插件加载错误，请查看右下角的红字报错，把报错内容截图发给作者，谢谢。（Q群：322785325，密码：金团表格）"])
                            break
                        end
                    end
                end
            end)
        end)
    end

    -- 更新计划
    --[[     do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(20, hight)
        if lastBt then
            bt:SetPoint("RIGHT", lastBt, "LEFT", -10, 0)
        else
            bt:SetPoint("BOTTOMRIGHT", -10, 1)
        end
        bt:SetNormalFontObject(BG.FontYellow13)
        bt:SetHighlightFontObject(BG.FontWhite13)
        bt:SetText("|A:Class:15:15|a" .. L["更新计划"])
        bt:SetWidth(bt:GetFontString():GetStringWidth())
        BG.ButtonUpdateLate = bt
        lastBt = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(self:GetText(), 1, 1, 1, true)
            GameTooltip:AddLine(L["BiaoGe插件未来的更新计划共享在在线文档。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["你可以浏览该内容，留下你的建议。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["（点击复制文档地址）"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)
        bt:SetScript("OnLeave", GameTooltip_Hide)
        bt:SetScript("OnClick", function(self)
            BG.PlaySound(1)
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            ChatEdit_ChooseBoxForSend():SetText("https://docs.qq.com/doc/DYVFDaU5uR21sanJm")
            ChatEdit_ChooseBoxForSend():HighlightText()
        end)
    end ]]

    -- 爱发电
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(20, hight)
        if lastBt then
            bt:SetPoint("RIGHT", lastBt, "LEFT", -10, 0)
        else
            bt:SetPoint("BOTTOMRIGHT", -10, 1)
        end
        bt:SetNormalFontObject(BG.FontYellow13)
        bt:SetHighlightFontObject(BG.FontWhite13)
        bt:SetText(AddTexture("Interface\\AddOns\\BiaoGe\\Media\\icon\\AFD") .. L["爱发电"])
        bt:SetWidth(bt:GetFontString():GetStringWidth())
        bt.maxLine = 40
        BG.ButtonAFD = bt
        lastBt = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(self:GetText(), 1, 1, 1, true)
            GameTooltip:AddLine(L["感谢以下玩家的发电："], 1, 1, 1, true)
            local text = ""
            for i, name in ipairs(AFDtbl) do
                if name:find(realmName, 1, true) then
                    name = BG.STC_g1(name)
                end
                if i == #AFDtbl then
                    text = text .. name
                else
                    text = text .. name .. BG.STC_dis("，")
                end
            end
            GameTooltip:AddLine(text, 1, 0.82, 0, true)
            GameTooltip:AddLine(L["你可以在这里订阅我的账号苍穹之霜，提前体验订阅模块和同步模块。"], 1, 1, 1, true)
            GameTooltip:AddLine(L["（点击复制网址）"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)
        bt:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
            BiaoGeTooltip2:Hide()
        end)
        bt:SetScript("OnClick", function(self)
            BG.PlaySound(1)
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            ChatEdit_ChooseBoxForSend():SetText("https://afdian.com/a/wow_biaoge")
            ChatEdit_ChooseBoxForSend():HighlightText()
        end)
    end

    -- 网易DD
    --[[     do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(20, hight)
        if lastBt then
            bt:SetPoint("RIGHT", lastBt, "LEFT", -10, 0)
        else
            bt:SetPoint("BOTTOMRIGHT", -10, 1)
        end
        bt:SetNormalFontObject(BG.FontYellow13)
        bt:SetHighlightFontObject(BG.FontWhite13)
        bt:SetText(AddTexture("DD") .. L["网易DD"])
        bt:SetWidth(bt:GetFontString():GetStringWidth())
        BG.ButtonDD = bt
        lastBt = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(self:GetText(), 1, 1, 1, true)
            GameTooltip:AddLine(L["官方插件平台"], 1, 1, 1, true)
            GameTooltip:AddLine(L["集插件管理、配置分享、云端备份、团队语音于一体。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["你可以在这里更新BiaoGe插件。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["（点击复制网址）"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)
        bt:SetScript("OnLeave", GameTooltip_Hide)
        bt:SetScript("OnClick", function(self)
            BG.PlaySound(1)
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            ChatEdit_ChooseBoxForSend():SetText("https://dd.163.com/?utm_source=112231")
            ChatEdit_ChooseBoxForSend():HighlightText()
        end)
    end ]]

    -- 新手盒子
    do
        local bt = CreateFrame("Button", nil, BG.MainFrame)
        bt:SetSize(20, hight)
        if lastBt then
            bt:SetPoint("RIGHT", lastBt, "LEFT", -10, 0)
        else
            bt:SetPoint("BOTTOMRIGHT", -10, 1)
        end
        bt:SetNormalFontObject(BG.FontYellow13)
        bt:SetHighlightFontObject(BG.FontWhite13)
        bt:SetText(AddTexture("BOX") .. L["新手盒子"])
        bt:SetWidth(bt:GetFontString():GetStringWidth())
        BG.ButtonBOX = bt
        lastBt = bt

        bt:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
            GameTooltip:ClearLines()
            GameTooltip:AddLine(self:GetText(), 1, 1, 1, true)
            GameTooltip:AddLine(L["集插件管理、配置分享、云端备份、游戏攻略、游戏工具于一体。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["你可以在这里更新BiaoGe插件。"], 1, 0.82, 0, true)
            GameTooltip:AddLine(L["你可以在这里订阅我的账号苍穹之霜，提前体验订阅模块和同步模块。"], 1, 1, 1, true)
            GameTooltip:AddLine(L["（点击复制网址）"], 1, 0.82, 0, true)
            GameTooltip:Show()
        end)
        bt:SetScript("OnLeave", GameTooltip_Hide)
        bt:SetScript("OnClick", function(self)
            BG.PlaySound(1)
            ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
            ChatEdit_ChooseBoxForSend():SetText("https://www.wclbox.com/")
            ChatEdit_ChooseBoxForSend():HighlightText()
        end)
    end
end)
