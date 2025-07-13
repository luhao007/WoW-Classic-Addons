local addonName, addonTable = ...;
local _, _, Fun, _, Default, Default_Per= unpack(PIG)
local extDefault = {
	["Open"] = true,
	["AddBut"] = true,
	["Rsetting"] ={
		["danwei"]=1,
		["autofen"]=false,
		["autofenMsg"] = true,
		["bobaomingxi"] = true,
		["bobaoTops"] = false,
		["liupaibobao"] = true,
		["liupaichuli"]="组织者自行处理",
		["Pchujia"]="无效",
		["caizhixiufu"] = false,
		["jiaoyidaojishi"] = true,
		["shoudongloot"] = true,
		["fubenwai"] = false,
		["wurenben"] = false,
		["jiaoyijilu"] = true,
		["tradetonggao"] = false,
		["zidonghuifuVoice"]=false,
		["YYguanjianzi"]={"YY","yy","TS","ts"},
		["YYneirong"]="YY频道:113213,组人不易,请耐心等待",
		["PaichuList"]={},
	},
	["instanceName"]={},
	["LootQuality"]=3,
	["ItemList"]={},
	["Raidinfo"] = {{},{},{},{},{},{},{},{}},
	["Dongjie"] = false,
	["jiangli"]={
		{RAID_LEADER,0,NONE,false},
		{HEALS.."第一",0,NONE,false},
		{HEALS.."第二",0,NONE,false},
		{HEALS.."第三",0,NONE,false},
		{DAMAGE.."第一",0,NONE,false},
		{DAMAGE.."第二",0,NONE,false},
		{DAMAGE.."第三",0,NONE,false},
	},
	["jiangli_config"]={},
	["fakuan"]={
		{"包地板出价",0,NONE,0},
		{"指挥失误罚款",0,NONE,0},
		{"跑位失误罚款1",0,NONE,0},
		{"跑位失误罚款2",0,NONE,0},
		{"跑位失误罚款3",0,NONE,0},
		{"ADD罚款1",0,NONE,0},
		{"ADD罚款2",0,NONE,0},
		{"ADD罚款3",0,NONE,0},
	},
	["fakuan_config"]={},
	["History"]={},
	["Tops"]={},
}
Default["GDKP"] =extDefault
local extDefault_Per = {

};
Default_Per["GDKP"]=extDefault_Per
-----
local function shezhiquxiaoFUN()
	for i=1,#PIGA["GDKP"]["ItemList"] do
		if PIGA["GDKP"]["ItemList"][i][8]=="N/A" then
			PIGA["GDKP"]["ItemList"][i][8]=NONE
		end
	end
	for i=1,#PIGA["GDKP"]["jiangli"] do
		if PIGA["GDKP"]["jiangli"][i][3]=="N/A" then
			PIGA["GDKP"]["jiangli"][i][3]=NONE
		end
	end
	for i=1,#PIGA["GDKP"]["fakuan"] do
		if PIGA["GDKP"]["fakuan"][i][3]=="N/A" then
			PIGA["GDKP"]["fakuan"][i][3]=NONE
		end
	end
end
function addonTable.Load_Config()
	PIGA["GDKP"] = PIGA["GDKP"] or extDefault
	PIGA_Per["GDKP"] = PIGA_Per["GDKP"] or extDefault_Per
	Fun.Load_DefaultData(PIGA["GDKP"],extDefault, 0)
	Fun.Load_DefaultData(PIGA_Per["GDKP"],extDefault_Per, 0, true)
	shezhiquxiaoFUN()
end