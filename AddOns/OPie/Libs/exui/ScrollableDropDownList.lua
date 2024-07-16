local _, T = ...
local XU, int, ScrollableBlockData, positionArchive, hoverWatcher = T.exUI, {}, {}, setmetatable({}, {__mode="k"}), nil
local MIN_SCROLL_ENTRIES, MAX_VISIBLE_ENTRIES, WHEEL_STEP = 20, 16, 8
local assert, getWidgetData, _, setWidgetData = XU:GetImpl()
DropDownList1:HookScript("OnHide", function() wipe(positionArchive) end)

local getFreeBlock do
	local pool = {}
	local function releaseBlock(block)
		local d = getWidgetData(block, ScrollableBlockData)
		if d then
			block:Hide()
			block:SetParent(nil)
			block:ClearAllPoints()
			pool[block], d.dataList, d.entryFormat, d.entrySelect = 1, nil
		end
	end
	local function newBlock()
		local block = CreateFrame("Frame")
		block:Hide()
		block:SetScript("OnHide", releaseBlock)
		block:SetScript("OnMouseWheel", int.OnMouseWheel)
		block:SetHitRectInsets(-4, -24, -8, -8)
		local bb = block:CreateTexture(nil, "BACKGROUND")
		bb:SetColorTexture(0.3, 0.3, 0.3)
		bb:SetPoint("BOTTOMLEFT", -4, -0.5)
		bb:SetPoint("BOTTOMRIGHT", 0, -0.5)
		local clipRoot = CreateFrame("Frame", nil, block)
		clipRoot:SetAllPoints()
		clipRoot:SetClipsChildren(true)
		local scrollOrigin = CreateFrame("Frame", nil, clipRoot)
		scrollOrigin:SetPoint("TOPLEFT")
		scrollOrigin:SetPoint("TOPRIGHT")
		scrollOrigin:SetHeight(1)
		local scrollBar = XU:Create("ScrollBar", nil, block)
		scrollBar:SetPoint("TOPRIGHT", -1, 0)
		scrollBar:SetPoint("BOTTOMRIGHT", -1, 0)
		scrollBar:SetScript("OnValueChanged", int.OnScrollChanged)
		scrollBar:SetWindowRange(MAX_VISIBLE_ENTRIES)
		scrollBar:SetStepsPerPage(MAX_VISIBLE_ENTRIES-2)
		local buttons = {}
		for i=1,MAX_VISIBLE_ENTRIES+1 do
			local b = CreateFrame("CheckButton", nil, clipRoot, nil, i)
			b:SetSize(100, 16)
			b:SetPoint("TOPLEFT", scrollOrigin, 0, 16-16*i)
			b:SetPoint("TOPRIGHT", scrollOrigin, -16, 16-16*i)
			b:SetScript("OnClick", int.OnEntryClick)
			b:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
			b:SetCheckedTexture([[Interface\Common\UI-DropDownRadioChecks]])
			b:SetNormalTexture([[Interface\Common\UI-DropDownRadioChecks]])
			b:SetNormalFontObject(GameFontHighlightSmallLeft)
			b:SetDisabledFontObject(GameFontHighlightSmallLeft)
			b:SetText("The Fifth Surprise")
			b:GetFontString():ClearAllPoints()
			b:GetFontString():SetPoint("LEFT", 22, 0)
			local h, c, n = b:GetHighlightTexture(), b:GetCheckedTexture(), b:GetNormalTexture()
			h:SetBlendMode("ADD")
			h:SetAllPoints()
			c:SetTexCoord(0, 0.5, 0.5, 1)
			c:ClearAllPoints()
			c:SetSize(16,16)
			c:SetPoint("LEFT", 3, 0)
			n:SetTexCoord(0.5, 1, 0.5, 1)
			n:ClearAllPoints()
			n:SetSize(16,16)
			n:SetPoint("LEFT", 3, 0)
			buttons[i] = b
		end
		local d = {root=block, clip=clipRoot, origin=scrollOrigin, scrollBar=scrollBar, buttons=buttons, bottomTex=bb}
		setWidgetData(block, ScrollableBlockData, d)
		return block
	end
	function getFreeBlock()
		local r = next(pool) or newBlock()
		pool[r] = nil
		return r, getWidgetData(r, ScrollableBlockData)
	end
end

function int:OnEntryClick()
	local d = getWidgetData(self:GetParent():GetParent(), ScrollableBlockData)
	local entrySelect, arg1 = d.entrySelect, d.dataList[self:GetID()]
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	CloseDropDownMenus()
	entrySelect(nil, arg1)
end
function int:OnMouseWheel(delta)
	local d = getWidgetData(self, ScrollableBlockData)
	d.scrollBar:Step(-delta*WHEEL_STEP, true)
	int.SyncToBar(d, false)
