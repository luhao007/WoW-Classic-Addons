local _, T = ...
local XU, ScrollBar, iSB, type = T.exUI, {}, {}, type
local assert, getWidgetData, newWidgetData, setWidgetData, AddObjectMethods, CallObjectScript = XU:GetImpl()

local HOLD_ACTION_DELAY, PAGE_DELAY, STEPPER_REPEAT_DELAY = 0.15, 0.25, 1/3
local MIN_ANIMATION_FRAMERATE, ANIMATION_TARGET_DURATION = 45, 0.2
local STYLES, DEFAULT_STYLE = {}, "minimal" do
	STYLES.common = {
		trackWidth = 20, stepperReserve = 18.5, stepperMarginY = 1, stepperTrack = true, thumbMinSize=16,
		trackTop = {"t", "Interface/PaperDollInfoFrame/UI-Character-ScrollBar", tc={2/64, 29/64, 0/256, 32/256}, w=22, h=22/27*32},
		trackTopBare = {tc={2/64, 29/64, 21/256, 32/256}, h=22/27*11},
		trackMid = {"t", "Interface/PaperDollInfoFrame/UI-Character-ScrollBar", tc={2/64, 29/64, 28/256, 1}},
		trackBot = {"t", "Interface/PaperDollInfoFrame/UI-Character-ScrollBar", tc={35/64, 62/64, 228/256, 255/256}, w=22, h=22},
		trackBotBare = {tc={35/64, 62/64, 228/256, 234/256}, h=22/27*6},
		trackBack = {"c", 0x5a000000, insetH=2, insetV=1},
		thumb = {w=15, h=20, ofsX=0.25, midOfsAbsolute=true, midOfsB=6, midOfsT=6},
		thumbTop = {"a", "UI-ScrollBar-Knob-EndCap-Top", hcB=28, h=20, hcT=1},
		thumbTopH = {"a", "UI-ScrollBar-Knob-MouseOver-EndCap-Top"},
		thumbMid = {"a", "UI-ScrollBar-Knob-Center", h=0, tch=1022},
		thumbMidH = {"a", "UI-ScrollBar-Knob-MouseOver-Center", h=0, tch=1022},
		thumbBot = {"a", "UI-ScrollBar-Knob-EndCap-Bottom", hcB=28, h=20},
		thumbBotH = {"a", "UI-ScrollBar-Knob-MouseOver-EndCap-Bottom"},
		step = {w=18, h=16, tc={0.20, 0.80, 0.25, 0.75}},
		stepUp = {"t", "Interface/Buttons/UI-ScrollBar-ScrollUpButton-Up"},
		stepUpH = {"t", "Interface/Buttons/UI-ScrollBar-ScrollUpButton-Highlight", blend="ADD"},
		stepUpP = {"t", "Interface/Buttons/UI-ScrollBar-ScrollUpButton-Down"},
		stepUpD = {"t", "Interface/Buttons/UI-ScrollBar-ScrollUpButton-Disabled"},
		stepDown = {"t", "Interface/Buttons/UI-ScrollBar-ScrollDownButton-Up"},
		stepDownH = {"t", "Interface/Buttons/UI-ScrollBar-ScrollDownButton-Highlight", blend="ADD"},
		stepDownP = {"t", "Interface/Buttons/UI-ScrollBar-ScrollDownButton-Down"},
		stepDownD = {"t", "Interface/Buttons/UI-ScrollBar-ScrollDownButton-Disabled"},
	}
	STYLES.minimal = {
		trackWidth = 10, stepperReserve = 20, stepperMarginY = 2, stepperPushOfsY = 2, thumbMinSize=18,
		trackMid = {"a", "!minimal-scrollbar-track-middle", asize=1},
		trackTop = {"a", "minimal-scrollbar-track-top", asize=1},
		trackBot = {"a", "minimal-scrollbar-track-bottom", asize=1},
		thumb = {w=8, h=20, midOfsAbsolute=true, midOfsT=8, midOfsB=10, asize=1},
		thumbS = {w=8, h=20, midOfsAbsolute=true, midOfsT=8, midOfsB=6, asize=1},
		smallThumbThreshold = 32,
		thumbTop  = {"a", "minimal-scrollbar-thumb-top"},
		thumbTopH = {"a", "minimal-scrollbar-thumb-top-over"},
		thumbTopP = {"a", "minimal-scrollbar-thumb-top-down"},
		thumbBot  = {"a", "minimal-scrollbar-thumb-bottom"},
		thumbBotS = {"a", "minimal-scrollbar-small-thumb-bottom"},
		thumbBotH = {"a", "minimal-scrollbar-thumb-bottom-over"},
		thumbBotHS = {"a", "minimal-scrollbar-small-thumb-bottom-over"},
		thumbBotP = {"a", "minimal-scrollbar-thumb-bottom-down"},
		thumbBotPS = {"a", "minimal-scrollbar-small-thumb-bottom-down"},
		thumbMid  = {"a", "minimal-scrollbar-thumb-middle", tch=715},
		thumbMidH = {"a", "minimal-scrollbar-thumb-middle-over"},
		thumbMidP = {"a", "minimal-scrollbar-thumb-middle-down"},
		step = {asize=1},
		stepUp  = {"a", "minimal-scrollbar-arrow-top"},
		stepUpH = {"a", "minimal-scrollbar-arrow-top-over"},
		stepUpP = {"a", "minimal-scrollbar-arrow-top-down"},
		stepUpD = {desat=true, vc={0.5, 0.5, 0.5}},
		stepDown  = {"a", "minimal-scrollbar-arrow-bottom"},
		stepDownH = {"a", "minimal-scrollbar-arrow-bottom-over"},
		stepDownP = {"a", "minimal-scrollbar-arrow-bottom-down"},
		stepDownD = {desat=true, vc={0.5, 0.5, 0.5}},
	}
