local addonName, addonTable = ...;
local gsub = _G.string.gsub
local L=addonTable.locale
local _, _, _, tocversion = GetBuildInfo()
local Create = addonTable.Create
local PIGLine=Create.PIGLine
local PIGButton=Create.PIGButton
local PIGOptionsList=Create.PIGOptionsList
local GetPIGID=addonTable.Fun.GetPIGID

local SendAddonMessage = SendAddonMessage or C_ChatInfo and C_ChatInfo.SendAddonMessage
----------------------------------------
local fuFrame = PIGOptionsList(L["ABOUT_TABNAME"],"BOT")
------
Create.About_Update(fuFrame,-10)
PIGLine(fuFrame,"TOP",-170,1)
Create.About_Thanks(fuFrame,-170)

--Update
local reverse=string.reverse
local function quchuerweizhidian(text)--"6.3.8"--"6.38"
	local text =text:reverse()
	local text = gsub(text, "%.", "",1)
	local text =text:reverse()
	return text
end
local Ver_biaotou="!Pig_VER";
Pig_OptionsUI.Ver_biaotou=Ver_biaotou
C_ChatInfo.RegisterAddonMessagePrefix(Ver_biaotou)
local function GetExtVer(uifff,EXTName,VerID, GetVer, arg1, arg2, arg4)
	-- print(uifff,EXTName,VerID, GetVer, arg1, arg2, arg4)
	-- print(quchuerweizhidian("6.3.8"))
	if arg1 == Ver_biaotou then
		local getName, GV, Verv = strsplit("#", arg2);
		local Verv=tonumber(Verv)
		if getName==EXTName then
			if GV=="G" then--请求版本号
				if arg4==Pig_OptionsUI.AllName then return end
				if arg5==Pig_OptionsUI.Name then return end
				SendAddonMessage(Ver_biaotou,EXTName.."#V#"..VerID,"WHISPER",arg4)
			elseif GV=="V" then--版本号
				local enabledState = GetAddOnEnableState(nil, EXTName)
				return arg4,Verv,enabledState
			elseif GV=="U" then--更新请求/不是自己/小于自己版本/回复
				if arg4==Pig_OptionsUI.AllName then return end
				if arg4==Pig_OptionsUI.Name then return end
				if Verv<VerID then
					SendAddonMessage(Ver_biaotou,GetVer,"WHISPER",arg4)
				end
			elseif GV=="D" then--是版本号
				if uifff.yiGenxing then return end
				if Verv>VerID then
					uifff.yiGenxing=true;
					PIGA["Ver"][EXTName]=Verv
					if EXTName==addonName then
						PIG_print(L["ABOUT_UPDATETIPS"],"R")
					end
				end
			end
		end
	end
end
Pig_OptionsUI.GetExtVer=GetExtVer
local function SendMessage(fsMsg)
	if tocversion<100000 then
		SendAddonMessage(Ver_biaotou,fsMsg,"YELL")
	else
		local PIGID=GetPIGID("PIG")
		if PIGID>0 then
			SendAddonMessage(Ver_biaotou,fsMsg,"CHANNEL",PIGID)
		end
	end
	if IsInGuild() then SendAddonMessage(Ver_biaotou,fsMsg,"GUILD") end
	if IsInRaid() then
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then SendAddonMessage(Ver_biaotou,fsMsg,"RAID") end
		if IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then SendAddonMessage(Ver_biaotou,fsMsg,"INSTANCE_CHAT") end
	elseif IsInGroup() then
		if IsInGroup(LE_PARTY_CATEGORY_HOME) then SendAddonMessage(Ver_biaotou,fsMsg,"PARTY") end
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then SendAddonMessage(Ver_biaotou,fsMsg,"INSTANCE_CHAT") end
	end
end
Pig_OptionsUI.SendMessage=SendMessage
---
fuFrame.GetVer=addonName.."#U#0"
fuFrame.FasVer=addonName.."#D#0"
fuFrame:RegisterEvent("CHAT_MSG_ADDON"); 
fuFrame:RegisterEvent("PLAYER_LOGIN");            
fuFrame:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event=="PLAYER_LOGIN" then
		PIGA["Ver"][addonName]=PIGA["Ver"][addonName] or 0
		fuFrame.GetVer=addonName.."#U#"..Pig_OptionsUI.VersionID;
		fuFrame.FasVer=addonName.."#D#"..Pig_OptionsUI.VersionID;
		if PIGA["Ver"][addonName]>Pig_OptionsUI.VersionID then
			self.yiGenxing=true;
			PIG_print(L["ABOUT_UPDATETIPS"],"R")
		else
			SendMessage(fuFrame.GetVer)
		end
	end
	---
	if event=="CHAT_MSG_ADDON" then
		--print(arg1, arg2, arg3, arg4, arg5)
		GetExtVer(self,addonName,Pig_OptionsUI.VersionID, fuFrame.FasVer, arg1, arg2, arg4)
	end
end)