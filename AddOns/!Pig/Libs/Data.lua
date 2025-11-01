local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local gsub = _G.string.gsub 
local Data = {}
----------
MAX_CONTAINER_ITEMS=MAX_CONTAINER_ITEMS or 36
Data.AtlasInfo={}
---职业
function PIGGetClassInfo(id)
	if C_CreatureInfo and C_CreatureInfo.GetClassInfo then
		local classInfo=C_CreatureInfo.GetClassInfo(id)
		if classInfo then
			return classInfo["className"],classInfo["classFile"],id
		end
	else
		local className, classFile=GetClassInfo(id)
		if className then
			return className, classFile,id
		end
	end
end
PIG_CLASS_COLORS={}
for k,v in pairs(RAID_CLASS_COLORS) do
    PIG_CLASS_COLORS[k] = {r = v.r, g = v.g, b = v.b, colorStr = v.colorStr}
end
PIG_CLASS_COLORS[NONE]={r = 1, g = 0.843, b = 0, colorStr = "ffFFD700"}

local cl_Name={};
local cl_Name_Role={
	["WARRIOR"] = {"TANK","DAMAGER"},
	["PALADIN"] = {"TANK", "HEALER","DAMAGER"},
	["HUNTER"] = {"DAMAGER"},
	["ROGUE"] = {"DAMAGER"},
	["PRIEST"] = {"HEALER","DAMAGER"},
	["DEATHKNIGHT"] = {"TANK","DAMAGER"},
	["SHAMAN"] = {"HEALER","DAMAGER"},
	["MAGE"] = {"DAMAGER"},
	["WARLOCK"] = {"DAMAGER"},
	["MONK"] = {"TANK", "HEALER","DAMAGER"},
	["DRUID"] = {"TANK", "HEALER","DAMAGER"},
	["DEMONHUNTER"] = {"TANK","DAMAGER"},
	["EVOKER"] = {"HEALER","DAMAGER"}, 
}
local ClasseID={};
local ClasseNameID={}
local ClassFile_Name={};
local expansionLevel = GetClassicExpansionLevel()
local classIDs
if expansionLevel == 0 or expansionLevel == 1 then
    classIDs = {1,2,3,4,5,7,8,9,11}
elseif expansionLevel == 2 then
    classIDs = {1,2,3,4,5,6,7,8,9,11}
elseif expansionLevel == 4 then
    classIDs = {1,2,3,4,5,6,7,8,9,10,11} 
-- elseif expansionLevel == 6 then
-- 	classIDs = {1,2,3,4,5,6,7,8,9,10,11,12} 
else
	classIDs = {1,2,3,4,5,6,7,8,9,10,11,12,13} 
end
for index=1,#classIDs do
	local classID=classIDs[index]
	local className, classFile, classID = PIGGetClassInfo(classID)
	if classFile then
		table.insert(cl_Name,{classFile,cl_Name_Role[classFile],className, classID})
		ClasseID[classFile]= classID
		ClasseNameID[className]= classFile
		ClassFile_Name[classFile]= className
	end
end
Data.cl_Name=cl_Name
Data.ClasseID=ClasseID
Data.ClasseNameID=ClasseNameID
Data.cl_Name_Role=cl_Name_Role
Data.ClassFile_Name=ClassFile_Name

--种族
local PIGraceList = {}
for i=100,1,-1 do
	local raceInfo = C_CreatureInfo.GetRaceInfo(i)
	if raceInfo then
		if raceInfo.raceName then
			if raceInfo.clientFileString=="Scourge" then raceInfo.clientFileString="undead" end
			if raceInfo.clientFileString=="EarthenDwarf" then raceInfo.clientFileString="earthen" end
			PIGraceList[raceInfo.raceName]=raceInfo.clientFileString
		end
	end
end
Data.PIGraceList=PIGraceList
--职责
--local zhizeIcon = {{0.01,0.26,0.26,0.51},{0.27,0.52,0,0.25},{0.27,0.52,0.25,0.5},{0.01,0.26,0,0.25}}
local zhizeIcon = {{0.01,0.26,0.26,0.51},{0.27,0.52,0,0.25},{0.27,0.52,0.25,0.5}}
Data.zhizeIcon=zhizeIcon
local zhizeAtlas = {"ui-lfg-roleicon-tank","ui-lfg-roleicon-healer","ui-lfg-roleicon-dps"}
Data.zhizeAtlas=zhizeAtlas
--装备编号
Data.buwei={}
if PIG_MaxTocversion() then
	Data.buwei.FEET={"FEETSLOT",FEETSLOT.."部","Feet",true}
	if PIG_MaxTocversion(20000) then
		Data.buwei.HANDS={"HANDSSLOT",HANDSSLOT,"Hands",true}
	else
		Data.buwei.HANDS={"HANDSSLOT",HANDSSLOT.."部","Hands",true}
	end
else
	Data.buwei.FEET={"FEETSLOT",FEETSLOT,"Feet",true}
	Data.buwei.HANDS={"HANDSSLOT",HANDSSLOT,"Hands",true}
