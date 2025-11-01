local addonName, addonTable = ...;
local gsub = _G.string.gsub
local L=addonTable.locale
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton=Create.PIGButton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
local Fun=addonTable.Fun
local GetPIGID=Fun.GetPIGID
----------------------------------------
local fuFrame = PIGOptionsList(L["ABOUT_TABNAME"],"BOT")

--右侧顶部版本
local Pig_Options=PIG_OptionsUI
Pig_Options.R.top = PIGFrame(Pig_Options.R)
Pig_Options.R.top:SetHeight(24)
Pig_Options.R.top:SetPoint("TOPLEFT", Pig_Options.R, "TOPLEFT", 0, -2)
Pig_Options.R.top:SetPoint("TOPRIGHT", Pig_Options.R, "TOPRIGHT", -2, 0)
Pig_Options.R.top:PIGSetBackdrop()
Pig_Options.R.top:PIGSetMovableNoSave(Pig_Options)
Pig_Options.R.top:PIGClose(25,25,Pig_Options)
Pig_Options.R.top.Ver = CreateFrame("Frame", nil, Pig_Options.R.top)
Pig_Options.R.top.Ver:SetPoint("TOPLEFT", Pig_Options.R.top, "TOPLEFT", 0, 0)
Pig_Options.R.top.Ver:SetPoint("BOTTOMRIGHT", Pig_Options.R.top, "BOTTOMRIGHT", -30, 0)
Pig_Options.VersionID=0
function Pig_Options:GetVer_NUM(EXTaddname,ly)
	if ly=="audio" then
		return Pig_Options.R.top.audioVer and Pig_Options.R.top.audioVer[EXTaddname].VersionID or 0
	else
		return Pig_Options.R.top.Ver and Pig_Options.R.top.Ver[EXTaddname].VersionID or 0
	end
end
function Pig_Options:GetVer_TXT(EXTaddname,ly)
	if ly=="audio" then
		return Pig_Options.R.top.audioVer and Pig_Options.R.top.audioVer[EXTaddname].VersionTXT or 0
	else
		return Pig_Options.R.top.Ver and Pig_Options.R.top.Ver[EXTaddname].VersionTXT or 0
	end
