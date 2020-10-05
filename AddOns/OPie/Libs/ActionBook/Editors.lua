local _, T = ...

local AB = assert(T.ActionBook:compatible(2, 23), "A compatible version of ActionBook is required.")
local MODERN = select(4,GetBuildInfo()) >= 8e4
local L = AB:locale()

local CreateEdge do
	local edgeSlices = {
		{"TOPLEFT", 0, -1, "BOTTOMRIGHT", "BOTTOMLEFT", 1, 1}, -- L
		{"TOPRIGHT", 0, -1, "BOTTOMLEFT", "BOTTOMRIGHT", -1, 1}, -- R
		{"TOPLEFT", 1, 0, "BOTTOMRIGHT", "TOPRIGHT", -1, -1, ccw=true}, -- T
		{"BOTTOMLEFT", 1, 0, "TOPRIGHT", "BOTTOMRIGHT", -1, 1, ccw=true}, -- B
		{"TOPLEFT", 0, 0, "BOTTOMRIGHT", "TOPLEFT", 1, -1},
		{"TOPRIGHT", 0, 0, "BOTTOMLEFT", "TOPRIGHT", -1, -1},
		{"BOTTOMLEFT", 0, 0, "TOPRIGHT", "BOTTOMLEFT", 1, 1},
		{"BOTTOMRIGHT", 0, 0, "TOPLEFT", "BOTTOMRIGHT", -1, 1}
	}
	function CreateEdge(f, info, bgColor, edgeColor)
		local insets = info.insets
		local es = info.edgeFile and (info.edgeSize or 39) or 0
		if info.bgFile then
			local bg = f:CreateTexture(nil, "BACKGROUND", nil, -7)
			local tileBackground = not not info.tile
			bg:SetTexture(info.bgFile, tileBackground, tileBackground)
			bg:SetPoint("TOPLEFT", (insets and insets.left or 0), -(insets and insets.top or 0))
			bg:SetPoint("BOTTOMRIGHT", -(insets and insets.right or 0), (insets and insets.bottom or 0))
			local n = bgColor or 0xffffff
			bg:SetVertexColor((n - n % 2^16) / 2^16 % 256 / 255, (n - n % 2^8) / 2^8 % 256 / 255, n % 256 / 255, n >= 2^24 and (n - n % 2^24) / 2^24 % 256 / 255 or 1)
		end
		if info.edgeFile then
			local n = edgeColor or 0xffffff
			local r,g,b,a = (n - n % 2^16) / 2^16 % 256 / 255, (n - n % 2^8) / 2^8 % 256 / 255, n % 256 / 255, n >= 2^24 and (n - n % 2^24) / 2^24 % 256 / 255 or 1
			for i=1,#edgeSlices do
				local t, s = f:CreateTexture(nil, "BORDER", nil, -7), edgeSlices[i]
				t:SetTexture(info.edgeFile)
				t:SetPoint(s[1], s[2]*es, s[3]*es)
				t:SetPoint(s[4], f, s[5], s[6]*es, s[7]*es)
				local x1, x2, y1, y2 = 1/128+(i-1)/8, i/8-1/128, 0.0625, 1-0.0625
				if s.ccw then
					t:SetTexCoord(x1,y2, x2,y2, x1,y1, x2,y1)
				else
					t:SetTexCoord(x1, x2, y1, y2)
				end
				t:SetVertexColor(r,g,b,a)
			end
		end
	end
end

local multilineInput do
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
	function multilineInput(name, parent, width)
		local scroller = CreateFrame("ScrollFrame", name .. "Scroll", parent, "UIPanelScrollFrameTemplate")
		local input = CreateFrame("Editbox", name, scroller)
		input:SetWidth(width)
		input:SetMultiLine(true)
		input:SetAutoFocus(false)
		input:SetTextInsets(2,4,0,2)
		input:SetFontObject(GameFontHighlight)
		input:SetScript("OnCursorChanged", onNavigate)
		scroller:EnableMouse(1)
		scroller:SetScript("OnMouseDown", onClick)
		scroller:SetScrollChild(input)
		input.scroll, scroller.input = scroller, input
		return input, scroller
	end
end

