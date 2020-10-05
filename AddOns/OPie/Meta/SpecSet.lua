local _, T = ...
if select(4,GetBuildInfo()) < 8e4 then return end

local EV, L = T.Evie, T.L
local AB = assert(T.ActionBook:compatible(2,23), "A compatible version of ActionBook is required.")
local RW = assert(AB:compatible("Rewire", 1,7), "A compatible version of Rewire is required")
local CHARNAME = UnitName("player") .. "@" .. GetRealmName()

do -- RW/opiespecset
	local f = CreateFrame("Frame", nil, nil, "SecureFrameTemplate")
	f:SetAttribute("RunSlashCmd", [[self:CallMethod("SwitchSpec", ...)]])
	local esSpec, esSet, esDeadline
	function EV:PLAYER_SPECIALIZATION_CHANGED(unit)
		if esDeadline and unit == "player" and GetSpecialization() == esSpec and not InCombatLockdown() and esDeadline > GetTime() then
			local sid = C_EquipmentSet.GetEquipmentSetID(esSet)
			esDeadline, esSpec, esSet = sid and C_EquipmentSet.UseEquipmentSet(sid) and nil
		end
	end
	function f:SwitchSpec(_cmd, args)
		local sid, sname = args:match("(%d+) {(.*)}")
		sid = tonumber(sid)
		if GetSpecialization() ~= sid and not InCombatLockdown() then
			SetSpecialization(sid)
			if sname ~= "" then
				esSpec, esSet, esDeadline = sid, sname, GetTime()+9
			end
		end
	end
	RW:RegisterCommand("/opiespecset", false, false, f)
end
do -- AB/specset
	local slot, tspec, tset = {}, {}, {}
	local function SetSpecializationTooltip(self, id, set)
		local _, name, desc = GetSpecializationInfo(id)
		if name then
			self:SetText(name, 1,1,1)
			self:AddLine(desc, nil, nil, nil, 1)
			if (set or "") ~= "" then
				local _, ico, _, _isCur, total, eq, bags, miss = C_EquipmentSet.GetEquipmentSetInfo(C_EquipmentSet.GetEquipmentSetID(set) or -1)
				if ico then
					local eql
					if total == eq then
						eql = GREEN_FONT_COLOR_CODE .. ITEMS_EQUIPPED:format(eq)
					elseif miss > 0 then
						eql = RED_FONT_COLOR_CODE .. ITEMS_NOT_IN_INVENTORY:format(miss)
					else
						eql = NORMAL_FONT_COLOR_CODE .. ITEMS_IN_INVENTORY:format(bags)
					end
					self:AddLine(" ")
					self:AddLine("|T" .. ico .. ":0|t " .. set .. ": " .. eql, 1,1,1)
				end
			end
		else
			self:Hide()
		end
	end
	local function SetSpecSetTooltip(self, tok)
		local spec, set = tspec[tok], tset[tok]
		if spec == nil then
			spec, set = 0+tok:sub(1,1), tok:sub(3)
			tspec[tok], tset[tok] = spec, set
		end
		SetSpecializationTooltip(self, spec, set)
	end
	local function hintSpecSet(tok)
		local cs, spec, set = GetSpecialization(), tspec[tok], tset[tok]
		if spec == nil then
			spec, set = 0+tok:sub(1,1), tok:sub(3)
			tspec[tok], tset[tok] = spec, set
		end
		local _, name, _, ico = GetSpecializationInfo(spec)
		local state = (cs == spec and 1 or 0)
		return (HasFullControl() and not InCombatLockdown()), state, ico, name, 0, 0, 0, SetSpecSetTooltip, tok
	end
	local function createSpecSet(idx, sets)
		local _, specName = GetSpecializationInfo(idx)
		local setName = sets and sets[CHARNAME]
		setName = setName ~= false and (setName or specName) or ""
		local tk = idx .. "#" .. setName
		local ret = slot[tk]
		if specName and UnitLevel("player") >= 10 and GetNumSpecializations() >= idx and not ret then
			ret = AB:GetActionSlot("macrotext", ("/cancelform [nospec:%d,form:travel,flyable,noflying,nocombat]\n/opiespecset %d {%s}\n%s [spec:%d] %s"):format(idx, idx, setName, SLASH_EQUIP_SET1, setName ~= "" and idx or 5, setName))
			ret = AB:CreateActionSlot(hintSpecSet, tk, "clone", ret)
			slot[tk] = ret
		end
		return ret
	end
	local function describeSpecSet(idx, _sets)
		local _, name, _, ico = GetSpecializationInfo(idx)
		return SPECIALIZATION, name or idx, ico or "Interface/Icons/Temp", nil, SetSpecializationTooltip, idx
	end
	AB:RegisterActionType("specset", createSpecSet, describeSpecSet)
	AB:AugmentCategory("Miscellaneous", function(_, add)
		for i=1,GetNumSpecializations() do
			add("specset", i)
		end
	end)
