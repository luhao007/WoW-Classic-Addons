local api, RK, conf, ORI, _, T = {}, OneRingLib.ext.RingKeeper, OneRingLib.ext.config, OPie.UI, ...
local L, MODERN = T.L, select(4,GetBuildInfo()) >= 8e4
local AB = assert(T.ActionBook:compatible(2,23), "A compatible version of ActionBook is required")
local gfxBase, EV = [[Interface\AddOns\OPie\gfx\]], T.Evie
local CreateEdge = T.ActionBook._CreateEdge

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
local function createIconButton(name, parent, id)
	local f = CreateFrame("CheckButton", name, parent)
	f:SetSize(32,32)
	f:SetNormalTexture("")
	f:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
	f:GetHighlightTexture():SetBlendMode("ADD")
	f:SetCheckedTexture("Interface/Buttons/CheckButtonHilight")
	f:GetCheckedTexture():SetBlendMode("ADD")
	f:SetPushedTexture("Interface/Buttons/UI-Quickslot-Depress")
	f.tex = f:CreateTexture()
	f.tex:SetAllPoints()
	f:SetID(id or 0)
	return f
end
local function SetCursor(tex)
	_G.SetCursor((type(tex) == "number" or tex == (gfxBase .. "opie_ring_icon")) and (MODERN and "Interface/Icons/Temp" or "Interface/Icons/INV_Crate_01") or tex)
end
local function SaveRingVersion(name, liveData)
	local key = "RKRing#" .. name
	if not conf.undo.search(key) then
		conf.undo.push(key, RK.SetRing, RK, name, liveData == true and RK:GetRingDescription(name) or liveData or false)
	end
end
local function CreateToggleButton(parent)
	local button = CreateFrame("CheckButton", nil, parent)
	button:SetSize(175, 30)
	button:SetNormalFontObject(GameFontHighlightMedium)
	button:SetPushedTextOffset(-1, -1)
	button:SetNormalTexture("Interface\\PVPFrame\\PvPMegaQueue")
	button:GetNormalTexture():SetTexCoord(0.00195313,0.58789063, 0.87304688,0.92773438)
	button:SetPushedTexture("Interface\\PVPFrame\\PvPMegaQueue")
	button:GetPushedTexture():SetTexCoord(0.00195313,0.58789063,0.92968750,0.98437500)
	button:SetHighlightTexture("Interface\\PVPFrame\\PvPMegaQueue")
	button:GetHighlightTexture():SetTexCoord(0.00195313,0.63867188, 0.70703125,0.76757813)
	button:SetCheckedTexture("Interface\\PVPFrame\\PvPMegaQueue")
	button:GetCheckedTexture():SetTexCoord(0.00195313,0.63867188, 0.76953125,0.83007813)
	for i=1,2 do
		local tex = i == 1 and button:GetHighlightTexture() or button:GetCheckedTexture()
		tex:ClearAllPoints()
		tex:SetPoint("TOPLEFT", button, "LEFT", -1.5, 12.3)
		tex:SetPoint("BOTTOMRIGHT", button, "RIGHT", 1.5, -12.3)
		tex:SetBlendMode("ADD")
	end
	return button
end
local function CreateButton(parent, width)
	local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	btn:SetWidth(width or 150)
	return btn
end
local function setIcon(self, path, ext, slice)
	if type(slice) == "table" and slice[1] == "macrotext" and type(slice[2]) == "string" then
		local p2 = path or "interface/icons/temp"
		local lp = type(p2) == "string" and p2:gsub("\\", "/"):lower()
		if lp == "interface/icons/temp" or lp == "interface/icons/inv_misc_questionmark" then
			for sidlist in slice[2]:gmatch("{{spell:([%d/]+)}}") do
				for sid in sidlist:gmatch("%d+") do
					local _,_,sico = GetSpellInfo(tonumber(sid))
					if sico then
						path = sico
						break
					end
				end
				if path then break end
			end
		end
	end
	self:SetTexture(path or "Interface/Icons/Inv_Misc_QuestionMark")
	self:SetTexCoord(0,1,0,1)
	if not ext then return end
	if type(ext.iconR) == "number" and type(ext.iconG) == "number" and type(ext.iconB) == "number" then
		self:SetVertexColor(ext.iconR, ext.iconG, ext.iconB)
	end
	if type(ext.iconCoords) == "table" then
		self:SetTexCoord(unpack(ext.iconCoords))
	elseif type(ext.iconCoords) == "function" or type(ext.iconCoords) == "userdata" then
		self:SetTexCoord(ext:iconCoords())
	end
end
local function GetPositiveFileIDFromPath(path)
	local id = GetFileIDFromPath(path)
	return id and id > 0 and id or nil
end

local ringContainer, ringDetail, sliceDetail, newSlice, newRing
local panel = conf.createPanel(L"Custom Rings", "OPie")
	panel.desc:SetText(L"Customize OPie by modifying existing rings, or creating your own.")
	panel.version:SetFormattedText("%d.%d", RK:GetVersion())
local ringDropDown = CreateFrame("Frame", "RKC_RingSelectionDropDown", panel, "UIDropDownMenuTemplate")
	ringDropDown:SetPoint("TOP", -70, -60)
	UIDropDownMenu_SetWidth(ringDropDown, 260)
local btnNewRing = CreateButton(panel)
	btnNewRing:SetPoint("LEFT", ringDropDown, "RIGHT", -5, 3)
	btnNewRing:SetText(L"New Ring...")

