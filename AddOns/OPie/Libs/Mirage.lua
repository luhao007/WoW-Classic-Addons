local COMPAT, _, T = select(4, GetBuildInfo()), ...
if T.TenEnv then T.TenEnv() end
local FRAME_BUFFER_OK = COMPAT == 40400

local gx do
	local b = ([[Interface\AddOns\%s\gfx\]]):format((...))
	gx = {
		BorderLow = b .. "borderlo",
		BorderHigh = b .. "borderhi",
		OuterGlow = b .. "oglow",
		InnerGlow = b .. "iglow",
		Ribbon = b .. "ribbon",
		CooldownStar = [[Interface\cooldown\star4]],
		CooldownSpark = b .. "spark",
		Tri = b .. "tri",
		IconMask = b .. "iconmask",
	}
end

local darken do
	local CSL = CreateFrame("ColorSelect")
	function darken(r,g,b, vf, sf)
		CSL:SetColorRGB(r,g,b)
		local h,s,v = CSL:GetColorHSV()
		CSL:SetColorHSV(h, s*(sf or 1), v*(vf or 1))
		return CSL:GetColorRGB()
	end
end
local function shortBindName(bind)
	return GetBindingText(bind, 1)
end
local qualAtlas = {} do
	for i=1,5 do
		qualAtlas[i] = "Professions-Icon-Quality-Tier" .. i .. "-Small"
	end
end

local function cooldownFormat(cd)
	if (cd or 0) == 0 then return "" end
	local f, n, unit = cd >= 9.95 and "%d%s" or "%.1f", cd, ""
	if n > 86400 then n, unit = ceil(n/86400), "d"
	elseif n > 3600 then n, unit = ceil(n/3600), "h"
	elseif n > 89 then n, unit = ceil(n/60), "m"
	elseif n > 60 then f, n, unit = "%d:%02d", n/60, ceil(n % 60)
	elseif cd >= 9.95 then n = ceil(n) end
	return f, n, unit
end
local function adjustIconAspect(self, aspect)
	if self.iconAspect ~= aspect then
		self.iconAspect = aspect
		local w, h = self.iconbg:GetSize()
		self.icon:SetSize(aspect < 1 and h*aspect or w, aspect > 1 and w/aspect or h)
	end
end

local indicatorAPI = {}
do -- inherit SetPoint, SetScale, GetScale, SetShown, SetParent
	local m = getmetatable(UIParent).__index
	for k in ("SetPoint SetScale GetScale SetShown SetParent"):gmatch("%S+") do
		local f = m[k]
		indicatorAPI[k] = function(self, ...)
			return f(self[0], ...)
		end
	end
end
function indicatorAPI:SetIcon(texture, aspect)
	self.icon:SetTexture(texture)
	local ofs = 2.5/64
	self.icon:SetTexCoord(ofs, 1-ofs, ofs, 1-ofs)
	return adjustIconAspect(self, aspect)
end
function indicatorAPI:SetIconAtlas(atlas, aspect)
	self.icon:SetAtlas(atlas)
	return adjustIconAspect(self, aspect)
end
function indicatorAPI:SetIconTexCoord(a,b,c,d, e,f,g,h)
	if a and b and c and d then
		if e and f and g and h then
			self.icon:SetTexCoord(a,b,c,d, e,f,g,h)
		else
			self.icon:SetTexCoord(a,b,c,d)
		end
	end
end
function indicatorAPI:SetIconVertexColor(r,g,b)
	self.icon:SetVertexColor(r,g,b)
end
function indicatorAPI:SetUsable(usable, _usableCharge, _cd, nomana, norange)
	local state = usable and 0 or (norange and 1 or (nomana and 2 or 3))
	if self.ustate == state then return end
	self.ustate = state
	if not usable and (nomana or norange) then
		self.ribbon:Show()
		if norange then
			self.ribbon:SetVertexColor(1, 0.20, 0.15)
		else
			self.ribbon:SetVertexColor(0.15, 0.75, 1)
		end
	else
		self.ribbon:Hide()
	end
	self.veil:SetAlpha(usable and 0 or 0.40)
