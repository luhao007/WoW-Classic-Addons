local addonName, addonTable = ...;
local _, _, Fun, _, Default, Default_Per= unpack(PIG)
local extDefault = {
	["Open"] = true,
	["AddBut"] = true,
	["Rsetting"] ={
		["danwei"]=1,
		["autofen"]=false,
		["bobaomingxi"] = true,
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
		{RAID_LEADER,0,"N/A",false},
		{HEALS.."第一",0,"N/A",false},
		{HEALS.."第二",0,"N/A",false},
		{HEALS.."第三",0,"N/A",false},
		{DAMAGE.."第一",0,"N/A",false},
		{DAMAGE.."第二",0,"N/A",false},
		{DAMAGE.."第三",0,"N/A",false},
	},
	["jiangli_config"]={},
	["fakuan"]={
		{"包地板出价",0,"N/A",0},
		{"指挥失误罚款",0,"N/A",0},
		{"跑位失误罚款1",0,"N/A",0},
		{"跑位失误罚款2",0,"N/A",0},
		{"跑位失误罚款3",0,"N/A",0},
		{"ADD罚款1",0,"N/A",0},
		{"ADD罚款2",0,"N/A",0},
		{"ADD罚款3",0,"N/A",0},
	},
	["fakuan_config"]={},
	["History"]={},
}
Default["GDKP"] =extDefault
local extDefault_Per = {

};
Default_Per["GDKP"]=extDefault_Per
-----
local Config_format=Fun.Config_format
function addonTable.Load_Config()
	PIGA["GDKP"] = PIGA["GDKP"] or extDefault
	PIGA_Per["GDKP"] = PIGA_Per["GDKP"] or extDefault_Per
	PIGA["GDKP"] = Config_format(PIGA["GDKP"],extDefault)
	PIGA_Per["GDKP"] = Config_format(PIGA_Per["GDKP"],extDefault_Per)
end