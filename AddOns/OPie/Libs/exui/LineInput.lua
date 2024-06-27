local _, T = ...
local XU, type = T.exUI, type
local assert, getWidgetData, newWidgetData, _setWidgetData, AddObjectMethods, _CallObjectScript = XU:GetImpl()

local LineInput, LineInputData = {}, {}, {}
local LineInputProps = {
	api=LineInput,
}
AddObjectMethods({"LineInput"}, LineInputProps)

function LineInput:SetStyle(style)
	local d = assert(getWidgetData(self, LineInputData), 'invalid object type')
	assert(style == nil or type(style) == 'string', 'Syntax: LineInput:SetStyle("style")')
	local common, l, r, m = style == "common", d.l, d.r, d.m
	l:SetSize(common and 8 or 32, common and 20 or 32)
	l:SetPoint("LEFT", common and -5 or -10, 0)
	l:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Left2")
	r:SetSize(common and 8 or 32, common and 20 or 32)
	r:SetPoint("RIGHT", common and 0 or 10, 0)
	r:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Right2")
	m:SetHeight(common and 20 or 32)
	m:SetPoint("LEFT", l, "RIGHT")
	m:SetPoint("RIGHT", r, "LEFT")
	m:SetTexture(common and "Interface\\Common\\Common-Input-Border" or "Interface\\ChatFrame\\UI-ChatInputBorder-Mid2", "MIRROR")
	if common then
		l:SetTexCoord(0,1/16, 0,5/8)
		r:SetTexCoord(15/16,1, 0,5/8)
		m:SetTexCoord(1/16,15/16, 0,5/8)
	else
		l:SetTexCoord(0,1, 0,1)
		r:SetTexCoord(0,1, 0,1)
		m:SetTexCoord(0,1, 0,1)
	end
	m:SetHorizTile(not common)
	d.self:SetTextInsets(common and 0 or 1, 0, 0, 0)
end

local function CreateLineInput(name, parent, outerTemplate, id)
	local input, d = CreateFrame("EditBox", name, parent, outerTemplate, id)
	d = newWidgetData(input, LineInputData, LineInputProps)
	input:SetAutoFocus(nil)
	input:SetSize(150, 20)
	input:SetFontObject(ChatFontNormal)
	input:SetScript("OnEscapePressed", input.ClearFocus)
	d.l, d.m, d.r = input:CreateTexture(nil, "BACKGROUND"), input:CreateTexture(nil, "BACKGROUND"), input:CreateTexture(nil, "BACKGROUND")
	LineInput.SetStyle(input, "common")
	return input
end

XU:RegisterFactory("LineInput", CreateLineInput)