end

local ScrollBarData, scrollBarProps = {}, {
	api=ScrollBar,
	scripts={"OnMinMaxChanged", "OnValueChanged"},
	val=0,
	min=0,
	max=100,
	win=10,
	step=1,
	stepsPerPage=1, stepsPerWheel=nil,
	maxAnimSteps=math.huge,
	enabled=true,
}
AddObjectMethods({"ScrollBar"}, scrollBarProps)

-- Public ScrollBar Widget API
function ScrollBar:GetValue()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.val
end
function ScrollBar:SetValue(value, forceNotify)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	assert(type(value) == "number", 'Syntax: ScrollBar:SetValue(value[, forceNotify])')
	if d.val ~= value then
		iSB.SetValue(d, value, false, true)
	elseif forceNotify then
		iSB.NotifyValueChanged(d, false, false)
	end
end
function ScrollBar:GetMinMaxValues()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.min, d.max
end
function ScrollBar:SetMinMaxValues(minValue, maxValue)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	assert(type(minValue) == 'number' and type(maxValue) == 'number', 'Syntax: ScrollBar:SetMinMaxValues(minValue, maxValue)')
	if minValue == d.min and maxValue == d.max then return end
	d.min, d.max, d.ThumbSize = minValue, maxValue < minValue and minValue or maxValue
	iSB.SetValue(d, d.val, false)
	iSB.SetInteractionState(d, "NONE")
	iSB.UpdateThumbSizeAndPosition(d)
	CallObjectScript(d.self, "OnMinMaxChanged", minValue, maxValue)
end
function ScrollBar:GetWindowRange()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.win
end
function ScrollBar:SetWindowRange(range)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	if d.win == range then return end
	assert(type(range) == 'number' and range >= 0, 'Syntax: ScrollBar:SetWindowRange(range)')
	d.win = range
	iSB.UpdateThumbSizeAndPosition(d)
	iSB.SetInteractionState(d, "NONE")
end
function ScrollBar:GetValueStep()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.step
end
function ScrollBar:SetValueStep(step)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	assert(type(step) == "number" and step >= 0, 'Syntax: ScrollBar:SetValueStep(step)')
	d.step = step
end
function ScrollBar:GetStepsPerPage()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.stepsPerPage, d.stepsPerWheel
end
function ScrollBar:SetStepsPerPage(steps, ...)
	local d, ws = assert(getWidgetData(self, ScrollBarData), "Invalid object type"), ...
	assert(type(steps) == "number" and steps >= 1 and
	       (ws == nil or type(ws) == "number" and ws >= 1),
	       'Syntax: ScrollBar:SetStepsPerPage(stepsPerPage[, stepsPerWheel])')
	d.stepsPerPage, d.stepsPerWheel = steps, ws or select("#", ...) == 0 and d.stepsPerWheel or nil
end
function ScrollBar:GetStepperButtonsShown()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.StepUp:IsShown()
end
function ScrollBar:SetStepperButtonsShown(shown)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	d.StepUp:SetShown(shown)
	d.StepDown:SetShown(shown)
	iSB.SetInteractionState(d, "NONE")
	iSB.ApplyTrackAnchors(d, shown)
	iSB.UpdateTrackTextures(d)
	iSB.UpdateThumbSizeAndPosition(d)
end
function ScrollBar:Step(delta, allowAnimation)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	assert(type(delta) == "number" and (allowAnimation == nil or type(allowAnimation) == "boolean"), 'Syntax: ScrollBar:Step(delta[, allowAnimation])')
	if d.interactionState ~= "THUMB_DRAG" then
		iSB.Step(d, delta, false, allowAnimation)
	end
