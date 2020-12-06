local configCache, _, T = {}, ...
local PC, api, iapi, MODERN = T.OPieCore, {}, {}, select(4, GetBuildInfo()) > 9e4
local max, min, abs, floor, sin, cos, atan2 = math.max, math.min, math.abs, math.floor, sin, cos, atan2
local function cc(m, f, ...)
	f[m](f, ...)
	return f
end
local function assert(condition, text, level)
	return (not condition) and error(text, level or 2) or condition
end

local triggerFrame = nil
local gfxBase = ([[Interface\AddOns\%s\gfx\]]):format((...))
local anchorFrame = cc("Hide", cc("SetPoint", cc("SetSize", CreateFrame("Frame"), 1, 1), "CENTER"))
local mainFrame = cc("Hide", cc("SetFrameStrata", cc("SetPoint", cc("SetSize", CreateFrame("Frame", nil, UIParent), 128, 128), "CENTER", anchorFrame), "FULLSCREEN"))
local ringQuad, setRingRotationPeriod, centerCircle, centerGlow = {} do
	local quadPoints, animations = {"BOTTOMRIGHT", "BOTTOMLEFT", "TOPLEFT", "TOPRIGHT"}, {}
	for i=1,4 do
		ringQuad[i] = cc("SetPoint", cc("SetSize", CreateFrame("Frame", nil, mainFrame), 32, 32), quadPoints[i], mainFrame, "CENTER")
	end
	centerCircle = T.Mirage._CreateQuadTexture("ARTWORK", 64, gfxBase .. "circle", nil, ringQuad)
	centerGlow = T.Mirage._CreateQuadTexture("BACKGROUND", 128, gfxBase .. "glow", nil, ringQuad)
	for i=1,4 do
		local g = cc("SetLooping", ringQuad[i]:CreateAnimationGroup(), "REPEAT")
		animations[i] = cc("SetOrigin", cc("SetDegrees", cc("SetDuration", g:CreateAnimation("Rotation"), 4), -360), quadPoints[i], 0, 0)
		g:Play()
	end
	function setRingRotationPeriod(p)
		local p = max(0.1, p)
		for i=1,4 do animations[i]:SetDuration(p) end
	end
end
local centerPointer = cc("SetTexture", cc("SetPoint", cc("SetSize", mainFrame:CreateTexture(nil, "ARTWORK"), 192, 192), "CENTER"), gfxBase .. "pointer")

local function SetAngle(self, angle, radius)
	self:SetPoint("CENTER", radius*cos(90+angle), radius*cos(angle))
end
local function CalculateRingRadius(n, fLength, aLength, min, baseAngle)
	if n < 2 then return min end
	local radius, mLength, astep = max(min, (fLength + aLength * (n-1))/6.2831853071796), (fLength+aLength)/2, 360 / n
	repeat
		local ox, oy, clear, angle, i = radius*cos(baseAngle), radius*sin(baseAngle), true, baseAngle + astep, 1
		while clear and i <= n do
			local nx, ny, sideLength = radius*cos(angle), radius*sin(angle), (i == 1 or i == n) and mLength or aLength
			if abs(ox - nx) < sideLength and abs(oy - ny) < sideLength then
				radius, clear = radius + 5
			end
			ox, oy, angle, i = nx, ny, angle + astep, i + 1
		end
	until clear
	return radius
end

