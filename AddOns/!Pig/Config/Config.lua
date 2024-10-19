local addonName, addonTable = ...;
local L=addonTable.locale
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGButton = Create.PIGButton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local Fun=addonTable.Fun
--------------
local function Config_format(DQPEIZHI,Def)
	for k,v in pairs(Def) do
		if DQPEIZHI[k]==nil then
			DQPEIZHI[k] = Def[k]
		elseif DQPEIZHI[k]=="OFF" then
			DQPEIZHI[k]=false
		elseif type(v)=="table" then
			if type(DQPEIZHI[k])~="table" then
				DQPEIZHI[k]=Def[k]
			end
			for kk,vv in pairs(v) do
				if DQPEIZHI[k][kk]==nil then
					DQPEIZHI[k][kk] = Def[k][kk]
				elseif DQPEIZHI[k][kk]=="OFF" then
					DQPEIZHI[k][kk]=false
				elseif type(vv)=="table" then
					if type(DQPEIZHI[k][kk])~="table" then
						DQPEIZHI[k][kk]=Def[k][kk]
					end
					for kkk,vvv in pairs(vv) do
						if DQPEIZHI[k][kk][kkk]==nil then
							DQPEIZHI[k][kk][kkk] = Def[k][kk][kkk]
						elseif DQPEIZHI[k][kk][kkk]=="OFF" then
							DQPEIZHI[k][kk][kkk]=false
						elseif type(vvv)=="table" then
							if type(DQPEIZHI[k][kk][kkk])~="table" then
								DQPEIZHI[k][kk][kkk]=Def[k][kk][kkk]
							end
							for kkkk,vvvv in pairs(vvv) do
								if DQPEIZHI[k][kk][kkk][kkkk]==nil then
									DQPEIZHI[k][kk][kkk][kkkk] = Def[k][kk][kkk][kkkk]
								elseif DQPEIZHI[k][kk][kkk][kkkk]=="OFF" then
									DQPEIZHI[k][kk][kkk][kkkk]=false
								end
							end
						end
					end
				end
			end
		end
	end
	return DQPEIZHI
end
Fun.Config_format=Config_format

function addonTable.Load_Config()
	PIGA = PIGA or addonTable.Default;
	PIGA = Config_format(PIGA,addonTable.Default)
	PIGA_Per = PIGA_Per or addonTable.Default_Per;
	PIGA_Per = Config_format(PIGA_Per,addonTable.Default_Per)
end
function addonTable.Set_Name_Realm()
	local wanjia, realm = UnitFullName("player")
	local realm = realm or GetRealmName()
	Pig_OptionsUI.Name=wanjia or ""
	Pig_OptionsUI.Realm=realm or ""
	Pig_OptionsUI.AllName = wanjia.."-"..realm
end
---------
local function load_Default()
	PIGA=addonTable.Default;
	PIGA_Per=addonTable.Default_Per;
	ReloadUI()
end
local function Config_Set(cfdata,bool)
	for k,v in pairs(cfdata) do
		if type(v)=="boolean" then
			cfdata[k] = bool
		elseif type(v)=="table" then
			for kk,vv in pairs(v) do
				if type(vv)=="boolean" then
					if kk~="MinimapBut" then
						cfdata[k][kk] = bool
					end
				elseif type(vv)=="table" then
					for kkk,vvv in pairs(vv) do
						if type(vvv)=="boolean" then
							cfdata[k][kk][kkk] = bool
						elseif type(vvv)=="table" then

						end
					end
				end
			end
		end
	end
end
addonTable.Config_Set=Config_Set
-- local function load_ALL()
-- 	PIGA=addonTable.Default;
-- 	Config_Set(PIGA,true)
-- 	PIGA_Per=addonTable.Default_Per;
-- 	Config_Set(PIGA_Per,true)
-- 	ReloadUI()
-- end
local Config_ID ={
	{"Default",L["CONFIG_DEFAULT"],L["CONFIG_DEFAULTTIPS"],load_Default},
	--{"AllON",L["CONFIG_ALLON"],L["CONFIG_ALLONTIPS"],load_ALL},
};
---------
local fuFrame = PIGOptionsList(L["CONFIG_TABNAME"])
local function add_Configbut(Config_Name,UIname,Config_SM)
	local But = PIGButton(fuFrame,nil,{120,26},Config_Name,UIname,Config_SM)
	But.title = PIGFontString(But,{"LEFT", But, "RIGHT", 6, 0},Config_SM)
	But.title:SetTextColor(0, 1, 0, 1);
	But.title:SetJustifyH("LEFT");
	PIGLine(But,"BOT",-20,1,{-20,484})
	return But
