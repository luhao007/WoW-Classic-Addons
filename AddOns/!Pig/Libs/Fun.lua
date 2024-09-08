local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local gsub = _G.string.gsub
local match = _G.string.match
local lower=string.lower
local sub = _G.string.sub
local find = _G.string.find
local char=string.char
local Fun = {}
addonTable.Fun=Fun
local L =addonTable.locale
-------------

function PIGGetIconForRole(role)
	if role=="NONE" then
		return "UI-LFG-RoleIcon-Pending"
	else
		return GetIconForRole(role)
	end
end
function PIGGetSpellInfo(SpellID)
	if C_Spell and C_Spell.GetSpellInfo then
		local spellInfo = C_Spell.GetSpellInfo(SpellID)
		if spellInfo then
			return spellInfo.name,spellInfo.iconID,spellInfo.castTime,spellInfo.minRange,spellInfo.maxRange,spellInfo.spellID,spellInfo.originalIconID
		end
	else
		local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon= GetSpellInfo(SpellID)
		return name, icon, castTime, minRange, maxRange, spellID, originalIcon,rank
	end
end
function PIGGetSpellTabInfo(SpellID)
	if C_SpellBook and C_SpellBook.GetSpellBookSkillLineInfo then
		local spellInfo = C_SpellBook.GetSpellBookSkillLineInfo(SpellID)
		if spellInfo then
			return spellInfo.name,spellInfo.iconID,spellInfo.itemIndexOffset,spellInfo.numSpellBookItems,spellInfo.isGuild,spellInfo.shouldHide,spellInfo.specID,spellInfo.offSpecID
		end
	else
		local name, texture, offset, numSlots, isGuild, offspecID= GetSpellTabInfo(SpellID)
		return name, texture, offset, numSlots, isGuild, offspecID
	end
end
function PIGGetSpellBookItemInfo(index, bookType)
	if C_SpellBook and C_SpellBook.GetSpellBookItemInfo then
		local spellInfo = C_SpellBook.GetSpellBookItemInfo(index, bookType)
		if spellInfo then
			return spellInfo.itemType,spellInfo.spellID
		end
	else
		local spellType, id= GetSpellBookItemInfo(index, bookType)
		return spellType, id
	end
end
function PIGGetSpellCooldown(SpellID)
	if C_Spell and C_Spell.GetSpellCooldown then
		local spellInfo = C_Spell.GetSpellCooldown(SpellID)
		if spellInfo then
			return spellInfo.startTime,spellInfo.duration,spellInfo.isEnabled,spellInfo.modRate
		end
	else
		local start, duration, enabled, modRate= GetSpellCooldown(SpellID)
		return start, duration, enabled, modRate
	end
end
--获取背包信息
function PIGGetContainerIDlink(bag, slot)
	if C_Container and C_Container.GetContainerItemInfo then
		local ItemInfo = C_Container.GetContainerItemInfo(bag, slot)
		if ItemInfo then
			return ItemInfo.itemID, ItemInfo.hyperlink, ItemInfo.iconFileID, ItemInfo.stackCount, ItemInfo.quality, ItemInfo.hasNoValue
		end
	else
		local itemID, itemLink, icon, stackCount, quality = GetContainerItemInfo(bag, slot)
		return itemID, itemLink, icon, stackCount, quality
	end
end
--发送消息
function PIGSendChatRaidParty(txt)
	if IsInRaid() then
		SendChatMessage(txt, "RAID");
	elseif IsInGroup() then
		SendChatMessage(txt, "PARTY");
	else
		SendChatMessage(txt, "SAY");
	end
end
function PIGSendAddonMessage(biaotou,txt)
	--C_ChatInfo.SendAddonMessage(biaotou,txt,"SAY");--测试
	if IsInRaid() then
		C_ChatInfo.SendAddonMessage(biaotou,txt,"RAID")
	elseif IsInGroup() then
		C_ChatInfo.SendAddonMessage(biaotou,txt,"PARTY")
	end