local Slices, CreateIndicator = {}, T.Mirage.CreateIndicator
local GhostIndication = {} do
	local spareGroups, spareSlices, currentGroups, activeGroup = {}, {}, {}
	local function AnimateHide(self, elapsed)
		local total = configCache.XTZoomTime
		self.expire = (self.expire or total) - elapsed
		if self.expire < 0 then
			self.expire = nil
			self:SetScript("OnUpdate", nil)
			self:Hide()
		else
			self:SetAlpha(self.expire/total)
		end
	end
	local function AnimateShow(self, elapsed)
		local zoomTime = configCache.XTZoomTime
		local et = self.expire
		et = et and (et - elapsed) or (zoomTime + configCache.GhostShowDelay)
		if et < 0 then
			self.expire = nil
			self:SetScript("OnUpdate", nil)
			self:SetAlpha(1)
		else
			self.expire = et
			self:SetAlpha(et > zoomTime and 0 or (1-self.expire/zoomTime))
		end
	end
	function GhostIndication:ActivateGroup(index, count, incidentAngle, mainRadius, mainScale)
		local ret = currentGroups[index] or next(spareGroups) or cc("SetScale", cc("SetSize", CreateFrame("Frame", nil, mainFrame), 1, 1), 0.80)
		currentGroups[index], spareGroups[ret] = ret
		if not ret:IsShown() then
			ret.expire = nil
			ret:SetScript("OnUpdate", AnimateShow)
			ret:Show()
			AnimateShow(ret, 0)
		end
		if activeGroup ~= ret then GhostIndication:Deactivate() end
		if ret.incident ~= incidentAngle or ret.count ~= count then
			local baseSize = 48 + 48*configCache.MIButtonMargin
			local radius, angleStep = CalculateRingRadius(count, baseSize*mainScale, 48*0.80, 30, incidentAngle-180)/0.80, 360/count
			local angle = incidentAngle - angleStep + 90
			for i=2,count do
				local cell = ret[i] or next(spareSlices) or CreateIndicator(nil, ret, 48, true)
				cell:SetParent(ret)
				SetAngle(cell, angle, radius)
				cell:SetShown(true)
				ret[i], angle, spareSlices[cell] = cell, angle - angleStep
			end
			for i=count+1,ret.count or 0 do
				local cell = ret[i]
				cell:SetShown(false)
				spareSlices[cell], ret[i] = cell, nil
			end
			ret.incident, ret.count = incidentAngle, count
			ret:SetPoint("CENTER", (mainRadius/0.80+radius)*cos(incidentAngle), (mainRadius/0.80+radius)*sin(incidentAngle))
			ret:Show()
		end
		activeGroup = ret
		return ret
	end
	function GhostIndication:Deactivate()
		if activeGroup then
			activeGroup:SetScript("OnUpdate", AnimateHide)
			activeGroup = nil
		end
	end
	function GhostIndication:Reset()
		for k, g in pairs(currentGroups) do
			g:Hide()
			for i=2,g.count or 0 do
				g[i]:SetShown(false)
				spareSlices[g[i]], g[i] = g[i]
			end
			spareGroups[g], currentGroups[k], g.incident, g.count = g
		end
		activeGroup = nil
	end
	function GhostIndication:SwitchSparePool(pool)
		self:Reset()
		spareSlices = pool
	end
end

