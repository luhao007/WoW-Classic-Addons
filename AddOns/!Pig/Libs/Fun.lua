local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local gsub = _G.string.gsub
local match = _G.string.match
local lower=string.lower
local sub = _G.string.sub
local find = _G.string.find
local char=string.char
local L =addonTable.locale
local Fun = {}
addonTable.Fun=Fun
local version, internalVersion, date, _, versionType, buildType = GetBuildInfo()
----
local IsAddOnLoaded = IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
function Fun.IsAddOnLoaded(AddOnName,funx)
	if IsAddOnLoaded(AddOnName) then
		funx()
	else
		EventUtil.ContinueOnAddOnLoaded(AddOnName, function()
			funx()
		end)
	end
end
function PIG_GetSpellBookType()
	if Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player then
		return Enum.SpellBookSpellBank.Player
	else
		return BOOKTYPE_SPELL
	end
end
function PIG_MaxTocversion(ver,max)
	local maxver = ver or 60000
	if max then
		if tocversion>maxver then
			return true
		else
			return false
		end
	else
		if tocversion<maxver then
			return true
		else
			return false
		end
	end
end
local voiceID = C_TTSSettings.GetVoiceOptionID(0)
function PIG_PlaySoundFile(url)
	if url[2]=="AI" then
		C_VoiceChat.SpeakText(voiceID, url[1], Enum.VoiceTtsDestination.LocalPlayback, 2, 100)
	elseif url[2]=="" then
	else
		PlaySoundFile(url[2], "Master")
	end
end
function Fun.IsAudioNumMaxV(cfv,AudioData)
	if  not AudioData[cfv] or AudioData[cfv] and cfv>#AudioData then
		return 1
	else
		return cfv
	end
end
function PIG_InviteUnit(name)
	local InviteUnit=C_PartyInfo and C_PartyInfo.InviteUnit or InviteUnit
	InviteUnit(name)
end
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
function PIGGetContainerItemInfo(bag, slot)
	if C_Container and C_Container.GetContainerItemInfo then
		local ItemInfo = C_Container.GetContainerItemInfo(bag, slot)
		if ItemInfo then
			return ItemInfo.itemID,ItemInfo.hyperlink,ItemInfo.iconFileID,ItemInfo.stackCount,ItemInfo.quality,ItemInfo.hasNoValue,ItemInfo.hasLoot,ItemInfo.isLocked,ItemInfo.isBound
		end
	else
		local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(bag, slot)
		return itemID, itemLink, icon, stackCount, quality, noValue, lootable, locked, isBound
	end
end
--发送消息
function PIGSendChatRaidParty(txt,GroupLeader,extinfo)
	local Newtxt="[!Pig] "..txt
	if extinfo=="nopig" then
		Newtxt=txt
	end
	if GroupLeader then--限制队长和团长
		if UnitIsGroupLeader("player") then
			if IsInRaid() then
				if extinfo=="W" then
					SendChatMessage(Newtxt, "RAID_WARNING")
				else
					SendChatMessage(Newtxt, "RAID");
				end
			elseif IsInGroup() then
				SendChatMessage(Newtxt, "PARTY");
			end
		end
	else
		if IsInRaid() then
			SendChatMessage(Newtxt, "RAID");
		elseif IsInGroup() then
			SendChatMessage(Newtxt, "PARTY");
		else
			if extinfo=="print" then
				print("|cff00FFFF[!Pig] |r"..txt)
			end
		end
	end
end
local SendAddonMessage=SendAddonMessage or C_ChatInfo and C_ChatInfo.SendAddonMessage
function PIGSendAddonMessage(biaotou,txt,chatType, target)
	SendAddonMessage(biaotou,txt,chatType, target)
end
function PIGSendAddonRaidParty(biaotou,txt)
	if IsInRaid() then
		PIGSendAddonMessage(biaotou,txt,"RAID")
	elseif IsInGroup() then
		PIGSendAddonMessage(biaotou,txt,"PARTY")
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
		print("|cff00FFFF[!Pig] |r|cffFF0000"..msg.."|r");
	elseif colour=="G" then
		print("|cff00FFFF[!Pig] |r|cff00FF00"..msg.."|r");
	else
		print("|cff00FFFF[!Pig] |r|cffFFFF00"..msg.."|r");
	end
end
function PIGGetAddOnInfo(id)
	local GetAddOnInfo=GetAddOnInfo or C_AddOns and C_AddOns.GetAddOnInfo
	return GetAddOnInfo(id)