end
do -- EditorUI
	local bg = CreateFrame("Frame")
	local drop = CreateFrame("Frame", "OPie_SSDrop", bg, "UIDropDownMenuTemplate")
	local lab = drop:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	local myPlayerMap, mySpecID, mySpecName
	lab:SetPoint("LEFT", bg, "TOPLEFT", 0, -18)
	lab:SetText(L"Equip set:")
	drop:SetPoint("TOPRIGHT", -3, -2)
	UIDropDownMenu_SetWidth(drop, 250)
	
	local function getCurrentValue()
		local value = nil
		if myPlayerMap and myPlayerMap[CHARNAME] ~= nil then
			value = myPlayerMap[CHARNAME]
		end
		if value == nil then
			value = mySpecName
		end
		return value
	end
	function drop:text()
		local name = getCurrentValue()
		local _, ico = C_EquipmentSet.GetEquipmentSetInfo(name and C_EquipmentSet.GetEquipmentSetID(name) or -1)
		UIDropDownMenu_SetText(drop, name == false and NONE or ((ico and "|T" .. ico .. ":0|t " or "|cffc02020") .. name))
	end
	function drop:set(name)
		if name == mySpecName then
			name = nil
		end
		if myPlayerMap or name ~= nil then
			myPlayerMap = myPlayerMap or {}
			myPlayerMap[CHARNAME] = name
			if name == nil and next(myPlayerMap) == nil then
				myPlayerMap = nil
			end
		end
		drop:text() -- SaveAction would normally cause a refresh via :SetAction.
		local p = bg:GetParent()
		p = p and p.SaveAction and p:SaveAction()
	end
	function drop:initialize()
		local value = getCurrentValue()
		local inf, hadSpec = {func=self.set, minWidth=self:GetWidth()-40}, false
		inf.text, inf.arg1, inf.checked = NONE, false, value == false
		UIDropDownMenu_AddButton(inf)
		for _, id in pairs(C_EquipmentSet.GetEquipmentSetIDs()) do
			local n, ico = C_EquipmentSet.GetEquipmentSetInfo(id)
			inf.text, inf.arg1, inf.checked = "|T" .. (ico or "Interface/Icons/Temp") .. ":0|t " .. n, n, value == n
			hadSpec = hadSpec or n == mySpecName
			UIDropDownMenu_AddButton(inf)
		end
		if not hadSpec and mySpecName then
			inf.text, inf.arg1, inf.checked = mySpecName, mySpecName, value == nil or value == mySpecName
			UIDropDownMenu_AddButton(inf)
		end
	end

	--[[ The action format is: "specset", specIndex, {CHARNAME => equipSetName}
	     The map in [3] is needed to allow different characters to use the
	     "same" specset action to equip different sets. This editor only changes
	     the set equipped by the current character. However, the table causes some
	     degree of alarm: other code has pointers to it (and could modify it while
	     we're not looking), this editor could modify the original table without
	     intending to save its changes (possibly bypassing the host's undo
	     functionality), and :GetAction(into) needs us to write the full action
	     into an empty table (so keeping just this character's set name
	     internally isn't an option).

	     Current editor, action, and editor host implementations would be fine
	     with us keeping, mutating, and handing back the original table. To avoid
	     headaches in the future, we nevertheless create copies in both :GetAction
	     and :SetAction. What's a little table churn between friends?
	--]]
	local function shallowCopy(t)
		if type(t) ~= "table" then
			return nil
		end
		local r = {}
		for k,v in pairs(t) do
			r[k] = v
		end
		return r
	end
	function bg:SetAction(owner, action)
		bg:SetParent(nil)
		bg:ClearAllPoints()
		bg:SetAllPoints(owner)
		bg:SetParent(owner)
		bg:Show()

		mySpecID, myPlayerMap = action[2], shallowCopy(action[3])
		if type(myPlayerMap) ~= "table" then
			myPlayerMap = nil
		end
		mySpecName = select(2, GetSpecializationInfo(mySpecID))
		drop:SetShown(not not mySpecName)
		if mySpecName then
			drop:text()
		end
	end
	function bg:GetAction(into)
		into[1], into[2], into[3] = "specset", mySpecID, shallowCopy(myPlayerMap)
	end
	function bg:Release(owner)
		if bg:IsOwned(owner) then
			bg:SetParent(nil)
			bg:ClearAllPoints()
			bg:Hide()
			myPlayerMap, mySpecID, mySpecName = nil
		end
	end
	function bg:IsOwned(owner)
		return bg:GetParent() == owner
	end
	
	AB:RegisterEditorPanel("specset", bg)
end