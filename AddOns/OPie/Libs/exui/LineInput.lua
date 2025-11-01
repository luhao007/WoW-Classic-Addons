local _, T = ...
local XU, type = T.exUI, type
local assert, getWidgetData, newWidgetData, _setWidgetData, AddObjectMethods, CallObjectScript = XU:GetImpl()

local LineInput, LineInputData = {}, {}, {}
local LineInputProps = {
	api=LineInput,
	style='common',
	tipL=0, tipR=0, tipT=0, tipB = 0,
	scripts={"OnEditFocusGained", "OnEditFocusLost"},
}
AddObjectMethods({"LineInput"}, LineInputProps)

local function adjustPlaceholderVisibility(self)
	local d = assert(getWidgetData(self, LineInputData), 'invalid object type')
	local sup = d.proto.super
	d.phText:SetShown(not sup.HasFocus(self) and sup.GetText(self) == "")
end
function LineInput:SetStyle(style)
	local d = assert(getWidgetData(self, LineInputData), 'invalid object type')
	assert(style == nil or type(style) == 'string', 'Syntax: LineInput:SetStyle("style")')
	local common, l, r, m = style == "common", d.l, d.r, d.m
	m:SetPoint("LEFT", l, "RIGHT")
	m:SetPoint("RIGHT", r, "LEFT")
	if style == "search" then
		l:SetSize(8, 20)
		r:SetSize(8, 20)
		m:SetSize(10, 20)
		l:SetPoint("LEFT", -5, 0)
		r:SetPoint("RIGHT", 0)
		l:SetAtlas("common-search-border-left")
		r:SetAtlas("common-search-border-right")
		m:SetAtlas("common-search-border-middle")
	else
		l:SetSize(common and 8 or 32, common and 20 or 32)
		l:SetPoint("LEFT", common and -5 or -10, 0)
		l:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Left2")
		r:SetSize(common and 8 or 32, common and 20 or 32)
		r:SetPoint("RIGHT", common and 0 or 10, 0)
		r:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Right2")
		m:SetHeight(common and 20 or 32)
		m:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Mid2", "MIRROR")
	end
	if common then
		l:SetTexCoord(0,1/16, 0,5/8)
		r:SetTexCoord(15/16,1, 0,5/8)
		m:SetTexCoord(1/16,15/16, 0,5/8)
	else
		l:SetTexCoord(0,1, 0,1)
		r:SetTexCoord(0,1, 0,1)
		m:SetTexCoord(0,1, 0,1)
	end
	m:SetHorizTile(not common and style ~= "search")
	d.style = style
	LineInput.SetTextInsets(self, d.tipL, d.tipR, d.tipT, d.tipB)
end
function LineInput:SetTextInsets(left, right, top, bottom)
	local d = assert(getWidgetData(self, LineInputData), 'invalid object type')
	left, right, top, bottom = tonumber(left or 0), tonumber(right or 0), tonumber(top or 0), tonumber(bottom or 0)
	assert(type(left) == 'number' and type(right) == 'number' and type(top) == 'number' and type(bottom) == 'number', 'Syntax: LineInput:SetTextInsets(left, right, top, bottom)')
	d.tipL, d.tipR, d.tipT, d.tipB = left, right, top, bottom
	local common = d.style == 'common'
	d.proto.super.SetTextInsets(self, left + (common and 0 or 1), right, top, bottom)
end
function LineInput:GetTextInsets()
	local d = assert(getWidgetData(self, LineInputData), 'invalid object type')
	return d.tipL, d.tipR, d.tipT, d.tipB
end
function LineInput:SetText(text)
	local d = assert(getWidgetData(self, LineInputData), 'invalid object type')
	d.proto.super.SetText(d.self, text)
	d.text:SetText(text)
	adjustPlaceholderVisibility(self)
end
function LineInput:GetPlaceholderText()
	local d = assert(getWidgetData(self, LineInputData), 'invalid object type')
	return d.phText:GetText()
end
function LineInput:SetPlaceholderText(text)
	assert(type(text) == "string", 'Syntax: LineInput:SetPlaceholderText("text")')
	local d = assert(getWidgetData(self, LineInputData), 'invalid object type')
	d.phText:SetText(text)
end

local function findFontString(a, ...)
	if a and not a:IsObjectType("FontString") then
		return findFontString(...)
	end
	return a
end
local function onEditFocusGained(self, ...)
	adjustPlaceholderVisibility(self)
	return CallObjectScript(self, "OnEditFocusGained", ...)
end
local function onEditFocusLost(self, ...)
	adjustPlaceholderVisibility(self)
	self:HighlightText(0,0)
	return CallObjectScript(self, "OnEditFocusLost", ...)
end
local function CreateLineInput(name, parent, outerTemplate, id)
	local input, d, t = CreateFrame("EditBox", name, parent, outerTemplate, id)
	input:SetScript("OnEditFocusGained", onEditFocusGained)
	input:SetScript("OnEditFocusLost", onEditFocusLost)
	d = newWidgetData(input, LineInputData, LineInputProps)
	input:SetAutoFocus(nil)
	input:SetSize(150, 20)
	input:SetFontObject(ChatFontNormal)
	t, d.text = input:CreateFontString(nil, "OVERLAY"), findFontString(input:GetRegions())
	t:SetFontObject(GameFontDisableSmall)
	t:SetTextColor(0.35, 0.35, 0.35)
	t:SetPoint("LEFT", 2, 0)
	t:SetPoint("RIGHT", -2, 0)
	t:SetJustifyH("LEFT")
	t:SetMaxLines(1)
	d.phText = t
	input:SetScript("OnEscapePressed", input.ClearFocus)
	d.l, d.m, d.r = input:CreateTexture(nil, "BACKGROUND"), input:CreateTexture(nil, "BACKGROUND"), input:CreateTexture(nil, "BACKGROUND")
	LineInput.SetStyle(input, "common")
	return input
end

XU:RegisterFactory("LineInput", CreateLineInput)