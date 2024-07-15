local _, addonTable = ...;
local L=addonTable.locale
local floor =floor
local Fun=addonTable.Fun
----------
local Create=addonTable.Create
local PIGEnter=Create.PIGEnter
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGFontStringBG=Create.PIGFontStringBG
--
local fuFrame = PIGOptionsList(L["DEBUG_TABNAME"],"BOT")
--------------------------------
fuFrame.errorUI = PIGButton(fuFrame,{"TOPLEFT",fuFrame,"TOPLEFT",20,-20},{120,24},L["DEBUG_ERRORLOG"])
fuFrame.errorUI:SetScript("OnClick", function (self)
	Pig_OptionsUI:Hide()
	Bugcollect_UI:Show()
end);
--
fuFrame.tishi =PIGFontString(fuFrame,{"LEFT", fuFrame.errorUI, "RIGHT", 10, 0},L["DEBUG_OPENERRORLOGCMD"].."/per")
fuFrame.tishi:SetTextColor(1, 1, 0, 1);
---------
fuFrame.ErrCB=PIGCheckbutton(fuFrame,{"LEFT",fuFrame.errorUI,"RIGHT", 200, 0},{SHOW_LUA_ERRORS,L["DEBUG_SCRIPTTOOLTIP"]})
fuFrame.ErrCB:SetScript("OnClick", function (self)
	if self:GetChecked() then
		SetCVar("scriptErrors", "1")
	else
		SetCVar("scriptErrors", "0")
	end
end);
---
local taintlist = {"0","1","2","11"}
local taintlistmenu = {["0"]=L["DEBUG_TAINT0"],["1"]=L["DEBUG_TAINT1"],
	["2"]=L["DEBUG_TAINT2"],["11"]=L["DEBUG_TAINT11"],
}
fuFrame.taintLog=PIGDownMenu(fuFrame,{"TOPLEFT",fuFrame.errorUI,"BOTTOMLEFT",60,-40},{400,24})
fuFrame.taintLog.tishi=PIGFontString(fuFrame.taintLog,{"RIGHT", fuFrame.taintLog, "LEFT", 0, 0},L["DEBUG_TAINTLOG"])
fuFrame.taintLog.tishi:SetTextColor(1, 1, 0, 1);
function fuFrame.taintLog:PIGDownMenu_Update_But(self)
	local info = {}
	info.func = self.PIGDownMenu_SetValue
	for i=1,#taintlist,1 do
	    info.text, info.arg1 = taintlistmenu[taintlist[i]], taintlist[i]
	    info.checked = taintlist[i]==GetCVar("taintLog")
		fuFrame.taintLog:PIGDownMenu_AddButton(info)
	end 
end
function fuFrame.taintLog:PIGDownMenu_SetValue(value,arg1,arg2)
	fuFrame.taintLog:PIGDownMenu_SetText(value)
	SetCVar("taintLog", arg1)
	PIGCloseDropDownMenus()
end
--內存CPU监控
fuFrame.OPENJK = PIGButton(fuFrame,{"TOPLEFT",fuFrame,"TOPLEFT",20,-200},{150,24},L["DEBUG_BUTNAME"])
fuFrame.OPENJK:SetScript("OnClick", function (self)
	Pig_OptionsUI:Hide()
	AddOnCPU_UI:Show()
end);
SetCVar("scriptProfile", 0)--默认关闭cpu監控
local AddOnCPU=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{360,494},"AddOnCPU_UI",true)
AddOnCPU:PIGSetBackdrop()
AddOnCPU:PIGSetMovable()
AddOnCPU:PIGClose()
AddOnCPU.biaoti=PIGFontString(AddOnCPU,{"TOP", AddOnCPU, "TOP", 0, -4},L["DEBUG_BUTNAME"])
PIGLine(AddOnCPU,"TOP",-20)
--
AddOnCPU.sort=21--排序
local hang_Height,hang_NUM  = 22, 18;
local function Get_AddOnData()
	AddOnCPU.AddOnData={}
	AddOnCPU.NumAddOns=0
	AddOnCPU.NumMemory=0
	AddOnCPU.NumCPU="N/A"
	UpdateAddOnMemoryUsage()
	if GetCVar("scriptProfile")=="1" then
		UpdateAddOnCPUUsage()
		AddOnCPU.NumCPU=0
	end
	local addhejinum = GetNumAddOns()
	AddOnCPU.NumAddOns=addhejinum
	for id=1,addhejinum do	
		local name=GetAddOnInfo(id)
		local Memory=GetAddOnMemoryUsage(id)
		local adddata = {name,floor(Memory),"N/A",false}
		AddOnCPU.NumMemory=AddOnCPU.NumMemory+Memory
		if GetCVar("scriptProfile")=="1" then
			local CPUUsage=GetAddOnCPUUsage(id)
			adddata[3]=floor(CPUUsage)
			AddOnCPU.NumCPU=AddOnCPU.NumCPU+CPUUsage
		end
		table.insert(AddOnCPU.AddOnData,adddata)
		if IsAddOnLoaded(id) then
			adddata[4]=true
		end
	end
	AddOnCPU.NumMemory=floor(AddOnCPU.NumMemory)
	if GetCVar("scriptProfile")=="1" then
		AddOnCPU.NumCPU=floor(AddOnCPU.NumCPU)
	end