local IndicatorFactories, ActiveIndicatorFactory, LastRegisteredIndicatorFactory = {}
local SwitchIndicatorFactory, ValidateIndicator do
	local CURRENT_API_LEVEL = 1
	local RequiredIndicatorMethods = {
		SetPoint=0, SetScale=0, GetScale=0, SetShown=0, SetParent=0,
		SetIcon=0, SetIconTexCoord=0, SetIconVertexColor=0, SetDominantColor=0,
		SetOverlayIcon=0, SetOverlayIconVertexColor=1,
		SetUsable=0, SetCount=0, SetBinding=0,
		SetCooldown=0, SetCooldownTextShown="supportsCooldownNumbers", SetShortLabel="supportsShortLabels",
		SetEquipState=0, SetHighlighted=0, SetActive=0, SetOuterGlow=0,
	}
	function ValidateIndicator(apiLevel, info, errorLevel)
		if apiLevel < 0 or (info.reqAPILevel or apiLevel) > CURRENT_API_LEVEL then
			error("API level " .. apiLevel .. " is not supported (current is " .. CURRENT_API_LEVEL .. ")", errorLevel)
		end
		local f = info.CreateIndicator(nil, mainFrame, 48)
		for k,v in pairs(RequiredIndicatorMethods) do
			local tv = type(v)
			if type(f[k]) ~= "function" and ((tv == "number" and apiLevel >= v) or (tv == "string" and info[v])) then
				return error(("Expected a function for indicator key %q, got %s."):format(k, type(f[k])), errorLevel)
			end
		end
		return {[f]=true}
	end
	function SwitchIndicatorFactory(iakey)
		local iakey = (iakey == nil or iakey == "_") and LastRegisteredIndicatorFactory or iakey
		local finfo = IndicatorFactories[iakey] or IndicatorFactories.mirage
		if finfo ~= ActiveIndicatorFactory then
			local oldPool = ActiveIndicatorFactory and ActiveIndicatorFactory.mainPool
			for k,v in pairs(Slices) do
				oldPool[v], Slices[k] = true, nil
				v:SetShown(false)
			end
			mainFrame:Hide()
			CreateIndicator, ActiveIndicatorFactory = finfo.CreateIndicator, finfo
			GhostIndication:SwitchSparePool(finfo.ghostPool)
		end
	end
	local function nextRIC(_, key)
		if key == "_" then return end
		local nk, nv = next(IndicatorFactories, key)
		if nk then
			return nk, nv.name, nv.apiLevel < CURRENT_API_LEVEL
		end
		return "_", IndicatorFactories[LastRegisteredIndicatorFactory].name, false
	end
	function iapi:EnumerateRegisteredIndicatorConstructors()
		return nextRIC
	end
	function iapi:DoesIndicatorConstructorSupport(key, feature)
		if key == nil or key == "_" then key = LastRegisteredIndicatorFactory end
		if not IndicatorFactories[key] then key = LastRegisteredIndicatorFactory or "mirage" end
		return not not IndicatorFactories[key]["supports" .. feature]
	end
	function iapi:GetIndicatorConstructorName(key)
		if key == nil or key == "_" then key = LastRegisteredIndicatorFactory end
		local ic = IndicatorFactories[key]
		return ic and ic.name
	end
	function iapi:HasMultipleIndicatorConstructors()
		return nil ~= next(IndicatorFactories, (next(IndicatorFactories)))
	end
end

local tokenR, tokenG, tokenB, tokenCaption, tokenIcon, tokenQuest = {}, {}, {}, {}, {}, {}
local getSliceColor do
	local col, pal = T.Niji._tex, T.Niji._palette
	function getSliceColor(token, icon, token2)
		if tokenR[token] then return tokenR[token], tokenG[token], tokenB[token] end
		if tokenR[token2] then return tokenR[token2], tokenG[token2], tokenB[token2] end
		local li = col[icon] or -3
		return pal[li] or 0.7, pal[li+1] or 1, pal[li+2] or 0.6
	end
end
local function extractAux(ext, v)
	if not ext then
	elseif v == "coord" then
		local t = type(ext.iconCoords)
		if t == "table" then
			return unpack(ext.iconCoords)
		elseif t == "function" then
			return ext.iconCoords()
		end
	elseif v == "color" and type(ext.iconR) == "number" and type(ext.iconG) == "number" and type(ext.iconB) == "number" then
		return ext.iconR, ext.iconG, ext.iconB
	end
end
local function SetDefaultAnchor(tt, owner)
	if tt:IsOwned(owner) then
		tt:ClearLines()
	else
		GameTooltip_SetDefaultAnchor(tt, owner)
	end
