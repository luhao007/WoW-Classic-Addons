local _, T = ...
local XU = T.exUI
local assert, getWidgetData, newWidgetData, _setWidgetData, AddObjectMethods, CallObjectScript = XU:GetImpl()

local function confToggleTexture(tex, blendMode, ...)
	tex:SetBlendMode(blendMode)
	tex:SetTexCoord(...)
	tex:SetTextureSliceMargins(12,12,12,12)
end
local function CreateToggleButton(name, parent, outerTemplate, id)
	local button = CreateFrame("CheckButton", name, parent, outerTemplate, id)
	button:SetSize(170, 30)
	button:SetNormalFontObject(GameFontHighlightMedium)
	button:SetPushedTextOffset(-1, -1)
	button:SetNormalTexture("Interface\\PVPFrame\\PvPMegaQueue")
	confToggleTexture(button:GetNormalTexture(), "BLEND", 1/512,301/512, 447/512,475/512)
	button:SetPushedTexture("Interface\\PVPFrame\\PvPMegaQueue")
	confToggleTexture(button:GetPushedTexture(), "BLEND", 1/512,301/512,476/512,504/512)
	button:SetHighlightTexture("Interface\\PVPFrame\\PvPMegaQueue")
	confToggleTexture(button:GetHighlightTexture(), "ADD", 1/512,327/512, 362/512,393/512)
	button:SetCheckedTexture("Interface\\PVPFrame\\PvPMegaQueue")
	confToggleTexture(button:GetCheckedTexture(), "ADD", 1/512,327/512, 394/512,425/512)
	for i=1,2 do
		local tex = i == 1 and button:GetHighlightTexture() or button:GetCheckedTexture()
		tex:ClearAllPoints()
		tex:SetPoint("TOPLEFT", button, "TOPLEFT", 1.5, 12.3-15)
		tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1.5, 15-12.3)
	end
	return button
end
XU:RegisterFactory("OPie:ToggleButton", CreateToggleButton)

do -- OPie:RadioSet
	local RadioSetData, RadioSet = {}, {}

	local function onSegmentClick(self)
		local p = self:GetParent()
		assert(getWidgetData(p, RadioSetData), "Invalid object type")
		if not self:GetChecked() then
			return self:SetChecked(true)
		end
		RadioSet.SetValue(p, self:GetID())
	end
	
	function RadioSet:SetOptionText(index, text)
		local d = assert(getWidgetData(self, RadioSetData), "Invalid object type")
		assert(type(index) == "number" and index % 1 == 0 and index >= 1 and type(text) == "string", 'Syntax: RadioSet:SetOptionText(index, "text")')
		local osz = #d.segments
		for i=osz+1, index do
			local wi = XU:Create('OPie:ToggleButton', nil, d.self, nil, i)
			wi:SetPoint("LEFT", 180*(i-1), 0)
			wi:SetScript("OnClick", onSegmentClick)
			wi:SetChecked(i == d.value)
			d.segments[i] = wi
		end
		d.segments[index]:SetText(text)
		if index > osz then
			self:Reflow(180*index-10)
		end
	end
	function RadioSet:SetValue(index)
		local d = assert(getWidgetData(self, RadioSetData), "Invalid object type")
		local nw = assert(d.segments[index], 'Syntax: RadioSet:SetValue(index)')
		local ow = d.segments[d.value]
		if ow == nw then return end
		if ow then ow:SetChecked(false) end
		if nw then nw:SetChecked(true) end
		d.value = index
		CallObjectScript(d.self, "OnValueChanged", index)
	end
	function RadioSet:GetValue()
		local d = assert(getWidgetData(self, RadioSetData), "Invalid object type")
		return d.value
	end
	function RadioSet:Reflow(targetWidth)
		local s = assert(getWidgetData(self, RadioSetData), "Invalid object type").segments
		assert(targetWidth == nil or type(targetWidth) == "number" and targetWidth > 0, 'Syntax: RadioSet:Reflow([targetWidth])')
		targetWidth = targetWidth or self:GetWidth()
		local n, l, W, w, o = #s, 0, 0, {}, {}
		for i=1,n do
			local wi = (s[i]:GetFontString():GetStringWidth() or 76)+24
			W, w[i], o[i] = W+wi, wi, i
		end
		table.sort(o, function(a,b) return w[a] > w[b] end)
		-- If targetWidth is too low, gap becomes negative and *everything* overlaps
		local gap = n > 1 and math.min(10, (targetWidth-W)/(n-1)) or 0
		W = targetWidth - gap * (n-1)
		for i=1,n do
			local k = o[i]
			local wk = math.max(w[k], W/(n-i+1))
			w[k], W = wk, W - wk
			s[k]:SetWidth(wk)
		end
		for i=2,n do
			l = l + w[i-1] + gap
			s[i]:SetPoint("LEFT", l, 0)
		end
		self:SetWidth(targetWidth)
	end
	
	local RadioSetProps = {
		api=RadioSet,
		scripts={"OnValueChanged"},
		value = 1,
	}
	AddObjectMethods({"RadioSet"}, RadioSetProps)
	local function CreateRadioSet(name, parent, outerTemplate, id)
		local co, d = CreateFrame("Frame", name, parent, outerTemplate, id)
		d = newWidgetData(co, RadioSetData, RadioSetProps)
		d.segments, d.segmentID = {}, {}
		co:SetHeight(30)
		return co
	end
	XU:RegisterFactory("OPie:RadioSet", CreateRadioSet)
end