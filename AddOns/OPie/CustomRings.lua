local MAJ, REV, _, T = 3, 62, ...
local EV, ORI, PC = T.Evie, OPie.UI, T.OPieCore
local AB, RW, IM = T.ActionBook:compatible(2,37), T.ActionBook:compatible("Rewire", 1,10), T.ActionBook:compatible("Imp", 1, 0)
assert(ORI and AB and RW and IM and EV and PC and 1, "Missing required libraries")

local api, private, NS = {}, {}, {}
local RK_RingDesc, RK_CollectionIDs, RK_FluxRings, SV = {}, {}, {}
local loadLock, queue, RK_DeletedRings, RK_FlagStore, sharedCollection = 0, {}, {}, {}, {}
local CLASS, FULLNAME, FACTION
local rotationPresentationModes = {cycle=20, shuffle=36, random=52, reset=68, jump=84}
local SLICE_ACTIONID_TYPE = {string="imptext", number="spell"}

local function assert(condition, text, level, ...)
	return condition or error(tostring(text):format(...), 1 + (level or 1))((0)[0])
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
		local h, p2, p3 = (134217689 * #s) % 17592186044399, sigN^2, sigN^3
		for i=1,#s,4 do
			local a, b, c, d = s:match("(.?)(.?)(.?)(.?)", i)
			a, b, c, d = sigT[a], (sigT[b] or 0) * sigN, (sigT[c] or 0) * p2, (sigT[d] or 0) * p3
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
local function updateSliceAction_Z3(slice)
	local at, v = type(slice[1]) == "string" and slice[1] or SLICE_ACTIONID_TYPE[type(slice.id)]
	if at == "item" then
		v = (slice.forceShow and 1 or 0) + (slice.byName and 2 or 0) + (slice.onlyEquipped and 4 or 0)
		slice.byName, slice.forceShow, slice.onlyEquipped = nil
	elseif at == "macro" or at == "extrabutton" or at == "toy" then
		v = (slice.forceShow and 1 or 0)
		slice.forceShow = nil
	elseif at == "opie.databroker.launcher" then
		v = (slice.clickUsingRightButton and 8 or 0)
		slice.clickUsingRightButton = nil
	elseif at == "spell" then
		slice[3] = slice[3] == "lock-rank" and 16 or nil
	end
	if v then
		slice[3] = v > 0 and v or nil
	end
end
local function genSliceTokenIndexMap(props)
	local r = {}
	for i=1, #props do
		r[props[i].sliceToken or r] = i
	end
	r[r] = nil
	return r
end

local RK_SetRingDesc
local function RK_SyncRing(name, force, tok)
	local desc, changed, cid = RK_RingDesc[name], (force == true), RK_CollectionIDs[name]
	if loadLock < 2 or not RK_IsRelevantRingDescription(desc) then return end
	tok = tok or AB:GetLastObserverUpdateToken("*")
	if not force and tok == desc._lastUpdateToken then return end
	desc._lastUpdateToken = tok
	
	local limit = desc.limit
	desc.sortScope = limit == FULLNAME and 30 or limit == CLASS and 20 or 10
	if not cid then
		wipe(sharedCollection)
		changed, cid = true, AB:CreateActionSlot(nil, nil, "collection", sharedCollection)
		RK_CollectionIDs[name], RK_CollectionIDs[cid] = cid, name
		PC:SetRing(name, cid, desc)
	end

	local onOpenSlice, onOpenAction, onOpenToken = desc.onOpen
	for i=1, #desc do
		local e = desc[i]
		local ident, action, pmode = e[1]
		if type(ident) == "string" then
			action = AB:GetActionSlot(e)
		end
		pmode = action and ((rotationPresentationModes[e.rotationMode] or 4) + (e.fastClick and 0 or 2)) or nil
		changed = changed or (action ~= e._action) or action and (e.show ~= e._show or e.embed ~= e._embed or pmode ~= e._pmode)
		e._action, e._pmode = action, pmode
		if i == onOpenSlice then
			onOpenAction, onOpenToken = e._action, e.sliceToken
		elseif action then
			ORI:SetDisplayOptions(e.sliceToken, e.icon, e.label, e._r, e._g, e._b)
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
			collection['__pmode-' .. e.sliceToken] = e._pmode
		end
	end
	collection['__embed'], desc._embed = desc.embed, desc.embed
	collection['__openAction'], desc._onOpen = onOpenAction, onOpenAction
	collection['__openToken'], desc._onOpenToken = onOpenToken, onOpenToken
	AB:UpdateActionSlot(cid, collection)
	PC:SetRing(name, cid, desc)
end
local BUP = {} do
	local metaBits = {name=1, hotkey=2, internal=4, limit=8, embed=16, noOpportunisticCA=32, onOpen=64}
	local ignoreSliceFields = {sliceToken=0, vm=0}
	function BUP.DiffSlice(slice, bs)
		if not bs then return end
		local am, mm, ia, ib = true, true, slice, bs
		repeat
			for k,v in pairs(ia) do
				local kt = type(k)
				am = am and (kt ~= "number" or ib[k] == v)
				mm = mm and (kt ~= "string" or ib[k] == v or ignoreSliceFields[k] or k:sub(1,1) == "_")
			end
			ia, ib = ib, ia
		until ia == slice or not (am or mm)
		local r = (am and 1 or 0) + (mm and 2 or 0)
		return r > 0 and r or nil
	end
	function BUP.PatchSlice(slice, bs, patchBits)
		if patchBits == 0 or type(patchBits) ~= "number" then
			return
		end
		local patchAction, patchMeta, cl = patchBits % 2 > 0, patchBits % 4 > 1
		for s=1, 2 do
			for k in pairs(s == 1 and bs or slice) do
				local tk, bv = type(k), bs[k]
				if bv ~= nil and s > 1 then
				elseif tk == "number" and patchAction or
				       tk == "string" and patchMeta and not ignoreSliceFields[k] and k:sub(1,1) ~= "_" then
					if type(bv) == "table" then
						cl = cl or {}
						bv = copy(bv, cl)
					end
					slice[k] = bv
				end
			end
		end
	end
	function BUP.FindSliceWithAction(props, needle, avoidTokens)
		local mv, mi
		for i=1, #props do
			local si = props[i]
			if not avoidTokens[si.sliceToken] then
				local v = BUP.DiffSlice(props[i], needle)
				if v and v % 2 > 0 and (mv == nil or v > mv) then
					mv, mi = v, i
				end
			end
		end
		return mi
	end
	function BUP.FindSliceByToken(props, needle)
		for i=1,#props do
			if props[i].sliceToken == needle then
				return i
			end
		end
	end
	function BUP.DiffRingMeta(props, bp)
		local r = 0
		for k,v in pairs(metaBits) do
			r = props[k] == bp[k] and r + v or r
		end
		return r > 0 and r or nil
	end
	function BUP.PatchRingMeta(props, bp, patchBits)
		if patchBits == 0 or type(patchBits) ~= "number" then
			return
		end
		for k,v in pairs(metaBits) do
			if patchBits % (v+v) >= v and bp[k] ~= nil then
				props[k] = bp[k]
			end
		end
	end
	function BUP.UpgradeBundledRing(saved, bundled)
		if not (bundled and bundled.v and (tonumber(bundled.v) or 0) > (tonumber(saved.v) or 0)) then
			return
		end
		local drop, lastMatchIndex = type(saved.dropTokens) == "table" and saved.dropTokens or nil, 0
		local stim, bstim = genSliceTokenIndexMap(saved), genSliceTokenIndexMap(bundled)
		for bst, bidx in pairs(bstim) do
			local bs, aid = bundled[bidx]
			for i=stim[bst] or 1, stim[bst] and #saved or 0 do
				if saved[i].sliceToken == bst then
					aid = i
					break
				end
			end
			aid = aid or BUP.FindSliceWithAction(saved, bs, bstim)
			if aid then
				BUP.PatchSlice(saved[aid], bs, saved[aid].vm)
				saved[aid].sliceToken, lastMatchIndex = bs.sliceToken, aid
			elseif not (drop and drop[bst]) then
				lastMatchIndex = lastMatchIndex + 1
				table.insert(saved, lastMatchIndex, copy(bs))
			end
		end
		for i=#saved, 1, -1 do
			local vm = not bstim[saved[i].sliceToken] and saved[i].vm
			if vm and type(vm) == "number" and vm % 2 > 0 then
				table.remove(saved, i)
			end
		end
		BUP.PatchRingMeta(saved, bundled, saved.vm)
		saved.v = bundled.v
	end
end
local function findSliceByToken(props, st)
	for i=1, props and st and #props or 0 do
		if props[i].sliceToken == st then
			return props[i]
		end
	end
end
local function dropUnderscoreKeys(t)
	for k in pairs(t) do
		if type(k) == "string" and k:sub(1,1) == "_" then
			t[k] = nil
		end
	end
end
local function RK_SanitizeDescription(name, props, isLaxInput, doQueueUpgrade)
	local uprefix, colID, marks = type(props._u) == "string" and props._u, RK_CollectionIDs[name], {}
	local qd = doQueueUpgrade and queue[name]
	for i=#props,1,-1 do
		local v = props[i]
		repeat
			local idt = SLICE_ACTIONID_TYPE[type(v.id)]
			if idt then
				v[1], v[2], v.id = idt, v.id
			elseif v[1] == nil then
				table.remove(props, i)
				break
			end
			if type(v.c) == "string" then
				local r,g,b = v.c:match("^(%x%x)(%x%x)(%x%x)$")
				if r then
					v._r, v._g, v._b = tonumber(r, 16)/255, tonumber(g, 16)/255, tonumber(b, 16)/255
				end
			end
			v.show = v.show ~= "" and v.show or nil
			local sliceToken = v.sliceToken or uprefix and type(v._u) == "string" and (uprefix .. v._u) or v.sliceToken
			local tokenOK = marks[sliceToken] == nil and sliceToken and AB:ReserveToken(sliceToken, NS, name, colID)
			if not tokenOK then
				if not isLaxInput then
					-- Persistent, globally-unique slice tokens are required for rings created/persisted by external code
					local tokenDesc = type(sliceToken)
					if tokenDesc == "string" and sliceToken:match("^[%a%d]+$") then
						tokenDesc = tokenDesc .. ":" .. sliceToken
					end
					assert(false, string.format("desc[%d].sliceToken value is missing, invalid, or not [globally] unique (got %s)", i, tokenDesc), 4)
				end
				sliceToken = AB:CreateToken()
			end
			v.sliceToken, marks[sliceToken] = sliceToken, 1
		until 0
	end
	props._embed = nil
	BUP.UpgradeBundledRing(props, qd)
	return props
end
local function RK_SerializeDescription(props, bp)
	local stim, drop = bp and bp.v and props.v == bp.v and genSliceTokenIndexMap(bp)
	if stim then
		local present = genSliceTokenIndexMap(props)
		for tok, bidx in pairs(stim) do
			if not present[tok] then
				local alt = BUP.FindSliceWithAction(props, bp[bidx], stim)
				if alt then
					props[alt].sliceToken, present[tok] = tok, alt
				else
					drop = drop or {}
					drop[tok] = 1
				end
			end
		end
		if type(props.dropTokens) == "table" then
			for tok, c in pairs(props.dropTokens) do
				c = not (present[tok] or drop and drop[tok]) and (type(c) ~= "number" and 1 or c < 99 and c + 1)
				if c then
					drop = drop or {}
					drop[tok] = c
				end
			end
		end
	end
	for _, slice in ipairs(props) do
		if stim then
			local bs = props[stim[slice.sliceToken]]
			slice.vm = bs and securecall(BUP.DiffSlice, slice, bs) or nil
		end
		if slice[1] == "spell" or slice[1] == "imptext" then
			slice.id, slice[1], slice[2] = slice[2]
		end
		dropUnderscoreKeys(slice)
	end
	dropUnderscoreKeys(props)
	if stim then
		props.v, props.vm, props.dropTokens = bp.v, BUP.DiffRingMeta(props, bp) or nil, drop
	end
	props.sortScope = nil
	props.quarantineBind = nil -- DEPRECATED [2310/Z2]
	return props
end
local function resyncRings()
	for k in pairs(RK_RingDesc) do
		securecall(RK_SyncRing, k)
	end
end
EV.PLAYER_REGEN_DISABLED = resyncRings
local function unlockSync()
	if loadLock < 2 then
		loadLock = 2
		resyncRings()
	end
end
local function abPreOpen(_, _, id)
	local k = RK_CollectionIDs[id]
	if RK_RingDesc[k] then
		RK_SyncRing(k)
	end
end
local function svInitializer(event, _name, sv)
	if event == "LOGOUT" and loadLock > 0 then
		for k in pairs(sv) do sv[k] = nil end
		for k, v in pairs(RK_RingDesc) do
			if type(v) == "table" and not RK_DeletedRings[k] and v.save then
				sv[k] = RK_SerializeDescription(v, queue[k])
			end
		end
		for k,v in pairs(RK_DeletedRings) do
			RK_DeletedRings[k] = queue[k] and true or type(v) ~= "number" and 0 or (v < 99 and v + 1 or nil)
		end
		sv.OPieDeletedRings, sv.OPieFlagStore = next(RK_DeletedRings) and RK_DeletedRings, next(RK_FlagStore) and RK_FlagStore

	elseif event == "LOGIN" and loadLock == 0 then
		local name, realm, _ = UnitFullName("player")
		FULLNAME, FACTION, _, CLASS = name .. '-' .. realm, UnitFactionGroup("player"), UnitClass("player")

		local deleted, flags, mousemap = SV.OPieDeletedRings or RK_DeletedRings, SV.OPieFlagStore or RK_FlagStore
		mousemap, SV.OPieDeletedRings, SV.OPieFlagStore = {PRIMARY=PC:GetOption("PrimaryButton"), SECONDARY=PC:GetOption("SecondaryButton")}
		for k,v in pairs(flags) do RK_FlagStore[k] = v end
		
		local storageVersion = flags.StoreVersion or (flags.FlushedDefaultColors and 1) or 0
		storageVersion = type(storageVersion) == "number" and storageVersion or 0
		local onOpenFlush, updateZ3 = storageVersion < 2, storageVersion < 3
		RK_FlagStore.StoreVersion, RK_FlagStore.FlushedDefaultColors = 3, nil

		loadLock = 1
		EV.After(0, unlockSync)
		for k, v in pairs(queue) do
			if v.hotkey then v.hotkey = v.hotkey:gsub("[^-; ]+", mousemap) end
			if deleted[k] == nil and SV[k] == nil then
				securecall(RK_SetRingDesc, k, v, true)
				SV[k] = nil
			end
		end
		for k,v in pairs(deleted) do
			RK_DeletedRings[k] = v
		end
		for k, v in pairs(SV) do
			if type(v) == "table" then
				if onOpenFlush and v.onOpen ~= nil then
					v.quarantineOnOpen, v.onOpen = v.onOpen, nil
				end
				for i=1, updateZ3 and #v or 0 do
					updateSliceAction_Z3(v[i])
				end
			end
			securecall(RK_SetRingDesc, k, v, true, true)
		end

	elseif event == "POST-LOGIN" and loadLock == 1 then
		unlockSync()
		collectgarbage("collect")
	end
end
local function ringIterator(isDeleted, k)
	local nk, v = next(isDeleted and RK_DeletedRings or RK_RingDesc, k)
	if nk and RK_FluxRings[nk] then
		return ringIterator(isDeleted, nk)
	elseif nk then
		if isDeleted then
			v = queue[nk]
			if not RK_IsRelevantRingDescription(v) then
				return ringIterator(isDeleted, nk)
			end
		end
		return nk, v.name or nk, RK_CollectionIDs[nk] ~= nil, #v, v.internal, v.limit
	end
end
function RK_SetRingDesc(name, desc, isLaxInput, doQueueUpgrade)
	assert(type(name) == "string" and (type(desc) == "table" or desc == false))
	if loadLock == 0 then
		queue[name] = desc and RK_SanitizeDescription(name, copy(desc), isLaxInput)
	elseif desc then
		RK_RingDesc[name], RK_DeletedRings[name] = RK_SanitizeDescription(name, copy(desc), isLaxInput, doQueueUpgrade), nil
		RK_SyncRing(name, true)
	elseif RK_RingDesc[name] then
		PC:SetRing(name, nil)
		RK_DeletedRings[name], RK_RingDesc[name], SV[name] = queue[name] and true or nil
	end
end

-- Public API
function api:GetVersion()
	return MAJ, REV
end
function api:GenFreeRingName(base, reserved)
	assert(type(base) == "string" and (reserved == nil or type(reserved) == "table"), 'Syntax: name = RK:GenFreeRingName("base"[, reservedNamesTable])', 2)
	base = base:gsub("[^%a%d]", ""):sub(-10)
	if base:match("^OPie") or not base:match("^%a") then base = "x" .. base end
	local cname, c = base, 1
	while RK_RingDesc[cname] or queue[cname] or SV[cname] or (reserved and reserved[cname] ~= nil) or PC:IsKnownRingName(cname) do
		cname, c = base .. math.random(2^c), c < 30 and (c + 1) or c
	end
	return cname
end
function api:AddDefaultRing(name, desc)
	assert(type(name) == "string" and type(desc) == "table", 'Syntax: RK:AddDefaultRing("name", descTable)', 2)
	assert(loadLock == 0, 'AddDefaultRing: locked; call before PLAYER_LOGIN')
	assert(queue[name] == nil and RK_RingDesc[name] == nil, 'A ring with this name already exists', 2)
	RK_SetRingDesc(name, desc)
end
function api:SetExternalRing(name, desc)
	assert(type(name) == "string" and (type(desc) == "table" or desc == false), 'Syntax: RK:SetExternalRing("name", descTable or false)', 2)
	assert(queue[name] == nil and (RK_RingDesc[name] == nil or RK_FluxRings[name]), "A ring with this name already exists and cannot be modified", 2)
	RK_FluxRings[name] = true
	RK_SetRingDesc(name, desc)
end

-- HIDDEN, UNSUPPORTED METHODS: May vanish at any time.
local hum = {}
setmetatable(api, {__index=hum})
hum.HUM = hum
function hum:SetMountPreference(groundSpellID, airSpellID, dragonSpellID) -- DEPRECATED [2303/Y8]
	assert((type(groundSpellID) == "number" or not groundSpellID) and
	       (type(airSpellID) == "number" or not airSpellID) and
	       (type(dragonSpellID) == "number" or not dragonSpellID),
	       'Syntax: groundSpellID, airSpellID = RK:SetMountPreference(groundSpellID|false|nil, airSpellID|false|nil, dragonSpellID|false|nil)', 2)
	return IM:SetMountPreference(groundSpellID, airSpellID, dragonSpellID)
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
	RK_SetRingDesc(name, desc, true)
end
function private:GetRingSnapshot(name, bundleNested)
	assert(type(name) == "string", 'Syntax: snapshot = RK:GetRingSnapshot("name"[, bundleNested])', 2)
	if not RK_RingDesc[name] then return end
	local props = copy(RK_RingDesc[name])
	local q, m, haveMacroCache = {}, {}, false
	repeat
		local props = m[table.remove(q)] or props
		RK_SerializeDescription(props)
		props.limit = type(props.limit) == "string" and props.limit:match("[^A-Z]") and "PLAYER" or props.limit
		props.save, props.hotkey, props.v, props.vm, props.dropTokens = nil
		for i=1,#props do
			local v = props[i]
			local st = v[1]
			if st == nil and type(v.id) == "string" then
				v.id, haveMacroCache = IM:EncodeCommands(v.id, haveMacroCache), true
			elseif st == "ring" then
				local sn = v[2]
				if sn == name then
					m[name] = 0
				elseif bundleNested and RK_RingDesc[sn] and RK_RingDesc[sn].save and not m[sn] then
					q[#q+1], m[sn] = sn, copy(RK_RingDesc[sn])
				end
			end
			v.caption = nil -- DEPRECATED [2101/X4]
			v.sliceToken, v.vm = nil
		end
	until not q[1]
	props._scv, props._bundle = 1, next(m) ~= nil and m or nil
	return serialize(props)
end
function private:GetSnapshotRing(snap)
	assert(type(snap) == "string", 'Syntax: desc, bundle = RK:GetSnapshotRing("snapshot")', 2)
	if snap == "" then return end
	local ok, root = pcall(unserialize, snap)
	if not ok or type(root) ~= "table" then return end
	local scv = type(root._scv) == "number" and root._scv or 0
	if scv > 1 or scv < 0 then return end
	local preZ3 = scv < 1
	local q, bun, bs = {}, {}, type(root._bundle) == "table" and root._bundle or nil
	repeat
		local ri = bun[table.remove(q)] or root
		if type(ri.name) ~= "string" then return end
		for i=1,#ri do
			local v, st, sa = ri[i]
			if not v then return end
			st, sa = v[1], v[2]
			v.caption = nil -- DEPRECATED [2101/X4]
			if st == nil and type(v.id) == "string" then
				v.id = IM:DecodeCommands(v.id)
			elseif st == "ring" and bs and sa then
				local bd = bs[sa]
				if bd == 0 and not bun[sa] then
					bun[sa] = 0
				elseif type(bd) == "table" and not bun[sa] then
					bun[sa], q[#q+1] = bd, sa
				end
			end
			if preZ3 then
				updateSliceAction_Z3(v)
			end
			dropUnderscoreKeys(v)
		end
		ri.name = ri.name:gsub("|?|", "||")
		ri.quarantineBind, ri.hotkey = nil
		ri.quarantineOnOpen, ri.onOpen = ri.onOpen, nil
		ri.v, ri.vm, ri.dropTokens = nil
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
		return true
	end
end
function private:GetDefaultDescription(name)
	assert(type(name) == "string", 'Syntax: desc = RK:GetDefaultDescription("name")', 2)
	return queue[name] and copy(queue[name]) or false
end
function private:GetDeletedRings()
	return ringIterator, true, nil
end

function private:CanRestoreSlice(ring, slice)
	assert(type(ring) == "string" and type(slice) == "table", 'Syntax: canRestore = RK:CanRestoreSlice("ring", slice)')
	local bs = findSliceByToken(queue[ring], slice.sliceToken)
	local diff = bs and BUP.DiffSlice(slice, bs)
	return diff and diff ~= 3 or false, not not bs
end
function private:GetRestoredSlice(ring, slice)
	assert(type(ring) == "string" and type(slice) == "table", 'Syntax: slice? = RK:GetRestoredSlice("ring", slice)')
	local bs = findSliceByToken(queue[ring], slice.sliceToken)
	return bs and copy(bs) or nil
end

for k,v in pairs(api) do
	if private[k] == nil then
		private[k] = v
	end
end

SV, T.RingKeeper, OPie.CustomRings = PC:RegisterPVar("RingKeeper", SV, svInitializer), private, api
AB:AddObserver("internal.collection.preopen", abPreOpen)