end
local function updateCentralElements(self, si)
	local osi, tok, usable, state, icon, caption, _, _, _, tipFunc, tipArg = self.oldSlice, OneRingLib:GetOpenRingSliceAction(si)
	caption = tokenCaption[tok] or caption
		
	if tok then
		local r,g,b = getSliceColor(tok, tokenIcon[tok] or icon or "INV_Misc_QuestionMark")
		centerPointer:SetVertexColor(r,g,b, 0.9)
		centerCircle:SetVertexColor(r,g,b, 0.9)
		centerGlow:SetVertexColor(r,g,b)
	elseif si ~= osi then
		centerPointer:SetVertexColor(1,1,1, 0.1)
		centerCircle:SetVertexColor(1,1,1, 0.3)
		centerGlow:SetVertexColor(0.75,0.75,0.75)
	end

	if configCache.UseGameTooltip then
		if tipFunc and tipArg then
			SetDefaultAnchor(GameTooltip, mainFrame)
			tipFunc(GameTooltip, tipArg)
			GameTooltip:Show()
		elseif caption and caption ~= "" then
			SetDefaultAnchor(GameTooltip, mainFrame)
			GameTooltip:AddLine(caption)
			GameTooltip:Show()
		else
			if GameTooltip:IsOwned(mainFrame) then
				GameTooltip:Hide()
			end
		end
	end

	local sm = (state and (state % 4 > 1) and 0.625 or 1)
	if self.rotPeriod ~= sm then
		self.rotPeriod = sm
		setRingRotationPeriod(configCache.XTRotationPeriod*sm)
	end

	local gAnim, gEnd, oIG, time, usable = self.gAnim, self.gEnd, self.oldIsGlowing, GetTime(), usable or (state and usable ~= false) or false
	if usable ~= oIG then
		gAnim, gEnd = usable and "in" or "out",  time + 0.3 - (gEnd and gEnd > time and (gEnd-time) or 0)
		self.oldIsGlowing, self.gAnim, self.gEnd = usable, gAnim, gEnd
		centerGlow:SetShown(true)
	end
	if gAnim and gEnd <= time or oIG == nil then
		self.gAnim, self.gEnd = nil, nil
		centerGlow:SetShown(usable)
		centerGlow:SetAlpha(0.75)
	elseif gAnim then
		local pg = (gEnd-time)/0.3*0.75
		centerGlow:SetAlpha(usable and (0.75 - pg) or pg)
	end
	self.oldSlice = si
end
local function updateSlice(self, originAngle, selected, tok, usable, state, icon, _, count, cd, cd2, _tf, _ta, ext, stext)
	local isJump, origJumpIcon, jumpOtherTok = false, icon
	state, usable, ext = state or 0, usable or (state and usable ~= false) or false, not tokenIcon[tok] and ext or nil
	if state % 8192 >= 4096 then
		icon, jumpOtherTok, isJump, count = 188515, count, true, 0
	end
	icon = tokenIcon[tok] or icon or "Interface/Icons/INV_Misc_QuestionMark"
	local active, overlay, faded, usableCharge, r,g,b = state % 2 >= 1, state % 4 >= 2, not usable, usable or (state % 128 >= 64)
	self:SetIcon(icon)
	if ext then
		self:SetIconTexCoord(securecall(extractAux, ext, "coord"))
		r, g, b = securecall(extractAux, ext, "color")
	end
	local dr, dg, db = getSliceColor(tok, isJump and icon == 188515 and origJumpIcon or icon, jumpOtherTok)
	self:SetUsable(usable, usableCharge, cd and cd > 0, state % 16 >= 8, state % 32 >= 16)
	self:SetIconVertexColor(r or 1, g or 1, b or 1)
	self:SetDominantColor(dr, dg, db)
	self:SetOuterGlow(overlay)
	if isJump and icon == 188515 then
		local cx, cy, cr = 128/256, 45/256, 0.53 * 0.45 -- l, r, t, b = 97/256, 159/256, 14/256, 76/256
		local a1, x1,x2,x3,x4, y1,y2,y3,y4 = 135-originAngle
		x1,y1 = cx + cr*cos(a1), cy - cr*sin(a1)
		x2,y2 = cx + cr*cos(a1+ 90), cy - cr*sin(a1+ 90)
		x3,y3 = cx + cr*cos(a1+180), cy - cr*sin(a1+180)
		x4,y4 = cx + cr*cos(a1+270), cy - cr*sin(a1+270)
		self:SetOverlayIcon(gfxBase .. "pointer", 40, 40, x2,y2, x3,y3, x1,y1, x4,y4)
		if ActiveIndicatorFactory.apiLevel >= 1 then
			self:SetOverlayIconVertexColor(dr, dg, db)
		end
	else
		self:SetOverlayIcon((tokenQuest[tok] or ((state or 0) % 64 >= 32)) and "Interface\\MINIMAP\\TRACKING\\OBJECTICONS", 21, 28, 40/256, 64/256, 32/64, 1)
	end
	if ActiveIndicatorFactory.supportsShortLabels then
		self:SetShortLabel(configCache.ShowShortLabels and stext or "")
	end
	self:SetCooldown(cd, cd2, usableCharge)
	self:SetEquipState(state % 256 >= 128, state % 512 >= 256)
	local ct = configCache.ShowOneCount and 0 or 1
	self:SetCount((count or 0) > ct and count)
	self:SetActive(active)
	self:SetHighlighted(selected and not faded)
