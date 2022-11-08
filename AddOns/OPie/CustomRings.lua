local api, private, _, T = {}, {}, ...
local RK_RingDesc, RK_CollectionIDs, RK_FluxRings, RK_Version, RK_Rev, EV, PC, SV = {}, {}, {}, 3, 53, T.Evie, T.OPieCore
local unlocked, queue, RK_DeletedRings, RK_FlagStore, sharedCollection = false, {}, {}, {}, {}
local MODERN = select(4,GetBuildInfo()) >= 8e4
local CF_WRATH = not MODERN and select(4,GetBuildInfo()) >= 3e4

local function assert(condition, text, level, ...)
	return (not condition) and error(tostring(text):format(...), 1 + (level or 1)) or condition
end

local AB = assert(T.ActionBook:compatible(2,19), "A compatible version of ActionBook is required")
local RW = assert(T.ActionBook:compatible("Rewire", 1,10), "A compatible version of Rewire is required")
local ORI = OPie.UI
local CLASS, FULLNAME, FACTION

local RK_ParseMacro, RK_QuantizeMacro, RK_SetMountPreference do
	local castAlias = {["#show"]=0, ["#showtooltip"]=0} do
		for n,v in ("CAST:1 USE:1 CASTSEQUENCE:2 CASTRANDOM:3 USERANDOM:3"):gmatch("(%a+):(%d+)") do
			local v, idx, s = v+0, 1
			repeat
				if s then
					castAlias[s] = v
				end
				s, idx = _G["SLASH_" .. n .. idx], idx+1
			until not s
		end
	end
	local function replaceSpellID(ctype, sidlist, prefix, tk)
		local sr, ar
		for id, sn in sidlist:gmatch("%d+") do
			id = id + 0
			sn, sr = GetSpellInfo(id), GetSpellSubtext(id)
			ar = GetSpellSubtext(sn)
			local isCastable, castFlag = RW:IsSpellCastable(id)
			if not MODERN and not isCastable and tk ~= "spellr" then
				local id2 = select(7,GetSpellInfo(sn))
				if id2 then
					id, isCastable, castFlag = id2, RW:IsSpellCastable(id2)
				end
			end
			if isCastable then
				if castFlag == "forced-id-cast" and (ctype == 1 or ctype == 3) then
					sn = "spell:" .. id
				elseif ctype == 3 and sn and sn:match(",") then
					sn = "spell:" .. id
				elseif sr and sr ~= "" and (MODERN or tk == "spellr") then
					sn = sn .. "(" .. sr .. ")"
				elseif tk == "spell" and not MODERN and ar ~= sr and ar then
					sn = sn .. "(" .. ar .. ")"
				end
				return prefix .. sn
			end
		end
	end
	local replaceMountTag do
		local skip, gmSid, gmPref, fmSid, fmPref = {[44153]=1, [44151]=1, [61451]=1, [75596]=1, [61309]=1, [169952]=1, [171844]=1, [213339]=1,}
		local function IsKnownSpell(sid)
			local sn, sr = GetSpellInfo(sid or 0), GetSpellSubtext(sid or 0)
			return GetSpellInfo(sn, sr) ~= nil and sid or (RW:GetCastEscapeAction(sn) and sid)
		end
		local function findMount(prefSID, mtype)
			local myFactionId, nc, cs = UnitFactionGroup("player") == "Horde" and 0 or 1, 0
			local idm = C_MountJournal.GetMountIDs()
			local gmi, gmiex = C_MountJournal.GetMountInfoByID, C_MountJournal.GetMountInfoExtraByID
			for i=1, #idm do
				i = idm[i]
				local _1, sid, _3, _4, _5, _6, _7, factionLocked, factionId, hide, have = gmi(i)
				if have and not hide
				   and (not factionLocked or factionId == myFactionId)
				   and RW:IsSpellCastable(sid)
				   then
					local _, _, _, _, t = gmiex(i)
					if sid == prefSID then
						return sid
					elseif t == mtype and not skip[sid] then
						nc = nc + 1
						if math.random(1,nc) == 1 then
							cs = sid
						end
					end
				end
			end
			return cs
		end
		function replaceMountTag(ctype, tag, prefix)
			if not MODERN then
			elseif tag == "ground" then
				gmSid = gmSid and IsKnownSpell(gmSid) or findMount(gmPref or gmSid, 230)
				return replaceSpellID(ctype, tostring(gmSid), prefix)
			elseif tag == "air" then
				fmSid = fmSid and IsKnownSpell(fmSid) or findMount(fmPref or fmSid, 248)
				return replaceSpellID(ctype, tostring(fmSid), prefix)
			end
			return nil
		end
		function RK_SetMountPreference(groundSpellID, airSpellID)
			if type(groundSpellID) == "number" then
				gmPref = groundSpellID
			elseif groundSpellID == false then
				gmPref = nil
			end
			if type(airSpellID) == "number" then
				fmPref = airSpellID
			elseif airSpellID == false then
				fmPref = nil
			end
			return gmPref, fmPref
		end
	end
	local function replaceAlternatives(ctype, replaceFunc, args)
		local ret, alt2, rfCtx
		for alt, cpos in (args .. ","):gmatch("(.-),()") do
			alt2, rfCtx = replaceFunc(ctype, alt, rfCtx, args, cpos)
			if alt == alt2 or (alt2 and alt2:match("%S")) then
				ret = (ret and (ret .. ", ") or "") .. alt2:match("^%s*(.-)%s*$")
			end
		end
		return ret
	end
	local function genLineParser(replaceFunc)
		return function(commandPrefix, command, args)
			local ctype = castAlias[command:lower()]
			if not ctype then return end
			local pos, len, ret = 1, #args
			repeat
				local cstart, cend, vend = pos
				repeat
					local ce, cs = args:match("();", pos) or (len+1), args:match("()%[", pos)
					if cs and cs < ce then
						pos = args:match("%]()", cs)
					else
						cend, vend, pos = pos, ce-1, ce + 1
					end
				until cend or not pos
				if not pos then return end
				local cval = args:sub(cend, vend)
				if ctype < 2 then
					cval = replaceFunc(ctype, args:sub(cend, vend))
				else
					local val, reset = args:sub(cend, vend)
					if ctype == 2 then reset, val = val:match("^(%s*reset=%S+%s*)"), val:gsub("^%s*reset=%S+%s*", "") end
					val = replaceAlternatives(ctype, replaceFunc, val)
					cval = val and ((reset or "") .. val) or nil
				end
				if cval or ctype == 0 then
					local clause = (cstart < cend and (args:sub(cstart, cend-1):match("^%s*(.-)%s*$") .. " ") or "") .. (cval and cval:match("^%s*(.-)%s*$") or "")
					ret = (ret and (ret .. "; ") or commandPrefix) .. clause
				end
			until not pos or pos > #args
			return ret or ""
		end
	end
	local parseLine, quantizeLine, prepareQuantizer do
		local tip = CreateFrame("GameTooltip")
		tip:AddFontStrings(tip:CreateFontString(), tip:CreateFontString())
		tip:SetOwner(UIParent, "ANCHOR_NONE")
		parseLine = genLineParser(function(ctype, value)
			local prefix, tkey, tval = value:match("^%s*(!?)%s*{{(%a+):([%a%d/]+)}}%s*$")
			if tkey == "spell" or tkey == "spellr" then
				return replaceSpellID(ctype, tval, prefix, tkey)
			elseif tkey == "mount" then
				return replaceMountTag(ctype, tval, prefix)
			end
			return value
		end)
		local spells, OTHER_SPELL_IDS = {}, {150544, 243819}
		quantizeLine = genLineParser(function(ctype, value, ctx, args, cpos)
			if type(ctx) == "number" and ctx > 0 then
				return nil, ctx-1
			end
			local cc, mark, name = 0, value:match("^%s*(!?)(.-)%s*$")
			repeat
				local sid, peek, cnpos = spells[name:lower()]
				if sid then
					if not MODERN then
						local rname = name:gsub("%s*%([^)]+%)$", "")
						local sid2 = rname ~= name and spells[rname:lower()]
						if sid2 then
							return (mark .. "{{spellr:" .. sid .. "}}"), cc
						end
					end
					return (mark .. "{{spell:" .. sid .. "}}"), cc
				end
				if ctype >= 2 and args then
					peek, cnpos = args:match("^([^,]+),?()", cpos)
					if peek then
						cc, name, cpos = cc + 1, name .. ", " .. peek:match("^%s*(.-)%s*$"), cnpos
					end
				end
			until not peek or cc > 5
			return value
		end)
		local function addModernSpells()
			local gmi, idm = C_MountJournal.GetMountInfoByID, C_MountJournal.GetMountIDs()
			for i=1, #idm do
				local _, sid = gmi(idm[i])
				local sname = GetSpellInfo(sid)
				if sname then
					spells[sname:lower()] = sid
				end
			end
			local cid = C_ClassTalents.GetActiveConfigID()
			if not cid then
				local spec = GetSpecializationInfo(GetSpecialization())
				local cc = C_ClassTalents.GetConfigIDsBySpecID(spec)
				cid = cc and cc[1]
			end
			local conf = cid and C_Traits.GetConfigInfo(cid)
			local tree = conf and conf.treeIDs and conf.treeIDs[1]
			local nodes = tree and C_Traits.GetTreeNodes(tree)
			for i=1,nodes and #nodes or 0 do
				local node = C_Traits.GetNodeInfo(cid, nodes[i])
				for i=1,#node.entryIDs do
					local entry = C_Traits.GetEntryInfo(cid, node.entryIDs[i])
					local did = entry.definitionID
					local def = C_Traits.GetDefinitionInfo(did)
					local sid = def and def.spellID and not IsPassiveSpell(def.spellID) and def.spellID
					if sid then
						local name, name2 = GetSpellInfo(sid), def.overrideName
						if name then
							spells[name:lower()] = sid
						end
						if name2 and name2 ~= name then
							spells[name2:lower()] = sid
						end
					end
				end
			end
		end
		local function addSpell(n, id, allowGenericOverwrite)
			local nl, sr, k = n:lower(), GetSpellSubtext(id)
			spells[nl] = allowGenericOverwrite and id or spells[nl] or id
			if sr and sr ~= "" then
				k = nl .. "(" .. sr:lower() .. ")"; spells[k] = spells[k] or id
				k = nl .. " (" .. sr:lower() .. ")"; spells[k] = spells[k] or id
			end
		end
		local function addSpellBookTab(ofs, c, allowGenericOverwrite)
			for j=ofs+1,ofs+c do
				local n, st, id = GetSpellBookItemName(j, "spell"), GetSpellBookItemInfo(j, "spell")
				if type(n) ~= "string" or not id then
				elseif st == "SPELL" or st == "FUTURESPELL" then
					addSpell(n, id, allowGenericOverwrite and st == "SPELL")
				elseif st == "FLYOUT" then
					for j=1,select(3,GetFlyoutInfo(id)) do
						local sid, _, _, sname = GetFlyoutSlotInfo(id, j)
						if sid and type(sname) == "string" then
							addSpell(sname, sid)
						end
					end
				end
			end
		end
		function prepareQuantizer(reuse)
			if reuse and next(spells) then return end
			wipe(spells)
			for i=1,#OTHER_SPELL_IDS do
				local sn = GetSpellInfo(OTHER_SPELL_IDS[i])
				if sn then
					spells[sn:lower()] = OTHER_SPELL_IDS[i]
				end
			end
			if MODERN then
				addModernSpells()
			elseif CF_WRATH then
				for k=1,2 do
					k = k == 1 and "MOUNT" or "CRITTER"
					for i=1,GetNumCompanions(k) do
						local _, _, sid = GetCompanionInfo(k, i)
						local sn = GetSpellInfo(sid)
						if sn then
							addSpell(sn, sid)
						end
					end
				end
			end
			for curSpec=0,1 do
				for i=GetNumSpellTabs()+12,1,-1 do
					local _, _, ofs, c, _, sid = GetSpellTabInfo(i)
					if ((curSpec == 0) == (sid == 0)) then
						addSpellBookTab(ofs, c, not MODERN)
					end
				end
			end
		end
	end
	function RK_ParseMacro(macro)
		if type(macro) == "string" and (macro:match("{{spellr?:[%d/]+}}") or macro:match("{{mount:%a+}}") ) then
			macro = ("\n" .. macro):gsub("(\n([#/]%S+) ?)([^\n]*)", parseLine)
		end
		return macro
	end
	function RK_QuantizeMacro(macro, useCache)
		return type(macro) == "string" and (prepareQuantizer(useCache) or true) and ("\n" .. macro):gsub("(\n([#/]%S+) ?)([^\n]*)", quantizeLine):sub(2) or macro
	end
