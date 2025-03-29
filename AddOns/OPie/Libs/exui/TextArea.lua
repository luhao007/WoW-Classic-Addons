local _, T = ...
local XU, type = T.exUI, type
local assert, getWidgetData, newWidgetData, setWidgetData, AddObjectMethods, CallObjectScript = XU:GetImpl()

local TextArea, TextAreaData, int = {}, {}, {}
local TextAreaProps = {
	api=TextArea,
	scripts={"OnCursorChanged"},
	self2methods={SetHyperlinksEnabled=1, GetHyperlinksEnabled=1},
	self2scripts={"OnKeyDown", "OnKeyUp", "OnChar", "OnHyperlinkClick", "OnHyperlinkEnter", "OnHyperlinkLeave"},
}
AddObjectMethods({"TextArea", "EditBox"}, TextAreaProps)

local tooltipBackdrop = {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=4,right=4,bottom=4,top=4}, bgColor=0xb2000000, edgeColor=0xb2b2b2}

function TextArea:GetHighlightText()
	local editBox = assert(getWidgetData(self, TextAreaData), 'invalid object type').editBox
	local text, curPos = editBox:GetText(), editBox:GetCursorPosition()
	editBox:Insert("")
	local text2, selStart = editBox:GetText(), editBox:GetCursorPosition()
	local selEnd = selStart + #text - #text2
	if text ~= text2 then
		editBox:SetText(text)
		editBox:SetCursorPosition(curPos)
		editBox:HighlightText(selStart, selEnd)
	end
	return text:sub(selStart+1, selEnd), selStart
end
function TextArea:SetHighlightText(newText, preserveCaret)
	assert(type(newText) == 'string', 'Syntax: TextArea:SetHighlightText("text"[, preserveCaret])')
	local d = assert(getWidgetData(self, TextAreaData), 'invalid object type')
	local editBox, op, op2 = d.editBox
	d.holdScroll, op = true, preserveCaret and editBox:GetCursorPosition()
	editBox:Insert("")
	op2 = editBox:GetCursorPosition()
	editBox:Insert(newText)
	d.holdScroll = nil
	if op == op2 then
		editBox:SetCursorPosition(op2)
	end
	editBox:HighlightText(op2, op2+#newText)
end
function TextArea:SetStickyFocus(sticky)
	assert(sticky == nil or type(sticky) == "function" or type(sticky) == "boolean", 'Syntax: TextArea:SetStickyFocus(sticky)')
	local d = assert(getWidgetData(self, TextAreaData), 'invalid object type')
	d.editBox.HasStickyFocus = sticky == true and int.alwaysHasStickyFocus or sticky or nil
end
function TextArea:SetStyle(style)
	assert(type(style) == "string", 'Syntax: TextArea:SetStyle("style")')
	local d = assert(getWidgetData(self, TextAreaData), 'invalid object type')
	local px, py = 0, 0
	if style == "tooltip" then
		if not d.backdrop then
			d.backdrop = XU:Create("Backdrop", d.self)
		end
		d.backdrop:SetBackdrop(tooltipBackdrop)
		px, py = 5, 5
	elseif d.backdrop then
		d.backdrop:SetBackdrop(nil)
	end
	d.clipArea:SetPoint("TOPLEFT", px, -py)
	d.scrollBar:SetPoint("TOPRIGHT", -px, -py)
	d.scrollBar:SetPoint("BOTTOMRIGHT", -px, py)
end

function int.alwaysHasStickyFocus()
	return true
end
function int:OnCursorChanged(...)
	local d = assert(getWidgetData(self, TextAreaData), 'invalid object type')
	if d.holdScroll then return end
	repeat
		local _x, y, _w, h = ...
		local sb, insT, insB = d.scrollBar, 2, 2
		local occH, occP, y = d.clipArea:GetHeight(), sb:GetValue(), -y
		if not self:HasFocus() then -- only move if focused
		elseif occP > y-insT then
			occP = y > insT and y-insT or 0 -- too far
		elseif occP < y+h-occH+insB+insT then
			occP = y+h-occH+insB+insT -- not far enough
		else
			break
		end
		local _, mx = sb:GetMinMaxValues()
		occP = (mx-occP)^2 < 1 and mx or math.floor(occP)
		sb:SetMinMaxValues(0, occP < mx and mx or occP)
		sb:SetWindowRange(occH)
		sb:SetValue(occP)
	until 1
	CallObjectScript(d.self, "OnCursorChanged", ...)
end
function int:OnClick()
	local eb = assert(getWidgetData(self, TextAreaData), 'invalid object type').editBox
	eb:SetCursorPosition(#eb:GetText())
	eb:SetFocus()
end
function int:OnScrollValueChanged(nv)
	local d = assert(getWidgetData(self, TextAreaData), 'invalid object type')
	d.editBox:SetPoint("TOPLEFT", 0, nv)
	d.editBox:SetPoint("TOPRIGHT", 0, nv)
end
function int:OnSizeChanged()
	local d = assert(getWidgetData(self, TextAreaData), 'invalid object type')
	if d.holdScroll then return end
	local sb, ch, th = d.scrollBar, d.clipArea:GetHeight(), d.editBox:GetHeight() + (d.editBox:GetText():sub(-1) == "\n" and 12+2/9 or 0)
	sb:SetMinMaxValues(0, th > ch and th-ch or 0)
	sb:SetWindowRange(ch)
	sb:SetStepsPerPage(math.min(5,math.ceil(ch/18)))
end
function int:OnShow()
	local d = assert(getWidgetData(self, TextAreaData), 'invalid object type')
	d.scrollBar:SetValue(0)
end

local function CreateTextArea(name, parent, outerTemplate, id)
	local area, d = CreateFrame("Frame", name, parent, outerTemplate, id)
	local sb = XU:Create("ScrollBar", nil, area)
	sb:SetPoint("TOPRIGHT")
	sb:SetPoint("BOTTOMRIGHT")
	sb:SetScript("OnValueChanged", int.OnScrollValueChanged)
	sb:SetWheelScrollTarget(area)
	sb:SetValueStep(12)
	local ec = CreateFrame("Frame", nil, area)
	ec:SetPoint("TOPLEFT")
	ec:SetPoint("BOTTOMRIGHT", sb, "BOTTOMLEFT")
	ec:SetClipsChildren(true)
	ec:SetScript("OnSizeChanged", int.OnSizeChanged)
	ec:EnableMouse(1)
	ec:SetScript("OnMouseDown", int.OnClick)
	local input = CreateFrame("EditBox", type(name) == "string" and name .. "EB" or nil, ec)
	input:SetPoint("TOPLEFT")
	input:SetPoint("TOPRIGHT")
	input:SetMultiLine(true)
	input:SetAutoFocus(false)
	input:SetSpacing(2)
	input:SetFontObject(GameFontHighlight)
	input:SetScript("OnCursorChanged", int.OnCursorChanged)
	input:SetScript("OnSizeChanged", int.OnSizeChanged)
	input:SetScript("OnShow", int.OnShow)
	d = newWidgetData(area, TextAreaData, TextAreaProps, input)
	d.clipArea, d.scrollBar, d.editBox = ec, sb, input
	setWidgetData(input, TextAreaData, d)
	setWidgetData(sb, TextAreaData, d)
	setWidgetData(ec, TextAreaData, d)
	return area
end

XU:RegisterFactory("TextArea", CreateTextArea)