end

local lastConAngle = nil
local function OnUpdate_Main(self, elapsed)
	local aframe = triggerFrame or self
	local count, offset = self.count, self.offset
	local scale, l, b, w, h = aframe:GetEffectiveScale(), aframe:GetRect()
	local x, y = GetCursorPosition()
	local dx, dy = (x / scale) - (l + w / 2), (y / scale) - (b + h / 2)
	local radius2 = dx*dx+dy*dy

	local angle, isInFastClick = atan2(dy, dx) % 360, configCache.CenterAction and self.fastClickSlice > 0 and self.fastClickSlice <= self.count
	local stick, stx, sty, stl = PC:GetActivePointerStick()
	if stick then
		angle = stl < 0.25 and lastConAngle or atan2(sty, stx) % 360
		lastConAngle, radius2 = angle, stl < 0.01 and 200 or stl < 0.25 and 1000 or 1600
	end

	isInFastClick = isInFastClick and radius2 <= 400
	if isInFastClick then
		angle = (90 - offset - (self.fastClickSlice-1)*360/count) % 360
	end

	local oangle = (not isInFastClick) and self.angle or angle
	local adiff, arate = min((angle-oangle) % 360, (oangle-angle) % 360)
	if adiff > 60 then
		arate = 420 + 120*sin(min(90, adiff-60))
	elseif adiff > 15 then
		arate = 180 + 240*sin(min(90, max((adiff-15)*2, 0)))
	else
		arate = 20 + 160*sin(min(90, adiff*6))
	end
	local abound, arotDirection = arate/GetFramerate(), ((oangle - angle) % 360 < (angle - oangle) % 360) and -1 or 1
	abound = abound * 2^configCache.XTPointerSpeed
	self.angle = (adiff < abound) and angle or (oangle + arotDirection * abound) % 360
	centerPointer:SetRotation(self.angle/180*3.1415926535898 - 90/180*3.1415926535898)

	local si = isInFastClick and self.fastClickSlice or (count <= 0 and 0) or (radius2 < 1600 and 0) or
		(floor(((90-angle - offset) * count/360 + 0.5) % count) + 1)
	updateCentralElements(self, si)

	if count == 0 then
		return
	end

	local cmState, mut = (IsShiftKeyDown() and 1 or 0) + (IsControlKeyDown() and 2 or 0) + (IsAltKeyDown() and 4 or 0) + (MODERN and IsMetaKeyDown() and 8 or 0), self.schedMultiUpdate or 0
	if self.omState == cmState and mut < 0  then
		self.schedMultiUpdate = mut + elapsed
	else
		self.omState, self.schedMultiUpdate = cmState, -0.05
		for i=1,count do
			updateSlice(Slices[i], 90 - (i-1)*360/count - offset, si == i, OneRingLib:GetOpenRingSliceAction(i))
		end
		if configCache.GhostMIRings then
			local _, _, _, nestedCount, atype = OneRingLib:GetOpenRingSlice(si or 0)
			if (nestedCount or 0) == 0 then
				GhostIndication:Deactivate()
			else
				local jump1 = atype == "jump" and 1 or 0
				local originAngle = 90 - 360/count*(si-1) - offset
				local group = GhostIndication:ActivateGroup(si, nestedCount + jump1, originAngle, self.radius*(configCache.MIScale and 1.10 or 1), 1.10)
				for i=2-jump1, nestedCount do
					updateSlice(group[i+jump1], 90, false, OneRingLib:GetOpenRingSliceAction(si, i))
				end
			end
		end
	end

	if configCache.MIScale then
		local limit = 2^configCache.XTScaleSpeed/GetFramerate()
		for i=1,count do
			local s, new = Slices[i], i == si and 1.10 or 1
			local old = s:GetScale()
			s:SetScale(old + min(limit, max(-limit, new-old)))
		end
	end