end
function indicatorAPI:SetDominantColor(r,g,b)
	r, g, b = r or 1, g or 1, b or 0.6
	local cd, r2, g2, b2 = self.cd, darken(r,g,b, 0.20)
	local r3, g3, b3 = darken(r,g,b, 0.10, 0.50)
	self.hiEdge:SetVertexColor(r, g, b)
	self.iglow:SetVertexColor(r, g, b)
	self.oglow:SetVertexColor(r, g, b)
	self.edge:SetVertexColor(darken(r,g,b, 0.80))
	self.cdText:SetTextColor(r, g, b)
	cd.spark:SetVertexColor(r, g, b)
	for i=1,4 do
		cd[i]:SetVertexColor(r2, g2, b2)
		cd[i+4]:SetVertexColor(r3, g3, b3)
	end
	cd[9]:SetVertexColor(r3, g3, b3)
end
function indicatorAPI:SetOverlayIcon(tex, w, h, ...)
	local oi = self.overIcon
	if not tex then
		return oi:Hide()
	end
	oi:Show()
	oi:SetTexture(tex)
	oi:SetSize(w, h)
	if ... then
		oi:SetTexCoord(...)
	else
		oi:SetTexCoord(0,1, 0,1)
	end
end
function indicatorAPI:SetOverlayIconVertexColor(...)
	self.overIcon:SetVertexColor(...)
end
function indicatorAPI:SetCount(count)
	self.count:SetText(count or "")
end
function indicatorAPI:SetBinding(binding)
	self.key:SetText(binding and shortBindName(binding) or "")
end
function indicatorAPI:SetCooldown(remain, duration, usable)
	if (duration or 0) <= 0 or (remain or 0) <= 0 then
		self.cd:Hide()
		self.cdText:SetText("")
	else
		local now = GetTime()
		local expire, usable, cd = now + remain, not not usable, self.cd
		local d = expire - (cd.expire or 0)
		if d < -0.05 or d > 0.05 then
			cd.duration, cd.expire, cd.updateCooldownStep, cd.updateCooldown = duration, expire, duration/1536/self[0]:GetEffectiveScale()
			cd:Show()
			cd.spark:SetShown(usable)
		end
		if cd.usable ~= usable then
			cd.usable = usable
			for i=1,4 do cd[i]:SetAlpha(usable and 0.45 or 1) end
			for i=5,9 do cd[i]:SetAlpha(usable and 0.25 or 0.85) end
			cd.spark:SetShown(usable)
		end
		local gcS, gcL = GetSpellCooldown(61304)
		if (duration ~= gcL or gcS+gcL-now < remain) and self[usable and "rcTextShown" or "cdTextShown"] then
			self.cdText:SetFormattedText(cooldownFormat(remain))
		else
			self.cdText:SetText("")
		end
	end
end
function indicatorAPI:SetCooldownTextShown(cooldownShown, rechargeShown)
	self.cdTextShown, self.rcTextShown = cooldownShown, rechargeShown
end
function indicatorAPI:SetHighlighted(highlight)
	self.hiEdge:SetShown(highlight)
end
function indicatorAPI:SetActive(active)
	self.iglow:SetShown(active)
end
function indicatorAPI:SetOuterGlow(shown)
	self.oglow:SetShown(shown)
end
function indicatorAPI:SetEquipState(isInContainer, isInInventory)
	local s, v, r, g, b = self.equipBanner, isInContainer or isInInventory, 0.1, 0.9, 0.15
	s:SetShown(v)
	if v then
		if not isInInventory then
			r, g, b = 1, 0.9, 0.2
		end
		s:SetVertexColor(r, g, b)
	end
end
function indicatorAPI:SetShortLabel(text)
	self.label:SetText(text)
end
function indicatorAPI:SetQualityOverlay(qual)
	local s, qa = self.qualityMark, qualAtlas[qual]
	s:SetAtlas(qa)
	s:SetShown(qa ~= nil)
end

