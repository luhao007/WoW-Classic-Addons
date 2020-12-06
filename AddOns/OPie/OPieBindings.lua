local config, _, T = OneRingLib.ext.config, ...
local KR = OneRingLib.ext.ActionBook:compatible("Kindred", 1, 0)
local L = T.L

local frame = config.createPanel("Bindings", "OPie")
local OBC_Profile = CreateFrame("Frame", "OBC_Profile", frame, "UIDropDownMenuTemplate")
	OBC_Profile:SetPoint("TOPLEFT", 0, -85) UIDropDownMenu_SetWidth(OBC_Profile, 200)
	OBC_Profile.initialize = OPC_Profile.initialize
local bindSet = CreateFrame("Frame", "OPC_BindingSet", frame, "UIDropDownMenuTemplate")
	bindSet:SetPoint("LEFT", OBC_Profile, "RIGHT")	UIDropDownMenu_SetWidth(bindSet, 250)

local lRing = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
local lBinding = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	lBinding:SetPoint("TOPLEFT", 16, -125)
	lRing:SetPoint("LEFT", lBinding, "LEFT", 215, 0)
	lBinding:SetWidth(180)
local bindLines, bindZone = {}, CreateFrame("Frame", nil, frame) do
	bindZone.bindingContainerFrame = frame
	local function onMacroClick(self)
		bindZone.showMacroPopup(self:GetParent():GetID())
	end
	for i=1,19 do
		local bind = config.createBindingButton(bindZone)
		local label = bind:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		bind:SetPoint("TOPLEFT", lBinding, "BOTTOMLEFT", 0, 16-20*i)
		bind.macro = CreateFrame("Button", nil, bind, "UIPanelButtonTemplate")
		bind.macro:SetWidth(24) bind.macro:SetPoint("LEFT", bind, "RIGHT", 1, 0)
		local ico = bind.macro:CreateTexture(nil, "ARTWORK")
		ico:SetSize(23,23) ico:SetPoint("CENTER", -1, -1) ico:SetTexture("Interface\\RaidFrame\\UI-RaidFrame-Arrow")
		bind.macro:SetScript("OnClick", onMacroClick)
		bind:SetScript("OnEnter", config.ui.ShowControlTooltip)
		bind:SetScript("OnLeave", config.ui.HideTooltip)
		bind:SetWidth(180) bind:GetFontString():SetWidth(170)
		label:SetPoint("LEFT", 215, 2)
		bind:SetNormalFontObject(GameFontNormalSmall)
		bind:SetHighlightFontObject(GameFontHighlightSmall)
		bindLines[i], bind.label = bind, label
	end