end
function ScrollBar:IsValueAtRest()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.animTarget == nil and d.interactionState ~= "THUMB_DRAG"
end
function ScrollBar:IsEnabled()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.enabled
end
function ScrollBar:SetEnabled(enabled)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	enabled = not not enabled
	if d.enabled ~= enabled then
		d.enabled = enabled
		iSB.SetInteractionState(d, "NONE")
	end
end
function ScrollBar:Enable()
	return ScrollBar.SetEnabled(self, true)
end
function ScrollBar:Disable()
	return ScrollBar.SetEnabled(self, false)
end
function ScrollBar:GetStyle()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.userStyle, d.style
end
function ScrollBar:SetStyle(style)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	assert(type(style) == "string", 'Syntax: ScrollBar:SetStyle("style")')
	iSB.ApplyStyle(d, style)
end
function ScrollBar:SetCoverTarget(widget, insetLeft, insetRight, insetTop, insetBottom)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	assert(widget == nil or
	       type(widget) == "table" and widget[0] and type(widget.IsObjectType) == "function" and widget:IsObjectType("Frame"),
	      'Syntax: ScrollBar:SetCoverTarget(widget[, insetLeft, insetRight, insetTop, insetBottom])')
	assert(insetLeft == nil and insetRight == nil and insetTop == nil and insetBottom == nil or
	       type(insetLeft) == "number" and type(insetRight) == "number" and type(insetTop) == "number" and type(insetBottom) == "number",
	       'Invalid insets')
	d.coverTarget, d.coverIL, d.coverIR, d.coverIT, d.coverIB = widget, insetLeft or 0, insetRight or 0, insetTop or 0, insetBottom or 0
	iSB.UpdateCover(d)
end
function ScrollBar:GetCoverTarget()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	local t = d.coverTarget
	if t then
		return t, d.coverIL, d.coverIR, d.coverIT, d.coverIB
	end
end
function ScrollBar:SetWheelScrollTarget(widget, insetLeft, insetRight, insetTop, insetBottom)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	assert(widget == nil or
	       type(widget) == "table" and widget[0] and type(widget.IsObjectType) == "function" and widget:IsObjectType("Frame"),
	      'Syntax: ScrollBar:SetWheelScrollTarget(widget[, insetLeft, insetRight, insetTop, insetBottom])')
	assert(insetLeft == nil and insetRight == nil and insetTop == nil and insetBottom == nil or
	       type(insetLeft) == "number" and type(insetRight) == "number" and type(insetTop) == "number" and type(insetBottom) == "number",
	       'Invalid insets')
	d.wheelTarget, d.wheelIL, d.wheelIR, d.wheelIT, d.wheelIB = widget, insetLeft or 0, insetRight or 0, insetTop or 0, insetBottom or 0
	iSB.UpdateWheelCapture(d)
end
function ScrollBar:GetWheelScrollTarget()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	if d.wheelTarget then
		return d.wheelTarget, d.wheelIL, d.wheelIR, d.wheelIT, d.wheelIB
	end
end
function ScrollBar:SetAnimationMaxSteps(limit)
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	assert(limit == nil or type(limit) == "number", 'Syntax: ScrollBar:SetAnimationMaxSteps(limit|nil)')
	d.maxAnimSteps = limit or math.huge
end
function ScrollBar:GetAnimationMaxSteps()
	local d = assert(getWidgetData(self, ScrollBarData), "Invalid object type")
	return d.maxAnimSteps
end

local confTexture, confTextureS do
	local p0, p1, p2
	local function p(k)
		local s = p0 and p0[k] ~= nil and p0 or
		          p1 and p1[k] ~= nil and p1 or
		          p2 and p2[k] ~= nil and p2
		return (s or nil) and s[k]
	end
	local function readpack(t, ...)
		if t then
			return unpack(t)
		end
		return ...
	end
	function confTextureS(tex, sz, ...) -- (tex, sz, p0, p1, p2)
		p0, p1, p2 = ...
		local at, av, w, h, blend, desat, tc, vc = p(1), p(2), p("w"), p("h"), p("blend"), p("desat"), p("tc"), p("vc")
		local asize, hcB, hcT, cutB, cutT = at == "a" and p("asize"), p("hcB"), p("hcT"), 0, 0
		if at == "a" then
			tex:SetAtlas(av, not not asize)
		elseif at == "t" then
			tex:SetTexture(av)
		else
			av = type(av) == "number" and av >= 0 and av < 2^32 and av or 0
			local a, r, g, b = av/256^3 % 256, av/256^2 % 256, av/256^1 % 256, av % 256
			a, r, g, b = (a - a % 1)/255, (r - r % 1)/255, (g - g % 1)/255, (b - b % 1)/255
			tex:SetColorTexture(r, g, b, a)
		end
		if sz and hcB and sz < hcB then
			local cut = 1-sz/hcB
			h, cutB, cutT = h - hcB + sz, hcT and 0 or cut, hcT and cut or 0
		end
		if not asize then
			tex:SetSize(w or 0, h or 0)
		end
		tex:SetBlendMode(blend or "BLEND")
		tex:SetDesaturated(desat or false)
		tex:SetTexCoord(readpack(tc, 0,1, cutB,1-cutT))
		tex:SetVertexColor(readpack(vc, 1,1,1,1))
	end
	function confTexture(tex, ...)
		return confTextureS(tex, nil, ...)
	end
