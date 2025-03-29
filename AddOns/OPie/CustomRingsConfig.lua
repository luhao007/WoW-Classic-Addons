local COMPAT, api, _, T = select(4,GetBuildInfo()), {}, ...
local PC, RK, ORI, L, config = T.OPieCore, T.RingKeeper, OPie.UI, T.L, T.config
local MODERN = COMPAT >= 11e4
local AB, EV, TS, XU = T.ActionBook:compatible(2,23), T.Evie, T.TenSettings, T.exUI
local GameTooltip = T.NotGameTooltip or GameTooltip
assert(PC and RK and ORI and AB and EV and TS and XU and L and 1, 'Incompatible library bundle')

local FULLNAME, SHORTNAME do
	function EV.PLAYER_LOGIN()
		local name, realm = UnitFullName("player")
		FULLNAME, SHORTNAME = name .. "-" .. realm, name
	end
end

local function prepEditBoxCancel(self)
	self.oldValue = self:GetText()
	if self.placeholder then self.placeholder:Hide() end
end
local function cancelEditBoxInput(self)
	local h = self:GetScript("OnEditFocusLost")
	self:SetText(self.oldValue or self:GetText())
	self:SetScript("OnEditFocusLost", nil)
	self:ClearFocus()
	self:SetScript("OnEditFocusLost", h)
	if self.placeholder and self:GetText() == "" then self.placeholder:Show() end
end
local function prepEditBox(self, save)
	if self:IsMultiLine() then
		self:SetScript("OnEscapePressed", self.ClearFocus)
	else
		self:SetScript("OnEditFocusGained", prepEditBoxCancel)
		self:SetScript("OnEscapePressed", cancelEditBoxInput)
		self:SetScript("OnEnterPressed", self.ClearFocus)
	end
	self:SetScript("OnEditFocusLost", save)
end
local function addIconSlotTextures(tex, sz)
	local p = tex:GetParent()
	local bg = p:CreateTexture(nil, "BACKGROUND", nil, -1)
	bg:SetTexture("Interface/Buttons/UI-EmptySlot-Disabled")
	bg:SetPoint("CENTER", tex, "CENTER")
	bg:SetSize(1.5*sz, 1.5*sz)
	local edge = p:CreateTexture(nil, "OVERLAY", nil, -1)
	edge:SetTexture("Interface/Buttons/UI-Quickslot2")
	edge:SetSize(1.625*sz, 1.625*sz)
	edge:SetPoint("CENTER", tex, "CENTER", 0.25, -0.25)
	if MODERN then
		local m = p:CreateMaskTexture()
		m:SetTexture("Interface/FrameGeneral/UIFrameIconMask")
		m:SetAllPoints(tex)
		tex:AddMaskTexture(m)
	end
	return bg, edge
end
local function createIconButton(name, parent, id, skipSlotDecorations)
	local f = CreateFrame("CheckButton", name, parent, nil, id or 0)
	f:SetSize(32,32)
	f:SetNormalTexture("")
	f:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
	f:GetHighlightTexture():SetBlendMode("ADD")
	f:SetCheckedTexture("Interface/Buttons/CheckButtonHilight")
	f:GetCheckedTexture():SetBlendMode("ADD")
	f:SetPushedTexture("Interface/Buttons/UI-Quickslot-Depress")
	f.tex = f:CreateTexture(nil, "ARTWORK")
	f.tex:SetAllPoints()
	if skipSlotDecorations ~= true then
		f.background, f.edge = addIconSlotTextures(f.tex, 32)
	end
	return f
end
local function PlayCheckboxSound(self)
	PlaySound(SOUNDKIT[self:GetChecked() and "IG_MAINMENU_OPTION_CHECKBOX_ON" or "IG_MAINMENU_OPTION_CHECKBOX_OFF"])
end
local function SetCursor(tex)
	tex = type(tex) == "string" and GetFileIDFromPath(tex) or tex
	_G.SetCursor(type(tex) == "number" and tex > 0 and tex or tex and 132761)
end
local CallSetRing
local function SaveRingVersion(name, liveData)
	local key = "RKRing#" .. name
	if not config.undo:search(key) then
		if liveData == true then
			liveData = RK:GetRingDescription(name) or false
		end
		config.undo:push(key, CallSetRing, name, liveData)
	end
end
function CallSetRing(msg, ...)
	if msg == "archive-unwind" then
		SaveRingVersion((...), true)
	end
	RK:SetRing(...)
end
local function CreateButton(parent, width)
	local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	btn:SetWidth(width or 150)
	return btn
end
local function setIcon(self, path, ext)
	local plainTexturePath, atlasName
	if type(path) == "string" and GetFileIDFromPath(path) == nil and C_Texture.GetAtlasInfo(path) then
		atlasName = path
		self:SetAtlas(path)
	else
		plainTexturePath = path
		self:SetTexture(path or "Interface/Icons/Inv_Misc_QuestionMark")
		self:SetTexCoord(0,1,0,1)
	end
	if ext then
		if type(ext.iconR) == "number" and type(ext.iconG) == "number" and type(ext.iconB) == "number" then
			self:SetVertexColor(ext.iconR, ext.iconG, ext.iconB)
		end
		if type(ext.iconCoords) == "table" then
			securecall(self.SetTexCoord, self, unpack(ext.iconCoords))
			plainTexturePath = nil
		elseif type(ext.iconCoords) == "function" or type(ext.iconCoords) == "userdata" then
			securecall(self.SetTexCoord, self, securecall(ext.iconCoords))
			plainTexturePath = nil
		end
	end
	return plainTexturePath, atlasName
end

local ringContainer, ringDetail, sliceDetail, newSlice, newRing, editorHost
local panel = TS:CreateOptionsPanel(L"Custom Rings", "OPie")
	panel.desc:SetText(L"Customize OPie by modifying existing rings, or creating your own.")
local ringDropDown = CreateFrame("Frame", "RKC_RingSelectionDropDown", panel, "UIDropDownMenuTemplate")
	ringDropDown:SetPoint("TOP", -70, -60)
	UIDropDownMenu_SetWidth(ringDropDown, 260)
local btnNewRing = CreateButton(panel)
	btnNewRing:SetPoint("LEFT", ringDropDown, "RIGHT", -5, 3)
	btnNewRing:SetText(L"New Ring...")
local dragBackdrop = CreateFrame("Frame") do
	dragBackdrop:Hide()
	dragBackdrop:SetFrameStrata("BACKGROUND")
	dragBackdrop:SetAllPoints()
	dragBackdrop:EnableMouse(true)
	dragBackdrop:SetScript("OnMouseDown", dragBackdrop.Hide)
end

newRing = CreateFrame("Frame") do
	newRing:SetSize(400, 115)
	newRing:Hide()
	local title = newRing:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	local modeToggles = XU:Create("OPie:RadioSet", nil, newRing)
	local name, snap = XU:Create("LineInput", nil, newRing), XU:Create("LineInput", nil, newRing)
	local nameLabel, snapLabel = newRing:CreateFontString(nil, "OVERLAY", "GameFontHighlight"), snap:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	local accept, cancel = CreateButton(newRing, 125), CreateButton(newRing, 125)
	local importNested = TS:CreateOptionsCheckButton(nil, newRing)
	local state = {buncount=0}
	title:SetPoint("TOP", 0, -3)
	modeToggles:SetPoint("TOP", 0, -25)
	name:SetPoint("TOPRIGHT", -15, -62)
	name:SetWidth(240)
	nameLabel:SetPoint("TOPLEFT", newRing, "TOPLEFT", 15, -67)
	snap:SetPoint("TOPRIGHT", -15, -85)
	snap:SetWidth(240)
	snapLabel:SetPoint("TOPLEFT", newRing, "TOPLEFT", 15, -90)
	accept:SetPoint("BOTTOMRIGHT", newRing, "BOTTOM", -2, 4)
	cancel:SetPoint("BOTTOMLEFT", newRing, "BOTTOM", 2, 4)
	importNested:SetScript("OnClick", PlayCheckboxSound)
	importNested:SetPoint("TOPLEFT", snap, "BOTTOMLEFT", -9, -2)
	importNested:SetHitRectInsets(0, -222, 0, 0)
	importNested:SetScript("OnHide", function(self) self:SetChecked(nil) end)
	
	snap:Hide()
	local function updateSnap(snapText, speculativeNameCheck)
		if state.snap == snapText and not speculativeNameCheck then
			return
		end
		local bc, ring, bun = 0, RK:GetSnapshotRing(snapText)
		if speculativeNameCheck == true and not ring then
			return
		end
		if type(bun) == "table" then
			for _,v in pairs(bun) do
				if type(v) == "table" then
					bc = bc + 1
				end
			end
		end
		state.snap, state.ring, state.bundle, state.buncount = snapText, ring, bun, bc
		if speculativeNameCheck == true then
			name:SetText("")
			snap:SetText(snapText)
			modeToggles:SetValue(2)
		end
		if state.ring and name:GetText() == "" then
			snap:SetCursorPosition(0)
			name:SetText(state.ring.name or "")
			name:SetFocus()
			name:HighlightText()
		end
		snap:SetTextColor((ring and GameFontGreen or ChatFontNormal):GetTextColor())
		importNested.Text:SetText((L"Import %s |4nested ring:nested rings;"):format(NORMAL_FONT_COLOR_CODE .. "|t" .. bc .. "|r"))
		return not not ring
	end
	local function validate()
		local nameText = name:GetText() or ""
		if modeToggles:GetValue() == 2 then
			updateSnap(snap:GetText() or "")
		elseif #nameText > 32 and nameText:match("^%s*oetohH7") then
			updateSnap(nameText, true)
		end
		local isSnapImport = modeToggles:GetValue() == 2
		local snapOK = state.ring and true or not isSnapImport
		local hasBundledRings = isSnapImport and state.ring and state.buncount ~= 0
		newRing:SetSize(400, hasBundledRings and 162 or isSnapImport and 140 or 115)
		snap:SetShown(isSnapImport)
		importNested:SetShown(hasBundledRings)
		accept:SetEnabled(type(nameText) == "string" and nameText:match("%S") and snapOK)
		if newRing:IsVisible() then
			TS:ShowFrameOverlay(panel, newRing)
		end
	end
	modeToggles:SetScript("OnValueChanged", function(_, nv)
		if nv == 1 then
			snap:SetText("")
		end
		if newRing:IsVisible() then
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			validate();
			(nv == 1 and name or snap):SetFocus()
		end
	end)
	local function navigate(self)
		if IsControlKeyDown() then
			modeToggles:SetValue(3-modeToggles:GetValue())
		elseif self ~= snap and snap:IsShown() then
			snap:SetFocus()
		else
			name:SetFocus()
		end
	end
	local function submit(self)
		if accept:IsEnabled() then
			accept:Click()
		else
			navigate(self)
		end
	end
	cancel:SetScript("OnClick", function() newRing:Hide() end)
	accept:SetScript("OnClick", function()
		if modeToggles:GetValue() == 1 then
			api.createRing(name:GetText(), {limit="PLAYER"})
			newRing:Hide()
		elseif api.createRing(name:GetText(), state.ring, state.bundle, importNested:GetChecked()) then
			newRing:Hide()
		end
	end)
	for i=1,2 do
		local v = i == 1 and name or snap
		v:SetScript("OnTabPressed", navigate)
		v:SetScript("OnEnterPressed", submit)
		v:SetScript("OnTextChanged", validate)
		v:SetScript("OnEditFocusLost", EditBox_ClearHighlight)
	end
	btnNewRing:SetScript("OnClick", function()
		title:SetText(L"Create a New Ring")
		modeToggles:SetOptionText(1, L"Empty ring")
		modeToggles:SetOptionText(2, L"Import snapshot")
		modeToggles:Reflow(375)
		nameLabel:SetText(L"Ring name:")
		snapLabel:SetText(L"Snapshot:")
		accept:SetText(L"Add Ring")
		cancel:SetText(L"Cancel")
		snap:SetText("")
		snap.cachedText, snap.cachedValue = nil
		name:SetText("")
		accept:Disable()
		importNested:SetChecked(false)
		TS:ShowFrameOverlay(panel, newRing)
		modeToggles:SetValue(1)
		name:SetFocus()
	end)
