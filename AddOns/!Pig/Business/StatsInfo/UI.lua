local addonName, addonTable = ...;
local L=addonTable.locale
local Create=addonTable.Create
local PIGGetRaceAtlas=addonTable.Fun.PIGGetRaceAtlas
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGModbutton=Create.PIGModbutton
local PIGFontString=Create.PIGFontString
local PIGOptionsList_RF=Create.PIGOptionsList_RF
--
local BusinessInfo=addonTable.BusinessInfo
--=================================
local GnName,GnUI,GnIcon,FrameLevel = unpack(BusinessInfo.StatsInfoData)
local Width,Height,biaotiH  = 860, 530, 21;
--
local zijimoren = {
	["Items"]=function(peizhiV)
		local morenitem={["BAG"]={},["BANK"]={},["MAIL"]={},["C"]={},["T"]={},["G"]={},["R"]={},["GUILD"]={}}
		local NewpeizhiV={}
		for k,v in pairs(morenitem) do
			NewpeizhiV[k]=peizhiV[k] or v
		end
		return NewpeizhiV
	end,
}
local peizhiList={
	["Players"] = "must",
	["PlayerSH"] = "none",
	["InstancesCD"] = "name",
	["SkillData"] = "name",
	["Times"] = "none",
	["Token"] = "name",
	["Items"] = "name_2",
	["TradeData"] = "name",
	["AHData"] = "realm",
}
--===========================
function BusinessInfo.StatsInfo_ADDUI()
	if not PIGA["StatsInfo"]["Open"] then return end
	if _G[GnUI] then return end
	local ModBut = PIGModbutton(GnName,GnIcon,GnUI,FrameLevel)
	local StatsInfo=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,60},{Width,Height},GnUI,true)
	StatsInfo:PIGSetBackdrop()
	StatsInfo:PIGClose()
	StatsInfo:PIGSetMovableNoSave()
	StatsInfo.butW=46
	StatsInfo.hang_Height=19
	StatsInfo.title = PIGFontString(StatsInfo,{"TOP", StatsInfo, "TOP", 0, -3},GnName)
	StatsInfo.F=PIGOptionsList_RF(StatsInfo,biaotiH,"Left")
	--
	function StatsInfo:Get_renwuInfo()
		self.allname = PIG_OptionsUI.AllName
		local race_icon = PIGGetRaceAtlas(PIG_OptionsUI.RaceData.raceFile,PIG_OptionsUI.gender)
		local level = UnitLevel("player")
		PIGA["StatsInfo"]["Players"][self.allname]={PIG_OptionsUI.englishFaction,PIG_OptionsUI.RaceData.raceId,race_icon,PIG_OptionsUI.ClassData.classId,level}
		for k,v in pairs(peizhiList) do
			if v=="name" then
				PIGA["StatsInfo"][k][self.allname]=PIGA["StatsInfo"][k][self.allname] or {}
			elseif v=="name_2" then
				PIGA["StatsInfo"][k][self.allname]=PIGA["StatsInfo"][k][self.allname] or {}
				PIGA["StatsInfo"][k][self.allname]=zijimoren[k](PIGA["StatsInfo"][k][self.allname])
			elseif v=="realm" then
				PIGA["StatsInfo"][k][PIG_OptionsUI.Realm]=PIGA["StatsInfo"][k][PIG_OptionsUI.Realm] or {}
			end
		end
	end
	StatsInfo:Get_renwuInfo()
	function StatsInfo:Del_DataInfo(ly,name)
		if ly=="del" then
			PIGA["StatsInfo"]["Players"][name]=nil
			PIGA["StatsInfo"]["PlayerSH"][name]=nil
			for k,v in pairs(peizhiList) do
				if v=="name" or v=="name_2" then
					PIGA["StatsInfo"][k][name]= nil
				elseif v=="realm" then
					--PIGA["StatsInfo"][k][PIG_OptionsUI.Realm]= nil
				end
			end		
		elseif ly=="hide" then
			PIGA["StatsInfo"]["PlayerSH"][name]=true
		elseif ly=="show" then
			PIGA["StatsInfo"]["PlayerSH"][name]=nil
		end
	end
	StatsInfo:RegisterEvent("PLAYER_LEVEL_UP");
	StatsInfo:HookScript("OnEvent",function (self, event)
		if event=="PLAYER_LEVEL_UP" then
			PIGA["StatsInfo"]["Players"][self.allname][5]=UnitLevel("player") or 1
		end
	end)
	--
	BusinessInfo.FBCD(StatsInfo)
	BusinessInfo.SkillCD(StatsInfo)
	BusinessInfo.Token(StatsInfo)
	BusinessInfo.Item(StatsInfo)
	BusinessInfo.Trade(StatsInfo)
	BusinessInfo.AH(StatsInfo)
	BusinessInfo.Time(StatsInfo)
	BusinessInfo.Admin(StatsInfo)
end
