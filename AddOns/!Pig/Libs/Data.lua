local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local gsub = _G.string.gsub 
local _, _, _, tocversion = GetBuildInfo()
local Data = {}
----------
MAX_CONTAINER_ITEMS=MAX_CONTAINER_ITEMS or 36
---职业
PIG_CLASS_COLORS={}
for k,v in pairs(RAID_CLASS_COLORS) do
    PIG_CLASS_COLORS[k] = {
        r = v.r,
        g = v.g,
        b = v.b,
        colorStr = v.colorStr,
    }
end
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
for i=1,GetNumClasses() do
	local className, classFile, classID = GetClassInfo(i)
	if classFile then
		--local tank, heal, dps = UnitGetAvailableRoles("player")
		table.insert(cl_Name,{classFile,cl_Name_Role[classFile],className, classID})
		ClasseID[classFile]= classID
		ClasseNameID[className]= classFile
		ClassFile_Name[classFile]= className
		--local color = PIG_CLASS_COLORS[classFile];
		--local rPerc, gPerc, bPerc, argbHex = GetClassColor(classFile);
		--local Texinfo = C_Texture.GetAtlasInfo(classFile)
		--local coords = CLASS_ICON_TCOORDS[classFile]
		--ClassColor[argbHex]=coords
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
if tocversion<50000 then
	Data.buwei.FEET={"FEETSLOT",FEETSLOT.."部","Feet",true}
	if tocversion<20000 then
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
if tocversion<50000 then
	table.insert(Data.InvSlot["ALLID"],18,18)
	table.insert(Data.InvSlot["ID"],18)
	table.insert(Data.InvSlot["CID"],18)
	if tocversion<20000 then
		if GetLocale() == "zhTW" then
			Data.InvSlot.Name[10][2]=Data.InvSlot.Name[10][2].."部"
		end
	end
end
Data.bagData = {
	["bagID"]={0,1,2,3,4},
	["bagIDMax"]= NUM_BAG_FRAMES,
	["bankID"]={-1,5,6,7,8,9,10},
	["bankmun"]=24,
	["bankbag"]=6,
	["ItemWH"]=_G["BankFrameItem1"]:GetWidth()+5,
}
if tocversion>20000 then
	Data.bagData["bankmun"]=28;
	Data.bagData["bankID"]={-1,5,6,7,8,9,10,11};
	Data.bagData["bankbag"]=7;
end
if tocversion>100000 then
	Data.bagData["bagIDMax"]= NUM_TOTAL_BAG_FRAMES
	Data.bagData["bagID"]={0,1,2,3,4,5}
	Data.bagData["bankID"]={-1,6,7,8,9,10,11,12}
end
--装备颜色
Data.Quality= {}
for k,v in pairs(Enum.ItemQuality) do
	Data.Quality[v]={["Name"]={},["RGB"]={},["HEX"]={}}
	local r, g, b, hex = GetItemQualityColor(v)
	Data.Quality[v]["Name"]='|c'..hex.._G["ITEM_QUALITY"..v.."_DESC"]..'|r'
	Data.Quality[v]["RGB"]={r, g, b}
	Data.Quality[v]["HEX"]=hex
end

--副本数据
local InstanceList = {{NONE,0}}
local InstanceID_id = {
	["Party"]={
		["Vanilla"]={33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,329,349,389,429,},
		["TBC"]={269,540,542,543,545,546,547,552,553,554,555,556,557,558,560,585,},
		["WLK"]={574,575,576,578,595,599,600,601,602,604,608,619,632,650,658,668,},
	},
	["Raid"] = {
		["Vanilla"]={309,409,469,509,531},
		["TBC"]={532,534,544,548,550,564,565,580},
		["WLK"]={603,615,616,624,631,649,724},
	},
}
if tocversion<20000 then
	table.insert(InstanceList,{DUNGEONS,"Party","Vanilla"})
	table.insert(InstanceList,{GUILD_INTEREST_RAID,"Raid","Vanilla"})
	table.insert(InstanceID_id["Raid"]["Vanilla"],249)--奥妮克希亚的巢穴
	table.insert(InstanceID_id["Raid"]["Vanilla"],533)--纳克萨玛斯
else
	table.insert(InstanceList,{DUNGEONS,"Party","Vanilla"})
	table.insert(InstanceList,{DUNGEONS.."(TBC)","Party","TBC"})
	table.insert(InstanceList,{GUILD_INTEREST_RAID,"Raid","Vanilla"})
	table.insert(InstanceList,{GUILD_INTEREST_RAID.."(TBC)","Raid","TBC"})
	if tocversion<30000 then
		table.insert(InstanceID_id["Raid"]["Vanilla"],249)
		table.insert(InstanceID_id["Raid"]["Vanilla"],533)
	else
		table.insert(InstanceList,4,{DUNGEONS.."(WLK)","Party","WLK"})
		table.insert(InstanceList,{GUILD_INTEREST_RAID.."(WLK)","Raid","WLK"})
		table.insert(InstanceID_id["Raid"]["WLK"],249)
		table.insert(InstanceID_id["Raid"]["WLK"],533)
	end
end
local InstanceID = InstanceID_id
-- local InstanceID = {}
-- for k,v in pairs(InstanceID_id) do
-- 	InstanceID[k]={}
-- 	for kk,vv in pairs(v) do
-- 		InstanceID[k][kk]={}
-- 		for i=1,#vv do
-- 			local fubenname = GetRealZoneText(vv[i])
-- 			-- local fubenname=fubenname:gsub("：",":");
-- 			-- local _,fubennameXX =fubenname:match("(:(.+))");
-- 			if fubennameXX then
-- 				InstanceID[k][kk][i]=fubennameXX
-- 			else
-- 				InstanceID[k][kk][i]=fubenname
-- 			end
-- 		end
-- 	end
-- end
Data.FBdata={InstanceList,InstanceID}
---时空之门
local PrefixBiaotou={"!Pig_Tardis","!Pig_Invite","!Pig_Houche","!Pig_Plane"};
local GetInfoMsg ={"TARDIS_INVITE","TARDIS_HOUCHE","TARDIS_LAYER"}
Data.Tardis={PrefixBiaotou,GetInfoMsg}
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",function(self,event,arg1,...)
	for i=1,#GetInfoMsg do
		if arg1:match(GetInfoMsg[i]) then
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
Data.ElvUI_BagName = {"ElvUI_ContainerFrameBag-1","ElvUI_ContainerFrameBag"}
Data.NDui_BagName={"NDui_BackpackSlot",6*36}