end
local PIG_GetAddOnEnableState=C_AddOns and C_AddOns.GetAddOnEnableState
if PIG_GetAddOnEnableState==nil then
	local _GetAddOnEnableState = _G.GetAddOnEnableState;
	PIG_GetAddOnEnableState = function(addon, name)
		return _GetAddOnEnableState(name, addon);
	end
end
PIGGetAddOnEnableState=PIG_GetAddOnEnableState
function PIGGetAddOnMetadata(addonName, shuxing)
	local GetAddOnMetadata=GetAddOnMetadata or C_AddOns and C_AddOns.GetAddOnMetadata
	return GetAddOnMetadata(addonName, shuxing)
end
---
if table.clear then
else
	function table.clear(table)
		for k in pairs(table) do
		    table[k] = nil
		end
	end
end
function Fun.PIGSetAtlas(buticon,Atlas,useAtlasSize,hWrapMode,vWrapMode)
	if not addonTable.Data.AtlasInfo then return false end
	for k,v in pairs(addonTable.Data.AtlasInfo) do
		if v[Atlas] then
			buticon:SetTexture(k,hWrapMode,vWrapMode)
			buticon:SetTexCoord(v[Atlas][3], v[Atlas][4], v[Atlas][5], v[Atlas][6])
			return true
		end
	end
	return false
end
function Fun.PIGSetButtonNormalAtlas(buticon,Atlas)
	if not addonTable.Data.AtlasInfo then return false end
	for k,v in pairs(addonTable.Data.AtlasInfo) do
		if v[Atlas] then
			buticon:SetNormalTexture(k)
			buticon:GetNormalTexture():SetTexCoord(v[Atlas][3], v[Atlas][4], v[Atlas][5], v[Atlas][6])
		end
	end
end
function Fun.PIGSetButtonPushedAtlas(buticon,Atlas)
	if not addonTable.Data.AtlasInfo then return false end
	for k,v in pairs(addonTable.Data.AtlasInfo) do
		if v[Atlas] then
			buticon:SetPushedTexture(k)
			buticon:GetPushedTexture():SetTexCoord(v[Atlas][3], v[Atlas][4], v[Atlas][5], v[Atlas][6])
		end
	end
end
function Fun.PIGSetButtonDisabledAtlas(buticon,Atlas)
	if not addonTable.Data.AtlasInfo then return false end
	for k,v in pairs(addonTable.Data.AtlasInfo) do
		if v[Atlas] then
			buticon:SetDisabledTexture(k)
			buticon:GetDisabledTexture():SetTexCoord(v[Atlas][3], v[Atlas][4], v[Atlas][5], v[Atlas][6])
		end
	end
end
function Fun.PIGSetButtonHighlightAtlas(buticon,Atlas)
	if not addonTable.Data.AtlasInfo then return false end
	for k,v in pairs(addonTable.Data.AtlasInfo) do
		if v[Atlas] then
			buticon:SetHighlightTexture(k)
			buticon:GetHighlightTexture():SetTexCoord(v[Atlas][3], v[Atlas][4], v[Atlas][5], v[Atlas][6])
		end
	end
end
function Fun.RGBToHex(t)
	local r,g,b = t.r*255,t.g*255,t.b*255
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return format("%02x%02x%02x", r, g, b)
end
-----
local GetLootMethod=GetLootMethod or C_PartyInfo and C_PartyInfo.GetLootMethod
local SetLootMethod=SetLootMethod or C_PartyInfo and C_PartyInfo.SetLootMethod
local GetSpecialization = GetSpecialization or C_SpecializationInfo and C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo or C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo
local lootList = {
	[0]="freeforall",
	[2]="master",
	[1]="roundrobin",
	[3]="group",
	[4]="needbeforegreed",
	[5]="personal",
}
local lootList_old = {}
for k,v in pairs(lootList) do
	lootList_old[v]=k
end
local lootListIDs = {
	0,1,2,3,4
}
if PIG_MaxTocversion(60000,true) then
	table.insert(lootListIDs,5)
