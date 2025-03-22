local Env = select(2, ...)

local AceGUI = LibStub("AceGUI-3.0")

local UI = {}

local _frame
local _jsonbox
local _outputGenerator
local _outputGeneratorBags

local function OnClose(frame)
    AceGUI:Release(frame)
    _frame = nil
    _jsonbox = nil
end

local function CreateCopyDialog(text)
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("WSE Copy Dialog")
    frame:SetStatusText("Use CTRL+C to copy link")
    frame:SetLayout("Flow")
    frame:SetWidth(400)
    frame:SetHeight(100)
    frame:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
    end)

    local editbox = AceGUI:Create("EditBox")
    editbox:SetText(text)
    editbox:SetFullWidth(true)
    editbox:DisableButton(true)
    editbox:SetFocus()
    editbox:HighlightText()
    frame:AddChild(editbox)
end

---Create/show the main window.
---@param classIsSupported boolean If false then show class not supported info instead of export stuff.
---@param simLink string The URL to the (class/spec) sim to display.
function UI:CreateMainWindow(classIsSupported, simLink)
    if _frame then return end

    local frame = AceGUI:Create("Frame")
    frame:SetCallback("OnClose", OnClose)
    frame:SetTitle("WowSimsExporter V" .. Env.VERSION .. "")
    frame:SetStatusText("点击“生成数据”以生成可导出的数据")
    frame:SetLayout("Flow")
    _frame = frame

    local icon = AceGUI:Create("Icon")
    icon:SetImage("Interface\\AddOns\\wowsimsexporter\\Skins\\wowsims.tga")
    icon:SetImageSize(32, 32)
    icon:SetFullWidth(true)
    frame:AddChild(icon)

    local label = AceGUI:Create("Label")
    label:SetFullWidth(true)
    frame:AddChild(label)

    if not classIsSupported then
        label:SetText("Your characters class is currently unsupported. The supported classes are currently:\n" ..
            table.concat(Env.supportedClasses, "\n"))
        return
    end

    label:SetText([[

想要了解您当前角色的DPS极限吗？只需简单几步，即可通过模拟器精准测算！

1：下载并安装新手盒子：点击下方链接，完成安装。
2：打开WoWSimsCN模拟器：在热门工具箱中找WoWSimsCN模拟器，点击进入对应职业。
3：导入角色数据：点击“导入”按钮，选择“WSE插件”，将生成的装备属性数据粘贴到输入框中，点击“导入”即可。
4：开始模拟：系统将根据您的装备属性，自动计算出当前的DPS极限。

]])

    if simLink then
        local ilabel = AceGUI:Create("InteractiveLabel")
        ilabel:SetText("复制链接: " .. simLink .. "\r\n")
        ilabel:SetFullWidth(true)
        ilabel:SetCallback("OnClick", function()
            CreateCopyDialog(simLink)
        end)
        frame:AddChild(ilabel)
    end

    local button = AceGUI:Create("Button")
    button:SetText("生成数据(仅装备)")
    button:SetWidth(300)
    button:SetCallback("OnClick", function()
        if _outputGenerator then
            UI:SetOutput(_outputGenerator())
        end
    end)
    frame:AddChild(button)

    local extraButton = AceGUI:Create("Button")
    extraButton:SetText("批量:导出包项目")
    extraButton:SetWidth(300)
    extraButton:SetCallback("OnClick", function()
        if _outputGeneratorBags then
            UI:SetOutput(_outputGeneratorBags())
        end
    end)
    frame:AddChild(extraButton)

    local jsonbox = AceGUI:Create("MultiLineEditBox")
    jsonbox:SetLabel("复制生成的代码并粘贴到WoWSimsCN模拟器中！")
    jsonbox:SetFullWidth(true)
    jsonbox:SetFullHeight(true)
    jsonbox:DisableButton(true)
    frame:AddChild(jsonbox)

    _jsonbox = jsonbox
end

---Sets string in textbox.
---@param outputString string
function UI:SetOutput(outputString)
    if not _frame or not _jsonbox then return end
    _jsonbox:SetText(outputString)
    _jsonbox:HighlightText()
    _jsonbox:SetFocus()
    _frame:SetStatusText("Data Generated!")
end

---Set the function that is used to get the output value when
---pressing the character export button.
---@param func fun():string
function UI:SetOutputGenerator(func)
    _outputGenerator = func
end

---Set the function that is used to get the output value when
---pressing the bag items export button.
---@param func fun():string
function UI:SetOutputGeneratorBags(func)
    _outputGeneratorBags = func
end

Env.UI = UI
