local addonName, addonTable = ...;
--local _, _, _, tocversion = GetBuildInfo()
local L =addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGFontString=Create.PIGFontString
----
local Fun = addonTable.Fun
-------------
local julidi = -26
local ExportImportUI=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{800, 600},"ExportImport_UI",true)
ExportImportUI:PIGSetBackdrop(1)
ExportImportUI:PIGSetMovable()
ExportImportUI:PIGClose()
ExportImportUI:SetFrameStrata("HIGH")
ExportImportUI:SetFrameLevel(999);
ExportImportUI.biaoti=PIGFontString(ExportImportUI,{"TOP", ExportImportUI, "TOP", 0, -3})
PIGLine(ExportImportUI,"TOP",-20,1,{-1,-1})
---
local daoruTXT,daochuTXT = L["CONFIG_IMPORT"],L["CONFIG_DERIVE"]
ExportImportUI.tishitxt = PIGFontString(ExportImportUI,{"TOPLEFT",ExportImportUI,"TOPLEFT",10,julidi-2},daochuTXT)
ExportImportUI.tishitxt:SetTextColor(0, 1, 0, 1);
ExportImportUI.daoruBut = PIGButton(ExportImportUI,{"TOPLEFT",ExportImportUI,"TOPLEFT",540,julidi},{100,20},L["CONFIG_DERIVERL"])
ExportImportUI.daoruBut:Hide();
ExportImportUI.daoruBut:SetScript("OnClick", function(self)
	ExportImportUI:daoruFun_1(ExportImportUI.NR.textArea:GetText())
end)
ExportImportUI.daoruButErr=PIGFontString(ExportImportUI.daoruBut,{"RIGHT",ExportImportUI.daoruBut,"LEFT",-4,0})
ExportImportUI.daoruButErr:SetTextColor(1, 0, 0, 1)
ExportImportUI.zifunumt=PIGFontString(ExportImportUI,{"TOPRIGHT",ExportImportUI,"TOPRIGHT",-60,julidi-2},"字符数:")
ExportImportUI.zifunumt:SetTextColor(1, 1, 1, 0.4)
ExportImportUI.zifunumV=PIGFontString(ExportImportUI,{"LEFT", ExportImportUI.zifunumt, "RIGHT", 0, 0},0)
ExportImportUI.zifunumV:SetTextColor(1, 1, 1, 0.4)
ExportImportUI.Line2 =PIGLine(ExportImportUI,"TOP",-50,1,{-1,-1})
ExportImportUI.NR=PIGFrame(ExportImportUI)
ExportImportUI.NR:SetPoint("TOPLEFT", ExportImportUI.Line2, "TOPLEFT", 4, -4)
ExportImportUI.NR:SetPoint("BOTTOMRIGHT", ExportImportUI, "BOTTOMRIGHT", -4, 4)
ExportImportUI.NR:PIGSetBackdrop()
ExportImportUI.NR.scroll = CreateFrame("ScrollFrame", nil, ExportImportUI.NR, "UIPanelScrollFrameTemplate")
ExportImportUI.NR.scroll:SetPoint("TOPLEFT", ExportImportUI.NR, "TOPLEFT", 6, -6)
ExportImportUI.NR.scroll:SetPoint("BOTTOMRIGHT", ExportImportUI.NR, "BOTTOMRIGHT", -26, 6)

