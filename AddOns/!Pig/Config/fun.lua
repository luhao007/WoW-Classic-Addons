local addonName, addonTable = ...;
local Fun=addonTable.Fun
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
--------------
local function Set_ConfigValue(cfdata,bool,count)
	for k,v in pairs(cfdata) do
		if type(v)=="boolean" then
			if k~="MinimapBut" then
				cfdata[k] = bool
			end
		elseif type(v)=="table" then
			if count<4 then
				Set_ConfigValue(v,bool,count+1)
			end
		end
	end
end
Fun.Set_ConfigValue=Set_ConfigValue
---
local function Load_DefaultData(DqCF, moren,count,Per)
	if type(moren) ~= "table" then return end
	for k,v in pairs(moren) do
		if DqCF[k]==nil then
			DqCF[k] = moren[k]
		elseif DqCF[k]=="OFF" then
			DqCF[k]=false
		elseif type(v)=="table" then
			if type(DqCF[k])=="table" then
				if count<4 then
					Load_DefaultData(DqCF[k],v,count+1,Per)
				end
			else
				DqCF[k]=v
			end			
		end
	end
end
Fun.Load_DefaultData=Load_DefaultData
local function Clear_FailureData()
	PIGA["xxxxxx"]=nil
	PIGA["Error"]["ErrorInfo"]=nil
	PIGA["PigUI"]=nil
	PIGA["PigUIPoint"]=nil
	PIGA["WowUI"]=nil
	PIGA["BlizzardUI"]=nil
	PIGA["Other"]["Fast_Loot"]=nil
	PIGA["Map"]["MinimapPoint"] = nil
	PIGA["Interaction"]["Autoloot"]=nil
	PIGA["Common"]["AutoCVars"]=nil
	PIGA["Common"]["AutoLoot"]=nil
	PIGA["Common"]["FastLoot"]=nil
	PIGA["Common"]["SHAMAN_Color"]=nil

	PIGA["Chat"]["Frame"]=nil
	PIGA["Chat"]["Plus_chat"]=nil
	PIGA["Chat"]["QuickChat_ButList"]=nil
	PIGA["Chat"]["Tiqu"]["KeywordFShow"]=nil
	PIGA["Chat"]["TiquKey"]=nil
	PIGA["Chatjilu"]["jiluinfo"]=nil
	PIGA["Chatjilu"]["tianshu"]=nil
	PIGA["ActionBar"]["HideShijiu"]=nil
	PIGA["ActionBar"]["BarRight"]=nil
	PIGA["ActionBar"]["ActionBar_bili_value"]=nil
	PIGA["ActionBar"]["ActionBar_bili"]=nil
	PIGA["BagBank"]["lixian"]=nil
	PIGA["BagBank"]["hulueBAG"]=nil
	PIGA["BagBank"]["hulueBANK"]=nil
	PIGA["StatsInfo"]["Skill_ExistCD"]=nil
	PIGA["StatsInfo"]["SkillCD"]=nil
	PIGA["StatsInfo"]["FubenCD"]=nil
	PIGA["StatsInfo"]["AHOffline"]=nil
	PIGA["AHPlus"]["Data"]=nil
	PIGA["AHPlus"]["RepeatQuery"]=nil
	PIGA["AHPlus"]["Time"]=nil
	PIGA["AHPlus"]["ScanCD"]=nil
	PIGA["AHPlus"]["ScanCD_M"]=nil
	PIGA["AHPlus"]["ScanTime"]=nil
	PIGA["AHPlus"]["Tokens"]=nil
	PIGA["AHPlus"]["DataList"]=nil
	PIGA["AHPlus"]["OfflineData"]=nil
	PIGA["CombatPlus"]["topMenu"]=nil
	PIGA["CombatPlus"]["CombatTime"]=nil
	PIGA["CombatPlus"]["Biaoji"]=nil
	PIGA["UnitFrame"]["PlayerFrame"]["Plus"]=nil
	PIGA["UnitFrame"]["PlayerFrame"]["Loot"]=nil
	PIGA["QuickFollow"]=nil
	PIGA["FramePlus"]["Zhuizong"]=nil
	PIGA["FramePlus"]["Character_xiuliG"]=nil
	PIGA["FramePlus"]["yidongUI"]=nil
	PIGA["FramePlus"]["Character_Mingzhong"]=nil
	PIGA["FramePlus"]["Character_naijiu"]=nil
	PIGA["Tooltip"]["SpellID"]=nil
	PIGA["QuickBut"]["Point"]=nil
	PIGA["QuickBut"]["AutoEquip"]=nil
	PIGA["QuickBut"]["TrinketMode"]=nil
	--
	PIGA_Per["PigUI"]=nil
	PIGA_Per["QuickFollow"]=nil
	PIGA_Per["Config_Unit"]=nil
	PIGA_Per["Config_ActionBar"]=nil
