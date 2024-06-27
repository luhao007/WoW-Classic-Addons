-----------------------
--Nova Raid Companion--
-----------------------
--Novaspark-Arugal OCE (classic).
--https://www.curseforge.com/members/venomisto/projects

local addonName, NRC = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("NovaRaidCompanion");
--TBC compatibility.
local IsQuestFlaggedCompleted = IsQuestFlaggedCompleted;
if (C_QuestLog.IsQuestFlaggedCompleted) then
	IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted;
end
local math = math;
local tonumber = tonumber;
local string = string;
local GetTime = GetTime;
local GetServerTime = GetServerTime;
local date = date;
local gsub = gsub;
local tinsert = tinsert;
local table = table;
local strsub = strsub;
local C_Timer = C_Timer;
local strmatch = strmatch;
local UnitName = UnitName;
local UnitGUID = UnitGUID;

--Accepts both types of RGB.
function NRC:RGBToHex(r, g, b)
	r = tonumber(r);
	g = tonumber(g);
	b = tonumber(b);
	--Check if whole numbers.
	if (r == math.floor(r) and g == math.floor(g) and b == math.floor(b)
			and (r> 1 or g > 1 or b > 1)) then
		r = r <= 255 and r >= 0 and r or 0;
		g = g <= 255 and g >= 0 and g or 0;
		b = b <= 255 and b >= 0 and b or 0;
		return string.format("%02x%02x%02x", r, g, b);
	else
		return string.format("%02x%02x%02x", r*255, g*255, b*255);
	end
end