end
local lootListIDNum=#lootListIDs-1
local lootmethodName={
	[0]=LOOT_FREE_FOR_ALL,
	[2]=LOOT_MASTER_LOOTER,
	[1]=LOOT_ROUND_ROBIN,
	[3]=LOOT_GROUP_LOOT,
	[4]=LOOT_NEED_BEFORE_GREED,
	[5]=LOOT_PERSONAL_LOOT,
}
local lootmethodNameJ={
	[0]="自由",
	[2]="队长",
	[1]="轮流",
	[3]="队伍",
	[4]="需求",
	[5]="个人",
}
function Fun.Get_LootTypeData()
	return lootListIDs,lootmethodName,lootmethodNameJ
end
function Fun.Get_LootTypeID(id)
	-- if PIG_MaxTocversion(30000,true) and PIG_MaxTocversion(40000) then
	-- 	return lootList[id]
	-- else
		return id
	--end
end
function Fun.PIG_GetLootMethod()
	local lootmethodID,masterLootPartyID, masterLooterRaidID= GetLootMethod();
	-- if type(lootmethodID)~="number" then
	-- 	return lootList_old[lootmethodID],masterLootPartyID, masterLooterRaidID
	-- else
		return lootmethodID,masterLootPartyID, masterLooterRaidID
	--end
end
local function Update_LootTxt(but)
	if PIG_MaxTocversion() then
		if IsInGroup() then
			but:Enable()
			local lootmethodID= Fun.PIG_GetLootMethod()
			return "\124cff00ff00"..lootmethodNameJ[lootmethodID].."\124r"
		else
			but:Disable();
			return "\124cff555555单人\124r"
		end
	else
		local specID = GetLootSpecialization()--当前拾取专精
		if specID>0 then
			local _, name = GetSpecializationInfoByID(specID)
			return "\124cff00ff00"..name.."\124r"
		else
			local specIndex = GetSpecialization()--当前专精
			if specIndex==5 then
				return "\124cff00ff00无*\124r"
			else
				local _, name = GetSpecializationInfo(specIndex)
				return "\124cff00ff00"..name.."*"
			end
		end
	end
end
function Fun.Update_LootType(uix,funx,set)
	uix:RegisterEvent("PLAYER_ENTERING_WORLD")
	if PIG_MaxTocversion() then
		uix:RegisterEvent("GROUP_ROSTER_UPDATE");
		uix:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");--战利品方法改变时触发
	else
		uix:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED");
	end
	if set then funx(Update_LootTxt(uix)) end
	uix:HookScript("OnEvent", function (self)
		funx(Update_LootTxt(self))
	end)
	uix:HookScript("OnClick", function (self)
		if PIG_MaxTocversion() then
			local lootmethodID= Fun.PIG_GetLootMethod()
			if lootmethodID==lootListIDNum then
				SetLootMethod(Fun.Get_LootTypeID(0))
			else
				local newlootID=lootmethodID+1;
				if newlootID==2 then
					SetLootMethod(Fun.Get_LootTypeID(newlootID),"player")
				else
					SetLootMethod(Fun.Get_LootTypeID(newlootID))
				end
			end
		else
			local numSpecializations = GetNumSpecializations()--总专精数
			local specID = GetLootSpecialization()
			if specID==0 then
				self.specIndex = 1
				local specID, name = GetSpecializationInfo(self.specIndex)
				SetLootSpecialization(specID)
			else
				self.specIndex = self.specIndex+1
				if self.specIndex>numSpecializations then
					SetLootSpecialization(0)
					self.specIndex = 0
				else
					local specID, name = GetSpecializationInfo(self.specIndex)
					SetLootSpecialization(specID)
				end	
			end
		end
	end)
end
function Fun.Delmaohaobiaodain(oldt)
	local oldt=oldt:gsub(" ","");
	local oldt=oldt:gsub("：","");
	local oldt=oldt:gsub(":","");
	return oldt
end
function Fun.tihuankuohao(fullName)
	local fullName = fullName:gsub("%s", "")
	local fullName = fullName:gsub("（", "(")
	local fullName = fullName:gsub("）", ")")
	return fullName
