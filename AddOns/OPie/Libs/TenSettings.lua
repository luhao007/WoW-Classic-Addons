local M, I, COMPAT, _, T = {}, {}, select(4, GetBuildInfo()), ...
local EV, XU, noop = T.Evie, T.exUI, function() end
local MODERN = COMPAT > 10e4
T.TenSettings = M

do -- EscapeCallback
	local getInfo, setInfo do
		local info = {}
		function getInfo(k)
			return info[k]
		end
		function setInfo(k, v)
			info[k] = v
		end
	end
	local function ESC_OnKeyDown(self, key)
		local it = getInfo(self)
		if key and (key == "ESCAPE" or key == it[3]) and GetCurrentKeyBoardFocus() == nil then
			it[2](it[1], key)
		else
			local a, b = it[4], it[5]
			a:SetScript("OnKeyDown", nil)
			b:SetScript("OnKeyDown", noop)
			it[4], it[5] = b, a
		end
	end
	function M:EscapeCallback(parent, key2, callback)
		if callback == nil then
			callback, key2 = key2, nil
		end
		local f0 = CreateFrame("Frame", nil, parent)
		local f1 = CreateFrame("Frame", nil, parent)
		local f2 = CreateFrame("Frame", nil, parent)
		setInfo(f0, {parent, callback, key2, f1, f2})
		f0:SetPropagateKeyboardInput(true)
		f0:SetScript("OnKeyDown", ESC_OnKeyDown)
		f1:SetScript("OnKeyDown", noop)
	end
