local addonName, addonTable = ...;
local L=addonTable.locale
local find = _G.string.find
local gsub = _G.string.gsub
local match = _G.string.match
local gmatch=_G.string.gmatch
local Data=addonTable.Data
local Fun=addonTable.Fun
--------------
local QuickChatfun = addonTable.QuickChatfun
local FasongYCqingqiu=addonTable.Fun.FasongYCqingqiu
local GetRaceClassTXT=addonTable.Fun.GetRaceClassTXT
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local GetItemStats=GetItemStats or C_Item and C_Item.GetItemStats
--远程观察图标
local wanjiaxinxil = {}
local ClassColor=Data.ClassColor
local Texwidth,Texheight = 500,500
local gemList = {
	["EMPTY_SOCKET_META"]=136257,--多彩
	["EMPTY_SOCKET_BLUE"]=136256,--蓝色
	["EMPTY_SOCKET_RED"]=136258,--红色
	["EMPTY_SOCKET_YELLOW"]=136259,--黄色
}
local function GetGemList(linkx)
	local baoshiinfo = {}
    local statsg = GetItemStats(linkx)
    if statsg then
	    for key, num in pairs(statsg) do
	        if (key:match("EMPTY_SOCKET_")) then
	            for i = 1, num do
	           		table.insert(baoshiinfo, key)
	            end
	        end
	    end
	end
	return baoshiinfo
end
local function ShowZb_Link_Icon(newText)
	if PIGA["Chat"]["FastCopy"] or PIGA["Chat"]["ShowZb"] then
		local namexShowZb=""
		if PIGA["Chat"]["ClassColor"] then
			namexShowZb = newText:match("%[|cff%w%w%w%w%w%w(.-)|r%]")
		else
			namexShowZb = newText:match("%[.-%].-%[(.-)%]")
		end
		if namexShowZb and namexShowZb~="" and wanjiaxinxil[namexShowZb] then
			if PIGA["Chat"]["FastCopy"] then
				local left=0.08*Texheight+5
				local right=0.92*Texheight-5
				local top=0*Texheight+5
				local bottom=0.95*Texheight-5
				local Copyicon ="|Tinterface/buttons/ui-guildbutton-publicnote-up.blp:0:0:0:0:"..Texheight..":"..Texheight..":"..left..":"..right..":"..top..":"..bottom.."|t"
				if Copyicon~="" then
					newText=newText:gsub("(|Hplayer:(.-)|h%[.-%]|h)", "|Hgarrmission:-999:%2|h"..Copyicon.."|h%1")
				end
			end
			if PIGA["Chat"]["ShowZb"] then
				local _, _, _, englishRace, sex = GetPlayerInfoByGUID(wanjiaxinxil[namexShowZb])
				local raceX = GetRaceClassTXT(0,Texwidth,englishRace,sex)
				if raceX~="" then
					newText=newText:gsub("(|Hplayer:(.-)|h%[.-%]|h)", "|Hgarrmission:-998:%2|h"..raceX.."|h%1")
				end
			end
		end
	end
	if PIGA["Chat"]["ShowLinkIcon"] or PIGA["Chat"]["ShowLinkLV"] or PIGA["Chat"]["ShowLinkSlots"] then
		if newText:match("Hitem:") then
			local tihuanidlist = {}
			for word in newText:gmatch("|(Hitem:.-)|h") do
				tihuanidlist[word] = {}
				if PIGA["Chat"]["ShowLinkIcon"] then
					tihuanidlist[word]["icon"]=GetItemIcon(word)
				end
				if PIGA["Chat"]["ShowLinkLV"] then
					local effectiveILvl, isPreview, baseILvl = GetDetailedItemLevelInfo(word)
					tihuanidlist[word]["LV"]=effectiveILvl or 0
				end
				if PIGA["Chat"]["ShowLinkSlots"] then
					local itemID, itemType, itemSubType, itemEquipLoc = GetItemInfoInstant(word)
					if _G[itemEquipLoc] then
						tihuanidlist[word]["Slots"]=itemSubType.."-".._G[itemEquipLoc]
					end
				end
				if PIGA["Chat"]["ShowLinkGem"] then
				    tihuanidlist[word]["Gem"]=GetGemList(word)
				end
			end
			for k,v in pairs(tihuanidlist) do
				if PIGA["Chat"]["ShowLinkIcon"] then
					newText=newText:gsub("(|cff%w%w%w%w%w%w|"..k.."|h)","|T"..v.icon..":0|t%1");
				end
				if PIGA["Chat"]["ShowLinkLV"] or PIGA["Chat"]["ShowLinkSlots"] then
					local tihuanneirong = ""
					if PIGA["Chat"]["ShowLinkLV"] then
						tihuanneirong=tihuanneirong..v.LV
					end
					if PIGA["Chat"]["ShowLinkSlots"] and v.Slots then
						tihuanneirong=tihuanneirong..v.Slots
					end
					newText=newText:gsub("(|cff%w%w%w%w%w%w|"..k.."|h%[)(.-%]|h|r)","%1("..tihuanneirong..")%2");
					if PIGA["Chat"]["ShowLinkGem"] and #v.Gem>0 then
						local GemTxt = ""
						for ixx=1,#v.Gem do
							GemTxt=GemTxt.."|T"..gemList[v.Gem[ixx]]..":0|t"
						end
						newText=newText:gsub("(|cff%w%w%w%w%w%w|"..k.."|h%[.-%]|h|r)","%1"..GemTxt);
					end
				end
			end
		end
	end
	return newText
