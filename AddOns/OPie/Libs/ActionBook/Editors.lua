local _, T = ...

local AB = assert(T.ActionBook:compatible(2, 23), "A compatible version of ActionBook is required.")
local MODERN = select(4,GetBuildInfo()) >= 8e4
local L = AB:locale()

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
	bg:SetBackdrop({edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=4,right=4,bottom=4,top=4}})
	bg:SetBackdropBorderColor(0.7,0.7,0.7)
	bg:SetBackdropColor(0,0,0,0.7)
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
		local text = eb:GetText():gsub("|c%x+|Hrk%d+:([%a:%d/]+)|h.-|h|r", "{{%1}}")
		into[1], into[2] = "macrotext", text
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


--[[ This API is not covered by the usual warranty.
     1. This is an internal convenience method; its signature may change.
        It's being exported (solely) because OPie's DataBroker bridge
        is implemented elsewhere and has a single option checkbox.
     2. Writing directly to the AB handle is a terrible idea.
        This may get renamed or moved to a separate :compatible() handle in
        the future.
    (3. It's self-less.)
--]]
AB._CreateSimpleEditorPanel = RegisterSimpleOptionsPanel