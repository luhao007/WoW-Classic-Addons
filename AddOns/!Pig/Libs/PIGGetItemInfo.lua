local addonName, addonTable = ...;
local char=string.char
local sub = _G.string.sub
local gsub = _G.string.gsub
local match = _G.string.match
----
local Fun=addonTable.Fun

local GetItemInfo=GetItemInfo or C_Item and C_Item.GetItemInfo
--------------------
local Tooltip = CreateFrame("GameTooltip", "PIG_TooltipUI", UIParent, "GameTooltipTemplate")
Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
-----------------
local function GetItemLinkJJ(ItemLink)
    local msg = "";
    if ItemLink ~= nil then
        local ItemLink1 = ItemLink:match("\124Hitem:([%w:%-]+)\124h%[");
        if ItemLink1 then
            if ItemLink1:match("Player%-") then
                local Player1,Player2 = ItemLink1:match("([%w:]+)Player%-([%w%-]+:)");
            	local msgjj = Fun.yasuo_NumberString(Player1)
                msg=msgjj..":"
            else
                msg = Fun.yasuo_NumberString(ItemLink1)
            end
        end
    else
        msg="^" 
    end
    return msg;
end
Fun.GetItemLinkJJ=GetItemLinkJJ
function Fun.GetEquipmTXT(kaishi,jieshu)
    local kaishi,jieshu = kaishi or 1, jieshu or 19
    local msg = "";
    for slot = kaishi,jieshu do
        local item = GetInventoryItemLink("player", slot);
        local slotD = GetItemLinkJJ(item)
        if slot==jieshu then
            msg = msg..slot.."-"..slotD;
        else
            msg = msg..slot.."-"..slotD.."+";
        end
    end
    return msg;
end
local function HY_ItemLinkJJ(ItemJJ)
    local yes=ItemJJ:match("|cff%w%w%w%w%w%w|Hitem:")
    if yes then
        return ItemJJ
    else
        local Player
        if ItemJJ:match("Player%-") then
            local Player1,Player2 = ItemJJ:match("([%w:]+)Player%-([%w%-]+:)");
            ItemJJ=Player1
            Player="Player-"..Player2
        end
        local Itemhy = Fun.jieya_NumberString(ItemJJ)
        if Player then
            return "item:"..Itemhy..Player
        else
            return "item:"..Itemhy
        end
    end
end
Fun.HY_ItemLinkJJ=HY_ItemLinkJJ
function Fun.HY_EquipmTXT(msg)
    local Data = {}
    if msg and msg~="" then
        local list = {strsplit("+", msg)}
        for i=1,#list do
            local xuhao,link = strsplit("-", list[i])
            if link=="^" or link=="" then
                Data[tonumber(xuhao)]=nil
            else
                Data[tonumber(xuhao)]=HY_ItemLinkJJ(link)
            end
        end
    end
    return Data
end
---
local function HY_ShowItemLink(But,itemID,itemlin,New)
    if But and itemlin then
        if not New then But.zhixingnum=0 end
        local Linktxt=HY_ItemLinkJJ(itemlin)
        local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID=GetItemInfo(Linktxt);
        if itemLink then
            if But.itemID==itemID then
                But:ShowInfoFun(itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID)
            end
        else
            if not New then But.zhixingnum=0 end
            But.zhixingnum=But.zhixingnum+1
            if But:IsVisible() and But.zhixingnum<10 then
                C_Timer.After(0.04,function()
                    HY_ShowItemLink(But,itemID,itemlin,true)
                end)
            end
        end
    end
end
Fun.HY_ShowItemLink=HY_ShowItemLink
local function PIGShowItemLink(But,itemID,SetFun,New)  
    if But and itemID and SetFun then  
        local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID=GetItemInfo(itemID);
        if itemLink and itemQuality and itemTexture then
            if But.itemID==itemID then
                SetFun(itemLink,itemQuality,itemTexture,itemType,itemSubType,itemEquipLoc,classID, subclassID)
            end
        else
            if not New then But.zhixingnum=0 end
            But.zhixingnum=But.zhixingnum+1
            if But:IsVisible() and But.zhixingnum<10 then
                C_Timer.After(0.04,function()
                    PIGShowItemLink(But,itemID,SetFun,true)
                end)
            end
        end
    end