end
local function anchorTexTrio(t, useAbsoluteOffsets, ofsStart, ofsEnd, xShift, yShift)
	local oy, ox, a,b,c = yShift or 0, xShift or 0, t[1], t[2], t[3]
	a:SetPoint("TOP", ox, oy)
	c:SetPoint("BOTTOM", ox, oy)
	b:ClearAllPoints()
	if useAbsoluteOffsets then
		b:SetPoint("TOP", ox, oy - (ofsStart or 0))
		b:SetPoint("BOTTOM", ox, oy + (ofsEnd or 0))
	else
		b:SetPoint("TOPLEFT", a, "BOTTOMLEFT", 0, ofsStart or 0)
		b:SetPoint("BOTTOMRIGHT", c, "TOPRIGHT", 0, -(ofsEnd or 0))
	end
end
local function createTexTrio(parent, layer)
	return XU:Create("ObjectGroup",
		parent:CreateTexture(nil, layer, nil, 0),
		parent:CreateTexture(nil, layer, nil, -1),
		parent:CreateTexture(nil, layer, nil, 0)
	)
end

function iSB.NotifyValueChanged(d, isInternalChange, onlyOnRestStart)
	local isAtRest = d.animTarget == nil and d.interactionState ~= "THUMB_DRAG"
	local wasNotAtRest = onlyOnRestStart and d.lastValueChangeNotAtRest
	d.lastValueChangeNotAtRest = not isAtRest
	if not onlyOnRestStart or (wasNotAtRest and isAtRest) then
		CallObjectScript(d.self, "OnValueChanged", d.val, isInternalChange)
	end
end
function iSB.SetInteractionState(d, state)
	local val, enabled = d.val, d.enabled
	d.interactionState = state
	d.ThumbTexN:SetShown(state ~= "THUMB_DRAG")
	d.ThumbTexP:SetShown(state == "THUMB_DRAG")
	d.Thumb:EnableMouseMotion(enabled and state ~= "THUMB_DRAG")
	if d.mouseDown and state ~= "THUMB_DRAG" and state ~= "TRACK_HELD" then
		d.mouseDown, d.mouseDownX, d.mouseDownY, d.mouseDownS, d.mouseDownV, d.mouseDownOnThumb = nil
		d.Track:SetScript("OnUpdate", state == "ANIMATING_VALUE" and iSB.OnTrackUpdate or nil)
	end
	if d.stepperHeld == d.StepUp and state ~= "STEP_UP_HELD" or
	   d.stepperHeld == d.StepDown and state ~= "STEP_DOWN_HELD" then
		d.stepperHeldTime, d.stepperHeld = nil
	end
	d.StepUpH:SetShown(state ~= "STEP_UP_HELD")
	d.StepDownH:SetShown(state ~= "STEP_DOWN_HELD")
	d.StepUp:SetEnabled(enabled and val > d.min)
	d.StepDown:SetEnabled(enabled and val < d.max)
	if state ~= "ANIMATING_VALUE" and state ~= "STEP_UP_HELD" and state ~= "STEP_DOWN_HELD" and state ~= "TRACK_HELD" then
		d.animStart, d.animTarget, d.animEnd, d.animDur = nil
	end
	iSB.UpdateCover(d)
	iSB.NotifyValueChanged(d, true, true)
end
function iSB.SetValue(d, candValue, isInternalChange, visualUpdate, allowInteraction)
	local vlo, vhi, enabled = d.min, d.max, d.enabled
	local ov, nv = d.val, candValue < vlo and vlo or candValue > vhi and vhi or candValue
	d.StepUp:SetEnabled(enabled and nv > vlo)
	d.StepDown:SetEnabled(enabled and nv < vhi)
	d.val = nv
	if visualUpdate then
		iSB.UpdateThumbPosition(d)
	end
	if nv ~= ov then
		if visualUpdate and not allowInteraction then
			iSB.SetInteractionState(d, "NONE")
		end
		iSB.NotifyValueChanged(d, isInternalChange)
		return true
	end
end
function iSB.UpdateThumbPosition(d)
	local om = d.ThumbOffsetMul
	if not om then
		return iSB.UpdateThumbSizeAndPosition(d)
	end
	d.Thumb:SetPoint("TOP", 0, (d.val - d.min)*om)