local CreateCooldown do
	local function cdOnUpdate(self, elapsed)
		local ucd, expire, time = self.updateCooldown or 0, self.expire or 0, GetTime()
		if ucd > elapsed and time < expire then
			self.updateCooldown = ucd - elapsed
			return
		end
		self.updateCooldown = self.updateCooldownStep
		local duration, progress = self.duration or 0, expire - time

		if progress >= duration or duration == 0 then
			self:Hide()
		else
			progress = progress < 0 and 0 or (1 - progress/duration)
			local tri, pos, sp, pp, scale = self[9], 1+4*(progress - progress % 0.25), progress % 0.25 >= 0.125, (progress % 0.125) * 8, self.scale
			if self.pos ~= pos then
				for i=1,4 do
					self[i]:SetShown(i >= pos)
					self[4+i]:SetShown(i > pos or (i == pos and not sp))
					if i > pos then
						self[i]:SetSize(24, 24)
						local l, t = i > 2, i == 1 or i == 4
						self[i]:SetTexCoord(l and 0 or 0.5, l and 0.5 or 1, t and 0 or 0.5, t and 0.5 or 1)
						self[4+i]:SetSize(21*scale, 21*scale)
					end
				end
				tri:ClearAllPoints()
				tri:SetPoint((pos % 4 < 2 and "BOTTOM" or "TOP") .. (pos < 3 and "LEFT" or "RIGHT") , self, "CENTER")
				local iH, iV = pos == 2 or pos == 3, pos > 2
				tri:SetTexCoord(iH and 1 or 0, iH and 0 or 1, iV and 1 or 0, iV and 0 or 1)
				self.pos = pos
			end

			local l, r, inv = sp and 21 or (pp * 21), 21 - (sp and pp * 21 or 0), pos == 2 or pos == 4
			l, r = l > 0 and l or 0.00000001, r > 0 and r or 0.00000001
			tri:SetSize((inv and r or l)*scale, (inv and l or r)*scale)

			local chunk, shrunk = self[4+pos], 21 - 21*pp
			chunk:SetSize((inv and 21 or shrunk)*scale, (inv and shrunk or 21)*scale)
			chunk:SetShown(not sp or pp >= 0.9999)

			local p1, p2, e, p1a, p2a = sp and 1 or pp, sp and pp or 0, self[pos]
			if p1 > 0.9 and p2 < 0.1 then
				p1a = 0.9 + (p1 + p2 - 0.9)/2
				p2a = 1-(1.81 - p1a*p1a)^0.5
			else
				p1a, p2a = p1, p2
			end
			if p2 > 0.5 then
			elseif p2 > 0.06 then
				p2 = 0.20 + (p2 - 0.06)*30/44
			elseif p1 > 0.96 then
				p1, p2 = 1, (p2 + p1 - 0.96) * 2
			elseif p1 > 0.56 then
				p1 = p1 + (p1 - 0.56)*0.1
			end
			local p1c, p2c = 24 - 21*p1, 24 - 24*p2
			e:SetSize(inv and p2c or p1c, inv and p1c or p2c)
			if pos == 1 then
				e:SetTexCoord(0.5 + 28/64*p1, 1, 0.5*p2, 0.5)
				self.spark:SetPoint("CENTER", self, "TOP", 22.5 * p1a, -22.5*p2a-1.5)
			elseif pos == 2 then
				e:SetTexCoord(0.5, 1-0.5*p2, 0.5 + 28/64*p1, 1)
				self.spark:SetPoint("CENTER", self, "RIGHT", -22.5*p2a-1.5, -22.5*p1a)
			elseif pos == 3 then
				e:SetTexCoord(0, 0.5 - 28/64*p1, 0.5, 1 - 0.5*p2)
				self.spark:SetPoint("CENTER", self, "BOTTOM", -22.5 * p1a, 1.5+22.5*p2a)
			else
				e:SetTexCoord(0.5*p2, 0.5, 0, 0.5 - 28/64*p1)
				self.spark:SetPoint("CENTER", self, "LEFT", 1.5+22.5*p2a, 22.5*p1a)
			end
			if p2 >= 0.9999 then
				e:Hide()
			end
		end
	end
	local function cdOnHide(self)
		local toExpire = GetTime() - (self.expire or 0)
		self.expire, self.pos = nil
		for i=5,9 do self[i]:Hide() end
		if -0.1 < toExpire and toExpire < 0.25 then
			self.flashAG:Play()
		end
		self:Hide()
		self.spark:Hide()
	end
	local function cdOnShow(self)
		self[9]:Show()
		self.pos = nil -- Forces quad texture update; probably redundant with onHide
		return cdOnUpdate(self, 0)
	end
	function CreateCooldown(parent, size, overParent)
		local cd, scale, w, b = CreateFrame("Frame", nil, parent), size * 87/4032
		cd:SetScale(size/48)
		cd:SetAllPoints()
		cd:SetScript("OnShow", cdOnShow)
		cd:SetScript("OnHide", cdOnHide)
		cd:SetScript("OnUpdate", cdOnUpdate)
		cd.cdText = cd:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeOutline")
		cd.cdText:SetPoint("CENTER")
		
		w = (overParent or cd):CreateTexture(nil, "OVERLAY", nil, 2)
		w:SetTexture(gx.CooldownSpark)
		w:SetSize(24,24)
		cd.scale, cd.spark = scale, w
		w = w:CreateAnimationGroup()
		w:SetLooping("REPEAT")
		b = w:CreateAnimation("Rotation")
		b:SetDegrees(90)
		b:SetDuration(1/3)
		w:Play()
		
		w = parent:CreateTexture(nil, "OVERLAY")
		w:SetSize(60*size/64, 60*size/64)
		w:SetPoint("CENTER")
		w:SetTexture(gx.CooldownStar)
		w:SetBlendMode("ADD")
		w:SetAlpha(0)
		w, cd.flash = w:CreateAnimationGroup(), w
		b, cd.flashAG = w:CreateAnimation("ROTATION"), w
		b:SetDuration(1/2)
		b:SetDegrees(-90)
		b = w:CreateAnimation("Alpha")
		b:SetFromAlpha(0)
		b:SetToAlpha(0.7)
		b:SetDuration(1/8)
		b = w:CreateAnimation("Alpha")
		b:SetFromAlpha(0.7)
		b:SetToAlpha(0)
		b:SetDuration(1/8)
		b:SetStartDelay(3/8)
		
		for i=1,4 do
			cd[i] = cd:CreateTexture(nil, "ARTWORK")
			cd[i]:SetTexture(gx.BorderLow)
		end
		cd[1]:SetPoint("BOTTOMRIGHT", cd, "RIGHT")
		cd[2]:SetPoint("BOTTOMLEFT", cd, "BOTTOM")
		cd[3]:SetPoint("TOPLEFT", cd, "LEFT")
		cd[4]:SetPoint("TOPRIGHT", cd, "TOP")
		for i=1,4 do
			w = parent:CreateTexture(nil, "ARTWORK", nil, 3)
			w:SetColorTexture(1,1,1)
			w:SetPoint((i % 4 < 2 and "TOP" or "BOTTOM") .. (i < 3 and "RIGHT" or "LEFT"), cd, "CENTER", (i < 3 and 21 or -21)*scale, (i % 4 < 2 and 21 or -21)*scale)
			cd[4+i] = w
		end
		cd[9] = parent:CreateTexture(nil, "ARTWORK", nil, 3)
		cd[9]:SetTexture(gx.Tri)
		
		return cd
	end
