local COMPAT, _, T = select(4,GetBuildInfo()), ...
local L, EV, PC, TS, XU, config, KR = T.L, T.Evie, T.OPieCore, T.TenSettings, T.exUI, T.config, OPie.ActionBook:compatible("Kindred", 1, 0)
local MODERN = COMPAT >= 10e4

local frame = TS:CreateOptionsPanel(L"Ring Bindings", "OPie")
	frame.desc:SetText(L"Customize OPie key bindings below. Hover over a binding button for additional information and options."
		.. (MODERN and "\n" .. L"Profiles activate automatically when you switch character specializations." or ""))
local OBC_Profile = CreateFrame("Frame", "OBC_Profile", frame, "UIDropDownMenuTemplate")
	OBC_Profile:SetPoint("TOPLEFT", 0, -80)
	UIDropDownMenu_SetWidth(OBC_Profile, 200)
	OBC_Profile.initialize, OBC_Profile.text = OPC_Profile.initialize, OPC_Profile.text
local bindSet = CreateFrame("Frame", "OBC_BindingSet", frame, "UIDropDownMenuTemplate")
	bindSet:SetPoint("LEFT", OBC_Profile, "RIGHT", 44, 0)
	UIDropDownMenu_SetWidth(bindSet, 250)
local bindLines, bindLines2, bindZone, bindZoneOrigin = {}, {}, CreateFrame("Frame", nil, frame) do
	bindZone:SetClipsChildren(true)
	bindZone:SetHitRectInsets(0, -22, 0, 0)
	bindZoneOrigin = CreateFrame("Frame", nil, bindZone)
	bindZoneOrigin:SetHeight(1)
	bindZoneOrigin:SetPoint("TOPLEFT")
	bindZoneOrigin:SetPoint("TOPRIGHT")
	bindZoneOrigin:Hide()
	bindZone.clipContainer, bindZone.bindingContainerFrame = bindZone, frame
	for i=1,19 do
		local bind = config.createBindingButton(bindZone, 170)
		bind:SetPoint("TOPLEFT", bindZoneOrigin, "TOPLEFT", 220, 22-24*i)
		local bind2 = config.createBindingButton(bindZone, 170)
		bind2:SetPoint("LEFT", bind, "RIGHT", 4, 0)
		local label = bind:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		label:SetPoint("LEFT", bind, -215, -1.25)
		label:SetWidth(200)
		label:SetMaxLines(1)
		label:SetJustifyH("LEFT")
		bind.warn = bind:CreateTexture(nil, "ARTWORK")
		bind.warn:SetTexture("Interface/EncounterJournal/UI-EJ-WarningTextIcon")
		bind.warn:SetSize(14, 14)
		bind.warn:SetPoint("RIGHT", bind, "LEFT", -3, 0)
		bindLines[i], bind.label, bindLines2[i] = bind, label, bind2
	end
	bindZone:SetPoint("TOP", OBC_Profile, "BOTTOM", 0, -4)
	bindZone:SetPoint("LEFT", 15, 0)
	bindZone:SetPoint("RIGHT", -30, 0)
	bindZone:SetHeight((#bindLines-1)*24+3)
end
local bindZoneBar = XU:Create("ScrollBar", nil, frame)
	bindZoneBar:SetPoint("TOPLEFT", bindZone, "TOPRIGHT", 1, 14)
	bindZoneBar:SetPoint("BOTTOMLEFT", bindZone, "BOTTOMRIGHT", 1, -10)
	bindZoneBar:SetWindowRange(#bindLines-1)
	bindZoneBar:SetStepsPerPage(#bindLines-5, 6)
	bindZoneBar:SetCoverTarget(bindZone)
	bindZoneBar:SetWheelScrollTarget(bindZone)

local ringBindings = {map={}, name=L"Ring Bindings"}
function ringBindings:refresh()
	local pos, map = 1, self.map
	for key in PC:IterateRings(IsAltKeyDown()) do
		map[pos], pos = key, pos + 1
	end
	for i=#map,pos,-1 do
		map[i] = nil
	end
	self.count = #map
end
local function ringBindings_getInner(key, bidx)
	local bind, cBind, isOverride, isActiveInt, isActiveExt = PC:GetRingBinding(key, bidx)
	local showWarning, prefix, tipTitle, tipText = false
	local cebind = cBind or (bind and KR:EvaluateCmdOptions(bind))
	local BC_HEADER_PREFIX = "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0:0:0:2|t "
	if not isOverride and not PC:GetOption("UseDefaultBindings", key) then
		if bind then
			showWarning, prefix, tipTitle = true, "|cffa0a0a0", BC_HEADER_PREFIX .. L"Default binding disabled"
			tipText = (L"Choose a binding for this ring, or enable the %s option in OPie options."):format(HIGHLIGHT_FONT_COLOR_CODE .. L"Use default ring bindings" .. "|r")
		end
	elseif cBind and isActiveExt ~= true then
		showWarning, tipTitle = true, BC_HEADER_PREFIX .. L"Binding conflict"
		if isActiveInt == false then
			prefix = isOverride and "|cfffa2800" or "|cffa0a0a0"
			tipText = L"This binding is not currently active because it conflicts with another."
		else
			prefix, tipText = "|cfffa2800", L"This binding is currently used by another addon."
		end
		if isActiveExt then
			local lab = _G["BINDING_NAME_" .. isActiveExt]
			if not (lab and type(lab) == "string" and lab:match("%S")) then lab = tostring(isActiveExt) end
			tipText = tipText .. "\n\n" .. (L"Conflicts with: %s"):format("|cffe0e0e0" .. lab .. "|r")
		end
	elseif cBind == nil and cebind and not isActiveInt then
		showWarning, tipTitle = true, BC_HEADER_PREFIX .. L"Binding conflict"
		prefix, tipText = "|cffa0a0a0", L"This binding is not currently active because it conflicts with another."
	elseif isOverride and bind ~= nil then
		prefix = "|cffffffff"
	end
	return bind, prefix, cBind, tipTitle, tipText, showWarning
end
function ringBindings:get(id)
	local name, key = PC:GetRingInfo(self.map[id])
	local text = name or key or "?"
	local bind, prefix, cBind, title, tip, warning = ringBindings_getInner(key, 1)
	local bind2, prefix2, _cBind2, title2, tip2, warning2 = ringBindings_getInner(key, 2)
	return bind, text, prefix, cBind, title, tip, warning, bind2, prefix2, title2, tip2, warning2
end
function ringBindings:set(id, key, bidx)
	id = self.map[id]
	config.undo:saveActiveProfile()
	PC:SetRingBinding(id, bidx, key)
end
function ringBindings:default()
	PC:ResetRingBindings()
end
function ringBindings:altClick() -- self is the binding button
	local id, bidx = self:GetID()
	id, bidx = id < 0 and -id or id, id < 0 and 2 or 1
	self:ToggleAlternateEditor(PC:GetRingBinding(ringBindings.map[id], bidx))
end
function ringBindings:shiftClick()
	local name, key, macro = PC:GetRingInfo(ringBindings.map[math.abs(self:GetID())])
	TS:ShowPromptOverlay(frame, name or key, (L"The following macro command opens this ring:"):format("|cffFFD029" .. (name or key) .. "|r"), false, false, nil, 0.90, nil, macro)
end

local subBindings = { name=L"In-Ring Bindings",
	options={"ScrollNestedRingUpButton", "ScrollNestedRingDownButton", "OpenNestedRingButton", "SelectedSliceBind", "SelectedCloseBind", "CloseRingBind"},
	optionNames={L"Scroll nested ring (up)", L"Scroll nested ring (down)", L"Open nested ring", L"Selected slice (keep ring open)", L"Selected slice (close ring)", L"Close ring"},
	count=0, t={}
}
local function adjustBindingID(scope, id)
	local prefixLength = scope and 3 or 6
	if id <= prefixLength then
		return true, id + (scope and 3 or 0), prefixLength
	end
	return false, id - prefixLength, prefixLength
end
function subBindings.allowWheel(btn)
	return btn:GetID() <= 2 and not subBindings.scope
end
function subBindings:refresh(scope)
	local ringName = scope and PC:GetRingInfo(scope)
	scope = ringName and scope or nil
	self.scope, self.nameSuffix = scope, scope and (" (|cffacd7e6" ..  ringName .. "|r)") or (" (" .. L"Defaults" .. ")")
	local t, ni = {}, 1
	for s, s2 in PC:GetOption("SliceBindingString", scope):gmatch("([^%s\31]+)\31?(%S*)") do
		t[ni], t[ni+0.5], ni = s, s2, ni + 1
	end
	local _, _, prefixLength = adjustBindingID(scope, 1)
	subBindings.t, subBindings.count = t, ni+prefixLength
end
function subBindings:get(id)
	local inPrefix, id = adjustBindingID(self.scope, id)
	if inPrefix then
		local value, setting = PC:GetOption(self.options[id], self.scope)
		local value2, setting2 = PC:GetOption(self.options[id] .. "2", self.scope)
		return value, self.optionNames[id], setting and "|cffffffff" or nil, nil, nil, nil, nil, value2, setting2 and "|cffffffff" or nil
	end
	local b, b2 = self.t[id], self.t[id+0.5]
	b, b2 = b ~= "false" and b or "", b2 ~= "false" and b2 or ""
	return b, (L"Slice #%d"):format(id), nil, nil, nil, nil, nil, b2
end
function subBindings:set(id, bind, bidx)
	local inPrefix, id, prefixLength = adjustBindingID(self.scope, id)
	if not inPrefix then
		return subBindings:setSliceBinding(id, bind, bidx, prefixLength)
	end
	config.undo:saveActiveProfile()
	local opt = self.options[id] .. (bidx == 2 and "2" or "")
	PC:SetOption(opt, bind or nil, self.scope)
	if bind == false and PC:GetOption(opt, self.scope) ~= "" then
		PC:SetOption(opt, "", self.scope)
	end
	if bind then
		subBindings:clearBinding(bind, opt)
	end
end
function subBindings:clearBinding(bind, exceptOpt)
	local scope, opts = self.scope, subBindings.options
	local _, startID, prefixLength = adjustBindingID(scope, 1)
	for i=startID, startID+prefixLength-1 do
		for j=1, 2 do
			local opt = j == 2 and opts[i] .. "2" or opts[i]
			if opt ~= exceptOpt and bind == PC:GetOption(opt, scope) then
				PC:SetOption(opt, nil, scope)
				if bind == PC:GetOption(opt, scope) then
					PC:SetOption(opt, "", scope)
				end
			end
		end
	end
end
function subBindings:setSliceBinding(sliceIdx, bind, bidx, prefixLength)
	if bind == nil then
		local i, s, s2 = 1, select(self.scope == nil and 5 or 4, PC:GetOption("SliceBindingString", self.scope))
		for f, f2 in (s or s2):gmatch("([^%s\31]+)\31?(%S*)") do
			if i == sliceIdx then
				bind = bidx == 2 and f2 or f
				bind = bind ~= "" and bind or nil
				break
			end
			i = i + 1
		end
	end

	local t, setIdx, setIdx2 = self.t, sliceIdx + (bidx == 2 and 0.5 or 0)
	t[setIdx], setIdx2 = bind or "false", setIdx - 0.5
	local o, nt, finalIndex = {}, {}
	for j=math.max(sliceIdx, #t), 1, -1 do
		local b1, b2 = t[j], t[j+0.5]
		local h1, h2 = b1 and b1 ~= "false" and b1 ~= "" and (b1 ~= bind or j == setIdx), b2 and b2 ~= "false" and b2 ~= "" and (b2 ~= bind or j == setIdx2)
		if (h1 and h2) then
			o[j], finalIndex = b1 .. "\31" .. b2, finalIndex or j
			nt[j], nt[j+0.5] = b1, b2
		elseif h1 or h2 or finalIndex then
			o[j], finalIndex = (h1 and b1 or h2 and b2 or "false"), finalIndex or j
			nt[j], nt[j+0.5] = o[j], ""
		end
	end
	
	self.t, self.count = nt, (finalIndex or 0) + prefixLength + 1
	local _, _, _, global, default = PC:GetOption("SliceBindingString", self.scope)
	local v = table.concat(o, " ")
	if self.scope == nil and v == default or
	   self.scope ~= nil and v == (global or default) then
		v = nil
	end
	config.undo:saveActiveProfile()
	PC:SetOption("SliceBindingString", v, self.scope)
	if bind then
		subBindings:clearBinding(bind, nil)
	end
end
local subBindings_List = {}
local function subBindings_ScopeClick(_, key)
	return bindSet.set(nil, subBindings, key or nil)
end
local function subBindings_ScopeFormat(key, list)
	return list[key], list[0] and (key or nil) == subBindings.scope
end
function subBindings:scopes(level, checked)
	local list = subBindings_List
	wipe(list) -- Reusing the table to maintain the scroll position key
	list[0], list[1], list[false] = checked, false, L"Defaults for all rings"
	local ct = T.OPC_RingScopePrefixes
	for key, name, scope in PC:IterateRings(true) do
		local color = ct and ct[scope] or "|cffacd7e6"
		list[#list+1], list[key] = key, (L"Ring: %s"):format(color .. (name or key) .. "|r")
	end
	XU:Create("ScrollableDropDownList", level, list, subBindings_ScopeFormat, subBindings_ScopeClick)
end
function subBindings:default()
	for i=0,#self.options do
		local on = i == 0 and "SliceBindingString" or self.options[i]
		PC:SetOption(on, nil)
		if self.scope then
			PC:SetOption(on, nil, self.scope)
		end
	end
end

local currentOwner, bindingTypes = ringBindings, {ringBindings, subBindings}
local function updatePanelContent()
	local m = currentOwner.count
	bindZoneBar:SetShown(m >= #bindLines)
	bindZoneBar:SetMinMaxValues(0, m >= #bindLines and m - #bindLines + 1 or 0)
	local csv = bindZoneBar:GetValue()
	local csPartial = csv % 1
	local csBase = csv - csPartial
	bindZoneOrigin:SetPoint("TOPLEFT", 0, csPartial*24)
	for i=1,#bindLines do
		local j, e, e2 = csBase+i, bindLines[i], bindLines2[i]
		if j > m then
			e:Hide()
			e2:Hide()
		else
			local binding, text, prefix, _, title, tip, showWarningIcon, binding2, prefix2, title2, tip2, warning2 = currentOwner:get(j)
			e.bindingName, e.tooltipTitle, e.tooltipText = text, title, tip
			e.label:SetText(text)
			e.warn:SetShown(showWarningIcon or warning2)
			e:SetBindingText(binding, prefix)
			e:SetID(j) e:Hide() e:Show()
			e2.bindingName, e2.tooltipTitle, e2.tooltipText = text, title2, tip2
			e2:SetBindingText(binding2, prefix2)
			e2:SetID(-j) e2:Hide() e2:Show()
		end
	end
	bindZone.OnBindingAltClick = currentOwner.altClick
	bindZone.OnBindingShiftClick = currentOwner.shiftClick
	UIDropDownMenu_SetText(bindSet, currentOwner.name .. (currentOwner.nameSuffix or ""))
end
function bindZone.SetBinding(buttonOrId, binding)
	local id, bidx = type(buttonOrId) == "number" and buttonOrId or buttonOrId:GetID()
	id, bidx = id < 0 and -id or id, id < 0 and 2 or 1
	currentOwner:set(id, binding, bidx)
	updatePanelContent()
end
bindZoneBar:SetScript("OnValueChanged", function(_, _, userEvent)
	if userEvent then
		updatePanelContent()
	end
end)

function bindSet:initialize(level)
	local info = {func=bindSet.set, minWidth=bindSet:GetWidth()-40}
	for i=1,#bindingTypes do
		local v = bindingTypes[i]
		if v.scopes then
			UIDropDownMenu_AddSeparator(level)
			info.text, info.isTitle, info.notCheckable, info.justifyH = v.name, true, true, "CENTER"
			UIDropDownMenu_AddButton(info, level)
			v:scopes(level, currentOwner == v)
		else
			info.notCheckable, info.isTitle, info.justifyH = nil
			info.text, info.arg1, info.checked = v.name, v, v == currentOwner
			UIDropDownMenu_AddButton(info, level)
		end
	end
end
function bindSet:set(owner, scope)
	currentOwner, bindZone.AllowWheelBinding = owner, owner and owner.allowWheel
	bindZoneBar:SetValue(0)
	if owner.refresh then owner:refresh(scope) end
	updatePanelContent()
	CloseDropDownMenus()
	frame.resetOnHide = nil
end

function frame.refresh()
	for _, v in pairs(bindingTypes) do
		if v.refresh then v:refresh(v.scope) end
	end
	OBC_Profile:text()
	updatePanelContent()
	config.checkSVState(frame)
end
function frame.default()
	config.undo:saveActiveProfile()
	for _, v in pairs(bindingTypes) do
		if v.default then v:default() end
	end
	frame.refresh()
end
local function resetView()
	currentOwner, frame.resetOnHide = ringBindings, nil
	bindZoneBar:SetValue(0)
	for _, v in pairs(bindingTypes) do
		v.scope = nil
	end
end
frame.okay, frame.cancel = resetView, resetView
frame:SetScript("OnShow", frame.refresh)
frame:SetScript("OnHide", function()
	if frame.resetOnHide then
		resetView()
	end
end)

function T.ShowSliceBindingPanel(ringKey)
	frame:OpenPanel()
	bindSet.set(nil, subBindings, ringKey)
	frame.resetOnHide = true
	config.pulseDropdown(bindSet)
end

T.AddSlashSuffix(function() frame:OpenPanel() end, "bind", "binding", "bindings")
T.AddSlashSuffix(function() T.ShowSliceBindingPanel(nil) end, "irbind")

function EV:OPIE_PROFILE_SWITCHED()
	if frame:IsVisible() then
		frame.refresh()
	end
end