end
function iSB.UpdateThumbSizeAndPosition(d)
	local sty, vrange, urange = STYLES[d.style], d.max - d.min, d.Track:GetHeight()
	d.Thumb:SetShown(vrange > 0)
	if vrange <= 0 then return end
	local tsz = math.max(sty.thumbMinSize, d.win / (vrange + d.win) * urange)
	local om = (tsz - urange) / vrange
	if d.ThumbSize == tsz and d.ThumbOffsetMul == om then return end
	d.ThumbSize, d.ThumbOffsetMul = tsz, om
	d.Thumb:SetHeight(tsz)
	iSB.UpdateThumbTextures(d, tsz)
	iSB.UpdateThumbPosition(d)
end
function iSB.PerformTrackPageStep(d, isFirstStep)
	local thumb, _mouseX, mouseY = d.Thumb, GetCursorPosition()
	local dsign = mouseY/thumb:GetEffectiveScale() >= thumb:GetTop() and -1 or 1
	if iSB.IsCursorOverThumb(d) then
		d.mouseDownS, d.mouseDown = nil -- Stop tracking, as MinimalScrollBar does
	elseif isFirstStep or dsign == d.mouseDownS then
		d.mouseDownS = dsign
		return iSB.Step(d, d.stepsPerPage*dsign, true)
	end
end
function iSB:OnTrackUpdate()
	local d, now = getWidgetData(self, ScrollBarData), GetTime()
	if not d then return end
	local atv, md, state = d.animTarget, d.mouseDown, d.interactionState
	if atv then
		local sv, et, ad, p = d.animStart, d.animEnd, d.animDur, nil
		if not (sv and atv and et and ad) then
		elseif et <= now then
			iSB.SetValue(d, atv, true, true, true)
			iSB.UpdateCover(d)
		else
			p = 1-(et-now)/ad
			p = p*p*(3-2*p)
			iSB.SetValue(d, sv + (atv-sv)*p, true, true, true)
		end
		if p == nil then
			d.animStart, d.animTarget, d.animEnd, d.animDur = nil
			iSB.UpdateCover(d)
			iSB.NotifyValueChanged(d, true, true)
		end
	elseif not md then
		if state ~= "STEP_UP_HELD" and state ~= "STEP_DOWN_HELD" and state ~= "NONE" then
			iSB.SetInteractionState(d, "NONE")
		end
		return self:SetScript("OnUpdate", nil)
	end
	if not (md and d.ThumbOffsetMul) then return end
	local doNothing = d.mouseDown + HOLD_ACTION_DELAY > now
	if doNothing and d.mouseDownOnThumb then
		local _mx, my = GetCursorPosition()
		doNothing = (my-d.mouseDownY)^2 < 5
	end
	if doNothing then
	elseif d.mouseDownOnThumb then
		local ts, _mx, my = self:GetEffectiveScale(), GetCursorPosition()
		local dm = (d.mouseDownY-my)/ts
		local nv = dm^2 > 0.5 and d.mouseDownV-dm/d.ThumbOffsetMul or d.mouseDownV
		iSB.SetValue(d, nv, true, true, true)
	elseif d.mouseDownS ~= 0 and iSB.PerformTrackPageStep(d, false) then
		d.mouseDown = now + PAGE_DELAY - HOLD_ACTION_DELAY
	end
end
function iSB:OnTrackMouseDown(button)
	local d = button == "LeftButton" and getWidgetData(self, ScrollBarData)
	if not (d and d.enabled and d.min < d.max) then return end
	d.mouseDown, d.mouseDownOnThumb = GetTime(), iSB.IsCursorOverThumb(d)
	d.mouseDownV, d.mouseDownX, d.mouseDownY = d.val, GetCursorPosition()
	iSB.SetInteractionState(d, d.mouseDownOnThumb and "THUMB_DRAG" or "TRACK_HELD")
	d.Track:SetScript("OnUpdate", iSB.OnTrackUpdate)
	if d.mouseDownOnThumb then
		PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	else
		iSB.PerformTrackPageStep(d, true)
	end
end
function iSB:OnTrackMouseUp(button)
	local d = button == "LeftButton" and getWidgetData(self, ScrollBarData)
	if d and d.mouseDown then
		iSB.SetInteractionState(d, d.interactionState == "TRACK_HELD" and d.animTarget and "ANIMATING_VALUE" or "NONE")
	end
end
function iSB:OnMouseWheel(delta)
	local d = getWidgetData(self, ScrollBarData)
	if d.enabled and d.interactionState ~= "THUMB_DRAG" then
		iSB.Step(d, -delta*(d.stepsPerWheel or d.stepsPerPage), true)
	end