end
local is_slist_1=Fun.is_slist_1
local function tiqu_UnitID(self,event,arg1,...)
	local arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12=...
	if arg5 and arg12 then
		local nameg, fuwqi = strsplit("-", arg5);
		if is_slist_1(nameg) then return true end
		if fuwqi==PIG_OptionsUI.Realm then
			wanjiaxinxil[nameg]=arg12
		else
			wanjiaxinxil[arg5]=arg12
		end
	end
	return false
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", tiqu_UnitID)
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMMUNITIES_CHANNEL", tiqu_UnitID)

---精简频道名
local JJM = L["CHAT_QUKBUTNAME"]
local JXname = L["CHAT_JXNAME"]
local function PindaoName(text)
	if PIGA["Chat"]["jingjian"] then
		if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
			local text=text:gsub(" (|Hplayer:.+)", "%1")
			local text=text:gsub("|h%["..SPELL_TARGET_TYPE11_DESC.."%]|h", "|h%["..JJM[3].."%]|h")--队伍
			local text=text:gsub("|h%["..GUILD.."%]|h", "|h%["..JJM[4].."%]|h")--公會
			local text=text:gsub("|h%["..CHAT_MSG_RAID.."%]|h", "|h%["..JJM[5].."%]|h")--团队
			local text=text:gsub("%["..CHAT_MSG_RAID_WARNING.."%]", "%["..JJM[6].."%]")--團隊通告
			local text=text:gsub("|h%["..CHAT_MSG_RAID_LEADER.."%]|h", "|h%["..JXname[2].."%]|h")--团队领袖
			local text=text:gsub("|h%["..CHAT_MSG_BATTLEGROUND.."%]|h", "|h%["..JJM[7].."%]|h")--戰場
			local text=text:gsub("|h%["..INSTANCE_CHAT.."%]|h", "|h%["..JJM[7].."%]|h")--副本
			local text=text:gsub("|h%["..INSTANCE_CHAT_LEADER.."%]|h", "|h%["..JXname[3].."%]|h")--副本向导
			--xuhao
			local text=text:gsub("|h%[(%d+)%. "..GENERAL.."(.-)%]|h", "|h%[%1%."..JJM[8].."%]|h")--综合
			local text=text:gsub("|h%[(%d+)%. "..LOOK_FOR_GROUP.."%]|h", "|h%[%1%."..JJM[10].."%]|h")--寻求组队
			local text=text:gsub("|h%[(%d+)%. 大脚世界频道%]|h", "|h%[%1%."..JJM[11].."%]|h")
			local text=text:gsub("|h%[(%d+)%. PIG%]|h", "|h%[%.PIG%]|h")
			if GetLocale() == "zhCN" then
				local text=text:gsub("(|Hplayer:.-|h)说", "%[说%]%1")
				local text=text:gsub("(|Hplayer:.-|h)喊道", "%[喊%]%1")
				local text=text:gsub("|h%[队长%]|h", "|h%["..JXname[1].."%]|h")--队长
				local text=text:gsub("|h%[小队%]|h", "|h%["..JJM[3].."%]|h")--小队
				--xuhao
				local text=text:gsub("|h%[(%d+)%. "..TRADE.." %- 城市%]|h", "|h%[%1%.交%]|h")
				if PIG_MaxTocversion(100000,true) then
					local text=text:gsub("|h%[(%d+)%. "..TRADE.." %(服务%) %- 城市%]|h", "|h%[%1%.服%]|h")
					local text=text:gsub("|h%[(%d+)%. 新手聊天%]|h", "|h%[%1%.新%]|h")
					return text
				end
				return text
			elseif GetLocale() == "zhTW" then
				local text=text:gsub("(|Hplayer:.-|h)說", "%[說%]%1")
				local text=text:gsub("(|Hplayer:.-|h)喊道", "%[喊%]%1")
				local text=text:gsub("|h%[隊長%]|h", "|h%["..JXname[1].."%]|h")--队长
				local text=text:gsub("|h%[小隊%]|h", "|h%["..JJM[3].."%]|h")--小队
				--xuhao
				local text=text:gsub("|h%[(%d+)%. "..TRADE.." %- 城鎮%]|h", "|h%[%1%.交%]|h")
				if PIG_MaxTocversion(100000,true) then
					local text=text:gsub("|h%[(%d+)%. "..TRADE.." %(服務%) %- 城鎮%]|h", "|h%[%1%.服%]|h")
					local text=text:gsub("|h%[(%d+)%. 新手聊天%]|h", "|h%[%1%.新%]|h")
					return text
				end
				return text
			end
			return text
		end
		return text
	end
	return text
end

