local addonName, addonTable = ...;
local sub = _G.string.sub
local match = _G.string.match
local Create = addonTable.Create
-------------
local Fun=addonTable.Fun
local jieya_NumberString=Fun.jieya_NumberString
local GetEquipmTXT=Fun.GetEquipmTXT
local HY_EquipmTXT=Fun.HY_EquipmTXT
local GetRuneTXT=Fun.GetRuneTXT
local HY_RuneTXT=Fun.HY_RuneTXT
local Data=addonTable.Data
local TalentData=Data.TalentData
---
local ALA_tiquMsg=addonTable.ALA.ALA_tiquMsg
local pig_PREFIX="!Pig-YCIN";
local ala_PREFIX = "ATEADD"
local td_PREFIX = "tdInspect"
local YCinfo_GET_MSG = {"!GETALL","!GETT-","!GETG-","!GETR-","!GETI-"};
C_ChatInfo.RegisterAddonMessagePrefix(pig_PREFIX)
local UIname="PIG_LongInspectUI"
Data.LongInspectUIUIname=UIname
Data.UILayout[UIname]={"TOPLEFT","TOPLEFT",0, -116}
---------------
local function Update_ShowItem(itemstxt,laiyuan)
	local zbData = {}
	if not itemstxt then return end
	for k,v in pairs(itemstxt) do
		zbData[k]=v
	end
	for k,v in pairs(zbData) do
		GetItemInfo(v)
	end
	C_Timer.After(0.1,function()
		_G[UIname].ZBLsit.ShowItemNum=0
		_G[UIname]:Update_ShowItem_List(zbData,laiyuan)
	end)
end
Fun.Update_ShowItem=Update_ShowItem
local function Update_ShowPlayer(Player,lyfrome)
	--				print(Player,lyfrome)
	local class,race,level,itemLV,gender = unpack(Player)
	if HardcoreDeaths_UI then HardcoreDeaths_UI.Save_playerdata(_G[UIname].fullnameX,class,race,gender) end
	local className, classFile = PIGGetClassInfo(class)
	local raceName = "  "
	if tonumber(race)>0 then
		local raceInfo = C_CreatureInfo.GetRaceInfo(race)
		raceName=raceInfo["raceName"]
	end
	_G[UIname].LevelText:SetText(LEVEL..level.." "..raceName.." "..className);
	if not ElvUI and not NDui then
		_G[UIname].Portrait:SetTexture("interface/targetingframe/ui-classes-circles.blp")
		local coords = CLASS_ICON_TCOORDS[classFile]
		_G[UIname].Portrait:SetTexCoord(unpack(coords));
	end
	_G[UIname].ZBLsit.level=level
	_G[UIname].ZBLsit.zhiyeID=class
	_G[UIname].ZBLsit.zhiye=classFile
	_G[UIname].ZBLsit.itemLV=itemLV
	_G[UIname].ZBLsit:Update_Player(lyfrome)
end
Fun.Update_ShowPlayer=Update_ShowPlayer
--处理获取信息
local function PIG_FormatData(msgx,nameX)
	local jiequkaishi = 1
	local datalist= {}  	  
	for i = 1, #msgx do  
	    local kshi, jieshu, msgx1 = msgx:find("(#[^#]+)", jiequkaishi) 
	    if kshi then
	    	jiequkaishi=jieshu+1
	   		table.insert(datalist, msgx1)  
	    end  
	end
	local yxwjinfo = {}
	for i=1,#datalist do
		local xinximsg = datalist[i]
		local qianzhui = xinximsg:sub(1, 2)
		if qianzhui == "#P" then
			yxwjinfo[1] = {strsplit("-", xinximsg:sub(3, -1))};
		elseif qianzhui == "#T" then
			local Tianfu,Tianfu2 =TalentData.HY_TianfuTXT(xinximsg:sub(3, -1))
			PIG_OptionsUI.talentData[nameX]["T"]={GetServerTime(),Tianfu,Tianfu2}
		elseif qianzhui == "#G" then
			local fwData,fwData2=TalentData.HY_GlyphTXT(xinximsg:sub(3, -1))
			PIG_OptionsUI.talentData[nameX]["G"]={GetServerTime(),fwData,fwData2}
		elseif qianzhui == "#R" then
			local fwData=HY_RuneTXT(xinximsg:sub(3, -1))
			PIG_OptionsUI.talentData[nameX]["R"]={GetServerTime(),fwData}
		elseif qianzhui == "#E" then
			yxwjinfo[2]=HY_EquipmTXT(xinximsg:sub(3, -1))
		end
	end
	Update_ShowPlayer(yxwjinfo[1],"yc")
	Update_ShowItem(yxwjinfo[2],"yc")
