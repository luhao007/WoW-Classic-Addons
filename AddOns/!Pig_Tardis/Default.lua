local addonName, addonTable = ...;
local _, _, Fun, _, Default, Default_Per= unpack(PIG)
local extDefault ={
	["Open"] = true,
	["AddBut"] = true,
	["Farm"]={
		["Open"] = true,
		["DaojishiCD"]=0,
	},
	["Invite"]={
		["Open"] = true,
		["Template"]={},
		["YellTemp"]={},
		["CMD"]="777",
		["CMD_Msg"]=false,
		["Yell_CHANNEL"]={["SAY"] = true},
		["YellMsg"]="",
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
		["Favorite_Siji"]={},
		["Ban_Siji"]={},
		["Favorite_Chengke"]={},
		["Ban_Chengke"]={},
		["ApplyTemp"]={},
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
		["YellTemp"]={},
		["CMD"]="888",
		["CMD_Msg"]=false,
		["Yell_CHANNEL"]={["SAY"] = true},
		["YellMsg"]="",
		["Conditions"]={},
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