end
local function AddOn_Update(self)
	for id=1,hang_NUM do
		_G["AddOnCPU_"..id]:Hide()
	end
	local shujuheji=AddOnCPU.AddOnData
	if AddOnCPU.sort==21 then
		table.sort(shujuheji,function(a,b)
			return a[2]>b[2]
		end)
	elseif AddOnCPU.sort==31 then
		table.sort(shujuheji,function(a,b)
			return a[3]>b[3]
		end)
	end
	FauxScrollFrame_Update(self, #shujuheji, hang_NUM, hang_Height);
	local offset = FauxScrollFrame_GetOffset(self);
	for id=1,hang_NUM do
		local dangqianID = id+offset
		if shujuheji[dangqianID] then
			local tetf = _G["AddOnCPU_"..id]
			tetf:Show()

			tetf.tet1:SetText(shujuheji[dangqianID][1]);
			if shujuheji[dangqianID][4] then
				tetf.tet1:SetTextColor(0, 1, 0, 1)
			else
				tetf.tet1:SetTextColor(0.5, 0.5, 0.5, 1)
			end
			tetf.tet2:SetText(shujuheji[dangqianID][2]);
			tetf.tet3:SetText(shujuheji[dangqianID][3]);
		end
	end
	AddOnCPU.NR.buttet1:SetText(AddOnCPU.NumAddOns..L["DEBUG_ADDNUM"]);
	AddOnCPU.NR.buttet2:SetText(AddOnCPU.NumMemory.."k");
	AddOnCPU.NR.buttet3:SetText(AddOnCPU.NumCPU.."ms");
end
AddOnCPU.NR=PIGFrame(AddOnCPU)
AddOnCPU.NR:SetPoint("TOPLEFT", AddOnCPU, "TOPLEFT", 4, -70)
AddOnCPU.NR:SetPoint("BOTTOMRIGHT", AddOnCPU, "BOTTOMRIGHT", -4, 24)
AddOnCPU.NR:PIGSetBackdrop()
local nrww = AddOnCPU.NR:GetWidth()
AddOnCPU.NR.tet1=PIGFontStringBG(AddOnCPU.NR,{"BOTTOMLEFT", AddOnCPU.NR, "TOPLEFT", 0,-1},L["DEBUG_ADD"],{nrww*0.5,22})
AddOnCPU.NR.tet2 = PIGButton(AddOnCPU.NR,{"LEFT", AddOnCPU.NR.tet1, "RIGHT", 0,0},{nrww*0.25,22},L["DEBUG_MEMORY"].."(k)")
AddOnCPU.NR.tet2:SetScript("OnClick", function ()
	AddOnCPU.sort=21
	AddOn_Update(AddOnCPU.NR.Scroll)
end);
AddOnCPU.NR.tet3 = PIGButton(AddOnCPU.NR,{"LEFT", AddOnCPU.NR.tet2, "RIGHT", 0,0},{nrww*0.25,22},"CPU(ms)")
AddOnCPU.NR.tet3:SetScript("OnClick", function ()
	if GetCVar("scriptProfile")=="1" then
		AddOnCPU.sort=31
		AddOn_Update(AddOnCPU.NR.Scroll)
	end
end);
AddOnCPU.NR.buttet1=PIGFontStringBG(AddOnCPU.NR,{"TOPLEFT", AddOnCPU.NR, "BOTTOMLEFT", 0,1},"",{nrww*0.5,22})
AddOnCPU.NR.buttet2=PIGFontStringBG(AddOnCPU.NR,{"LEFT", AddOnCPU.NR.buttet1, "RIGHT", 0,0},"",{nrww*0.25,22})
AddOnCPU.NR.buttet3=PIGFontStringBG(AddOnCPU.NR,{"LEFT", AddOnCPU.NR.buttet2, "RIGHT", 0,0},"",{nrww*0.25,22})
AddOnCPU.NR.Scroll = CreateFrame("ScrollFrame",nil,AddOnCPU.NR, "FauxScrollFrameTemplate");  
AddOnCPU.NR.Scroll:SetPoint("TOPLEFT",AddOnCPU.NR,"TOPLEFT",0,-1);
AddOnCPU.NR.Scroll:SetPoint("BOTTOMRIGHT",AddOnCPU.NR,"BOTTOMRIGHT",-24,1);
AddOnCPU.NR.Scroll:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, AddOn_Update)
end)

