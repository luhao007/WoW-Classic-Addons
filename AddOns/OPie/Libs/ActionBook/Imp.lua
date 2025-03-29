local MAJ, REV, COMPAT, _, T = 1, 12, select(4,GetBuildInfo()), ...
if T.SkipLocalActionBook then return end
if T.TenEnv then T.TenEnv() end

local EV, AB, RW = T.Evie, T.ActionBook:compatible(2,34), T.ActionBook:compatible("Rewire", 1,27)
assert(EV and AB and RW and 1, "Incompatible library bundle")
local MODERN, CF_WRATH, CI_ERA = COMPAT >= 10e4, COMPAT < 10e4 and COMPAT >= 3e4, COMPAT < 2e4
local IM, L, XU = {}, T.ActionBook.L, T.exUI

local function assert(condition, text, level, ...)
	return condition or error(tostring(text):format(...), 1 + (level or 1))((0)[0])
end

local GetModernTalentSpells do
	local GMTS_next, GMTS_node
	local function GMTS_entry(s, activeEID, entryID)
		local entry = C_Traits.GetEntryInfo(s.cid, entryID)
		local def = entry and entry.definitionID and C_Traits.GetDefinitionInfo(entry.definitionID)
		local sid = def and def.spellID
		if sid then
			return sid, activeEID == entryID, def.overrideName
		elseif entry.subTreeID then
			local sn, nodes = #s, C_Traits.GetTreeNodes(entry.subTreeID)
			if nodes and nodes[1] then
				s[sn+1], s[sn+2], s[sn+3], s[sn+4] = nodes, 1, s.cid, GMTS_node
			end
		end
		return GMTS_next(s)
	end
	function GMTS_node(s, confID, nodeID)
		local node = C_Traits.GetNodeInfo(confID, nodeID)
		local entryIDs = node and node.entryIDs
		if entryIDs and entryIDs[1] then
			local sn, activeEID = #s, node.activeEntry and node.activeEntry.entryID
			s[sn+1], s[sn+2], s[sn+3], s[sn+4] = node.entryIDs, 1, activeEID, GMTS_entry
		end
		return GMTS_next(s)
	end
	function GMTS_next(s)
		if not s then return end
		local sn = s and #s
		local a, i, c, fn = s[sn-3], s[sn-2], s[sn-1], s[sn]
		if a and a[i+1] == nil then
			s[sn-3], s[sn-2], s[sn-1], s[sn] = nil
		elseif i then
			s[sn-2] = i + 1
		end
		if fn then
			return fn(s, c, a[i])
		end
	end
	function GetModernTalentSpells()
		local s
		if MODERN then
			local cid = C_ClassTalents.GetActiveConfigID()
			if not cid then
				local spec = GetSpecializationInfo(GetSpecialization())
				local cc = C_ClassTalents.GetConfigIDsBySpecID(spec)
				cid = cc and cc[1]
			end
			local conf = cid and C_Traits.GetConfigInfo(cid)
			local tree = conf and conf.treeIDs and conf.treeIDs[1]
			local nodes = tree and C_Traits.GetTreeNodes(tree)
			s = nodes and {nodes, 1, cid, GMTS_node, cid=cid}
		end
		return GMTS_next, s
	end
end

local commandType, addCommandType = {["#show"]=0, ["#showtooltip"]=0, ["#imp"]=-1} do
	function addCommandType(slashToken, ct)
		local idx, s = 1
		while 1 do
			s = _G["SLASH_" .. slashToken .. idx]
			if not s then break end
			commandType[s], idx = commandType[s] or ct, idx + 1
		end
	end
	for n, ct in ("CAST:1 USE:1 CASTSEQUENCE:2 CASTRANDOM:3 USERANDOM:3"):gmatch("(%a+):(%d+)") do
		addCommandType(n, ct+0)
	end
	if MODERN then
		addCommandType("PING", 4)
	end
end

