local KR, MAJ, REV, execQueue, _, T = {}, 1, 16, {}, ...
if T.ActionBook then return end

local function assert(condition, err, ...)
	return (not condition) and error(tostring(err):format(...), 3) or condition
end
local safequote do
	local r = {u="\\117", ["{"]="\\123", ["}"]="\\125"}
	function safequote(s)
		return (("%q"):format(s):gsub("[{}u]", r))
	end
end

local core = CreateFrame("Frame", nil, nil, "SecureHandlerStateTemplate") do
	core:SetFrameRef("sandbox", CreateFrame("Frame", nil, nil, "SecureFrameTemplate"))
	local bindProxy = CreateFrame("Frame", nil, nil, "SecureFrameTemplate")
	core:SetFrameRef("bindProxy", bindProxy)
	core:WrapScript(bindProxy, "OnAttributeChanged", [=[--Kindred_Bind_OnAttributeChanged
		local key = name:match("^state%-(bind%d+)$")
		if not bindingDrivers[key] then return end
		owner:Run(BindingLink_Move, key, true, value and rtgsub(value, "[^%-]+$", bindEscapeMap))
	]=])
end
core:Execute([==[-- Kindred.Init
	pcache, nextDriverKey, sandbox, modStateMap = newtable(), 4200, self:GetFrameRef("sandbox"), newtable()
	cndType, cndState, cndDrivers, cndAlias, unitAlias, stateDrivers = newtable(), newtable(), newtable(), newtable(), newtable(), newtable()
	modStateMap.A, modStateMap.a, modStateMap.S, modStateMap.s, modStateMap.C, modStateMap.c, modStateMap.M, modStateMap.m = true, false, true, false, true, false, true, false
	btnState, isInLockdown, cndInsecure = newtable(), false, newtable()
	bindingDrivers, bindingKeys, nextBindingKey, bindProxy, bindEscapeMap = newtable(), newtable(), 42000, self:GetFrameRef("bindProxy"), newtable()
	bindEscapeMap.SEMICOLON, bindEscapeMap.OPEN, bindEscapeMap.CLOSE = ";", "[", "]"

	OptionParse = [=[-- Kindred_OptionParse
		local ret, conditional = newtable(), ...
		local no, ns, lp = conditional:gmatch("()%["), conditional:gmatch("();"), #conditional + 1
		local po, lc, cur, pc, ps = no() or lp, 0
		repeat
			ps, cur = ns() or lp, newtable()
			while po < ps do
				pc = conditional:match("()%]", po)
				if pc then
					local clause, ct = conditional:sub(po+1, pc-1):lower(), newtable()
					for m in clause:gmatch("[^,%s][^,]*") do
						m = m:match("^%s*(.-)%s*$")
						if m:sub(1,1) == "@" or m:sub(1,7) == "target=" then
							local bu, suf = m:match("[=@]%s*([^-%d]*%d*)(.-)%s*$")
							ct.target, ct.targetS = bu, suf ~= "" and suf or nil
						else
							local cvalparsed, mark, wname, inv, name, col, cval = nil, m:match("^([+]?)((n?o?)([^:=]*))([:=]?)(.-)%s*$")
							if inv ~= "no" then inv, name = "", wname end
							cval, name = col == ":" and cval and ("/" .. cval .. "/"):gsub("%s*/%s*", "/"):sub(2,-2) or nil, col == ":" and name or (name .. col .. cval)
							if cval and cval ~= "" then
								cvalparsed = newtable()
								for s in cval:gmatch("[^/]+") do
									local int = (name == "form" or name == "stance") and s:match("^%-?%s*%d+")
									if int then
										if int+0 < 1 then
											cvalparsed[0], s = true, nil
										else
											s = int
										end
									end
									cvalparsed[#cvalparsed+1] = s
								end
							end
							cct = newtable(name, cvalparsed, inv ~= "no", mark, cval)
							ct[#ct+1], cct[0] = cct, m
						end
					end
					cur[#cur+1], lc, po = ct, pc, no() or lp
				else
					break
				end
			end
			cur[1], cur.v = cur[1] or newtable(), conditional:sub(lc+1, ps-1):match("^%s*(.-)%s*$")
			ret[#ret + 1], lc = cur, ps
		until ps == lp
		pcache[conditional] = ret
	]=]
	OptionConstruct = [=[-- Kindred_OptionConstruct
		local cond, modState, skipChunks = ...
		local cond, out, msI, msA, msS, msC, msM = pcache[cond] or owner:Run(OptionParse, cond) or pcache[cond]
		local getNextSkip = type(skipChunks) == "string" and skipChunks:gmatch("()s")
		local skipNext = getNextSkip and getNextSkip()
		for i=1,#cond do
			local chunk, cparse, isTautology, skipThis = cond[i], "", false, i == skipNext
			skipNext = skipThis and getNextSkip() or skipNext
			for i=1,skipThis and 0 or #chunk do
				local target, ts, conditional, cnext = chunk[i].target, chunk[i].targetS, "", ""
				while unitAlias[target] do target = unitAlias[target] end
				target = ts and target and target .. ts or target
				for j=1,#chunk[i] do
					local c = chunk[i][j]
					local name, argp, goal, flag = c[1], c[2], c[3], c[4]
					if goal == false and (cndType[name] == nil and cndType["no" .. name]) then goal, name = true, "no" .. name end
					if cndAlias[name] then name = cndAlias[name] end
					if name == "mod" and modState then
						if not msI then
							local a,s,c,m = modState:match("(.)(.)(.)(.?)")
							msI, msA, msS, msC, msM = 1, modStateMap[a], modStateMap[s], modStateMap[c], modStateMap[m]
						end
						local argu, all = c[5], argp == nil
						local wA, wS, wC, wM = all or argu:match("alt"), all or argu:match("shift"), all or argu:match("ctrl"), all or argu:match("meta")
						if (wA and msA) or (wS and msS) or (wC and msC) or (wM and msM) then
							if not goal then
								conditional = nil
								break
							end
						else
							local par, pn = goal and "mod:" or "nomod:", ""
							if wA and msA ~= false then par, pn = par .. pn .. "alt", "/" end
							if wS and msS ~= false then par, pn = par .. pn .. "shift", "/" end
							if wC and msC ~= false then par, pn = par .. pn .. "ctrl", "/" end
							if wM and msM ~= false then par, pn = par .. pn .. "meta", "/" end
							if pn == "" and goal then
								conditional = nil
								break
							elseif pn ~= "" then
								conditional, cnext = conditional .. cnext .. par, ","
							end
						end
					elseif cndType[name] == nil then
						conditional, cnext = conditional .. cnext .. c[0], ","
					else
						local cres, ctype = false, cndType[name]
						if ctype == "state" then
							local cs, cval = cndState[name]
							if argp == nil then
								cval = cs and cs["*"] or false
							else
								for k=1,cs and #argp or 0 do
									if cs[argp[k]] then
										cval = true
										break
									end
								end
								cval = cval or (argp[0] and not (cs and cs["*"]))
							end
							cres = (not not cval) == goal
						elseif ctype == "gt" then
							local cs, cval = cndState[name]
							if argp == nil then
								cval = not not cs
							elseif cs then
								for k=1,#argp do
									local n = tonumber(argp[k])
									if n and n <= cs then
										cval = true
										break
									end
								end
							end
							cres = (not not cval) == goal
						elseif ctype == "srun" then
							local s = cndState[name]
							if type(s) == "string" then
								cres = sandbox:Run(s, c[5], target, c[4])
							elseif _shadowES and _shadowES[name] then
								cres = _shadowES[name](name, c[5], target, c[4])
							elseif s then
								cres = s:RunAttribute("EvaluateMacroConditional", name, c[5], target, c[4])
							end
							cres = (not not cres) == goal
						elseif ctype == "irun" then
							local markType = c[4]
							if isInLockdown then
								cres = markType == "+"
							elseif _shadowES and _shadowES[name] then
								cres = (not not _shadowES[name](name, c[5], target, markType)) == goal
							else
								self:CallMethod("irun", name, c[5], target, markType)
								cres = (not not self:GetAttribute("irun-result")) == goal
							end
						end
						if not cres then
							conditional = nil
							break
						end
					end
				end
				if conditional then
					if target then conditional = "@" .. target .. cnext .. conditional end
					cparse = cparse .. "[" .. conditional .. "]"
					if cnext == "" then
						isTautology = true
						break
					end
				end
			end
			if cparse ~= "" then
				out = (out and (out .. ";") or "") .. cparse .. chunk.v
				if isTautology then break end
			end
		end
		out = out or "[form:42]"
		return out
	]=]
	RefreshDrivers = [=[-- Kindred_RefreshDrivers
		local name = ...
		if cndDrivers[name] then
			for key, info in pairs(cndDrivers[name]) do
				local nv = owner:Run(OptionConstruct, info[3])
				if info[5] ~= nv then
					info[5] = nv
					RegisterStateDriver(info[1], info[2], nv)
				end
			end
		end
	]=]
	BindingLink_Move = [=[-- Kindred_BindingLink_Move
		local key, doInsert, newValue = ...
		local link = bindingDrivers[key]
		if not link then return end
		local up, down, value = link.up, link.down, link.value
		if up then
			up.down, link.up = down
		end
		if down then
			down.up, link.down = up
		end
		if value and not up then
			bindingKeys[value] = down
			if down then
				bindProxy:SetBindingClick(down.priority > 0, value, down.target, down.button)
				if down.notify then
					down.notify:SetAttribute('binding-' .. down.button, value)
				end
			else
				bindProxy:ClearBinding(value)
			end
		end
		if doInsert then
			newValue = (newValue or "") ~= "" and newValue or ""
			link.value = newValue
			if newValue then
				local down, up = bindingKeys[newValue]
				while down and down.priority > link.priority do
					down, up = down.down, down
				end
				link.down, link.up = down, up
				if down then
					down.up = link
				end
				if up then
					up.down = link
				else
					bindingKeys[newValue], link.down = link, down
					bindProxy:SetBindingClick(link.priority > 0, newValue, link.target, link.button)
				end
				if down and down.notify and not up then
					down.notify:SetAttribute('binding-' .. down.button, nil)
				end
			end
		end
		if link.notify then
			link.notify:SetAttribute('binding-' .. link.button, doInsert and not link.up and newValue or nil)
		end
	]=]
]==])
core:SetAttribute("RegisterStateDriver", [=[-- Kindred:RegisterStateDriver(*frame*, "state", "options")
	local frame = owner:GetFrameRef("RegisterStateDriver-frame")
	owner:SetAttribute("frameref-RegisterStateDriver-frame", nil)
	if frame == nil then return owner:CallMethod("throw", 'Set the "RegisterStateDriver-frame" frameref before calling RegisterStateDriver.') end
	local drivers, state, values = stateDrivers[frame], ...
	local old = drivers and drivers[state]
	if old then
		drivers[state] = nil
		RegisterStateDriver(frame, state, "")
		for _, t in pairs(cndDrivers) do
			t[old[4]] = nil
		end
	end
	if values and type(state) == "string" and values ~= "" then
		local info, key
		drivers, info, key = drivers or newtable(), newtable(frame, state, values, nextDriverKey), nextDriverKey
		stateDrivers[frame], drivers[state], nextDriverKey = drivers, info, nextDriverKey + 1
		local parse, cv = pcache[values] or owner:Run(OptionParse, values) or pcache[values], owner:Run(OptionConstruct, values)
		info[5] = cv
		RegisterStateDriver(frame, state, cv)
		for i=1,#parse do
			for j=1,#parse[i] do
				local clause = parse[i][j]
				for k=1,#clause do
					local n = clause[k][1]
					cndDrivers[n] = cndDrivers[n] or newtable()
					cndDrivers[n][key] = info
				end
				local u = clause.target while u do
					local n = "unit:" .. u
					cndDrivers[n] = cndDrivers[n] or newtable()
					cndDrivers[n][key], u = info, unitAlias[u]
				end
			end
		end
	end
]=])
core:SetAttribute("EvaluateCmdOptions", [=[-- Kindred:EvaluateCmdOptions("options")
	return SecureCmdOptionParse(owner:Run(OptionConstruct, ...))
]=])
core:SetAttribute("UpdateThresholdConditional", [=[-- Kindred:UpdateThresholdConditional("name", value or false)
	local name, new = ...
	if type(name) ~= "string" or (new ~= false and type(new) ~= "number") then
		return owner:CallMethod("throw", 'Syntax: ("UpdateThresholdConditional", "name", value or false)')
	end
	local ch = cndDrivers[name] and (cndType[name] ~= "gt" or cndState[name] ~= new)
	cndType[name], cndState[name] = "gt", new
	if ch then
		owner:Run(RefreshDrivers, name)
	end
]=])
core:SetAttribute("UpdateStateConditional", [=[-- Kindred:UpdateStateConditional("name", "addSet", "remSet")
	local name, new, kill = ...
	local cs = cndState[name] or newtable()
	cndType[name], cndState[name] = "state", cs
	if kill == "*" then
		wipe(cs)
	else
		for s in (kill and tostring(kill) or ""):lower():gmatch("[^/]+") do
			cs[s] = nil
		end
		cs["*"] = nil
	end
	for s in (new and tostring(new) or ""):lower():gmatch("[^/]+") do
		cs[s] = 1
	end
	cs["*"] = next(cs) and 2 or nil
	if cndDrivers[name] then
		owner:Run(RefreshDrivers, name)
	end
]=])
core:SetAttribute("SetAliasUnit", [=[-- Kindred:SetAliasUnit("alias", "unit" or nil)
	local alias, unit = ...
	if unitAlias[alias] == unit then
		return
	elseif not (type(alias) == "string" and (type(unit) == "string" or unit == nil)) then
		return owner:CallMethod("throw", 'Syntax: ("SetAliasUnit", "alias", "unit" or nil)')
	end
	local u = unit while unitAlias[u] and u ~= alias do u = unitAlias[u] end
	if u == alias then
		return owner:CallMethod("throw", ('Kindred:SetUnitAlias: would create a loop aliasing to %q'):format(alias))
	end
	unitAlias[alias] = unit
	owner:Run(RefreshDrivers, "unit:" .. alias)
]=])
core:SetAttribute("ResolveUnitAlias", [=[-- Kindred:ResolveUnitAlias("unit")
	local unit = ...
	if type(unit) ~= "string" then
		return owner:CallMethod("throw", 'Syntax: ("ResolveUnitAlias", "unit")')
	end
	local ua = unitAlias[unit]
	if ua == nil then
		local w, base, suf = unit:match("^%s*(([^-%d]*%d*)(.-))%s*$")
		ua = unitAlias[base]
		ua = ua and (ua .. suf) or unitAlias[w]
	end
	return ua or unit
]=])
core:SetAttribute("PokeConditional", [=[-- Kindred:PokeConditional("name")
	owner:Run(RefreshDrivers, (...))
]=])
core:SetAttribute("SetButtonState", [=[-- Kindred:SetButtonState("buttonid" or false or nil)
	local ostate, nstate = cndState.btn == btnState and btnState["*"], ...
	if nstate == false then
		cndType.btn, cndState.btn, btnState[ostate or 0] = nil
	else
		if ostate then
			btnState[ostate] = nil
		end
		if nstate then
			nstate = nstate .. ""
			btnState[nstate] = true
		end
		cndType.btn, cndState.btn, btnState["*"] = "state", btnState, nstate
	end
	return ostate
]=])
core:SetAttribute("RegisterBindingDriver", [=[-- Kindred:RegisterBindingDriver(*target*, "button", "options", priority[, *notify*])
	local target, notify, button, options, priority = self:GetFrameRef("RegisterBindingDriver-target"), self:GetFrameRef("RegisterBindingDriver-notify"), ...
	self:SetAttribute("frameref-RegisterStateDriver-target", nil)
	self:SetAttribute("frameref-RegisterStateDriver-notify", nil)
	if not target then return owner:CallMethod("throw", 'Set the "RegisterStateDriver-target" frameref before calling RegisterStateDriver.') end
	bindingDrivers[target] = bindingDrivers[target] or newtable()
	local driver = bindingDrivers[target][button] or newtable()
	if driver.id then
		bindProxy:SetAttribute("state-" .. driver.id, nil)
	else
		nextBindingKey, driver.id, driver.target, driver.button = nextBindingKey + 1, 'bind' .. nextBindingKey, target, button
		bindingDrivers[target][button], bindingDrivers[driver.id] = driver, driver
	end
	driver.priority, driver.notify = priority, notify
	self:SetAttribute("frameref-RegisterStateDriver-frame", bindProxy)
	self:RunAttribute("RegisterStateDriver", driver.id, options)
]=])
core:SetAttribute("UnregisterBindingDriver", [=[-- Kindred:UnregisterBindingDriver(*target*, "button")
	local target, button = self:GetFrameRef("UnregisterBindingDriver-target"), ...
	self:SetAttribute("frameref-UnregisterBindingDriver-target", nil)
	if not target then return owner:CallMethod("throw", 'Set the "UnregisterBindingDriver-target" frameref before calling UnregisterBindingDriver.') end
	local drivers = bindingDrivers[target]
	local driver = drivers and drivers[button]
	if driver then
		bindProxy:SetAttribute("state-" .. driver.id, nil)
		self:SetAttribute("frameref-RegisterStateDriver-frame", bindProxy)
		self:RunAttribute("RegisterStateDriver", driver.id, "")
		drivers[button], bindingDrivers[driver.id] = nil
		if not next(drivers) then
			bindingDrivers[target] = nil
		end
	end
]=])
core:SetAttribute("_onstate-lockdown", [[-- Kindred:SyncLockdown
	if newstate then
		isInLockdown = newstate == "on"
		self:SetAttribute("state-lockdown", nil)
	elseif not isInLockdown then
		for k in pairs(cndInsecure) do
			if cndType[k] ~= "irun" then
				cndInsecure[k] = nil
			elseif cndDrivers[k] then
				owner:Run(RefreshDrivers, k)
			end
		end
	end
]])
RegisterStateDriver(core, "lockdown", "[combat] on; off")
function core:throw(text)
	error(text)
end
function core:DeferExecute(snippet, key)
	if InCombatLockdown() then
		execQueue[key] = snippet
	elseif type(snippet) == "function" then
		snippet()
	else
		self:Execute(snippet)
	end
end
core:RegisterEvent("PLAYER_REGEN_ENABLED")
core:SetScript("OnEvent", function(self)
	for k,v in pairs(execQueue) do
		securecall(self.DeferExecute, self, v)
		execQueue[k] = nil
	end
end)

local EvaluateCmdOptions, SetExternalShadow do
	local ShadowEnvironment do
		local fcache, _R, _ENV = {}, {next=rtable.next, pairs=rtable.pairs, newtable=function(...) return {...} end}, {}
		local _shadow = {__index=function(t,k)
			local v = _ENV[t] and _ENV[t][k]
			if v == nil then
				v = _R[k] or _G[k]
			elseif type(v) == "userdata" then
				v = IsFrameHandle(v) and ShadowEnvironment(GetFrameHandleFrame(v)) or setmetatable({}, {__index=v})
				t[k] = v
			end
			return v
		end}
		local function ShadowRun(self, f, ...)
			local v = fcache[f] or loadstring(("-- %s\nreturn function(self, ...)\n%s\nend"):format(tostring(f):match("^[%s%-]*([^\n]*)"), f))()
			fcache[f] = setfenv(v, _ENV[self])
			return securecall(v, self, ...)
		end
		function ShadowEnvironment(h)
			local e = _ENV[h] or setmetatable({owner={Run=ShadowRun}}, _shadow)
			_ENV[h], _ENV[e], _ENV[e.owner] = e, GetManagedEnvironment(h), e
			return e.owner, e
		end
	end
	local _core, _env = ShadowEnvironment(core)
	_env._shadowES = {}
	function EvaluateCmdOptions(options, ...)
		return SecureCmdOptionParse((securecall(_core.Run, _core, _env.OptionConstruct, options, ...)))
	end
	function SetExternalShadow(name, func)
		_env._shadowES[name] = func
	end
	function core:irun(...)
		self:SetAttribute("irun-result", _env._shadowES[...](...))
	end
end

function KR:ClearConditional(name)
	assert(type(name) == "string", 'Syntax: Kindred:ClearConditional("name")')
	core:DeferExecute(([[-- KR:ClearConditional
		local name = %s
		cndAlias[name], cndType[name], cndState[name] = nil
		owner:Run(RefreshDrivers, name)
	]]):format(safequote(name)))
end
function KR:SetStateConditionalValue(name, value)
	if type(value) == "boolean" then value = value and "*" or "" end
	assert(type(name) == 'string' and type(value) == 'string', 'Syntax: Kindred:SetStateConditionalValue("name", "value")')
	core:DeferExecute(([[owner:RunAttribute("UpdateStateConditional", %s, %s, "*")]]):format(safequote(name), safequote(value or "")), name)
end
function KR:SetThresholdConditionalValue(name, value)
	assert(type(name) == 'string' and (value == false or type(value) == 'number'), 'Syntax: Kindred:SetThresholdConditionalValue("name", value or false)')
	core:DeferExecute(([[owner:RunAttribute("UpdateThresholdConditional", %s, %s)]]):format(safequote(name), value or "false"), name)
end
function KR:SetSecureExecConditional(name, snippet)
	assert(type(name) == "string" and type(snippet) == "string", 'Syntax: Kindred:SetSecureExecConditional("name", "snippet")')
	core:DeferExecute(([[-- KR:SetSecureExecConditional
		local name = %s
		cndType[name], cndState[name] = "srun", %s
		owner:Run(RefreshDrivers, name)
	]]):format(safequote(name), safequote(snippet)), name)
end
function KR:SetSecureExternalConditional(name, handler, hint)
	assert(type(name) == "string" and type(handler) == "table" and handler[0] and type(hint) == "function", 'Syntax: Kindred:SetSecureExternalConditional("name", handlerFrame, hintFunc)')
	assert(handler.IsProtected and select(2,handler:IsProtected()) and handler:GetAttribute("EvaluateMacroConditional"), 'Handler frame must be explicitly protected; must have EvaluateMacroConditional attribute set')
	if InCombatLockdown() then
		return core:DeferExecute(function() self:SetExternalConditional(name, handler, hint) end, name)
	end
	core:SetFrameRef("ExternalConditional-frame", handler)
	core:Execute(([[ local name, h = %s, self:GetFrameRef('ExternalConditional-frame')
		self:SetAttribute("frameref-ExternalConditional-frame", nil)
		cndType[name], cndState[name] = h and "srun", h
		owner:Run(RefreshDrivers, name)
	]]):format(safequote(name)), name)
	SetExternalShadow(name, hint)
end
function KR:SetNonSecureConditional(name, handler)
	assert(type(name) == "string" and type(handler) == "function", 'Syntax: Kindred:SetNonSecureConditional("name", handlerFunc)')
	if InCombatLockdown() then
		return core:DeferExecute(function() self:SetNonSecureConditional(name, handler) end, name)
	end
	core:Execute(([[-- KR:SetNonSecureConditional
		local name = %s
		cndType[name], cndInsecure[name], cndState[name] = "irun", true
		owner:Run(RefreshDrivers, name)
	]]):format(safequote(name)), name)
	SetExternalShadow(name, handler)
end
function KR:SetAliasConditional(name, aliasFor)
	assert(type(name) == "string" and type(aliasFor) == "string", 'Syntax: Kindred:SetAliasConditional("name", "aliasFor")')
	core:DeferExecute(('cndAlias[%s] = %s\n owner:Run(RefreshDrivers, name)'):format(safequote(name), safequote(aliasFor)), name)
end
function KR:SetAliasUnit(alias, unit)
	assert(type(alias) == "string" and (type(unit) == "string" or unit == nil), 'Syntax: Kindred:SetAliasUnit("alias", "unit" or nil)')
	core:DeferExecute(('owner:RunAttribute("SetAliasUnit", %s, %s)'):format(safequote(alias), unit and safequote(unit) or "nil"), "_alias-" .. alias)
end
function KR:PokeConditional(name)
	assert(type(name) == "string", 'Syntax: Kindred:PokeConditional("name")')
	core:DeferExecute(("owner:Run(RefreshDrivers, %s)"):format(safequote(name)), "_poke-" .. name)
end

function KR:EvaluateCmdOptions(options, ...)
	return EvaluateCmdOptions(options, ...)
end

function KR:RegisterStateDriver(frame, state, values)
	assert(type(frame) == "table" and type(state) == "string" and (values == nil or type(values) == "string"), 'Syntax: Kindred:RegisterStateDriver(frame, "state"[, "values"])')
	assert(not InCombatLockdown(), 'Combat lockdown in effect')
	core:SetFrameRef("RegisterStateDriver-frame", frame)
	core:Execute(([[self:RunAttribute("RegisterStateDriver", %s, %s)]]):format(safequote(state), safequote(values or "")))
end
function KR:RegisterBindingDriver(target, button, options, priority, notify)
	assert(type(target) == "table" and type(button) == "string" and type(options) == "string", 'Syntax: Kindred:RegisterBindingDriver(targetButton, "button", "options", priority, notifyFrame)')
	assert(type(priority or 0) == "number", 'Binding priority must be a number')
	assert(not InCombatLockdown(), 'Combat lockdown in effect')
	if notify and assert(type(notify) == "table" and notify:IsProtected(), 'If specified, notifyFrame must be a protected frame.') then
		core:SetFrameRef('RegisterBindingDriver-notify', notify)
	end
	core:SetFrameRef('RegisterBindingDriver-target', target)
	core:Execute(('self:RunAttribute("RegisterBindingDriver", %s, %s, %d)'):format(safequote(button), safequote(options), priority or 0))
end
function KR:UnregisterBindingDriver(target, button)
	assert(type(target) == "table" and type(button) == "string", 'Syntax: Kindred:UnregisterBindingDriver(targetButton, "button")')
	assert(not InCombatLockdown(), 'Combat lockdown in effect')
	core:SetFrameRef('UnregisterBindingDriver-target', target)
	core:Execute(('self:RunAttribute("UnregisterBindingDriver", %s)'):format(safequote(button)))
end

function KR:seclib()
	return core
end
function KR:compatible(cmaj, crev)
	return (cmaj == MAJ and crev <= REV) and KR or nil, MAJ, REV
end

KR:SetAliasConditional("modifier", "mod")
KR:SetAliasConditional("button", "btn")

T.Kindred = {compatible=KR.compatible}