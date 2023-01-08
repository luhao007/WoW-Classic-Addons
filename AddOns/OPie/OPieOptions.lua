local config, COMPAT, _, T = {}, select(4,GetBuildInfo()), ...
local MODERN, CF_WRATH = COMPAT >= 10e4, COMPAT < 10e4 and COMPAT >= 3e4
local L, EV, frame = T.L, T.Evie, nil
T.config = config

do -- /opie
	local slashExtensions = {}
	local function addSuffix(func, word, ...)
		if word then
			slashExtensions[word:lower()] = func
			addSuffix(func, ...)
		end
	end
	addSuffix(function()
		print("|cff0080ffOPie|r |cffffffff" .. GetAddOnMetadata("OPie", "Version") .. "|r")
	end, "version")
	T.AddSlashSuffix = addSuffix

	SLASH_OPIE1, SLASH_OPIE2 = "/opie", "/op"
	SlashCmdList["OPIE"] = function(args, ...)
		local ext = slashExtensions[(args:match("%S+") or ""):lower()]
		if ext then
			ext(args, ...)
		else
			frame:OpenPanel()
		end
	end
end

local KR, PC = T.ActionBook:compatible("Kindred",1,0), T.OPieCore
local CreateEdge = T.CreateEdge

function config.createPanel(...)
	return T.TenSettings:CreateOptionsPanel(...)