do -- .macrotext
	local bg = CreateFrame("Frame")
	CreateEdge(bg, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=4,right=4,bottom=4,top=4}}, 0xb2000000, 0xb2b2b2)
	bg:Hide()
	local eb, scroll = multilineInput("ABE_MacroInput", bg, 511)
	eb:SetScript("OnEscapePressed", eb.ClearFocus)
	eb:SetScript("OnEditFocusLost", function()
		local p = bg:GetParent()
		p = p and p.SaveAction and p:SaveAction()
	end)
	scroll:SetPoint("TOPLEFT", 5, -4)
	scroll:SetPoint("BOTTOMRIGHT", -26, 4)
	eb:SetHyperlinksEnabled(true)
	eb:SetScript("OnHyperlinkClick", function(self, link, text, button)
		local pos = string.find(self:GetText(), text, 1, 1)-1
		self:HighlightText(pos, pos + #text)
		if button == "RightButton" and link:match("^rk%d+:") then
			local replace = IsAltKeyDown() and text:match("|h(.-)|h") or ("{{" .. link:match("^rk%d+:(.+)") .. "}}")
			self:Insert(replace)
			self:HighlightText(pos, pos + #replace)
		else
			self:SetCursorPosition(pos + #text)
		end
		self:SetFocus()
	end)
	local function removeEditorLinks(text)
		return (text:gsub("|c%x+|Hrk%d+:([%a:%d/]+)|h.-|h|r", "{{%1}}"))
	end
	local function GetHighlightText(editBox)
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
	local function ReplaceSelection(editBox, newSelText)
		editBox:Insert(newSelText)
		local cur = editBox:GetCursorPosition()
		editBox:HighlightText(cur-#newSelText, cur)
	end
	eb:SetScript("OnKeyDown", function(self, key)
		if (key == "C" or key == "X") and IsControlKeyDown() then
			local stext = GetHighlightText(self)
			if stext:match("[^|]|H.+|h.*|h") then
				ReplaceSelection(self, removeEditorLinks(stext))
				if key == "C" then
					self._rsText = stext
				end
			end
		end
	end)
	eb:SetScript("OnUpdate", function(self)
		if self._rsText then
			ReplaceSelection(self, self._rsText)
			self._rsText = nil
		end
	end)
	
	local decodeSpellLink do
		local names, tag = {}, 0
		function decodeSpellLink(token, sid)
			local forceRank, tname = token == "spellr"
			for id in sid:gmatch("%d+") do
				local name, sr = GetSpellInfo(tonumber(id)), GetSpellSubtext(tonumber(id))
				if sr and sr ~= "" and (forceRank or MODERN) then name = name .. " (" .. sr .. ")" end
				if name and names[name] ~= tag then
					names[name], tname = tag, (tname and (tname .. " / ") or "") .. name
				end
			end
			tag = tag + 1
			return tname and ("|cff71d5ff|Hrk" .. token .. ":" .. sid .. "|h" .. tname .. "|h|r")
		end
	end
	local tagCounter = 0
	local function tagReplace()
		tagCounter = tagCounter + 1
		return "|Hrk" .. tagCounter .. ":"
	end
	function bg:SetAction(owner, action)
		bg:SetParent(nil)
		bg:ClearAllPoints()
		bg:SetAllPoints(owner)
		bg:SetParent(owner)
		bg:Show()
		tagCounter = 0
		eb:SetText((
			(action[1] == "macrotext" and type(action[2]) == "string" and action[2] or "")
			:gsub("{{(spellr?):([%d/]+)}}", decodeSpellLink)
			:gsub("{{mount:ground}}", "|cff71d5ff|Hrkmount:ground|h" .. L"Ground Mount" .. "|h|r")
			:gsub("{{mount:air}}", "|cff71d5ff|Hrkmount:air|h" .. L"Flying Mount" .. "|h|r")
			:gsub("|Hrk", tagReplace)
		))
	end
	function bg:GetAction(into)
		into[1], into[2] = "macrotext", removeEditorLinks(eb:GetText())
	end
	function bg:Release(owner)
		if bg:IsOwned(owner) then
			bg:SetParent(nil)
			bg:ClearAllPoints()
			bg:Hide()
		end
	end
	function bg:IsOwned(owner)
		return bg:GetParent() == owner
	end
	bg.editBox, bg.scrollFrame = bg, eb
	do -- Hook linking
		local old = ChatEdit_InsertLink
		function ChatEdit_InsertLink(link, ...)
			if GetCurrentKeyBoardFocus() == eb then
				local isEmpty = eb:GetText() == ""
				if link:match("item:") then
					eb:Insert((isEmpty and (GetItemSpell(link) and SLASH_USE1 or SLASH_EQUIP1) or "") .. " " .. GetItemInfo(link))
				elseif link:match("spell:") and not IsPassiveSpell(tonumber(link:match("spell:(%d+)"))) then
					eb:Insert((isEmpty and SLASH_CAST1 or "") .. " " .. decodeSpellLink(link:match("(spell):(%d+)")):gsub("|Hrk", tagReplace))
				else
					eb:Insert(link:match("|h%[?(.-[^%]])%]?|h"))
				end
				return true
			else
				return old(link, ...)
			end
		end
	end
	AB:RegisterEditorPanel("macrotext", bg)
end

local RegisterSimpleOptionsPanel do
	local f, e = CreateFrame("Frame")
	f:Hide()
	f.Options = {}
	local function callSave()
		local p = f:GetParent()
		if p and p.SaveAction then
			p:SaveAction()
		end
	end
	for i=1,3 do
		e = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
		e:SetHitRectInsets(0, -200, 4, 4)
		e:SetMotionScriptsWhileDisabled(1)
		e:SetScript("OnClick", callSave)
		e:SetPoint("TOPRIGHT", -261, 23-21*i)
		f.Options[i] = e
	end

	local optionsForHandle, curHandle, curHandleID = {}
	local function IsOwned(self, host)
		return curHandle == optionsForHandle[self] and f:GetParent() == host
	end
	local function Release(self, host)
		if IsOwned(self, host) then
			curHandle, curHandleID = nil
			f:SetParent(nil)
			f:ClearAllPoints()
			f:Hide()
		end
	end
	local function SetAction(self, host, actionTable)
		local opts = optionsForHandle[self]
		assert(actionTable[1] == opts[0], "Invalid editor")
		f:SetParent(nil)
		f:ClearAllPoints()
		f:SetAllPoints(host)
		f:SetParent(host)
		curHandle, curHandleID = opts, actionTable[2]
		local getState = opts.getOptionState
		for i=1,#opts do
			local w, oi, isChecked = f.Options[i], opts[i], false
			w.Text:SetText(opts[oi])
			if getState then
				isChecked = getState(actionTable, oi)
			elseif actionTable[opts[i]] ~= nil then
				isChecked = not not actionTable[oi]
			end
			w:SetChecked(isChecked)
			w:Show()
		end
		for i=#opts+1,#f.Options do
			f.Options[i]:Hide()
		end
		f:Show()
	end
	local function GetAction(self, into)
		local opts = optionsForHandle[self]
		into[1], into[2] = opts[0], curHandleID
		for i=1,#opts do
			into[opts[i]] = f.Options[i]:GetChecked() or nil
		end
		if opts.saveState then
			opts.saveState(into)
		end
	end
	function RegisterSimpleOptionsPanel(atype, opts)
		local r = {IsOwned=IsOwned, Release=Release, SetAction=SetAction, GetAction=GetAction}
		optionsForHandle[r], opts[0] = opts, atype
		AB:RegisterEditorPanel(atype, r)
	end
end

RegisterSimpleOptionsPanel("item", {"byName", "forceShow", "onlyEquipped",
	byName=L"Also use items with the same name",
	forceShow=L"Show a placeholder when unavailable",
	onlyEquipped=L"Only show when equipped"
})
RegisterSimpleOptionsPanel("macro", {"forceShow",
	forceShow=L"Show a placeholder when unavailable",
})
if MODERN then
	RegisterSimpleOptionsPanel("extrabutton", {"forceShow",
		forceShow=L"Show a placeholder when unavailable",
	})
	RegisterSimpleOptionsPanel("toy", {"forceShow",
		forceShow=L"Show a placeholder when unavailable",
	})
else
	RegisterSimpleOptionsPanel("spell", {"upRank",
		upRank=L"Use the highest known rank",
		getOptionState=function(actionTable, _optKey)
			return actionTable[3] ~= "lock-rank"
		end,
		saveState=function(intoTable)
			intoTable[3], intoTable.upRank = not intoTable.upRank and "lock-rank" or nil
		end,
	})
end


--[[ These functions are not covered by the usual API warranty; do not rely on
     them to exist or behave the way they do now in the future.
     Writing directly to this table is also terrible.
--]]
T.ActionBook._CreateSimpleEditorPanel = RegisterSimpleOptionsPanel
T.ActionBook._CreateEdge = CreateEdge