end
function addonTable.Load_Config()
	PIGA = PIGA or addonTable.Default;
	PIGA_Per = PIGA_Per or addonTable.Default_Per;
	Load_DefaultData(PIGA,addonTable.Default, 0)
	Load_DefaultData(PIGA_Per,addonTable.Default_Per, 0, true)
	Clear_FailureData()
end
function addonTable.Get_PlayerRealmData()
	local englishFaction= UnitFactionGroup("player")--阵营"Alliance"/"Horde"
	local wanjia, realm = UnitFullName("player")
	local realm = realm or GetRealmName()
	local className, classFile, classId = UnitClass("player")
	local raceName, raceFile, raceId = UnitRace("player")
	local gender = UnitSex("player")
	PIG_OptionsUI.englishFaction=englishFaction or ""
	PIG_OptionsUI.Name=wanjia or ""
	PIG_OptionsUI.Realm=realm or ""
	PIG_OptionsUI.AllName = wanjia.."-"..realm
	PIG_OptionsUI.gender=gender or 2
	PIG_OptionsUI.ClassData = {["className"]=className,["classFile"]=classFile,["classId"]=classId}
	PIG_OptionsUI.RaceData = {["raceName"]=raceName,["raceFile"]=raceFile,["raceId"]=raceId}
	PIG_OptionsUI.AllNameElvUI = format('%s - %s', wanjia, realm)
	PIG_OptionsUI.IsOpen_ElvUI=function(vf1,vf2,vf3)
		if IsAddOnLoaded("ElvUI") then
			if ElvPrivateDB then
				local peizName=ElvPrivateDB["profileKeys"][PIG_OptionsUI.AllNameElvUI]
				if peizName then
					local peizData=ElvPrivateDB["profiles"][peizName]
					if peizData then
						if vf1 and vf2 and vf3 then
							if peizData[vf1] and peizData[vf1][vf2] then
								if peizData[vf1][vf2][vf3]==false then
									return false
								end
							end
						elseif vf1 and vf2 then		
							if peizData[vf1] then
								if peizData[vf1][vf2]==false then
									return false
								end
							end
						elseif vf1 then
							if peizData[vf1]==false then
								return false
							end
						end
					end
					return true
				end
			elseif ElvDB then
				local peizData=ElvDB["profiles"]
				if peizData then
					if vf1 and vf2 and vf3 then
						if peizData[vf1] and peizData[vf1][vf2] then
							if peizData[vf1][vf2][vf3]==false then
								return false
							end
						end
					elseif vf1 and vf2 then		
						if peizData[vf1] then
							if peizData[vf1][vf2]==false then
								return false
							end
						end
					elseif vf1 then
						if peizData[vf1]==false then
							return false
						end
					end
				end
				return true
			end
			return true
		else
			return false
		end
	end
	PIG_OptionsUI.IsOpen_NDui=function(vf1,vf2,vf3)
		if IsAddOnLoaded("NDui") then
			if vf1 or vf2 or vf3 then
				if vf1 and vf2 and vf3 then
					if NDuiDB[vf1] and NDuiDB[vf1][vf2] and NDuiDB[vf1][vf2][vf3] then return true end
				elseif vf1 and vf2 then
					if NDuiDB[vf1] and NDuiDB[vf1][vf2] then return true end
				elseif vf1 then
					if NDuiDB[vf1] then return true end
				end
				return false
			else
				return true
			end
		else
			return false
		end
	end
end