end

for id=1,#Config_ID do
	local Default_But = add_Configbut(Config_ID[id][2],"Default_But_"..id,Config_ID[id][3])
	if id==1 then
		Default_But:SetPoint("TOPLEFT",fuFrame,"TOPLEFT",20,-20);
	else
		Default_But:SetPoint("TOPLEFT",_G["Default_But_"..(id-1)],"BOTTOMLEFT",0,-40);
	end
	Default_But:SetScript("OnClick", function ()
		StaticPopup_Show("PEIZHI_ZAIRUQUEREN",Config_ID[id][2],nil,id);
	end);
end
StaticPopupDialogs["PEIZHI_ZAIRUQUEREN"] = {
	text = L["CONFIG_LOADTIPS"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self,arg1)
		Config_ID[arg1][4]()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

---提示-----------------------------------
fuFrame.tishi = PIGFontString(fuFrame,{"TOPLEFT", fuFrame, "TOPLEFT", 20, -300},L["LIB_TIPS"]..": ")
fuFrame.tishi:SetTextColor(1, 1, 0, 1);
fuFrame.tishi1 = PIGFontString(fuFrame,{"TOPLEFT", fuFrame.tishi, "TOPRIGHT", 10, -2},L["CONFIG_ERRTIPS"])
fuFrame.tishi1:SetTextColor(0.6, 1, 0, 1);
fuFrame.tishi1:SetJustifyH("LEFT");
---
fuFrame.GETVER = PIGButton(fuFrame,{"BOTTOMRIGHT",fuFrame,"BOTTOMRIGHT",-304,4},{100,22},"重置更新提示")
fuFrame.GETVER:SetScript("OnClick", function ()
	PIGA["Ver"]={}
	Pig_Options_RLtishi_UI:Show()
	-- SendAddonMessage(Pig_OptionsUI.Ver_biaotou,"!Pig_Tardis#G#1.04","WHISPER",Pig_OptionsUI.AllName)
	-- local enabledState = GetAddOnEnableState(nil, "!Pig_Tardis")
	-- print(enabledState)
end);
--配置导出/导入页面-----------------
local ConfigWWW,ConfigHHH = 800, 600
local Config_Transfer=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,0},{ConfigWWW,ConfigHHH})
Config_Transfer:PIGSetBackdrop(1)
Config_Transfer:PIGSetMovable()
Config_Transfer:PIGClose()
Config_Transfer:SetFrameLevel(999);
Config_Transfer:Hide()
Config_Transfer.biaoti=PIGFontString(Config_Transfer,{"TOP", Config_Transfer, "TOP", 0, -4})
PIGLine(Config_Transfer,"TOP",-20,1,{-1,-20})
---
local julidi,daoruTXT,daochuTXT = -26,L["CONFIG_IMPORT"],L["CONFIG_DERIVE"]
Config_Transfer.tishitxt = PIGFontString(Config_Transfer,{"TOPLEFT",Config_Transfer,"TOPLEFT",6,julidi-4},daoruTXT)
Config_Transfer.tishitxt:SetTextColor(0, 1, 0, 1);
Config_Transfer.daoruBut = PIGButton(Config_Transfer,{"TOPRIGHT",Config_Transfer,"TOPRIGHT",-40,julidi},{140,20},L["CONFIG_DERIVERL"])
Config_Transfer.daoruBut:Hide();
Config_Transfer.Line2 =PIGLine(Config_Transfer,"TOP",-50,1,{-1,-50})
--
Config_Transfer.NR=PIGFrame(Config_Transfer)
Config_Transfer.NR:SetPoint("TOPLEFT", Config_Transfer.Line2, "TOPLEFT", 4, -4)
Config_Transfer.NR:SetPoint("BOTTOMRIGHT", Config_Transfer, "BOTTOMRIGHT", -4, 4)
Config_Transfer.NR:PIGSetBackdrop()
Config_Transfer.NR.scroll = CreateFrame("ScrollFrame", nil, Config_Transfer.NR, "UIPanelScrollFrameTemplate")
Config_Transfer.NR.scroll:SetPoint("TOPLEFT", Config_Transfer.NR, "TOPLEFT", 6, -6)
Config_Transfer.NR.scroll:SetPoint("BOTTOMRIGHT", Config_Transfer.NR, "BOTTOMRIGHT", -26, 6)

