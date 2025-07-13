local addonName, addonTable = ...;
local _, _, Fun, _, Default, Default_Per= unpack(PIG)
local extDefault ={
	["Open"] = true,
	["AddBut"] = true,
	["Farm"]={
		["Open"] = true,
		["DaojishiCD"]=0,
	},
	["Houche"]={
		["Open"] = true,
		["AutoInvite"]=true,
		["AutoInviteCD"]=0,
		["DaojishiCD"]=0,
		["Description"]="",
	},
	["Chedui"]={
		["Open"] = true,
		["ADD_Level"]=0,
		["ADD_comment"]="",
	},
	["Plane"]={
		["Open"] = true,
		["AutoInvite"]=true,
		["AutoInviteCD"]=0,
		["DaojishiCD"]=0,
		["InfoList"]={},
		["HelpNum"]=0,
	},
	["Yell"]={
		["Open"] = true,
		["ShowDesktopBut"]=false,
		["mubiaoNum"]={{},{},{},},
		["Yell_NR"]="[Pig]....",
		["Yell_CHANNEL"]={["SAY"] = true},
		["MaxPlayerNum"]=40,
		["jinzuCMD"]="888",
		["jinzuCMD_inv"]=false,
		["InvMode"]=1,
		["InvMode1_Info"]={},
		["Yell_CD"]=300,
	},
}
Default["Tardis"]=extDefault
local extDefault_Per = {

};
Default_Per["Tardis"]=extDefault_Per
-------
function addonTable.Load_Config()
	PIGA["Tardis"] = PIGA["Tardis"] or extDefault
	PIGA_Per["Tardis"] = PIGA_Per["Tardis"] or extDefault_Per
	Fun.Load_DefaultData(PIGA["Tardis"],extDefault,0)
	Fun.Load_DefaultData(PIGA_Per["Tardis"],extDefault_Per, 0, true)
end