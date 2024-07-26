local addonName, addonTable = ...;
local L=addonTable.locale
local find = _G.string.find
local gsub = _G.string.gsub
local match = _G.string.match
local gmatch=_G.string.gmatch
local _, _, _, tocversion = GetBuildInfo()
local Data=addonTable.Data
--------------
local QuickChatfun = addonTable.QuickChatfun
local FasongYCqingqiu=addonTable.Fun.FasongYCqingqiu
local GetRaceClassTXT=addonTable.Fun.GetRaceClassTXT

--远程观察图标
local wanjiaxinxil = {}
local ClassColor=Data.ClassColor
local Texwidth,Texheight = 500,500
local function ShowZb_Link_Icon(newText)
	if PIGA["Chat"]["ShowZb"] then
		local namexShowZb=""
		if PIGA["Chat"]["ClassColor"] then
			namexShowZb = newText:match("%[|cff%w%w%w%w%w%w(.-)|r%]")
		else
			namexShowZb = newText:match("%[.-%].-%[(.-)%]")
		end	
		if namexShowZb and namexShowZb~="" then
			if wanjiaxinxil[namexShowZb] then
				local _, _, _, englishRace, sex = GetPlayerInfoByGUID(wanjiaxinxil[namexShowZb])
				local raceX = GetRaceClassTXT(0,Texwidth,englishRace,sex)
				if raceX~="" then
					newText=newText:gsub("(|Hplayer:(.-)|h%[.-%]|h)", "|Hgarrmission:%2|h"..raceX.."|h%1")
				end
			end
		end	
	end
	if PIGA["Chat"]["ShowLinkIcon"] then
		if newText:match("Hitem:") then
			local tihuanidlist = {}
			for word in newText:gmatch("|cff%w%w%w%w%w%w|Hitem:(%d-):") do
				tihuanidlist[word]=GetItemIcon(word)
			end
			for k,v in pairs(tihuanidlist) do
				newText=newText:gsub("(|cff%w%w%w%w%w%w|Hitem:"..k..":)"," |T"..v..":0|t%1");
			end
		end
	end
	return newText
end
local function tiqu_UnitID(self,event,arg1,...)
	local arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12=...
	if arg5 and arg12 then
		local nameg, fuwqi = strsplit("-", arg5);
		if fuwqi==Pig_OptionsUI.Realm then
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
			local text=text:gsub("|h%[(%d+)%. PIG%]|h", "|h%[%.PIG%]|h")
			local text=text:gsub("|h%[(%d+)%. 大脚世界频道%]|h", "|h%[%1%."..JJM[12].."%]|h")
			if GetLocale() == "zhCN" then
				local text=text:gsub("(|Hplayer:.-|h)说", "%[说%]%1")
				local text=text:gsub("(|Hplayer:.-|h)喊道", "%[喊%]%1")
				local text=text:gsub("|h%[队长%]|h", "|h%["..JXname[1].."%]|h")--队长
				local text=text:gsub("|h%[小队%]|h", "|h%["..JJM[3].."%]|h")--小队
				--xuhao
				local text=text:gsub("|h%[(%d+)%. "..TRADE.." %- 城市%]|h", "|h%[%1%.交%]|h")
				if tocversion>99999 then
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
				if tocversion>99999 then
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
-- Pig_OptionsUI.Plus_chat = PIGCheckbutton(Pig_OptionsUI,{"BOTTOMRIGHT", Pig_OptionsUI, "TOPRIGHT", -340, 2},{"修复聊天框点击密语","修复聊天框点击密语无效问题"})
-- Pig_OptionsUI.Plus_chat:SetScript("OnClick", function (self)
-- 	if self:GetChecked() then
-- 		PIGA["Chat"]["Plus_chat"]=true;
-- 	else
-- 		PIGA["Chat"]["Plus_chat"]=false;
-- 	end
-- 	Pig_OptionsUI.Plus_chat:Plus_chat_xifu()
-- end);
-- Pig_OptionsUI.Plus_chat:HookScript("OnShow", function(self)
-- 	self:SetChecked(PIGA["Chat"]["Plus_chat"])
-- end)
-- function Pig_OptionsUI.Plus_chat:Plus_chat_xifu()
-- 	if PIGA["Chat"]["Plus_chat"]==nil then PIGA["Chat"]["Plus_chat"] = true end
-- 	if PIGA["Chat"]["Plus_chat"] then
-- 		local old_ChatFrame_SendTell=ChatFrame_SendTell
-- 		ChatFrame_SendTell=function(name, chatFrame,pig)
-- 			local name1,server2 = strsplit("-",name)
-- 			if Pig_OptionsUI.Realm==server2 then
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
	hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
		--print(link)
		-- local newTextxx = text:gsub("|", "||")
		-- print(newTextxx)
		--
		if not PIGA["Chat"]["ShowZb"] then return end
		if ( strsub(link, 1, 11) == "garrmission" ) then
			local namelink = strsub(link, 13);
			--local name_server, lineID, chatType, chatTarget = strsplit(":", namelink);
			local name_server = strsplit(":", namelink);
			if tocversion<100000 then
				local name,server = strsplit("-",name_server)
				if Pig_OptionsUI.Realm==server then
					name_server = name
				end
			end
			if button=="LeftButton" then
				if IsShiftKeyDown() then
					for ixx = chatFrame:GetNumMessages(), 1, -1 do
						local text = chatFrame:GetMessageInfo(ixx)
						if text and text:find(link, nil, true) then
							local kaishi,jieshu=text:find("|r%]|h： ")
							local newText = strsub(text, jieshu+1);
							local newText=newText:gsub(" |T.-|t","");
							local newText=newText:gsub("|T.-|t","");
							local editBoxXX = ChatEdit_ChooseBoxForSend()
					        local hasText = (editBoxXX:GetText() ~= "")
					        ChatEdit_ActivateChat(editBoxXX)
							editBoxXX:Insert(newText)
					        if (not hasText) then editBoxXX:HighlightText() end
							return
						end
					end
				elseif IsControlKeyDown() then
					
				else
					FasongYCqingqiu(name_server)
				end
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
				--ChatFrame99:AddMessage(text:gsub("|", "||"));
				-- if i==1 then
				-- 	table.insert(PIGA["xxxxxx"],text)
				-- end
				if text and text~="" and text:match("player") then
					local text=PindaoName(text)
					local text=ShowZb_Link_Icon(text,frame)
					return msninfo(frame, text, ...)
				end
				return msninfo(frame, text, ...)
			end
		end
	end
end