end
function iSB:OnShow()
	local d = getWidgetData(self, ScrollBarData)
	iSB.SetInteractionState(d, "NONE")
	d.ThumbSize = nil
	iSB.UpdateThumbSizeAndPosition(d)
	iSB.UpdateCover(d)
	iSB.UpdateWheelCapture(d)
end
function iSB.Step(d, steps, isInternalChange, allowAnimation)
	local sign, dstep = steps < 0 and -1 or steps > 0 and 1 or 0, d.step
	allowAnimation = allowAnimation == true or (allowAnimation == nil and d.maxAnimSteps >= sign*steps)
	local delta, at = steps * (dstep > 0 and dstep or 1), allowAnimation and d.animTarget
	local sval = at and (delta == 0 or ((at - d.val) < 0) == (delta < 0)) and at or d.val
	local nv = iSB.AdjustValueToStep(d, sval + delta, sign)
	if allowAnimation then
		return iSB.SetValueAnimated(d, nv, isInternalChange, ANIMATION_TARGET_DURATION)
	end
	return iSB.SetValue(d, nv, isInternalChange, true, true)
end
function iSB.AdjustValueToStep(d, candValue, dsign)
	local dstep, lo, hi = d.step, d.min, d.max
	local fv = dstep > 0 and candValue % dstep or 0
	dsign = dsign == 0 and (fv > 0.5 and 1 or -1) or dsign
	if fv > 0 then
		candValue = candValue - fv + (fv+fv > dstep and dstep or 0)
	end
	return candValue < lo and lo or candValue > hi and hi or candValue
end
function iSB.SetValueAnimated(d, nv, isInternalChange, targetDuration)
	local at = d.animTarget
	if nv == d.val then
		d.animStart, d.animDur, d.animTarget, d.animEnd = nil
		iSB.UpdateCover(d)
		return
	elseif at == nv then
		return true
	elseif GetFramerate() < MIN_ANIMATION_FRAMERATE and not at then
		return iSB.SetValue(d, nv, isInternalChange, true, true)
	end
	local et, ad, sv, now = d.animEnd, d.animDur, d.val, GetTime()
	local r0, r1 = et and (at-d.animStart), nv - sv
	d.animTarget, d.animEnd = nv, now + targetDuration - 1/60
	d.Track:SetScript("OnUpdate", iSB.OnTrackUpdate)
	if et == nil or et <= now or (r0 < 0) ~= (r1 < 0) or r1 == 0 then
		d.animStart, d.animDur = at or sv, targetDuration
		iSB.OnTrackUpdate(d.Track)
	else
		r0, r1 = r0 < 0 and -r0 or r0, r1 < 0 and -r1 or r1
		local p = 1-(et-now)/ad
		local s = r1*(36/144*r1-p*(1-p)*r0)
		local x1 = s > 0 and 0.5 - s^0.5/r1 or 0.25
		local p1 = x1*x1*(3-x1-x1)
		local d1 = p1*(nv-sv)/(1-p1)
		d.animStart, d.animDur = sv-d1, targetDuration/(1-x1)
	end
	iSB.UpdateCover(d)
	return true
end
function iSB:OnStepButtonDown(button)
	local d = button == "LeftButton" and getWidgetData(self, ScrollBarData)
	local isUpStep = d and self == d.StepUp
	if not d or (d.val == (isUpStep and d.min or d.max)) or not d.enabled then return end
	iSB.Step(d, isUpStep and -1 or 1, true, true)
	d.stepperHeldTime, d.stepperHeld = GetTime() + STEPPER_REPEAT_DELAY, self
	iSB.SetInteractionState(d, isUpStep and "STEP_UP_HELD" or "STEP_DOWN_HELD")
	self:SetScript("OnUpdate", iSB.OnStepButtonHeld)
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end
function iSB:OnStepButtonHeld()
	local d = getWidgetData(self:GetParent(), ScrollBarData)
	if not d then
	elseif d.stepperHeld ~= self then
		self:SetScript("OnUpdate", nil)
	elseif d.stepperHeldTime < GetTime() then
		iSB.OnStepButtonDown(self, "LeftButton")
	end
end
function iSB:OnStepButtonUp(button)
	local d = button == "LeftButton" and getWidgetData(self, ScrollBarData)
	if not d then return end
	self:SetScript("OnUpdate", nil)
	if d.stepperHeld == self then
		d.stepperHeldTime, d.stepperHeld = nil
	end
	if d.interactionState == (self == d.StepUp and "STEP_UP_HELD" or "STEP_DOWN_HELD") then
		iSB.SetInteractionState(d, d.animTarget and "ANIMATING_VALUE" or "NONE")
	end
end
function iSB.IsCursorOverThumb(d)
	local _l, _r, t, b = d.Thumb:GetHitRectInsets()
	return d.Thumb:IsMouseOver(-t, b, -9000, 9000)
