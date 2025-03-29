local COMPAT, _, T = select(4, GetBuildInfo()), ...
if COMPAT < 3e4 then return end

local EV, XU, AB = T.Evie, T.exUI, T.ActionBook:compatible(2, 45)
assert(EV and XU and AB and 1, "Incompatible library bundle")
local L, ABL = T.L, AB.L

do -- action handler
	local actions = {}
	local syncSetSet do
		local setNames, col, isCurrent, markCurrent
		local function cmpSetName(a, b)
			return strcmputf8i(a,b) < 0
		end
		local function initEQS2()
			local setNamesB, namesStale, colsStale = {}, true, false
			local syncGen, actionGen, actionPattern = 200, {}, {}
			setNames, col = {}, {__embed=true}
			local function bufferSetNames()
				local ni, namesChanged = 1
				for _,id in pairs(C_EquipmentSet.GetEquipmentSetIDs()) do
					setNamesB[ni], ni = C_EquipmentSet.GetEquipmentSetInfo(id), ni + 1
				end
				for i=ni, #setNamesB do
					setNamesB[i] = nil
				end
				table.sort(setNamesB, cmpSetName)
				namesStale, setNames, setNamesB = false, setNamesB, setNames
				namesChanged = #setNames ~= #setNamesB
				for i=1, namesChanged and 0 or #setNames do
					if setNames[i] ~= setNamesB[i] then
						namesChanged = true
						break
					end
				end
				if namesChanged then
					syncGen, colsStale = syncGen + 1, true
				end
			end
			function isCurrent(id)
				if namesStale then
					bufferSetNames()
				end
				return actionGen[id] == syncGen
			end
			function markCurrent(id, fp)
				actionPattern[id], actionGen[id] = fp, syncGen
			end
			function EV.EQUIPMENT_SETS_CHANGED()
				namesStale = true
			end
			function EV.PLAYER_REGEN_DISABLED()
				if namesStale then
					bufferSetNames()
				end
				if colsStale then
					for id, fp in pairs(actionPattern) do
						if actionGen[id] ~= syncGen then
							syncSetSet(fp, id)
						end
					end
					colsStale = false
				end
			end
			AB:AddObserver("internal.collection.preopen", function(_, _, id)
				local fp = actionPattern[id]
				if fp and not InCombatLockdown() and not isCurrent(id) then
					syncSetSet(fp, id)
				end
			end)
			initEQS2 = nil
		end
		function syncSetSet(fp, id)
			if initEQS2 then
				initEQS2()
			end
			if InCombatLockdown() or isCurrent(id) then
				return id
			end
			for i=1, #col do
				col[i], col[col[i] or 1] = nil
			end
			id = id or AB:CreateActionSlot(nil,nil, "collection",col)
			local ni, smatch = 1, string.match
			for i=1, #setNames do
				local name = setNames[i]
				if smatch(name, fp) then
					local said = AB:GetActionSlot("equipmentset", name)
					if said then
						local tk = "OPEQS2c" .. id .. "s" .. said
						col[ni], col[tk], ni = tk, said, ni + 1
					end
				end
			end
			markCurrent(id, fp)
			AB:UpdateActionSlot(id, col)
			return id
		end
	end
	local function describeEquipSetSet(filter)
		filter = (filter or "") ~= "" and filter or ("|cff0077cc" .. L"(All sets)" .. "|r")
		return L"Equipment Sets", filter, "Interface/Icons/INV_Pants_01", nil, nil, nil, "collection"
	end
	local function createEquipSetSet(filter)
		if type(filter) ~= "string" then return end
		local aid = actions[filter]
		if aid == nil then
			local fp = filter:gsub("[][%%()?.*+-]", "%%%0")
			aid = syncSetSet(fp)
			actions[filter] = aid
		end
		return aid
	end
	AB:RegisterActionType("opie.eqset2", createEquipSetSet, describeEquipSetSet, 1)
end
AB:AddActionToCategory(ABL"Equipment sets", "opie.eqset2", "")

local editor, edFrame, edFilter, edValue = {}
local function initEditor()
	edFrame = CreateFrame("Frame")
	edFrame:Hide()
	local s = edFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	s:SetText(L"Set name filter:")
	s:SetPoint("TOPLEFT", 0.5, -4)
	edFilter = XU:Create("LineInput", nil, edFrame)
	edFilter:SetScript("OnEnterPressed", edFilter.ClearFocus)
	edFilter:SetScript("OnEscapePressed", function(self)
		self:SetText(edValue)
		self:ClearFocus()
	end)
	edFilter:SetScript("OnEditFocusLost", function(self)
		local text = self:GetText()
		if text == edValue then return end
		edValue = text
		local p = edFrame and edFrame:GetParent()
		if p and type(p.OnActionChanged) == "function" then
			p:OnActionChanged(editor)
		end
	end)
	initEditor = nil
	return edFrame
end
function editor:SetAction(owner, action)
	local op = (edFrame or initEditor()):GetParent()
	if op and op ~= owner and type(op.OnEditorRelease) == "function" then
		securecall(op.OnEditorRelease, op, self)
	end
	edFrame:SetParent(nil)
	edFrame:ClearAllPoints()
	edFrame:SetAllPoints(owner)
	edFrame:SetParent(owner)
	edFrame:Show()
	local ofsX, ofsY, ofsR = owner.optionsColumnOffset, -2, -5.5
	ofsX = type(ofsX) == "number" and (ofsX + 7.5)
	edFrame:GetLeft()
	if not ofsX or (ofsX + 200) > (edFrame:GetWidth() or 0) then
		ofsX, ofsY, ofsR = 6.5, -20, -6.5
	end
	edFilter:SetPoint("TOPLEFT", ofsX, ofsY)
	edFilter:SetPoint("TOPRIGHT", ofsR, ofsY)
	edValue = action[2]
	edFilter:SetText(edValue)
	edFilter:SetCursorPosition(0)
end
function editor:GetAction(into)
	into[1], into[2] = "opie.eqset2", edFilter and edFilter:HasFocus() and edFilter:GetText() or edValue or ""
end
function editor:IsOwned(owner)
	return edFrame and edFrame:GetParent() == owner
end
function editor:Release(owner)
	if edFrame and editor:IsOwned(owner) then
		edFrame:SetParent(nil)
		edFrame:ClearAllPoints()
		edFrame:Hide()
	end
end
AB:RegisterEditorPanel("opie.eqset2", editor)