end

ringContainer = CreateFrame("Frame", nil, panel) do
	ringContainer:SetPoint("TOP", ringDropDown, "BOTTOM", 75, 0)
	ringContainer:SetPoint("BOTTOM", panel, 0, 6)
	ringContainer:SetPoint("LEFT", panel, 50, 0)
	ringContainer:SetPoint("RIGHT", panel, -10, 0)
	XU:Create("Backdrop", ringContainer, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", tile=true, edgeSize=14, edgeColor=0x7f7f7f})
	local function UpdateOnShow(self) self:SetScript("OnUpdate", nil) api.refreshDisplay() end
	ringContainer:SetScript("OnHide", function(self) if self:IsShown() then self:SetScript("OnUpdate", UpdateOnShow) end end)
	do -- up/down arrow buttons: ringContainer.prev and ringContainer.next
		local prev, next = CreateFrame("Button", nil, ringContainer), CreateFrame("Button", nil, ringContainer)
		prev:SetSize(22, 22) next:SetSize(22, 22)
		next:SetPoint("TOPRIGHT", ringContainer, "TOPLEFT", 2, 0)
		prev:SetPoint("RIGHT", next, "LEFT", 4, 0)
		prev:SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollUp-Up")
		prev:SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollUp-Down")
		prev:SetDisabledTexture("Interface/ChatFrame/UI-ChatIcon-ScrollUp-Disabled")
		prev:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
		next:SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Up")
		next:SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Down")
		next:SetDisabledTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Disabled")
		next:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
		next:SetID(1) prev:SetID(-1)
		local function handler(self) api.scrollSliceList(self:GetID()) end
		next:SetScript("OnClick", handler) prev:SetScript("OnClick", handler)
		ringContainer.prev, ringContainer.next = prev, next
		local cap = CreateFrame("Frame", nil, ringContainer)
		cap:SetPoint("TOPLEFT", ringContainer, "TOPLEFT", -38, 0)
		cap:SetPoint("BOTTOMRIGHT", ringContainer, "BOTTOMLEFT", -1, 0)
		cap:SetScript("OnMouseWheel", function(_, delta)
			local b = delta == 1 and prev or next
			if b:IsEnabled() then b:Click() end
		end)
	end
	ringContainer.slices = {} do
		local function onClick(self)
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			api.selectSlice(self:GetID(), self:GetChecked())
		end
		local function dragStart(self)
			if ringContainer.disableSliceDrag then return end
			PlaySound(832)
			self.source = api.resolveSliceOffset(self:GetID())
			dragBackdrop:Show()
			SetCursor(self.plainTex or "Interface/Icons/Temp")
		end
		local function dragAbort(self)
			local src = self.source
			if src then
				SetCursor(nil)
				dragBackdrop:Hide()
				self.source = nil
			end
			return src
		end
		local function dragStop(self)
			local source = dragAbort(self)
			if ringContainer.disableSliceDrag then return end
			local x, y = GetCursorPosition()
			PlaySound(833)
			local scale, l, b, w, h = self:GetEffectiveScale(), self:GetRect()
			local dy, dx = math.floor(-(y / scale - b - h-1)/(h+2)), x / scale - l
			if dx < -2*w or dx > 2*w then return api.deleteSlice(source) end
			if dx < -w/2 or dx > 3*w/2 then return end
			local dest = self:GetID() + dy
			if not ringContainer.slices[dest+1] or not ringContainer.slices[dest+1]:IsShown() then return end
			dest = api.resolveSliceOffset(dest)
			if dest ~= source then api.moveSlice(source, dest) end
		end
		for i=0,11 do
			local ico = createIconButton(nil, ringContainer, i)
			ico:SetPoint("TOP", ringContainer.prev, "BOTTOMRIGHT", -2, -34*i)
			ico:SetScript("OnClick", onClick)
			ico:RegisterForDrag("LeftButton")
			ico:SetScript("OnDragStart", dragStart)
			ico:SetScript("OnDragStop", dragStop)
			ico:SetScript("OnHide", dragAbort)
			ico.check = ico:CreateTexture(nil, "OVERLAY")
			ico.check:SetSize(8,8) ico.check:SetPoint("BOTTOMRIGHT", -1, 1)
			ico.check:SetTexture("Interface/FriendsFrame/StatusIcon-Online")
			ico.auto = ico:CreateTexture(nil, "OVERLAY", nil, 4)
			ico.auto:SetAllPoints()
			ico.auto:SetTexture("Interface/Buttons/UI-AutoCastableOverlay")
			ico.auto:SetTexCoord(14/64, 49/64, 14/64, 49/64)
			ringContainer.slices[i+1] = ico
		end
	end
	ringContainer.newSlice = createIconButton(nil, ringContainer, nil, true) do
		local b = ringContainer.newSlice
		b:SetSize(24,24)
		b.tex:SetTexture("Interface/GuildBankFrame/UI-GuildBankFrame-NewTab")
		b:SetScript("OnClick", function(self)
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			config.ui.HideTooltip(self)
			if IsAltKeyDown() then
				self:SetChecked(not self:GetChecked())
				TS:ShowPromptOverlay(panel, L"Custom slice", L"Input a slice action specification:", (L"Example: %s."):format(GREEN_FONT_COLOR_CODE .. '"item", 19019|r'), nil, api.addCustomSlice, 0.95)
				return
			end
			if newSlice:IsShown() then
				return api.closeActionPicker("add-new-slice-button")
			end
			if sliceDetail:IsShown() then
				api.selectSlice()
				for i=1,#ringContainer.slices do
					ringContainer.slices[i]:SetChecked(nil)
				end
			end
			ringDetail:Hide()
			api.endSliceRepick()
			newSlice:Show()
		end)
		b:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("LEFT", self, "RIGHT", 2, 0)
			GameTooltip:AddLine(L"Add a new slice", 1, 1, 1)
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", config.ui.HideTooltip)
		b:SetPoint("TOP", ringContainer.slices[12], "BOTTOM", 0, -2)
	end
end
ringDetail = CreateFrame("Frame", nil, ringContainer) do
	ringDetail:SetAllPoints()
	TS:EscapeCallback(ringDetail, function() api.deselectRing() end)
	ringDetail.name = CreateFrame("EditBox", nil, ringDetail) do
		local e = ringDetail.name
		e:SetHeight(24)
		e:SetPoint("TOPLEFT", 5, -5)
		e:SetPoint("TOPRIGHT", -5, -5)
		e:SetTextInsets(2,2,2,2)
		e:SetFontObject(GameFontNormalLarge)
		e:SetAutoFocus(false)
		prepEditBox(e, function(self) api.setRingProperty("name", self:GetText()) end)
		local ht = e:CreateTexture(nil, "BACKGROUND", nil, -3)
		ht:SetColorTexture(1,1,1,0.08)
		ht:SetAllPoints()
		ht:Hide()
		local function hideHilight() ht:Hide() end
		e:SetScript("OnEnter", function(self) if not self:HasFocus() then ht:Show() end end)
		e:SetScript("OnLeave", hideHilight)
		e:HookScript("OnEditFocusGained", hideHilight)
	end
	local tex = ringDetail.name:CreateTexture()
	tex:SetHeight(1) tex:SetPoint("BOTTOMLEFT", 0, -2) tex:SetPoint("BOTTOMRIGHT", 0, -2)
	tex:SetColorTexture(1,0.82,0, 0.5)
	ringDetail.scope = CreateFrame("Frame", "RKC_RingScopeDropDown", ringDetail, "UIDropDownMenuTemplate")
	ringDetail.scope:SetPoint("TOPLEFT", 250, -37) UIDropDownMenu_SetWidth(ringDetail.scope, 250)
	ringDetail.scope.label = ringDetail.scope:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	ringDetail.scope.label:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 10, -47)
	ringDetail.scope.label:SetText(L"Make this ring available to:")
	ringDetail.binding = config.createBindingButton(ringDetail)
	ringDetail.bindingContainerFrame = panel
	ringDetail.binding:SetPoint("TOPLEFT", 267, -68) ringDetail.binding:SetWidth(265)
	function ringDetail:SetBinding(bind) return api.setRingBinding(bind or false) end
	function ringDetail:OnBindingAltClick() self:ToggleAlternateEditor(api.getRingBinding()) end
	ringDetail.binding.label = ringDetail.scope:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	ringDetail.binding.label:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 10, -73)
	ringDetail.binding.label:SetText(L"Binding:")
	do -- ringDetail.rotation
		local s, sliderLeftMargin, centerLine = TS:CreateOptionsSlider(ringDetail, nil, 250)
		s:SetPoint("TOPLEFT", 270-sliderLeftMargin, -95)
		s:SetMinMaxValues(0, 345)
		s:SetValueStep(15)
		s:SetObeyStepOnDrag(true)
		s:SetScript("OnValueChanged", function(_, value) api.setRingProperty("offset", value) end)
		s.lo:SetText("0°")
		s.hi:SetText("345°")
		s.text:SetPoint("LEFT", ringDetail, "TOPLEFT", 10, -95-centerLine)
		s.text:SetText(L"Rotation:")
		s.text:Show()
		ringDetail.rotation, s.label = s, s.text
	end
	ringDetail.opportunistCA = TS:CreateOptionsCheckButton(nil, ringDetail)
	ringDetail.opportunistCA:SetPoint("TOPLEFT", 266, -118)
	ringDetail.opportunistCA:SetMotionScriptsWhileDisabled(1)
	ringDetail.opportunistCA.Text:SetText(L"Pre-select a quick action slice")
	ringDetail.opportunistCA:SetScript("OnEnter", config.ui.ShowControlTooltip)
	ringDetail.opportunistCA:SetScript("OnLeave", config.ui.HideTooltip)
	ringDetail.opportunistCA:SetScript("OnClick", function(self) PlayCheckboxSound(self) api.setRingProperty("noOpportunisticCA", (not self:GetChecked()) or nil) api.setRingProperty("noPersistentCA", (not self:GetChecked()) or nil) end)
	ringDetail.hiddenRing = TS:CreateOptionsCheckButton(nil, ringDetail)
	ringDetail.hiddenRing:SetPoint("TOPLEFT", ringDetail.opportunistCA, "BOTTOMLEFT", 0, 2)
	ringDetail.hiddenRing.Text:SetText(L"Hide this ring")
	ringDetail.hiddenRing:SetScript("OnClick", function(self) PlayCheckboxSound(self) api.setRingProperty("internal", self:GetChecked() and true or nil) end)
	ringDetail.embedRing = TS:CreateOptionsCheckButton(nil, ringDetail)
	ringDetail.embedRing:SetPoint("TOPLEFT", ringDetail.hiddenRing, "BOTTOMLEFT", 0, 2)
	ringDetail.embedRing.Text:SetText(L"Embed into other rings by default")
	ringDetail.embedRing:SetScript("OnClick", function(self) PlayCheckboxSound(self) api.setRingProperty("embed", self:GetChecked() and true or nil) end)
	ringDetail.firstOnOpen = TS:CreateOptionsCheckButton(nil, ringDetail) do
		local f = ringDetail.firstOnOpen
		f:SetPoint("TOPLEFT", ringDetail.embedRing, "BOTTOMLEFT", 0, 2)
		f:SetMotionScriptsWhileDisabled(1)
		f.Text:SetText(L"Use first slice when opened")
		f:SetScript("OnClick", function(self)
			PlayCheckboxSound(self)
			self.quarantineMark:Hide()
			api.setRingProperty("onOpen", self:GetChecked() and 1 or nil)
		end)
		f.quarantineMark = f:CreateTexture(nil, "ARTWORK")
		f.quarantineMark:SetAllPoints()
		f.quarantineMark:SetTexture(f:GetCheckedTexture():GetTexture())
		f.quarantineMark:SetDesaturated(true)
		f.quarantineMark:SetVertexColor(1, 0.95, 0.85, 0.65)
	end

	ringDetail.optionsLabel = ringDetail:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	ringDetail.optionsLabel:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 10, -125)
	ringDetail.optionsLabel:SetText(L"Options:")

	ringDetail.editBindings = CreateButton(ringDetail, 210)
	ringDetail.editBindings:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 292, -214)
	ringDetail.editBindings:SetText(L"Customize bindings")
	ringDetail.editBindings:SetScript("OnClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.showExternalEditor("slice-binding") end)

	ringDetail.editOptions = CreateButton(ringDetail, 210)
	ringDetail.editOptions:SetPoint("TOPLEFT", ringDetail.editBindings, "BOTTOMLEFT", 0, -2)
	ringDetail.editOptions:SetText(L"Customize options")
	ringDetail.editOptions:SetScript("OnClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.showExternalEditor("opie-options") end)

	ringDetail.shareLabel = ringDetail:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	ringDetail.shareLabel:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 10, -265)
	ringDetail.shareLabel:SetText(L"Snapshot:")
	ringDetail.shareLabel2 = ringDetail:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallLeft")
	ringDetail.shareLabel2:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 270, -265)
	ringDetail.shareLabel2:SetWidth(275)
	ringDetail.export = CreateButton(ringDetail)
	ringDetail.export:SetPoint("TOP", ringDetail.shareLabel2, "BOTTOM", 0, -4)
	ringDetail.export:SetText(L"Share ring")
	ringDetail.export:SetScript("OnClick", function(self) PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.exportRing(self.nested:IsShown() and self.nested:GetChecked() and true) end)
	ringDetail.export.nested = TS:CreateOptionsCheckButton(nil, ringDetail.export) do
		local f = ringDetail.export.nested
		f:SetPoint("TOPLEFT", ringDetail.shareLabel2, "BOTTOMLEFT", -4, -1)
		f.Text:SetText(L"Include nested rings")
		local function moveExportButton(self)
			ringDetail.export:SetPoint("TOP", ringDetail.shareLabel2, "BOTTOM", 0, self:IsVisible() and -22 or -4)
		end
		f:SetScript("OnClick", PlayCheckboxSound)
		f:SetScript("OnShow", moveExportButton)
		f:SetScript("OnHide", moveExportButton)
	end
	
	local textArea = XU:Create("TextArea", "RKC_ExportInput", ringDetail)
	textArea:SetStyle("tooltip")
	textArea:SetSize(265, 124)
	textArea:Hide()
	textArea:SetPoint("TOPLEFT", ringDetail.shareLabel2, "BOTTOMLEFT", -2, -2)
	ringDetail.exportArea = textArea
	textArea:SetFontObject(GameFontHighlightSmall)
	textArea:SetScript("OnEscapePressed", function() textArea:Hide() ringDetail.export:Show() end)
	textArea:SetScript("OnChar", function(self) local text = self:GetText() if text ~= "" and text ~= self.text then self:SetText(self.text or "") self:SetCursorPosition(0) self:HighlightText() end end)
	textArea:SetScript("OnTextSet", function(self) self.text = self:GetText() end)
	textArea:SetScript("OnHide", function(self)
		self:Hide()
		ringDetail.export:Show()
		ringDetail.shareLabel2:SetText(L"Take a snapshot of this ring to share it with others.")
	end)
	textArea:SetScript("OnShow", function()
		ringDetail.export:Hide()
		ringDetail.shareLabel2:SetText((L"Import snapshots by clicking %s above."):format(NORMAL_FONT_COLOR_CODE .. L"New Ring..." .. "|r"))
	end)
	
	ringDetail.remove = CreateButton(ringDetail)
	ringDetail.remove:SetPoint("BOTTOMRIGHT", -10, 10)
	ringDetail.remove:SetText(L"Delete ring")
	ringDetail.remove:SetScript("OnClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.deleteRing() end)
	
	ringDetail.restore = CreateButton(ringDetail)
	ringDetail.restore:SetPoint("RIGHT", ringDetail.remove, "LEFT", -20, 0)
	ringDetail.restore:SetText(L"Restore default")
	ringDetail.restore:SetScript("OnClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.restoreDefault() end)

	ringDetail:Hide()
end
sliceDetail = CreateFrame("Frame", nil, ringContainer) do
	sliceDetail:SetAllPoints()
	sliceDetail.desc = sliceDetail:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	sliceDetail.desc:SetPoint("TOPLEFT", 7, -9) sliceDetail.desc:SetPoint("TOPRIGHT", -7, -7) sliceDetail.desc:SetJustifyH("LEFT")
	TS:EscapeCallback(sliceDetail, "TAB", function(_, key)
		if sliceDetail.iconSelector:IsShown() then
			if key == "TAB" then
				sliceDetail.iconSelector:FocusManualInput()
			else
				sliceDetail.iconSelector:Hide()
			end
		elseif key == "ESCAPE" then
			api.selectSlice()
		end
	end)
	local oy = 37
	sliceDetail.skipSpecs = CreateFrame("Frame", "RKC_SkipSpecDropdown", sliceDetail, "UIDropDownMenuTemplate") do
		local s = sliceDetail.skipSpecs
		s:SetPoint("TOPLEFT", 250, -oy)
		UIDropDownMenu_SetWidth(s, 250)
		oy = oy + 31
		s.label = s:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		s.label:SetPoint("BOTTOMLEFT", sliceDetail, "TOPLEFT", 10, 9-oy)
		s.label:SetText(L"Show this slice for:")
	end
	sliceDetail.showConditional = XU:Create("LineInput", nil, sliceDetail) do
		local c = sliceDetail.showConditional
		c:SetWidth(260)
		c:SetPoint("TOPLEFT", 274, -oy)
		oy = oy + 23
		c.label = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		c.label:SetPoint("BOTTOMLEFT", sliceDetail, "TOPLEFT", 10, 6-oy)
		c.label:SetText(L"Visibility conditional:")
		prepEditBox(c, function(self) api.setSliceProperty("show", self:GetText()) end)
		c:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:AddLine(L"Conditional Visibility")
			GameTooltip:AddLine((L"If this macro conditional evaluates to %s, or if none of its clauses apply, this slice will be hidden."):format(GREEN_FONT_COLOR_CODE .. "hide" .. "|r"), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
			GameTooltip:AddLine((L"You may use extended macro conditionals; see %s for details."):format("|cff33DDFFhttps://townlong-yak.com/addons/opie/extended-conditionals|r"), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
			GameTooltip:AddLine((L"Example: %s."):format(GREEN_FONT_COLOR_CODE .. "[nocombat][mod]|r"), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			GameTooltip:AddLine((L"Example: %s."):format(GREEN_FONT_COLOR_CODE .. "[combat,@target,noexists] hide; show|r"), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			GameTooltip:Show()
		end)
		c:SetScript("OnLeave", config.ui.HideTooltip)
	end
	sliceDetail.shortLabel = XU:Create("LineInput", nil, sliceDetail) do
		local c = sliceDetail.shortLabel
		c:SetWidth(85)
		c:SetPoint("TOPLEFT", 274, -oy)
		oy = oy + 23
		c.label = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		c.label:SetPoint("BOTTOMLEFT", sliceDetail, "TOPLEFT", 10, 6-oy)
		c.label:SetText(L"Override label:")
		prepEditBox(c, function(self)
			local tx = self:GetText()
			api.setSliceProperty("label", tx ~= "" and tx or nil)
		end)
	end
	sliceDetail.color = XU:Create("LineInput", nil, sliceDetail) do
		local c = sliceDetail.color
		c:SetPoint("TOPLEFT", 274, -oy)
		c:SetWidth(85)
		oy = oy + 23
		c:SetTextInsets(22, 0, 0, 0) c:SetMaxBytes(7)
		prepEditBox(c, function(self)
			local r,g,b = self:GetText():match("(%x%x)(%x%x)(%x%x)")
			if self:GetText() == "" then
				api.setSliceProperty("color")
			elseif not r then
				if self.oldValue == "" then self.placeholder:Show() end
				self:SetText(self.oldValue)
			else
				api.setSliceProperty("color", tonumber(r,16)/255, tonumber(g,16)/255, tonumber(b,16)/255)
			end
		end)
		c.label = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		c.label:SetPoint("BOTTOMLEFT", sliceDetail, "TOPLEFT", 10, 6-oy)
		c.label:SetText(L"Color:")
		c.placeholder = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		c.placeholder:SetPoint("LEFT", 18, 0)
		c.placeholder:SetText("|cffa0a0a0" .. L"(default)")
		c.button = CreateFrame("Button", nil, c)
		local b = sliceDetail.color.button
		b:SetSize(14, 14) b:SetPoint("LEFT")
		b.bg = sliceDetail.color.button:CreateTexture(nil, "BACKGROUND")
		b.bg:SetSize(12, 12) b.bg:SetPoint("CENTER")
		b.bg:SetColorTexture(1,1,1)
		b.bg:SetSnapToPixelGrid(false)
		b.bg:SetTexelSnappingBias(0)
		b:SetNormalTexture("Interface/ChatFrame/ChatFrameColorSwatch")
		b:SetScript("OnEnter", function(self) self.bg:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b) end)
		b:SetScript("OnLeave", function(self) self.bg:SetVertexColor(1, 1, 1) end)
		b:SetScript("OnShow", b:GetScript("OnLeave"))
		local ctex = b:GetNormalTexture()
		ctex:SetSnapToPixelGrid(false)
		ctex:SetTexelSnappingBias(0)
		local function update()
			if not ColorPickerFrame:IsShown() or ColorPickerFrame.Footer and ColorPickerFrame.Footer.OkayButton:GetButtonState() == "PUSHED" then
				api.setSliceProperty("color", ColorPickerFrame:GetColorRGB())
			end
		end
		b:SetScript("OnClick", function()
			local cp, r,g,b = ColorPickerFrame, ctex:GetVertexColor()
			cp.previousValues, cp.hasOpacity, cp.func, cp.cancelFunc, cp.swatchFunc, cp.opacityFunc = true
			if cp.SetColorRGB then
				cp:SetColorRGB(r,g,b)
				cp.func = update
			else
				cp.Content.ColorSwatchOriginal:SetColorTexture(r,g,b)
				cp.Content.HexBox:OnColorSelect(r,g,b)
				cp.Content.ColorPicker:SetColorRGB(r,g,b)
				cp.swatchFunc = update
			end
			cp:Show()
		end)
		local ceil = math.ceil
		function c:SetColor(r,g,b, custom)
			if r and g and b and custom then
				c:SetText(("%02X%02X%02X"):format(ceil((r or 0)*255),ceil((g or 0)*255),ceil((b or 0)*255)))
				c.placeholder:Hide()
			else
				c:SetText("")
				c.placeholder:Show()
			end
			ctex:SetVertexColor(r or 0,g or 0,b or 0)
		end
	end
	sliceDetail.icon = CreateFrame("Button", nil, sliceDetail) do
		local f = sliceDetail.icon
		f:SetHitRectInsets(0,-280,0,0) f:SetSize(18, 18)
		f:SetPoint("TOPLEFT", 270, -oy-2)
		oy = oy + 23
		f:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		f:SetNormalFontObject(GameFontHighlight) f:SetHighlightFontObject(GameFontGreen) f:SetPushedTextOffset(3/4, -3/4)
		f:SetText(" ") f:GetFontString():ClearAllPoints() f:GetFontString():SetPoint("LEFT", f, "RIGHT", 4, 0)
		f.icon = f:CreateTexture() f.icon:SetAllPoints()
		f.label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		f.label:SetPoint("BOTTOMLEFT", sliceDetail, "TOPLEFT", 10, 6-oy)
		f.label:SetText(L"Icon:")
		
		local isd = XU:Create("IconSelector", nil, sliceDetail)
		isd:SetPoint("TOPLEFT", f, "TOPLEFT", -268, -18)
		isd:SetManualInputHintText("|cffa0a0a0" .. L"(enter an icon name or path here)")
		sliceDetail.iconSelector = isd
		f:SetScript("OnClick", function()
			isd:SetShown(not isd:IsShown())
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		end)
		isd:SetScript("OnIconSelect", function(_, asset)
			api.setSliceProperty("icon", asset)
		end)
		isd:SetScript("OnEditFocusGained", function(self, editbox)
			local nc = NORMAL_FONT_COLOR
			GameTooltip:SetOwner(editbox, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMLEFT", editbox, "TOPLEFT", -6, 0)
			GameTooltip:AddLine(L"Override Icon", 1,1,1)
			GameTooltip:AddLine(L"Specify an icon by entering an icon file name, texture path, atlas name, or a known ability name.", nc.r, nc.g, nc.b, 1)
			if self:IsSearchPossible() then
				GameTooltip:AddLine((L"Press %s to search"):format(HIGHLIGHT_FONT_COLOR_CODE .. GetBindingText("ALT-ENTER") .. "|r"), nc.r, nc.g, nc.b, 1)
			else
				local at = HIGHLIGHT_FONT_COLOR_CODE .. "IconFileNames |cff606060<|cff40a0ffhttps://townlong-yak.com/addons/iconfilenames|r>|r|r"
				GameTooltip:AddLine((L"Install and enable %s to search by file name."):format(at), nc.r, nc.g, nc.b, 1)
			end
			GameTooltip:Show()
		end)
		isd:SetScript("OnEditFocusLost", function(_, editbox)
			if GameTooltip:IsOwned(editbox) then
				GameTooltip:Hide()
			end
		end)
		function f:SetIcon(ico, forced, ext)
			local plainTexture, atlas = setIcon(self.icon, forced or ico, ext)
			self:SetText(forced and L"Customized icon" or L"Based on slice action")
			isd:SetFirstAsset(atlas or plainTexture)
			isd:SetSelectedAsset(forced)
		end
	end
	sliceDetail.fastClick = TS:CreateOptionsCheckButton(nil, sliceDetail) do
		local e = sliceDetail.fastClick
		e:SetHitRectInsets(0, -200, 4, 4) e:SetMotionScriptsWhileDisabled(1)
		e:SetPoint("TOPLEFT", 266, -oy)
		oy = oy + 23
		e:SetScript("OnClick", function(self) PlayCheckboxSound(self) return api.setSliceProperty("fastClick", self:GetChecked() and true or nil) end)
		e:SetScript("OnEnter", config.ui.ShowControlTooltip)
		e:SetScript("OnLeave", config.ui.HideTooltip)
		e.Text:SetText(L"Allow as quick action")
		e.label = sliceDetail:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		e.label:SetPoint("BOTTOMLEFT", sliceDetail, "TOPLEFT", 10, 6-oy)
		e.label:SetText(L"Options:")
	end
	sliceDetail.collectionDrop = CreateFrame("Frame", "RKC_SliceOptions_Collection", sliceDetail, "UIDropDownMenuTemplate") do
		local w = sliceDetail.collectionDrop
		w:SetPoint("TOPLEFT", 250, -oy)
		UIDropDownMenu_SetWidth(w, 250)
		w.label = w:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		w.label:SetText(L"Display as:")
		w.label:SetPoint("LEFT", -240, 0)
		local modes = {
			false, "cycle", "shuffle", "random", "reset", "jump",
			[false]=L"Remember last rotation",
			cycle=L"Advance rotation after use",
			shuffle=L"Randomize rotation after use",
			random=L"Randomize rotation on display",
			reset=L"Reset rotation on display",
			jump=L"Display a jump slice",
		}
		function w:set(opt)
			if opt == "default" then
				w.rotationMode, w.embed = nil, nil
			elseif opt == "embed" then
				w.embed, w.rotationMode = true, nil
			else
				w.rotationMode, w.embed = opt, nil
				if opt == nil then
					w.embed = false
				end
			end
			api.setSliceProperty("rotationMode", opt, w.embed)
			w:text()
		end
		function w:text()
			local text, mode = "", modes[self.rotationMode or false]
			if self.embed == nil and self.rotationMode == nil then
				text = L"Not customized"
			elseif self.embed then
				text = L"Embed slices in this ring"
			elseif self.rotationMode == "jump" then
				text = mode
			elseif mode then
				text = (NORMAL_FONT_COLOR_CODE .. L"Nested ring: %s"):format("|r" .. mode)
			end
			UIDropDownMenu_SetText(self, text)
		end
		function w:initialize()
			local info = {minWidth=self:GetWidth()-40, func=w.set}
			local isNotEmbed, isDefault = not self.embed, self.embed == nil and self.rotationMode == nil
			info.text, info.arg1, info.checked = L"Not customized", "default", isDefault
			UIDropDownMenu_AddButton(info)
			UIDropDownMenu_AddSeparator()
			info.text, info.isTitle, info.notCheckable = L"Display as a nested ring", true, true
			UIDropDownMenu_AddButton(info)
			info.isTitle, info.disabled, info.notCheckable = nil
			for i=1,#modes do
				local v = modes[i]
				info.arg1, info.text = v or nil, modes[v]
				info.checked = isNotEmbed and self.rotationMode == (v or nil) and not isDefault
				if v == "jump" then
					UIDropDownMenu_AddSeparator()
				end
				UIDropDownMenu_AddButton(info)
			end
			UIDropDownMenu_AddSeparator()
			info.arg1, info.text = "embed", L"Embed slices in this ring"
			info.checked = not isNotEmbed
			UIDropDownMenu_AddButton(info)
		end
	end
	
	do -- .editorContainer
		local f; f, editorHost = AB:CreateEditorHost(sliceDetail)
		f:SetPoint("TOPLEFT", sliceDetail.fastClick.label, "BOTTOMLEFT", 0, -10)
		f:SetPoint("BOTTOMRIGHT", -10, 36)
		f.optionsColumnOffset = 256
		function f:OnActionChanged(ed)
			return editorHost:IsCurrentEditor(ed) and api.setSliceAction()
		end
		function f:SetVerticalOffset(ofsY)
			f:SetPoint("TOPLEFT", sliceDetail.fastClick.label, "BOTTOMLEFT", 0, -6-ofsY)
		end
		sliceDetail.editorContainer = f
	end
	sliceDetail.remove = CreateButton(sliceDetail)
	sliceDetail.remove:SetPoint("BOTTOMRIGHT", -10, 10)
	sliceDetail.remove:SetText(L"Delete slice")
	sliceDetail.remove:SetScript("OnClick", function() return api.deleteSlice() end)
	sliceDetail.repick = CreateButton(sliceDetail)
	sliceDetail.repick:SetPoint("BOTTOMLEFT", 10, 10)
	sliceDetail.repick:SetText(L"Change action")
	sliceDetail.repick:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		return api.beginSliceRepick()
	end)
	sliceDetail.restore = CreateButton(sliceDetail)
	sliceDetail.restore:SetPoint("RIGHT", sliceDetail.remove, "LEFT", -20, 0)
	sliceDetail.restore:SetText(L"Restore default")
	sliceDetail.restore:SetScript("OnClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.restoreSliceDefault() end)
end
newSlice = CreateFrame("Frame", nil, ringContainer) do
	newSlice:SetAllPoints()
	newSlice:Hide()
	local NUM_VISIBLE_CATS, NUM_VISIBLE_ACTION_ROWS = 22, 12
	newSlice.slider = XU:Create("ScrollBar", nil, newSlice) do
		local s = newSlice.slider
		s:SetPoint("TOPLEFT", 162, -3)
		s:SetPoint("BOTTOMLEFT", 162, 3)
		s:SetMinMaxValues(0, 20)
		s:SetValueStep(1)
		s:SetWindowRange(NUM_VISIBLE_CATS)
		s:SetStepsPerPage(5)
		s:SetStyle("common")
	end
	
	local cats, actions, searchCat, selectCategory, selectedCategory, selectedCategoryId = {}, {}
	local performSearch do
		local function matchAction(q, ...)
			local _, aname = AB:GetActionDescription(...)
			if type(aname) ~= "string" then return end
			aname = aname:match("|") and aname:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", ""):lower() or aname:lower()
			return not not aname:match(q)
		end
		function performSearch(query, inCurrentCategory)
			searchCat = selectedCategory
			if not inCurrentCategory then
				searchCat = AB:GetCategoryContents(1)
				for i=2,AB:GetNumCategories() do
					searchCat = AB:GetCategoryContents(i, searchCat)
				end
			end
			searchCat:filter(matchAction, query:lower())
			selectCategory(-1)
		end
	end
	do -- newSlice.search
		local s = XU:Create("LineInput", nil, newSlice)
		s:SetWidth(153)
		s:SetPoint("TOPLEFT", 7, -1) s:SetTextInsets(16, 0, 0, 0)
		local i = s:CreateTexture(nil, "OVERLAY")
		i:SetSize(14, 14) i:SetPoint("LEFT", 0, -1)
		i:SetTexture("Interface/Common/UI-Searchbox-Icon")
		local l, tip = s:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"), CreateFrame("GameTooltip", "RKC_SearchTip", newSlice, "GameTooltipTemplate")
		l:SetPoint("LEFT", 16, 0)
		l:SetText(L"Search")
		s:SetScript("OnEditFocusGained", function(s)
			l:Hide()
			i:SetVertexColor(0.90, 0.90, 0.90)
			tip:SetFrameStrata("TOOLTIP")
			tip:SetOwner(s, "ANCHOR_BOTTOM")
			tip:AddLine((L"Press %s to search"):format(HIGHLIGHT_FONT_COLOR_CODE .. GetBindingText("ENTER") .. "|r"))
			tip:AddLine((L"%s to search within current results"):format(HIGHLIGHT_FONT_COLOR_CODE .. GetBindingText("CTRL-ENTER") .. "|r"), nil, nil, nil, true)
			tip:AddLine((L"%s to cancel"):format(HIGHLIGHT_FONT_COLOR_CODE .. GetBindingText("ESCAPE") .. "|r"), true)
			tip:Show()
		end)
		s:SetScript("OnEditFocusLost", function(s)
			l:SetShown(not s:GetText():match("%S"))
			i:SetVertexColor(0.75, 0.75, 0.75)
			tip:Hide()
		end)
		s:SetScript("OnEnterPressed", function(s)
			s:ClearFocus()
			if s:GetText():match("%S") then
				performSearch(s:GetText(), IsControlKeyDown() and selectedCategory)
			end
		end)
		newSlice.search, s.ico, s.label = s, i, l
	end
	
	local catbg = newSlice:CreateTexture(nil, "BACKGROUND")
	catbg:SetPoint("TOPLEFT", 2, -2) catbg:SetPoint("RIGHT", newSlice, "RIGHT", -2, 0) catbg:SetPoint("BOTTOM", 0, 2)
	catbg:SetColorTexture(0,0,0, 0.65)
	local function onCatClick(self)
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		selectCategory(self:GetID())
	end
	local function onCatEnter(self)
		if self:GetFontString():IsTruncated() then
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("LEFT", self, "RIGHT")
			GameTooltip:SetText(self:GetText())
			GameTooltip:Show()
		end
	end
	local catContainer = CreateFrame("Frame", nil, newSlice)
	catContainer:SetClipsChildren(true)
	catContainer:SetSize(159, NUM_VISIBLE_CATS*20)
	catContainer:SetPoint("TOPLEFT", 2, -22)
	newSlice.slider:SetWheelScrollTarget(catContainer)
	local catOrigin = CreateFrame("Frame", nil, catContainer)
	catOrigin:Hide()
	catOrigin:SetSize(159, 1)
	catOrigin:SetPoint("TOPLEFT")
	for i=1, NUM_VISIBLE_CATS+1 do
		local b, fs = CreateFrame("Button", nil, catContainer)
		b:SetSize(159, 20)
		b:SetNormalTexture("Interface/AchievementFrame/UI-Achievement-Category-Background")
		b:SetHighlightTexture("Interface/AchievementFrame/UI-Achievement-Category-Highlight")
		b:GetNormalTexture():SetTexCoord(7/256, 162/256, 5/32, 24/32)
		b:GetHighlightTexture():SetTexCoord(7/256, 163/256, 5/32, 24/32)
		b:GetNormalTexture():SetVertexColor(0.6, 0.6, 0.6)
		b:SetNormalFontObject(GameFontHighlight)
		b:SetHighlightFontObject(GameFontHighlight)
		b:SetPushedTextOffset(0,0)
		b:SetText(" ")
		fs = b:GetFontString()
		fs:SetPoint("LEFT", 6, 0)
		fs:SetPoint("RIGHT", -6, 0)
		fs:SetJustifyH("CENTER")
		fs:SetMaxLines(1)
		b:SetScript("OnClick", onCatClick)
		b:SetScript("OnEnter", onCatEnter)
		b:SetScript("OnLeave", config.ui.HideTooltip)
		cats[i] = b
		b:SetPoint("TOPLEFT", catOrigin, 0, 20-20*i)
	end

	newSlice.desc = newSlice:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	newSlice.desc:SetPoint("TOPLEFT", newSlice.slider, "TOPRIGHT", 2, -6)
	newSlice.desc:SetPoint("RIGHT", -24, 0)
	newSlice.desc:SetHeight(26)
	newSlice.desc:SetJustifyV("TOP") newSlice.desc:SetJustifyH("CENTER")
	newSlice.desc:SetText(L"Select an action by double clicking.")
	
	newSlice.close = CreateFrame("Button", nil, newSlice, "UIPanelCloseButton")
	newSlice.close:SetPoint("TOPRIGHT", 3, 4)
	newSlice.close:SetSize(30, 30)
	newSlice.close:SetFrameLevel(newSlice:GetFrameLevel()+120)
	newSlice.close:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		api.closeActionPicker("close-picker-button")
	end)
	TS:EscapeCallback(newSlice.close, function() api.closeActionPicker() end)

	local b = newSlice.close:CreateTexture(nil, "BACKGROUND")
	b:SetAtlas("UI-Frame-TopCornerRight")
	b:SetTexCoord(9/33, 1, 0, 23/33)
	b:SetPoint("TOPLEFT", 4, -5) b:SetPoint("BOTTOMRIGHT", -5, 4)
	b:SetVertexColor(0.6,0.6,0.6)
	
	newSlice.slider2 = XU:Create("ScrollBar", nil, newSlice) do
		local s = newSlice.slider2
		s:SetPoint("TOPRIGHT", -2, COMPAT > 11403 and -26 or -22)
		s:SetPoint("BOTTOMRIGHT", -2, 2)
		s:SetMinMaxValues(0, 20)
		s:SetWindowRange(NUM_VISIBLE_ACTION_ROWS)
		s:SetStepsPerPage(4)
	end

	local function onClick(self)
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		api.addSlice(nil, selectedCategory(self:GetID()))
	end
	local function onDragStart(self)
		if newSlice.disableDrag then return end
		PlaySound(832)
		dragBackdrop:Show()
		SetCursor(self.plainTex or "Interface/Icons/Temp")
		self.dragActive = true
	end
	local function onDragAbort(self)
		if self.dragActive then
			self.dragActive = nil
			SetCursor(nil)
			dragBackdrop:Hide()
		end
	end
	local function onDragStop(self)
		onDragAbort(self)
		if newSlice.disableDrag then return end
		PlaySound(833)
		local e, x, y = ringContainer.slices[1], GetCursorPosition()
		if not e:GetLeft() then e = ringContainer.prev end
		local scale, l, b, w, h = e:GetEffectiveScale(), e:GetRect()
		local dy, dx = math.floor(-(y / scale - b - h-1)/(h+2)+0.5), x / scale - l
		if dx < -w/2 or dx > 3*w/2 then return end
		if dy < -1 or dy > (#ringContainer.slices+1) then return end
		api.addSlice(dy, selectedCategory(self:GetID()))
	end
	local function onEnter(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		if type(self.tipFunc) == "function" then
			securecall(self.tipFunc, GameTooltip, self.tipFuncArg)
		else
			GameTooltip:AddLine(self.name:GetText())
		end
		GameTooltip:Show()
	end
	local actionsContainer = CreateFrame("Frame", nil, newSlice)
		actionsContainer:SetClipsChildren(true)
		actionsContainer:SetPoint("TOPLEFT", newSlice.desc, "BOTTOMLEFT", 0, 8)
		actionsContainer:SetSize(344, 36*NUM_VISIBLE_ACTION_ROWS-1)
		newSlice.slider2:SetWheelScrollTarget(actionsContainer)
	local actionsOrigin = CreateFrame("Frame", nil, actionsContainer)
		actionsOrigin:SetSize(1,1)
		actionsOrigin:SetPoint("TOPLEFT")
		actionsOrigin:Hide()

	for i=1,NUM_VISIBLE_ACTION_ROWS*2+2 do
		local f = CreateFrame("Button", nil, actionsContainer)
		f:SetSize(170, 34)
		f:SetPoint("TOPLEFT", actionsOrigin, "TOPLEFT", 172*(1 - i % 2), -math.floor((i-1)/2)*36)
		f:RegisterForDrag("LeftButton")
		actions[i] = f
		f:SetScript("OnDragStart", onDragStart)
		f:SetScript("OnDragStop", onDragStop)
		f:SetScript("OnDoubleClick", onClick)
		f:SetScript("OnEnter", onEnter)
		f:SetScript("OnHide", onDragAbort)
		f:SetScript("OnLeave", config.ui.HideTooltip)
		f.ico = f:CreateTexture(nil, "ARTWORK")
		f.ico:SetSize(32,32) f.ico:SetPoint("LEFT", 1, 0)
		addIconSlotTextures(f.ico, 32)
		f.name = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		f.name:SetHeight(14)
		f.name:SetJustifyV("TOP")
		f.name:SetNonSpaceWrap(true)
		f.name:SetPoint("TOPLEFT", f.ico, "TOPRIGHT", 3, -2)
		f.name:SetPoint("RIGHT", -2, 0)
		f.name:SetJustifyH("LEFT")
		f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		f.sub:SetPoint("TOPLEFT", f.name, "BOTTOMLEFT", 0, -2)
		f.sub:SetPoint("RIGHT", -2, 0)
		f.sub:SetJustifyH("LEFT")
		f:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		f:GetHighlightTexture():SetAllPoints(f.ico)
	end

	local function syncActions()
		local sv = newSlice.slider2:GetValue()
		local base = math.floor(sv)*2
		actionsOrigin:SetPoint("TOPLEFT", 0, 36*(sv%1))
		for i=1,#actions do
			local e, id = actions[i], i + base
			if id <= #selectedCategory then
				local stype, sname, sicon, extico, tipfunc, tiparg = AB:GetActionListDescription(selectedCategory(id))
				local ok, pt = pcall(setIcon, e.ico, sicon, extico)
				e.tipFunc, e.tipFuncArg, e.plainTex = tipfunc, tiparg, ok and pt or nil
				e.name:SetText(sname)
				e.sub:SetText(stype)
				e:SetID(id)
				e:Show()
			else
				e:Hide()
			end
		end
	end
	local function syncCats(_, base)
		local fr = base % 1
		base = base - fr
		catOrigin:SetPoint("TOPLEFT", 0, fr*20)
		for i=1,#cats do
			local e, category, id = cats[i], AB:GetCategoryInfo(i+base), i+base
			e:SetShown(not not category)
			e:SetID(id)
			e[id == selectedCategoryId and "LockHighlight" or "UnlockHighlight"](e)
			e:SetText(category)
		end
		if selectedCategoryId == -1 then
			newSlice.search.ico:SetVertexColor(0.3, 1, 0)
		else
			newSlice.search.ico:SetVertexColor(0.75, 0.75, 0.75)
		end
	end
	function selectCategory(id)
		selectedCategoryId, selectedCategory = id, id == -1 and searchCat or AB:GetCategoryContents(id)
		if id ~= -1 then
			newSlice.search:SetText("")
			newSlice.search.label:Show()
		end
		syncCats(newSlice.slider, newSlice.slider:GetValue())
		local xv = math.max(0, math.ceil((#selectedCategory - #actions + 2)/2))
		newSlice.slider2:SetMinMaxValues(0, xv)
		newSlice.slider2:SetValue(0)
		syncActions()
		newSlice.search:ClearFocus()
	end
	newSlice.slider:SetScript("OnValueChanged", syncCats)
	newSlice.slider2:SetScript("OnValueChanged", syncActions)
	newSlice:SetScript("OnShow", function(self)
		selectCategory(1)
		self.slider:SetMinMaxValues(0, math.max(0, AB:GetNumCategories() - #cats))
		self.slider:SetValue(0)
	end)
end

local PLAYER_CLASS, PLAYER_CLASS_UC = UnitClass("player")
local PLAYER_CLASS_COLOR_HEX = RAID_CLASS_COLORS[PLAYER_CLASS_UC].colorStr:sub(3)

local function getSliceInfo(slice)
	return securecall(AB.GetActionDescription, AB, slice)
end
local function getSliceColor(slice, sicon)
	local c, r,g,b = true, (type(slice.c) == "string" and slice.c or ""):match("(%x%x)(%x%x)(%x%x)")
	if ORI and not r then
		c, r,g,b = false, ORI:GetTexColor(slice.icon or sicon or "Interface\\Icons\\INV_Misc_QuestionMark")
	elseif r then
		r,g,b = tonumber(r,16)/255, tonumber(g,16)/255, tonumber(b,16)/255
	end
	return r,g,b, c
end
local function isCollectionSlice(...)
	local actType = select(7, AB:GetActionDescription(...))
	if actType ~= nil then
		return actType == "collection"
	end
	local aid = AB:GetActionSlot(...)
	if aid then
		return AB:GetSlotImplementation(aid) == "collection"
	end
end
local decodeConstantList do
	local stringEscapes = {a="\a",b="\b",f="\f",n="\n",r="\r",t="\t",v="\v",["\\"]="\\",["'"]="'",['"']='"'}
	local function decodeStringEscape(w, f, s)
		local v = stringEscapes[f]
		if v then
			return v .. s
		end
		v = f >= "0" and f <= "9" and tonumber(w)
		return v and (v < 256 and string.char(v) or error("Invalid escape sequence")) or w
	end
	function decodeConstantList(text, start)
		local rv, ve, ps, w, c, pe = nil, nil, text:match("^%s*()(([%dtfn\"'%[])[^,%s\\\"']*)%s*()", start)
		if c == "'" or c == '"' then
			repeat
				w, pe = text:match('(\\*)' .. c .. '()', pe)
			until pe == nil or #w % 2 == 0
			if pe then
				rv, ve = text:sub(ps+1,pe-2):gsub('||','|'):gsub('\\((.)(%d?%d?))', decodeStringEscape), pe
			end
		elseif c == '[' then
			w, rv, ve = text:match('^%[(=*)%[(.-)%]%1%]()', ps)
			if rv then
				rv = rv:gsub('||', '|')
			end
		elseif w == "false" or w == "true" then
			ve, rv = pe, w == "true"
		elseif w == "nil" or tonumber(w) then
			ve, rv = pe, tonumber(w)
		end
		if ve then
			local ns = text:match("^%s*,()", ve)
			if ns then
				return rv, decodeConstantList(text, ns)
			elseif text:match("^%s*$", ve) then
				return rv
			end
		end
		error("Invalid encoding at position " .. tostring(start))
	end
end
local function genBundledRingName(mainNew, mainOld, nestName, usedNames, seq)
	if type(mainOld) == "string" and type(nestName) == "string" and nestName:sub(1,#mainOld) == mainOld then
		nestName = nestName:sub(#mainOld + 1 + #nestName:match("^%s*:?%s*", 1+#mainOld))
	end
	local cand = mainNew .. ": " .. (nestName or seq)
	if usedNames[cand] then
		cand = cand .. "/" .. seq
		while usedNames[cand] do
			cand = ("%s: %s [%04x%04x]"):format(mainNew, nestName or seq, math.random(2^16)-1, math.random(2^16)-1)
		end
	end
	usedNames[cand] = seq
	return cand
end
local function setImportedRingProps(name, data)
	data.name, data.limit = name, data.limit == "PLAYER" and FULLNAME or (type(data.limit) == "string" and data.limit:match("^[A-Z]+$") or nil)
end
local function updateImportedRingContents(data, ringNameMap)
	for i=1,#data do
		local e = data[i]
		local s = ringNameMap[e and e[1] == "ring" and e[2] or nil]
		if s then
			e[2] = s
		end
	end
end

local ringNameMap, ringOrderMap, ringTypeMap, ringNames, currentRing, currentRingName, sliceBaseIndex, currentSliceIndex, repickSlice = {}, {}, {}, {}
local typePrefix = {
	MINE="|cff25bdff|TInterface/FriendsFrame/UI-Toast-FriendOnlineIcon:14:14:0:1:32:32:8:24:8:24:30:190:255|t ",
	PERSONAL="|cffd659ff|TInterface/FriendsFrame/UI-Toast-FriendOnlineIcon:14:14:0:1:32:32:8:24:8:24:180:0:255|t ",
	HORDE=MODERN and "|cffff3000|A:QuestPortraitIcon-Horde-small:18:18:-1:-2|a" or "|cffff3000|A:poi-horde:16:16:-2:0|a",
	ALLIANCE=MODERN and "|cff00a0ff|A:QuestPortraitIcon-Alliance-small:20:18:-2:0|a" or "|cff00a0ff|A:poi-alliance:17:20:-2:0|a",
}
do
	for k, v in pairs(CLASS_ICON_TCOORDS) do
		local cc = RAID_CLASS_COLORS[k]
		typePrefix[k] = ("|cff%s|TInterface/GLUES/CHARACTERCREATE/UI-CharacterCreate-Classes:16:16:0:0:256:256:%d:%d:%d:%d|t "):format(cc and cc.colorStr:sub(3) or "a0ff00", v[1]*256+6,v[2]*256-6,v[3]*256+6,v[4]*256-6)
	end
end
local function sortNames(a,b)
	local oa, ob, na, nb, ta, tb = ringOrderMap[a] or 5, ringOrderMap[b] or 5, ringNameMap[a] or "", ringNameMap[b] or "", ringTypeMap[a] or "", ringTypeMap[b] or ""
	return oa < ob or (oa == ob and ta < tb) or (oa == ob and ta == tb and na < nb) or false
end
local function ringDropDown_EntryFormat(k)
	return (typePrefix[ringTypeMap[k]] or "") .. (ringNameMap[k] or "?"), currentRingName == k
end
function ringDropDown:initialize(level, nameList)
	local playerName, playerServer = UnitFullName("player")
	local playerFullName = playerName .. "-" .. playerServer
	local info = {func=api.selectRing, minWidth=level == 1 and (self:GetWidth()-40) or nil}
	if level == 1 then
		ringNames = {hidden={}, other={}, deleted={}}
		for name, dname, active, _slices, internal, limit in RK:GetManagedRings() do
			table.insert(active and (internal and ringNames.hidden or ringNames) or ringNames.other, name)
			local isFactionLimit = (limit == "Alliance" or limit == "Horde") and limit:upper() or nil
			local rtype = type(limit) ~= "string" and "GLOBAL" or limit == playerFullName and "MINE" or isFactionLimit or limit:match("[^A-Z]") and "PERSONAL" or limit
			ringNameMap[name], ringOrderMap[name], ringTypeMap[name] = dname, (not active and (rtype == "PERSONAL" and 12 or 10)) or isFactionLimit and 4 or (limit and (limit:match("[^A-Z]") and 0 or 2)), rtype
		end
		for name, dname, _, _, _, limit in RK:GetDeletedRings() do
			table.insert(ringNames.deleted, name)
			local isFactionLimit = (limit == "Alliance" or limit == "Horde") and limit:upper() or nil
			local rtype = type(limit) ~= "string" and "GLOBAL" or limit == playerFullName and "MINE" or isFactionLimit or limit:match("[^A-Z]") and "PERSONAL" or limit
			ringNameMap[name], ringOrderMap[name], ringTypeMap[name] = dname, 0, rtype
		end
		table.sort(ringNames, sortNames)
		table.sort(ringNames.hidden, sortNames)
		table.sort(ringNames.other, sortNames)
		table.sort(ringNames.deleted, sortNames)
		if #ringNames == 0 and #ringNames.hidden == 0 and #ringNames.other == 0 and #ringNames.deleted == 0 then
			btnNewRing:Click()
			return
		end
	elseif nameList then
		XU:Create("ScrollableDropDownList", 2, nameList, ringDropDown_EntryFormat, api.selectRing)
		return
	end
	local hasHidden = ringNames.hidden and #ringNames.hidden > 0
	local hasOther = ringNames.other and #ringNames.other > 0
	local hasDeleted = ringNames.deleted and #ringNames.deleted > 0
	XU:Create("ScrollableDropDownList", 1, ringNames, ringDropDown_EntryFormat, api.selectRing, hasHidden or hasOther)
	info.hasArrow, info.notCheckable, info.padding, info.fontObject = 1, 1, 32, GameFontNormalSmall
	info.text, info.func, info.checked = nil
	if hasHidden then
		info.menuList, info.text = ringNames.hidden, L"Hidden rings"
		UIDropDownMenu_AddButton(info, level)
	end
	if hasOther then
		info.menuList, info.text = ringNames.other, L"Inactive rings"
		UIDropDownMenu_AddButton(info, level)
	end
	if hasDeleted then
		info.menuList, info.text = ringNames.deleted, L"Restore deleted ring"
		UIDropDownMenu_AddButton(info, level)
	end
end
function api.createRing(name, data, bundle, importNested)
	local name = name:match("^%s*(.-)%s*$")
	if name == "" then return false end
	local iname = RK:GenFreeRingName(name)
	local mapRings, reservedINames, usedNames, nr = {}, importNested and {[iname]=1}, {[name]=true}, 2
	if bundle then
		for k,v in pairs(bundle) do
			if v == 0 then
				mapRings[k] = iname
			elseif type(v) == "table" and importNested then
				setImportedRingProps(genBundledRingName(name, data.name, v.name, usedNames, nr), v)
				local n = RK:GenFreeRingName(v.name, reservedINames)
				mapRings[k], reservedINames[n], nr = n, nr, nr + 1
			end
		end
		if importNested then
			for k,v in pairs(bundle) do
				if type(v) == "table" then
					updateImportedRingContents(v, mapRings)
					SaveRingVersion(mapRings[k], false)
					api.saveRing(mapRings[k], v)
				end
			end
		end
	end
	setImportedRingProps(name, data)
	updateImportedRingContents(data, mapRings)
	SaveRingVersion(iname, false)
	api.saveRing(iname, data)
	api:selectRing(iname)
	return true
end
function api.selectRing(_, name)
	CloseDropDownMenus()
	ringDetail:Hide()
	api.hideSliceDetail()
	newSlice:Hide()
	ringContainer.newSlice:SetChecked(nil)
	local desc = RK:GetRingDescription(name)
	currentRing, currentRingName, repickSlice = nil
	if not desc then
		desc = name and RK:RestoreDefaults(name) and RK:GetRingDescription(name)
		if desc then
			SaveRingVersion(name, false)
		else
			return
		end
	end
	RK:SoftSync(name)
	UIDropDownMenu_SetText(ringDropDown, desc.name or name)
	ringDetail.rotation:SetValue(desc.offset or 0)
	ringDetail.name:SetText(desc.name or name)
	ringDetail.name:SetCursorPosition(0)
	ringDetail.hiddenRing:SetChecked(desc.internal)
	ringDetail.embedRing:SetChecked(desc.embed)
	currentRing, currentRingName, sliceBaseIndex, currentSliceIndex = desc, name, 1
	api.refreshDisplay()
	ringDetail:Show()
	ringDetail.scope:text()
	ringDetail.export.nested:SetChecked(true)
	api.updateRingLine(true)
	ringContainer:Show()
end
function api.hideSliceDetail()
	sliceDetail:Hide()
	editorHost:Clear()
end
function api.updateRingLine(scanForNestedRings)
	ringContainer.prev:SetEnabled(sliceBaseIndex > 1)
	ringContainer.next:Disable()
	local onOpen, lastWidget = currentRing.onOpen
	for i=sliceBaseIndex,#currentRing do
		local e = ringContainer.slices[i-sliceBaseIndex+1]
		if not e then ringContainer.next:Enable() break end
		local _, _, sicon, icoext = getSliceInfo(currentRing[i])
		local ok, pt = pcall(setIcon, e.tex, currentRing[i].icon or sicon, icoext)
		e.plainTex = ok and pt or nil
		e.check:SetShown(RK:IsRingSliceActive(currentRingName, i))
		e.auto:SetShown(onOpen == i)
		e:SetChecked(currentSliceIndex == i)
		e:Show()
		lastWidget = e
	end
	ringContainer.newSlice:SetPoint("TOP", lastWidget or ringContainer.slices[1], lastWidget and "BOTTOM" or "TOP", 0, -2)
	for i=#currentRing-sliceBaseIndex+2,#ringContainer.slices do
		ringContainer.slices[i]:Hide()
	end
	if scanForNestedRings then
		local hasNestedCustomRings = false
		for i=1,#currentRing do
			local e = currentRing[i]
			if e[1] == "ring" and e[2] ~= currentRingName and select(4,RK:GetRingInfo(e[2])) then
				hasNestedCustomRings = true
				break
			end
		end
		ringDetail.export.nested:SetShown(hasNestedCustomRings)
	end
end
function api.scrollSliceList(dir)
	sliceBaseIndex = math.max(1,sliceBaseIndex + dir)
	api.updateRingLine()
end
function api.resolveSliceOffset(id)
	return sliceBaseIndex + id
end
function sliceDetail.skipSpecs:toggle(id)
	self = sliceDetail.skipSpecs
	local v, c = self.val:gsub("/" .. id .. "/", "/")
	if c == 0 then v = "/" .. id .. v end
	self.val = v
	api.setSliceProperty("skipSpecs")
	self:text()
end
function sliceDetail.skipSpecs:SetValue(skip)
	self.val = type(skip) == "string" and skip ~= "" and ("/" .. skip .. "/") or "/"
	self:text()
end
function sliceDetail.skipSpecs:GetValue()
	return self.val:match("^/(.+)/$")
end
function sliceDetail.skipSpecs:text()
	if not MODERN then
		UIDropDownMenu_DisableDropDown(self)
		return UIDropDownMenu_SetText(self, L"All characters")
	end
	local text, u, skipSpecs = "", GetNumSpecializations(), self.val
	for i=1, u do
		local id, name = GetSpecializationInfo(i)
		if not skipSpecs:match("/" .. id .. "/") then
			text, u = text .. (text == "" and "" or ", ") .. name, u - 1
		end
	end
	if u == 0 then
		text = (L"All %s specializations"):format("|cff" .. PLAYER_CLASS_COLOR_HEX .. PLAYER_CLASS .. "|r")
	elseif text == "" then
		text = (L"No %s specializations"):format("|cff" .. PLAYER_CLASS_COLOR_HEX .. PLAYER_CLASS .. "|r")
	else
		text = (L"Only %s"):format("|cff" .. PLAYER_CLASS_COLOR_HEX .. text .. "|r")
	end
	UIDropDownMenu_SetText(self, text)
end
function sliceDetail.skipSpecs:initialize()
	local info = {func=self.toggle, isNotRadio=true, minWidth=self:GetWidth()-40, keepShownOnClick=true}
	local skip = self.val or ""
	for i=1, GetNumSpecializations() do
		local id, name, _, icon = GetSpecializationInfo(i)
		info.text, info.arg1, info.checked = "|T" .. icon .. ":16:16:0:0:64:64:4:60:4:60|t " .. name, id, not skip:match("/" .. id .. "/")
		UIDropDownMenu_AddButton(info)
	end
end
function ringDetail.scope:initialize()
	local luFaction, lFaction = UnitFactionGroup("player")
	local info = {func=self.set, minWidth=self:GetWidth()-40}
	info.text, info.checked = L"All characters", currentRing.limit == nil
	UIDropDownMenu_AddButton(info)
	info.text, info.checked, info.arg1 = (L"All %s characters"):format("|cff" .. (luFaction == "Horde" and "ff3000" or "00a0ff") .. lFaction .. "|r"), currentRing.limit == luFaction, luFaction
	UIDropDownMenu_AddButton(info)
	info.text, info.checked, info.arg1 = (L"All %s characters"):format("|cff" .. PLAYER_CLASS_COLOR_HEX .. PLAYER_CLASS .. "|r"), currentRing.limit == PLAYER_CLASS_UC, PLAYER_CLASS_UC
	UIDropDownMenu_AddButton(info)
	info.text, info.checked, info.arg1 = (L"Only %s"):format("|cff" .. PLAYER_CLASS_COLOR_HEX .. SHORTNAME .. "|r"), currentRing.limit == FULLNAME, FULLNAME
	UIDropDownMenu_AddButton(info)
end
function ringDetail.scope:set(arg1)
	api.setRingProperty("limit", arg1)
end
function ringDetail.scope:text()
	local limit = currentRing.limit
	local isFactionLimit = (limit == "Alliance" or limit == "Horde")
	UIDropDownMenu_SetText(self, type(limit) ~= "string" and L"All characters" or
		isFactionLimit and (L"All %s characters"):format((limit == "Horde" and "|cffff3000" or "|cff00a0ff") .. (limit == "Horde" and FACTION_HORDE or FACTION_ALLIANCE) .. "|r") or
		limit:match("[^A-Z]") and (L"Only %s"):format("|cff" .. (limit == FULLNAME and PLAYER_CLASS_COLOR_HEX .. SHORTNAME or ("d659ff" .. limit)) .. "|r") or
		RAID_CLASS_COLORS[limit] and (L"All %s characters"):format("|cff" .. RAID_CLASS_COLORS[limit].colorStr:sub(3) .. (UnitSex("player") == 3 and LOCALIZED_CLASS_NAMES_FEMALE or LOCALIZED_CLASS_NAMES_MALE)[limit] .. "|r")
	)
end
function api.getRingProperty(key)
	return currentRing[key]
end
function api.getRingBinding()
	if PC:GetRingInfo(currentRingName) then
		local skey, _, over = PC:GetRingBinding(currentRingName, 1)
		if over then
			return skey
		end
	end
	if currentRing.hotkey then
		return currentRing.hotkey, PC:GetOption("UseDefaultBindings", currentRingName) and "" or "|cffa0a0a0"
	end
end
function api.setRingBinding(value)
	if PC:GetRingInfo(currentRingName) then
		config.undo:saveActiveProfile()
		PC:SetRingBinding(currentRingName, 1, value)
		ringDetail.binding:SetBindingText(value)
	end
end
function api.setRingProperty(name, value)
	if not currentRing then return end
	currentRing[name] = value
	if name == "limit" then
		ringDetail.scope:text()
		ringOrderMap[currentRingName] = value ~= nil and (value:match("[^A-Z]") and 0 or 2) or nil
	elseif name == "internal" then
		local source, dest = value and ringNames or ringNames.hidden, value and ringNames.hidden or ringNames
		for i=1,#source do if source[i] == currentRingName then
			table.remove(source, i)
			break
		end end
		table.insert(dest, currentRingName)
	elseif name == "onOpen" then
		currentRing.quarantineOnOpen = nil
		api.updateRingLine()
	end
	api.saveRing(currentRingName, currentRing)
	if name == "name" then
		UIDropDownMenu_SetText(ringDropDown, value or currentRingName)
	end
end
function api.setSliceAction()
	if currentRing and currentSliceIndex then
		api.setSliceProperty("*")
	end
end
function api.setSliceProperty(prop, ...)
	local slice = assert(currentRing[currentSliceIndex], "Setting a slice property on an unknown slice")
	if prop == "color" then
		local r, g, b = ...
		slice.c = r and ("%02x%02x%02x"):format(r*255, g*255, b*255) or nil
	elseif prop == "*" then
		if editorHost:GetAction(slice) then
			api.updateSliceDisplay(currentSliceIndex, slice)
		end
	elseif prop == "skipSpecs" or prop == "show" then
		local ss = sliceDetail.skipSpecs:GetValue()
		local sh = sliceDetail.showConditional:GetText()
		slice.show = (ss or sh ~= "") and ((ss and ("[spec:" .. ss .. "] hide;") or "") .. sh) or nil
	elseif prop == "rotationMode" then
		if ... == "default" then
			slice.embed, slice.rotationMode = nil, nil
		elseif ... == "embed" then
			slice.embed, slice.rotationMode = true, nil
		else
			slice.rotationMode, slice.embed = ..., false
		end
	else
		slice[prop] = (...)
	end
	api.saveRing(currentRingName, currentRing)
	if prop == "icon" or prop == "color" then
		local _, _, ico, icoext = getSliceInfo(currentRing[currentSliceIndex])
		if prop ~= "color" then sliceDetail.icon:SetIcon(ico, slice.icon, icoext) end
		sliceDetail.color:SetColor(getSliceColor(slice, ico))
	end
	api.updateRingLine()
end
function api.noQuickActionHint(ringName)
	local noQuickAction = not (PC:GetOption("CenterAction", ringName) or PC:GetOption("MotionAction", ringName))
	local opt = noQuickAction and ("|cffffffff" .. (L"Quick action repeat trigger:"):gsub("%s*:%s*$", "") .. "|r")
	return noQuickAction and (L"You must enable a %s interaction for this ring in OPie options to use quick actions."):format(opt)
end
function api.updateSliceOptions(slice)
	local extraY, isCollection = 0, securecall(isCollectionSlice, slice)
	local fc, cd = sliceDetail.fastClick, sliceDetail.collectionDrop
	fc:SetChecked(not not slice.fastClick)
	local noQA = api.noQuickActionHint(currentRingName)
	if noQA then
		fc.tooltipText = noQA
		fc:SetChecked(false)
		fc:SetEnabled(false)
		fc.Text:SetVertexColor(0.6, 0.6, 0.6)
	else
		fc:SetEnabled(true)
		fc.tooltipText = nil
		fc.Text:SetVertexColor(1, 1, 1)
	end
	cd:SetShown(isCollection)
	if isCollection then
		cd:SetPoint("TOPLEFT", fc, "BOTTOMLEFT", -16, 1)
		extraY = 34
		cd.embed, cd.rotationMode = slice.embed, slice.rotationMode
		cd:text()
	end
	sliceDetail.editorContainer:SetVerticalOffset(extraY)
end
function api.selectSlice(offset, select)
	if not select then
		-- This can trigger save-on-hide logic, which in turn forces a
		-- (redundant) sliceDetail update.
		api.hideSliceDetail()
		newSlice:Hide()
		api.endSliceRepick()
		currentSliceIndex = nil
		ringDetail:Show()
		api.updateRingLine()
		return
	end
	ringDetail:Hide()
	newSlice:Hide()
	api.hideSliceDetail()
	ringContainer.newSlice:SetChecked(nil)
	local oid, id = (currentSliceIndex or 0) + 1 - sliceBaseIndex, sliceBaseIndex + offset
	local old, desc = ringContainer.slices[oid], currentRing[id]
	if old and oid ~= id then old:SetChecked(nil) end
	currentSliceIndex = nil
	if not desc then
		return ringDetail:Show()
	end
	api.updateSliceDisplay(id, desc)
	api.endSliceRepick()
	sliceDetail:Show()
	currentSliceIndex = id
end
function api.updateSliceDisplay(_id, desc)
	local stype, sname, sicon, icoext = getSliceInfo(desc)
	if (sname or "") ~= "" and stype ~= sname then
		sliceDetail.desc:SetFormattedText("%s: |cffffffff%s|r", stype or "?", sname or "?")
	else
		sliceDetail.desc:SetText(stype or "?")
	end
	local skipSpecs, showConditional = (desc.show or ""):match("^%[spec:([%d/]+)%] hide;(.*)")
	sliceDetail.iconSelector:Hide()
	sliceDetail.icon:SetIcon(sicon, desc.icon, icoext)
	sliceDetail.color:SetColor(getSliceColor(desc, sicon))
	sliceDetail.skipSpecs:SetValue(skipSpecs)
	sliceDetail.showConditional:SetText(showConditional or desc.show or "")
	sliceDetail.shortLabel:SetText(desc.label or "")
	api.updateSliceOptions(desc)
	editorHost:SetAction(desc)
	local canRestore, hasRestore = RK:CanRestoreSlice(currentRingName, desc)
	sliceDetail.restore:SetShown(hasRestore)
	sliceDetail.restore:SetEnabled(canRestore)
end
function api.moveSlice(source, dest)
	if not (currentRing and currentRing[source] and currentRing[dest]) then return end
	table.insert(currentRing, dest, table.remove(currentRing, source))
	if currentSliceIndex == source then currentSliceIndex = dest end
	api.saveRing(currentRingName, currentRing)
	api.updateRingLine()
end
function api.deleteSlice(id)
	if id == nil then id = currentSliceIndex end
	if id and currentRing and currentRing[id] then
		if id == currentSliceIndex then
			api.hideSliceDetail()
			currentSliceIndex = nil
			ringDetail:Show()
		end
		table.remove(currentRing, id)
		if sliceBaseIndex == id and sliceBaseIndex > 1 then
			sliceBaseIndex = sliceBaseIndex - 1
		end
		if id == currentRing.onOpen then
			currentRing.onOpen = nil
		elseif currentRing.onOpen and id < currentRing.onOpen then
			currentRing.onOpen = currentRing.onOpen - 1
		end
		api.saveRing(currentRingName, currentRing)
		api.updateRingLine(true)
	end
end
function api.beginSliceRepick()
	repickSlice = currentRing[currentSliceIndex]
	api.hideSliceDetail()
	ringContainer.disableSliceDrag, newSlice.disableDrag = true, true
	newSlice:Show()
end
function api.endSliceRepick()
	ringContainer.disableSliceDrag, newSlice.disableDrag = nil, nil
	repickSlice = nil
end
function api.finishSliceRepick()
	for i=1,#currentRing do
		if currentRing[i] == repickSlice then
			api.endSliceRepick()
			api.selectSlice(i-sliceBaseIndex, true)
			api.updateRingLine()
			return true
		end
	end
end
function api.deleteRing()
	if currentRing then
		ringContainer:Hide()
		config.undo:saveActiveProfile()
		api.saveRing(currentRingName, false)
		api.deselectRing()
	end
end
function api.deselectRing()
	ringContainer:Hide()
	currentRing, currentRingName, ringNames = nil
	UIDropDownMenu_SetText(ringDropDown, L"Select a ring to modify")
end
function api.restoreDefault()
	if currentRingName then
		local _, _, isDefaultAvailable, isDefaultOverriden = RK:GetRingInfo(currentRingName)
		if isDefaultAvailable and isDefaultOverriden then
			SaveRingVersion(currentRingName, true)
			RK:RestoreDefaults(currentRingName)
		end
		api.selectRing(nil, currentRingName)
	end
end
function api.restoreSliceDefault()
	if currentRingName and currentSliceIndex then
		local ns = RK:GetRestoredSlice(currentRingName, currentRing[currentSliceIndex])
		if ns then
			currentRing[currentSliceIndex] = ns
			api.saveRing(currentRingName, currentRing)
			api.updateSliceDisplay(currentSliceIndex, ns)
			api.updateRingLine()
		end
	end
end
function api.addSlice(pos, ...)
	local wasRepick
	if pos == nil and repickSlice then
		for k in pairs(repickSlice) do
			if type(k) == "number" then
				repickSlice[k] = nil
			end
		end
		for i=1,select("#", ...),2 do
			repickSlice[i], repickSlice[i+1] = select(i, ...)
		end
		wasRepick = true
	else
		pos = math.max(1, math.min(#currentRing+1, pos and (pos + sliceBaseIndex) or (#currentRing+1)))
		table.insert(currentRing, pos, {sliceToken=AB:CreateToken(), ...})
		sliceBaseIndex = math.min(pos, math.max(1 + pos - #ringContainer.slices, sliceBaseIndex))
	end
	api.saveRing(currentRingName, currentRing)
	api.updateRingLine(true)
	if wasRepick then
		api.finishSliceRepick()
	end
end
local function resolveCustomSliceAdd(ok, ...)
	if ok and type((...)) == "string" and AB:GetActionDescription(...) then
		api.addSlice(nil, ...)
		return true
	end
	return false
end
function api.addCustomSlice(_editbox, text, attemptAccept)
	if not attemptAccept then
		return true
	end
	return resolveCustomSliceAdd(pcall(decodeConstantList, text, 1))
end
function api.closeActionPicker(source)
	if source == "add-new-slice-button" and repickSlice then
		api.endSliceRepick()
		currentSliceIndex = nil
		api.updateRingLine()
		ringContainer.newSlice:SetChecked(true)
		return
	elseif repickSlice and api.finishSliceRepick() then
		return
	end
	newSlice:Hide()
	ringDetail:Show()
	api.updateRingLine()
	ringContainer.newSlice:SetChecked(false)
end
function api.saveRing(name, data)
	SaveRingVersion(name, true)
	if data ~= nil then
		if type(data) == "table" then
			data.save = true
		end
		RK:SetRing(name, data)
	end
	ringDetail.exportArea:Hide()
	ringDetail.binding:SetEnabled(not not PC:GetRingInfo(name))
end
function api.refreshDisplay()
	if currentRing and currentRing[currentSliceIndex] then
		api.updateSliceOptions(currentRing[currentSliceIndex])
		api.updateRingLine()
	end
	if currentRing then
		ringDetail.binding:SetBindingText(api.getRingBinding())
		ringDetail.binding:SetEnabled(not not PC:GetRingInfo(currentRingName))
		ringDetail.exportArea:GetScript("OnHide")(ringDetail.exportArea)
		local noCA = api.noQuickActionHint(currentRingName)
		ringDetail.opportunistCA.tooltipText = noCA
		ringDetail.opportunistCA:SetEnabled(not noCA)
		ringDetail.opportunistCA:SetChecked(not noCA and not currentRing.noOpportunisticCA)
		ringDetail.opportunistCA.Text:SetVertexColor(noCA and 0.6 or 1,noCA and 0.6 or 1,noCA and 0.6 or 1)
		ringDetail.firstOnOpen:SetChecked(currentRing.onOpen == 1)
		ringDetail.firstOnOpen.quarantineMark:SetShown(currentRing.quarantineOnOpen == 1)
	end
end
function api.exportRing(includeNestedRings)
	local input = ringDetail.exportArea
	ringDetail.export:Hide()
	input:Show()
	input:SetText(RK:GetRingSnapshot(currentRingName, includeNestedRings))
	input:SetCursorPosition(0)
	input:HighlightText()
	input:SetFocus()
end
function api.showExternalEditor(which)
	if which == "slice-binding" then
		T.ShowSliceBindingPanel(currentRingName)
	elseif which == "opie-options" then
		T.ShowOPieOptionsPanel(currentRingName)
	end
end

ringDetail:SetScript("OnShow", function()
	local _,_, isDefaultAvailable, isDefaultOverriden = RK:GetRingInfo(currentRingName)
	ringDetail.restore:SetText(isDefaultAvailable and L"Restore default" or L"Undo changes")
	ringDetail.restore:SetShown(isDefaultAvailable and isDefaultOverriden)
end)

local function resetView()
	currentRingName, currentRing, currentSliceIndex, ringNames = nil
	ringContainer:Hide()
end
function panel:refresh()
	local oRingName, oBaseIndex, oSliceIndex = currentRingName, sliceBaseIndex, currentSliceIndex
	local oSliceToken = currentRing and currentRing[currentSliceIndex] and currentRing[currentSliceIndex].sliceToken
	currentRingName, currentRing, currentSliceIndex, ringNames = nil
	ringContainer:Hide()
	ringDetail:Hide()
	api.hideSliceDetail()
	newSlice:Hide()
	if oRingName and RK:GetRingInfo(oRingName) then
		api.selectRing(nil, oRingName)
		for i=1, oSliceToken and type(currentRing) == "table" and #currentRing or 0 do
			local s = currentRing[i]
			if s and s.sliceToken == oSliceToken then
				api.selectSlice(i-sliceBaseIndex, true)
				break
			end
		end
		local cbi = currentSliceIndex and (currentSliceIndex - oSliceIndex + oBaseIndex) or oBaseIndex
		if currentRing and cbi > 0 and cbi < #currentRing and cbi ~= sliceBaseIndex then
			sliceBaseIndex = cbi
			api.updateRingLine()
		end
	end
	if not currentRing then
		UIDropDownMenu_SetText(ringDropDown, L"Select a ring to modify")
	end
end
function panel:default()
	for key in RK:GetManagedRings() do
		local _, _, isDefault, isOverriden = RK:GetRingInfo(key)
		if isDefault and isOverriden then
			SaveRingVersion(key, true)
		end
	end
	for key in RK:GetDeletedRings() do
		SaveRingVersion(key, false)
	end
	RK:RestoreDefaults()
	panel:refresh()
end
function panel:okay()
	ringContainer:Hide()
	resetView()
end
panel.cancel = resetView
panel:SetScript("OnShow", config.checkSVState)

SLASH_OPIE_CUSTOM_RINGS1 = "/rk"
function SlashCmdList.OPIE_CUSTOM_RINGS()
	panel:OpenPanel()
end
T.AddSlashSuffix(SlashCmdList.OPIE_CUSTOM_RINGS, "custom", "rings")