end
local function PIG_tiquMsg(msgx,nameX)
	if _G[UIname]:IsShown() and _G[UIname].fullnameX==nameX then
		local qianzhui = msgx:sub(1, 2)
		if qianzhui == "!P" then
			if not msgx:match("@") then
				_G[UIname].fanhuiYN=true
				local allnum = msgx:sub(3, 3)
				local danqian = msgx:sub(4, 4)
				if danqian=="1" then
					_G[UIname].allmsg=msgx:sub(5, -1)
				else
					_G[UIname].allmsg=_G[UIname].allmsg..msgx:sub(5, -1)
				end
				if allnum==danqian then
					PIG_FormatData(_G[UIname].allmsg,nameX)
				end
			end
		end
	end
	if InspectFrame and InspectFrame:IsShown() and InspectNameText:GetText()==nameX or _G[Data.TardisUI] and _G[Data.TardisUI]:IsShown() or Pig_playerStatsUI and Pig_playerStatsUI:IsShown() then--观察/时空
		local qianzhui = msgx:sub(1, 3)
		if qianzhui == "!T-" or qianzhui == "!G-" or qianzhui == "!R-" or qianzhui == "!I-" then
			local leixing = msgx:sub(2, 2)	
			if leixing == "T" then
				_G[UIname].fanhuiYN_TF=true
				local Tianfu,Tianfu2 =TalentData.HY_TianfuTXT(msgx:sub(4, -1))
				PIG_OptionsUI.talentData[nameX][leixing]={GetServerTime(),Tianfu,Tianfu2}
			end
			if leixing == "G" then
				_G[UIname].fanhuiYN_GG=true
				local dwData,dwData2=TalentData.HY_GlyphTXT(msgx:sub(4, -1))
				PIG_OptionsUI.talentData[nameX][leixing]={GetServerTime(),dwData,dwData2}
			end
			if leixing == "R" then
				_G[UIname].fanhuiYN_RR=true
				local fwData=HY_RuneTXT(msgx:sub(4, -1))
				PIG_OptionsUI.talentData[nameX][leixing]={GetServerTime(),fwData}
			end
			if leixing == "I" then
				_G[UIname].fanhuiYN_II=true
				local classId,raceId,level,ItemLevel,gender = strsplit("-", msgx:sub(4, -1))
				PIG_OptionsUI.talentData[nameX][leixing]={GetServerTime(),classId,raceId,level,ItemLevel,gender}
			end
		end
	end
end
--没有获取到目标信息
local function alaGet_Fun_1()
	if not _G[UIname].fanhuiYN then
		PIGSendAddonMessage(ala_PREFIX, "!Q32TGE", "WHISPER", _G[UIname].fullnameX);
	end
end
local function alaGet_Fun_2()
	if not _G[UIname].fanhuiYN then
		PIGSendAddonMessage(ala_PREFIX, "_q_tal", "WHISPER", _G[UIname].fullnameX);
		PIGSendAddonMessage(ala_PREFIX, "_q_equ", "WHISPER", _G[UIname].fullnameX);		
	end
end
local function ycNull_Fun()
	if not _G[UIname].fanhuiYN then
		_G[UIname].LevelText:SetText("|cffFF0000获取失败\n目标未安装"..addonName.."插件或版本过期|r");
	end