ExportImportUI.NR.textArea = CreateFrame("EditBox", nil, ExportImportUI.NR.scroll)
ExportImportUI.NR.textArea:SetFontObject(ChatFontNormal);
ExportImportUI.NR.textArea:SetWidth(ExportImportUI.NR:GetWidth()-40)
ExportImportUI.NR.textArea:SetMultiLine(true)
ExportImportUI.NR.textArea:SetMaxLetters(99999)
ExportImportUI.NR.textArea:EnableMouse(true)
ExportImportUI.NR.textArea:SetScript("OnEscapePressed", function(self)
	self:ClearFocus()
	ExportImportUI:Hide();
end)
ExportImportUI.NR.textArea:SetScript("OnTextChanged", function(self)
	local NdataT = self:GetText()
	local NdataT = NdataT:gsub("%s+", "")
	ExportImportUI.zifunumV:SetText(#NdataT)
	if NdataT=="" then
		ExportImportUI.daoruBut:Disable()
	else
		ExportImportUI.daoruBut:Enable()
	end
end)
ExportImportUI.NR.scroll:SetScrollChild(ExportImportUI.NR.textArea)
---
local versions,versionsV = "!P","01"
local function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            result = result .. '["' .. k .. '"]='
        else
            result = result .. '[' .. tostring(k) .. ']='
        end
        if type(v) == "table" then
            result = result .. table_to_string(v)
        elseif type(v) == "boolean" then
            result = result .. tostring(v)
        elseif type(v) == "string" then
            result = result .. '"' .. v .. '"'
        else
            result = result .. tostring(v)
        end
        result = result .. ","
    end
    return result .. "}"
end
function ExportImportUI:daochuFun(lyname,str)
	local lyname = L["CONFIG_DAOCHU"]..lyname
	self.biaoti:SetText(lyname)
	local NdataT = table_to_string(str)
	local NdataT = NdataT:gsub(",}", "}")
	local NdataT = NdataT:gsub("%s+", "")
	local NdataT = Fun.yasuo_string(NdataT)
	local NdataT = versions..versionsV..Fun.Base64_encod(NdataT)
	self.NR.textArea:SetText(NdataT)
	self.NR.textArea:HighlightText()
	self.daoruBut:Hide()
	self:Show()
end
local function deserialize(str)
    local func, err = loadstring("return " .. str)
    if not func then
        error("无效的字符串: " .. err)
    end
    return func()
end
function ExportImportUI:daoruFun(lyname,daoruyuan)
	self.daoruyuan=daoruyuan
	local lyname = L["CONFIG_DAORU"]..lyname
	self.biaoti:SetText(lyname)
	self.daoruButErr:SetText("")
	self.NR.textArea:SetText("")
	self.daoruBut:Show()
	self:Show()
end
function ExportImportUI:daoruFun_1(str)
	local vn = str:sub(1,2)
	if vn==versions then
		local vv = str:sub(3,4)
		if tonumber(vv)<tonumber(versionsV) then
			self.daoruButErr:SetText("此"..addonName.."字符串已过期")
		else
			local NdataT = str:sub(5)
			local NdataT = Fun.Base64_decod(NdataT)
			local NdataT = Fun.jieya_string(NdataT)
			local NdataT = deserialize(NdataT)
			for k,v in pairs(NdataT) do
				print(k,v)
				for kk,vv in pairs(v) do
					print(k,kk,vv)
				end
			end
			--print(#NdataT["Other"]["AFK"])
			-- for k1,v1 in pairs(NdataT["Other"]["AFK"]) do
			-- 	print("FFFF",k1,v1)
			-- end
			-- for k,v in pairs(PIGA["Other"]["AFK"]) do
			-- 	--print(k,v)
			-- end
			--self.daoruyuan
		end
	else
		self.daoruButErr:SetText("请导入"..addonName..ADDONS.."字符串")
	end
end
--去除和默认相同
local function removeMatchingKeyValues(fromTable, toCompareTable)
    for key, value in pairs(toCompareTable) do
        if fromTable[key] ~= nil then
            if type(value) == "table" and type(fromTable[key]) == "table" then
                local isNonKeyValueTable = true
                for k in pairs(value) do
                    if type(k) ~= "number" or k ~= math.floor(k) or k > #value then
                        isNonKeyValueTable = false
                        break
                    end
                end

                if isNonKeyValueTable then
                    for i, v in ipairs(value) do
                        for j, fv in ipairs(fromTable[key]) do
                            if v == fv then
                                table.remove(fromTable[key], j)
                                break
                            end
                        end
                    end
                    if #fromTable[key] == 0 then
                        fromTable[key] = nil
                    end
                else
                    removeMatchingKeyValues(fromTable[key], value)
                    if next(fromTable[key]) == nil then
                        fromTable[key] = nil
                    end
                end
            elseif fromTable[key] == value then
                fromTable[key] = nil
            end
        end
    end
end
function ExportImportUI.PIGCopyTable_Duplicates(old,duibi)
	removeMatchingKeyValues(old,duibi)
	for k,v in pairs(old) do
		print(k,v)
	end
	return old
end

----
ExportImportUI.Clear = PIGButton(ExportImportUI,{"TOPRIGHT",ExportImportUI,"TOPLEFT",-4,julidi},{70,22},"Clear")
ExportImportUI.Clear:SetScript("OnClick", function (self)
	ExportImportUI.NR.textArea:SetText("")
end)
ExportImportUI.Copy = PIGButton(ExportImportUI,{"TOP",ExportImportUI.Clear,"BOTTOM",0,-10},{70,22},"select all")
ExportImportUI.Copy:SetScript("OnClick", function (self)
	ExportImportUI.NR.textArea:HighlightText()
end)
ExportImportUI.zhunma = PIGButton(ExportImportUI,{"TOP",ExportImportUI.Copy,"BOTTOM",0,-10},{70,22},"cmd_1")
ExportImportUI.zhunma:SetScript("OnClick", function (self)
	local data = ExportImportUI.NR.textArea:GetText()
	local Ndata = Fun.Base64_encod(data)
	ExportImportUI.NR.textArea:SetText(Ndata)
end)
ExportImportUI.huanyuan = PIGButton(ExportImportUI,{"TOP",ExportImportUI.zhunma,"BOTTOM",0,-10},{70,22},"cmd_2")
ExportImportUI.huanyuan:SetScript("OnClick", function (self)
	local data = ExportImportUI.NR.textArea:GetText()
	local Ndata = Fun.Base64_decod(data)
	ExportImportUI.NR.textArea:SetText(Ndata)
end)