for id = 1, hang_NUM do
	local hang = CreateFrame("Frame", "AddOnCPU_"..id, AddOnCPU.NR.Scroll:GetParent());
	hang:SetSize(AddOnCPU.NR:GetWidth()-24, hang_Height);
	if id==1 then
		hang:SetPoint("TOP",AddOnCPU.NR.Scroll,"TOP",0,0);
	else
		hang:SetPoint("TOP",_G["AddOnCPU_"..(id-1)],"BOTTOM",0,0);
	end
	hang.tet1 = PIGFontString(hang,{"LEFT", hang, "LEFT", 2,0})
	hang.tet1:SetSize(nrww*0.5-2,hang_Height)
	hang.tet1:SetJustifyH("LEFT")
	hang.tet2 = PIGFontString(hang,{"LEFT", hang.tet1, "RIGHT", 2,0})
	hang.tet2:SetSize(nrww*0.25-2,hang_Height)
	hang.tet2:SetJustifyH("LEFT")
	hang.tet3 = PIGFontString(hang,{"LEFT", hang.tet2, "RIGHT", 2,0})
	hang.tet3:SetSize(nrww*0.25-2,hang_Height)
	hang.tet3:SetJustifyH("LEFT")
end
AddOnCPU.NR:SetScript("OnShow", function (self)
	Get_AddOnData()
	AddOn_Update(AddOnCPU.NR.Scroll)
end);
AddOnCPU.CPU_OPEN=PIGCheckbutton(AddOnCPU,{"TOPLEFT",AddOnCPU,"TOPLEFT",6,-21},{L["DEBUG_CPUUSAGE"],L["DEBUG_CPUUSAGETIPS"]})
AddOnCPU.CPU_OPEN:SetScript("OnClick", function (self)
	if self:GetChecked() then
		SetCVar("scriptProfile", "1")
	else
		SetCVar("scriptProfile", "0")
	end
	Get_AddOnData()
	AddOn_Update(AddOnCPU.NR.Scroll)
end);
AddOnCPU.shuaxin = PIGButton(AddOnCPU,{"TOPLEFT",AddOnCPU,"TOPLEFT",130,-25},{60,20},L["DEBUG_REFRESH"])
AddOnCPU.shuaxin:SetScript("OnClick", function (self)
	Get_AddOnData()
	AddOn_Update(AddOnCPU.NR.Scroll)
end);
AddOnCPU.CZ = PIGButton(AddOnCPU,{"TOPLEFT",AddOnCPU,"TOPLEFT",210,-25},{60,20},L["DEBUG_RESET"])
AddOnCPU.CZ:SetScript("OnClick", function (self)
	ResetCPUUsage()
	-- debugprofilestart()
	-- debugprofilestop()
	Get_AddOnData()
	AddOn_Update(AddOnCPU.NR.Scroll)
end);
AddOnCPU.COLLECT = PIGButton(AddOnCPU,{"TOPLEFT",AddOnCPU,"TOPLEFT",290,-25},{60,20},L["DEBUG_COLLECT"])
AddOnCPU.COLLECT:SetScript("OnClick", function (self)
	collectgarbage()--回收内存
	Get_AddOnData()
	AddOn_Update(AddOnCPU.NR.Scroll)
end);
AddOnCPU.COLLECT:Disable()
AddOnCPU.COLLECT:SetMotionScriptsWhileDisabled(true)
PIGEnter(AddOnCPU.COLLECT,L["LIB_TIPS"],L["DEBUG_COLLECTTIPS"]);