end
local function GetDATA_YN()
	if _G[UIname].alaGet_1 then _G[UIname].alaGet_1:Cancel() end
	_G[UIname].alaGet_1=C_Timer.NewTimer(1,alaGet_Fun_1)
	if _G[UIname].alaGet_2 then _G[UIname].alaGet_2:Cancel() end
	_G[UIname].alaGet_2=C_Timer.NewTimer(2,alaGet_Fun_2)
	if _G[UIname].ycNull then _G[UIname].ycNull:Cancel() end
	_G[UIname].ycNull=C_Timer.NewTimer(3,ycNull_Fun)
end
local function GetDATA_YN_TF(fullnameX)
	if _G[UIname].alaGet_TF then _G[UIname].alaGet_TF:Cancel() end
	_G[UIname].alaGet_TF=C_Timer.NewTimer(0.8,function()
		if not _G[UIname].fanhuiYN_TF then
			PIGSendAddonMessage(ala_PREFIX, "!Q32T", "WHISPER", fullnameX);
		end
	end)
end
local function GetDATA_YN_GG(fullnameX)
	if _G[UIname].alaGet_GG then _G[UIname].alaGet_GG:Cancel() end
	_G[UIname].alaGet_GG=C_Timer.NewTimer(0.8,function()
		if not _G[UIname].fanhuiYN_GG then
			PIGSendAddonMessage(ala_PREFIX, "!Q32G", "WHISPER", fullnameX);
		end
	end)
end
local function GetDATA_YN_RR(fullnameX)
	if _G[UIname].alaGet_RR then _G[UIname].alaGet_RR:Cancel() end
	_G[UIname].alaGet_RR=C_Timer.NewTimer(0.8,function()
		if not _G[UIname].fanhuiYN_RR then
			PIGSendAddonMessage(ala_PREFIX, "!Q32R", "WHISPER", fullnameX);
		end
	end)
end
local function FasongYCqingqiu(fullnameX,iidd)
	if name==UNKNOWNOBJECT then return end
	PIG_OptionsUI.talentData[fullnameX]=PIG_OptionsUI.talentData[fullnameX] or {}
	local iidd=iidd or 1
	if iidd==1 then
		if InspectFrame and InspectFrame:IsShown() then InspectFrame:Hide() end
		_G[UIname].fanhuiYN=false
		PIGSendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
		_G[UIname].TitleText:SetText(fullnameX);
		_G[UIname].fullnameX=fullnameX
		GetDATA_YN()
		_G[UIname]:CZ_yuancheng_Data(INVTYPE_RANGED)
	elseif iidd==2 then--只请求天赋信息
		if not PIG_OptionsUI.talentData[fullnameX]["T"] or GetServerTime()-PIG_OptionsUI.talentData[fullnameX]["T"][1]>10 then
			_G[UIname].fanhuiYN_TF=false
			PIGSendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
			GetDATA_YN_TF(fullnameX)
		end
	elseif iidd==3 then--只请求雕文信息
		if not PIG_OptionsUI.talentData[fullnameX]["G"] or GetServerTime()-PIG_OptionsUI.talentData[fullnameX]["G"][1]>10 then
			_G[UIname].fanhuiYN_GG=false
			PIGSendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
			GetDATA_YN_GG(fullnameX)
		end
	elseif iidd==4 then--只请求符文信息
		if not PIG_OptionsUI.talentData[fullnameX]["R"] or GetServerTime()-PIG_OptionsUI.talentData[fullnameX]["R"][1]>10 then
			_G[UIname].fanhuiYN_RR=false
			PIGSendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
			GetDATA_YN_RR(fullnameX)
		end
	elseif iidd==5 then--只请求角色信息
		if not PIG_OptionsUI.talentData[fullnameX]["I"] or GetServerTime()-PIG_OptionsUI.talentData[fullnameX]["I"][1]>10 then
			_G[UIname].fanhuiYN_II=false
			PIGSendAddonMessage(pig_PREFIX,YCinfo_GET_MSG[iidd], "WHISPER", fullnameX)
		end
	end