end
Data.InvSlot = {
	["ALLID"]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19},
	["ID"]={1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17},
	["CID"] = {1,2,3,15,5,4,19,9,10,6,7,8,11,12,13,14,16,17},
	["Name"]={
		[0]={"AMMOSLOT",AMMOSLOT,"Ammo",false},[1]={"HEADSLOT",HEADSLOT,"Head",true},[2]={"NECKSLOT",NECKSLOT,"Neck",false},
		[3]={"SHOULDERSLOT",SHOULDERSLOT,"Shoulder",true},[4]={"SHIRTSLOT",SHIRTSLOT,"Shirt",false},[5]={"CHESTSLOT",CHESTSLOT,"Chest",true},
		[6]={"WAISTSLOT",WAISTSLOT,"Waist",true},[7]={"LEGSSLOT",LEGSSLOT,"Legs",true},[8]=Data.buwei.FEET,
		[9]={"WRISTSLOT",WRISTSLOT,"Wrist",true},[10]=Data.buwei.HANDS,[11]={"FINGER0SLOT",FINGER0SLOT,"Finger0",false},
		[12]={"FINGER1SLOT",FINGER1SLOT,"Finger1",false},[13]={"TRINKET0SLOT",TRINKET0SLOT,"Trinket0",false},[14]={"TRINKET1SLOT",TRINKET1SLOT,"Trinket1",false},
		[15]={"BACKSLOT",BACKSLOT,"Back",false},[16]={"MAINHANDSLOT",MAINHANDSLOT,"MainHand",true},[17]={"SECONDARYHANDSLOT",SECONDARYHANDSLOT,"SecondaryHand",true},
		[18]={"RANGEDSLOT",RANGEDSLOT,"Ranged",true},[19]={"TABARDSLOT",TABARDSLOT,"Tabard",false},
	}
}
if PIG_MaxTocversion(50000) then
	table.insert(Data.InvSlot["ALLID"],18,18)
	table.insert(Data.InvSlot["ID"],18)
	table.insert(Data.InvSlot["CID"],18)
	if PIG_MaxTocversion(20000) then
		if GetLocale() == "zhTW" then
			Data.InvSlot.Name[10][2]=Data.InvSlot.Name[10][2].."部"
		end
	end
end
--装备颜色
local GetItemQualityColor=GetItemQualityColor or C_Item and C_Item.GetItemQualityColor
Data.Quality= {}
for k,v in pairs(Enum.ItemQuality) do
	Data.Quality[v]={["Name"]={},["RGB"]={},["HEX"]={}}
	local r, g, b, hex = GetItemQualityColor(v)
	--print(v, '|c'..hex.._G["ITEM_QUALITY"..v.."_DESC"]..'|r')
	Data.Quality[v]["Name"]='|c'..hex.._G["ITEM_QUALITY"..v.."_DESC"]..'|r'
	Data.Quality[v]["RGB"]={r, g, b}
	Data.Quality[v]["HEX"]=hex
end
---背包/银行
Data.bagData = {
	["bagID"]={0,1,2,3,4},
	["bagIDMax"]= NUM_BAG_FRAMES,
	["bankID"]={-1,5,6,7,8,9,10},
	["bankmun"]=24,
	["bankbag"]=6,
	["ItemWH"]=42,
}
if PIG_MaxTocversion(20000,true) then
	Data.bagData["bankmun"]=28;
	Data.bagData["bankID"]={-1,5,6,7,8,9,10,11};
	Data.bagData["bankbag"]=7;
end
if PIG_MaxTocversion(100000,true) then
	Data.bagData["bagIDMax"]= NUM_TOTAL_BAG_FRAMES
	Data.bagData["bagID"]={0,1,2,3,4,5}
	Data.bagData["bankID"]={-1,6,7,8,9,10,11,12}
elseif PIG_MaxTocversion(110200) then
	Data.bagData.ItemWH=_G["BankFrameItem1"]:GetWidth()+5
else
	Data.bagData.ItemWH=ContainerFrameCombinedBags.Items[1]:GetWidth()+5
end
--物品类型
local ItemTypeLsit = {
	{133971,{{0,5}}},--消耗品/食物
	{136240,{{0,1}}},--消耗品/药水
	{134071,{{7,4},{3}}},--商品/珠宝加工
	{136249,{{7,5}}},--商品/布料
	{133611,{{7,6}}},--商品/皮革
	{136248,{{7,7}}},--商品/金属矿石
	{133970,{{7,8}}},--商品/肉类
	{133939,{{7,9}}},--商品/草药
	{136244,{{7,12}}},--商品/附魔
}
local GetItemSubClassInfo=GetItemSubClassInfo or C_Item and C_Item.GetItemSubClassInfo
for iv=1,#ItemTypeLsit do
	local Subname = GetItemSubClassInfo(ItemTypeLsit[iv][2][1][1],ItemTypeLsit[iv][2][1][2])
	ItemTypeLsit[iv][3]=Subname or NONE