Config_Transfer.NR.textArea = CreateFrame("EditBox", nil, Config_Transfer.NR.scroll)
Config_Transfer.NR.textArea:SetFontObject(ChatFontNormal);
Config_Transfer.NR.textArea:SetWidth(ConfigWWW-40)
Config_Transfer.NR.textArea:SetMultiLine(true)
Config_Transfer.NR.textArea:SetMaxLetters(99999)
Config_Transfer.NR.textArea:EnableMouse(true)
Config_Transfer.NR.textArea:SetScript("OnEscapePressed", function(self)
	self:ClearFocus()
	Config_Transfer:Hide();
end)
Config_Transfer.NR.scroll:SetScrollChild(Config_Transfer.NR.textArea)

---以下部分来自ALA大神告诉的AEC3代码
local strbyte, strchar, gsub, gmatch, format = string.byte, string.char, string.gsub, string.gmatch, string.format
local assert, error, pcall = assert, function(msg) PIG_print("|cffFF0000"..msg.."|r") end, pcall
local type, tostring, tonumber = type, tostring, tonumber
local pairs, select, frexp = pairs, select, math.frexp
local tconcat = table.concat
local function SerializeStringHelper(ch)
	local n = strbyte(ch)
	if n==30 then
		return "\126\122"
	elseif n<=32 then
		return "\126"..strchar(n+64)
	elseif n==94 then
		return "\126\125"
	elseif n==126 then
		return "\126\124"
	elseif n==127 then
		return "\126\123"
	else
		assert(false)
	end
end
--
local function SerializeValue(v, res, nres)
	local t=type(v)
	if t=="string" then
		v = gsub(v,"|", "P124")
		res[nres+1] = "^S"
		res[nres+2] = gsub(v,"[%c \94\126\127]", SerializeStringHelper)
		nres=nres+2
	elseif t=="number" then	
		local str = tostring(v)
		if tonumber(str)==v then
			res[nres+1] = "^N"
			res[nres+2] = str
			nres=nres+2
		elseif v == inf or v == -inf then
			res[nres+1] = "^N"
			res[nres+2] = v == inf and serInf or serNegInf
			nres=nres+2
		else
			local m,e = frexp(v)
			res[nres+1] = "^F"
			res[nres+2] = format("%.0f",m*2^53)	
			res[nres+4] = tostring(e-53)
			nres=nres+4
		end
	elseif t=="table" then
		nres=nres+1
		res[nres] = "^T"
		for k,v in pairs(v) do
			nres = SerializeValue(k, res, nres)
			nres = SerializeValue(v, res, nres)
		end
		nres=nres+1
		res[nres] = "^t"
	elseif t=="boolean" then
		nres=nres+1
		if v then
			res[nres] = "^B"
		else
			res[nres] = "^b"
		end
	elseif t=="nil" then
		nres=nres+1
		res[nres] = "^Z"

	else
		error("Unable to serialize the value of the type'"..t.."'")--无法序列化类型的值
	end
	return nres
end
---
local serializeTbl = { "^1" }
local tconcat = table.concat
local function Serialize(...)
	local nres = 1
	for i=1,select("#", ...) do
		local v = select(i, ...)
		nres = SerializeValue(v, serializeTbl, nres)
	end
	serializeTbl[nres+1] = "^^"	
	return tconcat(serializeTbl, "", 1, nres+1)
end
local function Config_CHU(self,peizhiInfo)
	Config_Transfer:Show()
	Config_Transfer.daoruBut:Hide();
	Config_Transfer.biaoti:SetText(self:GetText()..L["CONFIG_TABNAME"]);
	Config_Transfer.tishitxt:SetText(daochuTXT);
	local text = Serialize(peizhiInfo)
	Config_Transfer.NR.textArea:SetText(text)
	Config_Transfer.NR.textArea:HighlightText()
end
addonTable.Fun.Config_CHU=Config_CHU
--导入
local function DeserializeStringHelper(escape)
	if escape<"~\122" then
		return strchar(strbyte(escape,2,2)-64)
	elseif escape=="~\122" then
		return "\030"
	elseif escape=="~\123" then
		return "\127"
	elseif escape=="~\124" then
		return "\126"
	elseif escape=="~\125" then
		return "\94"
	end
	error("DeserializeStringHelper got called for '"..escape.."'?!?")
end