end
local btnUnbind = config.createUnbindButton(bindZone)
	btnUnbind:SetPoint("TOP", bindLines[#bindLines], "BOTTOM", 0, -3)
local btnUp = CreateFrame("Button", nil, frame, "UIPanelScrollUpButtonTemplate")
	btnUp:SetPoint("RIGHT", btnUnbind, "LEFT", -10)
local btnDown = CreateFrame("Button", nil, frame, "UIPanelScrollDownButtonTemplate")
	btnDown:SetPoint("LEFT", btnUnbind, "RIGHT", 10)
local cap = bindZone
	cap:SetPoint("TOP", OBC_Profile, "BOTTOM", 0, 0)
	cap:SetPoint("LEFT", 5, 0)
	cap:SetPoint("RIGHT", -10, 0)
	cap:SetPoint("BOTTOM", btnUnbind, "TOP", 0, 2)
	cap:SetScript("OnMouseWheel", function(_, delta)
		local b = delta == 1 and btnUp or btnDown
		if b:IsEnabled() and not btnUnbind:IsEnabled() then b:Click() end
	end)

local ringBindings = {map={}, name=L"Ring Bindings", caption=L"Ring"}
function ringBindings:refresh()
	local pos, map = 1, self.map
	for key in OneRingLib:IterateRings(IsAltKeyDown()) do
		map[pos], pos = key, pos + 1
	end
	for i=#map,pos,-1 do
		map[i] = nil
	end
	self.count = #map
end
function ringBindings:get(id)
	local name, key = OneRingLib:GetRingInfo(self.map[id])
	local bind, cBind, isOverride, isActiveInt, isActiveExt = OneRingLib:GetRingBinding(key)
	local prefix, tipTitle, tipText
	local cebind = cBind or (bind and KR:EvaluateCmdOptions(bind))
	if not isOverride and not OneRingLib:GetOption("UseDefaultBindings", key) then
		if bind then
			prefix, tipTitle = "|cffa0a0a0", L"Default binding disabled"
			tipText = (L"Choose a binding for this ring, or enable the %s option in OPie options."):format("|cffffffff" .. L"Use default ring bindings" .. "|r")
		end
	elseif cBind and isActiveExt ~= true then
		tipTitle = L"Binding conflict"
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
		prefix, tipTitle, tipText = "|cffa0a0a0", L"Binding conflict", L"This binding is not currently active because it conflicts with another."
	elseif cBind and not isActiveInt then
		prefix, tipTitle = "|cffa0a0a0", tostring(isActiveInt) .. "/" .. tostring(cBind)
	elseif isOverride then
		prefix = "|cffffffff"
	end
	return bind, name or key or "?", prefix, cBind, tipTitle, tipText
end
function ringBindings:set(id, key)
	id = self.map[id]
	config.undo.saveProfile()
	OneRingLib:SetRingBinding(id, key)
end
function ringBindings:arrow(id)
	local name, key, macro = OneRingLib:GetRingInfo(self.map[id])
	local inputFrame = config.prompt(frame, name or key, (L"The following macro command opens this ring:"):format("|cffFFD029" .. (name or key) .. "|r"), false, false, nil, 0.90)
	inputFrame.editBox:SetText(macro)
	inputFrame.editBox:HighlightText(0, #macro)
	inputFrame.editBox:SetFocus()
end
function ringBindings:default()
	OneRingLib:ResetRingBindings()
end
function ringBindings:altClick() -- self is the binding button
	self:ToggleAlternateEditor(OneRingLib:GetRingBinding(ringBindings.map[self:GetID()]))
end

local subBindings = { name=L"In-Ring Bindings", caption=L"Action",
	options={"ScrollNestedRingUpButton", "ScrollNestedRingDownButton", "OpenNestedRingButton", "SelectedSliceBind"},
	optionNames={L"Scroll nested ring (up)", L"Scroll nested ring (down)", L"Open nested ring", L"Selected slice (keep ring open)"},
	count=0, t={},
}
function subBindings.allowWheel(btn)
	return btn:GetID() <= 2 and not subBindings.scope
end
function subBindings:refresh(scope)
	self.scope, self.nameSuffix = scope, scope and (" (|cffacd7e6" ..  (OneRingLib:GetRingInfo(scope or 1) or "") .. "|r)") or (" (" .. L"Defaults" .. ")")
	local t, ni = self.t, 1
	for s in OneRingLib:GetOption("SliceBindingString", scope):gmatch("%S+") do
		t[ni], ni = s, ni + 1
	end
	for i=#t,ni,-1 do t[i] = nil end
	subBindings.count = ni+(scope and 1 or 4)
end
function subBindings:get(id)
	local firstListSize = self.scope and 1 or 4
	if id <= firstListSize then
		id = (self.scope and 3 or 0) + id
		local value, setting = OneRingLib:GetOption(self.options[id], self.scope)
		return value, self.optionNames[id], setting and "|cffffffff" or nil
	else
		id = id - firstListSize
	end
	return self.t[id] == "false" and "" or self.t[id], (L"Slice #%d"):format(id)
end
function subBindings:set(id, bind)
	local firstListSize = self.scope and 1 or 4
	if id <= firstListSize then
		id = (self.scope and 3 or 0) + id
		config.undo.saveProfile()
		OneRingLib:SetOption(self.options[id], bind == false and "" or bind, self.scope)
		return
	else
		id = id - firstListSize
	end
	if bind == nil then
		local i, s, s2 = 1, select(self.scope == nil and 5 or 4, OneRingLib:GetOption("SliceBindingString", self.scope))
		for f in (s or s2):gmatch("%S+") do
			if i == id then bind = f break end
			i = i + 1
		end
	end

	local t, bind = self.t, bind or "false"
	if bind ~= "false" then
		for i=1,#t do
			if t[i] == bind then
				t[i] = "false"
			end
		end
	end
	t[id] = bind
	for j=#t,1,-1 do if t[j] == "false" then t[j] = nil else break end end
	self.count = #t+2
	local _, _, _, global, default = OneRingLib:GetOption("SliceBindingString", self.scope)
	local v = table.concat(t, " ")
	if self.scope == nil and v == default then v = nil
	elseif self.scope ~= nil and v == (global or default) then v = nil end
	config.undo.saveProfile()
	OneRingLib:SetOption("SliceBindingString", v, self.scope)
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
	for key, name, scope in OneRingLib:IterateRings(true) do
		local color = ct and ct[scope] or "|cffacd7e6"
		list[#list+1], list[key] = key, (L"Ring: %s"):format(color .. (name or key) .. "|r")
	end
	config.ui.scrollingDropdown:Display(level, list, subBindings_ScopeFormat, subBindings_ScopeClick)
end
function subBindings:default()
	for i=0,#self.options do
		local on = i == 0 and "SliceBindingString" or self.options[i]
		OneRingLib:SetOption(on, nil)
		if self.scope then
			OneRingLib:SetOption(on, nil, self.scope)
		end
	end
end

local currentOwner, currentBase, bindingTypes = ringBindings,0, {ringBindings, subBindings}
local function updatePanelContent()
	local m = currentOwner.count
	for i=1,#bindLines do
		local j, e = currentBase+i, bindLines[i]
		if j > m then
			e:Hide()
		else
			local binding, text, prefix, _, title, tip = currentOwner:get(j)
			e.tooltipTitle, e.tooltipText = title, tip
			e.label:SetText(text)
			e.macro:SetShown(currentOwner.arrow)
			e:SetBindingText(binding, prefix)
			e:SetID(j) e:Hide() e:Show()
		end
	end
	btnDown:SetEnabled(#bindLines + currentBase < m)
	btnUp:SetEnabled(currentBase > 0)
	lRing:SetText(currentOwner.caption)
	bindZone.OnBindingAltClick = currentOwner.altClick
	UIDropDownMenu_SetText(bindSet, currentOwner.name .. (currentOwner.nameSuffix or ""))
end
function bindZone.SetBinding(buttonOrId, binding)
	local id = type(buttonOrId) == "number" and buttonOrId or buttonOrId:GetID()
	currentOwner:set(id, binding)
	updatePanelContent()
end
function bindZone.showMacroPopup(id)
	return currentOwner:arrow(id)
end
local function scroll(self)
	currentBase = math.max(0, currentBase + (self == btnDown and 1 or -1))
	updatePanelContent()
end
btnDown:SetScript("OnClick", scroll) btnUp:SetScript("OnClick", scroll)

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
	currentOwner, currentBase, bindZone.AllowWheelBinding = owner, 0, owner and owner.allowWheel
	if owner.refresh then owner:refresh(scope) end
	updatePanelContent()
	CloseDropDownMenus()
	frame.resetOnHide = nil
end

function frame.localize()
	frame.name = L"Ring Bindings"
	frame.title:SetText(frame.name)
	frame.desc:SetText(L"Customize OPie key bindings below. |cffa0a0a0Gray|r and |cffFA2800red|r bindings conflict with others and are not currently active." .. "\n" ..
		(L"Alt+Left Click on a button to set a conditional binding, indicated by %s."):format("|cff4CFF40[+]|r"))
	lBinding:SetText(L"Binding")
	btnUnbind:SetText(L"Unbind")
	local p = OneRingLib:GetCurrentProfile()
	p = p == "default" and L"default" or p
	UIDropDownMenu_SetText(OBC_Profile, L"Profile" .. ": " .. p)
end
function frame.refresh()
	for _, v in pairs(bindingTypes) do
		if v.refresh then v:refresh() end
	end
	frame.localize()
	updatePanelContent()
	config.checkSVState(frame)
end
function frame.default()
	config.undo.saveProfile()
	for _, v in pairs(bindingTypes) do
		if v.default then v:default() end
	end
	frame.refresh()
end
function frame.okay()
	currentOwner, currentBase = ringBindings,0
end
frame.cancel = frame.okay
frame:SetScript("OnShow", frame.refresh)
frame:SetScript("OnHide", function()
	if frame.resetOnHide then
		frame.resetOnHide = nil
		currentOwner, currentBase = ringBindings,0
	end
end)

T.AddSlashSuffix(function() config.open(frame) end, "bind", "binding", "bindings")

function T.ShowSliceBindingPanel(ringKey)
	config.open(frame)
	bindSet.set(nil, subBindings, ringKey)
	frame.resetOnHide = true
	config.pulseDropdown(bindSet)
end