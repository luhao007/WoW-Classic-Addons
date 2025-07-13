local addonName, addonTable = ...;
local L=addonTable.locale
-----
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton=Create.PIGButton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
local Data=addonTable.Data
--------
local EnableAddOn=EnableAddOn or C_AddOns and C_AddOns.EnableAddOn
local Locale= GetLocale()
L.pigname =addonName.."_"
L.extLsit ={L.pigname.."Tardis",L.pigname.."GDKP",L.pigname.."Farm"}
L["PIGaddonList"] = {
	[addonName]=L["ADDON_NAME"],
	[L.extLsit[1]]="时空之门",
	[L.extLsit[2]]="金团助手",
	[L.extLsit[3]]="带本助手",
}
if Locale == "zhTW" then
	L["PIGaddonList"][L.extLsit[1]]="時空之門"
	L["PIGaddonList"][L.extLsit[2]]="金團助手"
	L["PIGaddonList"][L.extLsit[3]]="帶本助手"
elseif Locale == "enUS" then
	L["PIGaddonList"][L.extLsit[1]]="Tardis"
	L["PIGaddonList"][L.extLsit[2]]="GDKP"
	L["PIGaddonList"][L.extLsit[3]]="Farm"
end
local ADDONS_DOWN_1 = "网易DD(dd.163.com)|cff00FFFF插件库|r"..SEARCH
local ADDONS_DOWN_2 = "网易DD(dd.163.com)|cffFF00FF配置分享|r"..SEARCH
L["PIG_ADDON_LIST"]={
	[0]={
		["open"]=true,
		["name"]=addonName,
		["namecn"]=L["PIGaddonList"][addonName],
		["tooltip"]="工具合集。整合很多小功能，可以极大减少你的插件数量",
		["down_1"]=ADDONS_DOWN_1,
		--["down_2"]="https://www.curseforge.com/wow/addons/pig"	
	},
	[1]={
		["open"]=true,
		["name"]=L.extLsit[1],
		["namecn"]=L["PIGaddonList"][L.extLsit[1]],
		["tooltip"]="组队增强，查找队伍或车头/找队员/换位面/便捷喊话（智能邀请回复）",
		["down_1"]=ADDONS_DOWN_1,
		--["down_2"]="https://www.curseforge.com/wow/addons/pig_tardis"	
	},
	[2]={
		["open"]=true,
		["name"]=L.extLsit[2],
		["namecn"]=L["PIGaddonList"][L.extLsit[2]],
		["tooltip"]="拾取记录，快速拍卖/出价，补助/罚款记录，分G助手等",
		["down_1"]=ADDONS_DOWN_1,
		--["down_2"]="https://www.curseforge.com/wow/addons/pig_gdkp"	
	},
	[3]={
		["open"]=true,
		["name"]=L.extLsit[3],
		["namecn"]=L["PIGaddonList"][L.extLsit[3]],
		["tooltip"]="伐木/带本日志",
		["down_1"]=ADDONS_DOWN_2,
		["down_1_name"]="geligasi",
		["down_2"]="https://afdian.com/a/wowpig",
		--["down_2"]="https://www.curseforge.com/wow/addons/pig-farm",
	},
	[4]={

	},
}
local function add_extLsitFrame(ly,self,ExtID,topV)
	local data=L["PIG_ADDON_LIST"][ExtID]
	self.OpenMode=data.open
	local addnameF=PIGFrame(self,nil,{1,14})
	addnameF:SetPoint("TOPLEFT",self,"TOPLEFT",30,topV);
	addnameF.addnameT = PIGFontString(addnameF,{"LEFT",addnameF,"RIGHT",0,0},"|cff00FFFF"..data.namecn.."|r","OUTLINE",16)
	addnameF.err = PIGFontString(addnameF,{"LEFT", addnameF.addnameT, "RIGHT", 10,0},"","OUTLINE",18);
	addnameF.err:SetTextColor(1, 0, 0, 1);
	addnameF.errbut = PIGButton(addnameF,{"LEFT", addnameF.err, "RIGHT", 0,0},{120,22},"点击启用并重载");
	addnameF.errbut:SetScript("OnClick", function (self)
		EnableAddOn(data.name)
		ReloadUI();
	end)
	addnameF.introduce = PIGFontString(addnameF,{"TOPLEFT", addnameF.addnameT, "BOTTOMLEFT", 0,-10},"功能: "..data.tooltip,"OUTLINE");
	addnameF.introduce:SetTextColor(0, 1, 0, 1);
	addnameF.UpdateF=PIGFrame(addnameF,{"TOPLEFT",addnameF.introduce,"BOTTOMLEFT",0,-40},{100,10})
	if ly=="About" then addnameF.UpdateF:SetPoint("TOPLEFT",addnameF.introduce,"BOTTOMLEFT",0,0);end
	addnameF.UpdateF.jianjuV=0
	if data.down_1 then
		addnameF.UpdateF.jianjuV=addnameF.UpdateF.jianjuV+30
		addnameF.UpdateF.T2 = PIGFontString(addnameF.UpdateF,{"TOPLEFT",addnameF.UpdateF,"BOTTOMLEFT",0,0},data.down_1,"OUTLINE")
		addnameF.UpdateF.T2:SetTextColor(1, 1, 1, 1);
		addnameF.UpdateF.T2E = CreateFrame("EditBox", nil, addnameF.UpdateF, "InputBoxInstructionsTemplate");
		addnameF.UpdateF.T2E:SetSize(100,20);
		addnameF.UpdateF.T2E:SetPoint("LEFT",addnameF.UpdateF.T2,"RIGHT",4,0);
		PIGSetFont(addnameF.UpdateF.T2E, 15, "OUTLINE");
		addnameF.UpdateF.T2E:SetAutoFocus(false);
		addnameF.UpdateF.T2E:SetTextColor(0, 1, 1, 1);
		addnameF.UpdateF.T2E.tips = PIGFontString(addnameF.UpdateF.T2E,{"LEFT",addnameF.UpdateF.T2E,"RIGHT",0,0},nil,"OUTLINE")
		addnameF.UpdateF.T2E.tips:SetTextColor(1, 0, 0, 1);
		function addnameF.UpdateF.T2E:SetTextpig()
			if data.down_1_name then
				self:SetText(data.down_1_name);
				self.tips:SetText("注意改为按标题&作者搜索");
			else
				self:SetText(data.name);
				self.tips:SetText("");
			end
		end
		addnameF.UpdateF.T2E:SetTextpig()
		addnameF.UpdateF.T2E:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
		addnameF.UpdateF.T2E:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
		addnameF.UpdateF.T2E:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);
	end
	if data.down_2 then
		addnameF.UpdateF.T3 = PIGFontString(addnameF.UpdateF,{"TOPLEFT",addnameF.UpdateF,"BOTTOMLEFT",0,-addnameF.UpdateF.jianjuV},"非网易DD到此下载: ","OUTLINE")
		addnameF.UpdateF.T3:SetTextColor(1, 1, 1, 1);
		addnameF.UpdateF.T3E = CreateFrame("EditBox", nil, addnameF.UpdateF, "InputBoxInstructionsTemplate");
		addnameF.UpdateF.T3E:SetSize(400,20);
		addnameF.UpdateF.T3E:SetPoint("LEFT",addnameF.UpdateF.T3,"RIGHT",4,0);
		PIGSetFont(addnameF.UpdateF.T3E, 15, "OUTLINE");
		addnameF.UpdateF.T3E:SetAutoFocus(false);
		function addnameF.UpdateF.T3E:SetTextpig()
			self:SetText(data.down_2);
		end
		addnameF.UpdateF.T3E:SetTextpig()
		addnameF.UpdateF.T3E:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
		addnameF.UpdateF.T3E:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
		addnameF.UpdateF.T3E:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);
	end
	addnameF.errbut:Hide()
	addnameF.UpdateF:Hide()
	if data.open then
		if ly=="About" then
			addnameF.err:Hide()
			addnameF.UpdateF:Show()
		else
			local name, title, notes, loadable,reason=PIGGetAddOnInfo(L.extLsit[ExtID])
			if not loadable then
				if reason=="MISSING" then
					addnameF.err:SetText("<未安装>");
					addnameF.UpdateF:Show()
				elseif reason=="DISABLED" then
					addnameF.err:SetText("未启用 ");
					addnameF.errbut:Show()
				else
					addnameF.err:SetText(reason);
				end
			end
		end
	else
		addnameF.err:SetText("<已停止维护>");	
	end
	return addnameF
end
local function AddExtOptionsUI(ExtID)
	local fuFrame,fuFrameBut = PIGOptionsList(L["PIGaddonList"][L.extLsit[ExtID]],"EXT")
	fuFrame.extaddonT=add_extLsitFrame("ext",fuFrame,ExtID,-60)
	Data.Ext[L.extLsit[ExtID]]={fuFrame,fuFrameBut,L["PIG_ADDON_LIST"][ExtID].tooltip}
end
for i=1,3 do
	AddExtOptionsUI(i)
end
--About
local topV = 10
Create.add_extLsitAboutFrame=function(ly,fuFrame,YY)
	for i=0,3 do
		local NewtopV = topV
		if i==0 then
			NewtopV=YY-topV
		else
			NewtopV=YY-88*i-topV
		end
		add_extLsitFrame("About",fuFrame,i,NewtopV)
	end
end