end
--
Fun.pig64='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local genders = {[2]="male", [3]="female",[0]="male",[1]="female",}
--local genders = {[0]="male", [1]="female",[2]="none", [3]="both", [3]="neutral"}
local fixedRaceAtlasNames = {
    ["highmountaintauren"] = "highmountain",
    ["lightforgeddraenei"] = "lightforged",
    ["scourge"] = "undead",
    ["zandalaritroll"] = "zandalari",
};
function Fun.PIGGetRaceAtlas(raceName, gender)
	local gender=tonumber(gender)
	if gender>0 and gender<4 then
		local raceName = lower(raceName)
		if (fixedRaceAtlasNames[raceName]) then
			raceName = fixedRaceAtlasNames[raceName];
		end
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
local p=Fun.pig64
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
	for i=1,#biaoqingData do
		find_NOlink(paichuinfo,newText,biaoqingData[i][1]);
	end
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
local banBanben=10
local ssslist={
	{"57uZ5qKm55qE5aeR5aiY","6b6Z54mZ"},
	{"5aW25aW95LiA6Zif6JCo5ruh","57u05YWL5rSb5bCU"},
	{"VmVybWlu","6ZyH5Zyw6ICF"},
	{"UmlvdGVycw==","6ZyH5Zyw6ICF"},
}
local function is_slist()
	for i=1,#ssslist do
		if PIG_OptionsUI.Name==Fun.Base64_decod(ssslist[i][1]) and PIG_OptionsUI.Realm==Fun.Base64_decod(ssslist[i][2]) then
			return true
		end
	end
	if PIGA["ConfigString"] and PIGA["ConfigString"][2] then
		local ssslist = {strsplit("@", PIGA["ConfigString"][2])};
		for i=1,#ssslist do
			local Namex,Realmx = strsplit("^", ssslist[i]);
			if PIG_OptionsUI.Name==Fun.Base64_decod(Namex) and PIG_OptionsUI.Realm==Fun.Base64_decod(Realmx) then
				return true
			end
		end
	end
	return false
end
Fun.is_slist=is_slist
local function is_slist_1(namex)
	for i=1,#ssslist do
		if namex==Fun.Base64_decod(ssslist[i][1]) and PIG_OptionsUI.Realm==Fun.Base64_decod(ssslist[i][2]) then
			return true
		end
	end
	return false
end
Fun.is_slist_1=is_slist_1
local function Getis_slist()
	local txtxx=tostring(banBanben)
	for i=1,#ssslist do
		if i<#ssslist then
			txtxx=txtxx..ssslist[i][1].."^"..ssslist[i][2].."@"
		else
			txtxx=txtxx..ssslist[i][1].."^"..ssslist[i][2]
		end
	end
	return txtxx
end
local BanList=Getis_slist()
function Fun.fasong_is_slist(funx)
	if not PIGA["ConfigString"] or PIGA["ConfigString"] and banBanben>=PIGA["ConfigString"][1] then
		funx(addonName.."#X#"..BanList)
	end
end
function Fun.Save_is_slist(msg)
	local banben = tonumber(msg:sub(1,2))
	if not PIGA["ConfigString"] or PIGA["ConfigString"] and banben>PIGA["ConfigString"][1] then
		PIGA["ConfigString"]={banben,msg:sub(3)}
	end
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
function Fun.GetpindaoList(kong)
	local chuangkoulist = {[0]=NONE}
	if kong then chuangkoulist[0]=nil end
	for ix=1,NUM_CHAT_WINDOWS do
		local name= GetChatWindowInfo(ix);
		if name and name~="" then
			chuangkoulist[ix]=name
		end
	end
	return chuangkoulist
end
function Fun.GetSelectpindaoID(cfname,moren1)
	local chuangkoulist=Fun.GetpindaoList()
	for k,v in pairs(chuangkoulist) do
	 	if cfname and v==cfname then
	 		return k,v
	 	end
	end 
	if moren1 then 
		return 1,chuangkoulist[1]
	else
		return 0,NONE
	end
end
-- 去除所有 |c 和 |H 格式标签，只保留 [文本] 中的“显示名”
local function GetVisibleLength(text)
    local visible = text:gsub("|H.-|h(.-)|h|r", "%1")  -- 替换物品链接为显示名
    					:gsub("|c%x%x%x%x%x%x%x%x", "")  -- 移除所有颜色开始
						:gsub("|r", "")                      -- 移除所有重置符（可选）
                        :gsub("|T.-|t", "")                   -- 去除图标
    return #visible
