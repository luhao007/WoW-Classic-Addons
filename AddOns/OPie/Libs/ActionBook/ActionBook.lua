local apiV, AB, MAJ, REV, ext, T = {}, {}, 2, 26, ...
if T.ActionBook then return end
apiV[MAJ], ext, T.Kindred, T.Rewire = AB, {Kindred=T.Kindred, Rewire=T.Rewire, ActionBook={}}

local function assert(condition, err, ...)
	return (not condition) and error(tostring(err):format(...), 3) or condition
end
local safequote do
	local r = {u="\\117", ["{"]="\\123", ["}"]="\\125"}
	function safequote(s)
		return (("%q"):format(s):gsub("[{}u]", r))
	end
end
local listToString do
	local function walk(p, n, a, ...)
		if n > 0 then
			local at, c = type(a), (p == "" and "" or ", ")
			if at == "string" then
				p = p .. c .. safequote(a)
			elseif at == "number" then
				p = p .. c .. ("%g"):format(a)
			else
				-- RE unpack does not accept start/finish indices, so replace nil/invalid values by a special table.
				p = p .. c .. (at == "boolean" and (a and "true" or "false") or "_NIL")
			end
			return walk(p, n-1, ...)
		end
		return p
	end
	function listToString(...)
		return walk('', select("#", ...), ...)
	end
end
local istore do
	local function write(t, n, i, a, b, ...) -- overwrites by up to 1 element
		if n > 0 then
			t[i], t[i+1] = a, b
			return write(t, n-2, i+2, ...)
		end
		return i+n-1
	end
	local base, api, inner = newproxy(true), {}, setmetatable({}, {__mode="k"}), {}
	function istore()
		local r, d = newproxy(base), {[0]=0}
		inner[r] = d
		return r
	end
	function api:reset()
		local h = inner[self]
		h[0] = 0, wipe(h)
	end
	function api:insert(...)
		local h, n = inner[self], select("#", ...)
		if n > 0 then
			local c = h[0]
			h[0], h[-c-1] = c+1, write(h, n, h[-c]+1, ...)
		end
	end
	function api:filter(func, farg)
		local h, c, ni, first = inner[self], 0, 0, 0
		for i=1, h[0] do
			local last = h[-i]
			if securecall(func, farg, unpack(h, first+1, last)) then
				c, h[-c-1] = c + 1, ni + last-first
				for j=1,last == h[-c] and 0 or (last-first) do
					h[ni+j] = h[first+j]
				end
				ni = h[-c]
			end
			first = last
		end
		h[0] = c
	end
	function api:size()
		return inner[self][0]
	end
	function api:get(i)
		local h = inner[self]
		if i > 0 and h[-i] then
			return unpack(h, (i == 1 and 0 or h[-i+1]) + 1, h[-i])
		end
	end
	local meta = getmetatable(base)
	meta.__index, meta.__len, meta.__call = api, api.size, api.get
end

local LW, L do
	local LT, LR = {}
	local function lookup(_, k)
		return LT[k] or k
	end
	LR, LW = newproxy(true), newproxy(true)
	local LM, LWM = getmetatable(LR), getmetatable(LW)
	LM.__index, LM.__call = lookup, lookup
	function LWM:__newindex(k, v)
		if type(k) ~= "string" or (v ~= nil and type(v) ~= "string") then
			error("Localization phrase invalid", 2)
		end
		LT[k] = v
	end
	ext.ActionBook.L = LR
end

local actionCallbacks, core, coreEnv = {}, CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate") do
	core:SetFrameRef("KR", ext.Kindred:compatible(1,0):seclib())
	for s in ("0123456789QWERTYUIOP"):gmatch(".") do
		local bni, bn = 1 repeat
			bn, bni = "AB!" .. bni .. s, bni + 1
		until GetClickFrame(bn) == nil
		core:WrapScript(CreateFrame("Button", bn, core, "SecureActionButtonTemplate"), "OnClick",
		[[-- AB:OnClick_Pre
			local t = actInfo[tonumber(button)]
			busy[self], idle[self] = t
			for i=3, 2+t[2], 2 do
				self:SetAttribute(t[i], t[i+1])
			end
			return nil, 1
		]], [[-- AB:OnClick_Post
			local t = busy[self]
			idle[self], busy[self] = self:GetName()
			for i=3, 2+t[2], 2 do
				self:SetAttribute(t[i], nil)
			end
		]])
	end
	core:Execute([=[-- AB_Init
		collections, tokens, metadata, actConditionals, tokConditionals = newtable(), newtable(), newtable(), newtable(), newtable()
		actInfo, busy, idle, _NIL, sidCastID = newtable(), newtable(), newtable(), newtable(), 30 + math.random(9)
		actInfo[sidCastID] = newtable("attribute", 6, "spell",nil, "unit",nil, "type","spell")
		for _, c in pairs(self:GetChildList(newtable())) do idle[c] = c:GetName() end
		KR, colStack, idxStack, ecStack, onStack, outCount = self:GetFrameRef("KR"), newtable(), newtable(), newtable(), newtable(), newtable()
	]=])
	coreEnv = GetManagedEnvironment(core)