newRing = CreateFrame("Frame") do
	newRing:SetSize(400, 115)
	local title = newRing:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	local toggle1, toggle2 = CreateToggleButton(newRing), CreateToggleButton(newRing)
	local name, snap = conf.ui.lineInput(newRing, true, 240), conf.ui.lineInput(newRing, true, 240)
	local nameLabel, snapLabel = newRing:CreateFontString(nil, "OVERLAY", "GameFontHighlight"), snap:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	local accept, cancel = CreateButton(newRing, 125), CreateButton(newRing, 125)
	title:SetPoint("TOP", 0, -3)
	toggle1:SetPoint("TOPLEFT", 20, -25)
	toggle2:SetPoint("TOPRIGHT", -20, -25)
	name:SetPoint("TOPRIGHT", -15, -62)
	nameLabel:SetPoint("TOPLEFT", newRing, "TOPLEFT", 15, -67)
	snap:SetPoint("TOPRIGHT", -15, -85)
	snapLabel:SetPoint("TOPLEFT", newRing, "TOPLEFT", 15, -90)
	accept:SetPoint("BOTTOMRIGHT", newRing, "BOTTOM", -2, 4)
	cancel:SetPoint("BOTTOMLEFT", newRing, "BOTTOM", 2, 4)
	toggle1:SetChecked(1)
	snap:Hide()
	toggle1.other, toggle2.other = toggle2, toggle1
	local function validate()
		local nameText, snapText, snapOK = name:GetText() or "", snap:GetText() or "", true
		if toggle2:GetChecked() then
			if snapText ~= snap.cachedText then
				snap.cachedText, snap.cachedValue = snapText, snapText ~= "" and RK:GetSnapshotRing(snapText) or nil
				if type(snap.cachedValue) == "table" and nameText == "" then
					snap:SetCursorPosition(0)
					name:SetText(snap.cachedValue.name or "")
					name:SetFocus()
					name:HighlightText()
				end
			end
			snapOK = type(snap.cachedValue) == "table"
			if snapOK then
				snap:SetTextColor(GameFontGreen:GetTextColor())
			else
				snap:SetTextColor(ChatFontNormal:GetTextColor())
			end
		elseif #nameText > 32 and nameText:match("^%s*oetohH7") then
			local val = RK:GetSnapshotRing(nameText)
			if type(val) == "table" then
				snap.cachedText, snap.cachedValue = nameText, val
				name:SetText("")
				toggle2:Click()
				snap:SetText(nameText)
			end
		end
		accept:SetEnabled(type(nameText) == "string" and nameText:match("%S") and snapOK)
	end
	local function toggle(self)
		if not self:GetChecked() ~= not self.other:GetChecked() then
		elseif not self:GetChecked() then
			self:SetChecked(1)
		else
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			self.other:SetChecked(nil)
			newRing:SetSize(400, self == toggle1 and 115 or 140)
			snap:SetShown(self ~= toggle1)
			if newRing:IsVisible() then
				conf.overlay(panel, newRing)
				validate(name);
				(self == toggle1 and name or snap):SetFocus()
			end
		end
	end
	local function navigate(self)
		if IsControlKeyDown() then
			(toggle1:GetChecked() and toggle2 or toggle1):Click()
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
		local ringData = toggle2:GetChecked() and type(snap.cachedValue) == "table" and snap.cachedValue or {limit="PLAYER"}
		if api.createRing(name:GetText(), ringData) then
			newRing:Hide()
		end
	end)
	toggle1:SetScript("OnClick", toggle)
	toggle2:SetScript("OnClick", toggle)
	for i=1,2 do
		local v = i == 1 and name or snap
		v:SetScript("OnTabPressed", navigate)
		v:SetScript("OnEnterPressed", submit)
		v:SetScript("OnTextChanged", validate)
		v:SetScript("OnEditFocusLost", EditBox_ClearHighlight)
	end
	btnNewRing:SetScript("OnClick", function()
		title:SetText(L"Create a New Ring")
		toggle1:SetText(L"Empty ring")
		toggle2:SetText(L"Import snapshot")
		local w1, w2 = 32+toggle1:GetFontString():GetStringWidth(), 32+toggle2:GetFontString():GetStringWidth()
		toggle1:SetWidth(math.max(w1, 350 - math.max(175, w2)))
		toggle2:SetWidth(math.max(w2, 350 - math.max(175, w1)))
		nameLabel:SetText(L"Ring name:")
		snapLabel:SetText(L"Snapshot:")
		accept:SetText(L"Add Ring")
		cancel:SetText(L"Cancel")
		snap:SetText("")
		snap.cachedText, snap.cachedValue = nil
		name:SetText("")
		toggle1:Click()
		accept:Disable()
		conf.overlay(panel, newRing)
		name:SetFocus()
	end)
end