end
function Fun.Get_famsg(laiyuan,famsg,CMD_Opne,CMDtxt,otdata)
	if laiyuan=="yell" then
		if CMD_Opne then
			famsg=famsg..Fun.Base64_decod("LOi/m+e7hOaal+WPtw==")..CMDtxt.."";
		end
	elseif laiyuan=="Farm_Yell" then
		if CMD_Opne then
			local lvtxt = Fun.Get_GroupLvTxt();
			famsg=famsg..lvtxt;
		end
	elseif laiyuan=="Farm_huifu" then
		local Auto_lv,Auto_danjia,Fuben_ID,Fuben_G=unpack(otdata)
		if Auto_lv then
			local lvtxt = Fun.Get_GroupLvTxt();
			famsg=famsg..lvtxt;
		end
		if Auto_danjia then
			local danjiatxt = Fun.Get_LvDanjiaTxt(Fuben_ID,Fuben_G);
			famsg=famsg..", "..danjiatxt
		end
		if CMD_Opne then
			famsg=famsg..Fun.Base64_decod("LOi/m+e7hOaal+WPtw==")..CMDtxt..""
		end
	elseif laiyuan=="Farm_chedui" then

	end

	return famsg,GetVisibleLength(famsg)
end
----
function Fun.Key_hebing(str,fengefu)
	local fengefu=fengefu or ","
	local arr = ""
	local numx = #str
	for i=1,numx do
		if i==numx then
			arr=arr..str[i]
		else
			arr=arr..str[i]..fengefu
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
--=================
--压缩数字
-- local pig_yasuo = {}
-- local pig_jieya = {}
-- do
-- 	local xuhao = 1
-- 	for asciiCode = string.byte('A'), string.byte('Z') do
-- 		local char = char(asciiCode)
-- 		pig_yasuo[xuhao]=char
-- 		xuhao=xuhao+1
-- 	end
-- 	for asciiCode = string.byte('a'), string.byte('z') do
-- 		local char = char(asciiCode)
-- 		pig_yasuo[xuhao]=char
-- 		xuhao=xuhao+1
-- 	end
-- 	for asciiCode = string.byte('A'), string.byte('Z') do
-- 		local char = char(asciiCode)
-- 		pig_yasuo[xuhao]=char..char
-- 		xuhao=xuhao+1
-- 	end
-- 	for asciiCode = string.byte('a'), string.byte('z') do
-- 		local char = char(asciiCode)
-- 		pig_yasuo[xuhao]=char..char
-- 		xuhao=xuhao+1
-- 	end
-- 	for asciiCode = string.byte('A'), string.byte('Z') do
-- 		local char = char(asciiCode)
-- 		local charmin = lower(char)
-- 		pig_yasuo[xuhao]=char..charmin
-- 		xuhao=xuhao+1
-- 	end
-- 	for asciiCode = string.byte('A'), string.byte('Z') do
-- 		local char = char(asciiCode)
-- 		local charmin = lower(char)
-- 		pig_yasuo[xuhao]=charmin..char
-- 		xuhao=xuhao+1
-- 	end
-- 	for k,v in pairs(pig_yasuo) do
-- 		pig_jieya[v]=k
-- 	end
-- end
local pig_yasuo = {}
local pig_jieya = {}
do
    local xuhao = 1
    for asciiCode = string.byte('A'), string.byte('Z') do
        local char = char(asciiCode)
        pig_yasuo[xuhao] = char
        xuhao = xuhao + 1
    end
    for asciiCode = string.byte('a'), string.byte('z') do
        local char = char(asciiCode)
        pig_yasuo[xuhao] = char
        xuhao = xuhao + 1
    end
    for asciiCode = string.byte('A'), string.byte('Z') do
        local char = char(asciiCode)
        pig_yasuo[xuhao] = char .. char
        xuhao = xuhao + 1
    end
    for asciiCode = string.byte('a'), string.byte('z') do
        local char = char(asciiCode)
        pig_yasuo[xuhao] = char .. char
        xuhao = xuhao + 1
    end
    for asciiCode = string.byte('A'), string.byte('Z') do
        local char = char(asciiCode)
        local charmin = char:lower()
        pig_yasuo[xuhao] = char .. charmin
        xuhao = xuhao + 1
    end
    for asciiCode = string.byte('A'), string.byte('Z') do
        local char = char(asciiCode)
        local charmin = char:lower()
        pig_yasuo[xuhao] = charmin .. char
        xuhao = xuhao + 1
    end
    for k, v in pairs(pig_yasuo) do
        pig_jieya[v] = k
    end
