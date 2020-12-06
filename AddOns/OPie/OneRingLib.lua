local versionMajor, versionRev, ADDON, T, ORI = 3, 104, ...
local MODERN = select(4,GetBuildInfo()) >= 8e4
local api, OR_Rings, OR_ModifierLockState, TL, EV, OR_LoadedState = {ext={ActionBook=T.ActionBook}}, {}, nil, T.L, T.Evie, 1
local defaultConfig = {
	ClickActivation=false, ClickPriority=true, CloseOnRelease=false, NoClose=false, NoCloseOnSlice=false,
	IndicationOffsetX=0, IndicationOffsetY=0, RingAtMouse=false, RingScale=1,
	CenterAction=false,
	MouseBucket=1,
	SliceBinding=false, SliceBindingString="1 2 3 4 5 6 7 8 9 0", SelectedSliceBind="",
	UseDefaultBindings=true, PrimaryButton="BUTTON4", SecondaryButton="BUTTON5",
	OpenNestedRingButton="BUTTON3", ScrollNestedRingUpButton="", ScrollNestedRingDownButton="",
	PadSupportMode="freelook", PSSwitchOnOpen=true, PSRestoreOnClose=true, PSThawHold=0.75, PSThawDuration=4,
}
local configRoot, configInstance, activeProfile, PersistentStorageInfo, optionValidators, optionsMeta = {}, nil, nil, {}, {}, {__index=defaultConfig}
local charId, internalFreeId = ("%s-%s"):format(GetRealmName(), UnitName("player")), 424

local L do
	T.L = newproxy(true)
	L = T.L
	getmetatable(L).__call = TL and function(_,k) return TL[k] or k end or function(_,k) return k end
end

local AB, KR = T.ActionBook:compatible(2,24), T.ActionBook:compatible("Kindred", 1,11) do
	local function createRingAction(name)
		local ringInfo = type(name) == "string" and OR_Rings[name]
		return ringInfo and ringInfo.action or nil
	end
	local function describeRingAction(name)
		return L"OPie Ring", OR_Rings[name] and OR_Rings[name].name or name, [[Interface\AddOns\OPie\gfx\opie_ring_icon]], nil, nil, nil, "collection"
	end
	AB:RegisterActionType("ring", createRingAction, describeRingAction)
	AB:AugmentCategory(L"OPie rings", function(_, add)
		for i=1,#OR_Rings do
			add("ring", OR_Rings[i])
		end
	end)
end

local function assert(condition, text, level, ...)
	return (not condition) and error(tostring(text):format(...), 1 + (level or 1)) or condition
end
local copy do -- (tbl, into) -> into
	local copies = {}
	local function icopy(t, into)
		if type(into) == "table" then
			for k,v in pairs(into) do
				if not (type(k) ~= "table" and type(v) == "table" and type(t[k]) == "table") then
					into[k] = nil
				end
			end
		else
			into = {}
		end
		copies[t] = into
		for k,v in pairs(t) do
			into[type(k) == "table" and (copies[k] or icopy(k)) or k] = type(v) == "table" and (copies[v] or icopy(v, into[k])) or v
		end
		return into
	end
	function copy(t, into)
		assert(type(t) == "table" and (into == nil or type(into) == "table"), "Syntax: copy(tbl[, into])")
		local _, ret = wipe(copies), icopy(t, into), wipe(copies)
		return ret
	end
end
local function tostringf(b)
	return b and "true" or "nil"
end
local function getSpecCharIdent()
	local tg = MODERN and GetSpecialization() or 1
	return (tg == 1 and "%s" or "%s-%d"):format(charId, tg)
end
local safequote do
	local r = {u="\\117", ["{"]="\\123", ["}"]="\\125"}
	function safequote(s)
		return (("%q"):format(s):gsub("[{}u]", r))
	end
end

-- Here be (Secure) Dragons
local OR_SecCore = CreateFrame("Button", ("OPieRT-%08x-%04x"):format(time() % 2^30, math.random(2^16)-1), UIParent, "SecureActionButtonTemplate,SecureHandlerAttributeTemplate,SecureHandlerMouseWheelTemplate")
local OR_OpenProxy = CreateFrame("Button", "ORLOpen", nil, "SecureActionButtonTemplate")
local OR_SecEnv, OR_ActiveRingName, OR_ActiveCollectionID, OR_ActiveSliceCount
local OR_PadRestoreState = {}
OR_SecCore:SetSize(2^15, 2^15)
OR_SecCore:SetFrameStrata("FULLSCREEN_DIALOG")
OR_SecCore:RegisterForClicks("AnyUp", "AnyDown")
OR_SecCore:EnableMouseWheel(true)
OR_SecCore:Hide()
OR_SecCore:SetFrameRef("AB", AB:seclib())
OR_SecCore:SetFrameRef("KR", KR:seclib())
local OR_DeferExecute do
	local queue, qc, qpos = {}, 0
	function OR_DeferExecute(block, ...)
		if block then queue[qc+1], qc = block:format(...), qc + 1 end
		if InCombatLockdown() or qpos then return end
		qpos = 1 while qpos <= qc do
			OR_SecCore:Execute(queue[qpos])
			qpos = qpos + 1
		end
		qc, qpos = 0
	end