end
do -- config.ui
	config.ui = {}
	do -- multilineInput
		local function onNavigate(self, _x,y, _w,h)
			local scroller = self.scroll
			local occH, occP, y = scroller:GetHeight(), scroller:GetVerticalScroll(), -y
			if occP > y then
				occP = y -- too far
			elseif (occP + occH) < (y+h) then
				occP = y+h-occH -- not far enough
			else
				return
			end
			scroller:SetVerticalScroll(occP)
			local _, mx = scroller.ScrollBar:GetMinMaxValues()
			scroller.ScrollBar:SetMinMaxValues(0, occP < mx and mx or occP)
			scroller.ScrollBar:SetValue(occP)
		end
		local function onClick(self)
			self.input:SetFocus()
		end
		function config.ui.multilineInput(name, parent, width)
			local scroller = CreateFrame("ScrollFrame", name .. "Scroll", parent, "UIPanelScrollFrameTemplate")
			local input = CreateFrame("Editbox", name, scroller)
			input:SetWidth(width)
			input:SetMultiLine(true)
			input:SetAutoFocus(false)
			input:SetTextInsets(2,4,2,2)
			input:SetFontObject(GameFontHighlight)
			input:SetScript("OnCursorChanged", onNavigate)
			scroller:EnableMouse(1)
			scroller:SetScript("OnMouseDown", onClick)
			scroller:SetScrollChild(input)
			input.scroll, scroller.input = scroller, input
			return input, scroller
		end
	end
	function config.ui.lineInput(parent, common, width)
		return T.TenSettings:CreateLineInputBox(parent, common, width)
	end
	function config.ui.HideTooltip(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end
	function config.ui.ShowControlTooltip(self)
		local title, text = self.tooltipTitle, self.tooltipText
		if not (title or text) then return end
		GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_BOTTOMRIGHT")
		GameTooltip:AddLine(title or "", nil, nil, nil)
		GameTooltip:AddLine(text or "", nil, nil, nil, true)
		GameTooltip:Show()
	end
	do -- scrollingDropdown
		local sdAPI, scrollingDropdown = {}, CreateFrame("Frame", nil, UIParent) do
			local MIN_SCROLL_ENTRIES, MAX_VISIBLE_ENTRIES = 20, 16
			local WHEEL_STEP, WHEEL_DURATION = 8, 0.25
			local BUTTON_STEP, BUTTON_DURATION = 15, 0.15
			local SNAP_DURATION = 0.10
			local MAX_TARGET_DISTANCE, MIN_ANIM_FPS = 48, 45
			local clipRoot = CreateFrame("Frame", nil, scrollingDropdown)
			local relFrame = CreateFrame("Frame", nil, clipRoot)
			local slider = CreateFrame("Slider", nil, scrollingDropdown, "UIPanelScrollBarTemplate")
			local buttons = {}
			local SetDataSource, ReleaseDataSource, Entry_OnClick do
				local positionArchive = setmetatable({}, {__mode="k"})
				local dataList, entryFormat, entrySelect, fullSync
				local aTarget, aOrigin, aLength, aLeft
				function Entry_OnClick(self)
					local entrySelect, arg1 = entrySelect, dataList[self:GetID()]
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
					CloseDropDownMenus()
					entrySelect(nil, arg1)
				end
				local function VLD_OnUpdate(self, elapsed)
					aLeft = aLeft - elapsed
					local isDone, position = aLeft <= 0, aTarget
					if isDone then
						positionArchive[dataList] = aTarget
						aTarget, aOrigin, aLength, aLeft = nil
						self:SetScript("OnUpdate", nil)
					else
						local p = 1-aLeft/aLength
						p = p*p*(3-2*p)
						position = aOrigin*(1-p) + aTarget*p
					end
					local oy, baseOffset = (position % 1)*16, math.floor(position)
					relFrame:SetPoint("TOPLEFT", 0, oy)
					relFrame:SetPoint("TOPRIGHT", 0, oy)
					for i=1,#buttons do
						local w, eid = buttons[i], i+baseOffset
						local ek = dataList[eid]
						w:SetShown(ek ~= nil)
						if ek ~= nil then
							if fullSync or w:GetID() ~= eid then
								local text, selected = entryFormat(ek, dataList)
								w:SetText(text)
								w:SetChecked(selected)
								w:SetID(eid)
								w:GetFontString():GetLeft() -- TODO: (8.1.5) Without this, it sometimes gets lost.
							end
							w:SetEnabled(isDone)
						end
					end
					slider:SetValue(position)
					fullSync = false
				end
				local function ProcessScrollDelta(delta, time)
					local cur, vmin, vmax = slider:GetValue(), slider:GetMinMaxValues()
					local goal, time = cur+delta, GetFramerate() >= MIN_ANIM_FPS and time or 0
					if aTarget and aOrigin and (aOrigin < aTarget) == (cur < goal) then
						goal = delta < 0 and math.max(aTarget+delta, cur-MAX_TARGET_DISTANCE) or math.min(aTarget+delta, cur+MAX_TARGET_DISTANCE)
					end
					goal = math.min(vmax, math.max(vmin, math.floor(goal)))
					if aTarget == goal or (not aTarget and cur == goal) then
						return
					end
					aLength, aLeft = time, time
					aOrigin, aTarget = cur, goal
					scrollingDropdown:SetScript("OnUpdate", VLD_OnUpdate)
					VLD_OnUpdate(scrollingDropdown, 0)
				end
				scrollingDropdown:SetScript("OnMouseWheel", function(_, delta)
					return ProcessScrollDelta(-delta*WHEEL_STEP, WHEEL_DURATION)
				end)
				local function SB_OnClick(self)
					return ProcessScrollDelta(self == slider.ScrollUpButton and -BUTTON_STEP or BUTTON_STEP, BUTTON_DURATION)
				end
				slider.ScrollUpButton:SetScript("OnClick", SB_OnClick)
				slider.ScrollDownButton:SetScript("OnClick", SB_OnClick)
				slider.ScrollUpButton:SetMotionScriptsWhileDisabled(true)
				slider.ScrollDownButton:SetMotionScriptsWhileDisabled(true)
				slider:HookScript("OnMouseUp", function(self)
					local cv = self:GetValue()
					if cv % 1 ~= 0 then
						aLeft = GetFramerate() < MIN_ANIM_FPS and 0 or SNAP_DURATION
						aLength, aOrigin, aTarget = aLeft, self:GetValue(), math.floor(cv+0.5)
						scrollingDropdown:SetScript("OnUpdate", VLD_OnUpdate)
					end
				end)
				slider:SetScript("OnValueChanged", function(_, value, userDrag)
					if userDrag then
						aLeft, aTarget = 0, value
						VLD_OnUpdate(scrollingDropdown, 0)
					end
					local vmin, vmax = slider:GetMinMaxValues()
					slider.ScrollUpButton:SetEnabled(value ~= vmin)
					slider.ScrollDownButton:SetEnabled(value ~= vmax)
				end)
				function SetDataSource(list, format, func, skipFirst)
					dataList, entryFormat, entrySelect, fullSync = list, format, func, true
					local maxV, arch = #dataList-MAX_VISIBLE_ENTRIES, positionArchive[list]
					slider:SetMinMaxValues(skipFirst, maxV)
					aTarget, aLeft = skipFirst, 0
					if arch and skipFirst <= arch and arch <= maxV then
						aTarget = arch
					end
					VLD_OnUpdate(scrollingDropdown, 0)
				end
				function ReleaseDataSource()
					dataList, entryFormat, entrySelect = nil
				end
				DropDownList1:HookScript("OnHide", function()
					for k in pairs(positionArchive) do
						positionArchive[k] = nil
					end
				end)
			end
			local function bindToCounter(frame)
				if MODERN then return end
				if frame ~= scrollingDropdown then
					frame.parent = scrollingDropdown
				end
				frame:SetScript("OnEnter", UIDropDownMenu_StopCounting)
				frame:SetScript("OnLeave", UIDropDownMenu_StartCounting)
			end

			clipRoot:SetAllPoints()
			clipRoot:SetClipsChildren(true)
			local bb = scrollingDropdown:CreateTexture(nil, "BACKGROUND")
			bb:SetColorTexture(0.3, 0.3, 0.3)
			bb:SetPoint("BOTTOMLEFT", -4, -2)
			bb:SetPoint("BOTTOMRIGHT", 0, -2)
			slider:SetPoint("TOPRIGHT", -1, -12)
			slider:SetPoint("BOTTOMRIGHT", -1, 15)
			bindToCounter(slider)
			bindToCounter(slider.ScrollUpButton)
			bindToCounter(slider.ScrollDownButton)
			bindToCounter(clipRoot)
			bindToCounter(scrollingDropdown)
			scrollingDropdown:SetHitRectInsets(-4, -24, -8, -8)
			local bg = slider:CreateTexture(nil, "BACKGROUND")
			bg:SetWidth(1)
			bg:SetColorTexture(0.25, 0.25, 0.25)
			bg:SetPoint("TOPLEFT", -2, 17)
			bg:SetPoint("BOTTOMLEFT", -2, -16)
			relFrame:SetPoint("TOPLEFT")
			relFrame:SetPoint("TOPRIGHT")
			relFrame:SetHeight(1)
			for i=1,MAX_VISIBLE_ENTRIES+1 do
				local b = CreateFrame("CheckButton", nil, clipRoot, nil, i)
				b:SetSize(100, 16)
				b:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
				b:GetHighlightTexture():SetBlendMode("ADD")
				b:GetHighlightTexture():SetAllPoints()
				b:SetCheckedTexture([[Interface\Common\UI-DropDownRadioChecks]])
				b:GetCheckedTexture():SetTexCoord(0, 0.5, 0.5, 1)
				b:GetCheckedTexture():ClearAllPoints()
				b:GetCheckedTexture():SetSize(16,16)
				b:GetCheckedTexture():SetPoint("LEFT", 3, 0)
				b:SetNormalTexture([[Interface\Common\UI-DropDownRadioChecks]])
				b:GetNormalTexture():SetTexCoord(0.5, 1, 0.5, 1)
				b:GetNormalTexture():ClearAllPoints()
				b:GetNormalTexture():SetSize(16,16)
				b:GetNormalTexture():SetPoint("LEFT", 3, 0)
				b:SetNormalFontObject(GameFontHighlightSmallLeft)
				b:SetDisabledFontObject(GameFontHighlightSmallLeft)
				b:SetText("The Fifth Suprise")
				b:GetFontString():ClearAllPoints()
				b:GetFontString():SetPoint("LEFT", 22, 0)
				b:SetPoint("TOPLEFT", relFrame, 0, 16-16*i)
				b:SetPoint("TOPRIGHT", relFrame, -16, 16-16*i)
				bindToCounter(b)
				b:SetScript("OnClick", Entry_OnClick)
				buttons[i] = b
			end
			scrollingDropdown:SetScript("OnHide", function(self)
				self:Hide()
				ReleaseDataSource()
			end)
			function sdAPI:Display(level, dataList, entryFormatter, entrySelect, skipFirst, willContinue)
				skipFirst = type(skipFirst) == "number" and skipFirst or 0
				local count = #dataList-skipFirst
				if count < MIN_SCROLL_ENTRIES then
					local info = {func=entrySelect, minWidth=level == 1 and UIDROPDOWNMENU_OPEN_MENU:GetWidth()-40 or nil}
					for i=skipFirst+1,#dataList do
						local k = dataList[i]
						info.arg1, info.text, info.checked = k, entryFormatter(k, dataList)
						UIDropDownMenu_AddButton(info, level)
					end
					return
				end
				local baseName = "DropDownList" .. level
				local host = _G[baseName]
				local n1 = (host.numButtons+1)
				local nX = MAX_VISIBLE_ENTRIES+n1-1
				local minWidth = math.max(120, level == 1 and UIDROPDOWNMENU_OPEN_MENU:GetWidth()-40 or 0)
				for i=skipFirst+1,#dataList do
					local text = entryFormatter(dataList[i], dataList)
					buttons[1]:SetText(text)
					minWidth = math.max(minWidth, 60 + buttons[1]:GetFontString():GetStringWidth())
				end
				local info = {notClickable=true, notCheckable=true, minWidth=minWidth}
				for i=n1,nX do
					UIDropDownMenu_AddButton(info, level)
				end
				local b1, bX, boY = _G[baseName .. "Button" .. n1], _G[baseName .. "Button" .. nX], willContinue and 0 or -4
				scrollingDropdown.parent = host
				scrollingDropdown:SetParent(host)
				scrollingDropdown:SetPoint("TOPLEFT", b1)
				scrollingDropdown:SetPoint("BOTTOMRIGHT", bX, "BOTTOMRIGHT", 0, boY)
				SetDataSource(dataList, entryFormatter, entrySelect, skipFirst)
				scrollingDropdown:Show()
				scrollingDropdown:SetFrameLevel(b1:GetFrameLevel()+2)
				slider:SetFrameLevel(scrollingDropdown:GetFrameLevel()+3)
				bb:SetHeight(PixelUtil.GetPixelToUIUnitFactor()/scrollingDropdown:GetEffectiveScale()*1.001)
				bb:SetShown(not not willContinue)
			end
		end
		config.ui.scrollingDropdown = sdAPI
	end
end
do -- config.bind
	local unbindMap, activeCaptureButton = {}
	local alternateFrame = CreateFrame("Frame", nil, UIParent) do
		CreateEdge(alternateFrame, { bgFile="Interface/ChatFrame/ChatFrameBackground", edgeFile="Interface/DialogFrame/UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={left=11, right=11, top=11, bottom=10}}, 0xd8000000)
		alternateFrame:SetSize(380, 115)
		alternateFrame:EnableMouse(1)
		alternateFrame:SetScript("OnHide", alternateFrame.Hide)
		local extReminder = CreateFrame("Button", nil, alternateFrame)
		extReminder:SetHeight(16) extReminder:SetPoint("TOPLEFT", 12, -10) extReminder:SetPoint("TOPRIGHT", -12, -10)
		extReminder:SetNormalTexture("Interface/Buttons/UI-OptionsButton")
		extReminder:SetPushedTextOffset(0,0)
		extReminder:SetText(" ") extReminder:SetNormalFontObject(GameFontHighlightSmall) do
			local fs, tex = extReminder:GetFontString(), extReminder:GetNormalTexture()
			fs:ClearAllPoints() tex:ClearAllPoints()
			fs:SetPoint("LEFT", 18, -1) tex:SetSize(14,14) tex:SetPoint("LEFT")
		end
		alternateFrame.caption = extReminder
		extReminder:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOP", self, "BOTTOM")
			GameTooltip:AddLine(L"Conditional Bindings", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			GameTooltip:AddLine(L"The binding will update to reflect the value of this macro conditional.", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
			GameTooltip:AddLine((L"You may use extended macro conditionals; see %s for details."):format("|cff33DDFFhttps://townlong-yak.com/addons/opie/extended-conditionals|r"), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
			GameTooltip:AddLine((L"Example: %s."):format(GREEN_FONT_COLOR_CODE .. "[combat] ALT-C; [nomounted] CTRL-F|r"), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			GameTooltip:Show()
		end)
		extReminder:SetScript("OnLeave", config.ui.HideTooltip)
		extReminder:SetScript("OnHide", extReminder:GetScript("OnLeave"))
		local input, scroll = config.ui.multilineInput("OPC_AlternateBindInput", alternateFrame, 335)
		alternateFrame.input, alternateFrame.scroll = input, scroll
		scroll:SetPoint("TOPLEFT", 10, -28)
		scroll:SetPoint("BOTTOMRIGHT", -33, 10)
		input:SetMaxBytes(1023)
		input:SetScript("OnEscapePressed", function() alternateFrame:Hide() end)
		input:SetScript("OnChar", function(self, c)
			if c == "\n" then
				local bind = strtrim((self:GetText():gsub("[\r\n]", "")))
				if bind ~= "" then
					alternateFrame.apiFrame.SetBinding(alternateFrame.owner, bind)
				end
				alternateFrame:Hide()
			end
		end)
	end
	local captureFrame = CreateFrame("Button") do
		captureFrame:Hide()
		captureFrame:RegisterForClicks("AnyUp")
		captureFrame:SetScript("OnClick", function(_, ...)
			if activeCaptureButton then
				activeCaptureButton:Click(...)
			end
		end)
	end
	local function MapMouseButton(button)
		if button == "MiddleButton" then return "BUTTON3" end
		if type(button) == "string" and (tonumber(button:match("^Button(%d+)"))) or 1 > 3 then
			return button:upper()
		end
	end
	local function Deactivate(self)
		self:UnlockHighlight()
		self:EnableKeyboard(false)
		self:SetScript("OnKeyDown", nil)
		self:SetScript("OnGamePadButtonDown", nil)
		self:SetScript("OnHide", nil)
		captureFrame:Hide()
		activeCaptureButton = activeCaptureButton ~= self and activeCaptureButton or nil
		if unbindMap[self:GetParent()] then
			unbindMap[self:GetParent()]:Disable()
		end
		return self
	end
	local unbindableKeys = {
		UNKNOWN=1, ESCAPE=1, ALT=1, SHIFT=1, META=1,
		LALT=1, LCTRL=1, LSHIFT=1, LMETA=1,
		RALT=1, RCTRL=1, RSHIFT=1, RMETA=1,
		PADRSTICKUP=1, PADRSTICKDOWN=1, PADRSTICKLEFT=1, PADRSTICKRIGHT=1,
		PADLSTICKUP=1, PADLSTICKDOWN=1, PADLSTICKLEFT=1, PADLSTICKRIGHT=1,
	}
	local function SetBind(self, bind)
		if bind == "ESCAPE" then
			return Deactivate(self)
		elseif unbindableKeys[bind] then
			return
		end
		Deactivate(self)
		local bind, p = bind and ((IsAltKeyDown() and "ALT-" or "") ..  (IsControlKeyDown() and "CTRL-" or "") .. (IsShiftKeyDown() and "SHIFT-" or "") .. (IsMetaKeyDown() and "META-" or "") .. bind), self:GetParent()
		if p and type(p.SetBinding) == "function" then
			p.SetBinding(self, bind)
		end
	end
	local function OnClick(self, button)
		local parent = self:GetParent()
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
		if activeCaptureButton then
			local deactivated, mappedButton = Deactivate(activeCaptureButton), MapMouseButton(button)
			if deactivated == self and (mappedButton or button == "RightButton") then
				SetBind(self, mappedButton)
			end
			if deactivated == self then return end
		end
		if IsAltKeyDown() and activeCaptureButton == nil and self:GetParent().OnBindingAltClick then
			return parent.OnBindingAltClick(self, button)
		end
		activeCaptureButton = self
		self:LockHighlight()
		self:EnableKeyboard(true)
		self:SetScript("OnKeyDown", SetBind)
		self:SetScript("OnGamePadButtonDown", SetBind)
		self:SetScript("OnHide", Deactivate)
		if parent then
			captureFrame:SetParent(parent.bindingContainerFrame or parent)
			captureFrame:SetAllPoints()
			captureFrame:Show()
			captureFrame:SetFrameLevel(self:GetFrameLevel()-1)
		end
		if unbindMap[self:GetParent()] then
			unbindMap[self:GetParent()]:Enable()
		end
	end
	local function OnWheel(self, delta)
		local aw = self:GetParent().AllowWheelBinding
		if activeCaptureButton == self and aw and (type(aw) ~= "function" or aw(self)) then
			SetBind(self, delta > 0 and "MOUSEWHEELUP" or "MOUSEWHEELDOWN")
		end
	end
	local function UnbindClick(self)
		if activeCaptureButton and unbindMap[activeCaptureButton:GetParent()] == self then
			local p, button = activeCaptureButton:GetParent(), activeCaptureButton
			if p and type(p.SetBinding) == "function" then
				p.SetBinding(activeCaptureButton, false)
			end
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			Deactivate(button)
		end
	end
	local function IsCapturingBinding(self)
		return activeCaptureButton == self
	end
	local specialSymbolMap = {OPEN="[", CLOSE="]", SEMICOLON=";"}
	local function bindNameLookup(key)
		return GetBindingText(specialSymbolMap[key] or key)
	end
	local function bindFormat(bind)
		return bind and bind ~= "" and GetBindingText((bind:gsub("[^%-]+$", bindNameLookup))) or L"Not bound"
	end
	local function SetBindingText(self, bind, pre, post)
		if type(bind) == "string" and bind:match("%[.*%]") then
			return SetBindingText(self, KR:EvaluateCmdOptions(bind), pre, post or " |cff20ff20[+]|r")
		end
		return self:SetText((pre or "") .. bindFormat(bind) .. (post or ""))
	end
	local function ToggleAlternateEditor(self, bind)
		if alternateFrame:IsShown() and alternateFrame.owner == self then
			alternateFrame:Hide()
		else
			alternateFrame.apiFrame, alternateFrame.owner = self:GetParent(), self
			alternateFrame.caption:SetFormattedText(L"Press %s to save.", NORMAL_FONT_COLOR_CODE .. GetBindingText("ENTER") .. "|r")
			alternateFrame.input:SetText(bind or "")
			alternateFrame:SetParent(self)
			alternateFrame:SetFrameLevel(self:GetFrameLevel()+10)
			alternateFrame:ClearAllPoints()
			alternateFrame:SetPoint("TOP", self, "BOTTOM", 0, 4)
			if alternateFrame:GetLeft() < self:GetParent():GetLeft() then
				alternateFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -8, 4)
			elseif alternateFrame:GetRight() > self:GetParent():GetRight() then
				alternateFrame:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 8, 4)
			end
			alternateFrame:Show()
			alternateFrame.input:SetFocus()
		end
	end
	function config.createBindingButton(parent)
		local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
		btn:SetSize(120, 22)
		btn:RegisterForClicks("AnyUp")
		btn:SetScript("OnClick", OnClick)
		btn:SetScript("OnMouseWheel", OnWheel)
		btn:EnableMouseWheel(true)
		btn:SetText(" ")
		btn:GetFontString():SetMaxLines(1)
		btn.IsCapturingBinding, btn.SetBindingText, btn.ToggleAlternateEditor =
			IsCapturingBinding, SetBindingText, ToggleAlternateEditor
		return btn, unbindMap[parent]
	end
	function config.createUnbindButton(parent)
		local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
		btn:Disable()
		btn:SetSize(140, 22)
		unbindMap[parent] = btn
		btn:SetScript("OnClick", UnbindClick)
		return btn
	end
end
do -- config.undo
	local undoStack, undo = {}, {}
	config.undo = undo
	function undo:unwind()
		local entry
		for i=#undoStack,1,-1 do
			entry, undoStack[i] = undoStack[i]
			securecall(entry.func, unpack(entry, 1, entry.n))
		end
	end
	function undo:clear()
		undoStack = {}
	end
	function undo:search(key)
		for i=#undoStack,1,-1 do
			if undoStack[i].key == key then
				return true
			end
		end
	end
	local function undoEntry(key, func, ...)
		return {key=key, func=func, n=select("#", ...), ...}
	end
	function undo:push(...)
		undoStack[#undoStack + 1] = undoEntry(...)
	end
	function undo:sink(...)
		for i=#undoStack, 1, -1 do
			undoStack[i+1] = undoStack[i]
		end
		undoStack[1] = undoEntry(...)
	end
end
do -- config.pulseDropdown
	local function cloneTex(tex)
		local l, sl = tex:GetDrawLayer()
		local r = tex:GetParent():CreateTexture(nil, l, nil, sl+1)
		r:SetAllPoints(tex)
		r:SetTexture(tex:GetTexture())
		r:SetTexCoord(tex:GetTexCoord())
		r:SetVertexColor(0, 0.5, 0.75)
		r:SetBlendMode("ADD")
		return r
	end
	function config.pulseDropdown(drop)
		if not drop.LeftA then
			drop.LeftA, drop.MiddleA, drop.RightA = cloneTex(drop.Left), cloneTex(drop.Middle), cloneTex(drop.Right)
		end
		local endTime = GetTime()+2
		local function pulse()
			if drop.pulseFunc ~= pulse then
				return
			end
			local t = GetTime()
			if t >= endTime or not drop:IsVisible() then
				drop.MiddleA:SetAlpha(0)
				drop.LeftA:SetAlpha(0)
				drop.RightA:SetAlpha(0)
				drop.pulseFunc = nil
				return
			end
			local p = 1-(endTime-t)/2
			local s = 0.5+sin(p*360*3-90)/2
			drop.LeftA:SetAlpha(s)
			drop.MiddleA:SetAlpha(s)
			drop.RightA:SetAlpha(s)
			C_Timer.After(0, pulse)
		end
		drop.pulseFunc = pulse
		pulse()
	end
end

local function CallSwitchProfile(...)
	return PC:SwitchProfile(...)
end
local function CallSetSpecProfiles(...)
	return PC:SetSpecProfiles(...)
end
local function CallDeleteProfile(...)
	return PC:DeleteProfile(...)
end
function config.undo:saveSpecProfiles()
	if not self:search("profile-specs-init") then
		self:sink("profile-specs-init", CallSetSpecProfiles, PC:GetSpecProfiles())
	end
end
function config.undo:saveActiveProfile()
	self:saveSpecProfiles()
	local name = OPie:GetCurrentProfile()
	if not self:search("OPieProfile#" .. name) then
		self:push("OPieProfile#" .. name, CallSwitchProfile, name, (PC:ExportProfile(name)))
	end
end

function config.checkSVState(frame)
	if not PC:GetSVState() then
		T.TenSettings:ShowAlertOverlay(frame, L"Changes will not be saved", L"World of Warcraft could not load OPie's saved variables due to a lack of memory. Try disabling other addons.\n\nAny changes you make now will not be saved.", L"Understood; edit anyway")
	end
end

local OPC_OptionSets = {
	{ L"Behavior",
		{"bool", "RingAtMouse", caption=L"Center rings at mouse"},
		{"bool", "ClickPriority", caption=L"Make rings top-most"},
		{"bool", "CenterAction", caption=L"Quick action at ring center"},
		{"bool", "MotionAction", caption=L"Quick action if mouse remains still"},
		{"bool", "SliceBinding", caption=L"Per-slice bindings"},
		{"bool", "ClickActivation", caption=L"Activate on left click"},
		{"bool", "NoClose", caption=L"Leave open after use", depOn="ClickActivation", depValue=true, otherwise=false},
		{"bool", "UseDefaultBindings", caption=L"Use default ring bindings"},
		{"drop", "PadSupportMode", {"freelook", "cursor", "none", freelook=L"Camera analog stick", cursor=L"Virtual mouse cursor", none=L"None"}, caption=L"Controller interaction mode", hideFeature="GamePad"},
		{"range", "IndicationOffsetX", -500, 500, 50, caption=L"Move rings right", valueFormat="%d"},
		{"range", "IndicationOffsetY", -300, 300, 50, caption=L"Move rings down", valueFormat="%d"},
		{"range", "MouseBucket", 5, 1, 1, caption=L"Scroll wheel sensitivity", stdLabels=true},
		{"range", "RingScale", 0.1, 2, caption=L"Ring scale", valueFormat="%0.1f"},
	}, { L"Appearance",
		{"bool", "GhostMIRings", caption=L"Nested rings"},
		{"bool", "ShowKeys", caption=L"Per-slice bindings", depOn="SliceBinding", depValue=true, otherwise=false},
		{"bool", "ShowCooldowns", caption=L"Show cooldown numbers", depIndicatorFeature="CooldownNumbers"},
		{"bool", "ShowRecharge", caption=L"Show recharge numbers", depIndicatorFeature="CooldownNumbers"},
		{"bool", "ShowShortLabels", caption=L"Show slice labels"},
		{"bool", "UseGameTooltip", caption=L"Show tooltips"},
		{"bool", "HideStanceBar", caption=L"Hide stance bar", global=true},
	}, { L"Animation",
		{"bool", "MIScale", caption=L"Enlarge selected slice"},
		{"bool", "MISpinOnHide", caption=L"Outward spiral on hide"},
		{"bool", "XTPointerSnap", caption=L"Snap pointer to mouse cursor"},
		{"range", "XTZoomTime", 0, 1, 0.1, caption=L"Zoom-in/out time", valueFormat=L"%.1f sec"},
	}
}

frame = config.createPanel("OPie", nil, {forceRootVersion=true})
	frame.version:SetFormattedText("%s", OPie:GetVersion() or "")
	frame.desc:SetText(L"Customize OPie's appearance and behavior. Right clicking a checkbox restores it to its default state."
		.. (MODERN and "\n" .. L"Profiles activate automatically when you switch character specializations." or ""))
local OPC_Profile = CreateFrame("Frame", "OPC_Profile", frame, "UIDropDownMenuTemplate")
	OPC_Profile:SetPoint("TOPLEFT", frame, 0, -80)
	UIDropDownMenu_SetWidth(OPC_Profile, 200)
local OPC_OptionDomain = CreateFrame("Frame", "OPC_OptionDomain", frame, "UIDropDownMenuTemplate")
	OPC_OptionDomain:SetPoint("LEFT", OPC_Profile, "RIGHT")
	UIDropDownMenu_SetWidth(OPC_OptionDomain, 250)

local OPC_WidgetControl, OPC_AlterOption, OPC_BlockInput = {}
do -- Widget construction
	local build = {}
	local function notifyChange(self, ...)
		if not OPC_BlockInput then
			OPC_AlterOption(self, self.id, self:IsObjectType("Slider") and self:GetValue() or (not not self:GetChecked()), ...)
		end
	end
	local function OnStateChange(self)
		local a = self:IsEnabled() and 1 or 0.6
		self.text:SetVertexColor(a,a,a)
	end
	local function dropSelect(_, nv, drop)
		local dd = OPC_WidgetControl[drop]
		OPC_AlterOption(drop, dd[2], nv)
	end
	local function dropInitialize(self)
		local dda = OPC_WidgetControl[self][3]
		local info = {func=dropSelect, arg2=self, minWidth=self:GetWidth()-40}
		for i=1,#dda do
			local k = dda[i]
			info.text, info.arg1, info.checked = dda[k], k, OPC_WidgetControl[self].cv == k
			UIDropDownMenu_AddButton(info)
		end
	end
	local function dropSetValue(self, v)
		local dd = OPC_WidgetControl[self]
		dd.cv = v
		UIDropDownMenu_SetText(self, dd[3][v])
	end
	local function anchor_OnVisibilityChange(self)
		local v = OPC_WidgetControl[self]
		local r, y = v.anchorOffsetRelFrame, v[self:IsVisible() and "anchorOffsetVisible" or "anchorOffsetHidden"]
		self:SetPoint("TOPLEFT", r, "TOPLEFT", 0, y)
		self:SetPoint("TOPRIGHT", r, "TOPRIGHT", 0, y)
	end
	function build.bool(v, ofsY, halfpoint, rowHeight, rframe)
		local b = T.TenSettings:CreateOptionsCheckButton(nil, frame)
		b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		b:SetMotionScriptsWhileDisabled(true)
		b.id, b.text, b.desc = v[2], b.Text, v
		b:SetPoint("TOPLEFT", rframe, "TOPLEFT", halfpoint and 315 or 15, ofsY)
		b:SetScript("OnClick", notifyChange)
		hooksecurefunc(b, "SetEnabled", OnStateChange)
		return b, ofsY - (halfpoint and rowHeight or 0), not halfpoint, halfpoint and 0 or 20
	end
	function build.range(v, ofsY, halfpoint, rowHeight, rframe)
		if halfpoint then
			ofsY = ofsY - rowHeight
		end
		local s, leftMargin, centerLine = T.TenSettings:CreateOptionsSlider(frame, nil, 212)
		s:SetPoint("TOPLEFT", rframe, "TOPLEFT", 319-leftMargin, ofsY-5)
		s.text:SetPoint("LEFT", rframe, "TOPLEFT", 44, ofsY-5-centerLine)
		s.text:Show()
		s:SetValueStep(v[5] or 0.1)
		s:SetMinMaxValues(v[3] < v[4] and v[3] or -v[3], v[4] > v[3] and v[4] or -v[4])
		s:SetObeyStepOnDrag(true)
		s:SetScript("OnValueChanged", notifyChange)
		s.id, s.desc = v[2], v
		if not v.stdLabels then
			s.lo:SetText(v[3])
			s.hi:SetText(v[4])
		end
		return s, ofsY - 20, false, 0
	end
	function build.drop(v, ofsY, halfpoint, rowHeight, rframe)
		local f = CreateFrame("Frame", "OPC_Drop" .. v[2], frame, "UIDropDownMenuTemplate")
		if halfpoint then ofsY = ofsY - rowHeight end
		f:SetPoint("TOPLEFT", rframe, "TOPLEFT", 300, ofsY-4)
		UIDropDownMenu_SetWidth(f, 210)
		UIDropDownMenu_SetText(f, "Chicken-doom")
		f.initialize, f.refresh = dropInitialize, dropSetValue
		f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		f.text:SetPoint("TOPLEFT", rframe, "TOPLEFT", 44, ofsY-12.5)
		f.text:SetText(v.caption)
		return f, ofsY - 32, false, 0
	end
	function build.anchor(v, oY, cY, rframe)
		local f = CreateFrame("Frame", nil, v.widget)
		f:SetHeight(1)
		OPC_WidgetControl[f], v.anchorOffsetVisible, v.anchorOffsetHidden, v.anchorOffsetRelFrame = v, cY, oY, rframe
		f:SetScript("OnHide", anchor_OnVisibilityChange)
		f:SetScript("OnShow", anchor_OnVisibilityChange)
		anchor_OnVisibilityChange(f)
		return f
	end

	local cY, halfpoint, rframe, rowHeight = -100, false, frame
	for _, v in ipairs(OPC_OptionSets) do
		v.label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		v.label:SetPoint("TOP", rframe, "TOP", -50, cY-15)
		v.label:SetJustifyH("LEFT")
		v.label:SetPoint("LEFT", rframe, "LEFT", 16, 0)
		v.label:SetText(v[1])
		cY, halfpoint, rowHeight = cY - 36, false, 0
		for j=2,#v do
			local vj, oY = v[j], cY - (halfpoint and rowHeight or 0)
			vj.widget, cY, halfpoint, rowHeight = build[vj[1]](vj, cY, halfpoint, rowHeight, rframe)
			OPC_WidgetControl[vj.widget] = vj
			if vj.hideFeature then
				cY, rframe = 0, build.anchor(vj, oY, cY, rframe)
			end
		end
		if halfpoint then
			cY = cY - rowHeight
		end
	end
end
local OPC_AppearanceFactory = CreateFrame("Frame", "OPC_AppearanceDropdown", frame, "UIDropDownMenuTemplate")
OPC_AppearanceFactory:SetPoint("LEFT", OPC_OptionSets[2].label, "LEFT", 280, -2)
UIDropDownMenu_SetWidth(OPC_AppearanceFactory, 200)

T.OPC_RingScopePrefixes = {
	[30] = "|cff25bdff",
	[20] = "|c" .. RAID_CLASS_COLORS[select(2,UnitClass("player"))].colorStr,
	[10] = "|cffabffd5",
}

local OR_CurrentOptionsDomain

local function OPC_UpdateControlReqs(v)
	local enabled, disabledHint = true, nil
	if v.depOn then
		enabled = PC:GetOption(v.depOn, OR_CurrentOptionsDomain) == v.depValue
	elseif v.depIndicatorFeature then
		enabled = T.OPieUI:DoesIndicatorConstructorSupport(PC:GetOption("IndicatorFactory", OR_CurrentOptionsDomain), v.depIndicatorFeature)
		disabledHint = L"Not supported by selected appearance."
	end
	v.widget:SetEnabled(enabled)
	-- It just so happens they're all checkboxes. This will explode when they are not.
	if enabled then
		v.widget:SetChecked(PC:GetOption(v[2], OR_CurrentOptionsDomain) or nil)
		v.widget.tooltipText = nil
	else
		v.widget:SetChecked(v.otherwise or nil)
		v.widget.tooltipText = disabledHint
	end
end
function OPC_AlterOption(widget, option, newval, ...)
	local control = OPC_WidgetControl[widget]
	if (...) == "RightButton" then
		newval = nil
	end
	if control[1] == "range" and control[3] > control[4] and type(newval) == "number" then
		newval = -newval
	end
	config.undo:saveActiveProfile()
	PC:SetOption(option, newval, OR_CurrentOptionsDomain)
	local setval = PC:GetOption(option, OR_CurrentOptionsDomain)
	if widget:IsObjectType("Slider") then
		local text, vf = widget.desc.caption, widget.desc.valueFormat
		if vf then
			text = text .. " |cffffd500(" .. vf:format(setval) .. ")|r"
		end
		widget.text:SetText(text)
		OPC_BlockInput = true
		widget:SetValue(setval * (control[3] > control[4] and -1 or 1))
		OPC_BlockInput = false
	elseif control[1] == "drop" then
		widget:refresh(newval)
	elseif setval ~= newval then
		widget:SetChecked(setval and 1 or nil)
	end
	for _,set in ipairs(OPC_OptionSets) do for j=2,#set do local v = set[j]
		if v.depOn == option then
			OPC_UpdateControlReqs(v)
		end
	end end
end
local function OPC_OptionDomain_click(_, ringName)
	OR_CurrentOptionsDomain = ringName or nil
	frame.resetOnHide = nil
	frame.refresh()
end
local function OPC_OptionDomain_Format(key, list)
	return list[key], OR_CurrentOptionsDomain == (key or nil)
end
function OPC_OptionDomain:initialize()
	local list = {false, [false]=L"Defaults for all rings"}
	local ct = T.OPC_RingScopePrefixes
	for key, name, scope in OPie:IterateRings(IsAltKeyDown()) do
		local color = ct and ct[scope] or "|cffacd7e6"
		list[#list+1], list[key] = key, (L"Ring: %s"):format(color .. (name or key) .. "|r")
	end
	config.ui.scrollingDropdown:Display(1, list, OPC_OptionDomain_Format, OPC_OptionDomain_click)
end
function OPC_OptionDomain:text()
	local label = L"Defaults for all rings"
	if OR_CurrentOptionsDomain then
		local name, key = OPie:GetRingInfo(OR_CurrentOptionsDomain)
		label = (L"Ring: %s"):format("|cffaaffff" .. (name or key) .."|r")
	end
	UIDropDownMenu_SetText(self, label)
end
local function OPC_Profile_FormatName(ident)
	return ident == "default" and L"default" or ident
end
do -- OPC_Profile:initialize
	local curProfile
	local function dup(n, v)
		if n > 0 then
			return v, dup(n-1, v)
		end
	end
	local function prependCount(...)
		return select("#", ...), ...
	end
	local function OPC_Profile_format(ident, list)
		return list[ident], curProfile == ident, ident
	end
	local function OPC_Profile_switch(_, ident)
		config.undo:saveSpecProfiles()
		PC:SwitchProfile(ident)
	end
	local function OPC_Profile_new_callback(self, text, apply, _frame)
		local name = text:match("^%s*(.-)%s*$")
		if name == "" or PC:ProfileExists(name) then
			if apply then self:SetText("") end
			return false
		elseif apply then
			config.undo:saveSpecProfiles()
			PC:SwitchProfile(name, true)
			if not config.undo:search("OPieProfile#" .. name) then
				config.undo:push("OPieProfile#" .. name, CallDeleteProfile, name)
			end
		end
		return true
	end
	local function OPC_Profile_new(_, _, frame)
		T.TenSettings:ShowPromptOverlay(frame, L"Create a New Profile", L"New profile name:", L"Profiles save options and ring bindings.", L"Create Profile", OPC_Profile_new_callback)
	end
	local function OPC_Profile_delete()
		config.undo:saveActiveProfile()
		PC:DeleteProfile(OPie:GetCurrentProfile())
	end
	local function OPC_Profile_assignAllSpecs(_, curProfile)
		config.undo:saveSpecProfiles()
		PC:SetSpecProfiles(dup(select("#", PC:GetSpecProfiles()), curProfile))
	end
	function OPC_Profile:initialize()
		local hasPartialSpecProfiles, ns, p1, p2, p3, p4, plist = false, prependCount(PC:GetSpecProfiles())
		curProfile, plist, ns = OPie:GetCurrentProfile(), PC:GetAllProfiles(), ns > 1 and ns or 0
		for k=1, #plist do
			local ident = plist[k]
			local name, suf, ni = OPC_Profile_FormatName(ident), "", 0
			for i=1, ns do
				if ident == select(i, p1, p2, p3, p4) then
					if MODERN then
						local _, _, _, ico = GetSpecializationInfo(i)
						ni, suf = ni + 1, (ni > 0 and suf .. "|T" or " |T") .. (ico or "Interface/Icons/INV_Misc_QuestionMark") .. ":16:16:4:0:64:64:4:60:4:60|t"
					elseif CF_WRATH then
						ni, suf = ni + 1, suf .. " |cffff99ff[" .. i .."]|r"
					end
				end
			end
			if ni > 0 and ni < ns then
				name, hasPartialSpecProfiles = name .. suf, true
			end
			plist[ident] = name
		end
		config.ui.scrollingDropdown:Display(1, plist, OPC_Profile_format, OPC_Profile_switch, nil, true)
		local info = {arg2=self:GetParent(), text="", disabled=true, notCheckable=true, justifyH="CENTER"}
		UIDropDownMenu_AddButton(info)
		info.text, info.disabled, info.func, info.arg1 = L"Assign to all specializations", not hasPartialSpecProfiles, OPC_Profile_assignAllSpecs, curProfile
		if ns > 1 then
			UIDropDownMenu_AddButton(info)
		end
		info.text, info.minWidth, info.func, info.arg1, info.disabled = L"Create a new profile", self:GetWidth()-40, OPC_Profile_new, nil, nil
		UIDropDownMenu_AddButton(info)
		info.text, info.func = curProfile ~= "default" and L"Delete current profile" or L"Restore default settings", OPC_Profile_delete
		UIDropDownMenu_AddButton(info)
	end
end
function OPC_Profile:text()
	UIDropDownMenu_SetText(self, L"Profile" .. ": " .. OPC_Profile_FormatName(OPie:GetCurrentProfile()))
end
function OPC_AppearanceFactory:formatText(key, outOfDate, name)
	name = name or T.OPieUI:GetIndicatorConstructorName(key)
	if not name then
		name = "|cffa0a0a0*[" .. T.OPieUI:GetIndicatorConstructorName() .. "]|r"
	end
	if outOfDate then
		name = "|cffff6060" .. name .. "|r"
	end
	if key == "mirage" then
		name = "|cff00e800" .. name .. "|r"
	elseif key == "_" then
		name = L"Not customized" .. " (|cffb0b0b0" .. name .. "|r)"
	end
	return name
end
function OPC_AppearanceFactory:text()
	local key, own = PC:GetOption("IndicatorFactory", OR_CurrentOptionsDomain)
	UIDropDownMenu_SetText(self, OR_CurrentOptionsDomain and own == nil and L"Use global setting" or self:formatText(key, false))
end
function OPC_AppearanceFactory:initialize()
	local info = {func=self.set, minWidth=UIDROPDOWNMENU_OPEN_MENU:GetWidth()-40, tooltipOnButton=true}
	local current, own = PC:GetOption("IndicatorFactory", OR_CurrentOptionsDomain)
	for k, name, outOfDate in T.OPieUI:EnumerateRegisteredIndicatorConstructors() do
		name = self:formatText(k, outOfDate, name)
		if k == "_" then
			UIDropDownMenu_AddSeparator()
		end
		if outOfDate then
			info.tooltipTitle, info.tooltipText = "|cffff2020" .. L"Update required", L"This appearance may not support all OPie features."
		else
			info.tooltipTitle, info.tooltipText = nil
		end
		info.arg1, info.text, info.checked = k, name, k == own or (own == nil and not OR_CurrentOptionsDomain and current == k)
		UIDropDownMenu_AddButton(info)
	end
	if OR_CurrentOptionsDomain then
		info.text, info.arg1, info.checked = L"Use global setting", nil, own == nil
		info.tooltipTitle, info.tooltipText = nil
		UIDropDownMenu_AddButton(info)
	end
end
function OPC_AppearanceFactory:set(key)
	PC:SetOption("IndicatorFactory", key, OR_CurrentOptionsDomain)
	OPC_AppearanceFactory:text()
	for _,set in ipairs(OPC_OptionSets) do for j=2,#set do local v = set[j]
		if v.depIndicatorFeature then
			OPC_UpdateControlReqs(v)
		end
	end end
end
function frame.refresh()
	OPC_BlockInput = true
	for _, v in pairs(OPC_OptionSets) do
		v.label:SetText(v[1])
	end
	OPC_OptionDomain:text()
	OPC_Profile:text()
	OPC_AppearanceFactory:text()
	OPC_AppearanceFactory:SetShown(T.OPieUI:HasMultipleIndicatorConstructors())
	for _, set in pairs(OPC_OptionSets) do for j=2,#set do
		local v, opttype, option = set[j], set[j][1], set[j][2]
		if opttype == "range" then
			v.widget:SetValue(PC:GetOption(option) * (v[3] < v[4] and 1 or -1))
			local text = v.caption
			if v.valueFormat then
				local vf = v.valueFormat:format(v.widget:GetValue())
				text = text .. " |cffffd500(" .. vf .. ")|r"
			end
			v.widget.text:SetText(text)
		elseif opttype == "bool" then
			v.widget:SetChecked(PC:GetOption(option, OR_CurrentOptionsDomain) or nil)
			v.widget.text:SetText(v.caption)
		elseif opttype == "drop" then
			v.widget:refresh(PC:GetOption(option, OR_CurrentOptionsDomain) or nil)
		end
		if v.depOn or v.depIndicatorFeature then
			OPC_UpdateControlReqs(v)
		end
		if v.hideFeature == "GamePad" and not C_GamePad.IsEnabled() then
			v.widget:Hide()
		else
			v.widget:SetShown(not v.global or OR_CurrentOptionsDomain == nil)
		end
	end end
	OPC_BlockInput = false
	config.checkSVState(frame)
end
function frame.cancel()
	config.undo:unwind()
	OR_CurrentOptionsDomain = nil
end
function frame.default()
	config.undo:saveActiveProfile()
	PC:ResetOptions(true)
	frame.refresh()
end
function frame.okay()
	config.undo:clear()
	OR_CurrentOptionsDomain = nil
end
frame:SetScript("OnShow", frame.refresh)
frame:SetScript("OnHide", function()
	if frame.resetOnHide then
		OR_CurrentOptionsDomain, frame.resetOnHide = nil
	end
end)

function EV:OPIE_PROFILE_SWITCHED(_new, _old)
	if frame:IsVisible() then
		frame.refresh()
	end
end

function T.ShowOPieOptionsPanel(ringKey)
	frame:OpenPanel()
	OPC_OptionDomain_click(nil, ringKey)
	frame.resetOnHide = true
	config.pulseDropdown(OPC_OptionDomain)
end