end
function Fun.yasuo_NumberString(sss)
    if not sss or sss == "" then return "" end
    local txtmsg = ""
    local count = 1
    local lastChar = nil
    for i = 1, #sss do
        local char = sss:sub(i, i)
        if lastChar and (not lastChar:match("%d")) then
            txtmsg = txtmsg .. lastChar
            lastChar = nil
            count = 0
        end
        if char:match("%d") then
            if char == lastChar then
                count = count + 1
            else
                if lastChar and lastChar:match("%d") then
                    if count > 1 then
                        local comp = pig_yasuo[count]
                        txtmsg = txtmsg .. lastChar .. (comp or tostring(count))
                    else
                        txtmsg = txtmsg .. lastChar
                    end
                elseif lastChar then
                    txtmsg = txtmsg .. lastChar
                end
                count = 1
                lastChar = char
            end
        else
            if lastChar and lastChar:match("%d") then
                if count > 1 then
                    local comp = pig_yasuo[count]
                    txtmsg = txtmsg .. lastChar .. (comp or tostring(count))
                else
                    txtmsg = txtmsg .. lastChar
                end
                lastChar = nil
                count = 0
            end
            txtmsg = txtmsg .. char
        end
    end
    if lastChar then
        if lastChar:match("%d") then
            if count > 1 then
                local comp = pig_yasuo[count]
                txtmsg = txtmsg .. lastChar .. (comp or tostring(count))
            else
                txtmsg = txtmsg .. lastChar
            end
        else
            txtmsg = txtmsg .. lastChar
        end
    end
    return txtmsg
end
function Fun.jieya_NumberString(sss)
    if not sss or sss == "" then return "" end
    local txtdec = ""
    local i = 1
    while i <= #sss do
        local char = sss:sub(i, i)
        if char:match("%d") then
            local digit = char
            i = i + 1
            local nextChar1 = sss:sub(i, i)
            if nextChar1 and pig_jieya[nextChar1] then
                local repeatCount = pig_jieya[nextChar1]
                for _ = 1, repeatCount do
                    txtdec = txtdec .. digit
                end
                i = i + 1
            else
                local nextChar2 = sss:sub(i, i + 1)
                if nextChar2 and #nextChar2 == 2 and pig_jieya[nextChar2] then
                    local repeatCount = pig_jieya[nextChar2]
                    for _ = 1, repeatCount do
                        txtdec = txtdec .. digit
                    end
                    i = i + 2
                else
                    txtdec = txtdec .. digit
                end
            end
        else
            txtdec = txtdec .. char
            i = i + 1
        end
    end

    return txtdec
end
--压缩配置
local pig_teshuzifu = {"&","@","#"}
function Fun.quchu_teshufuhao(str)
   	for i=1,#pig_teshuzifu do
        str = str:gsub(pig_teshuzifu[i], "")
    end
    return str
end
local pig_yasuoCF = {
	['"%]=true,']="&",
	['"%]=false,']="@",
	['"%]={%["']="#",
}
local pig_yasuoCF_1 = {
	['"%]=true']="&_",
	['"%]=false']="@_",
	['"%]={']="#_",
}
local pig_yasuoCF_2 = {
	[']="BOTTOMRIGHT"']="&~",
	[']="RIGHT"']="@~",
	[']="CENTER"']="#~",
}
local pig_yasuoCF_3 = {
	['%]=true']="&~",
	['%]=false']="@~",
	['%]={}']="#~",
	['%]="N/A"']="#1",
	['%]=0']="&1",
	['%]=""']="@1",
}
local pig_jieyaCF = {}
local pig_jieyaCF_1 = {}
local pig_jieyaCF_2 = {}
do
	for k,v in pairs(pig_yasuoCF) do
		pig_jieyaCF[v]=k
	end
	for k,v in pairs(pig_yasuoCF_1) do
		pig_jieyaCF_1[v]=k
	end
	for k,v in pairs(pig_yasuoCF_2) do
		pig_jieyaCF_2[v]=k
	end
end
function Fun.yasuo_string(str)
	str = Fun.quchu_teshufuhao(str)
    for key, value in pairs(pig_yasuoCF) do
        str = str:gsub(key, tostring(value))
    end
    for key, value in pairs(pig_yasuoCF_1) do
        str = str:gsub(key, tostring(value))
    end
    for key, value in pairs(pig_yasuoCF_2) do
       str = str:gsub(key, tostring(value))
    end
    return str
end
function Fun.jieya_string(str)
	for key, value in pairs(pig_jieyaCF_2) do
       str = str:gsub(key, tostring(value))
    end
    for key, value in pairs(pig_jieyaCF_1) do
        str = str:gsub(key, tostring(value))
    end
    for key, value in pairs(pig_jieyaCF) do
        str = str:gsub(key, tostring(value))
    end
    return str
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