end
---------
local function PIGCopyfun(old,new)
	for k,v in pairs(old) do
    	if type(v)=="table" then
    		new[k]={}
    		PIGCopyfun(v,new[k])
    	else
    		new[k]=v
    	end
    end
end
function PIGCopyTable(OldTable)
    local NewTable = {}
    PIGCopyfun(OldTable,NewTable)
    return NewTable
end
function PIG_print(msg,colour)
	if colour=="R" then
		print("|cff00FFFF!Pig:|r|cffFF0000"..msg.."|r");
	elseif colour=="G" then
		print("|cff00FFFF!Pig:|r|cff00FF00"..msg.."|r");
	else
		print("|cff00FFFF!Pig:|r|cffFFFF00"..msg.."|r");
	end
end
function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end
function Fun.Delmaohaobiaodain(oldt)
	local oldt=oldt:gsub(" ","");
	local oldt=oldt:gsub("：","");
	local oldt=oldt:gsub(":","");
	return oldt
end
--
Fun.pig64='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local genders = {[2]="male", [3]="female"}
local fixedRaceAtlasNames = {
    ["highmountaintauren"] = "highmountain",
    ["lightforgeddraenei"] = "lightforged",
    ["scourge"] = "undead",
    ["zandalaritroll"] = "zandalari",
};
local p=Fun.pig64
function Fun.PIGGetRaceAtlas(raceName, gender)
	local raceName = lower(raceName)
	if (fixedRaceAtlasNames[raceName]) then
		raceName = fixedRaceAtlasNames[raceName];
	end
	if gender>1 then
		local race_icon = "raceicon-"..raceName.."-"..genders[gender]
		if race_icon then
			return race_icon
		end
	end
	return "Forge-ColorSwatchBackground"
end
local function GetRaceClassFormat(file,iconH,texW,left,right,top,bottom,color)
	if color then
		return "|T"..file..":"..iconH..":"..iconH..":0:0:"..texW..":"..texW..":"..left..":"..right..":"..top..":"..bottom..color.."|t"
	else
		return "|T"..file..":"..iconH..":"..iconH..":0:0:"..texW..":"..texW..":"..left..":"..right..":"..top..":"..bottom.."|t"
	end
end
function Fun.GetRaceClassTXT(iconH,texW,race,sex,class,color)
	local RaceX,ClassX = "",""
	if race and sex then
		local race_icon = Fun.PIGGetRaceAtlas(race,sex)
		local Texinfo = C_Texture.GetAtlasInfo(race_icon)
		if Texinfo then
			if tocversion<100000 then
				local left=Texinfo.leftTexCoord*texW+5
				local right=Texinfo.rightTexCoord*texW-5
				local top=Texinfo.topTexCoord*texW+5
				local bottom=Texinfo.bottomTexCoord*texW-5
				RaceX=GetRaceClassFormat(Texinfo.file,iconH,texW,left,right,top,bottom,color)
			else
				local left=Texinfo.leftTexCoord*texW+2
				local right=Texinfo.rightTexCoord*texW-1
				local top=Texinfo.topTexCoord*texW+3
				local bottom=Texinfo.bottomTexCoord*texW-3
				RaceX=GetRaceClassFormat(Texinfo.file,iconH,texW,left,right,top,bottom,color)
			end
		end
	end
	if class then
		local leftCoord,rightCoord,topCoord,bottomCoord = unpack(CLASS_ICON_TCOORDS[class])
		local left=leftCoord*texW+9
		local right=rightCoord*texW-9
		local top=topCoord*texW+9
		local bottom=bottomCoord*texW-9
		ClassX=GetRaceClassFormat(131146,iconH,texW,left,right,top,bottom,color)
	end
	return RaceX,ClassX