--
fuFrame.NPCID = PIGButton(fuFrame,{"TOPLEFT",fuFrame,"TOPLEFT",20,-350},{125,24},L["DEBUG_GETGUIDBUT"])
fuFrame.NPCID:SetScript("OnClick", function (self)
	print(UnitGUID("target"))
end);
fuFrame.GetItem = PIGButton(fuFrame,{"LEFT",fuFrame.NPCID,"RIGHT",200,0},{110,24},"获取物品信息")
fuFrame.GetItem:SetScript("OnClick", function (self)
	local itemName,itemLink = GetItemInfo(self.E:GetNumber())
	print(string.gsub(itemLink,"|","||"))
	local itemLink=Fun.GetItemLinkJJ(itemLink)
	--local itemLink=Fun.yasuo_NumberString(itemLink)
	print(itemLink)
	local itemLink=Fun.HY_ItemLinkJJ(itemLink)
	print(itemLink)
end);
fuFrame.GetItem.E = CreateFrame("EditBox", nil, fuFrame.GetItem, "InputBoxInstructionsTemplate");
fuFrame.GetItem.E:SetSize(80,24);
fuFrame.GetItem.E:SetPoint("RIGHT",fuFrame.GetItem,"LEFT",-4,0);
fuFrame.GetItem.E:SetFontObject(ChatFontNormal);
fuFrame.GetItem.E:SetAutoFocus(false);--自动获得焦点
fuFrame.GetItem.E:SetMaxLetters(10)--最大输入字符数
fuFrame.GetItem.E:SetNumeric(true)--只能输入数字
-----------------
fuFrame:SetScript("OnShow", function()
	if GetCVar("scriptErrors")=="1" then
		fuFrame.ErrCB:SetChecked(true)
	end
	fuFrame.taintLog:PIGDownMenu_SetText(taintlistmenu[GetCVar("taintLog")])
end);
---创建常用3宏
local hongNameList = {["RL"]={"/Reload",132096},["FST"]={"/fstack",132089},["EVE"]={"/eventtrace",132092}}
fuFrame.New_hong = PIGButton(fuFrame,{"BOTTOMLEFT",fuFrame,"BOTTOMLEFT",20,20},{100,24},"ADD_FWR")
fuFrame.New_hong:SetScript("OnClick", function ()
	for k,v in pairs(hongNameList) do
		local macroSlot = GetMacroIndexByName(k)
		if macroSlot>0 then
			EditMacro(macroSlot, nil, v[2], v[1])
		else
			local global, perChar = GetNumMacros()
			if global<120 then
				CreateMacro(k, v[2], v[1], nil)
			else
				PIGinfotip:TryDisplayMessage(L["LIB_MACROERR"]);
			end
		end
	end
end)
---调试配置
fuFrame.tiaoshipeizhi = PIGButton(fuFrame,{"BOTTOMLEFT",fuFrame,"BOTTOMLEFT",220,20},{100,24},L["DEBUG_CONFIG"])
fuFrame.tiaoshipeizhi:SetScript("OnClick", function ()
	StaticPopup_Show("TIAOSHIPEIZHIQIYONG",L["DEBUG_CONFIG"]);
end)
local function zairutiaoshiFUN()
	PIGA=addonTable.Default;
	addonTable.Config_Set(PIGA,false)
	PIGA_Per=addonTable.Default_Per;
	addonTable.Config_Set(PIGA_Per,false)
	Pig_Options_RLtishi_UI:Show()