end
local function OnUpdate_ZoomIn(self, elapsed)
	local delta = self.eleft - elapsed
	self.eleft, delta = delta, delta > 0 and delta/configCache.XTZoomTime or 0
	if delta == 0 then self:SetScript("OnUpdate", OnUpdate_Main) end
	self:SetScale(configCache.RingScale/max(0.20,cos(65*delta)))
	self:SetAlpha(1-delta)
	return OnUpdate_Main(self, elapsed)
end
local function OnUpdate_ZoomOut(self, elapsed)
	local delta = self.eleft - elapsed
	self.eleft, delta = delta, delta > 0 and delta/configCache.XTZoomTime or 0
	if delta == 0 then
		self:Hide()
		self:SetScript("OnUpdate", nil)
	elseif configCache.MISpinOnHide then
		local count = self.count
		if count > 0 then
			local baseAngle, angleStep, radius, prog = 45 - self.offset + 45*delta, 360/count, self.radius, (1-delta)*150*max(0.5, min(1, GetFramerate()/60))
			for i=1,count do
				Slices[i]:SetPoint("CENTER", cos(baseAngle)*radius + cos(baseAngle-90)*prog, sin(baseAngle)*radius + sin(baseAngle-90)*prog)
				baseAngle = baseAngle - angleStep
			end
		end
		self:SetScale(configCache.RingScale*(1.75 - .75*delta))
	else
		self:SetScale(configCache.RingScale*delta)
	end
	self:SetAlpha(delta)
end
mainFrame:SetScript("OnHide", function(self)
	if self:IsShown() and self:GetScript("OnUpdate") == OnUpdate_ZoomOut then
		self:SetScript("OnUpdate", nil)
		self:Hide()
	end
end)

function iapi:Show(_, fcSlice, fastOpen, reFrame)
	triggerFrame, lastConAngle, _, mainFrame.count, mainFrame.offset = reFrame, nil, OneRingLib:GetOpenRing(configCache)
	SwitchIndicatorFactory(configCache.IndicatorFactory)

	local baseSize = 48 + 48*configCache.MIButtonMargin
	mainFrame.radius = CalculateRingRadius(mainFrame.count or 3, baseSize, baseSize, 100, 90-(mainFrame.offset or 0))
	mainFrame:SetScript("OnUpdate", OnUpdate_ZoomIn)
	mainFrame.eleft, mainFrame.fastClickSlice, mainFrame.oldSlice, mainFrame.angle, mainFrame.omState, mainFrame.oldIsGlowing = configCache.XTZoomTime * (fastOpen and 0.5 or 1), fcSlice or 0, -1
	mainFrame.rotPeriod = nil
	GhostIndication:Reset()

	local astep, radius, usedMI = mainFrame.count == 0 and 0 or -360/mainFrame.count, mainFrame.radius, mainFrame.count
	for i=1, usedMI do
		local indic, _, _, sliceBind = Slices[i] or rawset(Slices, i, next(ActiveIndicatorFactory.mainPool) or CreateIndicator(nil, mainFrame, 48))[i], OneRingLib:GetOpenRingSlice(i)
		ActiveIndicatorFactory.mainPool[indic] = nil
		indic:SetBinding(configCache.ShowKeys and sliceBind or nil)
		SetAngle(indic, (i - 1) * astep - mainFrame.offset, radius)
		if ActiveIndicatorFactory.supportsCooldownNumbers then
			indic:SetCooldownTextShown(configCache.ShowCooldowns, configCache.ShowRecharge)
		end
		indic:SetShown(true)
		indic:SetScale(1)
	end
	for i=usedMI+1, #Slices do
		Slices[i]:SetShown(false)
	end

	configCache.RingScale = max(0.1, configCache.RingScale)
	mainFrame:SetScale(configCache.RingScale)
	if fastOpen == "inplace-switch" then
	elseif configCache.RingAtMouse then
		local cx, cy = GetCursorPosition()
		anchorFrame:SetPoint("CENTER", nil, "BOTTOMLEFT", cx + configCache.IndicationOffsetX, cy - configCache.IndicationOffsetY)
	else
		anchorFrame:SetPoint("CENTER", nil, "CENTER", configCache.IndicationOffsetX, -configCache.IndicationOffsetY)
	end
	mainFrame:Show()