end
core:SetAttribute("GetCollectionContent", [[-- AB:GetCollectionContent(slot)
	local i, ret, root, col, idx, aid, ecol = 1, "", tonumber((...)) or 0
	wipe(outCount) wipe(onStack)
	colStack[i], idxStack[i], ecStack[i] = root, 1, nil
	repeat
		col, idx, ecol = colStack[i], idxStack[i], ecStack[i]
		if idx == 1 and not outCount[col] then
			if outCount[col] == nil then
				self:CallMethod("notifyCollectionOpen", col)
			end
			if not ecol then
				onStack[col], outCount[col] = true, 0
			end
		end
		aid, idxStack[i] = collections[col][idx], idx + 1
		if aid then
			local tok = tokens[col][idx]
			local check1, check2 = actConditionals[aid], tokConditionals[tok]
			if (check1 == nil or (KR:RunAttribute("EvaluateCmdOptions", check1) or "hide") ~= "hide") and
			   (check2 == nil or (KR:RunAttribute("EvaluateCmdOptions", check2) or "hide") ~= "hide") then
				local isCollection = collections[aid]
				local tem = isCollection and metadata["tokEmbed-" .. tok]
				local isEmbed = isCollection and (tem == nil and metadata["embed-" .. aid] or tem)
				if isEmbed then
					local canEmbed = true
					for j=1, i-1 do
						if colStack[j] == aid then
							canEmbed = false
							break
						end
					end
					if canEmbed then
						i, colStack[i+1], idxStack[i+1], ecStack[i+1] = i + 1, aid, 1, ecol or col, ecol or col
					end
				elseif isCollection and not outCount[aid] then
					i, idxStack[i], colStack[i+1], idxStack[i+1], ecStack[i+1] = i + 1, idx, aid, 1, false
				elseif (outCount[aid] or 1) > 0 or onStack[aid] then
					local col = ecol or col
					local nid = outCount[col] + 1
					ret = ret .. "\n" .. col .. " " .. nid .. " " .. aid .. " " .. tok
					outCount[col] = nid
				end
			end
		else
			if not ecol then
				onStack[col] = nil
				local openAction = (i == 1 or (outCount[col] or 0) > 0) and metadata["openAction-" .. col]
				if openAction then
					ret = ret .. "\n" .. col .. " 0 " .. openAction .. " AOOA::" .. col
				end
			end
			i = i - 1
		end
	until i == 0
	return ret, metadata["openAction-" .. root] -- 2nd return is deprecated; use idx 0 actions in ret
]])
core:SetAttribute("UseAction", [[-- AB:UseAction(slot[, ...])
	local at = actInfo[...]
	if at == "icall" then
		return self:CallMethod("icall", ...) or ""
	elseif type(at) ~= "table" then
	elseif at[1] == "attribute" then
		local _, name = next(idle)
		return ("/click %s %d"):format(name, ...)
	elseif at[1] == "recall" then
		return at[2]:RunAttribute(select(3, unpack(at))) or ""
	end
	return ""
]])
core:SetAttribute("CastSpellByID", [[-- AB:CastSpellByID(sid[, "target"])
	local at = actInfo[sidCastID]
	at[4], at[6] = ...
	return self:RunAttribute("UseAction", sidCastID)
]])

function core:notifyCollectionOpen(id)
	AB:NotifyObservers("internal.collection.preopen", id)
end
function core:icall(id)
	local t = actionCallbacks[id]
	local ttype = type(t)
	if ttype == "table" then
		t[1](unpack(t,3,t[2]))
	elseif ttype == "function" then
		t()
	end