end
StaticPopupDialogs["TIAOSHIPEIZHIQIYONG"] = {
	text = L["CONFIG_LOADTIPS"].."\n"..L["DEBUG_CONFIGTIPS"],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		zairutiaoshiFUN()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
fuFrame.zhuanma = PIGButton(fuFrame,{"BOTTOMLEFT",fuFrame,"BOTTOMLEFT",460,20},{80,24},"Base64")
fuFrame.zhuanma:SetScript("OnClick", function (self)
	if self.F:IsShown() then
		self.F:Hide()
	else
		self.F:Show()
	end
end)
fuFrame.zhuanma:HookScript("OnHide", function (self)
	self.F:Hide()
end)
local ConfigWWW,ConfigHHH = 800, 600
fuFrame.zhuanma.F=PIGFrame(fuFrame.zhuanma,{"CENTER",UIParent,"CENTER",0,0},{ConfigWWW,ConfigHHH})
fuFrame.zhuanma.F:PIGSetBackdrop(1)
fuFrame.zhuanma.F:PIGSetMovable()
fuFrame.zhuanma.F:PIGClose()
fuFrame.zhuanma.F:SetFrameLevel(999);
fuFrame.zhuanma.F:Hide()
fuFrame.zhuanma.F.biaoti=PIGFontString(fuFrame.zhuanma.F,{"TOP", fuFrame.zhuanma.F, "TOP", 0, -4})
PIGLine(fuFrame.zhuanma.F,"TOP",-20,1,{-1,-20})
---
local julidi = -26
fuFrame.zhuanma.F.zhunma = PIGButton(fuFrame.zhuanma.F,{"TOPLEFT",fuFrame.zhuanma.F,"TOPLEFT",20,julidi},{80,20},"cmd_1")
fuFrame.zhuanma.F.zhunma:SetScript("OnClick", function (self)
	local data = fuFrame.zhuanma.F.NR.textArea:GetText()
	local Ndata = Fun.Base64_encod(data)
	fuFrame.zhuanma.F.NR.textArea:SetText(Ndata)
end)
fuFrame.zhuanma.F.huanyuan = PIGButton(fuFrame.zhuanma.F,{"LEFT",fuFrame.zhuanma.F.zhunma,"RIGHT",20,0},{80,20},"cmd_2")
fuFrame.zhuanma.F.huanyuan:SetScript("OnClick", function (self)
	local data = fuFrame.zhuanma.F.NR.textArea:GetText()
	local Ndata = Fun.Base64_decod(data)
	fuFrame.zhuanma.F.NR.textArea:SetText(Ndata)
end)
fuFrame.zhuanma.F.Copy = PIGButton(fuFrame.zhuanma.F,{"TOPLEFT",fuFrame.zhuanma.F,"TOPLEFT",320,julidi},{80,20},"select all")
fuFrame.zhuanma.F.Copy:SetScript("OnClick", function (self)
	fuFrame.zhuanma.F.NR.textArea:HighlightText()
	--CopyToClipboard(fuFrame.zhuanma.F.NR.textArea:GetText())
end)
fuFrame.zhuanma.F.Clear = PIGButton(fuFrame.zhuanma.F,{"LEFT",fuFrame.zhuanma.F.Copy,"RIGHT",20,0},{80,20},"Clear")
fuFrame.zhuanma.F.Clear:SetScript("OnClick", function (self)
	fuFrame.zhuanma.F.NR.textArea:SetText("")
end)
fuFrame.zhuanma.F.Line2 =PIGLine(fuFrame.zhuanma.F,"TOP",-50,1,{-1,-50})
--
fuFrame.zhuanma.F.NR=PIGFrame(fuFrame.zhuanma.F)
fuFrame.zhuanma.F.NR:SetPoint("TOPLEFT", fuFrame.zhuanma.F.Line2, "TOPLEFT", 4, -4)
fuFrame.zhuanma.F.NR:SetPoint("BOTTOMRIGHT", fuFrame.zhuanma.F, "BOTTOMRIGHT", -4, 4)
fuFrame.zhuanma.F.NR:PIGSetBackdrop()
fuFrame.zhuanma.F.NR.scroll = CreateFrame("ScrollFrame", nil, fuFrame.zhuanma.F.NR, "UIPanelScrollFrameTemplate")
fuFrame.zhuanma.F.NR.scroll:SetPoint("TOPLEFT", fuFrame.zhuanma.F.NR, "TOPLEFT", 6, -6)
fuFrame.zhuanma.F.NR.scroll:SetPoint("BOTTOMRIGHT", fuFrame.zhuanma.F.NR, "BOTTOMRIGHT", -26, 6)

fuFrame.zhuanma.F.NR.textArea = CreateFrame("EditBox", nil, fuFrame.zhuanma.F.NR.scroll)
fuFrame.zhuanma.F.NR.textArea:SetFontObject(ChatFontNormal);
fuFrame.zhuanma.F.NR.textArea:SetWidth(ConfigWWW-40)
fuFrame.zhuanma.F.NR.textArea:SetMultiLine(true)
fuFrame.zhuanma.F.NR.textArea:SetMaxLetters(99999)
fuFrame.zhuanma.F.NR.textArea:EnableMouse(true)
fuFrame.zhuanma.F.NR.textArea:SetScript("OnEscapePressed", function(self)
	self:ClearFocus()
	fuFrame.zhuanma.F:Hide();
end)
fuFrame.zhuanma.F.NR.scroll:SetScrollChild(fuFrame.zhuanma.F.NR.textArea)