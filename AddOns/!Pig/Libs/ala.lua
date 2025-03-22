local addonName, addonTable = ...;
local wipe, concat = table.wipe, table.concat;
local find = _G.string.find
local sub = _G.string.sub
local match = _G.string.match
local tonumber=tonumber
local tostring=tostring
local fmod=math.fmod
local strlower=strlower
local strupper=strupper
local strsplit=strsplit
local strchar=strchar
--===============================================
--兼容ALA远程数据文件，取自TalentEmu插件，版权归原作者
--===============================================
local ALA={}
local __base64, __debase64 = {  }, {  };
for i = 0, 9 do __base64[i] = tostring(i); end
__base64[10] = "-";
__base64[11] = "=";
for i = 0, 25 do __base64[i + 1 + 11] = strchar(i + 65); end
for i = 0, 25 do __base64[i + 1 + 11 + 26] = strchar(i + 97); end
for i = 0, 63 do
	__debase64[__base64[i]] = i;
end
local RepeatedZero = setmetatable(
	{[0] = "",[1] = "0",},
	{__index = function(tbl, key)
		local str = strrep("0", key);
		tbl[key] = str;
		return str;
	end,}
);
-- local function EncodeNumber(val, len)
-- 	if val == 0 or val == nil then
-- 		return __base64[0];
-- 	end
-- 	local code = nil;
-- 	if val < 0 then
-- 		code = "^";
-- 		val = -val;
-- 	else
-- 		code = "";
-- 	end
-- 	local num = 0;
-- 	while val > 0 do
-- 		local v = val % 64;
-- 		code = code .. __base64[v];
-- 		num = num + 1;
-- 		val = (val - v) / 64;
-- 	end
-- 	if len ~= nil and num < len then
-- 		return code .. RepeatedZero[len - num];
-- 	end
-- 	return code;
-- end
-- --装备
-- local function EncodeItem(item)
-- 	local val = { strsplit(":", item) };
-- 	if val[1] == "item" then
-- 		local code = EncodeNumber(tonumber(val[2]));
-- 		local pos = 2;
-- 		local len = #val;
-- 		for i = 3, len do
-- 			if val[i] ~= "" then
-- 				code = code .. ":" .. __base64[i - pos] .. EncodeNumber(tonumber(val[i]));
-- 				pos = i;
-- 			end
-- 		end
-- 		if pos < len then
-- 			code = code .. ":" .. __base64[len - pos];
-- 		end
-- 		return code;
-- 	end
-- 	return "^";
-- end
-- local function EncodeItemList()
-- 	local msg = "";
-- 	for slot = 0,19 do
-- 		local item = GetInventoryItemLink('player', slot);
-- 		if item ~= nil then
-- 			item = item:match("\124H(item:[%-0-9:]+)\124h");
-- 			if item ~= nil then
-- 				item = "+" .. EncodeItem(item);
-- 			else
-- 				item = "+^";
-- 			end
-- 		else
-- 			item = "+^";
-- 		end
-- 		msg = msg .. item;
-- 	end
-- 	return msg;
-- end
-- --天赋
-- local function EncodeTalentBlock(data)
-- 	local len = #data;
-- 	local num = 0;
-- 	local raw = 0;
-- 	local magic = 1;
-- 	local mem = {  };
-- 	local pos = 0;
-- 	for index = 1, len do
-- 		local d = tonumber(data:sub(index, index));
-- 		num = num + 1;
-- 		raw = raw + magic * d;
-- 		magic = magic * 6;
-- 		if num >= 11 or index == len then
-- 			num = 0;
-- 			magic = 1;
-- 			local nChar = 0;
-- 			while raw > 0 do
-- 				local v1 = raw % 64;
-- 				pos = pos + 1;
-- 				mem[pos] = __base64[v1];
-- 				raw = (raw - v1) / 64;
-- 				nChar = nChar + 1;
-- 			end
-- 			if nChar < 5 then
-- 				pos = pos + 1;
-- 				mem[pos] = ":";
-- 			end
-- 		end
-- 	end
-- 	return concat(mem)
-- end
-- ---雕文
-- local function EncodeGlyphBlock(GroupID)
-- 	local data = {};
-- 	for index = 1, 6 do
-- 		local Enabled, GlyphType, GlyphSpell, Icon = GetGlyphSocketInfo(index, GroupID);
-- 		if GlyphSpell ~= nil then
-- 			data[index] = { Enabled and 1 or 0, GlyphType, GlyphSpell, Icon, };
-- 		end
-- 	end
-- 	local code = "";
-- 	for index = 1, 6 do
-- 		local val = data[index];
-- 		if val == nil then
-- 			code = code .. "+";
-- 		else
-- 			code = code .. "+" .. __base64[val[1] * 8 + val[2]] .. ":" .. EncodeNumber(val[3]) .. ":" .. EncodeNumber(val[4]);
-- 		end
-- 	end
-- 	return code
-- end
-- local function EncodeGlyphList()
-- 	local numGroup = GetNumTalentGroups(false, false)
-- 	local activeGroup = GetActiveTalentGroup(false, false)
-- 	if numGroup < 2 then
-- 		local code1 =EncodeGlyphBlock(1);
-- 		return __base64[numGroup] ..__base64[activeGroup] ..__base64[#code1] .. code1;
-- 	else
-- 		local code1 =EncodeGlyphBlock(activeGroup);
-- 		local code2=""
-- 		if activeGroup==1 then
-- 			code2 =EncodeGlyphBlock(2);
-- 		elseif activeGroup==2 then
-- 			code2 =EncodeGlyphBlock(1);
-- 		end
-- 		return __base64[numGroup] ..__base64[activeGroup] ..__base64[#code1] .. code1 ..__base64[#code2] .. code2;
-- 	end
-- end
---恢复数据
local RepeatedColon = setmetatable(
	{[0] = "",[1] = ":",},
	{__index = function(tbl, key)
		local str = strrep(":", key);
		tbl[key] = str;
		return str;
	end}
);
local function DecodeNumber(code)
	if not code then return nil end
	local isnegative = false;
	if code:sub(1, 1) == "^" then
		code = code:sub(2);
		isnegative = true;
	end
	local v = nil;
	local n = #code;
	if n == 1 then
		v = __debase64[code];
	else
		v = 0;
		for i = n, 1, -1 do
			v = v * 64 + __debase64[code:sub(i, i)];
		end
	end
	return isnegative and -v or v;
end
--天赋
local function DecodeTalentBlock(code, len)
	if not code then return nil end
	len = len or #code;
	local data = "";
	local raw = 0;
	local magic = 1;
	local nChar = 0;
	for index = 1, len do
		local c = code:sub(index, index);
		if c == ":" then
			--
		elseif __debase64[c] then
			raw = raw + __debase64[c] * magic;
			magic = magic * 64;
			nChar = nChar + 1;
		else

		end
		if c == ":" or nChar == 5 or index == len then
			magic = 1;
			nChar = 0;
			local n = 0;
			while raw > 0 do
				local val = raw % 6;
				data = data .. val;
				raw = (raw - val) / 6;
				n = n + 1;
			end
			if n < 11 then
				data = data .. RepeatedZero[11 - n];
			end
		end
	end
	return data;
end
local ClasseID={[9]=1,[4]=2,[2]=3,[6]=4,[5]=5,[10]=6,[7]=7,[3]=8,[8]=9,[11]=10,[1]=11,[12]=12,}
local haiyuan_tianfu = {
	[1] = function(code)
		local classIndex = __debase64[code:sub(1, 1)];
		local class = ClasseID[classIndex];
		return class, __debase64[code:sub(-2, -2)] + __debase64[code:sub(-1, -1)] * 64, 1, 1, DecodeTalentBlock(code:sub(2, -3));
	end,
	[2] = function(code)
		local cc = code:sub(1, 1);
		local classIndex = __debase64[cc];
		local class = ClasseID[classIndex];
		local level = __debase64[code:sub(2, 2)] + __debase64[code:sub(3, 3)] * 64;
		local numGroup = tonumber(__debase64[code:sub(4, 4)]);
		local activeGroup = tonumber(__debase64[code:sub(5, 5)]);
		local tianfudata=""
		local tianfudata2=nil
		if numGroup < 2 then
			local lenTal1 = tonumber(__debase64[code:sub(6, 6)]);
			local code1 = code:sub(7, lenTal1 + 6);
			tianfudata=DecodeTalentBlock(code1, lenTal1)
		else
			local shuangtianfu = {}
			local lenTal1 = tonumber(__debase64[code:sub(6, 6)]);
			local code1 = code:sub(7, lenTal1 + 6);
			shuangtianfu[1]=DecodeTalentBlock(code1, lenTal1)
			local lenTal2 = tonumber(__debase64[code:sub(7 + lenTal1, 7 + lenTal1)]);
			local code2 = code:sub(lenTal1 + 8, lenTal1 + lenTal2 + 7);
			shuangtianfu[2]=DecodeTalentBlock(code2, lenTal2)
			tianfudata=shuangtianfu[activeGroup]
			if activeGroup==1 then
				tianfudata2=shuangtianfu[2]
			elseif activeGroup==2 then
				tianfudata2=shuangtianfu[1]
			end
		end
		return {["class"]=class,["race"]=0,["level"]=level,["active"]=activeGroup,["num"]=numGroup},tianfudata,tianfudata2
	end,
};
--雕文
local function DecodeGlyphBlock(code, len)
	local list = { strsplit("+", code) };
	if list[2] ~= nil then
		local data = {  };
		for index = 1, 6 do
			local str = list[index + 1];
			if str and str ~= "" then
				local val = { strsplit(":", str) };
				local v = DecodeNumber(val[1]);
				local Enabled = v % 8;
				local GlyphType = (v - Enabled) / 8;
				local GlyphSpell = DecodeNumber(val[2]);
				local Icon = DecodeNumber(val[3]);
				data[index] = { Enabled, GlyphType, GlyphSpell, Icon, };
			end
		end
		return data;
	end
	return nil;
end
local haiyuan_Glyph = {
	[2]=function(code)
		local numGroup = tonumber(__debase64[code:sub(1, 1)]);
		local activeGroup = tonumber(__debase64[code:sub(2, 2)]);
		if numGroup < 2 then
			local lenTal1 = tonumber(__debase64[code:sub(3, 3)]);
			local code1 = code:sub(4, lenTal1 + 3);
			return DecodeGlyphBlock(code1, lenTal1);
		else
			local lenTal1 = tonumber(__debase64[code:sub(3, 3)]);
			local code1 = code:sub(4, lenTal1 + 3);
			local lenTal2 = tonumber(__debase64[code:sub(4 + lenTal1, 4 + lenTal1)]);
			if not lenTal2 then return DecodeGlyphBlock(code1, lenTal1); end
			local code2 = code:sub(lenTal1 + 5, lenTal1 + lenTal2 + 4);
			if activeGroup==1 then
				return DecodeGlyphBlock(code1, lenTal1), DecodeGlyphBlock(code2, lenTal2);
			elseif activeGroup==2 then
				return DecodeGlyphBlock(code2, lenTal2),DecodeGlyphBlock(code1, lenTal1);
			end
		end
	end,
}
--装备
local function DecodeItem(code)
	if code ~= "^" then
		local item = "item:";
		local val = { strsplit(":", code) };
		if val[1] ~= nil then
			local id = DecodeNumber(val[1]);
			if id ~= nil then
				item = item .. id;
				for i = 2, #val do
					local v = val[i];
					if #v > 1 then
						item = item .. RepeatedColon[__debase64[v:sub(1, 1)]] .. DecodeNumber(v:sub(2));
					else
						item = item .. RepeatedColon[__debase64[v]];
					end
				end
				return item;
			end
		end
	end
	return nil;
end
local haiyuan_Item = {
	[1] = function(code)
		local DataTable = {}
		local val = { strsplit("+", code) };	--	"", slot, item, slot, item...
		if val[3] ~= nil then
			local num = #val;
			for i = 2, num, 2 do
				local slot = tonumber(val[i]);
				local item = val[i + 1];
				local id = item:match("item:([%-0-9]+)");
				id = tonumber(id);
				if id ~= nil and id > 0 then
					GetItemInfo(id);
					DataTable[slot] = item;
				else
					DataTable[slot] = nil;
				end
			end
			return DataTable;
		end
		return DataTable;
	end,
	[2] = function(code)
		local DataTable = {}
		local val = { strsplit("+", code) };
		if val[2] ~= nil then
			local start = __debase64[val[1]] - 2;
			local num = #val;
			for i = 2, num do
				local item = DecodeItem(val[i]);
				DataTable[start + i] = item;
				if item ~= nil then
					GetItemInfo(item);
				end
			end
			return DataTable;
		end
		return DataTable;
	end,
};
--60版本
local codeTable = {}
local revCodeTable = {}
local indexToClass = {
    [1]=11, -- 德鲁伊
    [2]=3, -- 猎人-OK
    [3]=8, -- 法师
    [4]=2, -- 圣骑士
    [5]=5, -- 牧师
    [6]=4, -- 盗贼
    [7]=7, -- 萨满祭司
    [8]=9, -- 术士
    [9]=1, -- 战士
    [10]=6, -- 死亡骑士
}
local function EmuCore_InitCodeTable()
	for i = 0, 9 do codeTable[i] = tostring(i); end
	codeTable[10] = "-";
	codeTable[11] = "=";
	for i = 0, 25 do codeTable[i + 1 + 11] = strchar(i + 65); end
	for i = 0, 25 do codeTable[i + 1 + 11 + 26] = strchar(i + 97); end
	for i = 0, 63 do
		revCodeTable[codeTable[i]] = i;
	end
end
EmuCore_InitCodeTable()
local function haiyuan_tianfu_60(code)
	local class, race, level, data=0,0,1,""
	local classIndex = revCodeTable[code:sub(1, 1)];
	local level = revCodeTable[code:sub(- 2, - 2)] + bit.lshift(revCodeTable[code:sub(- 1, - 1)], 6);
	if not classIndex or not level then return end
	class = indexToClass[classIndex]
	level = level
	local len = strlen(code);
	local pos = 0;
	local raw = 0;
	local magic = 1;
	local nChar = 0;
	for p = 2, len - 2 do
		local c = code:sub(p, p);
		pos = pos + 1;
		if c == ":" then
			--
		elseif revCodeTable[c] then
			raw = raw + revCodeTable[c] * magic;
			magic = bit.lshift(magic, 6);
			nChar = nChar + 1;
		else
			--
		end
		if c == ":" or nChar == 5 or p == len - 2 then
			pos = 0;
			magic = 1;
			nChar = 0;
			local n = 0;
			while raw > 0 do
				data = data..fmod(raw, 6);
				raw = floor(raw / 6);
				n = n + 1;
			end
			if n < 11 then
				for i = n + 1, 11 do
					data = data .. "0";
				end
			end
		end
	end
	-- print(data)
	return {class, race, level}, data
end
--------------
local Fun=addonTable.Fun
local function huifu_Glyph(glyph,glyph2)
	local fwData,fwData2={},{}
	if glyph then
		for k,v in pairs(glyph) do
			fwData[k]=v[3]
		end
	end
	if glyph2 then
		for k,v in pairs(glyph2) do
			fwData2[k]=v[3]
		end
	end
	return fwData,fwData2
end
local function ALA_FormatData(nameX,msgx)
	local allinfo = {}
	local _;
	local pos = 1;
	local code = nil;
	local v2_ctrl_code = nil;
	local len = #msgx;
	while pos < len do
		_, pos, code, v2_ctrl_code = msgx:find("((![^!])[^!]+)", pos);
		if v2_ctrl_code == "!T" then
			local LM = __debase64[code:sub(4, 4)];
			if haiyuan_tianfu[LM] ~= nil then
				local info,tianfu,tianfu2=haiyuan_tianfu[LM](code:sub(5,-1));
				allinfo.info=info
				Pig_OptionsUI.talentData[nameX]["T"]={GetServerTime(),tianfu,tianfu2}
			end
		elseif v2_ctrl_code == "!G" then
			local LM = __debase64[code:sub(4, 4)];
			if haiyuan_Glyph[LM] ~= nil then
				local glyph,glyph2=haiyuan_Glyph[LM](code:sub(5));
				local fwData,fwData2=huifu_Glyph(glyph,glyph2)
				Pig_OptionsUI.talentData[nameX]["G"]={GetServerTime(),fwData,fwData2}
			end
		elseif v2_ctrl_code == "!E" then
			local LM = __debase64[code:sub(4, 4)];
			if haiyuan_Item[LM] ~= nil then
				allinfo.items=haiyuan_Item[LM](code:sub(5,-1));
			end
		elseif v2_ctrl_code == "!A" then
			-- print(code)
		end
	end
	local Player={allinfo.info.class,allinfo.info.race,allinfo.info.level}
	Fun.Update_ShowPlayer(Player,"yc")
	Fun.Update_ShowItem(allinfo.items,"yc")
end
local function ALA_FormatData_60(nameX,msgx)
	local code60 = msgx:sub(7,-1)
	local info,tianfu=haiyuan_tianfu_60(code60)
	Pig_OptionsUI.talentData[nameX]["T"]={GetServerTime(),tianfu}
	Fun.Update_ShowPlayer(info,"yc")
end
local function ALA_FormatData_60_Item(nameX,msgx)
	local dataList={}
    local Ndata = {strsplit("+", msgx:sub(2,-1))}
    for i = 1, #Ndata, 2 do
        local slot, link = tonumber(Ndata[i]), Ndata[i + 1]
        if slot and link ~= 'item:-1' and link:find('item:(%d+)') then	
            dataList[slot] = link
        end
    end
	Fun.Update_ShowItem(dataList,"yc")
end
--
local function ALA_FormatData_TF(nameX,leixing,msgx)
	if leixing == "T" then
		local kshi, jieshu, msgx1 = msgx:find("(!T[^!]+)!", 1)
		local LM = __debase64[msgx1:sub(4, 4)];
		if haiyuan_tianfu[LM] ~= nil then
			local _,Tianfu,Tianfu2 = haiyuan_tianfu[LM](msgx1:sub(5,-1))
			Pig_OptionsUI.talentData[nameX][leixing]={GetServerTime(),Tianfu,Tianfu2}
		end
	end
	if leixing == "G" then
		local LM = __debase64[msgx:sub(4, 4)];
		if haiyuan_Glyph[LM] ~= nil then
			local glyph,glyph2=haiyuan_Glyph[LM](msgx:sub(5));
			local fwData,fwData2=huifu_Glyph(glyph,glyph2)
			Pig_OptionsUI.talentData[nameX][leixing]={GetServerTime(),fwData,fwData2}
		end
	end
end
function ALA.ALA_tiquMsg(msgx,nameX)
	if yuanchengCFrame:IsShown() and yuanchengCFrame.fullnameX==nameX then
		local qianzhui = msgx:sub(1, 2)
		if qianzhui == "!P" or qianzhui == "!T" then
			yuanchengCFrame.fanhuiYN=true
			Pig_OptionsUI.talentData[nameX]=Pig_OptionsUI.talentData[nameX] or {["T"]="",["G"]=""}
			if qianzhui == "!P" then
				local allnum = msgx:sub(5, 5)
				local danqian = msgx:sub(7, 7)
				if danqian=="1" then
					yuanchengCFrame.allmsg=msgx:sub(9, -1)
				else
					yuanchengCFrame.allmsg=yuanchengCFrame.allmsg..msgx:sub(9, -1)
				end
				if allnum==danqian then
					ALA_FormatData(nameX,yuanchengCFrame.allmsg)
				end
			elseif qianzhui == "!T" then
				ALA_FormatData(nameX,msgx)
			end
		else
			local qianzhui = msgx:sub(1, 6)	
			if qianzhui == '_r_tal' or qianzhui == '_reply' or qianzhui == '_r_equ' or qianzhui == '_repeq' or qianzhui == '_r_eq3' then
				Pig_OptionsUI.talentData[nameX]=Pig_OptionsUI.talentData[nameX] or {["T"]="",["G"]=""}
				if yuanchengCFrame:IsShown() and yuanchengCFrame.fullnameX==nameX then	
					if qianzhui == '_r_tal' then
						yuanchengCFrame.fanhuiYN=true
						ALA_FormatData_60(nameX,msgx)
					elseif qianzhui == '_r_eq3' then
						yuanchengCFrame.fanhuiYN=true
						yuanchengCFrame.allmsg=yuanchengCFrame.allmsg..msgx:sub(7, -1)
						if yuanchengCFrame.ycJieshou then yuanchengCFrame.ycJieshou:Cancel() end
						yuanchengCFrame.ycJieshou=C_Timer.NewTimer(0.2,function()
							ALA_FormatData_60_Item(nameX,yuanchengCFrame.allmsg)
						end)
					end
				end
			end
		end
	end
	if InspectFrame and InspectFrame:IsShown() and InspectNameText:GetText()==nameX or Tardis_UI and Tardis_UI:IsShown() then--观察/时空
		local qianzhui = msgx:sub(1, 2)
		if qianzhui == "!T" or qianzhui == "!G" then
			Pig_OptionsUI.talentData[nameX]=Pig_OptionsUI.talentData[nameX] or {["T"]="",["G"]=""}
			local leixing = msgx:sub(2, 2)	
			if leixing == "T" then
				yuanchengCFrame.fanhuiYN_TF=true
			end
			if leixing == "G" then
				yuanchengCFrame.fanhuiYN_GG=true
			end
			ALA_FormatData_TF(nameX,leixing,msgx)
		end
	end
end
addonTable.ALA=ALA