local function DeserializeNumberHelper(number)
	if number == serNegInf or number == serNegInfMac then
		return -inf
	elseif number == serInf or number == serInfMac then
		return inf
	else
		return tonumber(number)
	end
end
local function DeserializeValue(iter,single,ctl,data)
	if not single then
		ctl,data = iter()
	end
	if not ctl then 
		error("Supplied data misses AceSerializer terminator ('^^')")
	end	
	if ctl=="^^" then
		return
	end
	local res
	if ctl=="^S" then
		res = gsub(data, "~.", DeserializeStringHelper)
	elseif ctl=="^N" then
		res = DeserializeNumberHelper(data)
		if not res then
			error("Number of invalid serializations: '"..tostring(data).."'")--无效的序列化的数量
		end
	elseif ctl=="^F" then
		local ctl2,e = iter()
		if ctl2~="^f" then
			error("Invalid serialized floating point number expected , not '^f'"..tostring(ctl2).."'")--预期无效的序列化浮点数  not'^f', 
		end
		local m=tonumber(data)
		e=tonumber(e)
		if not (m and e) then
			error("Invalid serialized floating-point number, expected mantissa, and exponent'"..tostring(m).."' and '"..tostring(e).."'")--无效的序列化浮点数，期望的尾数和指数
		end
		res = m*(2^e)
	elseif ctl=="^B" then
		res = true
	elseif ctl=="^b" then
		res = false
	elseif ctl=="^Z" then
		res = nil
	elseif ctl=="^T" then
		res = {}
		local k,v
		while true do
			ctl,data = iter()
			if ctl=="^t" then break end
			k = DeserializeValue(iter,true,ctl,data)
			if k==nil then 
				error("Invalid AceSerializer format (no end-of-table flag)")--无效的AceSerializer格式(没有表结束标记)
			end
			ctl,data = iter()
			v = DeserializeValue(iter,true,ctl,data)
			if v==nil then
				error("Invalid AceSerializer format (no end-of-table flag)")--无效的AceSerializer格式(没有表结束标记)
			end
			res[k]=v
		end
	else
		error("Invalid AceSerializer control code"..ctl.."'")--无效的AceSerializer控制代码
	end
	if not single then
		return res,DeserializeValue(iter)
	else
		return res
	end
end
local function Deserialize(str)
	str = gsub(str,"P124", "|")
	str = gsub(str, "[%c ]", "")
	local iter = gmatch(str, "(^.)([^^]*)")	
	local ctl,data = iter()
	if not ctl or ctl~="^1" then
		return false, "Unknown data" --未知数据
	end
	return pcall(DeserializeValue, iter)
end
Config_Transfer.daoruBut:SetScript("OnClick", function(self, button)
	local tttxt =Config_Transfer.NR.textArea:GetText()
	local OOKK,dataff =Deserialize(tttxt)
	if OOKK then
		local peizhiInfo =self.peizhiInfo
		local jueseYN, xininfo1, xininfo2, xininfo3, xininfo4 = peizhiInfo[1],peizhiInfo[2],peizhiInfo[3],peizhiInfo[4],peizhiInfo[5];
		if jueseYN then
			if xininfo4 then
				PIGA_Per[xininfo1][xininfo2][xininfo3][xininfo4]=dataff
			elseif xininfo3 then
				PIGA_Per[xininfo1][xininfo2][xininfo3]=dataff
			elseif xininfo2 then
				PIGA_Per[xininfo1][xininfo2]=dataff
			elseif xininfo1 then
				PIGA_Per[xininfo1]=dataff
			end
		else
			if xininfo4 then
				PIGA[xininfo1][xininfo2][xininfo3][xininfo4]=dataff
			elseif xininfo3 then
				PIGA[xininfo1][xininfo2][xininfo3]=dataff
			elseif xininfo2 then
				PIGA[xininfo1][xininfo2]=dataff
			elseif xininfo1 then
				PIGA[xininfo1]=dataff
			end
		end
		ReloadUI()
	else
		message(L["CONFIG_DERIVEERROR"]);
	end
end)
----
local function Config_RU(self,peizhiInfo)
	Config_Transfer:Show()
	Config_Transfer.daoruBut:Show();
	Config_Transfer.biaoti:SetText(self:GetText()..L["CONFIG_TABNAME"]);
	Config_Transfer.tishitxt:SetText(daoruTXT);
	Config_Transfer.NR.textArea:SetText("")
	Config_Transfer.daoruBut.peizhiInfo=peizhiInfo
end
addonTable.Fun.Config_RU=Config_RU