end
function iSB.UpdateTrackTextures(d)
	local bg, sty = d.TrackBG, STYLES[d.style]
	local isBare = not d.StepUp:IsShown()
	confTexture(bg[1], isBare and sty.trackTopBare, sty.trackTop)
	confTexture(bg[2], sty.trackMid)
	confTexture(bg[3], isBare and sty.trackBotBare, sty.trackBot)
end
function iSB.UpdateThumbTextures(d, tsz)
	local sty, n, h, p, m = STYLES[d.style], d.ThumbTexN, d.ThumbTexH, d.ThumbTexP, d.ThumbTexM
	local stt, sth, mct, sbot = sty.smallThumbThreshold
	tsz = tsz or d.Thumb:GetHeight()
	local isSmall = stt and tsz < stt
	sth, sbot = isSmall and sty.thumbS or sty.thumb, isSmall and sty.thumbBotS or sty.thumbBot
	mct = isSmall and (sty.thumbMidS or sty.thumbMid).tch or sty.thumbMid.tch
	confTextureS(n[1], tsz, sty.thumbTop, sth)
	confTexture(n[2], sty.thumbMid, sth)
	confTextureS(n[3], tsz, sbot, sth)
	confTextureS(h[1], tsz, sty.thumbTopH, sty.thumbTop, sth)
	confTexture(h[2], sty.thumbMidH, sty.thumbMid, sth)
	confTextureS(h[3], tsz, isSmall and sty.thumbBotHS or sty.thumbBotH, sbot, sth)
	confTextureS(p[1], tsz, sty.thumbTopP, sty.thumbTop, sth)
	confTexture(p[2], sty.thumbMidP, sty.thumbMid, sth)
	confTextureS(p[3], tsz, isSmall and sty.thumbBotPS or sty.thumbBotP, sbot, sth)
	m:SetTexCoord(0,1, 0,mct and tsz < mct and tsz/mct or 1)
	local isAbs, st, sb, ox, oy = sth.midOfsAbsolute, sth.midOfsT, sth.midOfsB, sth.ofsX, sth.ofsY
	anchorTexTrio(d.ThumbTexN, isAbs, st, sb, ox, oy)
	anchorTexTrio(d.ThumbTexH, isAbs, st, sb, ox, oy)
	anchorTexTrio(d.ThumbTexP, isAbs, st, sb, ox, oy)
end
function iSB:UpdateStepButtonTextures(variant, sty)
	local bv = variant == "TOP" and "stepUp" or variant == "BOTTOM" and "stepDown" or error('invalid variant')
	local ns, bs = sty[bv], sty.step
	confTexture(self:GetNormalTexture(), ns, bs)
	confTexture(self:GetHighlightTexture(), sty[bv .. "H"], ns, bs)
	confTexture(self:GetPushedTexture(), sty[bv .. "P"], ns, bs)
	confTexture(self:GetDisabledTexture(), sty[bv .. "D"], ns, bs)
end
function iSB.ApplyStyle(d, style)
	local sty = d.style ~= style and STYLES[style]
	d.userStyle, d.style = style, sty and style or d.style
	if not sty then return end
	local stb, sth = sty.trackBack, sty.thumb
	d.StepUp:SetPoint("TOP", 0, -(sty.stepperMarginY or 0))
	d.StepDown:SetPoint("BOTTOM", 0, sty.stepperMarginY or 0)
	iSB.UpdateStepButtonTextures(d.StepUp, "TOP", sty)
	iSB.UpdateStepButtonTextures(d.StepDown, "BOTTOM", sty)
	d.StepUp:GetPushedTexture():SetPoint("CENTER", 0, sty.stepperPushOfsY or 0)
	d.StepDown:GetPushedTexture():SetPoint("CENTER", 0, -(sty.stepperPushOfsY or 0))
	d.Track:SetWidth(sty.trackWidth)
	iSB.ApplyTrackAnchors(d, nil)
	d.Thumb:SetWidth(sth.w)
	local etw = (d.Track:GetWidth()-d.Thumb:GetWidth())/2
	d.Thumb:SetHitRectInsets(-etw, -etw, 0, 0)
	d.TrackBG[4]:SetShown(not not stb)
	if stb then
		confTexture(d.TrackBG[4], stb)
		d.TrackBG[4]:SetPoint("TOPLEFT", d.TrackBG[1], stb.insetL or stb.insetH or 0, -(stb.insetT or stb.insetV or 0))
		d.TrackBG[4]:SetPoint("BOTTOMRIGHT", d.TrackBG[3], -(stb.insetR or stb.insetH or 0), stb.insetB or stb.insetV or 0)
	end
	iSB.UpdateTrackTextures(d)
	iSB.UpdateThumbTextures(d)
	iSB.UpdateThumbSizeAndPosition(d)