end
do -- Click dispatcher
	local bindProxy = CreateFrame("Frame", "ORL_BindProxy", nil, "SecureFrameTemplate")
	OR_SecCore:SetFrameRef("bindProxy", bindProxy)
	OR_SecCore:SetFrameRef("sliceBindProxy", CreateFrame("Frame", "ORL_BindProxySlice", nil, "SecureFrameTemplate"))
	OR_SecCore:SetFrameRef("overBindProxy", CreateFrame("Frame", "ORL_BindProxyOverride", nil, "SecureFrameTemplate"))
	OR_SecCore:SetFrameRef("screen", CreateFrame("Frame", nil, nil, "SecureFrameTemplate"))
	OR_SecCore:Execute([=[-- OR_SecCore
		ORL_GlobalOptions, ORL_RingData, ORL_RingDataN = newtable(), newtable(), newtable()
		ORL_KnownCollections, ORL_StoredCA = newtable(), newtable()
		POL_RUN_ONOPEN_ON_SWITCH = true
		collections, ctokens, rotation, rtokens, fcIgnore, rotationMode, emptyTable = newtable(), newtable(), newtable(), newtable(), newtable(), newtable(), newtable()
		modState, sizeSq, bindProxy, sliceProxy, overProxy = "", 16*9001^2, self:GetFrameRef("bindProxy"), self:GetFrameRef("sliceBindProxy"), self:GetFrameRef("overBindProxy")
		sliceBindState, visitedSlices = newtable(), newtable()
		BUTTON_NAMEKEY_MAP = newtable()
		BUTTON_NAMEKEY_MAP.LeftButton, BUTTON_NAMEKEY_MAP.RightButton, BUTTON_NAMEKEY_MAP.MiddleButton = "BUTTON1", "BUTTON2", "BUTTON3"
		BUTTON_NAMEKEY_MAP.Button4, BUTTON_NAMEKEY_MAP.Button5 = "BUTTON4", "BUTTON5"
		AIP_Binding, AIP_Key, AIP_Modifier, AIP_Handler, AIP_VirtualKey = nil
		-- TODO: check usages of AIP_Action/AI_LeftAction to allow them to coexist
		AIP_Action, AI_LeftAction, AI_RightAction = nil
		AIP_OnDown, AI_LeftOnDown, AI_RightOnDown = nil
		ORL_GlobalBindingMap = newtable("OpenNestedRingBinding","mwin", "ScrollNestedRingUpBinding","mwup", "ScrollNestedRingDownBinding","mwdown")
		AB, KR, SCREEN = self:GetFrameRef("AB"), self:GetFrameRef("KR"), self:GetFrameRef("screen")
		SCREEN:SetAllPoints(); SCREEN:Hide()

		ORL_PrepareCollection = [==[-- ORL_PrepareCollection
			wipe(collections) wipe(ctokens)
			local firstFC, root, colData = nil, ..., AB:RunAttribute("GetCollectionContent", ...)
			for cid, i, aid, tok in (colData or ""):gmatch("\n(%d+) (%d+) (%d+) (%S+)") do
				cid, i, aid = tonumber(cid), tonumber(i), tonumber(aid)
				if not collections[cid] then collections[cid], ctokens[cid] = newtable(), newtable() end
				collections[cid][i], ctokens[cid][i], ctokens[cid][tok], firstFC = aid, tok, i, firstFC or (cid == root and not fcIgnore[tok] and tok)
			end
			collections[root], ctokens[root] = collections[root] or emptyTable, ctokens[root] or emptyTable
			for cid, list in pairs(collections) do
				for i, aid in pairs(list) do
					if collections[aid] then
						local tok = ctokens[cid][i]
						local rMode, rIdx = rotationMode[ctokens[cid][i]], nil
						if rMode == "random" and #ctokens[aid] > 1 then
							local oIdx = ctokens[aid][rtokens[tok]]
							rIdx = math.random(#ctokens[aid] - (oIdx and 1 or 0))
							rIdx = rIdx + (oIdx and rIdx >= oIdx and 1 or 0)
						elseif rMode ~= "reset" and rMode ~= "jump" then
							rIdx = ctokens[aid][rtokens[tok]]
						end
						rotation[tok], rtokens[tok] = rIdx or 1, ctokens[aid][rIdx] or rtokens[tok]
					end
				end
			end
			return (collections[root] or emptyTable)[0], firstFC
		]==]
		ORL_CloseActiveRing = [[-- ORL_CloseActiveRing
			local old, shouldKeepOwner, selSliceIndex, selSliceAction = activeRing, ...
			if not shouldKeepOwner then
				owner:Hide()
			end
			bindProxy:ClearBindings()
			sliceProxy:ClearBindings()
			activeRing, openCollection, openCollectionID = nil
			AIP_Action, AIP_AltAction, AI_LeftAction, AI_RightAction = nil
			AIP_OnDown, AI_LeftOnDown, AI_RightOnDown = nil
			AIP_Binding, AIP_Key, AIP_Modifier, AIP_Handler, AIP_VirtualKey = nil
			owner:CallMethod("NotifyState", "close", old.name, old.action, selSliceIndex, selSliceAction)
		]]
		ORL_RegisterVariations = [[-- ORL_RegisterVariations
			local binding, mapkey, downmix, skipKey = ...
			local bindKey = binding == "-" and "-" or binding and binding:match("[^-]*.$")
			if skipKey and bindKey == skipKey or (binding or "") == "" then
				return
			end
			for alt=0,downmix:match("ALT") and 1 or 0 do for ctrl=0,downmix:match("CTRL") and 1 or 0 do for shift=0,downmix:match("SHIFT") and 1 or 0 do
				self:SetBindingClick(true, (alt == 1 and "ALT-" or "") .. (ctrl == 1 and "CTRL-" or "") .. (shift == 1 and "SHIFT-" or "") .. binding, owner, mapkey)
			end end end
		]]
		ORL_UpdateInteractionBindings = [==[-- ORL_UpdateInteractionBindings
			local setToVirtualKey = ...

			local interactKey = AIP_Binding == "-" and "-" or (AIP_Binding or ""):match("[^-]*.$")
			if setToVirtualKey then
				AIP_Binding, AIP_Key, AIP_Modifier, AIP_Handler, AIP_VirtualKey =
				   AIP_Binding, interactKey, interactKey ~= AIP_Binding and AIP_Binding or nil, self, setToVirtualKey
			end
		
			bindProxy:ClearBindings()
			owner:RunFor(bindProxy, ORL_RegisterVariations, "MOUSEWHEELUP", "mwup", "ALT-CTRL-SHIFT")
			owner:RunFor(bindProxy, ORL_RegisterVariations, "MOUSEWHEELDOWN", "mwdown", "ALT-CTRL-SHIFT")

			local down, up, open = ORL_GlobalOptions.ScrollNestedRingDownBinding or "", ORL_GlobalOptions.ScrollNestedRingUpBinding or "", ORL_GlobalOptions.OpenNestedRingBinding or ""
			owner:RunFor(bindProxy, ORL_RegisterVariations, down, down:match("MOUSEWHEEL") and "mwdownW" or "mwdownK", "ALT-CTRL-SHIFT", interactKey)
			owner:RunFor(bindProxy, ORL_RegisterVariations, up, up:match("MOUSEWHEEL") and "mwupW" or "mwupK", "ALT-CTRL-SHIFT", interactKey)
			owner:RunFor(bindProxy, ORL_RegisterVariations, open, "mwin", "ALT-CTRL-SHIFT", AIP_Binding)

			do
				sliceProxy:ClearBindings()
				if activeRing.SliceBinding then
					wipe(sliceBindState)
					local prefix = AIP_Action and AIP_Binding and AIP_Binding:match("^(.-)[^-]*$") or ""
					for i,b in pairs(activeRing.SliceBinding) do
						if openCollection[i] then
							owner:RunFor(sliceProxy, ORL_RegisterVariations, b, "slice" .. i, prefix)
						end
					end
				end
				if (activeRing.SelectedSliceBind or "") ~= "" then
					local prefix = AIP_Action and AIP_Binding and AIP_Binding:match("^(.-)[^-]*$") or ""
					owner:RunFor(sliceProxy, ORL_RegisterVariations, activeRing.SelectedSliceBind, "usenow", prefix)
				end
				wheelBucket = 0
			end

			if AIP_Binding and AIP_Action then
				bindProxy:SetBindingClick(true, AIP_Binding, AIP_Handler, AIP_VirtualKey)
			end
			if AI_LeftAction then
				bindProxy:SetBindingClick(true, "BUTTON1", self, "BUTTON1")
			end
			if AI_RightAction and AIP_Binding ~= "BUTTON2" then
				bindProxy:SetBindingClick(true, "BUTTON2", owner, "BUTTON2")
			end
			bindProxy:SetBindingClick(true, "ESCAPE", owner, "close")
		]==]
		ORL_OpenRing = [==[-- ORL_OpenRing
			local ring, ringID, openCause = ORL_RingData[...], ...
			local setToVirtualKey, fastSwitch, fastSwitch2
			if openCause == "primary-binding" then
				local isLC = ring.ClickActivation
				fastSwitch, fastSwitch2 = false, activeRing == ring
				AIP_Binding, setToVirtualKey = ring.bind, "r" .. ringID
				AIP_Action, AIP_AltAction = isLC and "close" or "use", isLC and ring.CenterAction and "useFC" or "noop"
				AI_LeftAction, AI_RightAction = isLC and (ring.NoClose and "usenow" or "use") or nil, "close"
				AIP_OnDown, AI_LeftOnDown, AI_RightOnDown = AIP_Action == "close", false, true
			elseif openCause == "override-binding" then
				fastSwitch, fastSwitch2 = false, activeRing == ring
				AIP_Binding, setToVirtualKey = bindOverrides[ringID], "ro" .. ringID
				AIP_Action, AIP_AltAction, AI_LeftAction, AI_RightAction = "use", nil, nil, "close"
				AIP_OnDown, AI_LeftOnDown, AI_RightOnDown = false, false, true
			elseif openCause == "open-macro" then
				fastSwitch, fastSwitch2 = nil
				AIP_Binding, AIP_Key, AIP_Modifier, AIP_Handler, AIP_VirtualKey = nil
				AIP_Action, AIP_AltAction, AI_LeftAction, AI_RightAction = "close", nil, ring.NoClose and "usenow" or "use", "close"
				AIP_OnDown, AI_LeftOnDown, AI_RightOnDown = true, false, true
			end
			local stickyPrimaryMods = AIP_Action and AIP_Action ~= "close"
			modState = (not stickyPrimaryMods and "") or (fastSwitch and modState) or ((IsAltKeyDown() and "A" or "") .. (IsControlKeyDown() and "C" or "") .. (IsShiftKeyDown() and "S" or "") .. (IsModifiedClick("META-X") and "M" or ""))
			local bind = stickyPrimaryMods and AIP_Binding or ""
			modLockState = (modState:match("A") or bind:match("ALT%-") and "a" or "-") .. (modState:match("S") or bind:match("SHIFT%-") and "s" or "-") .. (modState:match("C") or bind:match("CTRL%-") and "c" or "-") .. (modState:match("M") or bind:match("META%-") and "m" or "-")

			local cid = ring.action
			local openAction, firstFC = owner:Run(ORL_PrepareCollection, cid)
			openCollection, openCollectionID = collections[cid], cid
			activeRing = ring
			if ORL_StoredCA[ring.name] and not ring.fcToken then
				ring.fcToken, ORL_StoredCA[ring.name] = ORL_StoredCA[ring.name]
			end
			fastClick = ring.CenterAction and ((not fcIgnore[ring.fcToken] and ctokens[cid][ring.fcToken]) or (ring.OpprotunisticCA and ctokens[cid][firstFC])) or nil

			owner:RunFor(self, ORL_UpdateInteractionBindings, setToVirtualKey)

			owner:SetScale(ring.scale)
			owner:SetPoint('CENTER', ring.ofs, ring.ofsx/owner:GetEffectiveScale(), ring.ofsy/owner:GetEffectiveScale())
			if ring.ClickPriority then
				owner:Show()
			end

			owner:CallMethod("NotifyState", "open", ring.name, ring.action, fastClick, fastSwitch or fastSwitch2, modLockState)
			return owner:RunFor(self, ORL_PerformAB, openAction)
		]==]
		ORL_SwitchRing = [==[-- ORL_SwitchRing
			local colID, switchCause = ...
			local ringID = ORL_KnownCollections[colID]
			local col, ring = collections[colID], ORL_RingData[ringID]
			if not col then
				print("|cffff0000[OPie] Cannot switch to unknown collection " .. tostring(colID))
				return false
			end
			if switchCause == "switch-binding" then
			elseif switchCause == "jump-slice-release" then
				AIP_Binding, AIP_Key, AIP_Modifier, AIP_Handler, AIP_VirtualKey = nil
				AIP_Action, AIP_AltAction, AI_LeftAction, AI_RightAction = "close", nil, (ring and ring.NoClose) and "usenow" or "use", "close"
				AIP_OnDown, AI_LeftOnDown, AI_RightOnDown = true, false, true
				modState = ""
			end

			activeRing = ORL_RingData[ringID] or activeRing
			openCollection, openCollectionID, fastClick = col, colID, nil
			owner:RunFor(self, ORL_UpdateInteractionBindings) -- setToVirtualKey?
			owner:CallMethod("NotifyState", "switch", ring and ring.name, openCollectionID, fastClick, true, modState)
			if openCollection[0] and POL_RUN_ONOPEN_ON_SWITCH then
				return owner:RunFor(self, ORL_PerformAB, openCollection[0])
			end
		]==]
		ORL_GetCursorSlice = [[-- ORL_GetCursorSlice
			if not openCollection[1] then return nil end
			local psm = IsGamePadEnabled and IsGamePadEnabled() and ORL_GlobalOptions.PadSupportMode
			if psm == "freelook" and SCREEN:GetMousePosition() == 0.5 then
				local ms = GetGamePadState()
				local st = ms and ms.sticks
				st = st and st[2]
				if st then
					local radius, angle = 10000*st.len, math.deg(math.atan2(st.y, st.x))
					if radius > 2500 then
						local segAngle = 360/#openCollection
						return floor(((90 - angle + segAngle/2 - activeRing.ofsDeg) % 360) / segAngle) + 1, false
					elseif radius < 100 then
						return fastClick, true
					end
				end
			end

			local x, y = owner:GetMousePosition()
			x, y = x - 0.5, y - 0.5
			local radius, segAngle = (x*x*sizeSq + y*y*sizeSq)^0.5, 360/#openCollection
			if radius >= 40 then
				return floor(((math.deg(math.atan2(x, y)) + segAngle/2 - activeRing.ofsDeg) % 360) / segAngle) + 1, false
			elseif radius <= 20 then
				return fastClick, true
			end
		]]
		ORL_ResolveNestedSlice = [==[-- ORL_ResolveNestedSlice
			local visitedSlices, col, index, willPerform = wipe(visitedSlices), ...
			while 1 do
				local aid, ct = collections[col] and collections[col][index], ctokens[col] and ctokens[col][index]
				if visitedSlices[ct] or not aid then
					return
				elseif not collections[aid] then
					if willPerform then
						for ict, icol in pairs(visitedSlices) do
							local ort = rtokens[ict]
							local irMode, ctk = rotationMode[ict], ctokens[icol]
							if #ctk <= 1 then
							elseif irMode == "cycle" then
								local nid = (rotation[ict] or 0) % #ctk + 1
								rotation[ict], rtokens[ict] = nid, ctk[nid]
							elseif irMode == "shuffle" then
								local oid = rotation[ict]
								local nid = math.random(#ctk - (oid and 1 or 0))
								nid = nid + (oid and nid >= oid and 1 or 0)
								rotation[ict], rtokens[ict] = nid, ctk[nid]
							end
						end
					end
					return aid, "act"
				elseif rotationMode[ct] == "jump" then
					return aid, "jump"
				end
				visitedSlices[ct], col, index = aid, aid, rotation[ct] or 1
			end
		]==]
		ORL_PerformAB = [[-- ORL_PerformAB
			local action = ...
			if action then
				self:SetAttribute("type", "macro")
				self:SetAttribute("macrotext", AB:RunAttribute("UseAction", action))
			end
			return action or false, 0
		]]
		ORL_PerformSliceAction = [[-- ORL_PerformSliceAction
			local pureSlice, shouldUpdateFastClick, noClose, interactionSource = ...
			local pureToken = ctokens[openCollectionID][pureSlice]
			local action, at = owner:Run(ORL_ResolveNestedSlice, openCollectionID, pureSlice, true)
			activeRing.fcToken = shouldUpdateFastClick and activeRing.CenterAction and not fcIgnore[pureToken] and pureToken or activeRing.fcToken
			if at == "jump" then
				return owner:RunFor(self, ORL_SwitchRing, action, interactionSource == "primary-binding" and "jump-slice-release" or "switch-binding")
			end
			if not noClose then
				owner:Run(ORL_CloseActiveRing, nil, pureSlice, action)
			end
			return owner:RunFor(self, ORL_PerformAB, action)
		]]
		ORL_OnWheel = [==[-- ORL_OnWheel
			local slice = owner:Run(ORL_GetCursorSlice)
			local nestedCol = collections[openCollection[slice]]
			local rMode = rotationMode[(ctokens[openCollectionID] or emptyTable)[slice]]
			if not (slice and nestedCol and rMode ~= "jump") then return end
			if slice ~= wheelSlice then wheelSlice, wheelBucket = slice, 0 end
			wheelBucket = wheelBucket + (...)
			if abs(wheelBucket) >= activeRing.bucket then wheelBucket = 0 else return end
			local stoken, step, count, c = ctokens[openCollectionID][slice], (...) > 0 and 0 or -2, #nestedCol, 0
			repeat
				rotation[stoken], c = (rotation[stoken] + step) % count + 1, c + 1
			until owner:Run(ORL_ResolveNestedSlice, openCollectionID, slice, false) or c == count
			rtokens[stoken] = (ctokens[openCollection[slice]] or emptyTable)[rotation[stoken]] or rtokens[stoken]
		]==]
		ORL_CheckButtonBindings = [==[-- ORL_CheckButtonBindings
			local lvalue, lkey, BUTTON, checkRingBindings = 0, nil, ...
			for i=1, #ORL_GlobalBindingMap, 2 do
				local bind = ORL_GlobalOptions[ORL_GlobalBindingMap[i]]
				if bind then
					local mod, bindButton = bind:match("^(.-)([^-]*%-?)$")
					if bindButton == BUTTON and #bind > lvalue and (mod == "" or IsModifiedClick(bind)) then
						lkey, lvalue = ORL_GlobalBindingMap[i+1], #bind
					end
				end
			end
			if checkRingBindings and not lkey then
				for k, v in pairs(ORL_RingData) do
					if v.bindButton == BUTTON and (v.bindModifiedClick == nil or IsModifiedClick(v.bindModifiedClick)) and #v.bind > lvalue then
						lkey, lvalue = "r" .. k, #v.bind
					end
				end
			end
			return lkey
		]==]
		ORL_OnClick = [==[-- ORL_OnClick
			local button, down = ...
			local BUTTON = BUTTON_NAMEKEY_MAP[button] or button and button:upper()
			local isActiveRingTriggerClick = (AIP_VirtualKey and AIP_VirtualKey == button) or (AIP_Key and AIP_Key == BUTTON and (AIP_Modifier == nil or IsModifiedClick(AIP_Modifier)))
			local openHotkeyOverride, openHotkeyId = button:match("^r(o?)(%d+)$")
			openHotkeyId = tonumber(openHotkeyId)
			if isActiveRingTriggerClick and AIP_Action then
				button = down == AIP_OnDown and AIP_Action or AIP_AltAction or "noop"
				-- If hovering over a nested ring, allow global mwin/up/down bindings to override the ring binding (when down)
				local globalAction = down and owner:Run(ORL_CheckButtonBindings, (AIP_VirtualKey == ... and AIP_Key or BUTTON), false)
				local pointerAID = globalAction and openCollection[owner:Run(ORL_GetCursorSlice)]
				if collections[pointerAID] or ORL_KnownCollections[pointerAID] then
					-- (primary binding, up) may happen again, ignore it
					button, AIP_AltAction = globalAction, "noop"
				end
			elseif BUTTON == "BUTTON1" and activeRing and AI_LeftAction then
				button = down == AI_LeftOnDown and AI_LeftAction or "noop"
			elseif BUTTON == "BUTTON2" and AI_RightAction then
				button = down == AI_RightOnDown and AI_RightAction or "noop"
			end

			if button == "noop" then
				return false
			elseif activeRing and (button == "use" or button == "useFC") then
				local slice, isFC = owner:Run(ORL_GetCursorSlice)
				if button == "useFC" and not (isFC and slice) then
					return false
				end
				return owner:RunFor(self, ORL_PerformSliceAction, slice, openCollectionID == activeRing.action, false, isActiveRingTriggerClick and "primary-binding")
			elseif activeRing and button == "usenow" then
				return owner:RunFor(self, ORL_PerformSliceAction, owner:Run(ORL_GetCursorSlice), false, true, "use-binding")
			elseif activeRing and button == "close" then
				return false, owner:Run(ORL_CloseActiveRing)
			elseif activeRing and button:match("^slice%d+") then
				local b = tonumber(button:match("slice(%d+)"))
				if openCollection and openCollection[b] then
					if down then
						sliceBindState[b] = true
					elseif sliceBindState[b] then
						return owner:RunFor(self, ORL_PerformSliceAction, b, true, activeRing.NoCloseOnSlice, "slice-binding")
					end
				end
			elseif activeRing and button == "mwin" and down then
				local aid = openCollection[owner:Run(ORL_GetCursorSlice)]
				if collections[aid] then
					return owner:RunFor(self, ORL_SwitchRing, aid, "switch-binding")
				end
			elseif activeRing and button:match("^mw[ud]") then
				return false, down and owner:Run(ORL_OnWheel, (button:match("^mwup") and 1 or -1) * (button:match("K$") and activeRing.bucket or 1))
			elseif BUTTON:match("^BUTTON%d+$") then
				-- The click-capturing overlay captures all mouse clicks, including bindings
				local lkey = owner:Run(ORL_CheckButtonBindings, BUTTON, true)
				if lkey then
					return owner:RunFor(self, ORL_OnClick, lkey, down)
				end
			elseif openHotkeyId and down then
				if activeRing then
					-- If the click-capturing overlay gets the binding DOWN event, only *it* will be notified of the corresponding UP.
					owner:Run(ORL_CloseActiveRing, self == owner)
				end
				local isOverrideBinding = openHotkeyOverride == "o" and bindOverrides[openHotkeyId]
				return owner:RunFor(self, ORL_OpenRing, openHotkeyId, isOverrideBinding and "override-binding" or "primary-binding")
			end
			return false
		]==]
		ORL_OpenClick = [[-- OpenClick
			local rdata, cur = ORL_RingDataN[...], activeRing
			if not rdata then
				return print("|cffff0000[OPie] Unknown ring alias: ".. tostring((...)))
			elseif cur then
				owner:Run(ORL_CloseActiveRing)
				if cur == rdata then return end
			end
			return owner:RunFor(self, ORL_OpenRing, rdata.id, "open-macro")
		]]
	]=])
	OR_SecCore:SetAttribute("_onmousewheel", [[-- OR_OnMouseWheel
		local wheelDirection = delta == 1 and "UP" or "DOWN"
		local bind = ORL_GlobalOptions.ScrollNestedRingDownBinding
		for bindDelta=-1,1,2 do
			if bind and bind:match("MOUSEWHEEL([UPDOWN]+)$") == wheelDirection and (bind:match("%-") == nil or IsModifiedClick(bind)) then
				delta = bindDelta
				break
			end
			bind = ORL_GlobalOptions.ScrollNestedRingUpBinding
		end
		return self:Run(ORL_OnWheel, delta)
	]])
	OR_SecCore:WrapScript(OR_SecCore, "OnClick", "return self:Run(ORL_OnClick, button, down)", "self:SetAttribute('type', nil)")
	OR_SecCore:WrapScript(OR_OpenProxy, "OnClick", "return owner:Run(ORL_OpenClick, button)")
	OR_SecCore:WrapScript(bindProxy, "OnAttributeChanged", [[-- ORL.BindProxy-OnAttributeChanged
		local data = ORL_RingData[tonumber(type(name) == "string" and name:match("^binding%-r(%d+)$"))]
		if data then
			if (value or "") ~= "" then
				local modifiedClick, modifiers, undash, button = value:match("^((.-)([^-]?)(BUTTON%d+))$")
				if undash ~= "" or modifiedClick == button then
					modifiedClick, modifiers = nil
				end
				data.bind, data.bindButton, data.bindModifiedClick = value, button, modifiedClick
			else
				data.bind, data.bindButton, data.bindModifiedClick = nil
			end
		end
	]])
	OR_SecEnv = GetManagedEnvironment(OR_SecCore)
end
local function OR_GetRingOption(ringName, option)
	if not configInstance then return defaultConfig[option], nil, nil, nil, defaultConfig[option] end
	local ring, global, default, value, setting = configInstance.RingOptions[ringName and (ringName .. "#" .. option)], rawget(configInstance, option), defaultConfig[option]
	if ringName ~= nil then setting = ring else setting = global end
	if ringName ~= nil and ring ~= nil then value = ring
	elseif ring == nil and global ~= nil then value = global
	else value = default end
	return value, setting, ring, global, default
end
local OR_SyncRingBinding do -- Binding management
	local bindingEncodeChars = {["["]="OPEN", ["]"]="CLOSE", [";"]="SEMICOLON"}
	local function RemoveConflictingBindings(whole, bind)
		return GetBindingAction(bind) ~= "" and ";" or whole
	end
	function OR_SyncRingBinding(name, props)
		if InCombatLockdown() then return end
		local hotkey, isSoftBinding, id = configInstance and configInstance.Bindings[name], false, props.internalID
		if hotkey == nil and type(props.hotkey) == "string" and OR_GetRingOption(name, "UseDefaultBindings") then
			hotkey, isSoftBinding = props.hotkey, true
		end
		if hotkey then
			if not hotkey:match("%[.*%]") then
				hotkey = "[] " .. hotkey:gsub("([^-]+)%s*$", bindingEncodeChars)
			end
			if isSoftBinding then
				hotkey = (hotkey .. ";"):gsub("(([^%s%[%];]+)%s*;)", RemoveConflictingBindings)
			end
		end
		if not OR_SecCore:GetAttribute("frameref-proxy" .. id) then
			local f = CreateFrame("Button", "ORL_RProxy" .. id, nil, "SecureActionButtonTemplate")
			f:RegisterForClicks("AnyUp", "AnyDown")
			OR_SecCore:WrapScript(f, "OnClick", "return owner:RunFor(self, ORL_OnClick, button, down)", 'self:SetAttribute("type", nil)')
			OR_SecCore:SetFrameRef("proxy" .. id, f)
			_G["BINDING_NAME_CLICK ".. f:GetName() .. ":r" .. id] = (L"OPie ring: %s"):format(props.name or "?")
		end
		if props.currentBindingConditional == hotkey then
			return
		end
		props.currentBindingConditional = hotkey
		OR_DeferExecute([=[-- OR_SyncRingBinding
			local ringName, internalId = %s, %d
			KR:SetAttribute("frameref-RegisterBindingDriver-target", self:GetFrameRef("proxy" .. internalId))
			KR:SetAttribute("frameref-RegisterBindingDriver-notify", bindProxy)
			KR:RunAttribute("RegisterBindingDriver", "r" .. internalId, %s, -10)
		]=], safequote(name), id, safequote((hotkey or "") .. ";"))
	end
	OR_SecCore:Execute([=[-- BindingInit
		bindOverrides = newtable()
		RegisterStateDriver(self, "combat", "[combat] combat; nocombat")
		ORL_RegisterOverride = [[-- ORL_RegisterOverride
			local id, bind = ...
			if bindOverrides[id] then overProxy:ClearBinding(bindOverrides[id]) end
			if bindOverrides[bind] then bindOverrides[ bindOverrides[bind] ] = nil end
			if bind then
				overProxy:SetBindingClick(true, bind, self:GetFrameRef("proxy" .. id), "ro" .. id)
				bindOverrides[bind] = ring
			end
			bindOverrides[id] = bind
		]]
	]=])
	OR_SecCore:SetAttribute("_onattributechanged", [=[-- ORL_UpdateBinding
		if name == "state-combat" and value == "combat" then
			overProxy:ClearBindings()
			wipe(bindOverrides)
		end
	]=])
end
local function OR_SyncRing(name, actionId, newprops)
	local props = OR_Rings[name] or {}
	if not OR_Rings[name] then
		OR_Rings[name], OR_Rings[#OR_Rings+1], props.internalID, props.internalName, internalFreeId = props, name, internalFreeId, name, internalFreeId+1
	end
	if newprops then
		props.action, props.offset, props.name, props.hotkey, props.internal = actionId, newprops.offset or 0, newprops.name or name, newprops.hotkey, newprops.internal
		local fcBlock = ""
		for i=1,#newprops do
			if newprops[i].sliceToken then
				local pMode, rMode = newprops[i].rotationMode, nil
				if pMode and (pMode == "random" or pMode == "shuffle" or pMode == "cycle" or pMode == "reset" or pMode == "jump") then
					rMode = pMode
				elseif newprops[i].lockRotation then
					-- DEPRECATED [1902/3.96/W1]: lockRotation->rotationMode="reset" transition
					rMode = "reset"
				end
				fcBlock = fcBlock .. ("fcIgnore[%s], rotationMode[%1$s] = %s, %s "):format(safequote(newprops[i].sliceToken), tostringf(not newprops[i].fastClick), rMode and safequote(rMode) or "nil")
			end
		end
		props.fcBlock, props.opportunisticCA, props.noPersistentCA = fcBlock, not newprops.noOpportunisticCA, newprops.noPersistentCA
		props.sortScope = type(newprops.sortScope) == "number" and newprops.sortScope or 2
	end

	local sliceBindTable = "false"
	if OR_GetRingOption(name, "SliceBinding") then
		local bound = false
		for s in OR_GetRingOption(name, "SliceBindingString"):gmatch("%S+") do
			local u = s:upper()
			if u:match("BUTTON[123]$") or u:match("ESCAPE$") then s = "false" end
			if sliceBindTable == "false" then
				sliceBindTable = ("newtable(%s"):format(safequote(s))
			else
				sliceBindTable = ("%s, %s"):format(sliceBindTable, safequote(s))
			end
			bound = bound or (s ~= "false")
		end
		sliceBindTable = bound and (sliceBindTable .. ")") or "false"
	end

	OR_DeferExecute([[-- SyncRing
		local ringName, internalId, actionId = %s, %d, %d
		local data = ORL_RingData[internalId] or newtable()
		ORL_KnownCollections[actionId], ORL_RingData[internalId], ORL_RingDataN[ringName], data.action, data.name, data.id = internalId, data, data, actionId, ringName, internalId

		data.name, data.ofs, data.ofsx, data.ofsy, data.ofsDeg = ringName, %q, %d, %d, %f
		data.CenterAction, data.ClickActivation, data.ClickPriority = %s, %s, %s
		data.NoClose, data.NoCloseOnSlice, data.CloseOnRelease = %s, %s, %s
		data.scale, data.bucket = %f, %d
		data.SliceBinding, data.SelectedSliceBind, data.OpprotunisticCA = %s, %s, %s
		%s
	]], safequote(name), props.internalID, props.action,
		OR_GetRingOption(name, "RingAtMouse") and "$cursor" or "$screen", OR_GetRingOption(name, "IndicationOffsetX"), -OR_GetRingOption(name, "IndicationOffsetY"), props.offset,
		tostringf(OR_GetRingOption(name, "CenterAction")), tostringf(OR_GetRingOption(name, "ClickActivation")), tostringf(OR_GetRingOption(name, "ClickPriority")),
		tostringf(OR_GetRingOption(name, "NoClose")), tostringf(OR_GetRingOption(name, "NoCloseOnSlice")), tostringf(OR_GetRingOption(name, "CloseOnRelease")),
		math.max(0.1, (OR_GetRingOption(name, "RingScale"))), (OR_GetRingOption(name, "MouseBucket")),
		sliceBindTable, safequote(OR_GetRingOption(name, "SelectedSliceBind") or ""), tostringf(props.opportunisticCA),
		props.fcBlock or "")
	OR_SyncRingBinding(name, props)
	if newprops and AB then AB:NotifyObservers("ring") end
end
local function OR_DeleteRing(name, data)
	OR_DeferExecute([[-- DeleteRing
		local ringName, internalId, actionId = %s, %d, %d
		self:SetAttribute("state-r" .. internalId, nil)
		ORL_KnownCollections[actionId], ORL_RingData[internalId], ORL_RingDataN[ringName] = nil
		KR:SetAttribute("frameref-UnregisterBindingDriver-target", self:GetFrameRef("proxy" .. internalId))
		KR:RunAttribute("UnregisterBindingDriver", "r" .. internalId)
	]], safequote(name), data.internalID, data.action or 0)

	local bind = configInstance and configInstance.Bindings[name]
	if configRoot and configRoot.ProfileStorage then
		local rnOpt = "^" .. name:gsub("[%]%[().+*%-?^$%%]", "%%%1") .. "#"
		for _,v in pairs(configRoot.ProfileStorage) do
			if v.Bindings then
				v.Bindings[name] = nil
			end
			if v.RingOptions then
				for k2, _v2 in pairs(v.RingOptions) do
					if type(k2) ~= "string" or k2:match(rnOpt) then
						v.RingOptions[k2] = nil
					end
				end
			end
		end
	end
	OR_Rings[name] = nil
	tDeleteItem(OR_Rings, name)

	if bind then
		for k, v in pairs(OR_Rings) do
			if v.hotkey == bind then
				OR_SyncRing(k)
			end
		end
	end
end
local function OR_SecProfilePull()
	local pInstance = configRoot.ProfileStorage[OR_SecEnv.activeProfile]
	if not pInstance then return end
	for k, v in rtable.pairs(OR_SecEnv.rtokens) do
		pInstance.RotationTokens[k] = v
	end
end
local function OR_SecProfilePush()
	if InCombatLockdown() or (activeProfile == OR_SecEnv.activeProfile) then return end
	local e = ("-- SecProfilePush\n activeProfile = %s"):format(safequote(activeProfile))
	for k,v in pairs(configInstance.RotationTokens) do
		e = e .. ("\n rtokens[%s] = %s"):format(safequote(k), safequote(v))
	end
	OR_SecCore:Execute(e)
end
local function OR_PullCAs()
	local t = {}
	for k,v in rtable.pairs(OR_SecEnv.ORL_StoredCA) do
		t[k] = v
	end
	for _, k in ipairs(OR_Rings) do
		local rt = OR_SecEnv.ORL_RingDataN[k] and OR_SecEnv.ORL_RingDataN[k].fcToken or t[k]
		t[k] = not ((OR_Rings[k] and OR_Rings[k].noPersistentCA) or OR_SecEnv.fcIgnore[rt]) and rt or nil
	end
	return next(t) and t or nil
end
local OR_FindFinalAction do
	local seen, wipe = {}, table.wipe
	local secRotation, secCollections, secTokens, secRotationMode = OR_SecEnv.rotation, OR_SecEnv.collections, OR_SecEnv.ctokens, OR_SecEnv.rotationMode
	function OR_FindFinalAction(collection, id, from, rotationBonus, followJumps)
		wipe(seen)
		for k=1,1e3 do
			local col = secCollections[collection]
			local act = col and col[id]
			if act then
				local nCol, tok = secCollections[act], secTokens[collection][id]
				local isJump = secRotationMode[tok] == "jump"
				if isJump and nCol and tok ~= from and not followJumps then
					return act, tok, "jump"
				elseif nCol and not seen[tok] then
					seen[tok] = true
					local rot = secRotation[tok] or 1
					if tok == from then rot = (rot + rotationBonus - 1) % #nCol + 1 end
					collection, id, from, rotationBonus = act, rot, from, rotationBonus
				elseif nCol == nil then
					return act, tok, "act"
				else
					-- TODO: ???
					return act, tok, isJump and "jump" or "act"
				end
			end
		end
	end
	end
local OR_CameraStickOverride = {} do
	local hasStoredState, storedYaw, storedPitch = false
	local isThawing, thawFrame, thawEnd, thawL, thawH = false, CreateFrame("Frame")
	thawFrame:Hide()
	thawFrame:SetScript("OnUpdate", function(s, e)
		local t = GetTime()
		if t >= thawEnd or not isThawing then
			if isThawing then
				SetCVar("GamePadCameraYawSpeed", storedYaw)
				SetCVar("GamePadCameraPitchSpeed", storedPitch)
				isThawing, hasStoredState = false, false
			end
			s:Hide()
			return
		end
		local ms = C_GamePad.GetDeviceMappedState()
		local st = ms and ms.sticks
		st = st and st[2]
		if st and st.len == 0 then
			thawEnd = t-1
			return s:GetScript("OnUpdate")(s, e)
		end
		local r = (thawEnd-t)/thawL
		local p = r >= thawH and 0 or (1-r/(1-thawH))
		p = p < 0 and 0 or p > 1 and 1 or p
		if p > 0 then
			local s = p*p
			SetCVar("GamePadCameraYawSpeed", storedYaw*s)
			SetCVar("GamePadCameraPitchSpeed", storedPitch*s)
		end
	end)
	function OR_CameraStickOverride:Lock()
		if not hasStoredState then
			hasStoredState, storedYaw, storedPitch = true, GetCVar("GamePadCameraYawSpeed"), GetCVar("GamePadCameraPitchSpeed")
		end
		SetCVar("GamePadCameraYawSpeed", 0)
		SetCVar("GamePadCameraPitchSpeed", 0)
		isThawing = false
	end
	function OR_CameraStickOverride:Release()
		if hasStoredState and not isThawing then
			isThawing, thawL, thawH = true, OR_GetRingOption(nil, "PSThawDuration"), OR_GetRingOption(nil, "PSThawHold")
			thawEnd = thawL + GetTime()
			thawFrame:Show()
		end
	end
	function EV:PLAYER_LOGOUT()
		if hasStoredState then
			SetCVar("GamePadCameraYawSpeed", storedYaw)
			SetCVar("GamePadCameraPitchSpeed", storedPitch)
		end
	end
end
function OR_SecCore:NotifyState(state, _ringName, collection, ...)
	if state == "open" then
		MouselookStop()
		local fastClick, fastOpen, ms = ...
		OR_ActiveCollectionID, OR_ActiveRingName, OR_ActiveSliceCount, OR_ModifierLockState = collection, OR_SecEnv.activeRing.name, #OR_SecEnv.openCollection, ms
		if ORI then
			securecall(ORI.Show, ORI, collection, fastClick, fastOpen, self)
		end
		local psm = MODERN and C_GamePad.IsEnabled() and OR_SecEnv.ORL_GlobalOptions.PadSupportMode
		if psm == "freelook" then
			if not OR_PadRestoreState.saved then
				OR_PadRestoreState.InFreeLook = IsGamePadFreelookEnabled()
				OR_PadRestoreState.InCursorControl = IsGamePadCursorControlEnabled()
				OR_PadRestoreState.saved = true
			end
			if OR_GetRingOption(nil, "PSSwitchOnOpen") then
				SetGamePadFreeLook(true)
				SetGamePadCursorControl(false)
				OR_CameraStickOverride:Lock()
			end
		elseif psm == "cursor" then
			if not OR_PadRestoreState.saved then
				OR_PadRestoreState.InFreeLook = IsGamePadFreelookEnabled()
				OR_PadRestoreState.InCursorControl = IsGamePadCursorControlEnabled()
				OR_PadRestoreState.saved = true
			end
			if OR_GetRingOption(nil, "PSSwitchOnOpen") then
				SetGamePadFreeLook(false)
				SetGamePadCursorControl(true)
			end
		end
	elseif state == "switch" then
		OR_ActiveCollectionID, OR_ActiveSliceCount = collection, #OR_SecEnv.openCollection
		if ORI then
			securecall(ORI.Show, ORI, collection, ..., "inplace-switch", self)
		end
	elseif state == "close" then
		if ORI then
			securecall(ORI.Hide, ORI, ...)
		end
		OR_ActiveSliceCount, OR_ActiveCollectionID, OR_ActiveRingName = 0
		OR_CameraStickOverride:Release()
		if OR_PadRestoreState.saved then
			if OR_GetRingOption(nil, "PSRestoreOnClose") then
				SetGamePadFreeLook(OR_PadRestoreState.InFreeLook)
				SetGamePadCursorControl(OR_PadRestoreState.InCursorControl)
			end
			OR_PadRestoreState.saved = nil
		end
	end
end

-- Responding to WoW Events
local function OR_NotifyPVars(event, filter, perProfile)
	for k, v in pairs(PersistentStorageInfo) do
		if type(v.f) == "function" and v.t == (filter or v.t) and (perProfile == nil or perProfile == v.perProfile) then
			securecall(v.f, event, k, v.t)
		end
	end
end
local function OR_ForceResync(filter)
	for _,v in ipairs(OR_Rings) do
		if (filter or v) == v then
			OR_SyncRing(v)
		end
	end
	if (filter or true) == true then
		OR_DeferExecute([[-- SyncGlobalOptions
			ORL_GlobalOptions.OpenNestedRingBinding, ORL_GlobalOptions.ScrollNestedRingUpBinding, ORL_GlobalOptions.ScrollNestedRingDownBinding = %s, %s, %s
			ORL_GlobalOptions.PadSupportMode = %s]],
			safequote(OR_GetRingOption(nil, "OpenNestedRingButton")),
			safequote(OR_GetRingOption(nil, "ScrollNestedRingUpButton")),
			safequote(OR_GetRingOption(nil, "ScrollNestedRingDownButton")),
			safequote(MODERN and OR_GetRingOption(nil, "PadSupportMode") or "none")
		)
	end
end
local function OR_CheckBindings()
	if InCombatLockdown() then return end
	for i=1,#OR_Rings do
		local k = OR_Rings[i]
		OR_SyncRingBinding(k, OR_Rings[k])
	end
end
function EV:PLAYER_REGEN_ENABLED()
	OR_CheckBindings()
	OR_SecProfilePush()
	OR_DeferExecute()
end
local function OR_UnserializeConfigInstance(profile)
	activeProfile = configRoot.ProfileStorage[profile] and profile or "default"
	local newCI = configRoot.ProfileStorage[activeProfile]
	for t in ("RingOptions Bindings RotationTokens"):gmatch("%S+") do
		if type(newCI[t]) ~= "table" then newCI[t] = {} end
	end
	for k,v in pairs(PersistentStorageInfo) do if v.perProfile then	copy(newCI[k], v.t) end end
	configInstance = setmetatable(newCI, optionsMeta)
end
local function OR_NotifyOptions()
	for option, func in pairs(optionValidators) do
		if func then
			securecall(func, option, configInstance[option])
		end
	end
end
local function OR_InitConfigState()
	if type(OneRing_Config) == "table" then
		for k, v in pairs(OneRing_Config) do
			configRoot[k] = v
		end
	end
	for t in ("CharProfiles PersistentStorage ProfileStorage"):gmatch("%S+") do
		if type(configRoot[t]) ~= "table" then configRoot[t] = {} end
	end
	
	local gameVersion = GetBuildInfo()
	if configRoot._GameVersion ~= gameVersion then
		for _,v in pairs(configRoot.ProfileStorage) do
			if type(v) == "table" then
				v.RotationTokens = nil
			end
		end
	end
	configRoot._GameVersion, configRoot._GameLocale = gameVersion, GetLocale()
	configRoot._OPieVersion = ("%s (%d.%d)"):format(api:GetVersion())

	if type(configRoot.ProfileStorage.default) ~= "table" then
		configRoot.ProfileStorage.default = {Bindings=configRoot.Bindings or {}, RingOptions=configRoot.RingOptions or {}}
	end
	OR_UnserializeConfigInstance(configRoot.CharProfiles[getSpecCharIdent()] or configRoot.CharProfiles[charId])

	if type(configRoot.CenterActions) == "table" then
		local exec = "-- InitCA"
		for name, tok in pairs(configRoot.CenterActions) do
			exec = ("%s\nORL_StoredCA[%s] = %s"):format(exec, safequote(name), safequote(tok))
		end
		OR_SecCore:Execute(exec)
	end

	-- Load variables into relevant tables, unlock core and fire notifications.
	for k, v in pairs(configRoot.PersistentStorage) do
		if PersistentStorageInfo[k] and not PersistentStorageInfo[k].perProfile then
			copy(v, PersistentStorageInfo[k].t)
		end
	end
	OneRing_Config, configRoot.CenterActions = nil
	DisableAddOn("OPie_Classic", true)
	OR_NotifyPVars("LOADED")
	OR_NotifyOptions()
	OR_SecProfilePush()
	OR_ForceResync()
end
function EV:ADDON_LOADED(addon)
	if addon == ADDON then
		ORI, OR_LoadedState = T.OPieUI, OR_LoadedState == 1 and 2 or OR_LoadedState
		OR_InitConfigState()
		OR_ForceResync(true)
		return "remove"
	end
end
function EV:SAVED_VARIABLES_TOO_LARGE(addon)
	if addon == ADDON then
		OR_LoadedState = false
	end
end
function EV:PLAYER_LOGIN()
	OR_LoadedState = OR_LoadedState == 1 and 3 or OR_LoadedState
	OR_NotifyPVars("LOGIN")
	return "remove"
end
function EV:PLAYER_LOGOUT()
	OneRing_Config = configRoot
	OR_NotifyPVars("LOGOUT")
	OR_SecProfilePull()
	configRoot.CenterActions = OR_PullCAs()
	for k, v in pairs(configInstance) do
		if v == defaultConfig[k] then
			configInstance[k] = nil
		end
	end
	for k, v in pairs(PersistentStorageInfo) do
		local store = v.perProfile and configInstance or configRoot.PersistentStorage
		store[k] = next(v.t) ~= nil and v.t or nil
	end
	for _, v in pairs(configRoot.ProfileStorage) do
		if v.RingOptions and next(v.RingOptions) == nil then v.RingOptions = nil end
		if v.Bindings and next(v.Bindings) == nil then v.Bindings = nil end
		if v.RotationTokens and next(v.RotationTokens) == nil then v.RotationTokens = nil end
	end
end
local function OR_SaveCurrentProfile()
	OR_NotifyPVars("SAVE", nil, true)
	for k, v in pairs(PersistentStorageInfo) do
		if v.perProfile then
			configInstance[k] = next(v.t) and copy(v.t)
		end
	end
	OR_SecProfilePull()
end
local function OR_SwitchProfile(ident)
	if ident ~= activeProfile then OR_SaveCurrentProfile() end
	OR_UnserializeConfigInstance(ident)
	OR_NotifyPVars("UPDATE", nil, true)
	OR_NotifyOptions()
	OR_SecProfilePush()
	OR_ForceResync()
end
function EV:ACTIVE_TALENT_GROUP_CHANGED()
	local newProfile = configRoot.CharProfiles[getSpecCharIdent()]
	if configRoot.ProfileStorage[newProfile] and newProfile ~= activeProfile then
		OR_SwitchProfile(newProfile)
	end
end
EV.UPDATE_BINDINGS = OR_CheckBindings

local function cmpRingProps(a, b)
	local ac, bc = b.sortScope or 0, a.sortScope or 0
	if ac == bc then
		ac, bc = (a.name or a.internalName), (b.name or b.internalName)
	end
	return ac < bc
end

local private = {}
function private:GetActivePointerStick()
	local stick = 2
	if OR_SecEnv.ORL_GlobalOptions.PadSupportMode == "freelook" and C_GamePad.IsEnabled() and IsGamePadFreelookEnabled() and not IsGamePadCursorControlEnabled() then
		local ms = C_GamePad.GetDeviceMappedState()
		local st = ms and ms.sticks
		st = st and st[stick]
		if st then
			return stick, st.x, st.y, st.len
		end
	end
end
function private:GetSVState()
	return OR_LoadedState
end
function private:RegisterOption(name, default, validator)
	assert(type(name) == "string" and default ~= nil and (validator == nil or type(validator) == "function"), 'Syntax: api:RegisterOption("name", defaultValue[, validatorFunc])', 2)
	assert(defaultConfig[name] == nil and PersistentStorageInfo[name] == nil, "Option %q has a conflicting name", 2, name)
	defaultConfig[name], optionValidators[name] = default, validator or false
end
function private:RegisterPVar(name, into, notifier, perProfile)
	assert(type(name) == "string" and (into == nil or type(into) == "table") and (notifier == nil or type(notifier) == "function"), 'Syntax: api:RegisterPVar("name"[, storageTable[, notifierFunc[, perProfile]]])', 2)
	assert(PersistentStorageInfo[name] == nil and defaultConfig[name] == nil, "Persistent variable %q already declared.", 2, name)
	assert(name:match("^%a"), "%q is not a valid persistent variable name", 2, name)
	local store, into = ((perProfile == true) and configInstance or configRoot.PersistentStorage), into or {}
	PersistentStorageInfo[name] = {t=into, f=notifier, perProfile=perProfile == true}
	if configInstance then
		if store and store[name] then copy(store[name], into) end
		OR_NotifyPVars("LOADED", into)
	end
	return into
end

-- Public API
function api:SetRing(name, actionId, props)
	assert(type(name) == "string" and (actionId == nil or (type(props) == "table" or type(actionId) == "number")), 'Syntax: api:SetRing("ringName"[, actionId, propsTable])', 2)
	if actionId then
		OR_SyncRing(name, actionId, props)
	elseif OR_Rings[name] then
		OR_DeleteRing(name, OR_Rings[name])
	end
end
function api:OverrideRingBinding(ringName, bind)
	assert(type(ringName) == "string" and (bind == nil or type(bind) == "string"), 'Syntax: api:OverrideRingBinding("ringName", "binding")', 2)
	assert(OR_Rings[ringName], 'Ring %q is not defined', 2, ringName)
	if OR_SecEnv.bindOverrides[OR_Rings[ringName].internalID] ~= bind then
		OR_SecCore:Execute(("owner:Run(ORL_RegisterOverride, %d, %s)"):format(OR_Rings[ringName].internalID, bind and safequote(bind) or "nil"))
	end
end
function api:GetNumRings()
	return #OR_Rings
end
function api:GetRingInfo(id)
	assert(type(id) == "number" or type(id) == "string", 'Syntax: name, key, macro, flags = api:GetRingInfo(index or "ringName")', 2)
	local key = type(id) == "string" and OR_Rings[id] and id or OR_Rings[id]
	if not key then return end
	local props = OR_Rings[key]
	return props.name, key, "/click "..OR_OpenProxy:GetName().." "..key, (props.internal and 1 or 0)
end
function api:IterateRings(includeInternalRings)
	local ot = {}
	for i=1,#OR_Rings do
		local props = OR_Rings[OR_Rings[i]]
		if props and (includeInternalRings or not props.internal) then
			ot[#ot+1] = props
		end
	end
	table.sort(ot, cmpRingProps)
	local p, props = 1
	return function()
		props, p = ot[p], p + 1
		if props then
			return props.internalName, props.name or props.internalName, props.sortScope, props.internal and 1 or 0
		end
	end
end
function api:IsKnownRingName(ringName)
	assert(type(ringName) == "string", 'Syntax: isKnown = api:IsKnownRingName("ringName")', 2)
	if OR_Rings[ringName] then return true end
	for _, v in pairs(configRoot.ProfileStorage) do
		if type(v.Bindings) == "table" and v.Bindings[ringName] then
			return true
		end
	end
	return false
end
function api:GetCurrentProfile()
	return activeProfile
end
function api:GetVersion()
	return GetAddOnMetadata(ADDON, "Version") or "?", versionMajor, versionRev
end

-- DEPRECATED: private, no forward compatibility guarantees
function api:GetOption(option, ringName)
	assert(type(option) == "string" and (ringName == nil or type(ringName) == "string"), 'Syntax: value, setting, ring, global, default = api:GetOption("option"[, "ringName"])', 2)
	if defaultConfig[option] == nil then return end
	return OR_GetRingOption(ringName, option)
end
function api:SetOption(option, value, ringName)
	assert(type(option) == "string" and (ringName == nil or type(ringName) == "string"), 'Syntax: api:SetOption("option", value[, "ringName"])', 2)
	assert(defaultConfig[option] ~= nil, "Option %q is undefined.", 2, option)
	assert(ringName == nil or OR_Rings[ringName], "Ring %q is undefined.", 2, ringName)
	assert(value == nil or type(defaultConfig[option]) == type(value), "Type mismatch: %q expected to be a %s (got %s).", 2, option, type(defaultConfig[option]), type(value))
	assert(not optionValidators[option] or optionValidators[option](option, value, ringName) ~= false, "Value rejected by option validator.", 2)
	local scope, prefix = ringName and configInstance.RingOptions or configInstance, ringName and (ringName .. "#") or ""
	scope[prefix .. option] = value
	if optionValidators[option] == nil then
		OR_ForceResync(ringName)
	end
end
function api:SetRingBinding(ringName, bind)
	assert(type(ringName) == "string" and (type(bind) == "string" or bind == false or bind == nil), 'Syntax: api:SetRingBinding("ringName", "binding" or false or nil)', 2)
	assert(OR_Rings[ringName], "Ring %q is not defined", 2, ringName)
	if bind == configInstance.Bindings[ringName] then return end
	local obind = api:GetRingBinding(ringName)
	configInstance.Bindings[ringName] = bind
	for i=1,#OR_Rings do
		local ikey = OR_Rings[i]
		local cbind = api:GetRingBinding(ikey)
		if ikey ~= ringName and (cbind == bind or cbind == obind) then
			if cbind == bind and cbind then
				configInstance.Bindings[ikey] = nil
				if api:GetRingBinding(ikey) == bind then
					configInstance.Bindings[ikey] = false
				end
			end
			OR_SyncRing(ikey)
		end
	end
	OR_SyncRing(ringName)
end
function api:GetRingBinding(ringName)
	assert(type(ringName) == "string", 'Syntax: binding, currentKey, isUserBinding, isActiveInternal, isActiveExternal = api:GetRingBinding("ringName")', 2)
	assert(OR_Rings[ringName], 'Ring %q is not defined', 2, ringName)
	local binding, isUser, iid = configInstance.Bindings[ringName], true, OR_Rings[ringName].internalID
	if binding == nil then binding, isUser = OR_Rings[ringName].hotkey, false end
	local secRingData = OR_SecEnv.ORL_RingData[iid]
	local curKey = secRingData and secRingData.bind
	local curAct = curKey and GetBindingAction(curKey, 1)
	curAct = (curKey == nil) or (curAct == ("CLICK ORL_RProxy" .. iid .. ":r" .. iid)) or curAct
	return binding, curKey, isUser, curKey ~= nil, curAct
end
function api:ResetOptions(includePerRing)
	assert(type(includePerRing) == "boolean" or includePerRing == nil, "Syntax: api:ResetOptions([includePerRing])", 2)
	for k in pairs(defaultConfig) do
		configInstance[k] = nil
	end
	if includePerRing then
		configInstance.RingOptions = {}
	end
	OR_ForceResync()
end
function api:ResetRingBindings()
	wipe(configInstance.Bindings)
	OR_ForceResync()
end
function api:SwitchProfile(ident, inherit)
	assert(type(ident) == "string" and (inherit == nil or type(inherit) == "boolean" or type(inherit) == "table"), 'Syntax: api:SwitchProfile("profile"[, deriveFromCurrent or profileData])', 2)
	if type(inherit) == "table" then
		local data = copy(inherit)
		if data._usedBy then
			for _, charid in pairs(data._usedBy) do
				configRoot.CharProfiles[charid] = ident
			end
			data._usedBy = nil
		end
		configRoot.ProfileStorage[ident] = data
	elseif not configRoot.ProfileStorage[ident] then
		configRoot.ProfileStorage[ident] = inherit and copy(configInstance) or {}
	end
	OR_SwitchProfile(ident)
	configRoot.CharProfiles[getSpecCharIdent()] = activeProfile
end
function api:DeleteProfile(ident)
	assert(type(ident) == "string", 'Syntax: api:DeleteProfile("profile")', 2)
	local oldP = assert(configRoot.ProfileStorage[ident], "Profile %q does not exist.", 2, ident)
	if configRoot.CharProfiles then
		for k,v in pairs(configRoot.CharProfiles) do
			if v == ident then configRoot.CharProfiles[k] = nil end
		end
	end
	configRoot.ProfileStorage[ident] = nil
	if configInstance == oldP then self:SwitchProfile("default") end
end
function api:ExportProfile(ident)
	assert(type(ident) == "string" or ident == nil, 'Syntax: profileData = api:ExportProfile(["profile"])', 2)
	assert(ident == nil or configRoot.ProfileStorage[ident], 'Profile %q does not exist.', 2, ident)
	if ident == nil then OR_SaveCurrentProfile() end
	local data = copy(ident == nil and configInstance or configRoot.ProfileStorage[ident])
	if configRoot.CharProfiles then
		local id, ni, usedBy = ident or activeProfile, 1, {}
		for k,v in pairs(configRoot.CharProfiles) do
			if v == id then
				usedBy[ni], ni = k, ni + 1
			end
		end
		data._usedBy = ni > 1 and usedBy or nil
	end
	return data
end
function api:Profiles(prev)
	if not configInstance then return end
	local ident, data = next(configRoot.ProfileStorage, prev)
	return ident, data == configInstance
end
function api:ProfileExists(ident)
	return configRoot.ProfileStorage[ident] ~= nil
end
function api:GetOpenRing(optTable)
	if type(optTable) == "table" then
		for k in pairs(defaultConfig) do
			optTable[k] = OR_GetRingOption(OR_ActiveRingName or "default", k)
		end
	end
	return OR_ActiveRingName, OR_ActiveSliceCount, OR_SecEnv.activeRing and OR_SecEnv.activeRing.ofsDeg or 0
end
function api:GetOpenRingSlice(id)
	if type(id) ~= "number" or id < 1 or id > OR_ActiveSliceCount then return false end
	local sbt, act, tok, atype = OR_SecEnv.activeRing.SliceBinding, OR_FindFinalAction(OR_ActiveCollectionID, id)
	local nt = OR_SecEnv.collections[OR_SecEnv.collections[OR_ActiveCollectionID][id]]
	return act, tok, sbt and sbt[id], nt and #nt or 0, atype
end
function api:GetOpenRingSliceAction(id, id2)
	if id < 1 or id > OR_ActiveSliceCount then return end
	local s, tok, atype = OR_FindFinalAction(OR_ActiveCollectionID, id, id2 and OR_SecEnv.ctokens[OR_ActiveCollectionID][id] or nil, (id2 or 1)-1)
	if type(s) == "number" then
		if atype == "jump" then
			local icon, aid, tok2, _ = nil, OR_FindFinalAction(s, 1, nil, 0, true)
			if type(aid) == "number" then
				_, _, icon =  AB:GetSlotInfo(aid, OR_ModifierLockState)
			end
			local rid = OR_SecEnv.ORL_RingData[OR_SecEnv.ORL_KnownCollections[s]]
			rid = OR_Rings[rid and rid.name]
			local rname = rid and rid.name
			return tok, true, 4096, icon or [[Interface\AddOns\OPie\gfx\opie_ring_icon]], rname or L"Open nested ring", tok2, 0, 0
		end
		return tok, AB:GetSlotInfo(s, OR_ModifierLockState)
	end
	return tok, false, 0, [[Interface\Icons\INV_Misc_QuestionMark]], "Unknown Slice", 0, 0, 0
end

_G.OneRingLib, _G.OPie, T.OPieCore = api, {}, private