ringContainer = CreateFrame("Frame", nil, panel) do
	ringContainer:SetPoint("TOP", ringDropDown, "BOTTOM", 75, 0)
	ringContainer:SetPoint("BOTTOM", panel, 0, 10)
	ringContainer:SetPoint("LEFT", panel, 50, 0)
	ringContainer:SetPoint("RIGHT", panel, -10, 0)
	CreateEdge(ringContainer, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", tile=true, edgeSize=8}, nil, 0x7f7f7f)
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
			SetCursor(self.tex:GetTexture())
		end
		local function dragStop(self)
			if ringContainer.disableSliceDrag then return end
			local source, x, y = self.source, GetCursorPosition()
			self.source = nil
			PlaySound(833)
			SetCursor(nil)
			local scale, l, b, w, h = self:GetEffectiveScale(), self:GetRect()
			local dy, dx = math.floor(-(y / scale - b - h-1)/(h+2)), x / scale - l
			if dx < -2*w or dx > 2*w then return api.deleteSlice(source) end
			if dx < -w/2 or dx > 3*w/2 then return end
			local dest = self:GetID() + dy
			if not ringContainer.slices[dest+1] or not ringContainer.slices[dest+1]:IsShown() then return end
			dest = api.resolveSliceOffset(dest)
			if dest ~= source then api.moveSlice(source, dest) end
		end
		local function dragAbort(self)
			if self.source then
				SetCursor(nil)
				self.source = nil
			end
		end
		for i=0,11 do
			local ico = createIconButton(nil, ringContainer, i)
			ico:SetPoint("TOP", ringContainer.prev, "BOTTOMRIGHT", -2, -34*i+2)
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
	ringContainer.newSlice = createIconButton(nil, ringContainer) do
		local b = ringContainer.newSlice
		b:SetSize(24,24) b.tex:SetTexture("Interface/GuildBankFrame/UI-GuildBankFrame-NewTab")
		b:SetScript("OnClick", function(self)
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			conf.ui.HideTooltip(self)
			if IsAltKeyDown() then
				self:SetChecked(not self:GetChecked())
				conf.prompt(panel, L"Custom slice", L"Input a slice action specification:", (L"Example: %s."):format(GREEN_FONT_COLOR_CODE .. '"item", 19019|r'), nil, api.addCustomSlice, 0.95)
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
		b:SetScript("OnLeave", conf.ui.HideTooltip)
		b:SetPoint("TOP", ringContainer.slices[12], "BOTTOM", 0, -2)
	end
end
ringDetail = CreateFrame("Frame", nil, ringContainer) do
	ringDetail:SetAllPoints()
	ringDetail:SetScript("OnKeyDown", function(self, key)
		self:SetPropagateKeyboardInput(key ~= "ESCAPE")
		if key == "ESCAPE" then
			api.deselectRing()
		end
	end)
	ringDetail.name = CreateFrame("EditBox", nil, ringDetail)
	ringDetail.name:SetHeight(20) ringDetail.name:SetPoint("TOPLEFT", 7, -7) ringDetail.name:SetPoint("TOPRIGHT", -7, -7) ringDetail.name:SetFontObject(GameFontNormalLarge) ringDetail.name:SetAutoFocus(false)
	prepEditBox(ringDetail.name, function(self) api.setRingProperty("name", self:GetText()) end)
	local tex = ringDetail.name:CreateTexture()
	tex:SetHeight(1) tex:SetPoint("BOTTOMLEFT", 0, -2) tex:SetPoint("BOTTOMRIGHT", 0, -2)
	tex:SetColorTexture(1,0.82,0, 0.5)
	ringDetail.scope = CreateFrame("Frame", "RKC_RingScopeDropDown", ringDetail, "UIDropDownMenuTemplate")
	ringDetail.scope:SetPoint("TOPLEFT", 250, -37) UIDropDownMenu_SetWidth(ringDetail.scope, 250)
	ringDetail.scope.label = ringDetail.scope:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	ringDetail.scope.label:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 10, -47)
	ringDetail.scope.label:SetText(L"Make this ring available to:")
	ringDetail.binding = conf.createBindingButton(ringDetail)
	ringDetail.bindingContainerFrame = panel
	ringDetail.binding:SetPoint("TOPLEFT", 267, -68) ringDetail.binding:SetWidth(265)
	function ringDetail:SetBinding(bind) return api.setRingProperty("hotkey", bind) end
	function ringDetail:OnBindingAltClick() self:ToggleAlternateEditor(api.getRingProperty("hotkey")) end
	ringDetail.binding.label = ringDetail.scope:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	ringDetail.binding.label:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 10, -73)
	ringDetail.binding.label:SetText(L"Binding:")
	ringDetail.bindingQuarantine = CreateFrame("CheckButton", nil, ringDetail, "InterfaceOptionsCheckButtonTemplate")
	ringDetail.bindingQuarantine:SetHitRectInsets(0,0,0,0)
	ringDetail.bindingQuarantine:SetPoint("RIGHT", ringDetail.binding, "LEFT", 0, 0)
	ringDetail.bindingQuarantine:SetScript("OnClick", function() api.setRingProperty("hotkey", api.getRingProperty("quarantineBind")) end)
	ringDetail.bindingQuarantine:SetScript("OnEnter", conf.ui.ShowControlTooltip)
	ringDetail.bindingQuarantine:SetScript("OnLeave", conf.ui.HideTooltip)
	ringDetail.bindingQuarantine.tooltipText = L"To enable the default binding for this ring, check this box or change the binding."
	ringDetail.rotation = CreateFrame("Slider", "RKC_RingRotation", ringDetail, "OptionsSliderTemplate")
	ringDetail.rotation:SetPoint("TOPLEFT", 270, -95) ringDetail.rotation:SetWidth(260) ringDetail.rotation:SetMinMaxValues(0, 345) ringDetail.rotation:SetValueStep(15) ringDetail.rotation:SetObeyStepOnDrag(true)
	ringDetail.rotation:SetScript("OnValueChanged", function(_, value) api.setRingProperty("offset", value) end)
	RKC_RingRotationLow:SetText("0°") RKC_RingRotationHigh:SetText("345°")
	ringDetail.rotation.label = ringDetail.scope:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	ringDetail.rotation.label:SetPoint("TOPLEFT", ringDetail, "TOPLEFT", 10, -96)
	ringDetail.rotation.label:SetText(L"Rotation:")
	ringDetail.opportunistCA = CreateFrame("CheckButton", nil, ringDetail, "InterfaceOptionsCheckButtonTemplate")
	ringDetail.opportunistCA:SetPoint("TOPLEFT", 266, -118)
	ringDetail.opportunistCA:SetMotionScriptsWhileDisabled(1)
	ringDetail.opportunistCA.Text:SetText(L"Pre-select a quick action slice")
	ringDetail.opportunistCA:SetScript("OnEnter", conf.ui.ShowControlTooltip)
	ringDetail.opportunistCA:SetScript("OnLeave", conf.ui.HideTooltip)
	ringDetail.opportunistCA:SetScript("OnClick", function(self) api.setRingProperty("noOpportunisticCA", (not self:GetChecked()) or nil) api.setRingProperty("noPersistentCA", (not self:GetChecked()) or nil) end)
	ringDetail.hiddenRing = CreateFrame("CheckButton", nil, ringDetail, "InterfaceOptionsCheckButtonTemplate")
	ringDetail.hiddenRing:SetPoint("TOPLEFT", ringDetail.opportunistCA, "BOTTOMLEFT", 0, 2)
	ringDetail.hiddenRing.Text:SetText(L"Hide this ring")
	ringDetail.hiddenRing:SetScript("OnClick", function(self) api.setRingProperty("internal", self:GetChecked() and true or nil) end)
	ringDetail.embedRing = CreateFrame("CheckButton", nil, ringDetail, "InterfaceOptionsCheckButtonTemplate")
	ringDetail.embedRing:SetPoint("TOPLEFT", ringDetail.hiddenRing, "BOTTOMLEFT", 0, 2)
	ringDetail.embedRing.Text:SetText(L"Embed into other rings by default")
	ringDetail.embedRing:SetScript("OnClick", function(self) api.setRingProperty("embed", self:GetChecked() and true or nil) end)
	ringDetail.firstOnOpen = CreateFrame("CheckButton", nil, ringDetail, "InterfaceOptionsCheckButtonTemplate") do
		local f = ringDetail.firstOnOpen
		f:SetPoint("TOPLEFT", ringDetail.embedRing, "BOTTOMLEFT", 0, 2)
		f:SetMotionScriptsWhileDisabled(1)
		f.Text:SetText(L"Use first slice when opened")
		f:SetScript("OnClick", function(self)
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
	ringDetail.export:SetPoint("TOP", ringDetail.shareLabel2, "BOTTOM", 0, -3)
	ringDetail.export:SetText(L"Share ring")
	ringDetail.export:SetScript("OnClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.exportRing() end)
	
	local exportBg, scroll = CreateFrame("Frame", nil, ringDetail)
	CreateEdge(exportBg, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=4,right=4,bottom=4,top=4}}, 0xb2000000, 0xb2b2b2)
	exportBg:SetSize(265, 124) exportBg:Hide()
	exportBg:SetPoint("TOPLEFT", ringDetail.shareLabel2, "BOTTOMLEFT", -2, -2)
	ringDetail.exportFrame, ringDetail.exportInput, scroll = exportBg, conf.ui.multilineInput("RKC_ExportInput", exportBg, 235)
	scroll:SetPoint("TOPLEFT", 5, -4) scroll:SetPoint("BOTTOMRIGHT", -26, 4)
	ringDetail.exportInput:SetFontObject(GameFontHighlightSmall)
	ringDetail.exportInput:SetScript("OnEscapePressed", function() exportBg:Hide() ringDetail.export:Show() end)
	ringDetail.exportInput:SetScript("OnChar", function(self) local text = self:GetText() if text ~= "" and text ~= self.text then self:SetText(self.text or "") self:SetCursorPosition(0) self:HighlightText() end end)
	ringDetail.exportInput:SetScript("OnTextSet", function(self) self.text = self:GetText() end)
	exportBg:SetScript("OnHide", function(self)
		self:Hide()
		ringDetail.export:Show()
		ringDetail.shareLabel2:SetText(L"Take a snapshot of this ring to share it with others.")
	end)
	exportBg:SetScript("OnShow", function()
		ringDetail.export:Hide()
		ringDetail.shareLabel2:SetText((L"Import snapshots by clicking %s above."):format(NORMAL_FONT_COLOR_CODE .. L"New Ring..." .. "|r"))
	end)
	
	ringDetail.remove = CreateButton(ringDetail)
	ringDetail.remove:SetPoint("BOTTOMRIGHT", -10, 10)
	ringDetail.remove:SetText(L"Delete ring")
	ringDetail.remove:SetScript("OnClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.deleteRing() end)
	
	ringDetail.restore = CreateButton(ringDetail)
	ringDetail.restore:SetPoint("RIGHT", ringDetail.remove, "LEFT", -10, 0)
	ringDetail.restore:SetText(L"Restore default")
	ringDetail.restore:SetScript("OnClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) api.restoreDefault() end)

	ringDetail:Hide()
end
sliceDetail = CreateFrame("Frame", nil, ringContainer) do
	sliceDetail:SetAllPoints()
	sliceDetail.desc = sliceDetail:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	sliceDetail.desc:SetPoint("TOPLEFT", 7, -9) sliceDetail.desc:SetPoint("TOPRIGHT", -7, -7) sliceDetail.desc:SetJustifyH("LEFT")
	sliceDetail:SetScript("OnKeyDown", function(self, key)
		self:SetPropagateKeyboardInput(key ~= "ESCAPE")
		if key == "ESCAPE" then
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
		s.label:SetPoint("TOPLEFT", sliceDetail, "TOPLEFT", 10, -47)
		s.label:SetText(L"Show this slice for:")
	end
	sliceDetail.showConditional = conf.ui.lineInput(sliceDetail, true, 260) do
		local c = sliceDetail.showConditional
		c:SetPoint("TOPLEFT", 274, -oy)
		oy = oy + 23
		c.label = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		c.label:SetPoint("TOPLEFT", sliceDetail, "TOPLEFT", 10, -73)
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
		c:SetScript("OnLeave", conf.ui.HideTooltip)
	end
	sliceDetail.color = conf.ui.lineInput(sliceDetail, true, 85) do
		local c = sliceDetail.color
		c:SetPoint("TOPLEFT", 274, -oy)
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
		c.label:SetPoint("TOPLEFT", sliceDetail, "TOPLEFT", 10, -96)
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
		local function update(v)
			if ColorPickerFrame:IsShown() or v then return end
			api.setSliceProperty("color", ColorPickerFrame:GetColorRGB())
		end
		b:SetScript("OnClick", function()
			local cp = ColorPickerFrame
			cp.previousValues, cp.hasOpacity, cp.func, cp.cancelFunc = true
			cp:SetColorRGB(ctex:GetVertexColor()) cp:Show()
			cp.func, cp.cancelFunc = update, update
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
		f.label:SetPoint("TOPLEFT", sliceDetail, "TOPLEFT", 10, -119)
		f.label:SetText(L"Icon:")
		
		local frame = CreateFrame("Frame", nil, f)
		CreateEdge(frame, {bgFile = "Interface/ChatFrame/ChatFrameBackground", edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, insets = { left = 11, right = 11, top = 12, bottom = 10 }}, 0xd8000000)
		frame:SetSize(554, 19+34*6) frame:SetPoint("TOPLEFT", f, "TOPLEFT", -265, -18) frame:SetFrameStrata("DIALOG")
		frame:EnableMouse(1) frame:SetToplevel(1) frame:Hide()
		f:SetScript("OnClick", function() frame:SetShown(not frame:IsShown()) PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) end)
		frame:SetScript("OnHide", frame.Hide)
		do
			local ed = conf.ui.lineInput(frame, false, 280)
			local hint = ed:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			hint:SetPoint("CENTER")
			hint:SetText("|cffa0a0a0" .. L"(enter an icon name or path here)")
			local bg = ed:CreateTexture(nil, "BACKGROUND", nil, -8)
			bg:SetColorTexture(0,0,0,0.95)
			bg:SetPoint("TOPLEFT", -3, 3)
			bg:SetPoint("BOTTOMRIGHT", 3, -3)
			ed:SetPoint("BOTTOM", 0, 8)
			ed:SetFrameLevel(ed:GetFrameLevel()+5)
			ed:SetScript("OnEditFocusGained", function() hint:Hide() end)
			ed:SetScript("OnEditFocusLost", function(self) hint:SetShown(not self:GetText():match("%S")) end)
			ed:SetScript("OnEnterPressed", function(self)
				local text = self:GetText()
				if text:match("%S") then
					local path = GetPositiveFileIDFromPath(text)
					path = path or GetPositiveFileIDFromPath("Interface\\Icons\\" .. text)
					api.setSliceProperty("icon", path or text)
				end
				self:SetText("")
				self:ClearFocus()
			end)
			ed:SetScript("OnEscapePressed", function(self) self:SetText("") self:ClearFocus() end)
			frame.textInput, frame.textInputHint = ed, hint
			frame:SetScript("OnKeyDown", function(self, key)
				self:SetPropagateKeyboardInput(key ~= "TAB" and key ~= "ESCAPE")
				if key == "TAB" then
					ed:SetFocus()
				elseif key == "ESCAPE" then
					frame:Hide()
				end
			end)
		end
		local icons, selectedIcon = {}
		local function onClick(self)
			if selectedIcon then selectedIcon:SetChecked(nil) end
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			api.setSliceProperty("icon", self:GetChecked() and self.tex:GetTexture() or nil)
			selectedIcon = self:GetChecked() and self or nil
		end
		for i=0,89 do
			local j = createIconButton(nil, frame, i)
			j:SetPoint("TOPLEFT", (i % 15)*34+12, -11 - 34*math.floor(i / 15))
			j:SetScript("OnClick", onClick)
			icons[i] = j
		end
		local icontex, initTexture = {}, nil
		local slider = CreateFrame("Slider", "RKC_IconSelectionSlider", frame, "UIPanelScrollBarTrimTemplate")
			slider:SetPoint("TOPRIGHT",-11, -26) slider:SetPoint("BOTTOMRIGHT", -11, 25)
			slider:SetValueStep(15) slider:SetObeyStepOnDrag(true) slider.scrollStep = 45
			slider.Up, slider.Down = RKC_IconSelectionSliderScrollUpButton, RKC_IconSelectionSliderScrollDownButton
			slider:SetScript("OnValueChanged", function(self, value)
				self.Up:SetEnabled(value > 1)
				self.Down:SetEnabled(icontex[value + #icons + 1] ~= nil)
				for i=0,#icons do
					local ico, tex = icons[i].tex, i == 0 and value == 1 and (initTexture or "Interface/Icons/INV_Misc_QuestionMark") or icontex[i+value-1]
					icons[i]:SetShown(not not tex)
					if tex then
						ico:SetTexture(tex)
						local tex = ico:GetTexture()
						icons[i]:SetChecked(f.selection == tex)
						selectedIcon = f.selection == tex and icons[i] or selectedIcon
					end
				end
			end)
		local function FixLooseIcons(f, t)
			local c = #t
			f(t)
			for i=c+1,#t do
				local e = t[i]
				if type(e) == "string" and not GetFileIDFromPath(e) then
					local c1 = e:gsub("%.$", "")
					local c2 = "Interface/Icons/" .. c1
					local c3 = "Interface/Icons/" .. e
					t[i] = GetFileIDFromPath(c1) and c1 or GetFileIDFromPath(c2) and c2 or GetFileIDFromPath(c3) and c3 or e
				end
			end
		end
		frame:SetScript("OnShow", function(self)
			self:SetFrameStrata("DIALOG")
			self:SetFrameLevel(sliceDetail.icon:GetFrameLevel()+10)
			icontex = GetMacroIcons()
			FixLooseIcons(GetLooseMacroIcons, icontex)
			GetMacroItemIcons(icontex)
			FixLooseIcons(GetLooseMacroItemIcons, icontex)
			slider:SetMinMaxValues(1, #icontex-#icons+16)
			if slider:GetValue() == 1 then
				slider:GetScript("OnValueChanged")(slider, slider:GetValue())
			else
				slider:SetValue(1)
			end
		end)
		frame:SetScript("OnMouseWheel", function(_, delta)
			slider:SetValue(slider:GetValue()-delta*15)
		end)
		function f:SetIcon(ico, forced, ext, slice)
			setIcon(self.icon, forced or ico, ext, slice)
			initTexture = self.icon:GetTexture()
			self.selection = forced
			self:SetText(forced and L"Customized icon" or L"Based on slice action")
			if frame:IsShown() then slider:GetScript("OnValueChanged")(slider, slider:GetValue()) end
		end
		function f:HidePanel()
			frame:Hide()
		end
	end
	sliceDetail.fastClick = CreateFrame("CheckButton", nil, sliceDetail, "InterfaceOptionsCheckButtonTemplate") do
		local e = sliceDetail.fastClick
		local function update(self)
			return api.setSliceProperty("fastClick", self:GetChecked() and true or nil)
		end
		e:SetHitRectInsets(0, -200, 4, 4) e:SetMotionScriptsWhileDisabled(1) e:SetScript("OnClick", update)
		e:SetPoint("TOPLEFT", 266, -oy)
		e:SetScript("OnEnter", conf.ui.ShowControlTooltip)
		e:SetScript("OnLeave", conf.ui.HideTooltip)
		e.Text:SetText(L"Allow as quick action")
		e.label = sliceDetail:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		e.label:SetPoint("TOPLEFT", sliceDetail, "TOPLEFT", 10, -142)
		e.label:SetText(L"Options:")
		oy = oy + 21
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
			cycle=L"Advance after use",
			shuffle=L"Shuffle after use",
			random=L"Randomize on display",
			reset=L"Reset on display",
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
		local f = CreateFrame("Frame", nil, sliceDetail)
		f:SetPoint("TOPLEFT", sliceDetail.fastClick.label, "BOTTOMLEFT", 0, -10)
		f:SetPoint("BOTTOMRIGHT", -10, 36)
		function f:SaveAction()
			return api.setSliceProperty("*", self.curEditor)
		end
		function f:SetEditor(editor, ...)
			if self.curEditor then
				self.curEditor:Release(self)
			end
			self.curEditor = editor
			if editor then
				editor:SetAction(self, ...)
			end
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
	sliceDetail.repick:SetPoint("TOPRIGHT", sliceDetail.remove, "TOPLEFT", -20, 0)
	sliceDetail.repick:SetText(L"Change action")
	sliceDetail.repick:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		return api.beginSliceRepick()
	end)
end
newSlice = CreateFrame("Frame", nil, ringContainer) do
	newSlice:SetAllPoints()
	newSlice:Hide()
	newSlice.slider = CreateFrame("Slider", "RKC_NewSliceCategorySlider", newSlice, "UIPanelScrollBarTrimTemplate") do
		local s = newSlice.slider
		s:SetPoint("TOPLEFT", 162, -19)
		s:SetPoint("BOTTOMLEFT", 162, 17)
		s:SetMinMaxValues(0, 20)
		s:SetValueStep(1)
		s:SetObeyStepOnDrag(true)
		s.scrollStep = 5
		s.Up, s.Down = RKC_NewSliceCategorySliderScrollUpButton, RKC_NewSliceCategorySliderScrollDownButton
		local cap = CreateFrame("Frame", nil, newSlice)
		cap:SetPoint("TOPLEFT")
		cap:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT")
		cap:SetScript("OnMouseWheel", function(_, delta)
			s:SetValue(s:GetValue()-delta)
		end)
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
		local s = conf.ui.lineInput(newSlice, true, 153)
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
			tip:AddLine(L"Press |cffffffffEnter|r to search")
			tip:AddLine(L"|cffffffffCtrl+Enter|r to search within current results", nil, nil, nil, true)
			tip:AddLine(L"|cffffffffEscape|r to cancel", true)
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
	local function onClick(self) PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) selectCategory(self:GetID()) end
	for i=1,22 do
		local b = CreateFrame("Button", nil, newSlice)
		b:SetSize(159, 20)
		b:SetNormalTexture("Interface/AchievementFrame/UI-Achievement-Category-Background")
		b:SetHighlightTexture("Interface/AchievementFrame/UI-Achievement-Category-Highlight")
		b:GetNormalTexture():SetTexCoord(7/256, 162/256, 5/32, 24/32)
		b:GetHighlightTexture():SetTexCoord(7/256, 163/256, 5/32, 24/32)
		b:GetNormalTexture():SetVertexColor(0.6, 0.6, 0.6)
		b:SetNormalFontObject(GameFontHighlight)
		b:SetHighlightFontObject(GameFontHighlight)
		b:SetPushedTextOffset(0,0)
		b:SetText(" ") b:GetFontString():SetPoint("CENTER", 0, 1)
		b:SetScript("OnClick", onClick)
		cats[i] = b
		if i > 1 then cats[i]:SetPoint("TOP", cats[i-1], "BOTTOM") end
	end
	cats[1]:SetPoint("TOPLEFT", 2, -22)

	newSlice.desc = newSlice:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	newSlice.desc:SetPoint("TOPLEFT", newSlice.slider, "TOPRIGHT", 2, 10)
	newSlice.desc:SetPoint("RIGHT", -24, 0)
	newSlice.desc:SetHeight(26)
	newSlice.desc:SetJustifyV("TOP") newSlice.desc:SetJustifyH("CENTER")
	newSlice.desc:SetText(L"Select an action by double clicking.")
	
	newSlice.close = CreateFrame("Button", "RKC_CloseNewSliceBrowser", newSlice, "UIPanelCloseButton")
	newSlice.close:SetPoint("TOPRIGHT", 3, 4)
	newSlice.close:SetSize(30, 30)
	newSlice.close:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		api.closeActionPicker("close-picker-button")
	end)
	newSlice.close:SetScript("OnKeyDown", function(self, key)
		self:SetPropagateKeyboardInput(key ~= "ESCAPE")
		if key == "ESCAPE" then
			api.closeActionPicker()
		end
	end)

	local b = newSlice.close:CreateTexture(nil, "BACKGROUND")
	if MODERN then
		b:SetAtlas("UI-Frame-TopCornerRight")
		b:SetTexCoord(9/33, 1, 0, 23/33)
	else
		b:SetTexture("Interface/FrameGeneral/UI-Frame")
		b:SetTexCoord(90/128, 114/128, 1/128, 24/128)
	end
	b:SetPoint("TOPLEFT", 4, -5) b:SetPoint("BOTTOMRIGHT", -5, 4)
	b:SetVertexColor(0.6,0.6,0.6)
	
	newSlice.slider2 = CreateFrame("Slider", "RKC_NewSliceActionSlider", newSlice, "UIPanelScrollBarTrimTemplate") do
		local s = newSlice.slider2
		s:SetPoint("TOPRIGHT", -2, -38)
		s:SetPoint("BOTTOMRIGHT", -2, 16)
		s:SetMinMaxValues(0, 20)
		s:SetValueStep(1)
		s:SetObeyStepOnDrag(true)
		s.scrollStep = 4
		s.Up, s.Down = RKC_NewSliceActionSliderScrollUpButton, RKC_NewSliceActionSliderScrollDownButton
		local cap = CreateFrame("Frame", nil, newSlice)
		cap:SetPoint("TOPRIGHT")
		cap:SetPoint("BOTTOMLEFT", newSlice.slider, "BOTTOMRIGHT")
		cap:SetScript("OnMouseWheel", function(_, delta)
			s:SetValue(s:GetValue()-delta)
		end)
	end

	local function onClick(self)
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		api.addSlice(nil, selectedCategory(self:GetID()))
	end
	local function onDragStart(self)
		if newSlice.disableDrag then return end
		PlaySound(832)
		SetCursor(self.ico:GetTexture())
	end
	local function onDragStop(self)
		if newSlice.disableDrag then return end
		PlaySound(833)
		SetCursor(nil)
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
	for i=1,24 do
		local f = CreateFrame("Button", nil, newSlice)
		f:SetSize(176, 34) f:SetPoint("TOPLEFT", newSlice.desc, "BOTTOMLEFT", 178*(1 - i % 2), -math.floor((i-1)/2)*36+3)
		f:RegisterForDrag("LeftButton")
		actions[i] = f
		f:SetScript("OnDragStart", onDragStart)
		f:SetScript("OnDragStop", onDragStop)
		f:SetScript("OnDoubleClick", onClick)
		f:SetScript("OnEnter", onEnter)
		f:SetScript("OnLeave", conf.ui.HideTooltip)
		f.ico = f:CreateTexture(nil, "ARTWORK")
		f.ico:SetSize(32,32) f.ico:SetPoint("LEFT", 1, 0)
		f.name = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		f.name:SetHeight(12)
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
		local slider = newSlice.slider2
		local base, _, maxV = math.floor(slider:GetValue())*2, slider:GetMinMaxValues()
		slider.Up:SetEnabled(base > 0)
		slider.Down:SetEnabled(base < maxV*2)
		for i=1,#actions do
			local e, id = actions[i], i + base
			if id <= #selectedCategory then
				local stype, sname, sicon, extico, tipfunc, tiparg = AB:GetActionDescription(selectedCategory(id))
				pcall(setIcon, e.ico, sicon, extico)
				e.tipFunc, e.tipFuncArg = tipfunc, tiparg
				e.name:SetText(sname)
				e.sub:SetText(stype)
				e:SetID(id)
				e:Show()
			else
				e:Hide()
			end
		end
	end
	local function syncCats(self, base)
		self.Up:SetEnabled(base > 0)
		self.Down:SetEnabled(base < select(2, self:GetMinMaxValues()))
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
		newSlice.slider2:SetMinMaxValues(0, math.max(0, math.ceil((#selectedCategory - #actions)/2)))
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
	return securecall(AB.GetActionDescription, AB, RK:UnpackABAction(slice))
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
local function copyKeys(src, dst, n, k, ...)
	if n == 0 then
		return dst
	end
	if k ~= nil then
		dst[k] = src and src[k]
	end
	return copyKeys(src, dst, n-1, ...)
end
local function countAndReturn(...)
	return select("#", ...), ...
end
local function shallowCopyArrayAndKeys(src, dst, ...)
	for k in pairs(dst) do
		if type(k) == "number" then
			dst[k] = nil
		end
	end
	if type(src) == "table" then
		for k,v in pairs(src) do
			if type(k) == "number" then
				dst[k] = v
			end
		end
	end
	copyKeys(src, dst, countAndReturn(...))
	return dst
end
local function pmethodcall(f, s, ...)
	return true, f[s](f, ...)
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
local function dropKeys(t, k, ...)
	if k == nil then return end
	t[k] = nil
	return dropKeys(t, ...)
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

local ringNameMap, ringOrderMap, ringTypeMap, ringNames, currentRing, currentRingName, sliceBaseIndex, currentSliceIndex, repickSlice = {}, {}, {}, {}
local typePrefix = {
	MINE="|cff25bdff|TInterface/FriendsFrame/UI-Toast-FriendOnlineIcon:14:14:0:1:32:32:8:24:8:24:30:190:255|t ",
	PERSONAL="|cffd659ff|TInterface/FriendsFrame/UI-Toast-FriendOnlineIcon:14:14:0:1:32:32:8:24:8:24:180:0:255|t ",
	HORDE=MODERN and "|cffff3000|A:QuestPortraitIcon-Horde-small:18:18:-1:-2|a" or "|cffff3000|A:poi-horde:16:16:-2:0|a",
	ALLIANCE=MODERN and "|cff00a0ff|A:QuestPortraitIcon-Alliance-small:20:18:-2:0|a" or "|cff00a0ff|A:poi-alliance:17:20:-2:0|a",
}
do
	for k, v in pairs(CLASS_ICON_TCOORDS) do
		typePrefix[k] = ("|cff%s|TInterface/GLUES/CHARACTERCREATE/UI-CharacterCreate-Classes:16:16:0:0:256:256:%d:%d:%d:%d|t "):format(RAID_CLASS_COLORS[k].colorStr:sub(3), v[1]*256+6,v[2]*256-6,v[3]*256+6,v[4]*256-6)
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
		ringNames = {hidden={}, other={}}
		for name, dname, active, _slices, internal, limit in RK:GetManagedRings() do
			table.insert(active and (internal and ringNames.hidden or ringNames) or ringNames.other, name)
			local isFactionLimit = (limit == "Alliance" or limit == "Horde") and limit:upper() or nil
			local rtype = type(limit) ~= "string" and "GLOBAL" or limit == playerFullName and "MINE" or isFactionLimit or limit:match("[^A-Z]") and "PERSONAL" or limit
			ringNameMap[name], ringOrderMap[name], ringTypeMap[name] = dname, (not active and (rtype == "PERSONAL" and 12 or 10)) or isFactionLimit and 4 or (limit and (limit:match("[^A-Z]") and 0 or 2)), rtype
		end
		table.sort(ringNames, sortNames)
		table.sort(ringNames.hidden, sortNames)
		table.sort(ringNames.other, sortNames)
		if #ringNames == 0 and #ringNames.hidden == 0 and #ringNames.other == 0 then
			btnNewRing:Click()
			return
		end
	elseif nameList == "overflow-main" then
		conf.ui.scrollingDropdown:Display(2, ringNames, ringDropDown_EntryFormat, api.selectRing, 16)
		return
	elseif nameList then
		conf.ui.scrollingDropdown:Display(2, nameList, ringDropDown_EntryFormat, api.selectRing)
		return
	end
	local stopAt = #ringNames > 20 and 16 or #ringNames
	for i=1,stopAt do
		local k = ringNames[i]
		info.arg1, info.text, info.checked = k, ringDropDown_EntryFormat(k)
		UIDropDownMenu_AddButton(info, level)
	end
	info.hasArrow, info.notCheckable, info.padding, info.fontObject = 1, 1, 32, GameFontNormalSmall
	info.text, info.func, info.checked = nil
	if stopAt < #ringNames then
		info.menuList, info.text = "overflow-main", L"More active rings"
		UIDropDownMenu_AddButton(info, level)
	end
	if ringNames.hidden and #ringNames.hidden > 0 then
		info.menuList, info.text = ringNames.hidden, L"Hidden rings"
		UIDropDownMenu_AddButton(info, level)
	end
	if ringNames.other and #ringNames.other > 0 then
		info.menuList, info.text = ringNames.other, L"Inactive rings"
		UIDropDownMenu_AddButton(info, level)
	end
end
function api.createRing(name, data)
	local name = name:match("^%s*(.-)%s*$")
	if name == "" then return false end
	local iname = RK:GenFreeRingName(name)
	SaveRingVersion(iname, false)
	data.name, data.limit = name, data.limit == "PLAYER" and FULLNAME or (type(data.limit) == "string" and not data.limit:match("[^A-Z]") and data.limit or nil)
	api.saveRing(iname, data)
	api:selectRing(iname)
	return true
end
function api.selectRing(_, name)
	CloseDropDownMenus()
	ringDetail:Hide()
	sliceDetail:Hide()
	newSlice:Hide()
	ringContainer.newSlice:SetChecked(nil)
	local desc = RK:GetRingDescription(name)
	currentRing, currentRingName, repickSlice = nil
	if not desc then return end
	RK:SoftSync(name)
	UIDropDownMenu_SetText(ringDropDown, desc.name or name)
	ringDetail.rotation:SetValue(desc.offset or 0)
	ringDetail.name:SetText(desc.name or name)
	ringDetail.hiddenRing:SetChecked(desc.internal)
	ringDetail.embedRing:SetChecked(desc.embed)
	currentRing, currentRingName, sliceBaseIndex, currentSliceIndex = desc, name, 1
	api.refreshDisplay()
	ringDetail:Show()
	ringDetail.scope:text()
	api.updateRingLine()
	ringContainer:Show()
end
function api.updateRingLine()
	ringContainer.prev:SetEnabled(sliceBaseIndex > 1)
	ringContainer.next:Disable()
	local onOpen, lastWidget = currentRing.onOpen
	for i=sliceBaseIndex,#currentRing do
		local e = ringContainer.slices[i-sliceBaseIndex+1]
		if not e then ringContainer.next:Enable() break end
		local _, _, sicon, icoext = getSliceInfo(currentRing[i])
		pcall(setIcon, e.tex, currentRing[i].icon or sicon, icoext, currentRing[i])
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
	if key == "hotkey" then
		if OneRingLib:GetRingInfo(currentRingName) then
			local skey, _, over = OneRingLib:GetRingBinding(currentRingName)
			if over then return skey end
		end
		if currentRing.hotkey and not OneRingLib:GetOption("UseDefaultBindings", currentRingName) then
			return currentRing.hotkey, "|cffa0a0a0"
		elseif currentRing.quarantineBind and not currentRing.hotkey then
			return currentRing.quarantineBind, "|cffa0a0a0"
		end
	end
	return currentRing[key]
end
function api.setRingProperty(name, value)
	if not currentRing then return end
	currentRing[name] = value
	if name == "limit" then
		ringDetail.scope:text()
		ringOrderMap[currentRingName] = value ~= nil and (value:match("[^A-Z]") and 0 or 2) or nil
	elseif name == "hotkey" then
		currentRing.quarantineBind = nil
		ringDetail.bindingQuarantine:Hide()
		ringDetail.binding:SetBindingText(value)
		if OneRingLib:GetRingInfo(currentRingName) then
			conf.undo.saveProfile()
			OneRingLib:SetRingBinding(currentRingName, value)
		end
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
end
function api.setSliceProperty(prop, ...)
	local slice = assert(currentRing[currentSliceIndex], "Setting a slice property on an unknown slice")
	if prop == "color" then
		local r, g, b = ...
		slice.c = r and ("%02x%02x%02x"):format(r*255, g*255, b*255) or nil
	elseif prop == "*" then
		local edOutput = {}
		(...):GetAction(edOutput)
		if type(edOutput[1]) == "string" then
			if edOutput[1] == "macrotext" and type(edOutput[2]) == "string" then
				edOutput[2] = RK:QuantizeMacro(edOutput[2])
			end
			if edOutput[1] ~= slice[1] then
				copyKeys(nil, slice, countAndReturn(AB:GetActionOptions(slice[1])))
			end
			shallowCopyArrayAndKeys(edOutput, slice, AB:GetActionOptions(edOutput[1]))
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
		if prop ~= "color" then sliceDetail.icon:SetIcon(ico, slice.icon, icoext, currentRing[currentSliceIndex]) end
		sliceDetail.color:SetColor(getSliceColor(slice, ico))
	end
	api.updateRingLine()
end
function api.updateSliceOptions(slice)
	local extraY, isCollection = 0, securecall(isCollectionSlice, RK:UnpackABAction(slice))
	local fc, cd = sliceDetail.fastClick, sliceDetail.collectionDrop
	fc:SetChecked(not not slice.fastClick)
	if OneRingLib:GetOption("CenterAction", currentRingName) then
		fc:SetEnabled(true)
		fc.tooltipText = nil
		fc.Text:SetVertexColor(1, 1, 1)
	else
		fc.tooltipText = (L"You must enable the %s option for this ring in OPie options to use quick actions."):format("|cffffffff" .. L"Quick action at ring center" .. "|r")
		fc:SetChecked(false)
		fc:SetEnabled(false)
		fc.Text:SetVertexColor(0.6, 0.6, 0.6)
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
		sliceDetail:Hide()
		newSlice:Hide()
		api.endSliceRepick()
		currentSliceIndex = nil
		ringDetail:Show()
		api.updateRingLine()
		return
	end
	ringDetail:Hide()
	newSlice:Hide()
	sliceDetail:Hide()
	ringContainer.newSlice:SetChecked(nil)
	local old, id = ringContainer.slices[(currentSliceIndex or 0) + 1 - sliceBaseIndex], sliceBaseIndex + offset
	local desc = currentRing[id]
	if old then old:SetChecked(nil) end
	currentSliceIndex = nil
	if not desc then return ringDetail:Show() end
	api.updateSliceDisplay(id, desc)
	api.endSliceRepick()
	sliceDetail:Show()
	currentSliceIndex = id
end
function api.updateSliceDisplay(_id, desc)
	local stype, sname, sicon, icoext = getSliceInfo(desc)
	if sname ~= "" then
		sliceDetail.desc:SetFormattedText("%s: |cffffffff%s|r", stype or "?", sname or "?")
	else
		sliceDetail.desc:SetText(stype or "?")
	end
	local skipSpecs, showConditional = (desc.show or ""):match("^%[spec:([%d/]+)%] hide;(.*)")
	sliceDetail.icon:HidePanel()
	sliceDetail.icon:SetIcon(sicon, desc.icon, icoext, desc)
	sliceDetail.color:SetColor(getSliceColor(desc, sicon))
	sliceDetail.skipSpecs:SetValue(skipSpecs)
	sliceDetail.showConditional:SetText(showConditional or desc.show or "")
	api.updateSliceOptions(desc)
	local ep = AB:GetEditorPanel(desc[1])
	local desc2 = ep and shallowCopyArrayAndKeys(desc, {}, AB:GetActionOptions(desc[1])) or nil
	if not securecall(pmethodcall, sliceDetail.editorContainer, "SetEditor", ep, desc2) then
		securecall(pmethodcall, sliceDetail.editorContainer, "SetEditor", nil)
	end
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
			sliceDetail:Hide()
			currentSliceIndex = nil
			ringDetail:Show()
		end
		table.remove(currentRing, id)
		if sliceBaseIndex == id and sliceBaseIndex > 1 then
			sliceBaseIndex = sliceBaseIndex - 1
		end
		api.saveRing(currentRingName, currentRing)
		api.updateRingLine()
	end
end
function api.beginSliceRepick()
	repickSlice = currentRing[currentSliceIndex]
	sliceDetail:Hide()
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
		conf.undo.saveProfile()
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
function api.addSlice(pos, ...)
	local wasRepick
	if pos == nil and repickSlice then
		local otid = repickSlice[1]
		for k in pairs(repickSlice) do
			if type(k) == "number" then
				repickSlice[k] = nil
			end
		end
		dropKeys(repickSlice, AB:GetActionOptions(otid))
		for i=1,select("#", ...),2 do
			repickSlice[i], repickSlice[i+1] = select(i, ...)
		end
		wasRepick = true
	else
		pos = math.max(1, math.min(#currentRing+1, pos and (pos + sliceBaseIndex) or (#currentRing+1)))
		table.insert(currentRing, pos, {...})
		if pos < sliceBaseIndex then sliceBaseIndex = pos end
	end
	api.saveRing(currentRingName, currentRing)
	api.updateRingLine()
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
	ringDetail.exportFrame:Hide()
end
function api.refreshDisplay()
	if currentRing and currentRing[currentSliceIndex] then
		api.updateSliceOptions(currentRing[currentSliceIndex])
	end
	if currentRing then
		ringDetail.binding:SetBindingText(api.getRingProperty("hotkey"))
		ringDetail.exportFrame:GetScript("OnHide")(ringDetail.exportFrame)
		local noCA = not OneRingLib:GetOption("CenterAction", currentRingName) and (L"You must enable the %s option for this ring in OPie options to use quick actions."):format("|cffffffff" .. L"Quick action at ring center" .. "|r") or nil
		ringDetail.opportunistCA.tooltipText = noCA
		ringDetail.opportunistCA:SetEnabled(not noCA)
		ringDetail.opportunistCA:SetChecked(not noCA and not currentRing.noOpportunisticCA)
		ringDetail.opportunistCA.Text:SetVertexColor(noCA and 0.6 or 1,noCA and 0.6 or 1,noCA and 0.6 or 1)
		ringDetail.bindingQuarantine:SetShown(not not currentRing.quarantineBind)
		ringDetail.bindingQuarantine:SetChecked(nil)
		ringDetail.firstOnOpen:SetChecked(currentRing.onOpen == 1)
		ringDetail.firstOnOpen.quarantineMark:SetShown(currentRing.quarantineOnOpen == 1)
	end
end
function api.exportRing()
	local input = ringDetail.exportInput
	ringDetail.export:Hide()
	ringDetail.exportFrame:Show()
	input:SetText(RK:GetRingSnapshot(currentRingName))
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

function panel:refresh()
	UIDropDownMenu_SetText(ringDropDown, L"Select a ring to modify")
	currentRingName, currentRing, currentSliceIndex, ringNames = nil
	ringContainer:Hide()
	ringDetail:Hide()
	sliceDetail:Hide()
	newSlice:Hide()
end
function panel:okay()
	ringContainer:Hide()
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
local function prot(f)
	return function() return securecall(f) end
end
panel.okay, panel.default, panel.refresh = prot(panel.okay), prot(panel.default), prot(panel.refresh)
panel:SetScript("OnShow", conf.checkSVState)

SLASH_OPIE_CUSTOM_RINGS1 = "/rk"
function SlashCmdList.OPIE_CUSTOM_RINGS()
	conf.open(panel)
end
T.AddSlashSuffix(SlashCmdList.OPIE_CUSTOM_RINGS, "custom", "rings")