end
function iapi:Hide()
	mainFrame:SetScript("OnUpdate", OnUpdate_ZoomOut)
	mainFrame.eleft = configCache.XTZoomTime
	GhostIndication:Deactivate()
	if GameTooltip:IsOwned(mainFrame) then
		GameTooltip:Hide()
	end
end

function api:SetDisplayOptions(token, icon, caption, r,g,b)
	if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then r,g,b = nil end
	tokenR[token], tokenG[token], tokenB[token], tokenCaption[token], tokenIcon[token] = r,g,b, caption, icon
end
function api:SetQuestHint(sliceToken, hint)
	tokenQuest[sliceToken] = hint or nil
end
function api:GetTexColor(icon)
	return getSliceColor(nil, icon)
end

local ricErrorOffset = 0
function api:RegisterIndicatorConstructor(key, info)
	local errorLevel = 3 + ricErrorOffset
	ricErrorOffset = 0
	assert(type(key) == "string" and type(info) == "table", 'Syntax: OPieUI:RegisterIndicatorConstructor("key", infoTable)', errorLevel)
	local func, apiLevel = info.CreateIndicator, info.apiLevel
	assert(IndicatorFactories[key] == nil or key == "legacy", 'RegisterIndicatorConstructor: an indicator constructor with the specified key is already registered', errorLevel)
	assert(type(func) == "function", 'RegisterIndicatorConstructor: info.CreateIndicator must be a function', errorLevel)
	assert(type(apiLevel) == "number" and apiLevel < math.huge, 'RegisterIndicatorConstructor: info.apiLevel must be a finite number', errorLevel)
	assert(type(info.name) == "string", 'RegisterIndicatorConstructor: info.name must be a string', errorLevel)
	assert(type(info.reqAPILevel) == "number" or info.reqAPILevel == nil, 'RegisterIndicatorConstructor: info.reqAPILevel, if set, must be a number', errorLevel)

	local mainPool = ValidateIndicator(apiLevel, info, 1+errorLevel)
	LastRegisteredIndicatorFactory, IndicatorFactories[key] = key, {
		name = info.name:gsub("|", ""),
		apiLevel = apiLevel,
		CreateIndicator = func,
		mainPool = mainPool,
		ghostPool = {},
		supportsCooldownNumbers = not not info.supportsCooldownNumbers,
		supportsShortLabels = not not info.supportsShortLabels,
	}
end

for k,v in pairs({ShowCooldowns=false, ShowRecharge=false, UseGameTooltip=true, ShowKeys=true, ShowOneCount=false, ShowShortLabels=true,
	MIScale=true, MISpinOnHide=true, MIButtonMargin=0.1, GhostMIRings=true,
	IndicatorFactory="_",
	XTPointerSpeed=0, XTScaleSpeed=0, XTZoomTime=0.3, XTRotationPeriod=4, GhostShowDelay=0.25}) do
	PC:RegisterOption(k,v)
end
api:RegisterIndicatorConstructor("mirage", T.Mirage)

T.OPieUI, OPie.UI = iapi, api

local dapi = {}
-- DEPRECATED: call RegisterIndicatorConstructor (once); OPie will switch (or not) based on user prefs.
function dapi:SetIndicatorConstructor(func)
	if func then
		ricErrorOffset = 1
		return api:RegisterIndicatorConstructor("legacy", {
			CreateIndicator=func,
			apiLevel=0,
			name="Legacy",
		})
	else
		LastRegisteredIndicatorFactory = "mirage"
	end
end
-- Moved; alias for a bit longer
dapi.SetQuestHint = api.SetQuestHint
dapi.SetDisplayOptions = api.SetDisplayOptions

OneRingLib.ext.OPieUI = dapi