end
local function RK_IsRelevantRingDescription(desc)
	if desc then
		local limit = desc.limit
		return limit == nil or limit == FULLNAME or limit == CLASS or limit == FACTION
	end
end
local serialize, unserialize do
	local sb, sc = string.byte, string.char
	local sigT, sigB, sigN = {}, {}
	for i, c in ("01234qwertyuiopasdfghjklzxcvbnm5678QWERTYUIOPASDFGHJKLZXCVBNM9"):gmatch("()(.)") do sigT[i-1], sigT[c], sigB[sb(c)], sigN = c, i-1, i-1, i end
	local function checksum(s)
		local h = (134217689 * #s) % 17592186044399
		for i=1,#s,4 do
			local a, b, c, d = s:match("(.?)(.?)(.?)(.?)", i)
			a, b, c, d = sigT[a], (sigT[b] or 0) * sigN, (sigT[c] or 0) * sigN^2, (sigT[d] or 0) * sigN^3
			h = (h * 211 + a + b + c + d) % 17592186044399
		end
		return h % 3298534883309
	end
	local function nenc(v, b, rest)
		if b == 0 then return v == 0 and rest or error("numeric overflow") end
		local v1 = v % sigN
		local v2 = (v - v1) / sigN
		return nenc(v2, b - 1, sigT[v1] .. (rest or ""))
	end
	local function cenc(c)
		local b, m = c:byte(), sigN-1
		return sigT[(b - b % m) / m] .. sigT[b % m]
	end
	local function venc(v, t, reg)
		if reg[v] then
			t[#t+1] = sigT[1] .. sigT[reg[v]]
		elseif type(v) == "table" then
			local n = math.min(sigN-1, #v)
			for i=n,1,-1 do venc(v[i], t, reg) end
			t[#t+1] = sigT[3] .. sigT[n]
			for k,v2 in pairs(v) do
				if not (type(k) == "number" and k >= 1 and k <= n and k % 1 == 0) then
					venc(v2, t, reg)
					venc(k, t, reg)
					t[#t+1] = sigT[4]
				end
			end
		elseif type(v) == "number" then
			if v >= -1000000 and v < 13776336 and v % 1 == 0 then
				t[#t+1] = sigT[5] .. nenc(v + 1000000, 4)
			elseif (v+v == v) or (v < 0) == (v >= 0) then
				error("not a (real) number")
			else
				local f, e = math.frexp(v)
				if e < -1070 then
					f, e = f / 2, e + 1
				end
				t[#t+1] = sigT[f < 0 and 14 or 13] .. nenc(e+1500-1, 2) .. nenc(f*2^53*(f < 0 and -1 or 1), 9)
			end
		elseif type(v) == "string" then
			t[#t+1] = sigT[6] .. v:gsub("[^a-zA-Z5-8]", cenc) .. "9"
		else
			t[#t+1] = sigT[1] .. ((v == true and sigT[1]) or (v == nil and sigT[0]) or sigT[2])
		end
		return t
	end
	local function tenc(t)
		local u, ua, fm, fc = {}, {}, {}, sigN-3
		for i=3,sigN-1 do
			fm[sigT[1] .. sigT[i]] = sigT[2] .. sigT[i]
		end
		for i=1,#t do
			local k = t[i]
			if fm[k] then
				fc, fm[k] = fc - 1, nil
			elseif u[k] then
				u[k] = u[k] + 1
			elseif #k >= 4 then
				ua[#ua+1], u[k] = k, 1
			end
		end
		table.sort(ua, function(a, b)
			return (#a-2)*(u[a]-1) > (#b-2)*(u[b]-1)
		end)
		for i=fc+1, #ua do
			u[ua[i]], ua[i] = nil
		end
		local r, s = next(fm)
		for i=1,#t do
			local uk = u[t[i]]
			if uk == nil then
			elseif type(uk) == "string" then
				t[i] = uk
			elseif r and uk > 1 then
				u[t[i]], t[i], r, s = r, t[i] .. s, next(fm, r)
			end
		end
		return t
	end
	
	local ops do
		local s, r, pri
		local function cdec(c, l)
			return sc(sigT[c]*(sigN-1) + sigT[l])
		end
		local function ndec(p, l)
			local r = 0
			for i=p,p+l-1 do
				r = r * sigN + sigB[sb(pri,i)]
			end
			return r
		end
		ops = {
			function(d, pos)
				s[d+1] = r[sigB[sb(pri, pos)]]
				return d+1, pos+1
			end,
			function(d, pos)
				r[sigB[sb(pri,pos)]] = s[d]
				return d, pos+1
			end,
			function(d, pos)
				local t, n = {}, sigB[sb(pri,pos)]
				for i=1,n do
					t[i] = s[d-i+1]
				end
				s[d - n + 1] = t
				return d+1-n, pos+1
			end,
			function(d, pos)
				s[d-2][s[d]] = s[d-1]
				return d-2, pos
			end,
			function(d, pos)
				s[d+1] = ndec(pos, 4) - 1000000
				return d+1, pos+4
			end,
			function(d, pos)
				d, s[d+1], pos = d+1, pri:match('^(.-)9()', pos)
				s[d] = s[d]:gsub('([0-4])(.)', cdec)
				return d, pos
			end,
			function(d, pos)
				s[d-1] = s[d-1]+s[d]
				return d-1, pos
			end,
			function(d, pos)
				s[d-1] = s[d-1]*s[d]
				return d-1, pos
			end,
			function(d, pos)
				s[d-1] = s[d-1]/s[d]
				return d-1, pos
			end,
			function(d, pos)
				s[d-1] = s[d-1]-s[d]
				return d-1, pos
			end,
			function(d, pos)
				s[d-1] = s[d-1]^s[d]
				return d-1, pos
			end,
			function(d, pos)
				s[d-1] = s[d-1]*2^s[d]
				return d-1, pos
			end,
			function(d, pos)
				s[d+1] =  2^(ndec(pos,2)-1500) * (ndec(pos+2,9)*2^-52)
				return d+1, pos+11
			end,
			function(d, pos)
				s[d+1] = -2^(ndec(pos,2)-1500) * (ndec(pos+2,9)*2^-52)
				return d+1, pos+11
			end,
			function(d, pos)
				s[d-1] = r[s[d]]
				return d-1, pos
			end,
			function(d, pos)
				r[s[d]] = s[d-1]
				return d-1, pos
			end,
		}
		local opsB = {}
		for i=1,#ops do
			opsB[sb(sigT[i])] = ops[i]
		end
		ops = opsB
		function ops.bind(...)
			s, r, pri = ...
		end
	end
	
	local defaultSign = sc(111,101,116,111,104,72,55)
	local st = {
		[defaultSign] = {"name", "hotkey", "offset", "noOpportunisticCA", "noPersistentCA", "internal", "limit", "id", "skipSpecs", "caption", "icon", "show"},
	}
	
	function serialize(t, sign)
		sign = sign == nil and defaultSign or sign
		local rt, sd = {}, st[sign]
		for i=1, sd and #sd or 0 do
			rt[sd[i]] = 2+i
		end
		local payload = table.concat(tenc(venc(t, {}, setmetatable({}, {__index=rt}))), "")
		return ((sign .. nenc(checksum(sign .. payload), 7) .. payload):gsub("(.......)", "%1 "):gsub(" ?$", ".", 1))
	end
	function unserialize(s)
		local ssign, h, pri = s:gsub("[^a-zA-Z0-9.]", ""):match("^(" .. ("."):rep(#defaultSign) .. ")(.......)([^.]+)")
		if st[ssign] == nil or nenc(checksum(ssign .. pri), 7) ~= h then return end
		local rt, sd = {true, false}, st[ssign]
		for i=1, sd and #sd or 0 do
			rt[2+i] = sd[i]
		end
		local stack, depth, pos, len = {}, 0, 1, #pri
		ops.bind(stack, setmetatable({}, {__index=rt}), pri)
		while pos <= len do
			depth, pos = ops[sb(pri, pos)](depth, pos + 1)
		end
		ops.bind()
		return depth == 1 and stack[1]
	end
end
local encodeMacro, decodeMacro do
	local function slash_i18n(command, lead)
		if lead == "!" then return "\n!" .. command end
		local key = command:upper()
		if type(hash_ChatTypeInfoList[key]) == "string" and not hash_ChatTypeInfoList[key]:match("!") then
			return "\n!" .. hash_ChatTypeInfoList[key] .. "!" .. command
		elseif type(hash_EmoteTokenList[key]) == "string" and not hash_EmoteTokenList[key]:match("!") then
			return "\n!" .. hash_EmoteTokenList[key] .. "!" .. command
		end
	end
	local function slash_l10n(key, command)
		if key == "" then return "\n!" .. command end
		local k2 = command:upper()
		if hash_ChatTypeInfoList[k2] == key or hash_EmoteTokenList[k2] == key then
		elseif _G["SLASH_" .. key .. 1] then
			return "\n" .. _G["SLASH_" .. key .. 1]
		else
			local i, v = 2, EMOTE1_TOKEN
			while v do
				if v == key then
					return "\n" .. _G["EMOTE" .. (i-1) .. "_CMD1"]
				end
				i, v = i + 1, _G["EMOTE" .. i .. "_TOKEN"]
			end
		end
		return "\n" .. command
	end
	function encodeMacro(m)
		ChatFrame_ImportAllListsToHash()
		return ("\n" .. m):gsub("\n(([/!])%S*)", slash_i18n):sub(2)
	end
	function decodeMacro(m)
		ChatFrame_ImportAllListsToHash()
		return ("\n" .. m):gsub("\n!(.-)!(%S*)", slash_l10n):sub(2)
	end
end
local function copy(t, copies)
	local into = {}
	copies = copies or {}
	copies[t] = into
	for k,v in pairs(t) do
		k = type(k) == "table" and (copies[k] or copy(k, copies)) or k
		v = type(v) == "table" and (copies[v] or copy(v, copies)) or v
		into[k] = v
	end
	return into
end

local RK_SetRingDesc
local function pullOptions(e, a, ...)
	if a then return e[a], pullOptions(e, ...) end
end
local function unpackABAction(e, s)
	if e[s] then return e[s], unpackABAction(e, s+1) end
	return pullOptions(e, AB:GetActionOptions(e[1]))
end
local function RK_SyncRing(name, force, tok)
	local desc, changed, cid = RK_RingDesc[name], (force == true), RK_CollectionIDs[name]
	if not RK_IsRelevantRingDescription(desc) then return end
	tok = tok or AB:GetLastObserverUpdateToken("*")
	if not force and tok == desc._lastUpdateToken then return end
	desc._lastUpdateToken = tok
	
	local limit = desc.limit
	desc.sortScope = limit == FULLNAME and 30 or limit == CLASS and 20 or 10
	if not cid then
		wipe(sharedCollection)
		changed, cid = true, AB:CreateActionSlot(nil, nil, "collection", sharedCollection)
		RK_CollectionIDs[name], RK_CollectionIDs[cid] = cid, name
		OPie:SetRing(name, cid, desc)
	end

	local onOpenSlice, onOpenAction, onOpenToken = desc.onOpen
	for i=1, #desc do
		local e = desc[i]
		local ident, action = e[1]
		if ident == "macrotext" then
			local m = RK_ParseMacro(e[2])
			if m:match("%S") then action = AB:GetActionSlot("macrotext", m) end
		elseif type(ident) == "string" then
			action = AB:GetActionSlot(unpackABAction(e, 1))
		end
		changed = changed or (action ~= e._action) or (e.fastClick ~= e._fastClick) or (e.rotationMode ~= e._rotationMode) or (action and (e.show ~= e._show) or (e.embed ~= e._embed))
		e._action, e._fastClick, e._rotationMode = action, e.fastClick, e.rotationMode
		if i == onOpenSlice then
			onOpenAction, onOpenToken = e._action, e.sliceToken
		end
	end
	changed = changed or (desc._embed ~= desc.embed) or (desc._onOpen ~= onOpenAction) or (desc._onOpenToken ~= onOpenToken)

	if not changed and not force then return end
	local collection, cn = sharedCollection, 1
	wipe(collection)
	for i=1, #desc do
		local e = desc[i]
		if e._action and i ~= onOpenSlice then
			collection[e.sliceToken], collection[cn], cn = e._action, e.sliceToken, cn + 1
			collection['__visibility-' .. e.sliceToken], e._show = e.show or nil, e.show
			collection['__embed-' .. e.sliceToken], e._embed = e.embed, e.embed
			ORI:SetDisplayOptions(e.sliceToken, e.icon, nil, e._r, e._g, e._b)
		end
	end
	collection['__embed'], desc._embed = desc.embed, desc.embed
	collection['__openAction'], desc._onOpen = onOpenAction, onOpenAction
	collection['__openToken'], desc._onOpenToken = onOpenToken, onOpenToken
	AB:UpdateActionSlot(cid, collection)
	OPie:SetRing(name, cid, desc)
end
local function dropUnderscoreKeys(t)
	for k in pairs(t) do
		if type(k) == "string" and k:sub(1,1) == "_" then
			t[k] = nil
		end
	end
end
local function RK_SanitizeDescription(props)
	local uprefix = type(props._u) == "string" and props._u
	for i=#props,1,-1 do
		local v = props[i]
		if type(v.c) == "string" then
			local r,g,b = v.c:match("^(%x%x)(%x%x)(%x%x)$")
			if r then
				v._r, v._g, v._b = tonumber(r, 16)/255, tonumber(g, 16)/255, tonumber(b, 16)/255
			end
		end
		local rt, id = v.rtype, v.id
		if rt and id then
			v[1], v[2], v.rtype, v.id = rt, id
		elseif type(id) == "number" then
			v[1], v[2], v.rtype, v.id = "spell", id
		elseif type(id) == "string" then
			v[1], v[2], v.rtype, v.id = "macrotext", id
		elseif v[1] == nil then
			table.remove(props, i)
		end
		if v.lockRotation ~= nil and v.rotationMode == nil then
			-- DEPRECATED [1902/3.96/W1]: lockRotation->rotationMode transition.
			v.rotationMode = v.lockRotation and "reset" or nil
			v.lockRotation = nil
		end
		v.show = v.show ~= "" and v.show or nil
		v.sliceToken = v.sliceToken or (uprefix and type(v._u) == "string" and (uprefix .. v._u)) or AB:CreateToken()
		v._action, v._embed = nil
	end
	props._embed = nil
	return props
end
local function RK_SerializeDescription(props)
	for _, slice in ipairs(props) do
		if slice[1] == "spell" or slice[1] == "macrotext" then
			slice.id, slice[1], slice[2] = slice[2]
		end
		dropUnderscoreKeys(slice)
	end
	dropUnderscoreKeys(props)
	props.sortScope = nil
	return props
end
function EV.PLAYER_REGEN_DISABLED()
	for k in pairs(RK_RingDesc) do
		securecall(RK_SyncRing, k)
	end
end
local function abPreOpen(_, _, id)
	local k = RK_CollectionIDs[id]
	if k then
		RK_SyncRing(k)
	end
end
local function svInitializer(event, _name, sv)
	if event == "LOGOUT" and unlocked then
		for k in pairs(sv) do sv[k] = nil end
		for k, v in pairs(RK_RingDesc) do
			if type(v) == "table" and not RK_DeletedRings[k] and v.save then
				sv[k] = RK_SerializeDescription(v)
			end
		end
		sv.OPieDeletedRings, sv.OPieFlagStore = next(RK_DeletedRings) and RK_DeletedRings, next(RK_FlagStore) and RK_FlagStore

	elseif event == "LOGIN" then
		local name, realm, _ = UnitFullName("player")
		FULLNAME, FACTION, _, CLASS = name .. '-' .. realm, UnitFactionGroup("player"), UnitClass("player")

		unlocked = true
		local deleted, flags, mousemap = SV.OPieDeletedRings or RK_DeletedRings, SV.OPieFlagStore or RK_FlagStore
		mousemap, SV.OPieDeletedRings, SV.OPieFlagStore = {PRIMARY=PC:GetOption("PrimaryButton"), SECONDARY=PC:GetOption("SecondaryButton")}
		for k,v in pairs(flags) do RK_FlagStore[k] = v end
		
		local storageVersion = flags.StoreVersion or (flags.FlushedDefaultColors and 1) or 0
		storageVersion = type(storageVersion) == "number" and storageVersion or 0
		local colorFlush, onOpenFlush = storageVersion < 1, storageVersion < 2
		RK_FlagStore.StoreVersion, RK_FlagStore.FlushedDefaultColors = 2, nil

		for k, v in pairs(queue) do
			if v.hotkey then v.hotkey = v.hotkey:gsub("[^-; ]+", mousemap) end
			if deleted[k] == nil and SV[k] == nil then
				securecall(RK_SetRingDesc, k, v)
				SV[k] = nil
			elseif deleted[k] then
				RK_DeletedRings[k] = true
			end
		end
		for k, v in pairs(SV) do
			if type(v) == "table" then
				if colorFlush then
					for _,v in pairs(v) do
						if type(v) == "table" and v.c == "e5ff00" then
							v.c = nil
						end
					end
				end
				if onOpenFlush and v.onOpen ~= nil then
					v.quarantineOnOpen, v.onOpen = v.onOpen, nil
				end
			end
			securecall(RK_SetRingDesc, k, v)
		end

		collectgarbage("collect")
	end
end
local function ringIterator(isDeleted, k)
	local nk, v = next(isDeleted and RK_DeletedRings or RK_RingDesc, k)
	if nk and RK_FluxRings[nk] then
		return ringIterator(isDeleted, nk)
	elseif nk and isDeleted then
		return RK_IsRelevantRingDescription(queue[nk]) and nk or ringIterator(isDeleted, nk)
	elseif nk then
		return nk, v.name or nk, RK_CollectionIDs[nk] ~= nil, #v, v.internal, v.limit
	end
end
function RK_SetRingDesc(name, desc)
	assert(type(name) == "string" and (type(desc) == "table" or desc == false))
	if not unlocked then
		queue[name] = desc
	elseif desc == false then
		if RK_RingDesc[name] then
			OPie:SetRing(name, nil)
			if RK_CollectionIDs[name] then RK_CollectionIDs[RK_CollectionIDs[name]] = nil end
			RK_DeletedRings[name], RK_RingDesc[name], RK_CollectionIDs[name], SV[name] = queue[name] and true or nil
		end
	else
		RK_RingDesc[name], RK_DeletedRings[name] = RK_SanitizeDescription(copy(desc)), nil
		RK_SyncRing(name, true)
	end
end

-- Public API
function api:GetVersion()
	return RK_Version, RK_Rev
end
function api:GenFreeRingName(base, reserved)
	assert(type(base) == "string" and (reserved == nil or type(reserved) == "table"), 'Syntax: name = RK:GenFreeRingName("base"[, reservedNamesTable])', 2)
	base = base:gsub("[^%a%d]", ""):sub(-10)
	if base:match("^OPie") or not base:match("^%a") then base = "x" .. base end
	local suffix, c = "", 1
	while RK_RingDesc[base .. suffix] or queue[base .. suffix] or SV[base .. suffix] or (reserved and reserved[base .. suffix] ~= nil) or OPie:IsKnownRingName(base .. suffix) do
		suffix, c = math.random(2^c), c < 30 and (c + 1) or c
	end
	return base .. suffix
end
function api:AddDefaultRing(name, desc)
	assert(type(name) == "string" and type(desc) == "table", 'Syntax: RK:AddDefaultRing("name", descTable)', 2)
	assert(queue[name] == nil and RK_RingDesc[name] == nil, 'A ring with this name already exists', 2)
	queue[name] = copy(desc)
	RK_SetRingDesc(name, queue[name])
end
function api:SetExternalRing(name, desc)
	assert(type(name) == "string" and (type(desc) == "table" or desc == false), 'Syntax: RK:SetExternalRing("name", descTable or false)', 2)
	assert(queue[name] == nil and (RK_RingDesc[name] == nil or RK_FluxRings[name]), "A ring with this name already exists and cannot be modified", 2)
	RK_FluxRings[name] = true
	RK_SetRingDesc(name, desc)
end
function api:SetMountPreference(groundSpellID, airSpellID)
	assert((type(groundSpellID) == "number" or not groundSpellID) and
	       type(airSpellID) == "number" or not airSpellID, 'Syntax: groundSpellID, airSpellID = RK:SetMountPreference(groundSpellID|false|nil, airSpellID|false|nil)', 2)
	return RK_SetMountPreference(groundSpellID, airSpellID)
end

-- Private API: this just supports the configuration UI; no forward compatibility guarantees
function private:GetManagedRings()
	return ringIterator, false, nil
end
function private:GetRingDescription(name, serialize)
	assert(type(name) == "string", 'Syntax: desc = RK:GetRingDescription("name"[, serialize])', 2)
	local ring = RK_RingDesc[name] and copy(RK_RingDesc[name]) or false
	return serialize and ring and RK_SerializeDescription(ring) or ring
end
function private:GetRingInfo(name)
	assert(type(name) == "string", 'Syntax: title, numSlices, isDefault, isOverriden = RK:GetRingInfo("name")', 2)
	local ring = RK_RingDesc[name]
	return ring and (ring.name or name), ring and #ring, not not queue[name], ring and ring.save
end
function private:SetRing(name, desc)
	assert(type(name) == "string" and (type(desc) == "table" or desc == false), "Syntax: RK:SetRing(name, descTable or false)", 2)
	RK_SetRingDesc(name, desc)
end
function private:UnpackABAction(slice)
	if type(slice) == "table" and slice[1] == "macrotext" and type(slice[2]) == "string" then
		local pmt = RK_ParseMacro(slice[2])
		return "macrotext", pmt == "" and slice[2] ~= "" and "#empty" or pmt, unpackABAction(slice, 3)
	else
		return unpackABAction(slice, 1)
	end
end
function private:QuantizeMacro(macrotext)
	return RK_QuantizeMacro(macrotext)
end
function private:GetRingSnapshot(name, bundleNested)
	assert(type(name) == "string", 'Syntax: snapshot = RK:GetRingSnapshot("name"[, bundleNested])', 2)
	if not RK_RingDesc[name] then return end
	local props = copy(RK_RingDesc[name])
	local q, m, haveMacroCache = {}, {}, false
	repeat
		local props = m[table.remove(q)] or props
		RK_SerializeDescription(props)
		props.limit, props.save = type(props.limit) == "string" and props.limit:match("[^A-Z]") and "PLAYER" or props.limit
		for i=1,#props do
			local v = props[i]
			local st = v[1]
			if st == nil and type(v.id) == "string" then
				v.id, haveMacroCache = encodeMacro(RK_QuantizeMacro(v.id, haveMacroCache)), true
			elseif st == "ring" then
				local sn = v[2]
				if sn == name then
					m[name] = 0
				elseif bundleNested and RK_RingDesc[sn] and RK_RingDesc[sn].save and not m[sn] then
					q[#q+1], m[sn] = sn, copy(RK_RingDesc[sn])
				end
			end
			v.caption = nil -- DEPRECATED [2101/3.105/X4]
			v.sliceToken = nil
		end
	until not q[1]
	props._bundle = next(m) ~= nil and m or nil
	return serialize(props)
end
function private:GetSnapshotRing(snap)
	assert(type(snap) == "string", 'Syntax: desc, bundle = RK:GetSnapshotRing("snapshot")', 2)
	if snap == "" then return end
	local ok, root = pcall(unserialize, snap)
	if not ok or type(root) ~= "table" then return end
	local q, bun, bs = {}, {}, type(root._bundle) == "table" and root._bundle or nil
	repeat
		local ri = bun[table.remove(q)] or root
		if type(ri.name) ~= "string" then return end
		for i=1,#ri do
			local v, st, sa = ri[i]
			if not v then return end
			st, sa = v[1], v[2]
			v.caption = nil -- DEPRECATED [2101/3.105/X4]
			if st == nil and type(v.id) == "string" then
				v.id = decodeMacro(v.id)
			elseif st == "ring" and bs and sa then
				local bd = bs[sa]
				if bd == 0 and not bun[sa] then
					bun[sa] = 0
				elseif type(bd) == "table" and not bun[sa] then
					bun[sa], q[#q+1] = bd, sa
				end
			end
			dropUnderscoreKeys(v)
		end
		ri.name = ri.name:gsub("|?|", "||")
		ri.quarantineBind, ri.hotkey = type(ri.hotkey) == "string" and ri.hotkey or nil
		ri.quarantineOnOpen, ri.onOpen = ri.onOpen, nil
		dropUnderscoreKeys(ri)
	until q[1] == nil
	return root, bun
end
function private:IsRingSliceActive(ring, slice)
	return RK_RingDesc[ring] and RK_RingDesc[ring][slice] and RK_RingDesc[ring][slice]._action and true or false
end
function private:SoftSync(name)
	assert(type(name) == "string", 'Syntax: RK:SoftSync("name")', 2)
	securecall(RK_SyncRing, name)
end
function private:RestoreDefaults(name)
	if name == nil then
		for k, v in pairs(queue) do
			if RK_IsRelevantRingDescription(v) then
				self:SetRing(k, queue[k])
			end
		end
	elseif queue[name] then
		self:SetRing(name, queue[name])
	end
end
function private:GetDefaultDescription(name)
	assert(type(name) == "string", 'Syntax: desc = RK:GetDefaultDescription("name")', 2)
	return queue[name] and copy(queue[name]) or false
end
function private:GetDeletedRings()
	return ringIterator, true, nil
end

SV, T.RingKeeper, OPie.CustomRings, private.pub = PC:RegisterPVar("RingKeeper", SV, svInitializer), private, api, api
AB:AddObserver("internal.collection.preopen", abPreOpen)