end
function Pig_Options:SetVer_EXT(EXTaddname,ly)
	local VersionTXT=PIGGetAddOnMetadata(EXTaddname, "Version")
	local VersionID=tonumber(VersionTXT)
	if ly=="audio" then
		Pig_Options.R.top.audioVer=Pig_Options.R.top.audioVer or{}
		Pig_Options.R.top.audioVer[EXTaddname]=Pig_Options.R.top.audioVer[EXTaddname] or {}
		Pig_Options.R.top.audioVer[EXTaddname].VersionID=VersionID
		Pig_Options.R.top.audioVer[EXTaddname].VersionTXT=VersionTXT
	else
		local name, title, notes, loadable = PIGGetAddOnInfo(EXTaddname)
		local ziframe = {Pig_Options.R.top.Ver:GetChildren()}
		local verF = PIGFrame(Pig_Options.R.top.Ver,nil,{0.0001,20})
		Pig_Options.R.top.Ver[EXTaddname]=verF
		if #ziframe==0 then
			verF:SetPoint("LEFT", Pig_Options.R.top.Ver, "LEFT", 4, -2)
		else
			verF:SetPoint("LEFT", ziframe[#ziframe].txt, "RIGHT", 0, 0)
		end
		verF.txt = PIGFontString(verF,{"LEFT", verF, "LEFT", 0, 0})
		verF.New = verF:CreateTexture();
		verF.New:SetAtlas("loottoast-arrow-purple");
		verF.New:SetSize(14,15);
		verF.New:SetPoint("BOTTOMLEFT", verF.txt, "TOPRIGHT", -6, -11);
		verF.New:Hide()
		verF.VersionTXT=VersionTXT
		verF.VersionID=VersionID
	end
end
Pig_Options:HookScript("OnShow", function (self)
	for EXTaddname,v in pairs(L["PIGaddonList"]) do
		if self.R.top.Ver[EXTaddname] then
			local verF = Pig_Options.R.top.Ver[EXTaddname]
			local VerTXT = "|cffFFD700%s:|r|cff00FF00%s|r"
			if EXTaddname==addonName then
				verF.txt:SetText(string.format(VerTXT,GAME_VERSION_LABEL,verF.VersionTXT))
			else
				verF.txt:SetText("|cff00FFFF + |r"..string.format(VerTXT,L["PIGaddonList"][EXTaddname],verF.VersionTXT))
			end
			if PIGA["Ver"][EXTaddname] and PIGA["VerC"][EXTaddname] then
				if verF.VersionID<PIGA["Ver"][EXTaddname] and #PIGA["VerC"][EXTaddname].p>4 then
					verF.New:Show()
					if EXTaddname==addonName then
						self.UpdateVer:Show()
					end
				end
			end
		end
	end
end);

------
local function Add_EditBox(fuUI,Point,biaoti,txt,WWW)
	local WWW=WWW or 460
	local EditButBT = PIGFontString(fuUI,Point,biaoti,"OUTLINE")
	EditButBT:SetTextColor(1, 1, 1, 1)
	local EditBut = CreateFrame("EditBox", nil, fuUI, "InputBoxInstructionsTemplate");
	EditBut:SetSize(WWW,30);
	EditBut:SetPoint("LEFT",EditButBT,"RIGHT",4,0);
	PIGSetFont(EditBut, 16, "OUTLINE");
	EditBut:SetTextColor(0, 1, 1, 1)
	EditBut:SetTextInsets(6, 0, 0, 0)
	EditBut:SetAutoFocus(false);
	EditBut:HookScript("OnShow", function(self)
		self:SetText(txt);
	end); 
	function EditBut:SetTextpig()
		self:SetText(txt);
	end
	EditBut:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
	EditBut:SetScript("OnEscapePressed", function(self) self:SetTextpig() self:ClearFocus() end);
	EditBut:SetScript("OnEditFocusLost", function(self) self:SetTextpig() end);
	return EditButBT,EditBut
end
local Aboutdata={
	["Mail"] = "xdfxjf1004@hotmail.com",
	["Media"] = "哔哩哔哩/抖音搜",
	["Author"] = "geligasi",
	["Other"]="QQ群|cff00FFFF27397148|r   2群|cff00FFFF117883385|r   YY频道|cff00FFFF113213|r"
}
local YY=-10
Add_EditBox(fuFrame,{"TOPLEFT",fuFrame,"TOPLEFT",20,YY-30},L["ABOUT_MAIL"],Aboutdata.Mail)
Add_EditBox(fuFrame,{"TOPLEFT",fuFrame,"TOPLEFT",20,YY-60},L["ABOUT_MEDIA"]..Aboutdata.Media,Aboutdata.Author,280)
if GetLocale() == "zhCN" then
	fuFrame.ShowAuthor = PIGButton(fuFrame,{"TOPLEFT",fuFrame,"TOPLEFT",20,YY-90},{100,22},L["ADDON_AUTHOR"])
	fuFrame.ShowAuthor:SetScript("OnClick", function (self)
		local fujiUI=fuFrame:GetParent():GetParent():GetParent():GetParent()
		fujiUI:ShowAuthor()
	end);
	fuFrame.ShowAuthor:Hide()
	fuFrame.Other = PIGFontString(fuFrame,{"LEFT",fuFrame.ShowAuthor,"RIGHT",20,0},Aboutdata.Other,"OUTLINE")
	fuFrame.Other:SetTextColor(1, 1, 1, 1)
	fuFrame.Other:SetJustifyH("LEFT")
end
local YY=-140
PIGLine(fuFrame,"TOP",YY)
Create.add_extLsitAboutFrame("About",fuFrame,YY)

--Update===============================
local Ver_biaotou="!Pig_VER";
PIG_OptionsUI.Ver_biaotou=Ver_biaotou
C_ChatInfo.RegisterAddonMessagePrefix(Ver_biaotou)
---
local player_Width,player_Height,topv,player_jiangeH=440,20,24,2;
local duiwu_Width,duiwu_Height,duiwu_jiangeW,duiwu_jiangeH=player_Width,player_Height*5+player_jiangeH*4,10,10;

local PIG_Version=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{(duiwu_Width+duiwu_jiangeW)*2+duiwu_jiangeW,(duiwu_Height+duiwu_jiangeH)*4+topv+20},"PIG_VersionUI",true)
PIG_Version:PIGSetBackdrop()
PIG_Version:PIGClose()
PIG_Version:PIGSetMovableNoSave()
PIG_Version.title = PIGFontString(PIG_Version,{"TOP", PIG_Version, "TOP", 0, -4},GAME_VERSION_LABEL..INFO)
PIGLine(PIG_Version,"TOP",-topv)
local addonsdata=L["PIG_ADDON_LIST"]
local addonspoint={130,210,290,370}
for i=0,3 do
	local title = PIGFontString(PIG_Version,{"TOPLEFT", PIG_Version, "TOPLEFT", addonspoint[i+1]+duiwu_jiangeW, -4-topv},addonsdata[i].name)
	local title1 = PIGFontString(PIG_Version,{"TOPLEFT", PIG_Version, "TOPLEFT", addonspoint[i+1]+player_Width+duiwu_jiangeW*2, -4-topv},addonsdata[i].name)
end
PIG_Version.butlist={}
for p=1,8 do
	local DuiwuF = CreateFrame("Frame", nil, PIG_Version);
	PIG_Version.butlist[p]=DuiwuF
	PIG_Version.butlist[p].butlist={}
	DuiwuF:SetSize(duiwu_Width,duiwu_Height);
	if p==1 then
		DuiwuF:SetPoint("TOPLEFT",PIG_Version,"TOPLEFT",10,-topv-24);
	elseif p==3 then
		DuiwuF:SetPoint("TOP",PIG_Version.butlist[1],"BOTTOM",0,-duiwu_jiangeH);
	elseif p==5 then
		DuiwuF:SetPoint("TOP",PIG_Version.butlist[3],"BOTTOM",0,-duiwu_jiangeH);
	elseif p==7 then
		DuiwuF:SetPoint("TOP",PIG_Version.butlist[5],"BOTTOM",0,-duiwu_jiangeH);
	else
		DuiwuF:SetPoint("LEFT",PIG_Version.butlist[p-1],"RIGHT",duiwu_jiangeW,0);
	end
	for pp=1,5 do
		local DuiwuF_P = PIGFrame(DuiwuF,nil,{player_Width,player_Height});
		DuiwuF_P:PIGSetBackdrop()
		PIG_Version.butlist[p].butlist[pp]=DuiwuF_P
		DuiwuF_P.verlist={}
		if pp==1 then
			DuiwuF_P:SetPoint("TOP",DuiwuF,"TOP",0,0);
		else
			DuiwuF_P:SetPoint("TOP",PIG_Version.butlist[p].butlist[pp-1],"BOTTOM",0,-player_jiangeH);
		end
		DuiwuF_P.name = PIGFontString(DuiwuF_P,{"LEFT", DuiwuF_P, "LEFT", 2, 0})
		DuiwuF_P.verlist[0] = PIGFontString(DuiwuF_P,{"LEFT", DuiwuF_P, "LEFT", addonspoint[1]+2, 0})
		DuiwuF_P.verlist[1] = PIGFontString(DuiwuF_P,{"LEFT", DuiwuF_P, "LEFT", addonspoint[2]+2, 0})
		DuiwuF_P.verlist[2] = PIGFontString(DuiwuF_P,{"LEFT", DuiwuF_P, "LEFT", addonspoint[3]+2, 0})
		DuiwuF_P.verlist[3] = PIGFontString(DuiwuF_P,{"LEFT", DuiwuF_P, "LEFT", addonspoint[4]+2, 0})
	end
end
PIG_Version.getinfo = PIGButton(PIG_Version,{"TOPLEFT",PIG_Version,"TOPLEFT",40,-2.4},{80,20},"发起查询")
PIG_Version.getinfo:SetScript("OnClick", function (self)
	self:Disable()
	PIG_Version.UpdateBut:Disable()
	C_Timer.After(1,function()
		self:Enable()
		PIG_Version.UpdateBut:Enable()
		PIG_Version.Update_hang()
	end)
	PIG_Version.infoList={}
	for p=1,8 do
		for pp=1,5 do
			local but=PIG_Version.butlist[p].butlist[pp]
			but.name:SetText("-")
			for butid=0,3 do
				but.verlist[butid]:SetText("-")
			end
		end
	end
	if IsInRaid() then
		for id=1,MAX_RAID_MEMBERS do
			local name, _, subgroup, _, _, fileName = GetRaidRosterInfo(id);
			if name then
				local but=PIG_Version.butlist[subgroup].butlist[id]
				but.name:SetText(name)
				if UnitIsConnected("raid"..id) then
					PIG_Version.GetExtVer(name)
				end
			end
		end
	elseif IsInGroup() then
		for id = 1, MAX_PARTY_MEMBERS, 1 do
			local name = GetUnitName("party"..id, true)
			if name then
				local but=PIG_Version.butlist[1].butlist[id]
				but.name:SetText(name)
				if UnitIsConnected("party"..id) then
					PIG_Version.GetExtVer(name)
				end
			end
		end
	end
end)
PIG_Version.UpdateBut = PIGButton(PIG_Version,{"LEFT",PIG_Version.getinfo,"RIGHT",20,0},{80,20},"刷新结果")
PIG_Version.UpdateBut:Disable()
PIG_Version.UpdateBut:SetScript("OnClick", function (self)
	PIG_Version.Update_hang()
end)
function PIG_Version.Update_hang()
	if IsInRaid() then
		for id=1,MAX_RAID_MEMBERS do
			local name, _, subgroup, _, _, fileName = GetRaidRosterInfo(id);
			if name then
				local but=PIG_Version.butlist[subgroup].butlist[id]
				but.name:SetText(name)
				if PIG_Version.infoList[name] then
					for butid=0,3 do
						if PIG_Version.infoList[name][addonsdata[butid].name] then
							but.verlist[butid]:SetText(PIG_Version.infoList[name][addonsdata[butid].name])
						end
					end
				end
			end
		end
	elseif IsInGroup() then
		for id = 1, MAX_PARTY_MEMBERS, 1 do
			local name = GetUnitName("party"..id, true)
			if name then
				local but=PIG_Version.butlist[1].butlist[id]
				but.name:SetText(name)
				if PIG_Version.infoList[name] then
					for butid=0,3 do
						if PIG_Version.infoList[name][addonsdata[butid].name] then
							but.verlist[butid]:SetText(PIG_Version.infoList[name][addonsdata[butid].name])
						end
					end
				end
			end
		end
	end
end
function PIG_Version.GetExtVer(name)
	for i=0,3 do
		PIGSendAddonMessage(Ver_biaotou,addonsdata[i].name.."#G","WHISPER",name)
	end
end
--
fuFrame.OpenVerFBut = PIGButton(fuFrame,{"TOPLEFT",fuFrame,"TOPLEFT",2,-2},{50,20},"查询")
fuFrame.OpenVerFBut:SetScript("OnClick", function ()
	if PIG_Version:IsShown() then
		PIG_Version:Hide()
	else
		PIG_OptionsUI:Hide()
		PIG_Version:Show()
	end
end)
---提示---------------
fuFrame.GETVER = PIGButton(fuFrame,{"LEFT",fuFrame.OpenVerFBut,"RIGHT",10,0},{50,20},"重置")
fuFrame.GETVER:SetScript("OnClick", function ()
	PIGA["Ver"]={}
	PIGA["VerC"]={}
	PIG_OptionsUI.RLUI:Show()
end);
-----
--local reverse=string.reverse
-- local function quchuerweizhidian(text)--"6.3.8"--"6.38"
-- 	local text =text:reverse()
-- 	local text = gsub(text, "%.", "",1)
-- 	local text =text:reverse()
-- 	return text
-- end
local function ISchongfuP(name,data)
	for i=1,#data do
		if name==data[i] then
			return true
		end
	end
	return false
end
local function GetExtVerInfo(uifff,EXTName,EXTlocalV, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= Ver_biaotou then return end
	local getName, getype, getVer = strsplit("#", arg2);
	if getype=="X" then
		Fun.Save_is_slist(getVer)
	else
		local getVer=tonumber(getVer)
		if arg3=="WHISPER" then
			if getype=="V" then--存储手动请求的版本信息
				PIG_Version.infoList[arg5]=PIG_Version.infoList[arg5] or {}
				PIG_Version.infoList[arg5][getName]=getVer
			else
				if getName~=EXTName then return end
				if getype=="G" then--请求版本号
					PIGSendAddonMessage(Ver_biaotou,EXTName.."#V#"..EXTlocalV,"WHISPER",arg4)
				elseif getype=="D" then--收到其他玩家版本号
					if uifff.yiGenxing then return end
					if getVer>EXTlocalV then
						uifff.yiGenxing=true;
						PIGA["Ver"][EXTName]=getVer
						PIGA["VerC"][EXTName]= {["verno"]=0,["p"]={}}
						PIGA["VerC"][EXTName]=PIGA["VerC"][EXTName] or {["verno"]=0,["p"]={}}
						if getVer>PIGA["VerC"][EXTName].verno then
							PIGA["VerC"][EXTName].p={}
							PIGA["VerC"][EXTName].verno=getVer
							if not ISchongfuP(arg5,PIGA["VerC"][EXTName].p) then
								table.insert(PIGA["VerC"][EXTName].p,arg5)
							end
						elseif getVer==PIGA["VerC"][EXTName].verno then
							if not ISchongfuP(arg5,PIGA["VerC"][EXTName].p) then
								table.insert(PIGA["VerC"][EXTName].p,arg5)
							end
						end
						-- print("--------")
						-- print("插件名    :"..EXTName)
						-- print("版本      :"..EXTlocalV)
						-- print("消息      :"..arg2)
						-- print("频道      :"..arg3)
						-- print("名字+服务器:"..arg4)
						-- print("名字      :"..arg5)
						if EXTName==addonName then
							PIG_print(L["ABOUT_UPDATETIPS"],"R")
						end
					end
				end
			end
		else
			if getName~=EXTName then return end
			if getype=="U" then--回复更新请求
				if getVer<EXTlocalV then--小于自己版本
					--不是自己
					if arg4==PIG_OptionsUI.AllName then return end
					if arg5==PIG_OptionsUI.Name then return end
					PIGSendAddonMessage(Ver_biaotou,EXTName.."#D#"..EXTlocalV+0.01,"WHISPER",arg4)
				end
			end
		end
	end
end
local function SendExtVerInfo(fsMsg,adname,exuix)
	if PIGA["Ver"][adname] and PIGA["VerC"][adname] then
		if PIGA["Ver"][adname]>PIG_OptionsUI:GetVer_NUM(adname) and #PIGA["VerC"][adname].p>4 then
			exuix.yiGenxing=true;
			return
		end
	end
	if PIG_MaxTocversion(100000) then
		PIGSendAddonMessage(Ver_biaotou,fsMsg,"YELL")
	else
		local PIGID=GetPIGID("PIG")
		if PIGID>0 then
			PIGSendAddonMessage(Ver_biaotou,fsMsg,"CHANNEL",PIGID)
		end
	end
	if IsInGuild() then PIGSendAddonMessage(Ver_biaotou,fsMsg,"GUILD") end
	if IsInRaid() then
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then PIGSendAddonMessage(Ver_biaotou,fsMsg,"RAID") end
		if IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then PIGSendAddonMessage(Ver_biaotou,fsMsg,"INSTANCE_CHAT") end
	elseif IsInGroup() then
		if IsInGroup(LE_PARTY_CATEGORY_HOME) then PIGSendAddonMessage(Ver_biaotou,fsMsg,"PARTY") end
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then PIGSendAddonMessage(Ver_biaotou,fsMsg,"INSTANCE_CHAT") end
	end
end
PIG_OptionsUI.GetExtVerInfo=GetExtVerInfo
PIG_OptionsUI.SendExtVerInfo=SendExtVerInfo
---
fuFrame:RegisterEvent("CHAT_MSG_ADDON"); 
fuFrame:RegisterEvent("PLAYER_LOGIN");            
fuFrame:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event=="CHAT_MSG_ADDON" then
		GetExtVerInfo(self,addonName,PIG_OptionsUI:GetVer_NUM(addonName), arg1, arg2, arg3, arg4, arg5)
	elseif event=="PLAYER_LOGIN" then
		Fun.fasong_is_slist(SendExtVerInfo)
		if PIGA["Ver"][addonName] and PIGA["VerC"][addonName] then
			if PIGA["Ver"][addonName]>PIG_OptionsUI:GetVer_NUM(addonName) and PIGA["VerC"][addonName] and #PIGA["VerC"][addonName].p>4 then
				self.yiGenxing=true;
				PIG_print(L["ABOUT_UPDATETIPS"],"R")
				return
			end
		end
		SendExtVerInfo(addonName.."#U#"..PIG_OptionsUI:GetVer_NUM(addonName))
	end
end)