--修复点击密语
-- PIG_OptionsUI.Plus_chat = PIGCheckbutton(PIG_OptionsUI,{"BOTTOMRIGHT", PIG_OptionsUI, "TOPRIGHT", -340, 2},{"修复聊天框点击密语","修复聊天框点击密语无效问题"})
-- PIG_OptionsUI.Plus_chat:SetScript("OnClick", function (self)
-- 	if self:GetChecked() then
-- 		PIGA["Chat"]["Plus_chat"]=true;
-- 	else
-- 		PIGA["Chat"]["Plus_chat"]=false;
-- 	end
-- 	PIG_OptionsUI.Plus_chat:Plus_chat_xifu()
-- end);
-- PIG_OptionsUI.Plus_chat:HookScript("OnShow", function(self)
-- 	self:SetChecked(PIGA["Chat"]["Plus_chat"])
-- end)
-- function PIG_OptionsUI.Plus_chat:Plus_chat_xifu()
-- 	if PIGA["Chat"]["Plus_chat"]==nil then PIGA["Chat"]["Plus_chat"] = true end
-- 	if PIGA["Chat"]["Plus_chat"] then
-- 		local old_ChatFrame_SendTell=ChatFrame_SendTell
-- 		ChatFrame_SendTell=function(name, chatFrame,pig)
-- 			local name1,server2 = strsplit("-",name)
-- 			if PIG_OptionsUI.Realm==server2 then
-- 				name = name1
-- 			end
-- 			local editBox = ChatEdit_ChooseBoxForSend(chatFrame);	
-- 			if ( editBox ~= ChatEdit_GetActiveWindow() ) then
-- 				ChatFrame_OpenChat(SLASH_WHISPER1.." "..name.." ", chatFrame);
-- 			else
-- 				editBox:SetText(SLASH_WHISPER1.." "..name.." ");
-- 			end
-- 			ChatEdit_ParseText(editBox, 0);
-- 		end
-- 	end
-- end
--处理非当前本地语言乱码
-- local function PIGPlusxiufuluanma(text)
-- 	local text = text:gsub(":(.-)%-(.-):(.-)%-(.-)|h%[", ":%1:%3|h%[")
-- 	return text
-- end
---
function QuickChatfun.PIGMessage()
	hooksecurefunc("SetItemRef", function(text,link, button, chatFrame)
		-- print(text)
		-- local newTextxx = link:gsub("|", "||")
		-- print(newTextxx)
		if not PIGA["Chat"]["ShowZb"] and not PIGA["Chat"]["FastCopy"] then return end
		if ( strsub(text, 1, 11) ~= "garrmission" ) then return end
		local nametext = strsub(text, 13);
		local gnid,name_server = strsplit(":", nametext);--lineID, chatType, chatTarget
		if PIG_MaxTocversion() then
			local name,server = strsplit("-",name_server)
			if PIG_OptionsUI.Realm==server then
				name_server = name
			end
		end
		if gnid=="-999" and PIGA["Chat"]["FastCopy"] then
			local editBoxXX = ChatEdit_ChooseBoxForSend()
	        local hasText = (editBoxXX:GetText() ~= "")
	        ChatEdit_ActivateChat(editBoxXX)
			if button=="LeftButton" then
				editBoxXX:Insert(name_server)
				if (not hasText) then editBoxXX:HighlightText() end
			else
				for msgid = chatFrame:GetNumMessages(), 1, -1 do
					local msgtext = chatFrame:GetMessageInfo(msgid)
					if msgtext and msgtext:find(text, nil, true) then
						local endjieshu
						local kaishi,jieshu=msgtext:find("|r%]|h:")
						local endjieshu=jieshu
						if not endjieshu then
							local kaishi,jieshu=msgtext:find("|r%]|h： ")
							endjieshu=jieshu
						end
						if endjieshu then
							local newText = strsub(msgtext, endjieshu+1);
							local newText=newText:gsub(" |T.-|t","");
							local newText=newText:gsub("|T.-|t","");
							editBoxXX:Insert(newText)
					        if (not hasText) then editBoxXX:HighlightText() end
					    end
						return
					end
				end
			end
		elseif gnid=="-998" and PIGA["Chat"]["ShowZb"] then
			if button=="LeftButton" then
				FasongYCqingqiu(name_server)
			else
				C_FriendList.SendWho('n-"'..name_server..'"')
			end
		end
	end)
	--PIGA["xxxxxx"]={}
	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 and i~=3 ) then
			local chatID = _G["ChatFrame"..i]
			local msninfo = chatID.AddMessage
			chatID.AddMessage = function(frame, text, ...)
				--local text=text:gsub("|cff%w%w%w%w%w%w|Hmount:.-|h%[","");
				--PIG_ChatFrameKeyWord:AddMessage(text:gsub("|", "||"));
				--if i==1 then table.insert(PIGA["xxxxxx"],text) end
				if text and text~="" and text:match("player") then
					local text=PindaoName(text)
					local text=ShowZb_Link_Icon(text)
					return msninfo(frame, text, ...)
				end
				return msninfo(frame, text, ...)
			end
		end
	end
end