end

local CreateIndicator do
	local apimeta = {__index=indicatorAPI}
	function CreateIndicator(name, parent, size, nested)
		local cf = CreateFrame("Frame", name, parent)
			cf:SetSize(size, size)
		local bf = CreateFrame("Frame", nil, cf)
			bf:SetAllPoints()
			bf:SetFlattensRenderLayers(true)
			bf:SetIsFrameBuffer(FRAME_BUFFER_OK)
		local ef = CreateFrame("Frame", nil, bf)
			ef:SetAllPoints()
		local uf = CreateFrame("Frame", nil, cf)
			uf:SetAllPoints()
			uf:SetFrameLevel(bf:GetFrameLevel()+5)
		local r, w = setmetatable({[0]=cf, cd=CreateCooldown(ef, size, uf), bf=bf}, apimeta)
		w = ef:CreateTexture(nil, "OVERLAY")
			w:SetAllPoints()
			w:SetTexture(gx.BorderLow)
		w, r.edge = ef:CreateTexture(nil, "OVERLAY", nil, 1), w
			w:SetAllPoints()
			w:SetTexture(gx.BorderHigh)
		w, r.hiEdge = T.CreateQuadTexture("BACKGROUND", size*2, gx.OuterGlow, cf), w
			w:SetShown(false)
		w, r.oglow = ef:CreateTexture(nil, "ARTWORK", nil, 1), w
			w:SetAllPoints()
			w:SetTexture(gx.InnerGlow)
			w:SetAlpha(nested and 0.6 or 1)
		w, r.iglow = ef:CreateTexture(nil, "ARTWORK"), w
			w:SetPoint("CENTER")
			w:SetSize(60*size/64, 60*size/64)
		w, r.icon = ef:CreateTexture(nil, "ARTWORK", nil, -2), w
			w:SetPoint("CENTER")
			w:SetSize(60*size/64, 60*size/64)
			w:SetColorTexture(0.15, 0.15, 0.15, 0.85)
		w, r.iconbg = ef:CreateTexture(nil, "ARTWORK", nil, 2), w
			w:SetSize(60*size/64, 60*size/64)
			w:SetPoint("CENTER")
			w:SetColorTexture(0,0,0)
		w, r.veil = ef:CreateTexture(nil, "ARTWORK", nil, 3), w
			w:SetAllPoints()
			w:SetTexture(gx.Ribbon)
			w:Hide()
		w, r.ribbon = ef:CreateTexture(nil, "ARTWORK", nil, 4), w
			w:SetPoint("BOTTOMLEFT", 4, 4)
		w, r.overIcon = ef:CreateFontString(nil, "OVERLAY", "NumberFontNormal"), w
			w:SetJustifyH("RIGHT")
			w:SetPoint("BOTTOMRIGHT", -2, 4)
		w, r.count = ef:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmallGray"), w
			w:SetJustifyH("RIGHT")
			w:SetPoint("TOPRIGHT", -2, -3)
		w, r.key = ef:CreateTexture(nil, "ARTWORK", nil, 2), w
			w:SetSize(size/5, size/4)
			w:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
			w:SetTexCoord(0, 42/128, 6/64, 52/64)
			w:SetPoint("TOPLEFT", 6*size/64, -3*size/64)
		w, r.equipBanner = ef:CreateFontString(nil, "OVERLAY", "TextStatusBarText", -1), w
			w:SetSize(size-4, 12)
			w:SetJustifyH("CENTER")
			w:SetJustifyV("BOTTOM")
			w:SetMaxLines(1)
			w:SetPoint("BOTTOMLEFT", 3, 4)
			w:SetPoint("BOTTOMRIGHT", r.count, "BOTTOMLEFT", 2, 0)
		w, r.label = ef:CreateTexture(nil, "ARTWORK", nil, 3), w
			w:SetPoint("TOPLEFT", 4, -4)
			w:SetSize(14,14)
			w:Hide()
		w, r.qualityMark = ef:CreateMaskTexture(), w
			w:SetTexture(gx.IconMask)
			w:SetAllPoints()
			r.icon:AddMaskTexture(w)
		r.cdText = r.cd.cdText
		r.iconAspect = 1
		return r
	end
end

T.Mirage = {
	name="OPie",
	apiLevel=3,
	CreateIndicator=CreateIndicator,

	supportsCooldownNumbers=true,
	supportsShortLabels=true,
	onParentAlphaChanged=FRAME_BUFFER_OK and function(self, pea) self.bf:SetAlpha(pea) end or nil,
}