end
Fun.FasongYCqingqiu=FasongYCqingqiu
-----
local function lixian_chakan(fullnameX,renwu,itemdata)
	if InspectFrame and InspectFrame:IsShown() then InspectFrame:Hide() end
	_G[UIname].TitleText:SetText(fullnameX);
	_G[UIname].fullnameX=fullnameX
	_G[UIname]:CZ_yuancheng_Data(FRIENDS_LIST_OFFLINE)
	Update_ShowPlayer({renwu[4],renwu[2],renwu[5]},"lx")
	local zbtxtlist=HY_EquipmTXT(PIGA["StatsInfo"]["Items"][fullnameX]["C"])
	Update_ShowItem(zbtxtlist,"lx")
end
Fun.lixian_chakan=lixian_chakan
------------------------------------
local fengeLEN = 240
local uixxx = CreateFrame("Frame")
uixxx:RegisterEvent("PLAYER_LOGIN")
uixxx:SetScript("OnEvent",function(self, event, arg1, arg2, _, arg4, arg5)
	if event=="PLAYER_LOGIN" then
		Create.CharacterFrame(UIParent,UIname,99)
		Create.PIG_SetPoint(UIname)
		C_Timer.After(3,function()
			if not C_ChatInfo.IsAddonMessagePrefixRegistered(ala_PREFIX) then
				C_ChatInfo.RegisterAddonMessagePrefix(ala_PREFIX)
			end
			if not C_ChatInfo.IsAddonMessagePrefixRegistered(td_PREFIX) then
				C_ChatInfo.RegisterAddonMessagePrefix(td_PREFIX)
			end
		end)
		self:RegisterEvent("CHAT_MSG_ADDON")
		PIG_OptionsUI.talentData={}
	end
	if event=="CHAT_MSG_ADDON" then
		if arg1 == pig_PREFIX then
			if arg2==YCinfo_GET_MSG[1] then
				local Player =TalentData.SAVE_Player()
				local Tianfu =TalentData.GetTianfuTXT()
				local Glyph =TalentData.GetGlyphTXT()
				local Rune =GetRuneTXT()
				local Items =GetEquipmTXT()
				local infoall = "#P"..Player.."#T"..Tianfu.."#G"..Glyph.."#R"..Rune.."#E"..Items
				local msglen = #infoall
				if msglen>fengeLEN then
					local fasongcishu = math.ceil(msglen/fengeLEN)
					for ic=1,fasongcishu do
						local jiequK = (ic-1)*fengeLEN+1
						local jiequJ = ic*fengeLEN
						if ic==fasongcishu then
							jiequJ = -1
						end
						local NewMsg1 = infoall:sub(jiequK,jiequJ)
						PIGSendAddonMessage(pig_PREFIX, "!P"..fasongcishu..ic..NewMsg1, "WHISPER", arg5)
					end		
				else
					PIGSendAddonMessage(pig_PREFIX, "!P11"..infoall, "WHISPER", arg5)
				end
			elseif arg2==YCinfo_GET_MSG[2] then
				local info =TalentData.GetTianfuTXT()
				PIGSendAddonMessage(pig_PREFIX, "!T-"..info, "WHISPER", arg5)
			elseif arg2==YCinfo_GET_MSG[3] then
				local info =TalentData.GetGlyphTXT()
				PIGSendAddonMessage(pig_PREFIX, "!G-"..info, "WHISPER", arg5)
			elseif arg2==YCinfo_GET_MSG[4] then
				local info =GetRuneTXT()
				PIGSendAddonMessage(pig_PREFIX, "!R-"..info, "WHISPER", arg5)
			elseif arg2==YCinfo_GET_MSG[5] then
				local Player =TalentData.SAVE_Player()
				PIGSendAddonMessage(pig_PREFIX, "!I-"..Player, "WHISPER", arg5)
			else
				PIG_tiquMsg(arg2,arg5)
			end
		elseif arg1==ala_PREFIX then
			ALA_tiquMsg(arg2,arg5)
		elseif arg1==td_PREFIX then
			--TD_tiquMsg(arg2,arg5)
		end
	end
end)