end
function int:OnScrollChanged(_, internalEvent)
	if internalEvent then
		int.SyncToBar(getWidgetData(self:GetParent(), ScrollableBlockData), false)
	end
end
function int.SyncToBar(d, fullSync)
	local buttons, scrollBar, dataList, entryFormat = d.buttons, d.scrollBar, d.dataList, d.entryFormat
	local position, isDone = scrollBar:GetValue(), scrollBar:IsValueAtRest()
	positionArchive[dataList] = position
	local oy, baseOffset = (position % 1)*16, math.floor(position)
	d.origin:SetPoint("TOPLEFT", 0, oy)
	d.origin:SetPoint("TOPRIGHT", 0, oy)
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
				w:GetFontString():GetLeft() -- BUG[8.1.5] Without this, it sometimes gets lost.
			end
			w:SetEnabled(isDone)
		end
	end
end
if UIDropDownMenu_StopCounting then
	hoverWatcher = CreateFrame("Frame", nil, DropDownList1)
	hoverWatcher:Hide()
	hoverWatcher:SetScript("OnUpdate", function(self)
		for l=(DropDownList1.isCounting or self.suspended) and UIDROPDOWNMENU_MENU_LEVEL or 0, 1, -1 do
			local m = _G["DropDownList" .. l]
			if m and m:IsMouseOver() then
				self.suspended = true
				return DropDownList1.isCounting and UIDropDownMenu_StopCounting(DropDownList1)
			end
		end
		self.suspended = self.suspended and UIDropDownMenu_StartCounting(DropDownList1) and nil
	end)
	hoverWatcher:SetScript("OnHide", function(self) self.suspended = nil; self:Hide() end)
end

local function DisplayScrollableDropDownEntryList(level, dataList, entryFormatter, entrySelect, willContinue)
	assert(type(level) == "number", 'ScrollableDropDownList: level argument must be a number')
	assert(type(dataList) == "table", 'ScrollableDropDownList: dataList argument must be a table')
	assert(type(entryFormatter) == "function", 'ScrollableDropDownList: entryFormatter argument must be a function')
	assert(type(entrySelect) == "function", 'ScrollableDropDownList: entrySelect argument must be a function')
	if #dataList < MIN_SCROLL_ENTRIES then
		local info = {func=entrySelect, minWidth=level == 1 and UIDROPDOWNMENU_OPEN_MENU:GetWidth()-40 or nil}
		for i=1,#dataList do
			local k = dataList[i]
			info.arg1, info.text, info.checked = k, entryFormatter(k, dataList)
			UIDropDownMenu_AddButton(info, level)
		end
		return
	end
	local ddlName, maxV, arch =  "DropDownList" .. level, #dataList-MAX_VISIBLE_ENTRIES, positionArchive[dataList]
	local host, block, d = _G[ddlName], getFreeBlock()
	block.parent, d.dataList, d.entryFormat, d.entrySelect = host, dataList, entryFormatter, entrySelect
	block:SetParent(host)
	local n1, nX = host.numButtons+1, MAX_VISIBLE_ENTRIES + host.numButtons
	local minWidth, testFS = math.max(120, level == 1 and UIDROPDOWNMENU_OPEN_MENU:GetWidth()-40 or 0), d.buttons[1]:GetFontString()
	for i=1,#dataList do
		local text = entryFormatter(dataList[i], dataList)
		testFS:SetText(text)
		minWidth = math.max(minWidth, 60 + testFS:GetStringWidth())
	end
	local info = {notClickable=true, notCheckable=true, minWidth=minWidth}
	for i=n1,nX do
		UIDropDownMenu_AddButton(info, level)
	end
	local b1, bX = _G[ddlName .. "Button" .. n1], _G[ddlName .. "Button" .. nX]
	block:SetPoint("TOPLEFT", b1, 0, n1 == 1 and 5 or 0)
	d.clip:SetPoint("TOPLEFT", 0, n1 == 1 and -5 or 0)
	block:SetPoint("BOTTOMRIGHT", bX, "BOTTOMRIGHT", 0, willContinue and 0 or -4)
	d.scrollBar:SetMinMaxValues(0, maxV)
	d.scrollBar:SetValue(arch and arch <= maxV and arch or 0)
	int.SyncToBar(d, true)
	d.bottomTex:SetHeight(PixelUtil.GetPixelToUIUnitFactor()/block:GetEffectiveScale()*1.001)
	d.bottomTex:SetShown(not not willContinue)
	block:Show()
	block:SetFrameLevel(b1:GetFrameLevel()+2)
	d.scrollBar:SetFrameLevel(block:GetFrameLevel()+3)
	if hoverWatcher then hoverWatcher:Show() end
end

XU:RegisterFactory("ScrollableDropDownList", DisplayScrollableDropDownEntryList)