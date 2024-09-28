local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
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
local function Get_renwuInfo(infoUI)
	infoUI.allname = Pig_OptionsUI.AllName
	local englishFaction= UnitFactionGroup("player")--阵营"Alliance"/"Horde"
	local _, raceFile, raceID = UnitRace("player")
	local _, classId = UnitClassBase("player")
	local level = UnitLevel("player")
	local gender = UnitSex("player")
	local race_icon = PIGGetRaceAtlas(raceFile,gender)
	PIGA["StatsInfo"]["Players"][infoUI.allname]={englishFaction,raceID,race_icon,classId,level}
end
--===========================
function BusinessInfo.StatsInfo_ADDUI()
	if not PIGA["StatsInfo"]["Open"] then return end
	if _G[GnUI] then return end
	local ModBut = PIGModbutton(GnName,GnIcon,GnUI,FrameLevel)
	local StatsInfo=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,60},{Width,Height},GnUI,true)
	StatsInfo:PIGSetBackdrop()
	StatsInfo:PIGClose()
	StatsInfo:PIGSetMovable()
	StatsInfo.butW=50
	StatsInfo.title = PIGFontString(StatsInfo,{"TOP", StatsInfo, "TOP", 0, -3},GnName)
	PIGLine(StatsInfo,"TOP",-biaotiH)
	StatsInfo.F=PIGOptionsList_RF(StatsInfo,biaotiH,"Left")
	Get_renwuInfo(StatsInfo)
	BusinessInfo.FBCD()
	BusinessInfo.SkillCD()
	BusinessInfo.Token()
	BusinessInfo.Item()
	BusinessInfo.Trade()
	BusinessInfo.AH()
	BusinessInfo.Admin()
    StatsInfo:RegisterEvent("PLAYER_ENTERING_WORLD")
    StatsInfo:SetScript("OnEvent", function(self, event, arg1)
    	Get_renwuInfo(self)
    end)
end