end
function iSB.ApplyTrackAnchors(d, showSteppers)
	local sty, bg = STYLES[d.style], d.TrackBG
	showSteppers = showSteppers == nil and d.StepUp:IsShown() or showSteppers
	d.Track:SetPoint("TOP", 0, showSteppers and -sty.stepperReserve or -1)
	d.Track:SetPoint("BOTTOM", 0, showSteppers and sty.stepperReserve or 1)
	anchorTexTrio(bg, false, nil, nil, nil, 1)
	if showSteppers and sty.stepperTrack then
		bg[1]:SetPoint("TOP", d.StepUp, 0, 1)
		bg[3]:SetPoint("BOTTOM", d.StepDown, 0, -1)
	end
end
function iSB.UpdateCover(d)
	local cov, state, ct = d.Cover, d.interactionState
	ct = (d.animTarget or state == "THUMB_DRAG" or state == "TRACK_HELD") and d.coverTarget
	if ct and not cov then
		cov = CreateFrame("Frame", nil, d.self)
		cov:EnableMouseMotion(true)
		d.Cover = cov
	elseif not ct then
		return cov and cov:Hide()
	end
	cov:ClearAllPoints()
	cov:SetPoint("TOPLEFT", ct, d.coverIL, -d.coverIT)
	cov:SetPoint("BOTTOMRIGHT", ct, -d.coverIR, d.coverIB)
	cov:SetFrameLevel(math.min(9900, ct:GetFrameLevel()+1000))
	cov:Show()
end
function iSB.UpdateWheelCapture(d)
	local ct, w = d.wheelTarget, d.WheelCapture
	if ct and not w then
		w = CreateFrame("Frame", nil, d.self)
		w:SetScript("OnMouseWheel", iSB.OnMouseWheel)
		setWidgetData(w, ScrollBarData, d)
		d.WheelCapture = w
	elseif not ct then
		return w and w:Hide()
	end
	w:ClearAllPoints()
	w:SetPoint("TOPLEFT", ct, d.wheelIL, -d.wheelIT)
	w:SetPoint("BOTTOMRIGHT", ct, -d.wheelIR, d.wheelIB)
	w:SetFrameLevel(math.min(d.self:GetFrameLevel(), ct:GetFrameLevel()))
	w:Show()
end

local function createStepButton(parent, d)
	local t = CreateFrame("Button", nil, parent)
	t:SetSize(16, 16)
	t:SetScript("OnMouseDown", iSB.OnStepButtonDown)
	t:SetScript("OnMouseUp", iSB.OnStepButtonUp)
	setWidgetData(t, ScrollBarData, d)
	t:SetNormalTexture('')
	t:SetHighlightTexture('')
	t:SetPushedTexture('')
	t:SetDisabledTexture('')
	local a,b,c,d = t:GetNormalTexture(), t:GetHighlightTexture(), t:GetPushedTexture(), t:GetDisabledTexture()
	for i=1,4 do
		a:ClearAllPoints()
		a:SetPoint("CENTER")
		a:SetShown(i < 3)
		a,b,c,d=b,c,d,a
	end
	return t, b
end
local function CreateScrollBar(name, parent, outerTemplate, id)
	local f, d, t = CreateFrame("Frame", name, parent, outerTemplate, id)
	d = newWidgetData(f, ScrollBarData, scrollBarProps)
	f:SetWidth(20)
	f:SetScript("OnMouseWheel", iSB.OnMouseWheel)
	t = CreateFrame("Frame", nil, f)
	t:SetScript("OnMouseDown", iSB.OnTrackMouseDown)
	t:SetScript("OnMouseUp", iSB.OnTrackMouseUp)
	t:SetScript("OnShow", iSB.OnShow)
	t:SetScript("OnSizeChanged", iSB.OnShow)
	setWidgetData(t, ScrollBarData, d)
	t, d.Track = CreateFrame("Frame", nil, t), t
	t:EnableMouseMotion(true)
	d.Thumb = t
	d.ThumbTexN = createTexTrio(t, "BACKGROUND")
	d.ThumbTexH = createTexTrio(t, "HIGHLIGHT")
	d.ThumbTexP = createTexTrio(t, "BACKGROUND")
	d.ThumbTexM = XU:Create("ObjectGroup", d.ThumbTexN[2], d.ThumbTexH[2], d.ThumbTexP[2])
	d.ThumbTexP:SetShown(false)
	d.StepUp, d.StepUpH = createStepButton(f, d)
	d.StepDown, d.StepDownH = createStepButton(f, d)
	d.TrackBG = createTexTrio(d.Track, "BACKGROUND")
	d.TrackBG[4] = d.Track:CreateTexture(nil, "BACKGROUND", nil, -2)
	iSB.ApplyStyle(d, DEFAULT_STYLE)
	return f
end

XU:RegisterFactory("ScrollBar", CreateScrollBar)