end
--删除聊天link信息
function Fun.del_link(newText)
	local newText = newText or ""
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Hitem:.-|h%[","");
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Henchant:.-|h%[","");
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Htrade:.-|h%[","");
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Hmount:.-|h%[","");--
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Hjournal:.-|h%[","");
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Hachievement:.-|h%[","");
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Hspell:.-|h%[","");
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Hquest:.-|h%[","");
	local newText=newText:gsub("|cff%w%w%w%w%w%w|HclubFinder:.-|h%[","");--加入公会
	local newText=newText:gsub("|cff%w%w%w%w%w%w|HclubTicket:.-|h%[","");--加入群组
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Htransmogillusion:.-|h%[","");--附魔外观
	local newText=newText:gsub("|cff%w%w%w%w%w%w|Hworldmap:.-|h%[","");--附魔外观
	--local newText=newText:gsub("|cff%w%w%w%w%w%w|Hquestie:(%d+):Player%-(%d+)%-(%w+)|h","");
	local newText=newText:gsub("|A.-%]|h|r","");
	local newText=newText:gsub("%]|h|r","");
	return newText or ""
end
local function find_NOlink(paichuinfo,Text,key)
	local oldstart = 0
	for _ in Text:gmatch(key) do
		local start, over = Text:find(key,oldstart+1);
		if start and over then table.insert(paichuinfo,{start, over}) end
		oldstart = start
	end
end
function Fun.gsub_NOlink(newText)--替换Link之外信息
	local newText = newText or ""
	local paichuinfo = {}
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Hitem:.-|h%[.-%]|h|r)")
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Henchant:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Htrade:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Hmount:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Hjournal:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Hachievement:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Hspell:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Hquest:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|HclubFinder:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|HclubTicket:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Htransmogillusion:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|Hworldmap:.-|h%[.-%]|h|r)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|T.-:%d|t)");
	find_NOlink(paichuinfo,newText,"(|cff%w%w%w%w%w%w|T.-:%d|T)");
	return paichuinfo
end
function Fun.Is_IndexContain(paichuinfo,start,over)--判断是否在编号内
	local paichuinfo = paichuinfo or {}
	for i=1,#paichuinfo do
		if start>=paichuinfo[i][1] and over<=paichuinfo[i][2] then
			return true
		end
	end
	return false
end
local biaoqingData = {
	{"{rt1}","INTERFACE/TARGETINGFRAME/UI-RAIDTARGETINGICON_1"}, {"{rt2}","INTERFACE/TARGETINGFRAME/UI-RAIDTARGETINGICON_2"}, 
	{"{rt3}","INTERFACE/TARGETINGFRAME/UI-RAIDTARGETINGICON_3"}, {"{rt4}","INTERFACE/TARGETINGFRAME/UI-RAIDTARGETINGICON_4"}, 
	{"{rt5}","INTERFACE/TARGETINGFRAME/UI-RAIDTARGETINGICON_5"}, {"{rt6}","INTERFACE/TARGETINGFRAME/UI-RAIDTARGETINGICON_6"}, 
	{"{rt7}","INTERFACE/TARGETINGFRAME/UI-RAIDTARGETINGICON_7"}, {"{rt8}","INTERFACE/TARGETINGFRAME/UI-RAIDTARGETINGICON_8"},
	{"{天使}","Interface/AddOns/"..addonName.."/Chat/icon/angel.tga"},{"{生气}","Interface/AddOns/"..addonName.."/Chat/icon/angry.tga"},
	{"{大笑}","Interface/AddOns/"..addonName.."/Chat/icon/biglaugh.tga"},{"{鼓掌}","Interface/AddOns/"..addonName.."/Chat/icon/clap.tga"},
	{"{酷}","Interface/AddOns/"..addonName.."/Chat/icon/cool.tga"},{"{哭}","Interface/AddOns/"..addonName.."/Chat/icon/cry.tga"},
	{"{可爱}","Interface/AddOns/"..addonName.."/Chat/icon/cutie.tga"},{"{鄙视}","Interface/AddOns/"..addonName.."/Chat/icon/despise.tga"},
	{"{美梦}","Interface/AddOns/"..addonName.."/Chat/icon/dreamsmile.tga"},{"{尴尬}","Interface/AddOns/"..addonName.."/Chat/icon/embarrass.tga"},
	{"{邪恶}","Interface/AddOns/"..addonName.."/Chat/icon/evil.tga"},{"{兴奋}","Interface/AddOns/"..addonName.."/Chat/icon/excited.tga"},
	{"{晕}","Interface/AddOns/"..addonName.."/Chat/icon/faint.tga"},{"{打架}","Interface/AddOns/"..addonName.."/Chat/icon/fight.tga"},
	{"{流感}","Interface/AddOns/"..addonName.."/Chat/icon/flu.tga"},{"{呆}","Interface/AddOns/"..addonName.."/Chat/icon/freeze.tga"},
	{"{皱眉}","Interface/AddOns/"..addonName.."/Chat/icon/frown.tga"},{"{致敬}","Interface/AddOns/"..addonName.."/Chat/icon/greet.tga"},
	{"{鬼脸}","Interface/AddOns/"..addonName.."/Chat/icon/grimace.tga"},{"{龇牙}","Interface/AddOns/"..addonName.."/Chat/icon/growl.tga"},
	{"{开心}","Interface/AddOns/"..addonName.."/Chat/icon/happy.tga"},{"{心}","Interface/AddOns/"..addonName.."/Chat/icon/heart.tga"},
	{"{恐惧}","Interface/AddOns/"..addonName.."/Chat/icon/horror.tga"},{"{生病}","Interface/AddOns/"..addonName.."/Chat/icon/ill.tga"},
	{"{无辜}","Interface/AddOns/"..addonName.."/Chat/icon/Innocent.tga"},{"{功夫}","Interface/AddOns/"..addonName.."/Chat/icon/kongfu.tga"},
	{"{花痴}","Interface/AddOns/"..addonName.."/Chat/icon/love.tga"},{"{邮件}","Interface/AddOns/"..addonName.."/Chat/icon/mail.tga"},
	{"{化妆}","Interface/AddOns/"..addonName.."/Chat/icon/makeup.tga"},{"{马里奥}","Interface/AddOns/"..addonName.."/Chat/icon/mario.tga"},
	{"{沉思}","Interface/AddOns/"..addonName.."/Chat/icon/meditate.tga"},{"{可怜}","Interface/AddOns/"..addonName.."/Chat/icon/miserable.tga"},
	{"{好}","Interface/AddOns/"..addonName.."/Chat/icon/okay.tga"},{"{漂亮}","Interface/AddOns/"..addonName.."/Chat/icon/pretty.tga"},
	{"{吐}","Interface/AddOns/"..addonName.."/Chat/icon/puke.tga"},{"{握手}","Interface/AddOns/"..addonName.."/Chat/icon/shake.tga"},
	{"{喊}","Interface/AddOns/"..addonName.."/Chat/icon/shout.tga"},{"{闭嘴}","Interface/AddOns/"..addonName.."/Chat/icon/shuuuu.tga"},
	{"{害羞}","Interface/AddOns/"..addonName.."/Chat/icon/shy.tga"},{"{睡觉}","Interface/AddOns/"..addonName.."/Chat/icon/sleep.tga"},
	{"{微笑}","Interface/AddOns/"..addonName.."/Chat/icon/smile.tga"},{"{吃惊}","Interface/AddOns/"..addonName.."/Chat/icon/suprise.tga"},
	{"{失败}","Interface/AddOns/"..addonName.."/Chat/icon/surrender.tga"},{"{流汗}","Interface/AddOns/"..addonName.."/Chat/icon/sweat.tga"},
	{"{流泪}","Interface/AddOns/"..addonName.."/Chat/icon/tear.tga"},{"{悲剧}","Interface/AddOns/"..addonName.."/Chat/icon/tears.tga"},
	{"{想}","Interface/AddOns/"..addonName.."/Chat/icon/think.tga"},{"{偷笑}","Interface/AddOns/"..addonName.."/Chat/icon/Titter.tga"},
	{"{猥琐}","Interface/AddOns/"..addonName.."/Chat/icon/ugly.tga"},{"{胜利}","Interface/AddOns/"..addonName.."/Chat/icon/victory.tga"},
	{"{雷锋}","Interface/AddOns/"..addonName.."/Chat/icon/volunteer.tga"},{"{委屈}","Interface/AddOns/"..addonName.."/Chat/icon/wronged.tga"},
};
Fun.biaoqingData=biaoqingData
local function TihuanBiaoqing(arg1)
	for i=1,#biaoqingData do
		if arg1:match(biaoqingData[i][1]) then
			arg1 = arg1:gsub(biaoqingData[i][1], "|T"..biaoqingData[i][2]..":0|t");
		end
	end
	return arg1
end
Fun.TihuanBiaoqing=TihuanBiaoqing
--
local biaoqingList={}--表情字符
for i=1,#biaoqingData do
	local newvalueXxX = biaoqingData[i][2]:gsub("%-", "%%-");
	table.insert(biaoqingList,newvalueXxX)
end
function Fun.del_biaoqing(newText)--删除表情
	local newText = newText or ""
	for i=1,#biaoqingData do
		newText = newText:gsub(biaoqingData[i][1], "");
		if i<9 then
			local daxieBQ=biaoqingData[i][1]:upper()--转换大写
			newText = newText:gsub(daxieBQ, "");
		end
		newText = newText:gsub("|T"..biaoqingList[i]..":%d|t", "");
		newText = newText:gsub("|T"..biaoqingList[i]..":%d|T", "");
	end
	return newText
end
function Fun.del_biaodian(newText)--删除标点统一大小写
	local newText = newText or ""
	local newText=newText:gsub("`","");
	--local newText=newText:gsub("%p","");--任何标点符号
	local newText=newText:gsub("，","");
	local newText=newText:gsub("。","");
	local newText=newText:gsub("！","");
	local newText=newText:gsub("：","");
	local newText=newText:gsub("；","");
	local newText=newText:gsub("“","");
	local newText=newText:gsub("”","");
	local newText=newText:gsub("‘","");
	local newText=newText:gsub("’","");
	local newText=newText:gsub("~","");
	local newText=newText:gsub("%s","");
	local newText=newText:upper()--转换大写
	return newText or ""
end
--处理特殊字符
function Fun.PIGwenbenhua(newtxt)
	local newtxt=newtxt or ""
	local newtxt=newtxt:gsub("%^","%%^");
	local newtxt=newtxt:gsub("%$","%%$");
	local newtxt=newtxt:gsub("%%","%%%");
	local newtxt=newtxt:gsub("%*","%%*");
	local newtxt=newtxt:gsub("%+","%%+");
	local newtxt=newtxt:gsub("%-","%%-");
	local newtxt=newtxt:gsub("%.","%%.");
	local newtxt=newtxt:gsub("%?","%%?");
	local newtxt=newtxt:gsub("%(","%%(");
	local newtxt=newtxt:gsub("%)","%%)");
	local newtxt=newtxt:gsub("%[","%%[");
	local newtxt=newtxt:gsub("%]","%%]");
	return newtxt
end
--格式化时间
function Fun.disp_time(time)
	if time then
		local days = floor(time/86400)
		local hours = floor(mod(time, 86400)/3600)
		local minutes = math.ceil(mod(time,3600)/60)
		if time>86400 then
			return format("|c00FF0000"..GARRISON_DURATION_DAYS_HOURS.."|r",days,hours)
		elseif time<86400 and time>3600 then
			return format("|c00FFA500"..GARRISON_DURATION_HOURS_MINUTES.."|r",hours,minutes)
		elseif time<3600 and time>60 then
			return format("|c00FFFF40"..GARRISON_DURATION_MINUTES.."|r",minutes)
		else
			return format("|c00FFFF40"..GARRISON_DURATION_SECONDS.."|r",time)
		end
	else
		return TIME_UNKNOWN
	end
	-- GARRISON_DURATION_DAYS = "%d天";
	-- GARRISON_DURATION_HOURS = "%d小时";
end
--获取PIG频道
local ChatpindaoMAX = 5
Fun.ChatpindaoMAX=ChatpindaoMAX
local function huoqubianhao(Name)
	local channels = {GetChannelList()}
	for i = 1, #channels, 3 do
		local id, name, disabled = channels[i], channels[i+1], channels[i+2]
		if name==Name then
			return id
		end
	end
	return 0
end
function Fun.GetPIGID(chname)
	local chname = chname or "PIG"
	local cunzaihao = huoqubianhao(chname)
	if cunzaihao>0 then
		return cunzaihao
	else
		for x=1,ChatpindaoMAX do
			local newpindaoname = chname..x
			local cunzaihao = huoqubianhao(newpindaoname)
			if cunzaihao>0 then
				return cunzaihao
			end
		end
	end
	return 0
end
--获取喊话频道
local blocklist ={L["CHAT_BENDIFANGWU"],L["CHAT_WORLDFANGWU"],"PIG"};
if GetLocale() == "zhCN" then
	table.insert(blocklist,"服务")
elseif GetLocale() == "zhTW" then
	table.insert(blocklist,"服務")
end
function Fun.GetPindaoList()
	local chatpindaoList = {{SAY,"SAY"},{"|cffFF4040"..YELL.."|r","YELL"},{"|cff40FF40"..GUILD.."|r","GUILD"}}
	local channels = {GetChannelList()}
	for i = 1, #channels, 3 do
		local id, name, disabled = channels[i], channels[i+1], channels[i+2]
		local baohanguolvpindao=true
		for h=1,#blocklist do
			if blocklist[h]==name then
				baohanguolvpindao=false
				break
			end
		end
		if baohanguolvpindao then
			table.insert(chatpindaoList,{"|cffFFC0C0"..name.."|r",name,"CHANNEL",id})
		end
	end
	return chatpindaoList
end
function Fun.GetYellPindao(PindaoList,peizhi)
	local yellpindaolist = {}
	for i=1,#PindaoList do
		if peizhi[PindaoList[i][2]] then
			if PindaoList[i][3]=="CHANNEL" then
				table.insert(yellpindaolist,{PindaoList[i][3],PindaoList[i][4]})
			else
				table.insert(yellpindaolist,{PindaoList[i][2],nil})
			end
		end
	end
	return yellpindaolist
end
--获取所带副本级别单价文本
function Fun.Get_LvDanjiaTxt(fubenID,danjiaList)
	local MsgNr = ""
	local danjiaData=danjiaList[fubenID]
	for id = 1, 4, 1 do
		local kaishiLV =danjiaData[id][1]
		local jieshuLV =danjiaData[id][2]
		local jiageG =danjiaData[id][3]
		if kaishiLV>0 and jieshuLV>0 then
			if jiageG>0 then
				MsgNr=MsgNr.."<"..kaishiLV.."-"..jieshuLV..">"..jiageG.."G"
			else
				MsgNr=MsgNr.."<"..kaishiLV.."-"..jieshuLV..">".."免费"
			end
		end
	end
	return MsgNr
end
--获取队伍等级文本
function Fun.Get_GroupLV()
	local MsgNr=""
	if IsInGroup() then
		local MsgNr=MsgNr..",队内"
		local numgroup = GetNumSubgroupMembers()
		if numgroup>0 then
			for id=1,numgroup do
				local dengjiKk = UnitLevel("Party"..id);
				if id==numgroup then
					MsgNr=MsgNr..dengjiKk;
				else
					MsgNr=MsgNr..dengjiKk..",";
				end
			end
			MsgNr=MsgNr;
		end
	end
	return MsgNr
end
function Fun.Get_famsg(laiyuan,famsg,CMD,peizhiopen,datad)
	if laiyuan=="yell" then
		if peizhiopen then
			famsg=famsg..",进组暗号"..CMD.."";
		end
	elseif laiyuan=="FarmYellLV" then
		if CMD then
			local lvtxt = Fun.Get_GroupLV();
			famsg=famsg..lvtxt;
		end
	elseif laiyuan=="Farm_huifu" then
		if danjiaOpen then
			for k,v in pairs(datad) do
				print(k,v)
			end
			local danjiatxt = Fun.Get_LvDanjiaTxt(datad[3],datad[4]);
			famsg=famsg..","..danjiatxt
		end
		if LvOpen then
			local lvtxt = Fun.Get_GroupLV();
			famsg=famsg..lvtxt;
		end
		if autoInvite then
			famsg=famsg..",进组暗号"..CMD..""
		end
	end
	return famsg
end
--根据等级计算单价
function Fun.Get_LvDanjia(lv,fbName,danjiaList)
	if fbName~=NONE then
		for id = 1, 4, 1 do
			if danjiaList[id][1]>0 then
				if lv>=danjiaList[id][1] and lv<=danjiaList[id][2] then
					return danjiaList[id][3]
				end
			end
		end
	end
	return 0
end
--获取设置的最小和最大级别
function Fun.Get_LVminmax(fbName,danjiaList)
	local min,max = nil,nil
	for id = 1, 4, 1 do
		local kaishiLV =danjiaList[id][1]
		local jieshuLV =danjiaList[id][2]
		if kaishiLV>0 and jieshuLV>0 then
			if min then
				if kaishiLV<min then
					min=kaishiLV
				end
			else
				min=kaishiLV
			end
			if max then
				if jieshuLV>max then
					max=jieshuLV
				end
			else
				max=jieshuLV
			end
		end
	end
	local min,max = min or 0,max or 0
	return min,max
end
function Fun.Key_hebing(str)
	local arr = ""
	local numx = #str
	for i=1,numx do
		if i==numx then
			arr=arr..str[i]
		else
			arr=arr..str[i]..","
		end
	end
    return arr
end
local function zifufengekaishi(newDeli,str)
	local locaall ={["locaStart"]=nil,["locaEnd"]=nil,["fengex"]=nil}
	local xuleidaxiao = {}
	for i=1,#newDeli do
		xuleidaxiao[i]={nil,nil,newDeli[i]}
		local locaStart_1,locaEnd_1 = str:find(newDeli[i])
		if locaStart_1 then
			xuleidaxiao[i][1]=locaStart_1
			xuleidaxiao[i][2]=locaEnd_1
		end
	end
	for i=1,#xuleidaxiao do
		if xuleidaxiao[i][1] then
			if locaall["locaStart"]==nil then 
				locaall["locaStart"]=xuleidaxiao[i][1]
				locaall["locaEnd"]=xuleidaxiao[i][2]
				locaall["fengex"]=xuleidaxiao[i][3]
			else
				if xuleidaxiao[i][1]<locaall["locaStart"] then
					locaall["locaStart"]=xuleidaxiao[i][1]
					locaall["locaEnd"]=xuleidaxiao[i][2]
					locaall["fengex"]=xuleidaxiao[i][3]
				end
			end
		end
	end
	return locaall["locaStart"],locaall["locaEnd"],locaall["fengex"]
end
function Fun.Key_fenge(str,fengefu,geshihua,daifengefu)
	local arr = {}
	if type(fengefu)=="table" then
		local locaStart,locaEnd,fuhaoX=zifufengekaishi(fengefu,str)
		--
		local n = 1
		local shanjifuhao = "#"
		while locaStart ~= nil do
			if n==1 then
				if shanjifuhao=="&" then
					arr[n] = shanjifuhao..str:sub(1,locaStart-1)
				else
					arr[n] = str:sub(1,locaStart-1)
				end
			else
				if shanjifuhao=="&" then
					arr[n] = shanjifuhao..str:sub(1,locaStart-1)
				else
					arr[n] = str:sub(1,locaStart-1)
				end
			end
			str = str:sub(locaEnd+1,string.len(str))
			n = n + 1
			shanjifuhao = fuhaoX
			locaStart,locaEnd,fuhaoX=zifufengekaishi(fengefu,str)
		end
	    if str ~= nil and str ~= "" and str ~= " " then
	    	if shanjifuhao=="&" then
				arr[n] = shanjifuhao..str
			else
				arr[n] = str
			end
	    end
	else
	    local dLen = string.len(fengefu)
	    local newDeli = ''
	    for i=1,dLen,1 do
	        newDeli = newDeli .. "["..fengefu:sub(i,i).."]"
	    end
	    local locaStart,locaEnd = str:find(newDeli)
	    local n = 1
	    while locaStart ~= nil
	    do
	        if locaStart>0 then
	            arr[n] = str:sub(1,locaStart-1)
	            n = n + 1
	        end
	        str = str:sub(locaEnd+1,string.len(str))
	        locaStart,locaEnd = str:find(newDeli)
	    end
	    if str ~= nil and str ~= "" and str ~= " " then
	       	arr[n] = str
	    end
	end
	if geshihua then
	    for ix=1,#arr do
	    	arr[ix]=Fun.PIGwenbenhua(arr[ix])
	    end
	end
    return arr
end
---字符串压缩
local pig_yasuo = {}
local pig_jieya = {}
do
	local xuhao = 1
	for asciiCode = string.byte('A'), string.byte('Z') do
		local char = char(asciiCode)
		pig_yasuo[xuhao]=char
		xuhao=xuhao+1
	end
	for asciiCode = string.byte('a'), string.byte('z') do
		local char = char(asciiCode)
		pig_yasuo[xuhao]=char
		xuhao=xuhao+1
	end
	for asciiCode = string.byte('A'), string.byte('Z') do
		local char = char(asciiCode)
		pig_yasuo[xuhao]=char..char
		xuhao=xuhao+1
	end
	for asciiCode = string.byte('a'), string.byte('z') do
		local char = char(asciiCode)
		pig_yasuo[xuhao]=char..char
		xuhao=xuhao+1
	end
	for asciiCode = string.byte('A'), string.byte('Z') do
		local char = char(asciiCode)
		local charmin = lower(char)
		pig_yasuo[xuhao]=char..charmin
		xuhao=xuhao+1
	end
	for asciiCode = string.byte('A'), string.byte('Z') do
		local char = char(asciiCode)
		local charmin = lower(char)
		pig_yasuo[xuhao]=charmin..char
		xuhao=xuhao+1
	end
	for k,v in pairs(pig_yasuo) do
		pig_jieya[v]=k
	end
end
function Fun.yasuo_NumberString(sss)
	if not sss or sss=="" then return "" end
    local txtmsg = ""
    local count = 1
    local lastDigit=nil
    for i = 1, #sss do
        local str = sss:sub(i, i)
        if str == lastDigit then
            count = count + 1
        else
			if lastDigit then
				local str = sss:sub(i, i)
	            if count > 1 then
	                txtmsg = txtmsg .. tostring(lastDigit) .. pig_yasuo[count]
	            else
	                txtmsg = txtmsg .. tostring(lastDigit)
	            end
	        end
            count = 1
            lastDigit = str
        end
    end
    if count > 1 then
        txtmsg = txtmsg .. tostring(lastDigit) .. pig_yasuo[count]
    elseif count == 1 then
        txtmsg = txtmsg .. tostring(lastDigit)
    end
    return txtmsg
end
---
function Fun.jieya_NumberString(sss)
	if not sss or sss=="" then return "" end
    local txtdec = ""
    local zifutxt = nil
    local count = 0
    for i = 1, #sss do
        local char = sss:sub(i, i)
        local char1 = sss:sub(i+1, i+1)
        if char:match("%A") then
			txtdec=txtdec..char
            zifutxt = char
        elseif char:match("%a") and char1:match("%a") then
        	if zifutxt then
        		for ix=2,pig_jieya[char..char1] do
        			txtdec=txtdec..zifutxt
        		end
            end
            zifutxt = nil
        elseif char:match("%a") then
        	if zifutxt then
        		for ix=2,pig_jieya[char] do
        			txtdec=txtdec..zifutxt
        		end
            end
            zifutxt = nil
        end
    end
    return txtdec
end
--转码
function Fun.Base64_encod(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return p:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
function Fun.Base64_decod(data)
    data = data:gsub('[^'..p..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(p:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return char(c)
    end))
end