end
local DeferExecute do
	local q = {}
	function DeferExecute(block)
		if InCombatLockdown() then
			q[#q+1] = block
		elseif type(block) == "function" then
			securecall(block)
		else
			core:Execute(block)
		end
	end
	core:SetScript("OnEvent", function()
		for i=1,#q do
			q[i] = DeferExecute(q[i])
		end
	end)
	core:RegisterEvent("PLAYER_REGEN_ENABLED")
end

local actionCreators, actionDescribers, optData, optStart, optEnd, categories = {}, {}, {}, {}, {}, {}
local nextActionId, allocatedActions, allocatedActionType, allocatedActionArg = 42, {}, {}, {}

local createHandlers, updateHandlers = {}, {}
function createHandlers.attribute(id, cnt, ...)
	DeferExecute(("actInfo[%d] = newtable(%s)"):format(id, listToString("attribute", cnt, ...)))
	return true
end
function createHandlers.func(id, cnt, func, ...)
	if type(func) ~= "function" then
		return false, "Callback expected, got %s", type(func)
	end
	DeferExecute(("actInfo[%d] = 'icall'"):format(id))
	actionCallbacks[id] = cnt > 1 and {func, cnt+1, ...} or func
	return true
end
function createHandlers.recall(id, _count, handle, attr, ...)
	if type(handle) ~= "table" or type(attr) ~= "string" then
		return false, "Frame handle, attribute method expected; got %s/%s", type(handle), type(attr)
	elseif type(handle.IsProtected) ~= "function" or type(handle.GetAttribute) ~= "function" then
		return false, "Frame handle expected; got %s", type(handle)
	elseif not select(2, handle:IsProtected()) then
		return false, "Callback frame must be explicitly protected"
	elseif type(handle:GetAttribute(attr)) ~= "string" then
		return false, "Callback snippet expected in attribute %q, got %s", attr, type(handle:GetAttribute(attr))
	end
	local s = ("local t = newtable(%s)\n t[2] = self:GetFrameRef('recall-ref')\nactInfo[%d] = t"):format(listToString("recall", nil, attr, ...), id)
	DeferExecute(function()
		core:SetFrameRef('recall-ref', handle)
		core:Execute(s)
	end)
	return true
end
function updateHandlers.collection(id, _count, idList)
	if not (type(idList) == "table") then
		return false, "Expected table specifying collection actions, got %q", type(idList)
	elseif idList.__openAction and not allocatedActions[idList.__openAction] then
		return false, "Collection __openAction key does not specify a valid action"
	end
	local spec, tokens, visibility = "", "", ""
	for i=1,#idList do
		local tok = idList[i]
		local aid, vis, emb = idList[tok], idList['__visibility-' .. tok], idList['__embed-' .. tok]
		if type(tok) ~= "string" then
			return false, "Collection entry #%d: unsupported token type (%s)", i, type(tok)
		elseif not tok:match("^[A-Za-z][A-Za-z0-9_=/]*$") then
			return false, "Collection entry #%d: invalid token format (%s)", i, tok
		elseif allocatedActions[aid] == nil then
			return false, "Collection entry #%d: unallocated action id", i, tostring(idList[i])
		elseif vis ~= nil and type(vis) ~= "string" then
			return false, "Collection entry #%d: unsupported visibility conditional type (%s)", i, type(vis)
		elseif emb ~= nil and type(emb) ~= "boolean" then
			return false, "Collection entry #%d: unsupported embed flag type (%s)", i, type(emb)
		end
		vis = vis and safequote(vis) or "nil"
		emb = emb == nil and "nil" or tostring(emb)
		spec, tokens, visibility = spec .. idList[tok] .. ", ", tokens .. safequote(tok) .. ", ", ('%s\ntk = %s; tokConditionals[tk], metadata["tokEmbed-" .. tk] = %s, %s'):format(visibility, safequote(tok), vis, emb)
	end
	local openAction = type(idList.__openAction) == "number" and idList.__openAction or "nil"
	local embed = type(idList.__embed) == "boolean" and tostring(idList.__embed) or "nil"
	DeferExecute(("local id, tk = %d; collections[id], tokens[id], metadata['openAction-' .. id], metadata['embed-' .. id] = newtable(%s nil), newtable(%s nil), %s, %s; %s")
		:format(id, spec, tokens, openAction, embed, visibility))
	return true
end
function createHandlers.clone(id, _count, id2)
	DeferExecute(("local d,s = %d, %d; actInfo[d], actConditionals[d] = actInfo[s], actConditionals[s]"):format(id, id2))
	return true
end
local function nullInfoFunc() return false end

local getActionIdent, getActionArgs do
	function getActionIdent(identTable)
		local itt = type(identTable)
		if itt == "string" then
			return identTable, nil
		elseif itt == "table" and type(identTable[1]) == "string" then
			return identTable[1], identTable
		end
	end
	local function index(t, a, ...)
		if a then
			return t[a], index(t, ...)
		end
	end
	local function unfold(t, i)
		if t[i] then
			return t[i], unfold(t, i+1)
		elseif optStart[t[1]] and optEnd[t[1]] then
			return index(t, unpack(optData, optStart[t[1]], optEnd[t[1]]))
		end
	end
	function getActionArgs(it, ...)
		if it then
			return unfold(it, 1)
		end
		return ...
	end
end
local categoryAliases = {}
local function getCategoryName(id)
	local LM = id == (#categories+1) and L"Miscellaneous"
	return categories[id] or (LM and categories[LM] and LM) or nil
end
local function getCategoryTable(name)
	name = categoryAliases[name] or name
	local r = categories[name]
	if not r then
		r = {}
		categories[name] = r
		if name ~= L"Miscellaneous" then
			categories[#categories + 1] = name
		end
	end
	return r
end

local editorPanels = {}

do -- AB:CreateToken()
	local seq, dict, dictLength, prefix = 262143, "qwer1tyui2opas3dfgh4jklz5xcvb6nmQWE7RTYU8IOPA9SDFG0HJKL=ZXCV/BNM", 64
	local function encode(n)
		local ret, d = ""
		repeat
			d = n % dictLength
			ret, n = dict:sub(d+1, d+1) .. ret, (n - d) / dictLength
		until n == 0
		return ret
	end
	function AB:CreateToken()
		if seq > 262142 then
			prefix, seq = "ABu" .. encode(time()*100+(math.floor(GetTime()%1*100)%100)), 0
		end
		seq = seq + 1
		return prefix .. encode(seq)
	end
end

function AB:GetActionSlot(actionType, ...)
	local ident, at = getActionIdent(actionType)
	local id = actionCreators[ident] and actionCreators[ident](getActionArgs(at, ...))
	if allocatedActions[id] then
		return id
	end
	assert(ident, 'Syntax: actionId = ActionBook:GetActionSlot(actionTable or "actionType", ...)')
end
function AB:GetActionDescription(actionType, ...)
	local ident, at = getActionIdent(actionType)
	if actionDescribers[ident] then
		return actionDescribers[ident](getActionArgs(at, ...))
	end
	assert(ident, 'Syntax: typeName, actionName, icon, ext, tipFunc, tipArg, actionType = ActionBook:GetActionDescription(actionTable or "actionType", ...)')
end
function AB:GetActionOptions(actionType)
	-- DEPRECATED: Named action options will be going away; use the array portion + :RegisterEditorPanel
	assert(type(actionType) == "string", 'Syntax: ... = ActionBook:GetActionOptions("actionType")')
	return unpack(optData, optStart[actionType] or 0, optEnd[actionType] or -1)
end
function AB:GetSlotInfo(id, modLock)
	assert(type(id) == "number" and (modLock == nil or type(modLock) == "string"), 'Syntax: usable, state, icon, caption, count, cdLeft, cdLength, tipFunc, tipArg, ext = ActionBook:GetSlotInfo(slot[, "modLockState"])')
	if allocatedActions[id] then
		return allocatedActions[id](allocatedActionArg[id], modLock)
	end
end
function AB:GetSlotImplementation(id)
	assert(type(id) == "number", "Syntax: actionType, colEntryCount, colEmbedDefault = ActionBook:GetSlotImplementation(slot)")
	local aType = allocatedActions[id] and allocatedActionType[id]
	local colData = coreEnv.collections[id]
	return aType, colData and #colData or nil, colData and coreEnv.metadata['embed-' .. id]
end

function AB:RegisterActionType(actionType, create, describe, opt)
	assert(type(actionType) == "string" and type(create) == "function" and type(describe) == "function" and (opt == nil or type(opt) == "table"), 'Syntax: ActionBook:RegisterActionType("actionType", createFunc, describeFunc[, {options}])')
	assert(not actionCreators[actionType], "Identifier %q is already registered", actionType)
	actionCreators[actionType], actionDescribers[actionType] = create, describe
	if opt and #opt > 0 then
		local ok
		for i=0,#optData-1 do ok = i for j=1,#opt do if opt[j] ~= optData[i+j] then ok = nil break end end if ok then break end end
		if not ok then ok = #optData for i=1,#opt do optData[ok+i] = opt[i] end end
		optStart[actionType], optEnd[actionType] = ok+1, ok + #opt
	end
end
function AB:CreateActionSlot(infoFunc, infoArg, implType, ...)
	local as, an = 1, select("#", ...)
	local cnd if implType == "conditional" then
		as, an, cnd, implType = as + 2, an - 2, select(as, ...)
		assert(type(cnd) == "string" and type(implType) == "string", "Conditional option/implementation type expected, got %s/%s", type(cnd), type(implType))
	end
	assert(type(implType) == "string" and (infoFunc == nil or type(infoFunc) == "function"), 'Syntax: slot = ActionBook:CreateAction(infoFunc, infoArg, "implType", ...)')
	local cf, id = assert(createHandlers[implType] or updateHandlers[implType], "Implementation type %q is not creatable", implType), nextActionId
	nextActionId, allocatedActionType[id], allocatedActionArg[id] = id + 1, implType, infoArg
	assert(cf(id, an, select(as, ...)))
	allocatedActions[id] = infoFunc or nullInfoFunc
	if cnd then DeferExecute(("actConditionals[%d] = %s"):format(id, safequote(cnd))) end
	return id
end
function AB:UpdateActionSlot(id, ...)
	assert(type(id) == "number", "Syntax: ActionBook:UpdateActionSlot(actionId, ...)")
	assert(allocatedActions[id] and allocatedActionType[id], "Action %d does not exist", id)
	assert(updateHandlers[allocatedActionType[id]], "Action type %q is not updatable", allocatedActionType[id])
	assert(updateHandlers[allocatedActionType[id]](id, select("#", ...), ...))
end

function AB:AddCategoryAlias(name, aliasOf)
	assert(type(name) == "string" and type(aliasOf) == "string", 'Syntax: ActionBook:AddCategoryAlias("name", "aliasOf")')
	assert(name == aliasOf or categories[name] == nil, "Category %q already exists.", name)
	categoryAliases[name] = categoryAliases[name] or aliasOf
end
function AB:AugmentCategory(name, augFunc)
	assert(type(name) == "string" and type(augFunc) == "function" and name ~= "*", 'Syntax: ActionBook:AugmentCategory("name", augFunc)')
	table.insert(getCategoryTable(name), augFunc)
end
function AB:AddActionToCategory(name, actionType, ...)
	assert(type(name) == "string" and type(actionType) == "string" and name ~= "*", 'Syntax: ActionBook:AddActionToCategory("name", "actionType"[, ...])')
	local ct = getCategoryTable(name)
	ct.extra = ct.extra or istore()
	ct.extra:insert(actionType, ...)
end
function AB:GetNumCategories()
	return #categories + (categories[L"Miscellaneous"] and 1 or 0)
end
function AB:GetCategoryInfo(id)
	assert(type(id) == "number", 'Syntax: name = ActionBook:GetCategoryInfo(index)')
	return getCategoryName(id)
end
function AB:GetCategoryContents(id, into)
	assert(type(id) == "number", 'Syntax: contents = ActionBook:GetCategoryContents(index[, into])')
	local cname, ret = assert(getCategoryName(id), 'Invalid category index'), into or istore()
	local co = categories[cname]
	local ex, addToRet = co.extra, #co > 0 and function(...) return ret:insert(...) end
	for i=1,#co do
		securecall(co[i], cname, addToRet)
	end
	for i=1,ex and #ex or 0 do
		ret:insert(ex(i))
	end
	return ret
end

local notifyCount, observers = 1, {["*"]={}, ["internal.collection.preopen"] = {}}
function AB:NotifyObservers(ident, data)
	assert(type(ident) == "string", 'Syntax: ActionBook:NotifyObservers("identifier"[, data])')
	assert(actionCreators[ident] or observers[ident] ~= nil, "Identifier %q is not registered", ident)
	notifyCount = (notifyCount + 1) % 4503599627370495
	for i=ident == "*" or not observers[ident] and 1 or 2, 1, -1 do
		for k,v in pairs(observers[i == 1 and "*" or ident]) do
			securecall(k, v, ident, data)
		end
	end
end
function AB:AddObserver(ident, callback, selfarg)
	assert(type(ident) == "string" and type(callback) == "function", 'Syntax: ActionBook:AddObserver("identifier", callbackFunc, callbackSelfArg)')
	assert(ident == "*" or actionCreators[ident] or observers[ident], "Identifier %q is not registered", ident)
	if observers[ident] == nil then observers[ident] = {} end
	observers[ident][callback] = selfarg == nil and true or selfarg
end
function AB:GetLastObserverUpdateToken(ident)
	assert(type(ident) == "string", 'Syntax: token = ActionBook:GetLastObserverUpdateToken("identifier")')
	assert(ident == "*" or actionCreators[ident], "Identifier %q is not registered", ident)
	return notifyCount
end

function AB:RegisterEditorPanel(actionType, editorPanel)
	assert(type(actionType) == "string" and type(editorPanel) == "table", 'Syntax: ActionBook:RegisterEditorPanel("actionType", editorPanel)')
	assert(actionCreators[actionType] ~= nil, "actionType %q is not registered", actionType)
	assert(editorPanels[actionType] == nil, "An editor for %q is already registered", actionType)
	assert(
		type(editorPanel.SetAction) == "function" and
		type(editorPanel.GetAction) == "function" and
		type(editorPanel.IsOwned) == "function" and
		type(editorPanel.Release) == "function",
	"Required editor panel API methods not implemented")
	editorPanels[actionType] = editorPanel
end
function AB:GetEditorPanel(actionType)
	return editorPanels[actionType]
end

function AB:seclib()
	return core
end
function AB:compatible(module, maj, rev, ...)
	if ext[module] then
		return ext[module]:compatible(maj, rev, ...)
	elseif type(module) == "number" and type(maj) == "number" and rev == nil then
		maj, rev = module, maj -- Oh hey, it's us!
		if maj == 1 then securecall(error, "ActionBook v1 API is deprecated.", 3) end
		return rev <= REV and apiV[maj], MAJ, REV
	end
end

function AB:locale(getWritableHandle)
	if getWritableHandle then
		local r = LW
		LW = nil
		return assert(r, "A writable locale handle has already been returned")
	end
	return L
end

apiV[1] = {uniq=AB.CreateToken, get=AB.GetActionSlot, describe=AB.GetActionDescription, info=AB.GetSlotInfo, options=AB.GetActionOptions, actionType=AB.GetSlotImplementation,
	register=AB.RegisterActionType, update=AB.UpdateActionSlot, notify=AB.NotifyObservers, observe=AB.AddObserver, lastupdate=AB.GetLastObserverUpdateToken, compatible=AB.compatible} do
	apiV[1].miscaction = function(_self, ...) return AB:AddActionToCategory(L"Miscellaneous", ...) end
	apiV[1].category = function(_self, name, numFunc, getFunc)
		assert(type(name) == "string" and type(numFunc) == "function" and type(getFunc) == "function", 'Syntax: ActionBook:category("name", countFunc, entryFunc)')
		local count = numFunc()
		assert(type(count) == "number" and count >= 0, "countFunc() must return a non-negative integer")
		return AB:AugmentCategory(name, function(_, add)
			for i=1, numFunc() do
				add(getFunc(i))
			end
		end)
	end
	local proxy = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
	proxy:SetFrameRef("core", core)
	proxy:Execute("core = self:GetFrameRef('core'), self:SetAttribute('frameref-core', nil)")
	proxy:SetAttribute("collection", "return core:RunAttribute('GetCollectionContent', ...)")
	proxy:SetAttribute("triggerMacro", "return core:RunAttribute('UseAction', ...)")
	apiV[1].seclib = function() return proxy end
	apiV[1].create = function(_self, atype, hint, ...)
		assert(type(atype) == "string" and (hint == nil or type(hint) == "function"), 'Syntax: id = ActionBook:create("actionType", hintFunc, ...)')
		return AB:CreateActionSlot(hint, nextActionId, atype, ...)
	end
end

T.ActionBook, ext.ActionBook.compatible = ext.ActionBook, AB.compatible
L = T.ActionBook.L -- TODO: Remove this when write tracing works