local toMacroText, quantizeMacro, formatMacro, formatToken, setMountPreference do
	local COMMA_LIST_COMMAND_TYPES, CAST_ESCAPE_COMMAND_TYPES = {[2]=1, [3]=1}, {[0]=1, [1]=1, [3]=1}
	local function parseListEntryPrefix(s, p)
		local sp, spc = p, p
		while spc do
			sp, spc = spc, s:match("^%s*<[^<]->()", sp)
		end
		return sp > p and s:sub(p, sp-1), sp
	end
	local genParser do
		local doRewrite, replaceFunc, critFail, critLine
		local function replaceAlternatives(ctype, args)
			local sp, ret, alt, alt2, altPrefix, rfCtx = 1
			repeat
				if ctype == 3 then
					altPrefix, sp = parseListEntryPrefix(args, sp)
				end
				alt, sp = args:match("([^,]*),?()", sp)
				alt2, rfCtx = replaceFunc(ctype, alt, rfCtx, args, sp)
				if alt == alt2 or (alt2 and alt2:match("%S")) then
					alt2 = doRewrite and alt2:match("^%s*(.-)%s*$") or alt2
					alt2 = altPrefix and altPrefix .. alt2 or alt2
					ret = ret and ret .. "," .. alt2 or alt2
				end
			until sp > #args
			if not doRewrite and args:sub(-1) == "," then
				ret = ret and ret .. "," or ret
			end
			return ret
		end
		local function hasTautCondition(cond)
			return (cond:match("%[%s*%]") or cond:match("%[%s*@[^,]*%]")) and true
		end
		local function procImpOptions(args)
			if not doRewrite then
				return
			end
			if args:match("^%s*critical%s*$") then
				critLine = true
			end
			return ""
		end
		local function procLine(commandPrefix, nlc, command, args)
			if critFail or (nlc ~= "" and nlc ~= "\n") then return end
			local ctype = commandType[command:lower()] or command:match("^/!%S") and commandType["/cast"]
			if ctype == -1 then
				return procImpOptions(args)
			elseif not ctype then
				return
			end
			local isCritical, pos, len1, ret = critLine and ctype > 0, 1, #args+1
			critLine = critLine and not isCritical
			repeat
				local cstart, cend, vend = pos
				repeat
					local ce, cc = args:match("()([%[;])", pos)
					if cc == "[" then
						pos = args:match("%]()", ce)
					else
						ce = ce or len1
						cend, vend, pos = pos, ce-1, ce + 1
					end
				until cend or not pos
				if not pos then return end
				local cval = args:sub(cend, vend)
				if ctype < 2 then
					cval = replaceFunc(ctype, args:sub(cend, vend))
				else
					local val, reset = args:sub(cend, vend)
					if ctype == 2 then
						local r, r2, v = val:match("^(%s*(reset=%S+)%s*)(.*)")
						reset, val = r and (doRewrite and r2 .. " " or r), v or val
					end
					val = replaceAlternatives(ctype, val)
					cval = val and ((reset or "") .. val) or nil
				end
				if cval or ctype == 0 then
					local cond = cstart < cend and args:sub(cstart, cend-1)
					if doRewrite then
						cond = cond and cond:match("^%s*(.-)%s*$")
						cval = cval and cval:match("^%s*(.-)%s*$")
						cond = cond and cval and (cond .. " ") or cond
					end
					ret = ret and (ret .. (doRewrite and "; " or ";")) or commandPrefix
					ret = ret .. (cond or "") .. (cval or "")
					if doRewrite and (not cond or hasTautCondition(cond)) then
						break
					end
				end
			until pos > len1
			critFail = critFail or isCritical and (ret or "") == ""
			return ret or ""
		end
		function genParser(pReplaceFunc)
			return function(aDoRewrite, text)
				doRewrite, replaceFunc, critFail, critLine = aDoRewrite, pReplaceFunc
				text = text:gsub("((.?)([#/]%S+) ?)([^\n]*)", procLine)
				return critFail and "" or text
			end
		end
	end
	local function parseVarPrefix(value, _ctype)
		local varPrefixEnd = 1
		repeat
			local col, ep = value:match("^%s*%%[a-zA-Z\128-\255][a-zA-Z0-9_\128-\255]*(%S?)%s*()", varPrefixEnd)
			if not ep or col ~= ":" and ep <= #value then
				break
			else
				varPrefixEnd = ep
			end
		until ep > #value
		return varPrefixEnd == 1 and "" or value:sub(1, varPrefixEnd-1)
	end
	local function restoreVarPrefix(varPrefix, emitText)
		if varPrefix == "" then
			return emitText
		elseif emitText then
			return varPrefix .. emitText
		end
		return (varPrefix:gsub("%:%s*$", ""))
	end
	local function replaceSpellID(ctype, sidlist, prefix, tk)
		local noEscapes, sn, sr, ar = not CAST_ESCAPE_COMMAND_TYPES[ctype]
		for id in sidlist:gmatch("%d+") do
			id = id + 0
			sn, sr = GetSpellInfo(id), GetSpellSubtext(id)
			ar = sn and GetSpellSubtext(sn)
			local isCastable, castFlag = RW:IsSpellCastable(id, noEscapes)
			if not MODERN and not isCastable and tk ~= "spellr" then
				local id2 = select(7,GetSpellInfo(sn))
				if id2 then
					id, isCastable, castFlag = id2, RW:IsSpellCastable(id2, noEscapes)
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
	local replaceMountTag do -- +setMountPreference
		local skip, gmSid, gmPref, fmSid, fmPref, drSid, drPref = {[44153]=1, [44151]=1, [61451]=1, [75596]=1, [61309]=1, [169952]=1, [171844]=1, [213339]=1,}
		local function IsKnownSpell(sid)
			local sn, sr = GetSpellInfo(sid or 0), GetSpellSubtext(sid or 0)
			return GetSpellInfo(sn, sr) ~= nil and sid or (RW:GetCastEscapeAction(sn) and sid)
		end
		local function findMount(prefSID, mtype, ctype)
			local wantDragonriding, escapeContext = mtype == 402, ctype == 2 and 0 or 1
			if prefSID and RW:IsSpellCastable(prefSID, escapeContext) then
				return prefSID
			end
			local idm, myFactionId, nc, cs = C_MountJournal.GetMountIDs(), UnitFactionGroup("player") == "Horde" and 0 or 1, 0
			local gmi, gmiex = C_MountJournal.GetMountInfoByID, C_MountJournal.GetMountInfoExtraByID
			for i=1, #idm do
				i = idm[i]
				local _1, sid, _3, active, _5, _6, _7, factionLocked, factionId, hide, have, _12, _isSteadyFlight = gmi(i)
				if have and not hide
				   and (not factionLocked or factionId == myFactionId)
				   and RW:IsSpellCastable(sid, escapeContext)
				   then
					local _, _, _, _, t = gmiex(i)
					local isTypeMatch = t == mtype or (wantDragonriding and t == 424)
					if sid == prefSID or (active and isTypeMatch and prefSID == nil) then
						return sid
					elseif isTypeMatch and not skip[sid] then
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
			if tag == "ground" then
				gmSid = gmSid and IsKnownSpell(gmSid) or findMount(gmPref or gmSid, 230, ctype)
				return replaceSpellID(ctype, tostring(gmSid), prefix)
			elseif tag == "dragon" or MODERN and tag == "air" then
				drSid = drSid and IsKnownSpell(drSid) or findMount(drPref or drSid, 402, ctype)
				return replaceSpellID(ctype, tostring(drSid), prefix)
			elseif tag == "air" then
				fmSid = fmSid and IsKnownSpell(fmSid) or findMount(fmPref or fmSid, 248, ctype)
				return replaceSpellID(ctype, tostring(fmSid), prefix)
			end
			return nil
		end
		if not (MODERN or CF_WRATH) then
			replaceMountTag = function () end
		end
		local function editPreference(orig, new, cached)
			local v = type(new) == "number" and new or new ~= false and orig or nil
			return v, v == orig and cached or nil
		end
		function setMountPreference(groundSpellID, flyingSpellID, dragonSpellID)
			gmPref, gmSid = editPreference(gmPref, groundSpellID, gmSid)
			fmPref, fmSid = editPreference(fmPref, flyingSpellID, fmSid)
			drPref, drSid = editPreference(drPref, dragonSpellID, drSid)
			return gmPref, fmPref, drPref
		end
	end
	local pingTextMap, pingTokenMap = {}, {
		assist=PING_TYPE_ASSIST,
		attack=PING_TYPE_ATTACK,
		onmyway=PING_TYPE_ON_MY_WAY,
		warning=PING_TYPE_WARNING,
	}
	for k,v in pairs(pingTokenMap) do
		pingTextMap[v:lower()], pingTextMap[k] = k, k
	end
	toMacroText = genParser(function(ctype, value)
		local varPrefix = parseVarPrefix(value, ctype)
		local prefix, tkey, tval = value:match("^%s*(!?){{(%a+):([%a%d/]+)}}%s*$", #varPrefix+1)
		if tkey == "spell" or tkey == "spellr" then
			return restoreVarPrefix(varPrefix, replaceSpellID(ctype, tval, prefix, tkey))
		elseif tkey == "mount" then
			return restoreVarPrefix(varPrefix, replaceMountTag(ctype, tval, prefix))
		elseif tkey == "ping" and ctype == 4 then
			return restoreVarPrefix(varPrefix, pingTokenMap[tval] or value)
		elseif value:match('^%s*!?|Hiptok|h|h%s*$') then
			return '-'
		end
		return value
	end)
	local toImpText, prepareQuantizer do
		local spells, specialTokens, OTHER_SPELL_IDS = {}, {}, {150544, 243819, 460013}
		local abMountTokens = {["Ground Mount"]="{{mount:ground}}", ["Flying Mount"]="{{mount:air}}", ["Dragonriding Mount"]=MODERN and "{{mount:dragon}}" or nil}
		toImpText = genParser(function(ctype, value, skipCount, args, cpos)
			if type(skipCount) == "number" and skipCount > 0 then
				-- This replaceAlternatives interaction would get bamboozled by
				-- a castable token matching ",%s*<[^<]-,[^<]*>".
				return nil, skipCount-1
			end
			local commaList, noEscapes = COMMA_LIST_COMMAND_TYPES[ctype], not CAST_ESCAPE_COMMAND_TYPES[ctype]
			local varPrefix = parseVarPrefix(value, ctype)
			local cc, pre, name, tws = 0, value:match("^(%s*!?)(.-)(%s*)$", #varPrefix+1)
			repeat
				local lowname = name:lower()
				local sid, peek, cnpos = spells[lowname]
				if ctype == 4 then
					name = pingTextMap[lowname]
					if name then
						return restoreVarPrefix(varPrefix, pre .. "{{ping:" .. name.. "}}" .. tws)
					end
				elseif sid and noEscapes and RW:IsCastEscape(lowname, true) then
					-- Don't tokenize escapes in contexts they wont't work in
				elseif sid then
					if not MODERN then
						local rname = name:gsub("%s*%([^)]+%)$", "")
						local sid2 = rname ~= name and spells[rname:lower()]
						if sid2 then
							return restoreVarPrefix(varPrefix, (pre .. "{{spellr:" .. sid .. "}}" .. tws)), cc
						end
					end
					return restoreVarPrefix(varPrefix, (pre .. "{{spell:" .. sid .. "}}" .. tws)), cc
				elseif specialTokens[lowname] then
					return restoreVarPrefix(varPrefix, pre .. specialTokens[lowname] .. tws), cc
				elseif name:match("^{{.*}}$") then
					return restoreVarPrefix(varPrefix, pre .. name .. tws), cc
				end
				if commaList and args then
					peek, cnpos = args:match("^([^,]+),?()", cpos)
					if peek then
						cc, cpos, name, tws = cc + 1, cnpos, (name .. "," .. peek):match("^(.-)(%s*)$")
					end
				end
			until not peek or cc > 5
			return value
		end)
		local function addMountSpells()
			local gmi, idm = C_MountJournal.GetMountInfoByID, C_MountJournal.GetMountIDs()
			for i=1, #idm do
				local _, sid = gmi(idm[i])
				local sname = GetSpellInfo(sid)
				if sname then
					spells[sname:lower()] = sid
				end
			end
			for k, tok in pairs(abMountTokens) do
				specialTokens[k:lower()], specialTokens[L(k):lower()] = tok, tok
			end
		end
		local function addModernTalents()
			for sid, _active, overrideName in GetModernTalentSpells() do
				local name = GetSpellInfo(sid)
				if name then
					spells[name:lower()] = sid
				end
				if overrideName and overrideName ~= name then
					spells[overrideName:lower()] = sid
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
		local function addSpellBookTab(ofs, c, allowGenericOverwrite, isRuneBook)
			for j=ofs+1,ofs+c do
				local n, st, id = GetSpellBookItemName(j, "spell"), GetSpellBookItemInfo(j, "spell")
				if type(n) ~= "string" or not id then
				elseif st == "SPELL" or st == "FUTURESPELL" then
					local ao = allowGenericOverwrite and st == "SPELL" and not isRuneBook
					if isRuneBook then
						local sn, id2 = GetSpellInfo(id), select(7, GetSpellInfo(n))
						if sn ~= n then
							addSpell(sn, id, ao)
						end
						if id2 and id2 ~= id then
							addSpell(n, id2, ao)
						end
					end
					addSpell(n, id, ao)
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
		function prepareQuantizer(skipCacheRefresh)
			if skipCacheRefresh and next(spells) then return end
			wipe(spells)
			wipe(specialTokens)
			for i=1,#OTHER_SPELL_IDS do
				local sn = GetSpellInfo(OTHER_SPELL_IDS[i])
				if sn then
					spells[sn:lower()] = OTHER_SPELL_IDS[i]
				end
			end
			if MODERN then
				addMountSpells()
				addModernTalents()
			elseif CF_WRATH then
				addMountSpells()
				for i=1,GetNumCompanions("CRITTER") do
					local _, _, sid = GetCompanionInfo("CRITTER", i)
					local sn = GetSpellInfo(sid)
					if sn then
						addSpell(sn, sid)
					end
				end
			end
			for curSpec=0,1 do
				for i=GetNumSpellTabs()+12,1,-1 do
					local _, ico, ofs, c, _, sid = GetSpellTabInfo(i)
					if ((curSpec == 0) == (sid == 0)) then
						addSpellBookTab(ofs, c, not MODERN, CI_ERA and ico == 134419)
					end
				end
			end
			spells[""], spells["()"] = nil
		end
	end
	function quantizeMacro(macro, skipCacheRefresh)
		if type(macro) ~= "string" then
			return macro
		end
		prepareQuantizer(skipCacheRefresh)
		return toImpText(false, macro)
	end
	do -- formatMacro/formatToken
		local formatTokenInner do
			local names, tag, mountTokens = {}, 0, {
				ground="|cff71d5ff|Hiltmount:ground|h" .. L"Ground Mount" .. "|h|r",
				air   ="|cff71d5ff|Hiltmount:air|h" .. L"Flying Mount" .. "|h|r",
				dragon="|cff71d5ff|Hiltmount:dragon|h" .. L"Dragonriding Mount" .. "|h|r",
			}
			function formatTokenInner(token, targ)
				if token == "spell" or token == "spellr" then
					local forceRank, tname = token == "spellr"
					tag = tag + 1
					for id in targ:gmatch("%d+") do
						id = id+0
						local name, sr = GetSpellInfo(id), GetSpellSubtext(id)
						if sr and sr ~= "" and (forceRank or MODERN) then
							name = name .. "(" .. sr .. ")"
						end
						if name and names[name] ~= tag then
							names[name], tname = tag, tname and (tname .. " / " .. name) or name
						end
					end
					if tname then
						return "|cff71d5ff|Hilt" .. token .. ":" .. targ .. "|h" .. tname .. "|h|r"
					end
				elseif token == "mount" then
					return mountTokens[targ]
				elseif token == "ping" then
					local tname = pingTokenMap[targ]
					if tname then
						return "|cff71d5ff|Hilt" .. token .. ":" .. targ .. "|h" .. tname .. "|h|r"
					end
				end
				return '{{' .. token .. ':' .. targ .. '}}'
			end
		end
		local toUIText = genParser(function(ctype, value)
			local varPrefix = parseVarPrefix(value, ctype)
			local prefix, token, targ, suf = value:match("^(%s*!?){{(%a+):([%a%d/]+)}}(%s*)$", #varPrefix+1)
			local v = token and formatTokenInner(token, targ)
			return v and restoreVarPrefix(varPrefix, prefix .. v .. suf) or value
		end)
		local linkTag = 0
		local function tagLinks(p)
			linkTag = linkTag + 1
			return p .. linkTag .. ":"
		end
		function formatToken(lastLink, tk, targ)
			linkTag, tk = lastLink or 0, formatTokenInner(tk, targ)
			tk = tk:gsub("%f[|]|Hilt", tagLinks)
			return tk, linkTag
		end
		function formatMacro(macro)
			if type(macro) == "string" then
				linkTag, macro = 0, toUIText(false, macro)
				macro = macro:gsub("%f[|]|Hilt", tagLinks)
			end
			return macro, linkTag
		end
	end
end
local encodeMacro, decodeMacro do
	local skipCacheRefresh
	local phash_ChatTypeInfoList, importLooseSlashCommands = setmetatable({}, {__index=hash_ChatTypeInfoList}) do
		local imported = {}
		-- Bootleg ChatFrame_ImportListToHash(SlashCmdList, hash_SlashCmdList); calling the FrameXML version directly
		-- would defeat its iterator isolation, and SlashCmdList has late-added secure entries which would notice.
		function importLooseSlashCommands()
			for k in pairs(SlashCmdList) do
				if not imported[k] then
					local p, i, cmd = "SLASH_" .. k, 1
					repeat
						cmd, i = _G[p .. i], i + 1
						if type(cmd) == "string" then
							phash_ChatTypeInfoList[cmd:upper()] = k
						end
					until not cmd
					imported[k] = true
				end
			end
		end
	end
	local function encodeSlash(nl, command, lead)
		if nl ~= "\n" and nl ~= "" then
			return
		elseif lead == "!" then
			return nl .. "!" .. command
		end
		local cu = command:upper()
		if not (skipCacheRefresh or next(SlashCmdList) == nil) then
			skipCacheRefresh = true
			importLooseSlashCommands()
		end
		local ctk = phash_ChatTypeInfoList[cu]
		if type(ctk) == "string" and not ctk:match("!") then
			return nl .. "!" .. ctk .. "!" .. command
		elseif type(hash_EmoteTokenList[cu]) == "string" and not hash_EmoteTokenList[cu]:match("!") then
			return nl .. "!" .. hash_EmoteTokenList[cu] .. "!" .. command
		end
	end
	local function decodeSlash(nl, key, command)
		if nl ~= "\n" and nl ~= "" then
			return
		elseif key == "" then
			return nl .. "!" .. command
		end
		local cu = command:upper()
		if not (skipCacheRefresh or next(SlashCmdList) == nil) then
			skipCacheRefresh = true
			importLooseSlashCommands()
		end
		if phash_ChatTypeInfoList[cu] == key or hash_EmoteTokenList[cu] == key then
		elseif _G["SLASH_" .. key .. 1] then
			return nl .. _G["SLASH_" .. key .. 1]
		else
			local i, v = 2, EMOTE1_TOKEN
			while v do
				if v == key then
					return nl .. _G["EMOTE" .. (i-1) .. "_CMD1"]
				end
				i, v = i + 1, _G["EMOTE" .. i .. "_TOKEN"]
			end
		end
		return nl .. command
	end
	function encodeMacro(m, skipImport)
		skipCacheRefresh = skipImport
		return (m:gsub("(.?)(([/!])%S*)", encodeSlash))
	end
	function decodeMacro(m, skipImport)
		skipCacheRefresh = skipImport
		return (m:gsub("(.?)!([^\n!]*)!(%S*)", decodeSlash))
	end
end

do -- AB imptext action type
	local function findAnySpellTokenIcon(imptext)
		local argMod = 2^31
		for sl in imptext:gmatch("{{spell:([%d/]+)}}") do
			for sid in sl:gmatch("%d+") do
				local _,_, sico = GetSpellInfo(sid % argMod)
				if sico then
					return sico
				end
			end
		end
	end
	local function createImpMacro(macrotext)
		if type(macrotext) ~= "string" then return end
		local dt = toMacroText(true, macrotext)
		return dt and dt:match("%S") and AB:GetActionSlot("macrotext", dt) or nil
	end
	local function describeImpMacro(imptext)
		if type(imptext) ~= "string" then return end
		if imptext == "" then return L"Custom Macro", L"New Macro", "Interface/Icons/INV_Misc_Note_03" end
		local _, _, ico = RW:GetMacroAction(toMacroText(true, imptext))
		local lp = ico and type(ico) == "string" and ico:gsub("\\", "/"):lower()
		if ico == nil or lp == "interface/icons/temp" or lp == "interface/icons/inv_misc_questionmark" then
			ico = findAnySpellTokenIcon(imptext)
		end
		return L"Custom Macro", "", ico or "interface/icons/inv_misc_questionmark"
	end
	AB:RegisterActionType("imptext", createImpMacro, describeImpMacro, 1)
end
do -- Editor UI
	local function removeEditorLinks(text)
		return (text:gsub("|c%x+|Hilt%d+:([%a:%d/]+)|h.-|h|r", "{{%1}}"))
	end
	local setImpText, getImpText, newImpToken do
		local nextLinkID
		function setImpText(box, imptext)
			local uitext
			uitext, nextLinkID = formatMacro(imptext)
			return box:SetText(uitext)
		end
		function getImpText(box)
			return quantizeMacro(removeEditorLinks(box:GetText()))
		end
		function newImpToken(_forBox, tok, targ)
			local uitext
			uitext, nextLinkID = formatToken(nextLinkID, tok, targ)
			return uitext
		end
	end

	local eb = XU:Create("TextArea", "ABE_MacroInput")
	eb:Hide()
	eb:SetStyle("tooltip")
	eb:SetScript("OnEscapePressed", eb.ClearFocus)
	eb:SetScript("OnEditFocusLost", function(self)
		setImpText(self, getImpText(self))
		local p = self:GetParent()
		if p and type(p.OnActionChanged) == "function" then
			p:OnActionChanged(self)
		end
	end)
	eb:SetStickyFocus(true)
	eb:SetHyperlinksEnabled(true)
	eb:SetScript("OnHyperlinkClick", function(self, link, text, button)
		local pos = string.find(self:GetText(), text, 1, 1)-1
		self:HighlightText(pos, pos + #text)
		if button == "RightButton" and link:match("^ilt%d+:") then
			local replace = IsAltKeyDown() and text:match("|h(.-)|h") or removeEditorLinks(text)
			self:Insert(replace)
			self:HighlightText(pos, pos + #replace)
		else
			self:SetCursorPosition(pos + #text)
		end
		self:SetFocus()
	end)
	eb:SetScript("OnKeyDown", function(self, key)
		if (key == "C" or key == "X") and (IsMacClient() and IsMetaKeyDown or IsControlKeyDown)() then
			local stext = self:GetHighlightText()
			if stext:match("[^|]|H.+|h.*|h") then
				self:SetHighlightText(removeEditorLinks(stext), true)
				self._rsText = key == "C" and stext or nil
			end
		end
	end)
	eb:SetScript("OnUpdate", function(self)
		if self._rsText then
			self:SetHighlightText(self._rsText, true)
			self._rsText = nil
		end
	end)
	eb:SetScript("OnTabPressed", function(self)
		local p = self:GetParent()
		if p and type(p.OnTabPressed) then
			p:OnTabPressed()
		end
	end)
	local function isImpTokenParsed(prefixText)
		local suf = '|Hiptok|h|h'
		return toMacroText(false, prefixText .. suf):sub(-#suf) ~= suf
	end
	local function stripUIEscapeCheck(preseq)
		return (#preseq % 2) == 0 and preseq or nil
	end
	local function stripUIEscapes(link)
		return (link:gsub("(|*)|H.-|h", stripUIEscapeCheck):gsub("(|*)|[hr]", stripUIEscapeCheck):gsub("(|*)|c%x%x%x%x%x%x%x%x", stripUIEscapeCheck))
	end
	hooksecurefunc("ChatEdit_InsertLink", function(link)
		if not eb:HasFocus() then return end
		local isItemLink = link:match("%f[|]|Hitem:")
		local sid = not isItemLink and link:match("%f[|]|Hspell:(%d+)") or link:match("%f[|]|Htrade:[^:]+:(%d+)") or (CI_ERA and select(7,GetSpellInfo(link)))
		local isCastableLink = sid and not IsPassiveSpell(sid+0)
		local prefix, atext, skipPrefixSpace
		if isItemLink or isCastableLink then
			eb:Insert("") -- Inserting the link will clobber selection; do it now to i.a. converge cursor position
			local cursor, text = eb:GetCursorPosition(), eb:GetText()
			local isOnEmptyLineStart, lineCommand, lineStart do
				local lep, sp, wep, ap = 0
				while 1 do
					sp, wep, ap, lep = text:match("()%S*()[^\n%S]*()[^\n]*()", lep+1)
					if lep > cursor then
						isOnEmptyLineStart = cursor < sp and ap == lep
						lineCommand = cursor >= wep-1 and text:sub(sp, wep-1):lower()
						lineStart = sp
						break
					end
				end
			end
			local canTokenize, tokPrefix, tokSuffix, tokNoPreSpace do
				if not isCastableLink then
				elseif isOnEmptyLineStart then
					canTokenize = true
				elseif commandType[lineCommand] then
					canTokenize = isImpTokenParsed(removeEditorLinks(text:sub(1, cursor)) .. ' ;')
					if canTokenize then
						local ct, nc = commandType[lineCommand], text:match('^[^%S\n]*(.?)', cursor+1)
						tokSuffix = nc ~= '' and nc ~= '\n' and nc ~= ';' and (ct < 2 or nc ~= ',') and ((ct < 2 or nc == '[') and ';' or ',')
						local excPrefix = text:sub(cursor, cursor) == '!'
						local baseLineText = removeEditorLinks(text:sub(lineStart, cursor)) .. (excPrefix and '' or ' ')
						tokPrefix = not isImpTokenParsed(baseLineText) and (ct >= 2 and isImpTokenParsed(baseLineText .. ',') and ',' or ';')
						tokNoPreSpace = excPrefix and not tokPrefix
					end
				end
			end
			if isItemLink then
				prefix = isOnEmptyLineStart and (C_Item.GetItemSpell(link) and SLASH_USE1 or SLASH_EQUIP1)
				atext = C_Item.GetItemNameByID(link)
			else
				prefix = isOnEmptyLineStart and SLASH_CAST1
				if canTokenize then
					atext = newImpToken(eb, "spell", tostring(sid))
					prefix = prefix or (atext and tokPrefix)
					atext = atext and atext .. (tokSuffix or "")
					skipPrefixSpace = tokNoPreSpace
				end
			end
		end
		prefix = skipPrefixSpace and (prefix or "") or (prefix and prefix .. " " or " ")
		eb:Insert(prefix .. (atext or link:match("|h%[?(.-[^%]])%]?|h") or stripUIEscapes(link)))
	end)

	function eb:SetAction(owner, action)
		local op = eb:GetParent()
		if op and op ~= owner and type(op.OnEditorRelease) == "function" then
			securecall(op.OnEditorRelease, op, self)
		end
		eb:SetParent(nil)
		eb:ClearAllPoints()
		eb:SetAllPoints(owner)
		eb:SetParent(owner)
		setImpText(eb, action[1] == "imptext" and action[2] or "")
		eb:SetCursorPosition(0)
		eb:Show()
	end
	function eb:GetAction(into)
		into[1], into[2] = "imptext", getImpText(eb)
	end
	function eb:Release(owner)
		if eb:IsOwned(owner) then
			eb:SetParent(nil)
			eb:ClearAllPoints()
			eb:Hide()
		end
	end
	function eb:IsOwned(owner)
		return eb:GetParent() == owner
	end
	function eb:GetTabFocusWidget(_which)
		return eb
	end
	AB:RegisterEditorPanel("imptext", eb)
end

function IM:EncodeCommands(macrotext, skipCacheRefresh)
	assert(type(macrotext) == "string" and (skipCacheRefresh == nil or type(skipCacheRefresh) == "boolean"),
	       'Syntax: enctext = IM:EncodeCommands("macrotext"[, skipCacheRefresh])', 2)
	return encodeMacro(macrotext, skipCacheRefresh)
end
function IM:DecodeCommands(enctext, skipCacheRefresh)
	assert(type(enctext) == "string" and (skipCacheRefresh == nil or type(skipCacheRefresh) == "boolean"),
	       'Syntax: macrotext = IM:DecodeCommands("enctext"[, skipCacheRefresh])', 2)
	return decodeMacro(enctext, skipCacheRefresh)
end

function IM:EncodeTokens(imptext, skipCacheRefresh)
	assert(type(imptext) == "string" and (skipCacheRefresh == nil or type(skipCacheRefresh) == "boolean"),
	       'Syntax: imptext = IM:EncodeTokens("macrotext"[, skipCacheRefresh])', 2)
	return quantizeMacro(imptext, skipCacheRefresh)
end
function IM:DecodeTokens(imptext)
	assert(type(imptext) == "string", 'Syntax: macrotext = IM:DecodeTokens("imptext")', 2)
	return toMacroText(true, imptext)
end
function IM:FormatTokens(imptext)
	assert(type(imptext) == "string", 'Syntax: uitext = IM:FormatTokens("imptext")', 2)
	return formatMacro(imptext)
end
function IM:AddTokenizableCommand(slashKey, behavesLikeCommand)
	assert(type(slashKey) == 'string' and type(behavesLikeCommand) == 'string',
	       'Syntax: IM:AddTokenizableCommand("slashKey"[, "behavesLikeCommand"])', 2)
	assert(type(_G['SLASH_' .. slashKey .. '1']) == 'string', 'Invalid slash command key %q', 2, slashKey)
	assert((commandType[behavesLikeCommand] or -1) >= 0, 'Unrecognized behaves-like command %q', 2, behavesLikeCommand)
	addCommandType(slashKey, commandType[behavesLikeCommand])
	AB:NotifyObservers("imptext")
end

function IM:SetMountPreference(groundSpellID, flyingSpellID, dragonSpellID)
	assert((type(groundSpellID) == "number" or not groundSpellID) and
	       (type(flyingSpellID) == "number" or not flyingSpellID) and
	       (type(dragonSpellID) == "number" or not dragonSpellID),
	       'Syntax: groundSpellID, flyingSpellID, dragonSpellID = IM:SetMountPreference(groundSpellID|false|nil, flyingSpellID|false|nil, dragonSpellID|false|nil)', 2)
	return setMountPreference(groundSpellID, flyingSpellID, dragonSpellID)
end

-- HIDDEN, UNSUPPORTED METHODS: May vanish at any time.
local hum = {}
setmetatable(IM, {__index=hum})
hum.HUM = hum
hum.GetModernTalentSpells = GetModernTalentSpells

AB:RegisterModule("Imp", {
	compatible=function(_, maj, rev)
		if maj == MAJ and (rev == nil or rev <= REV) then
			return IM
		end
	end
})