local M, I, _, T, TEN = {}, {}, ...
T.TenSettings, TEN = M, select(4, GetBuildInfo()) >= 10e4
local CreateEdge = T.CreateEdge

if TEN then
	local WINDOW_PADDING_H, WINDOW_PADDING_TOP, WINDOW_ACTIONS_HEIGHT, WINDOW_PADDING_BOTTOM = 10, 30, 30, 15
	local WINDOW_LEFT_GAP = 5
	local CONTAINER_TABS_YOFFSET, CONTAINER_CONTENT_TOP_YOFFSET, CONTAINER_TITLE_YOFFSET = 11, -26, -4
	local CONTAINER_PADDING_H, CONTAINER_PADDING_V = 10, 6
	local PANEL_VIEW_MARGIN_TOP, PANEL_VIEW_MARGIN_TOP_TITLESHIFT = -14, -35
	local PANEL_VIEW_MARGIN_LEFT, PANEL_VIEW_MARGIN_RIGHT = -15, -10
	
	local PANEL_WIDTH, PANEL_HEIGHT = 585, 528
	local CONTAINER_WIDTH = PANEL_WIDTH + CONTAINER_PADDING_H * 2
	local CONTAINER_HEIGHT = PANEL_HEIGHT - CONTAINER_CONTENT_TOP_YOFFSET + CONTAINER_PADDING_V*2
	local WINDOW_WIDTH = CONTAINER_WIDTH + WINDOW_PADDING_H * 2
	local WINDOW_HEIGHT = CONTAINER_HEIGHT + WINDOW_PADDING_TOP + WINDOW_ACTIONS_HEIGHT + WINDOW_PADDING_BOTTOM

	local TenSettingsFrame = CreateFrame("Frame", "TenSettingsFrame", UIParent, "SettingsFrameTemplate") do
		TenSettingsFrame:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT)
		TenSettingsFrame:SetPoint("CENTER", 0, 50)
		TenSettingsFrame.NineSlice.Text:SetText(OPTIONS)
		TenSettingsFrame:SetFrameStrata("HIGH")
		TenSettingsFrame:Hide()
		TenSettingsFrame:SetMouseClickEnabled(true)
		TenSettingsFrame:SetMouseMotionEnabled(true)
		TenSettingsFrame:SetClampedToScreen(true)
		TenSettingsFrame:SetClampRectInsets(WINDOW_LEFT_GAP,0,0,0)
		local cancel = CreateFrame("Button", nil, TenSettingsFrame, "UIPanelButtonTemplate")
		cancel:SetSize(110, 24)
		cancel:SetPoint("BOTTOMRIGHT", -WINDOW_PADDING_H, WINDOW_PADDING_BOTTOM)
		cancel:SetText(CANCEL)
		TenSettingsFrame.Cancel = cancel
		local save = CreateFrame("Button", nil, TenSettingsFrame, "UIPanelButtonTemplate")
		save:SetSize(110, 24)
		save:SetPoint("RIGHT", cancel, "LEFT", -4, 0)
		save:SetText(OKAY)
		TenSettingsFrame.Save = save
		local defaults = CreateFrame("Button", nil, TenSettingsFrame, "UIPanelButtonTemplate")
		defaults:SetSize(110, 24)
		defaults:SetPoint("BOTTOMLEFT", WINDOW_PADDING_H + WINDOW_LEFT_GAP/2, WINDOW_PADDING_BOTTOM)
		defaults:SetText(DEFAULTS)
		TenSettingsFrame.Reset = defaults
		TenSettingsFrame.ClosePanelButton:SetScript("PostClick", function()
			PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
		end)
		TenSettingsFrame:SetScript("OnKeyDown", function(self, key)
			self:SetPropagateKeyboardInput(key ~= "ESCAPE")
			if key == "ESCAPE" then
				self.ClosePanelButton:Click()
			end
		end)
		table.insert(UISpecialFrames, TenSettingsFrame:GetName())
		local dragHandle = CreateFrame("Frame", nil, TenSettingsFrame) do
			dragHandle:SetPoint("TOPLEFT", TenSettingsFrame, "TOPLEFT", 4, 0)
			dragHandle:SetPoint("BOTTOMRIGHT", TenSettingsFrame, "TOPRIGHT", -28, -20)
			dragHandle:RegisterForDrag("LeftButton")
			dragHandle:SetScript("OnEnter", function()
				SetCursor("Interface/CURSOR/UI-Cursor-Move.crosshair")
			end)
			dragHandle:SetScript("OnLeave", function()
				SetCursor(nil)
			end)
			dragHandle:SetScript("OnDragStart", function()
				TenSettingsFrame:SetMovable(true)
				TenSettingsFrame:StartMoving()
			end)
			dragHandle:SetScript("OnDragStop", function()
				TenSettingsFrame:StopMovingOrSizing()
			end)
		end
	end
	
	local minitabs = {}
	local function minitab_deselect(self)
		local r = minitabs[self]
		r.Text:SetPoint("BOTTOM", 0, 6)
		r.Text:SetFontObject("GameFontNormalSmall")
		r.Left:SetAtlas("Options_Tab_Left", true)
		r.Middle:SetAtlas("Options_Tab_Middle", true)
		r.Right:SetAtlas("Options_Tab_Right", true)
		r.NormalBG:SetPoint("TOPRIGHT", -2, -15)
		r.HighlightBG:SetColorTexture(1,1,1,1)
		r.SelectedBG:SetColorTexture(0,0,0,0)
		self:SetNormalFontObject(GameFontNormalSmall)
	end
	local function minitab_select(self)
		local r = minitabs[self]
		r.Text:SetPoint("BOTTOM", 0, 8)
		r.Text:SetFontObject("GameFontHighlightSmall")
		r.Left:SetAtlas("Options_Tab_Active_Left", true)
		r.Middle:SetAtlas("Options_Tab_Active_Middle", true)
		r.Right:SetAtlas("Options_Tab_Active_Right", true)
		r.NormalBG:SetPoint("TOPRIGHT", -2, -12)
		r.HighlightBG:SetColorTexture(0,0,0,0)
		r.SelectedBG:SetColorTexture(1,1,1,1)
		self:SetNormalFontObject(GameFontHighlightSmall)
	end
	local function minitab_new(parent, text)
		local b, r, t = CreateFrame("Button", nil, parent), {}
		minitabs[b], r.f = r, b
		t = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		b:SetFontString(t)
		t:ClearAllPoints()
		t:SetPoint("BOTTOM", 0, 6)
		b:SetNormalFontObject(GameFontNormalSmall)
		b:SetDisabledFontObject(GameFontDisableSmall)
		b:SetHighlightFontObject(GameFontHighlightSmall)
		b:SetPushedTextOffset(0, 0)
		t:SetText(text)
		t, r.Text = b:CreateTexture(nil, "BACKGROUND"), t
		t:SetPoint("BOTTOMLEFT")
		t, r.Left = b:CreateTexture(nil, "BACKGROUND"), t
		t:SetPoint("BOTTOMRIGHT")
		t, r.Right = b:CreateTexture(nil, "BACKGROUND"), t
		t:SetPoint("TOPLEFT", r.Left, "TOPRIGHT", 0, 0)
		t:SetPoint("TOPRIGHT", r.Right, "TOPLEFT", 0, 0)
		t, r.Middle = b:CreateTexture(nil, "BACKGROUND", nil, -2), t
		t:SetPoint("BOTTOMLEFT", 2, 0)
		t:SetPoint("TOPRIGHT", -2, -15)
		t:SetColorTexture(1,1,1,1)
		t:SetGradient("VERTICAL", {r=0.1, g=0.1, b=0.1, a=0.85}, {r=0.15, g=0.15, b=0.15, a=0.85})
		t, r.NormalBG = b:CreateTexture(nil, "HIGHLIGHT"), t
		t:SetPoint("BOTTOMLEFT", 2, 0)
		t:SetPoint("TOPRIGHT", b, "BOTTOMRIGHT", -2, 12)
		t:SetColorTexture(1,1,1, 1)
		t:SetGradient("VERTICAL", {r=1, g=1, b=1, a=0.15}, {r=0, g=0, b=0, a=0})
		t, r.HighlightBG = b:CreateTexture(nil, "BACKGROUND", nil, -1), t
		t:SetPoint("BOTTOMLEFT", 2, 0)
		t:SetPoint("TOPRIGHT", b, "BOTTOMRIGHT", -2, 16)
		t:SetGradient("VERTICAL", {r=1, g=1, b=1, a=0.15}, {r=0, g=0, b=0, a=0})
		r.SelectedBG = t
		b:SetSize(r.Text:GetStringWidth()+40, 37)
		minitab_deselect(b)
		return b
	end
	
	local containers = {}
	local container_notifications, container_notifications_internal = {}, {} do
		local function container_notify_panels(self, notification, ...)
			local ci = containers[self]
			local onlyNotifyCurrentPanel = (...) == "current-panel-only"
			for i=1, math.max(#ci.tabs, 1) do
				local panel = ci.tabs[ci.tabs[i]] or ci.root
				if panel[notification] and (ci.currentPanel == panel or not onlyNotifyCurrentPanel) then
					securecall(panel[notification], panel)
				end
			end
			if container_notifications_internal[notification] then
				securecall(container_notifications_internal[notification], self, ...)
			end
		end
		for s in ("okay cancel default refresh"):gmatch("%S+") do
			container_notifications[s] = function(self, ...)
				container_notify_panels(self, s, ...)
			end
		end
	end
	local function container_setTenant(ci, newPanel)
		if ci.currentPanel == newPanel then return end
		local t
		if ci.currentPanel then
			ci.currentPanel:Hide()
			local t = ci.tabs[ci.currentPanel]
			minitab_deselect(t)
		end
		t, ci.currentPanel = ci.tabs[newPanel], newPanel
		minitab_select(t)
		local oy = -PANEL_VIEW_MARGIN_TOP
		if newPanel.TenSettings_TitleBlock then
			newPanel.title:Hide()
			newPanel.version:Hide()
			ci.Version:SetText((ci.forceRootVersion and ci.root or newPanel).version:GetText() or "")
			oy = -PANEL_VIEW_MARGIN_TOP_TITLESHIFT
		end
		newPanel:SetParent(ci.View)
		newPanel:ClearAllPoints()
		newPanel:SetPoint("TOPLEFT", CONTAINER_PADDING_H + PANEL_VIEW_MARGIN_LEFT, oy - CONTAINER_PADDING_V)
		newPanel:SetPoint("BOTTOMRIGHT", -PANEL_VIEW_MARGIN_RIGHT - CONTAINER_PADDING_H, CONTAINER_PADDING_V)
		newPanel:Show()
		if newPanel.refresh and ci.f:IsShown() then
			securecall(newPanel.refresh, newPanel)
		end
		return true
	end
	local function container_selectTab(self, button)
		local ci = containers[self:GetParent()]
		local newPanel = ci.tabs[self]
		if container_setTenant(ci, newPanel) and button then
			PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
		end
	end
	local function container_addTab(tabs, parent, panel, text)
		local prev, idx = tabs[#tabs], #tabs+1
		local tab = minitab_new(parent, text or panel.name)
		tabs[idx], tabs[panel], tabs[tab] = tab, tab, panel
		tab:SetPoint("TOPRIGHT", -10, CONTAINER_TABS_YOFFSET)
		tab:SetScript("OnClick", container_selectTab)
		if prev == nil then
			container_selectTab(tab, nil)
		else
			prev:SetPoint("TOPRIGHT", tab, "TOPLEFT", -4, 0)
		end
		return tab
	end
	local function container_onCanvasShow(self)
		local ci = containers[self]
		local cf = ci.f
		if cf:GetParent() ~= self then
			cf:ClearAllPoints()
			cf:SetParent(self)
			cf:SetPoint("CENTER", -5, 0)
			cf:Show()
		end
	end
	local function container_new(name, rootPanel, opts)
		local cf = CreateFrame("Frame") do
			cf:Hide()
			cf:SetClipsChildren(true)
			cf:SetScript("OnMouseWheel", function() end)
			local cn = container_notifications
			cf.OnCommit, cf.OnDefault, cf.OnRefresh, cf.OnCancel = cn.okay, cn.default, cn.refresh, cn.cancel
			cf:SetSize(CONTAINER_WIDTH, CONTAINER_HEIGHT)
		end
		local ci = {f=cf, tabs={}, name=name, root=rootPanel}
		local t = cf:CreateTexture(nil, "BACKGROUND")
		t:SetAtlas("Options_InnerFrame")
		t:SetPoint("TOPLEFT", 0, CONTAINER_CONTENT_TOP_YOFFSET)
		t:SetPoint("BOTTOMRIGHT", cf, "BOTTOM", 0, 0)
		t:SetTexCoord(1,0.64, 0,1)
		t = cf:CreateTexture(nil, "BACKGROUND")
		t:SetAtlas("Options_InnerFrame")
		t:SetPoint("TOPRIGHT", 0, CONTAINER_CONTENT_TOP_YOFFSET)
		t:SetPoint("BOTTOMLEFT", cf, "BOTTOM", 0, 0)
		t:SetTexCoord(0.64,1, 0,1)
		t = cf:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
		t:SetPoint("TOPLEFT", 5, CONTAINER_TITLE_YOFFSET)
		t:SetText(name)
		t, ci.Title = cf:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"), t
		t:SetPoint("TOPLEFT", ci.Title, "TOPRIGHT", 4, 2)
		t, ci.Version = CreateFrame("Frame", nil, cf), t
		t:SetPoint("TOPLEFT", 0, CONTAINER_CONTENT_TOP_YOFFSET)
		t:SetPoint("BOTTOMRIGHT", 0, 0)
		t:SetClipsChildren(true)
		t, ci.View = CreateFrame("Frame"), t
		t:Hide()
		t:SetScript("OnShow", container_onCanvasShow)
		t.OnCommit, t.OnDefault, t.OnRefresh, t.OnCancel = cf.OnCommit, cf.OnDefault, cf.OnRefresh, cf.OnCancel
		containers[t], ci.canvas = ci, t
		if type(opts) == "table" then
			ci.forceRootVersion = opts.forceRootVersion
		end
		
		containers[rootPanel], containers[name], containers[cf] = ci, ci, ci
		return ci
	end
	local function container_selectRootPanel(self)
		local ci = containers[self]
		if ci and #ci.tabs > 1 then
			container_setTenant(ci, ci.root)
		end
	end
	local function container_isContainerWithConfusableReset(f)
		local ci = containers[f]
		if ci and ci.f == f and ci.currentPanel.default then
			local dc = 0
			for i=1,#ci.tabs do
				if ci.tabs[ci.tabs[i]].default ~= nil then
					dc = dc + 1
					if dc == 2 then
						return true
					end
				end
			end
		end
		return false
	end
	container_notifications_internal.okay = container_selectRootPanel
	container_notifications_internal.cancel = container_selectRootPanel
	
	local currentSettingsTenant
	local function settings_show(newTenant)
		if currentSettingsTenant then
			currentSettingsTenant:Hide()
			currentSettingsTenant:ClearAllPoints()
			currentSettingsTenant = nil
		end
		newTenant:ClearAllPoints()
		newTenant:SetParent(TenSettingsFrame)
		newTenant:SetPoint("TOP", WINDOW_LEFT_GAP/2, -WINDOW_PADDING_TOP)
		currentSettingsTenant = newTenant
		securecall(newTenant.OnRefresh, newTenant)
		newTenant:Show()
		if not TenSettingsFrame:IsShown() then
			TenSettingsFrame:ClearAllPoints()
			TenSettingsFrame:SetPoint("CENTER", 0, 50)
		end
		TenSettingsFrame:Show()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
	end

	TenSettingsFrame.Save:SetScript("OnClick", function()
		if currentSettingsTenant then
			securecall(currentSettingsTenant.OnCommit, currentSettingsTenant)
		end
		TenSettingsFrame.ClosePanelButton:Click()
	end)
	TenSettingsFrame.Reset:SetScript("OnClick", function()
		if currentSettingsTenant then
			if container_isContainerWithConfusableReset(currentSettingsTenant) then
				-- TODO: Really should ask
				securecall(currentSettingsTenant.OnDefault, currentSettingsTenant, "current-panel-only")
			elseif currentSettingsTenant.OnDefault then
				securecall(currentSettingsTenant.OnDefault, currentSettingsTenant)
			else
				return
			end
			PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
		end
	end)
	TenSettingsFrame.Cancel:SetScript("OnClick", function()
		if currentSettingsTenant and currentSettingsTenant.OnCancel then
			securecall(currentSettingsTenant.OnCancel, currentSettingsTenant)
		end
		TenSettingsFrame.ClosePanelButton:Click()
	end)

	local function openSettingsPanel(panel)
		local ci = containers[panel]
		if SettingsPanel:IsVisible() then
			container_setTenant(ci, panel)
			Settings.OpenToCategory(ci.name)
		else
			container_setTenant(ci, panel)
			settings_show(ci.f)
		end
	end
	function I.AddOptionsCategory(panel, opts)
		local name, parent = panel.name, panel.parent
		local ci = containers[parent]
		assert(parent == nil or ci)
		if parent == nil then
			ci = container_new(name, panel, opts)
			panel:SetParent(ci.f)
			local cat = Settings.RegisterCanvasLayoutCategory(ci.canvas, name)
			cat.ID = name
			Settings.RegisterAddOnCategory(cat)
		else
			containers[panel] = ci
			panel:SetParent(ci.f)
			if #ci.tabs == 0 then
				container_addTab(ci.tabs, ci.f, ci.root, OPTIONS)
			end
			container_addTab(ci.tabs, ci.f, panel)
		end
		panel.OpenPanel = openSettingsPanel
	end
	function I.GetBottomOverlayOffset(f)
		local p2 = f and f:GetParent()
		p2 = p2 and p2:GetParent()
		local ci = containers[f]
		return ci and ci.f == p2 and -3.5 or 2
	end
end
if not TEN then
	local function openInterfaceOptionsFrameCategory(panel)
		InterfaceOptionsFrame_OpenToCategory(panel)
		if not panel:IsVisible() then
			-- Fails on first run as adding a category doesn't trigger a list update, but OTC does.
			InterfaceOptionsFrame_OpenToCategory(panel)
		end
	
		-- If the panel is offscreen in the AddOns list, both OTC calls above will fail;
		-- in any case, we want all the children/sibling categories to be visible.
		local cat, parent = INTERFACEOPTIONS_ADDONCATEGORIES, panel.parent or panel.name
		local numVisiblePredecessors, parentPanel, lastRelatedPanel = 0
		for i=1,#cat do
			local e = cat[i]
			if e.name == parent then
				parentPanel, lastRelatedPanel = e, numVisiblePredecessors+1
			elseif parentPanel then
				if e.parent ~= parent then
					break
				end
				lastRelatedPanel = lastRelatedPanel + 1
			elseif not e.hidden then
				numVisiblePredecessors = numVisiblePredecessors + 1
			end
		end
		if lastRelatedPanel then
			local buttons, ofsY = InterfaceOptionsFrameAddOns.buttons
			if lastRelatedPanel - InterfaceOptionsFrameAddOnsList.offset > #buttons then
				ofsY = (lastRelatedPanel - #buttons)*buttons[1]:GetHeight()
				-- If the parent is collapsed, we might only be able to get it to show here
				local _, maxY = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
				InterfaceOptionsFrameAddOnsListScrollBar:SetValue(math.min(ofsY, maxY))
			end
			-- If the parent is collapsed, expand it
			for i=1,parentPanel and parentPanel.collapsed and #buttons or 0 do
				if buttons[i].element == parentPanel then
					InterfaceOptionsListButton_ToggleSubCategories(buttons[i])
					break
				end
			end
			if ofsY then
				-- Set the proper scroll value, and force selection highlight to be updated
				InterfaceOptionsFrameAddOnsListScrollBar:SetValue(ofsY)
				InterfaceOptionsFrame_OpenToCategory(panel)
			end
		end
	
		if not panel:IsVisible() then
			-- I give up.
			InterfaceOptionsList_DisplayPanel(panel)
		end
	end
	function I.AddOptionsCategory(panel)
		InterfaceOptions_AddCategory(panel)
		panel.OpenPanel = openInterfaceOptionsFrameCategory
	end
end

function M:CreateLineInputBox(parent, common, width)
	local input = CreateFrame("EditBox", nil, parent)
	input:SetAutoFocus(nil) input:SetSize(width or 150, 20)
	input:SetFontObject(ChatFontNormal)
	input:SetScript("OnEscapePressed", input.ClearFocus)
	local l, m, r = input:CreateTexture(nil, "BACKGROUND"), input:CreateTexture(nil, "BACKGROUND"), input:CreateTexture(nil, "BACKGROUND")
	l:SetSize(common and 8 or 32, common and 20 or 32) l:SetPoint("LEFT", common and -5 or -10, 0)
	l:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Left2")
	r:SetSize(common and 8 or 32, common and 20 or 32) r:SetPoint("RIGHT", common and 0 or 10, 0)
	r:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Right2")
	m:SetHeight(common and 20 or 32) m:SetPoint("LEFT", l, "RIGHT") m:SetPoint("RIGHT", r, "LEFT")
	m:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Mid2")
	if common then
		l:SetTexCoord(0,1/16, 0,5/8)
		r:SetTexCoord(15/16,1, 0,5/8)
		m:SetTexCoord(1/16,15/16, 0,5/8)
	else
		m:SetHorizTile(true)
	end
	return input
end

do -- M:ShowFrameOverlay(self, overlayFrame)
	local container, watcher, occupant = CreateFrame("Frame"), CreateFrame("Frame") do
		container:EnableMouse(1) container:EnableKeyboard(1) container:Hide()
		container:SetPropagateKeyboardInput(true)
		container:SetScript("OnKeyDown", function(self, key)
			if key == "ESCAPE" then self:Hide() end
			self:SetPropagateKeyboardInput(key ~= "ESCAPE")
		end)
		container:SetScript("OnMouseWheel", function() end)
		container.fader = container:CreateTexture(nil, "BACKGROUND")
		container.fader:SetColorTexture(0,0,0, 0.40)
		local corner = container:CreateTexture(nil, "ARTWORK")
		corner:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Corner")
		corner:SetSize(30,30) corner:SetPoint("TOPRIGHT", -5, -6)
		local close = CreateFrame("Button", nil, container, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", TEN and -5 or 0, TEN and -5 or -1)
		close:SetScript("OnClick", function() container:Hide() end)
		CreateEdge(container, {edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize=32, bgFile="Interface\\FrameGeneral\\UI-Background-Rock", tile=true, tileSize=256, insets={left=10,right=10,top=10,bottom=10}}, 0x4c667f)
		watcher:SetScript("OnHide", function()
			if occupant then
				container:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
				occupant:Hide()
				occupant=nil
			end
		end)
	end
	function M:ShowFrameOverlay(self, overlayFrame)
		if occupant and occupant ~= overlayFrame then occupant:Hide() end
		local cw, ch = overlayFrame:GetSize()
		local w2, h2 = self:GetSize()
		local w, h, isRefresh = cw + 24, ch + 24, occupant == overlayFrame
		w2, h2, occupant = w2 > w and (w-w2)/2 or 0, h2 > h and (h-h2)/2 or 0
		container:SetSize(w, h)
		container:SetHitRectInsets(w2, w2, h2, h2)
		container:SetParent(self)
		container:SetPoint("CENTER")
		container:SetFrameLevel(self:GetFrameLevel()+20)
		container.fader:ClearAllPoints()
		container.fader:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
		container.fader:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, TEN and I.GetBottomOverlayOffset(self) or 2)
		container:Show()
		overlayFrame:ClearAllPoints()
		overlayFrame:SetParent(container)
		overlayFrame:SetPoint("CENTER")
		overlayFrame:Show()
		watcher:SetParent(overlayFrame)
		watcher:Show()
		CloseDropDownMenus()
		if not isRefresh then PlaySound(SOUNDKIT.IG_MAINMENU_OPEN) end
		occupant = overlayFrame
	end
end
do -- M:ShowPromptOverlay(...)
	local promptFrame, promptInfo = CreateFrame("Frame"), {} do
		promptFrame:SetSize(400, 130)
		promptInfo.title = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		promptInfo.prompt = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		promptInfo.editBox = M:CreateLineInputBox(promptFrame, false, 300)
		promptInfo.accept = CreateFrame("Button", nil, promptFrame, "UIPanelButtonTemplate")
		promptInfo.cancel = CreateFrame("Button", nil, promptFrame, "UIPanelButtonTemplate")
		promptInfo.detail = promptFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		promptInfo.title:SetPoint("TOP", 0, -3)
		promptInfo.prompt:SetPoint("TOP", promptInfo.title, "BOTTOM", 0, -8)
		promptInfo.editBox:SetPoint("TOP", promptInfo.prompt, "BOTTOM", 0, -7)
		promptInfo.detail:SetPoint("TOP", promptInfo.editBox, "BOTTOM", 0, -8)
		promptInfo.prompt:SetWidth(380)
		promptInfo.detail:SetWidth(380)
				
		promptInfo.cancel:SetScript("OnClick", function() promptFrame:Hide() end)
		promptInfo.editBox:SetScript("OnTextChanged", function(self)
			promptInfo.accept:SetEnabled(promptInfo.callback == nil or promptInfo.callback(self, self:GetText() or "", false, promptFrame:GetParent():GetParent()))
		end)
		promptInfo.accept:SetScript("OnClick", function()
			local callback, text = promptInfo.callback, promptInfo.editBox:GetText() or ""
			if callback == nil or callback(promptInfo.editBox, text, true, promptFrame:GetParent():GetParent()) then
				promptFrame:Hide()
			end
		end)
		promptInfo.editBox:SetScript("OnEnterPressed", function() promptInfo.accept:Click() end)
		promptInfo.editBox:SetScript("OnEscapePressed", function() promptInfo.cancel:Click() end)
	end
	function M:ShowPromptOverlay(frame, title, prompt, explainText, acceptText, callback, editBoxWidth, cancelText)
		promptInfo.callback = callback
		promptInfo.title:SetText(title or "")
		promptInfo.prompt:SetText(prompt or "")
		promptInfo.detail:SetText(explainText or "")
		promptInfo.editBox:SetText("")
		promptFrame:SetHeight(55 + math.max(20, promptInfo.prompt:GetStringHeight()) + (editBoxWidth ~= false and 30 or 0) + ((explainText or "") ~= "" and 20 or 0))
		M:ShowFrameOverlay(frame, promptFrame)
		if editBoxWidth ~= false then
			promptInfo.editBox:Show()
			promptInfo.editBox:SetWidth((editBoxWidth or 0.50) * 380)
			promptInfo.editBox:SetFocus()
		else
			promptInfo.editBox:Hide()
		end
		promptInfo.cancel:ClearAllPoints()
		promptInfo.accept:ClearAllPoints()
		if acceptText ~= false then
			promptInfo.accept:SetText(acceptText or ACCEPT)
			promptInfo.cancel:SetText(cancelText or CANCEL)
			promptInfo.cancel:SetPoint("BOTTOMLEFT", promptFrame, "BOTTOM", 5, 2)
			promptInfo.accept:SetPoint("BOTTOMRIGHT", promptFrame, "BOTTOM", -5, 2)
			promptInfo.accept:Show()
		else
			promptInfo.accept:Hide()
			promptInfo.cancel:SetText(cancelText or OKAY)
			promptInfo.cancel:SetPoint("BOTTOM", 5, 0)
		end
		promptInfo.cancel:SetWidth(math.max(125, 15+promptInfo.cancel:GetFontString():GetStringWidth()))
		promptInfo.accept:SetWidth(math.max(125, 15+promptInfo.accept:GetFontString():GetStringWidth()))
		return promptFrame
	end
end
function M:ShowAlertOverlay(frame, title, message, dissmissText)
	return M:ShowPromptOverlay(frame, title, message, nil, false, nil, false, dissmissText)
end
function M:CreateOptionsPanel(name, parent, opts)
	local f, t, a = CreateFrame("Frame")
	f:Hide()
	f.name, f.parent = name, parent
	a = CreateFrame("Frame", nil, f)
	a:SetHeight(20)
	a:SetPoint("TOPLEFT")
	a:SetPoint("TOPRIGHT")
	t = a:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeLeftTop")
	t:SetPoint("TOPLEFT", 16, -16)
	t:SetText(name)
	t, f.title = a:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"), t
	t:SetPoint("TOPLEFT", f.title, "TOPRIGHT", 4, 3)
	t, f.version = a:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallLeftTop"), t
	t:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -8)
	t:SetWidth(590)
	f.desc = t
	f.TenSettings_TitleBlock = true
	I.AddOptionsCategory(f, opts)
	return f
end
do -- M:CreateOptionsCheckButton(name, parent)
	local function updateCheckButtonHitRect(self)
		local b = self:GetParent()
		b:SetHitRectInsets(0, -self:GetStringWidth()-5, 4, 4)
	end
	function M:CreateOptionsCheckButton(name, parent)
		local b = CreateFrame("CheckButton", name, parent, TEN and "UICheckButtonTemplate" or "InterfaceOptionsCheckButtonTemplate")
		if TEN then
			b:SetSize(24, 24)
			b.Text:SetPoint("LEFT", b, "RIGHT", 2, 1)
			b.Text:SetFontObject(GameFontHighlightLeft)
		end
		hooksecurefunc(b.Text, "SetText", updateCheckButtonHitRect)
		return b
	end
end