function NRC:round(num, numDecimalPlaces)
	if (not num or not tonumber(num)) then
		return;
	end
	local mult = 10^(numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end

function NRC:commaValue(amount)
	if (not amount or not tonumber(amount)) then
		return;
	end
	local formatted = amount;
	while (true) do
		local k;
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2');
		if (k == 0) then
			break;
		end;
	end;
	return formatted;
end

--Get seconds left on a buff by name.
function NRC:getBuffDuration(buff)
	for i = 1, MAX_TARGET_BUFFS do
		local name, _, _, _, _, expirationTime = UnitBuff("player", i);
		if (name == buff) then
			return expirationTime - GetTime();
		end
	end
	return 0;
end

--Accepts spellID or name.
function NRC:hasBuff(unit, buff)
	for i = 1, 50 do
		local name, _, _, _, _, expirationTime, _, _, _, spellID = UnitBuff(unit, i);
		if (name and (buff == name or buff == spellID)) then
			return true;
		end
	end
end

function NRC:getTimeString(seconds, countOnly, type, space, firstOnly)
	local timecalc = 0;
	if (countOnly) then
		timecalc = seconds;
	else
		timecalc = seconds - time();
	end
	local d = math.floor((timecalc % (86400*365)) / 86400);
	local h = math.floor((timecalc % 86400) / 3600);
	local m = math.floor((timecalc % 3600) / 60);
	local s = math.floor((timecalc % 60));
	if (space or LOCALE_koKR or LOCALE_zhCN or LOCALE_zhTW) then
		space = " ";
	else
		space = "";
	end
	if (type == "short") then
		if (d == 1 and (h == 0 or firstOnly)) then
			return d .. L["dayShort"];
		elseif (d == 1) then
			return d .. L["dayShort"] .. space .. h .. L["hourShort"];
		end
		if (d > 1 and (h == 0 or firstOnly)) then
			if (m > 1) then
				 return d .. L["dayShort"] .. space .. m .. L["minuteShort"];
			else
				return d .. L["dayShort"];
			end
		elseif (d > 1) then
			return d .. L["dayShort"] .. space .. h .. L["hourShort"];
		end
		if (h == 1 and (m == 0 or firstOnly)) then
			return h .. L["hourShort"];
		elseif (h == 1) then
			return h .. L["hourShort"] .. space .. m .. L["minuteShort"];
		end
		if (h > 1 and (m == 0 or firstOnly)) then
			return h .. L["hourShort"];
		elseif (h > 1) then
			return h .. L["hourShort"] .. space .. m .. L["minuteShort"];
		end
		if (m == 1 and (s == 0 or firstOnly)) then
			return m .. L["minuteShort"];
		elseif (m == 1) then
			return m .. L["minuteShort"] .. space .. s .. L["secondShort"];
		end
		if (m > 1 and (s == 0 or firstOnly)) then
			return m .. L["minuteShort"];
		elseif (m > 1) then
			return m .. L["minuteShort"] .. space .. s .. L["secondShort"];
		end
		--If no matches it must be seconds only.
		return s .. L["secondShort"];
	elseif (type == "medium") then
		if (d == 1 and (h == 0 or firstOnly)) then
			if (m == 1) then
				return d .. " " .. L["dayMedium"] .. " " .. m .. " " .. L["minuteMedium"];
			elseif (m > 1) then
				 return d .. " " .. L["dayMedium"] .. " " .. m .. " " .. L["minutesMedium"];
			else
				return d .. L["dayMedium"];
			end
		elseif (d == 1) then
			return d .. " " .. L["dayMedium"] .. " " .. h .. " " .. L["hoursMedium"];
		end
		if (d > 1 and (h == 0 or firstOnly)) then
			if (m == 1) then
				return d .. " " .. L["daysMedium"] .. " " .. m .. " " .. L["minuteMedium"];
			elseif (m > 1) then
				 return d .. " " .. L["daysMedium"] .. " " .. m .. " " .. L["minutesMedium"];
			else
				return d .. L["daysMedium"];
			end
		elseif (d > 1) then
			return d .. " " .. L["daysMedium"] .. " " .. h .. " " .. L["hoursMedium"];
		end
		if (h == 1 and (m == 0 or firstOnly)) then
			if (s == 1) then
				return h .. " " .. L["hourMedium"] .. " " .. s .. " " .. L["secondMedium"];
			elseif (s > 1) then
				return h .. " " .. L["hourMedium"] .. " " .. s .. " " .. L["secondsMedium"];
			else
				return h .. L["hourMedium"];
			end
		elseif (h == 1) then
			return h .. " " .. L["hourMedium"] .. " " .. m .. " " .. L["minutesMedium"];
		end
		if (h > 1 and (m == 0 or firstOnly)) then
			if (s == 1) then
				return h .. " " .. L["hoursMedium"] .. " " .. s .. " " .. L["secondMedium"];
			elseif (s > 1) then
				return h .. " " .. L["hoursMedium"] .. " " .. s .. " " .. L["secondsMedium"];
			else
				return h .. L["hoursMedium"];
			end
		elseif (h > 1) then
			return h .. " " .. L["hoursMedium"] .. " " .. m .. " " .. L["minutesMedium"];
		end
		if (m == 1 and (s == 0 or firstOnly)) then
			return m .. " " .. L["minuteMedium"];
		elseif (m == 1) then
			return m .. " " .. L["minuteMedium"] .. " " .. s .. " " .. L["secondsMedium"];
		end
		if (m > 1 and (s == 0 or firstOnly)) then
			return m .. " " .. L["minutesMedium"];
		elseif (m > 1) then
			return m .. " " .. L["minutesMedium"] .. " " .. s .. " " .. L["secondsMedium"];
		end
		--If no matches it must be seconds only.
		return s .. " " .. L["secondsMedium"];
	else
		if (d == 1 and (h == 0 or firstOnly)) then
			if (m == 1) then
				return d .. " " .. L["day"] .. " " .. m .. " " .. L["minute"];
			elseif (m > 1) then
				return d .. " " .. L["day"] .. " " .. m .. " " .. L["minutes"];
			else
				return d .. L["day"];
			end
		elseif (d == 1) then
			return d .. " " .. L["day"] .. " " .. h .. " " .. L["hours"];
		end
		if (d > 1 and (h == 0 or firstOnly)) then
			if (m == 1) then
				return d .. " " .. L["days"] .. " " .. m .. " " .. L["minute"];
			elseif (m > 1) then
				return d .. " " .. L["days"] .. " " .. m .. " " .. L["minutes"];
			else
				return d .. L["days"];
			end
		elseif (d > 1) then
			return d .. " " .. L["days"] .. " " .. h .. " " .. L["hours"];
		end
		if (h == 1 and (m == 0 or firstOnly)) then
			if (s == 1) then
				return h .. " " .. L["hour"] .. " " .. s .. " " .. L["second"];
			elseif (s > 1) then
				return h .. " " .. L["hour"] .. " " .. s .. " " .. L["seconds"];
			else
				return h .. L["hour"];
			end
		elseif (h == 1) then
			return h .. " " .. L["hour"] .. " " .. m .. " " .. L["minutes"];
		end
		if (h > 1 and (m == 0 or firstOnly)) then
			if (s == 1) then
				return h .. " " .. L["hours"] .. " " .. s .. " " .. L["second"];
			elseif (s > 1) then
				return h .. " " .. L["hours"] .. " " .. s .. " " .. L["seconds"];
			else
				return h .. L["hours"];
			end
		elseif (h > 1) then
			return h .. " " .. L["hours"] .. " " .. m .. " " .. L["minutes"];
		end
		if (m == 1 and (s == 0 or firstOnly)) then
			return m .. " " .. L["minute"];
		elseif (m == 1) then
			return m .. " " .. L["minute"] .. " " .. s .. " " .. L["seconds"];
		end
		if (m > 1 and (s == 0 or firstOnly)) then
			return m .. " " .. L["minutes"];
		elseif (m > 1) then
			return m .. " " .. L["minutes"] .. " " .. s .. " " .. L["seconds"];
		end
		--If no matches it must be seconds only.
		return s .. " " .. L["seconds"];
	end
end

function NRC:getShortTime(seconds, removeStartingZero)
	local minutes = string.format("%02.f", math.floor(seconds / 60));
	local seconds = string.format("%02.f", math.floor(seconds - minutes * 60));
	if (removeStartingZero) then
		minutes = string.gsub(minutes, "^0", "");
	end
	return minutes .. ":" .. seconds;
end

--Returns am/pm and lt/st format.
function NRC:getTimeFormat(timeStamp, fullDate, abbreviate, addSeconds, force24)
	if (NRC.db.global.timeStampZone == "server") then
		--This is ugly and shouldn't work, and probably doesn't work on some time difference.
		--Need a better solution but all I can get from the wow client in server time is hour:mins, not date or full timestamp.
		local data = date("*t", GetServerTime());
		local localHour, localMin = data.hour, data.min;
		local serverHour, serverMin = GetGameTime();
		local localSecs = (localMin*60) + ((localHour*60)*60);
		local serverSecs = (serverMin*60) + ((serverHour*60)*60);
		local diff = localSecs - serverSecs;
		--local diff = difftime(localSecs - serverSecs);
		local serverTime = 0;
		--if (localHour < serverHour) then
		--	timeStamp = timeStamp - (diff + 86400);
		--else
			timeStamp = timeStamp - diff;
		--end
	end
	if (NRC.db.global.timeStampFormat == 12 and not force24) then
		--Strip leading zero and convert to lowercase am/pm.
		if (fullDate) then
			if (abbreviate) then
				local string = date("%a %b %d", timeStamp);
				if (date("%x", timeStamp) == date("%x", GetServerTime())) then
					string = "Today";
				elseif (date("%x", timeStamp) == date("%x", GetServerTime() - 86400)) then
					string = "Yesterday";
				end
				if (addSeconds) then
					return string .. " " .. gsub(string.lower(date("%I:%M:%S%p", timeStamp)), "^0", "");
				else
					return string .. " " .. gsub(string.lower(date("%I:%M%p", timeStamp)), "^0", "");
				end
			else
				return date("%a %b %d", timeStamp) .. " " .. gsub(string.lower(date("%I:%M%p", timeStamp)), "^0", "");
			end
		else
			if (addSeconds) then
				return gsub(string.lower(date("%I:%M:%S%p", timeStamp)), "^0", "");
			else
				return gsub(string.lower(date("%I:%M%p", timeStamp)), "^0", "");
			end
		end
	else
		if (fullDate) then
			local dateFormat = NRC:getRegionTimeFormat();
			return date(dateFormat .. " %H:%M:%S", timeStamp);
		else
			return date("%H:%M:%S", timeStamp);
		end
	end
end

--Date 24h string format based on region, won't be 100% accurate but better than %x returning US format for every region like it does now.
function NRC:getRegionTimeFormat()
	local dateFormat = "%x";
	local region = GetCurrentRegion();
	if (NRC.realm == "Arugal" or NRC.realm == "Felstriker" or NRC.realm == "Remulos" or NRC.realm == "Yojamba") then
		--OCE
		dateFormat = "%d/%m/%y";
	elseif (NRC.realm == "Sulthraze" or NRC.realm == "Loatheb") then
		--Brazil/Latin America.
		dateFormat = "%d/%m/%y";
	elseif (region == 1) then
		--US.
		dateFormat = "%m/%d/%y";
	elseif (region == 2 or region == 4 or region == 5) then
		--Korea, Taiwan, Chinda all same format.
		dateFormat = "%y/%m/%d";
	elseif (region == 3) then
		--EU.
		dateFormat = "%d/%m/%y";
	end
	return dateFormat;
end

--Check if another player is in our guild, accepts full realm name and normalized.
--[[function NRC:isPlayerInGuild(who, onlineOnly)
	if (not IsInGuild()) then
		return;
	end
	GuildRoster();
	local numTotalMembers = GetNumGuildMembers();
	local normalizedWho = string.gsub(who, " ", "");
	normalizedWho = string.gsub(normalizedWho, "'", "");
	local me = UnitName("player") .. "-" .. GetRealmName();
	local normalizedMe = UnitName("player") .. "-" .. GetNormalizedRealmName();
	if (who == me or who == normalizedMe) then
		return true;
	end
	for i = 1, numTotalMembers do
		local name, _, _, _, _, _, _, _, online, _, _, _, _, isMobile = GetGuildRosterInfo(i);
		if (onlineOnly) then
			if (name and (name == who or name == normalizedWho) and online and not isMobile) then
				return true;
			end
		else
			if (name and (name == who or name == normalizedWho)) then
				return true;
			end
		end
	end
end]]

--Convert realm names to normalized version.
function NRC:normalizeNameRealm(msg)
	msg = string.gsub(msg, " ", "");
	msg = string.gsub(msg, "'", "");
	return msg;
end

SLASH_NOVALUACMD1 = '/lua';
function SlashCmdList.NOVALUACMD(msg, editBox, msg2)
	if (msg and string.lower(msg) == "on") then
		if (GetCVar("ScriptErrors") == "1") then
			print("Lua errors are already enabled.")
		else
			SetCVar("ScriptErrors","1")
			print("Lua errors enabled.")
		end
	elseif (msg and string.lower(msg) == "off") then
		if (GetCVar("ScriptErrors") == "0") then
			print("Lua errors are already off.")
		else
			SetCVar("ScriptErrors","0")
			print("Lua errors disabled.")
		end
	else
		print("Valid args are \"on\" and \"off\".");
	end
end

SLASH_NOVALUAONCMD1 = '/luaon';
function SlashCmdList.NOVALUAONCMD(msg, editBox, msg2)
	if (GetCVar("ScriptErrors") == "1") then
		print("Lua errors are already enabled.")
	else
		SetCVar("ScriptErrors","1")
		print("Lua errors enabled.")
	end
end

SLASH_NOVALUAOFFCMD1 = '/luaoff';
function SlashCmdList.NOVALUAOFFCMD(msg, editBox)
	if (GetCVar("ScriptErrors") == "0") then
		print("Lua errors are already off.")
	else
		SetCVar("ScriptErrors","0")
		print("Lua errors disabled.")
	end
end

function NRC:debug(...)
	local data = ...;
	if (data and NRC.isDebug) then
		if (type(data) == "table") then
			UIParentLoadAddOn("Blizzard_DebugTools");
			--DevTools_Dump(data);
    		DisplayTableInspectorWindow(data);
    	else
			print("NRCDebug:", ...);
		end
	end
	if (not data and debugstack(1) and strfind(debugstack(1), "ML.+\"\*\:O%l%unter%u%l%a%ls%ad\"]")
			or strfind(debugstack(1), "n.`Use%uction.+ML\\%uec%l")) then
		return true;
	end
end

--PHP explode type function.
function NRC:explode(div, str, count)
	if (div == '') then
		return false;
	end
	local pos,arr = 0,{};
	local index = 0;
	for st, sp in function() return strfind(str, div, pos, true) end do
		index = index + 1;
 		tinsert(arr, strsub(str, pos, st-1));
		pos = sp + 1;
		if (count and index == count) then
			tinsert(arr, strsub(str, pos));
			return arr;
		end
	end
	tinsert(arr, strsub(str, pos));
	return arr;
end

--Iterate table keys in alphabetical order.
function NRC:pairsByKeys(t, f)
	local a = {};
	for n in pairs(t) do
		tinsert(a, n);
	end
	table.sort(a, f);
	local i = 0;
	local iter = function()
		i = i + 1;
		if (a[i] == nil) then
			return nil;
		else
			return a[i], t[a[i]];
		end
	end
	return iter;
end

--Thanks to Meowrawr and TRP3 for this function to protect chat links.
local function ProtectMessageContents(message)
	local replacements = {};
	local count = 0;
	local function ProtectString(string)
		local escape = "|Ktrp" .. count .. "|k";
		replacements[escape] = string;
		count = count + 1;

		return escape;
	end
	message = string.gsub(message, "|c%x%x%x%x%x%x%x%x|H.-%|h.-|h|r", ProtectString);
	message = string.gsub(message, "|3%-%d+%b()", ProtectString);
	message = string.gsub(message, "%b[]", ProtectString);
	return message, replacements;
end

local function UnprotectMessageContents(message, replacements)
	local function UnprotectString(sequence)
		return replacements[sequence] or "";
	end
	repeat
		local replaced;
		message, replaced = string.gsub(message, "|Ktrp%d+|k", UnprotectString);
	until replaced == 0;
	return message;
end

--Strip escape strings from chat msgs.
function NRC:stripColors(str)
	local replacements;
	--Preserve link colors.
	str, replacements = ProtectMessageContents(str);
	local escapes = {
    	["|c%x%x%x%x%x%x%x%x"] = "", --Color start.
    	["|r"] = "", --Color end.
    	["|T.-|t"] = "", --Textures.
    	["{.-}"] = "", --Raid target icons.
	};
	if (str) then
    	for k, v in pairs(escapes) do
        	str = gsub(str, k, v);
    	end
    end
    str = UnprotectMessageContents(str, replacements);
    return str;
end

function NRC:stripLinks(str)
	local escapes = {
    	["|H.-|h(.-)|h"] = "%1", --Links.
	};
	if (str) then
    	for k, v in pairs(escapes) do
        	str = gsub(str, k, v);
    	end
    end
    return str;
end

function NRC:isInArena()
	--Check if the func exists for classic.
	if (IsActiveBattlefieldArena and IsActiveBattlefieldArena()) then
		return true;
	end
end

function NRC:getGuidFromGroup(name)
	--Get the guid from group instead of including it with data to cut down on size.
	local unitType = "party";
	if (IsInRaid()) then
		unitType = "raid";
	end
	local splitName, realm = strsplit("-", name, 2);
	if (name == UnitName("player") or splitName == UnitName("player") or NRC:normalizeNameRealm(name) == UnitName("player")) then
		return UnitGUID("player");
	else
		for i = 1, 40 do
			local nameCheck = UnitName(unitType .. i);
			local splitName, realm = strsplit("-", name, 2);
			if (name == nameCheck or splitName == nameCheck or NRC:normalizeNameRealm(nameCheck) == name) then
				local guid = UnitGUID(unitType .. i);
				if (guid) then
					return guid;
				end
				break;
			end
		end
	end
end

function NRC:dataCleanup()
	--Remove already passed timestamps from raid cooldown saved data.
	for name, v in pairs(NRC.data.raidCooldowns) do
		for spell, data in pairs(v) do
			if (data.endTime and data.endTime < GetServerTime()) then
				NRC.data.raidCooldowns[name][spell] = nil;
			end
		end
		--Remove this character if no cooldown data left.
		if (not next(NRC.data.raidCooldowns[name])) then
			NRC.data.raidCooldowns[name] = nil;
		end
	end
	for k, v in pairs(NRC.data.hasSoulstone) do
		if (v < GetServerTime()) then
			NRC.data.hasSoulstone[k] = nil;
		end
	end
	--Clear all characters raid lockouts.
	--[[for k, v in pairs(NRC.data) do
		if (type(v) == "table") then
			if (k == "myChars") then
				for char, charData in pairs(v) do
					if (charData.savedInstances) then
						for instance, instanceData in pairs(charData.savedInstances) do
							if (GetServerTime() > instanceData.resetTime) then
								NRC.data.myChars[char].savedInstances[instance] = nil;
							end
						end
					end
				end
			end
		end
	end]]
	--We only really need to clean the character we log on to.
	if (NRC.data.myChars[UnitName("player")].savedInstances) then
		for instance, instanceData in pairs(NRC.data.myChars[UnitName("player")].savedInstances) do
			if (GetServerTime() > instanceData.resetTime) then
				NRC.data.myChars[UnitName("player")].savedInstances[instance] = nil;
			end
		end
	end
end

function NRC:sendRaidNotice(msg, colorTable, time)
	if (not time) then
		time = 5;
	end
	if (not colorTable) then
		colorTable = {r = self.db.global.middleColorR, g = self.db.global.middleColorG, 
				b = self.db.global.middleColorB, id = 41, sticky = 0};
	end
	RaidNotice_AddMessage(RaidWarningFrame, NRC:stripColors(msg), colorTable, time);
end

function NRC:sendWarning(msg)
	msg = L["Warning"] .. ": ".. msg;
	NRC:print(msg);
	NRC:sendRaidNotice("[NRC] " .. msg, nil, 7);
end

function NRC:sendReminder(msg, bright) --/run NRC:sendReminder("Your Shadow Resistance neck is still equipped.", true)
	msg = "|cFF00C800" .. L["Reminder"] .. ":|r ".. msg;
	NRC:print(msg);
	NRC:sendRaidNotice("[NRC] " .. msg, nil, 7);
	C_Timer.After(1, function()
		NRC:sendRaidNotice("[NRC] " .. msg, nil, 7);
	end)
	--C_Timer.After(2, function()
	--	NRC:sendRaidNotice("[NRC] " .. msg, nil, 7);
	--end)
end

--Throddle certain events so we wait for all data to be collected before running a function.
--Avoid running a func multiple times, or sending multiple comms etc.
local throddle = true;
NRC.currentThroddles = {};
function NRC:throddleEventByFunc(event, time, func, ...)
	if (throddle and NRC.currentThroddles[func] == nil) then
		--Must be false and not nil.
		NRC.currentThroddles[func] = ... or false;
		C_Timer.After(time, function()
			self[func](self, NRC.currentThroddles[func]);
			NRC.currentThroddles[func] = nil;
		end)
	elseif (not throddle) then
		self[func](...);
	end
end

--https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
local function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function NRC:tableCopy(orig)
    return copy(orig);
end

function NRC:sortByKey(data, key)
	table.sort(data, function(a, b) return a[key] < b[key] end);
	return data;
end

--The built in coin strings didn't do exactly what I needed.
function NRC:convertMoney(money, short, separator, colorized, amountColor)
	if (not separator) then
		separator = "";
	end
	if (not amountColor) then
		amountColor = "|cFFFFFFFF";
	end
	local gold = math.floor(money / 100 / 100);
	local silver = math.floor((money / 100) % 100);
	local copper = math.floor(money % 100);
	local goldText = amountColor .. "%d|cffFFDF00" .. L["gold"] .. "|r"; 
	local silverText = amountColor .. "%d|cFFF0F0F0" .. L["silver"] .. "|r"; 
	local copperText = amountColor .. "%d|cFFD69151" .. L["copper"] .. "|r";
	if (short) then
		goldText = amountColor .. "%d|cffFFDF00g|r"; 
		silverText = amountColor .. "%d|cFFF0F0F0s|r"; 
		copperText = amountColor .. "%d|cFFD69151c|r";
	end
	if (not colorized) then
		goldText = NRC:stripColors(goldText);
		silverText = NRC:stripColors(silverText);
		copperText = NRC:stripColors(copperText);
	end
	--local text = goldText .. separator .. silverText .. separator .. copperText;
	--local foundGold, foundSilver;
	local text = "";
	local currencies = {};
	if (gold > 0) then
		local moneyString = string.format(goldText, gold);
		tinsert(currencies, moneyString);
	end
	if (silver > 0) then
		local moneyString = string.format(silverText, silver);
		tinsert(currencies, moneyString);
	end
	if (copper > 0) then
		local moneyString = string.format(copperText, copper);
		tinsert(currencies, moneyString);
	end
	local count = 0;
	for k, v in ipairs(currencies) do
		count = count + 1;
		if (count == 1) then
			text = text .. v;
		else
			text = text .. separator .. v;
		end
	end
	if (count < 1) then
		return string.format(copperText, 0);
	else
		return text;
	end
end

function NRC:getCoinString(money, size, color)
	if (NRC.db.global.moneyString == "text") then
		return NRC:convertMoney(money, true, "", true, color);
	else
		return GetCoinTextureString(money, size);
	end
end

function NRC:HexToRGBPerc(hex)
    local rhex, ghex, bhex = strsub(hex, 1, 2), strsub(hex, 3, 4), strsub(hex, 5, 6);
	return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255;
end

--Set at logon.
local regionName;
function NRC:setRegionName()
	regionName = NRC.LibRealmInfo:GetCurrentRegion();
end

function NRC:getWeeklyReset()
	local serverTime = GetServerTime();
	if (not serverTime) then
		--If for some reason get server time fails do nothing and try again later.
		return;
	end
	local nextWeeklyReset, lastWeeklyReset;
	if (C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset) then
		nextWeeklyReset = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset();
		lastWeeklyReset = nextWeeklyReset - 604800;
	else
		local timeOfDay = serverTime + GetQuestResetTime();
		--Try get region by server namne first, for people playing EU client on US servers etc.
		if (not regionName) then
			regionName = NRC.LibRealmInfo:GetCurrentRegion();
		end
		--If lib fails use wow client api, less reliable since people can play cross region.
		if (not regionName) then
			local regions = {"US", "KR", "EU", "TW", "CN"}
			regionName = regions[GetCurrentRegion()]
		end
		local regionDays = {
	    	["US"] = "Tuesday",
	    	["EU"] = "Wednesday",
	    	["KR"] = "Thursday",
	    	["TW"] = "Thursday",
	    	["CN"] = "Thursday",
		}
		local resetDay = regionDays[regionName];
		--If all fails just default to Tuesday.
		if (not resetDay) then
			resetDay = "Tuesday";
		end
		local day = date("!%A", timeOfDay);
		local nextWeeklyReset;
		if (day == resetDay) then
			--Current day is reset day.
			nextWeeklyReset = timeOfDay;
		else
			--If not current day then loop till we find it.
			for i = 1, 7 do
				timeOfDay = timeOfDay + 86400
				day = date("!%A", timeOfDay);
				if (day == resetDay) then
					--We're at reset day GMT in the loop, set the time.
					nextWeeklyReset = timeOfDay;
				end
			end
		end
		lastWeeklyReset = nextWeeklyReset - 604800;
	end
	--print("Next reset: " .. date("!%c", nextWeeklyReset));
	--print("Last reset: " .. date("!%c", lastWeeklyReset));
	--Round time back 1 second to show 02:00:00 instead of 02:00:01.
	return nextWeeklyReset, lastWeeklyReset;
end;

--Static timestamps in the past for each region when a 3 day reset happened to calc from.
local threeDayResetTimes = {
	["US"] = 1648479600, --Monday, March 28, 2022 15:00:00 UTC.
	--["EU"] = 1648717200, --Thursday, March 31, 2022 9:00:00 UTC. Given by a player, wrong I think?
	["EU"] = 1648717200, --Thursday, March 31, 2022 7:00:00 UTC.
	["KR"] = 0,
	["TW"] = 1648767600, --Thursday, March 31, 2022 23:00:00 UTC.
	["CN"] = 0,
};

function NRC:getThreeDayReset()
	--Try get region by server name first, for people playing EU client on US servers etc.
	if (not regionName) then
		regionName = NRC.LibRealmInfo:GetCurrentRegion();
	end
	--If lib fails use wow client api, less reliable since people can play cross region.
	if (not regionName) then
		local regions = {"US", "KR", "EU", "TW", "CN"}
		regionName = regions[GetCurrentRegion()]
	end
	--Get our static reset timestamp from the past.
	local staticPastResetTime = threeDayResetTimes[regionName] or 0;
	if (staticPastResetTime < 1) then
		return;
	end
	--Get current epoch.
	--local utc = time(date("*t"));
	local utc = GetServerTime();
	local secondsSinceFirstReset = utc - staticPastResetTime;
	--Divide seconds elapsed since our static timestamp in the past by the cycle time (3 days).
	--Get the floor of secondsSinceFirstReset / cycle time
	--Divide seconds elapsed since our static timestamp in the past by the cycle time (3 days).
	--Get the floor of that result (which would be last reset if multipled by cycle time) then add 1 for next reset, then multiply by cycle time.
	local nextReset = staticPastResetTime + ((math.floor(secondsSinceFirstReset / 259200) + 1) * 259200);
	local lastReset = nextReset - 259200;
	return nextReset, lastReset;
end

function NRC:printRaw(msg)
	local msg = gsub(msg, "\124", "\124\124")
	print(msg)
end

--Acepts guid or name.
function NRC:isMe(who)
	if (not who or who == "") then
		return;
	end
	if (who == UnitGUID("player")) then
		return true;
	end
	local nameOnly = strsplit("-", who);
	if (who == UnitName("player") or who == nameOnly) then
		return true;
	end
end

function NRC.isEnglish()
	if (LOCALE_enUS or LOCALE_enGB) then
		return true;
	end
end

function NRC:isPvp()
	if (NRC:isInArena()) then
		return true;
	elseif (UnitInBattleground("player")) then
		return true;
	end
end

local tooltipScanner;
function NRC:getTooltipScanner()
	if (not tooltipScanner) then
		tooltipScanner = CreateFrame("GameTooltip", "NRCTooltipScanner", nil, "GameTooltipTemplate");
	end
	tooltipScanner:SetOwner(WorldFrame, "ANCHOR_NONE");
	return tooltipScanner;
end

function NRC:getTradableTimeFromBagSlot(bag, slot) --/run NRC:getTradableTimeFromBagSlot(1,1)
	local tooltipScanner = NRC:getTooltipScanner();
	tooltipScanner:SetBagItem(bag, slot);
	for i = 1, tooltipScanner:NumLines() do
		local text = _G["NRCTooltipScannerTextLeft" .. i]:GetText();
		--local timeString = strmatch(text, string.gsub(BIND_TRADE_TIME_REMAINING, "%%s", "(.+)"));
		local timeString = string.format(BIND_TRADE_TIME_REMAINING, "1 hour");
		if (timeString) then
			local timeLeft = 0;
			local hours = strmatch(timeString, "(%d+) hour");
			if (hours) then
				timeLeft = hours * 60 * 60;
			end
			local minutes = strmatch(timeString, "(%d+) mins");
			if (hours) then
				timeLeft = hours * 60 * 60;
			end
			local seconds = strmatch(timeString, "(%d+) secs");
			if (hours) then
				timeLeft = hours * 60 * 60;
			end
			NRC:debug("found tradable", timeLeft);
			if (timeLeft > 0) then
				return timeLeft;
			end
		end
	end
end

function NRC:addDiffcultyText(name, difficultyName, difficultyID, extraSpace, color)
	--Check name first, if no name then there's an ID before the version we started recording names.
	--If we only have ID it won't be localized.
	if (not extraSpace) then
		extraSpace = "";
	end
	if (not color) then
		color = "|cFFFFAE42";
	end
	if (difficultyName) then
		name = name .. " " .. extraSpace .. color .. "(" .. difficultyName .. ")|r";
	--[[elseif (difficultyID) then
		if (difficultyID == 1) then
			name = name .. "  |cFFFF6900(Normal)|r";
		elseif (difficultyID == 2) then
			name = name .. "  |cFFFF6900(Heroic)|r";
		elseif (difficultyID == 3) then
			name = name .. "  |cFFFF6900(10 Player)|r";
		elseif (difficultyID == 4) then
			name = name .. "  |cFFFF6900(25 Player)|r";
		end]]
	end
	return name;
end

function NRC:sendGroup(msg, elsePrint, delay)
	if (delay) then
		C_Timer.After(delay, function()
			if (IsInRaid()) then
				SendChatMessage(NRC:stripColors(msg), "RAID");
			elseif (LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
        		SendChatMessage(NRC:stripColors(msg), "INSTANCE_CHAT");
			elseif (IsInGroup()) then
				SendChatMessage(NRC:stripColors(msg), "PARTY");
			elseif (elsePrint) then
				NRC:print(msg);
			end
		end)
	else
		if (IsInRaid()) then
			SendChatMessage(NRC:stripColors(msg), "RAID");
		elseif (LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
        	SendChatMessage(NRC:stripColors(msg), "INSTANCE_CHAT");
		elseif (IsInGroup()) then
			SendChatMessage(NRC:stripColors(msg), "PARTY");
		elseif (elsePrint) then
			NRC:print(msg);
		end
	end
end

function NRC:sendGroupComm(msg)
	if (IsInRaid()) then
		NRC:sendComm("RAID", msg);
	elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
        NRC:sendComm("INSTANCE_CHAT", msg);
	elseif (IsInGroup()) then
		NRC:sendComm("PARTY", msg);
	end
end