end
Fun.PIGShowItemLink=PIGShowItemLink
---60级探索符文
local pig_yasuo_2 = {
    [10]="_",[11]="=",[12]="(",[13]=")",[14]="[",[15]="]",[16]="{",[17]="}",
    [18]="<",[19]=">",[20]="?",[21]=",",[22]=".",[23]="~",[24]="`",
}
local pig_jieya_2 = {}
do
    local xuhao_2 = 25
    for asciiCode = string.byte('A'), string.byte('Z') do
        local char = char(asciiCode)
        pig_yasuo_2[xuhao_2]=char
        xuhao_2=xuhao_2+1
    end
    for asciiCode = string.byte('a'), string.byte('z') do
        local char = char(asciiCode)
        pig_yasuo_2[xuhao_2]=char
        xuhao_2=xuhao_2+1
    end
    for k,v in pairs(pig_yasuo_2) do
        pig_jieya_2[v]=k
    end
end
local function yasuo_NumberString_2(sss)
    local txtmsg = ""
    for i = 1, #sss, 2 do
        local str = sss:sub(i, i+1)
        local strnum = tonumber(str)
        if pig_yasuo_2[strnum] then
            txtmsg = txtmsg .. pig_yasuo_2[strnum]
        else
            txtmsg = txtmsg .. str
        end
    end
    return txtmsg
end

local function jieya_NumberString_2(sss)
    local txtmsg = ""
    for i = 1, #sss do
        local str = sss:sub(i, i)
        if pig_jieya_2[str] then
            txtmsg = txtmsg .. pig_jieya_2[str]
        else
            txtmsg = txtmsg .. str
        end
    end
    return txtmsg
end
local function GetRuneList(kaishi,jieshu)
    local DataList = {};
    if PIG_MaxTocversion(20000) then
        for slot = kaishi,jieshu do
            if C_Engraving and C_Engraving.IsEngravingEnabled() and C_Engraving.IsEquipmentSlotEngravable(slot) then
                local engravingInfo = C_Engraving.GetRuneForEquipmentSlot(slot);
                if(engravingInfo) then
                    DataList[slot]={engravingInfo.iconTexture,engravingInfo.skillLineAbilityID}
                end
            end
        end
    end
    return DataList;
end
function Fun.GetRuneData(kaishi,jieshu)
    local kaishi,jieshu = kaishi or 1, jieshu or 19
    return GetRuneList(kaishi,jieshu)
end

function Fun.GetRuneTXT(kaishi,jieshu)
    local msg = ""
    local kaishi,jieshu = kaishi or 1, jieshu or 19
    local data = GetRuneList(kaishi,jieshu)
    for k,v in pairs(data) do
        local vv1=yasuo_NumberString_2(tostring(v[1]))
        local vv2=yasuo_NumberString_2(tostring(v[2]))
        msg=msg.."+"..k..":"..vv1..":"..vv2
    end
    return msg
end
function Fun.HY_RuneTXT(msg)
    local Data = {} 
    if msg and msg~="" then
        local msg=msg:sub(2, -1)
        local list = {strsplit("+", msg)}
        for i=1,#list do
            local xuhao,icon,spell = strsplit(":", list[i])
            local icon=jieya_NumberString_2(icon)
            local spell=jieya_NumberString_2(spell)
            Data[tonumber(xuhao)]={icon,spell}
        end
    end
    return Data
end
-- SetCVar("alwaysShowRuneIcons","1")
-- print(GetCVar("alwaysShowRuneIcons"))
-- local PIGRuneList =  {"苦修","奥术冲击","活动炸弹"}
-- local function PIG_GetRuneInfo(sta)
--     local x = sta[1],sta[3]
--     for i=1,#PIGRuneList do
--         if sta[1]:match(PIGRuneList[i]) then--提取符文
--             print(sta[1],sta[3])
--             return 
--         end
--     end
-- end
-- local categories = C_Engraving.GetRuneCategories(true, true);
-- for _, category in ipairs(categories) do
--     local runes = C_Engraving.GetRunesForCategory(category, true);
--     for k,v in pairs(runes) do
--         print(k,v)
--         for kk,vv in pairs(v) do
--             print(kk,vv)
--         end
--     end
-- end