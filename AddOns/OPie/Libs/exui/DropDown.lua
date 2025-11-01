local _, T = ...
local XU = T.exUI
local assert, getWidgetData, newWidgetData, _setWidgetData, AddObjectMethods, CallObjectScript = XU:GetImpl()

local DropDown, DropDownData, internal = {}, {}, {}
local DropDownProps = {
	api=DropDown,
	scripts={"OnHide"},
	pulseAnim=nil,
}
AddObjectMethods({"DropDown"}, DropDownProps)

function DropDown:HandlesGlobalMouseEvent(button)
	return button == "LeftButton" and self:IsEnabled()
end
function DropDown:Pulse()
	local d = assert(getWidgetData(self, DropDownData), 'invalid object type')
	if not d.pulseAnim then
		local tex = d.bg
		local atl, l, sl = tex:GetAtlas(), tex:GetDrawLayer()
		local r = tex:GetParent():CreateTexture(nil, l, nil, sl+1)
		r:SetAllPoints(tex)
		r[atl and "SetAtlas" or "SetTexture"](r, atl or tex:GetTexture())
		r:SetTexCoord(tex:GetTexCoord())
		r:SetVertexColor(0, 0.5, 0.75, 0)
		r:SetBlendMode("ADD")
		r:SetTextureSliceMargins(tex:GetTextureSliceMargins())
		local ag = d.self:CreateAnimationGroup()
		ag:SetLooping("BOUNCE")
		ag:SetScript("OnLoop", internal.OnPulseLoop)
		local aa = ag:CreateAnimation("Alpha")
		aa:SetTarget(r)
		aa:SetDuration(1/3)
		aa:SetFromAlpha(1)
		aa:SetToAlpha(0)
		aa:SetSmoothing("IN_OUT")
		d.pulseAnim = ag
	end
	d.pulseCyclesLeft = 6
	d.pulseAnim:Restart(true)
end

function internal.OnPulseLoop(self, ls)
	local d = ls == "FORWARD" and getWidgetData(self:GetParent(), DropDownData)
	if not d then return end
	local cl = (d.pulseCyclesLeft or 1) - 1
	d.pulseCyclesLeft = cl > 0 and cl or nil
	if cl <= 0 then
		d.pulseAnim:Finish()
	end
end
function internal.OnDropArrowClick(self)
	ToggleDropDownMenu(nil, nil, self, self, 8, 8)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end
function internal.OnDropHide(self, ...)
	local d = getWidgetData(self, DropDownData)
	if UIDROPDOWNMENU_OPEN_MENU == self and DropDownList1:IsVisible() then
		securecall(CloseDropDownMenus)
	end
	if d.pulseAnim and d.pulseAnim:IsPlaying() then
		d.pulseAnim:Stop()
	end
	CallObjectScript(d.self, "OnHide", ...)
end

local function prepArrowTexture(p, m, f)
	p["Set" .. m](p, f)
	local tex = p["Get" .. m](p)
	tex:ClearAllPoints()
	tex:SetSize(24, 24)
	tex:SetPoint("RIGHT", -16, 3)
	return tex
end
local function nop() end
local nopTex = {SetWidth=nop, Hide=nop}
local HAS_CLASSIC_DROPDOWN_ATLAS = (C_Texture.GetAtlasElementID("common-dropdown-classic-textholder") or 0) ~= 0
local function CreateDropDown(name, parent, outerTemplate, id)
	local f, d, t = CreateFrame("Button", name, parent, outerTemplate, id)
	f:SetSize(120, 32)
	f:SetHitRectInsets(20,18,4,8)
	f:SetText(" ")
	f:SetNormalFontObject(GameFontHighlightSmall)
	f:SetDisabledFontObject(GameFontDisableSmall)
	f:SetPushedTextOffset(0,0)
	f:SetScript("OnHide", internal.OnDropHide)
	prepArrowTexture(f, "NormalTexture", [[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
	prepArrowTexture(f, "PushedTexture", [[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
	prepArrowTexture(f, "DisabledTexture", [[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]])
	prepArrowTexture(f, "HighlightTexture", [[Interface\Buttons\UI-Common-MouseHilight]]):SetBlendMode("ADD")
	f:SetScript("OnClick", internal.OnDropArrowClick)
	t = f:CreateTexture(nil, "BACKGROUND")
	if HAS_CLASSIC_DROPDOWN_ATLAS then
		t:SetAtlas("common-dropdown-classic-textholder")
		t:SetTextureSliceMargins(26, 26, 26, 26)
		t:SetPoint("TOPLEFT", 9, 6)
		t:SetPoint("BOTTOMRIGHT", -9, -2.5)
	else
		t:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
		t:SetTextureSliceMargins(24, 16, 24, 16)
		t:SetPoint("TOPLEFT", 0, 17)
		t:SetPoint("BOTTOMRIGHT", 0, -15)
	end
	d = newWidgetData(f, DropDownData, DropDownProps)
	t, d.bg = f:GetFontString(), t
	t:ClearAllPoints()
	t:SetPoint("RIGHT", -43, 3)
	t:SetPoint("LEFT", 26, 3)
	t:SetJustifyH("RIGHT")
	t:SetWordWrap(false)
	f.Button, f.Text, f.Middle, f.Left, f.Right = f, t, nopTex, nopTex, nopTex
	return f
end

XU:RegisterFactory("DropDown", CreateDropDown)