end
do -- TenSettingsFrame
	local WINDOW_PADDING_H, WINDOW_PADDING_TOP, WINDOW_ACTIONS_HEIGHT, WINDOW_PADDING_BOTTOM = 10, 30, 30, 15
	local IW_PADDING_TOP, IW_PADDING_RIGHT, IW_PADDING_BOTTOM, IW_PADDING_LEFT = 24, 4, 5, 8
	local CONTAINER_TABS_YOFFSET, CONTAINER_CONTENT_TOP_YOFFSET, CONTAINER_TITLE_YOFFSET = 11, -26, -4
	local CONTAINER_PADDING_H, CONTAINER_PADDING_V = 10, 6
	local PANEL_VIEW_MARGIN_TOP, PANEL_VIEW_MARGIN_TOP_TITLESHIFT = -14, -35
	local PANEL_VIEW_MARGIN_LEFT, PANEL_VIEW_MARGIN_RIGHT = -15, -10
	
	local PANEL_WIDTH, PANEL_HEIGHT = 585, 528
	local CONTAINER_WIDTH = PANEL_WIDTH + CONTAINER_PADDING_H * 2
	local CONTAINER_HEIGHT = PANEL_HEIGHT - CONTAINER_CONTENT_TOP_YOFFSET + CONTAINER_PADDING_V*2
	local WINDOW_WIDTH = CONTAINER_WIDTH + WINDOW_PADDING_H * 2
	local WINDOW_HEIGHT = CONTAINER_HEIGHT + WINDOW_PADDING_TOP + WINDOW_ACTIONS_HEIGHT + WINDOW_PADDING_BOTTOM

	local TenSettingsFrame, notifyTenant = CreateFrame("Frame", "TenSettingsFrame", UIParent, "SettingsFrameTemplate") do
		TenSettingsFrame:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT)
		TenSettingsFrame:SetPoint("CENTER", 0, 50)
		TenSettingsFrame.NineSlice.Text:SetText(OPTIONS)
		TenSettingsFrame:SetFrameStrata("HIGH")
		TenSettingsFrame:SetToplevel(true)
		TenSettingsFrame:Hide()
		TenSettingsFrame:SetMouseClickEnabled(true)
		TenSettingsFrame:SetMouseMotionEnabled(true)
		TenSettingsFrame:SetClampedToScreen(true)
		TenSettingsFrame:SetClampRectInsets(5,0,0,0)
		local f = CreateFrame("Frame", nil, TenSettingsFrame)
		f:SetPoint("TOPLEFT", IW_PADDING_LEFT, -IW_PADDING_TOP)
		f:SetPoint("BOTTOMRIGHT", -IW_PADDING_RIGHT, IW_PADDING_BOTTOM)
		f.OverlayFaderMargin = 0
		TenSettingsFrame.WindowArea = f
		f = CreateFrame("Frame", nil, f)
		f:SetPoint("TOPLEFT", 0, IW_PADDING_TOP-WINDOW_PADDING_TOP)
		f:SetPoint("BOTTOMRIGHT", 0, WINDOW_ACTIONS_HEIGHT+WINDOW_PADDING_BOTTOM-IW_PADDING_BOTTOM)
		TenSettingsFrame.ContentArea = f
		local cancel = CreateFrame("Button", nil, TenSettingsFrame.WindowArea, "UIPanelButtonTemplate")
		cancel:SetSize(110, 24)
		cancel:SetPoint("BOTTOMRIGHT", IW_PADDING_RIGHT-WINDOW_PADDING_H, WINDOW_PADDING_BOTTOM-IW_PADDING_BOTTOM)
		cancel:SetText(CANCEL)
		TenSettingsFrame.Cancel = cancel
		local save = CreateFrame("Button", nil, TenSettingsFrame.WindowArea, "UIPanelButtonTemplate")
		save:SetSize(110, 24)
		save:SetPoint("RIGHT", cancel, "LEFT", -4, 0)
		save:SetText(OKAY)
		TenSettingsFrame.Save = save
		local defaults = CreateFrame("Button", nil, TenSettingsFrame.WindowArea, "UIPanelButtonTemplate")
		defaults:SetSize(110, 24)
		defaults:SetPoint("BOTTOMLEFT", WINDOW_PADDING_H - IW_PADDING_LEFT, WINDOW_PADDING_BOTTOM-IW_PADDING_BOTTOM)
		defaults:SetText(DEFAULTS)
		TenSettingsFrame.Reset = defaults
		local revert = CreateFrame("Button", nil, TenSettingsFrame.WindowArea, "UIPanelButtonTemplate") do
			revert:SetSize(110, 24)
			revert:SetPoint("LEFT", defaults, "RIGHT", 4, 0)
			revert:SetText(REVERT)
			local drop = CreateFrame("Frame", nil, revert, "UIDropDownMenuTemplate")
			UIDropDownMenu_SetAnchor(drop, 0, 2, "BOTTOM", revert, "TOP")
			UIDropDownMenu_SetDisplayMode(drop, "MENU")
			revert:SetScript("OnClick", function()
				ToggleDropDownMenu(1, nil, drop)
				PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			end)
			function revert:HandlesGlobalMouseEvent(button, _ev)
				return button == "LeftButton"
			end
			local function performRevert(_, idx)
				if idx == -1 then
					I.undo:UnwindStack()
				else
					I.undo:UnwindArchives(idx)
				end
				notifyTenant("OnRefresh")
			end
			local function formatTime(td)
				if GetCVarBool("timeMgrUseMilitaryTime") then
					return date("%H:%M:%S", time()-td)
				end
				return (date("%I:%M:%S %p", time()-td):gsub("^0(%d)", "%1"))
			end
			function drop:initialize()
				local info, text = {func=performRevert, notCheckable=1, justifyH="CENTER"}, revert.optionText or "%2$s"
				local now, numEntries, numArchives, firstTime = GetServerTime(), I.undo:GetState()
				for i=1, numArchives + (numEntries > 0 and 1 or 0) do
					local isCancel = i > numArchives
					local td = now - (isCancel and firstTime or I.undo:GetArchiveInfo(i))
					local cc = isCancel and "|cffffb000" or ""
					info.text, info.arg1 = cc .. text:format(math.floor(td/60+0.5), formatTime(td)), isCancel and -1 or i
					UIDropDownMenu_AddButton(info)
				end
			end
			TenSettingsFrame.Revert, revert.drop = revert, drop
		end
		M:EscapeCallback(TenSettingsFrame, function(self)
			self.ClosePanelButton:Click()
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
	local ConfusableResetDialog, crd_show, CRD_QUESTION_TEXT = CreateFrame("Frame", nil) do
		local d, t, tenant = ConfusableResetDialog
		d:Hide()
		d:SetSize(460, 105)
		local function onResetButtonClick(self)
			local id = self:GetID()
			if id ~= 0 then
				notifyTenant("OnDefault", tenant, select(id, "current-panel-only"))
			end
			ConfusableResetDialog:Hide()
		end
		t = d:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		t:SetPoint("TOP", -15, -8)
		t:SetWidth(410)
		t, d.Question = d:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"), t
		t:SetPoint("BOTTOM", -15, 38)
		t:SetWidth(410)
		t, d.Hint = CreateFrame("Button", nil, d, "UIPanelButtonTemplate", 2), t
		t:SetSize(150, 24)
		t:SetPoint("BOTTOM", -150, 6)
		t:SetText(ALL_SETTINGS)
		t:SetScript("OnClick", onResetButtonClick)
		t, d.AllSet = CreateFrame("Button", nil, d, "UIPanelButtonTemplate", 0), t
		t:SetSize(130, 24)
		t:SetPoint("BOTTOM", 0, 6)
		t:SetText(CANCEL)
		t:SetScript("OnClick", onResetButtonClick)
		t, d.Cancel = CreateFrame("Button", nil, d, "UIPanelButtonTemplate", 1), t
		t:SetSize(150, 24)
		t:SetPoint("BOTTOM", 150, 6)
		t:SetText(CURRENT_SETTINGS)
		t:SetScript("OnClick", onResetButtonClick)
		d.OnlyThese = t
		d:SetScript("OnHide", function(self)
			self:Hide()
			tenant = nil
		end)
		function crd_show(forTenant, thisName, rootName)
			local qt, cc = CRD_QUESTION_TEXT or CONFIRM_RESET_INTERFACE_SETTINGS, NORMAL_FONT_COLOR_CODE
			ConfusableResetDialog.Question:SetFormattedText(qt, cc .. tostring(rootName) .. "|r", cc .. tostring(thisName) .. "|r")
			tenant = forTenant
			M:ShowFrameOverlay(TenSettingsFrame.WindowArea, ConfusableResetDialog)
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
			I.HandlePanelNotification(notification)
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
		if ci.currentPanel then
			ci.currentPanel:Hide()
			minitab_deselect(ci.tabs[ci.currentPanel])
		end
		ci.currentPanel = newPanel
		minitab_select(ci.tabs[newPanel])
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
			cf:SetScript("OnMouseWheel", noop)
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
	local function container_isResetConfusable(f)
		local ci = containers[f]
		if ci and ci.f == f and ci.currentPanel.default then
			local dc = 0
			for i=1,#ci.tabs do
				if ci.tabs[ci.tabs[i]].default ~= nil then
					dc = dc + 1
					if dc == 2 then
						local ct = ci.tabs[ci.currentPanel]
						return true, ct and ct:GetText() or ci.currentPanel.name, ci.name
					end
				end
			end
		end
		return false
	end
	container_notifications_internal.okay = container_selectRootPanel
	container_notifications_internal.cancel = container_selectRootPanel
	
	local currentSettingsTenant
	function notifyTenant(notification, filter, ...)
		local nf = currentSettingsTenant and currentSettingsTenant[notification]
		if nf and (filter == nil or currentSettingsTenant == filter) then
			securecall(nf, currentSettingsTenant, ...)
		end
	end
	local function settings_show(newTenant)
		if currentSettingsTenant then
			currentSettingsTenant:Hide()
			currentSettingsTenant:ClearAllPoints()
			currentSettingsTenant = nil
		end
		newTenant:ClearAllPoints()
		newTenant:SetParent(TenSettingsFrame.ContentArea)
		newTenant:SetPoint("TOP")
		currentSettingsTenant = newTenant
		securecall(newTenant.OnRefresh, newTenant)
		newTenant:Show()
		if not TenSettingsFrame:IsShown() then
			TenSettingsFrame:ClearAllPoints()
			TenSettingsFrame:SetPoint("CENTER", 0, 50)
		end
		I.OnUndoStateChange()
		TenSettingsFrame:Show()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
	end
	local function settings_hide(dismissCommit, skipSound)
		if dismissCommit and currentSettingsTenant and currentSettingsTenant.OnCommit then
			securecall(currentSettingsTenant.OnCommit, currentSettingsTenant, "commit-on-dismiss")
		end
		TenSettingsFrame:Hide()
		if currentSettingsTenant then
			currentSettingsTenant:Hide()
			currentSettingsTenant:ClearAllPoints()
			currentSettingsTenant = nil
		end
		I.undo:ArchiveStack()
		if not skipSound then
			PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
		end
	end

	do -- Detect settings dismissal, archive undo stack
		local cueWatcher do
			local waitLeft, watcher = 0, CreateFrame("Frame")
			watcher:Hide()
			watcher:SetScript("OnUpdate", function(_, elapsed)
				if elapsed and elapsed < waitLeft then
					waitLeft = waitLeft - elapsed
					return
				end
				waitLeft = 0.2
				if TenSettingsFrame:IsVisible() or SettingsPanel:IsVisible() or I.undo:GetState() == 0 then
					watcher:Hide()
				elseif not (TenSettingsFrame:IsShown() or SettingsPanel:IsShown()) then
					if currentSettingsTenant then
						settings_hide(true, true)
					end
					I.undo:ArchiveStack()
					watcher:Hide()
				end
			end)
			function cueWatcher()
				waitLeft = 0
				watcher:Show()
			end
		end
		for i=1,2 do
			local f = CreateFrame("Frame", nil, i == 1 and SettingsPanel or TenSettingsFrame)
			f:SetScript("OnHide", cueWatcher)
		end
	end

	TenSettingsFrame.ClosePanelButton:SetScript("OnClick", function()
		settings_hide(true)
	end)
	TenSettingsFrame.Save:SetScript("OnClick", function()
		if currentSettingsTenant then
			securecall(currentSettingsTenant.OnCommit, currentSettingsTenant)
		end
		settings_hide()
	end)
	TenSettingsFrame.Reset:SetScript("OnClick", function()
		if currentSettingsTenant and currentSettingsTenant.OnDefault then
			local isConfusable, currentName, rootName = container_isResetConfusable(currentSettingsTenant)
			if isConfusable then
				crd_show(currentSettingsTenant, currentName, rootName)
			else
				securecall(currentSettingsTenant.OnDefault, currentSettingsTenant)
			end
			PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
		end
	end)
	TenSettingsFrame.Cancel:SetScript("OnClick", function()
		if currentSettingsTenant and currentSettingsTenant.OnCancel then
			securecall(currentSettingsTenant.OnCancel, currentSettingsTenant)
		end
		settings_hide()
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
	function I.GetOverlayDefaults(f)
		local p2 = f and f:GetParent()
		p2 = p2 and p2:GetParent()
		local ci = containers[f]
		if ci and ci.f == p2 then
			return p2, f.OverlayFaderMargin or 3.5, 28
		end
		return nil, f.OverlayFaderMargin
	end
	function I.OnUndoStateChange()
		local nEntries, nArchives = I.undo:GetState()
		TenSettingsFrame.Revert:SetEnabled(nEntries > 0 or nArchives > 0)
	end
	function M:Localize(t)
		CRD_QUESTION_TEXT = t.RESET_QUESTION
		ConfusableResetDialog.AllSet:SetText(t.DEFAULTS_ALL or ALL_SETTINGS)
		ConfusableResetDialog.OnlyThese:SetText(t.DEFAULTS_VISIBLE or CURRENT_SETTINGS)
		TenSettingsFrame.Revert:SetText(t.REVERT or REVERT)
		TenSettingsFrame.Revert.optionText = t.REVERT_OPTION_LABEL
		ConfusableResetDialog.Hint:SetText(t.REVERT_CANCEL_HINT or "")
	end
end

do -- M:CreateUndoHandle()
	local undoStack, archives, undo, uhandle, pendingNotify = {}, {}, {}, {}, false
	local MAX_ARCHIVES = 10
	I.undo = undo
	local function storeUndoEntry(idx, ns, key, func, ...)
		local bot, now = undoStack.bottom, GetServerTime()
		undoStack[idx] = {ns=ns, key=key, func=func, n=select("#", ...), ...}
		undoStack.bottom = (bot == nil or bot > idx) and idx or bot
		undoStack.firstTime, undoStack.lastTime = undoStack.firstTime or now, now
	end
	local function unwind(us, msg)
		undoStack = us == undoStack and {} or undoStack
		for i=#us, us.bottom or 1, -1 do
			i = us[i]
			securecall(i.func, msg, unpack(i, 1, i.n))
		end
	end
	local function archive(data)
		for i=1, #archives == MAX_ARCHIVES and MAX_ARCHIVES or 0 do
			archives[i] = archives[i+1]
		end
		data.archiveTime = data.archiveTime or GetServerTime()
		undoStack = undoStack == data and {} or undoStack
		archives[#archives+1] = data
	end
	local function rearchive(_msg, aa)
		for i=#aa, 1, -1 do
			archive(aa[i])
		end
	end
	local function notifyStateChanged()
		pendingNotify = false
		I.OnUndoStateChange()
	end
	function undo:UnwindStack()
		unwind(undoStack, "unwind")
		undo:NotifyStateChanged()
	end
	function undo:UnwindArchives(idx)
		if undoStack.bottom then
			unwind(undoStack, "unwind")
		end
		local uw, ai = {}
		for i=#archives, idx, -1 do
			ai, uw[#uw+1], archives[i] = archives[i], archives[i], nil
			unwind(ai, "archive-unwind")
		end
		if #uw > 0 and undoStack.bottom then
			storeUndoEntry(#undoStack+1, nil, nil, rearchive, uw)
		end
		undo:NotifyStateChanged()
	end
	function undo:GetState()
		local bot = undoStack.bottom
		return #undoStack + (bot and 1-bot or 0), #archives, undoStack.firstTime
	end
	function undo:ArchiveStack()
		if #undoStack > 0 or undoStack.bottom then
			archive(undoStack)
			undo:NotifyStateChanged()
		end
	end
	function undo:GetArchiveInfo(idx)
		local ai = archives[idx]
		if ai then
			return ai.firstTime, ai.lastTime, ai.archiveTime
		end
	end
	function undo:ClearStack()
		if undoStack.bottom then
			undoStack = {}
			undo:NotifyStateChanged()
		end
	end
	function undo:NotifyStateChanged()
		if not pendingNotify and I.OnUndoStateChange then
			pendingNotify = true
			EV.After(0, notifyStateChanged)
		end
	end
	function uhandle:search(key)
		for i=#undoStack, undoStack.bottom or 1,-1 do
			local e = undoStack[i]
			if e.ns == self and e.key == key then
				return true
			end
		end
	end
	function uhandle:push(...)
		storeUndoEntry(#undoStack + 1, self, ...)
		undo:NotifyStateChanged()
	end
	function uhandle:sink(...)
		storeUndoEntry((undoStack.bottom or 2) - 1, self, ...)
		undo:NotifyStateChanged()
	end
	local uhmeta = {__index=uhandle, __metatable=false}
	function M:CreateUndoHandle()
		return setmetatable({}, uhmeta)
	end
end
function I.HandlePanelNotification(notification)
	if notification == "okay" then
		I.undo:ArchiveStack()
	elseif notification == "cancel" then
		I.undo:UnwindStack()
	end
end

do -- M:ShowFrameOverlay(self, overlayFrame)
	local container, watcher, occupant = CreateFrame("Frame"), CreateFrame("Frame") do
		container:EnableMouse(true) container:Hide()
		M:EscapeCallback(container, function(self)
			self:Hide()
		end)
		container:SetScript("OnMouseWheel", function() end)
		container.fader = container:CreateTexture(nil, "BACKGROUND", nil, -6)
		container.fader:SetColorTexture(0,0,0, 0.40)
		local corner = container:CreateTexture(nil, "ARTWORK")
		corner:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Corner")
		corner:SetSize(30,30) corner:SetPoint("TOPRIGHT", -5, -6)
		local close = CreateFrame("Button", nil, container, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", MODERN and -5 or 0, MODERN and -5 or 0)
		close:SetScript("OnClick", function() container:Hide() end)
		XU:Create("Backdrop", container, {edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize=32, bgFile="Interface\\FrameGeneral\\UI-Background-Rock", tile=true, tileSize=256, insets={left=10,right=10,top=10,bottom=10}, bgColor=0x4c667f, subLevel=-5})
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
		local frameLevel = (math.ceil(self:GetFrameLevel()/500)+1)*500
		w2, h2, occupant = w2 > w and (w-w2)/2 or 0, h2 > h and (h-h2)/2 or 0
		container:SetSize(w, h)
		container:SetHitRectInsets(w2, w2, h2, h2)
		container:SetParent(self)
		container:SetPoint("CENTER")
		container:SetFrameLevel(frameLevel)
		container.fader:ClearAllPoints()
		local oaf, omd, omt, omr, omb, oml = I.GetOverlayDefaults(self)
		oaf, omd = oaf or self, type(omd) == "number" and omd or 2
		container.fader:SetPoint("TOPLEFT", oaf, "TOPLEFT", (oml or omd), -(omt or omd))
		container.fader:SetPoint("BOTTOMRIGHT", oaf, "BOTTOMRIGHT", -(omr or omd), omb or omd)
		container:SetFrameStrata("DIALOG")
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
		promptInfo.editBox = XU:Create("LineInput", nil, promptFrame)
		promptInfo.editBox:SetStyle("chat")
		promptInfo.editBox:SetWidth(300)
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
			promptInfo.accept:SetEnabled(promptInfo.callback == nil or promptInfo.callback(self, self:GetText() or "", false, promptInfo.owner))
		end)
		promptInfo.accept:SetScript("OnClick", function()
			local callback, text = promptInfo.callback, promptInfo.editBox:GetText() or ""
			if callback == nil or callback(promptInfo.editBox, text, true, promptInfo.owner) then
				promptFrame:Hide()
			end
		end)
		promptInfo.editBox:SetScript("OnEnterPressed", function() promptInfo.accept:Click() end)
		promptInfo.editBox:SetScript("OnEscapePressed", function() promptInfo.cancel:Click() end)
	end
	function M:ShowPromptOverlay(frame, title, prompt, explainText, acceptText, callback, editBoxWidth, cancelText, editText)
		local showEditBox = editBoxWidth ~= false
		editText = showEditBox and type(editText) == "string" and editText or ""
		promptInfo.owner, promptInfo.callback = frame, callback
		promptInfo.title:SetText(title or "")
		promptInfo.prompt:SetText(prompt or "")
		promptInfo.detail:SetText(explainText or "")
		promptInfo.editBox:SetText(editText)
		promptInfo.editBox:HighlightText(0, #editText)
		promptInfo.editBox:SetShown(editBoxWidth ~= false)
		promptInfo.editBox:SetWidth(math.max(40, (editBoxWidth or 0.50) * 380))
		promptFrame:SetHeight(55 + math.max(20, promptInfo.prompt:GetStringHeight()) + (editBoxWidth ~= false and 30 or 0) + ((explainText or "") ~= "" and 20 or 0))
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
			promptInfo.cancel:SetPoint("BOTTOM", 5, 2)
		end
		promptInfo.cancel:SetWidth(math.max(125, 25+promptInfo.cancel:GetFontString():GetStringWidth()))
		promptInfo.accept:SetWidth(math.max(125, 25+promptInfo.accept:GetFontString():GetStringWidth()))
		M:ShowFrameOverlay(frame, promptFrame)
		if showEditBox then
			promptInfo.editBox:SetFocus()
		end
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
	t, f.version = a:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall2"), t
	t:SetJustifyH("LEFT")
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
		local b = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
		b:SetSize(24, 24)
		b.Text:SetPoint("LEFT", b, "RIGHT", 2, 1)
		b.Text:SetFontObject(GameFontHighlightLeft)
		hooksecurefunc(b.Text, "SetText", updateCheckButtonHitRect)
		return b
	end
end