end
Data.ItemTypeLsit=ItemTypeLsit
--专业信息
Data.SkillbookType=PIG_GetSpellBookType()
local Skill_List = {
	["top"]={
		746,--急救
		2018,--锻造
		2108,--制皮
		2259,--炼金术
		2550,--烹饪
		2656,--熔炼/采矿日志
		3908,--裁缝
		4036,--工程学
		7411,--附魔
		25229,--珠宝加工
		45357,--铭文
		53428,--符文熔铸
	},
	["bot"]={
		818,--"基础营火/烹饪用火",
		13262,--"分解",
		31252,--"选矿",
		2366,--"采集草药",
		7620,--"钓鱼"
	},
};
if PIG_MaxTocversion(30000) then
	table.insert(Skill_List.top,5149)--训练
	table.insert(Skill_List.top,2842)--毒药
end
if PIG_MaxTocversion(40000,true) then
	--table.insert(Skill_List.top,195127)--考古
	--table.insert(Skill_List.bot,80451)--勘探
end
if PIG_MaxTocversion(100000,true) then
	table.insert(Skill_List.top,61422)--10.0熔炼
	table.insert(Skill_List.top,193290)--草药学日志
	table.insert(Skill_List.top,271990)--钓鱼日志
end
if PIG_MaxTocversion(80000) then
	table.insert(Skill_List.top,2575)--采矿
else
	table.insert(Skill_List.bot,2575)--采矿
	table.insert(Skill_List.bot,131474)--"钓鱼"
end
local Skill_ListName = {}
local Skill_ListNameIcon={}
for k,v in pairs(Skill_List) do
	Skill_ListName[k]={}
	for i=1,#v do
		local spellName, spellTexture = PIGGetSpellInfo(v[i])
		if spellName then 
			Skill_ListNameIcon[spellName]=spellTexture
			table.insert(Skill_ListName[k],spellName) 
		end
	end
end
Data.Skill_ListNameIcon=Skill_ListNameIcon
local function Is_SkillName(namex)
	for k,v in pairs(Skill_ListName) do
		for i=1,#v do
			if v[i]==namex then
				return true,k
			end
		end
	end
	return false
end
local function Save_data(SkillData,spellName,spellID,one)
	local Is_Skill, topbot=Is_SkillName(spellName)
	if Is_Skill then
		if one then
			if topbot=="top" then
				table.insert(SkillData[topbot],{spellName,spellID})
				return true
			end
		else
			table.insert(SkillData[topbot],{spellName,spellID})
		end
	end
	return false
end

function Data.Get_Skill_Info(one)
	local SkillData = {["top"]={},["bot"]={}}
	if PIG_MaxTocversion(40000) then
		local _, _, tabOffset, numEntries = GetSpellTabInfo(1)
		for j=tabOffset + 1, tabOffset + numEntries do
			local spellName, _ ,spellID=GetSpellBookItemName(j, Data.SkillbookType)
			if Save_data(SkillData,spellName,spellID,one) then return SkillData end
		end
	elseif PIG_MaxTocversion(60000)then
		for _, i in pairs{GetProfessions()} do
			local offset, numSlots = select(3, GetSpellTabInfo(i))
			for j = offset+1, offset+numSlots do
				local spellName, _ ,spellID=GetSpellBookItemName(j, Data.SkillbookType)
				if Save_data(SkillData,spellName,spellID,one) then return SkillData end
			end
		end
	else
		for _, i in pairs{GetProfessions()} do
			local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(i)
			local offset, numSlots = skillLineInfo.itemIndexOffset, skillLineInfo.numSpellBookItems
			for j = offset+1, offset+numSlots do
				local spellName = C_SpellBook.GetSpellBookItemName(j, Data.SkillbookType)
				local spellID = select(2,C_SpellBook.GetSpellBookItemType(j, Data.SkillbookType))
				if Save_data(SkillData,spellName,spellID,one) then return SkillData end
			end
		end
	end
	return SkillData
end

---时空之门=====
Data.Tardis={["Prefix"]="!Pig_Tardis",
	["GetMsg"] ={"TARDIS_INVITE","TARDIS_HOUCHE","TARDIS_FARM","TARDIS_LAYER"},
	["qianzhui"] ={"!I","!H","!F","!L"},
	["SqMsg"] ={"!ISQINV_","!HSQYQC_","!FSQSC","!LSQHWM_"},
	["ver"] ={0,0,8.21,8.21},
}
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",function(self,event,arg1,...)
	for i=1,#Data.Tardis.GetMsg do
		if arg1:match(Data.Tardis.GetMsg[i]) then
			return true;
		end
	end
end)
---喊话随机符
Data.MSGsuijizifu ={",",".","!",";","，","。","！","；"};
----------------
Data.Ext ={};
-----
addonTable.Data=Data
---
Data.ElvUI_BagName = {"ElvUI_ContainerFrameBag-","ElvUI_ContainerFrameBag"}
Data.NDui_BagName={"NDui_BackpackSlot",6*36}