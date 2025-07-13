local AB, _, T = assert(OPie.ActionBook:compatible(2,14), "Requires a compatible version of ActionBook"), ...
if T.TenEnv then T.TenEnv() end

local ORI, EV, L, PC, XU, config = OPie.UI, T.Evie, T.L, T.OPieCore, T.exUI, T.config
local COMPAT = select(4,GetBuildInfo())
local MODERN, CF_WRATH = COMPAT >= 10e4, COMPAT < 10e4 and COMPAT >= 3e4
local GameTooltip = T.NotGameTooltip or GameTooltip

local exclude, questItems = PC:RegisterPVar("AutoQuestExclude", {}), {}
local IsQuestItem, IsQuestItemF, disItems
local function getContainerItemQuestInfo(bag, slot)
	if bag and slot then
		local iqi = C_Container.GetContainerItemQuestInfo(bag, slot)
		return iqi.isQuestItem, iqi.questID, iqi.isActive
	end
end
if MODERN or CF_WRATH then
	questItems[30148] = {72986, 72985}
	local include, filtered do
		local function isInPrimalistFutureScenario()
			return C_TaskQuest.IsActive(74378) and C_Scenario.IsInScenario() and select(8, GetInstanceInfo()) == 2512
		end
		local function isOnKeysOfLoyalty()
			local q = C_QuestLog.IsOnQuest
			return q(66805) or q(66133)
		end
		local function have1()
			return true, false, false, 4
		end
		local function have3(iid)
			return C_Item.GetItemCount(iid) > 2, false, false, 4
		end
		local function have1_lv80()
			if (UnitLevel("player") or 0) >= 80 then
				return true, false, false, 4
			end
		end
		local function c1()
			return true, false, false, 3
		end
		local function c100_lv80(iid)
			return C_Item.GetItemCount(iid) > 99 and (UnitLevel("player") or 0) >= 80, false, false, 3
		end
		local function haveInterestingNotes()
			return C_Item.GetItemCount(227406) > 0, false, false, 3
		end
		local function ebIsNotRockReviver()
			local at, sid = GetActionInfo(GetExtraBarIndex()*12-11)
			return at ~= "spell" or sid ~= 463623, false, false, nil
		end
		local function ebIsNotGoPack()
			local at, sid = GetActionInfo(GetExtraBarIndex()*12-11)
			return at ~= "spell" or (sid ~= 467294 and sid ~= 469807), false, false, nil
		end
		local function crownChemical()
			local _,_,_,_, _,_,_,imid, _,did = GetInstanceInfo()
			return imid == 33 and did == 288
		end
		local mapMarker = c1
		include = {
			[21746]=have1, -- lucky red envelope
			[33634]=true, [35797]=true, [37888]=true, [37860]=true, [37859]=true, [37815]=true, [46847]=true, [47030]=true, [39213]=true, [42986]=true, [49278]=true,
			[86425]={31332, 31333, 31334, 31335, 31336, 31337}, [90006]=true, [86536]=true, [86534]=true,
			[49351]=crownChemical, [49352]=crownChemical, -- perfume/cologne neutralizers
			[180008]=-60609, [180009]=-60609, [180170]=-60649,
			[174464]=true, [168035]=true,
			[191251]=isOnKeysOfLoyalty, [202096]=isInPrimalistFutureScenario, [203478]=isInPrimalistFutureScenario,
			[194540]=mapMarker, [198843]=mapMarker, [198852]=mapMarker, [198854]=mapMarker, [199061]=mapMarker, [199062]=mapMarker, [199065]=mapMarker,
			[199066]=mapMarker, [199067]=mapMarker, [199068]=mapMarker, [199069]=mapMarker, [200738]=mapMarker, [202667]=mapMarker, [202668]=mapMarker,
			[202669]=mapMarker, [202670]=mapMarker,
			[204911]=have1,
			[205254]=c1, -- Honorary Explorer's Compass
			[199192]=have1, [204359]=have1, [205226]=have1, [210549]=have1, [227450]=have1,  -- racer's purse
			-- TWW inscription treatises [weekly]
			[222546]=83725, [222547]=83735, [222548]=83730, [222549]=83732, [222550]=83727, [222551]=83731,
			[222552]=83729, [222553]=83733, [222554]=83726, [222621]=83728, [222649]=83734,
			[224292]=-81691, [224913]=-81691, -- radiant fuel shard/cache
			[228741]=have1, -- lamplighter supply satchel
			[229899]=c100_lv80, [236096]=c100_lv80, -- coffer key shard
			[217011]=have1, [217012]=have1, [217013]=have1, -- (isle of dorn) actor's chest
			[235151]=have1, -- distinguished actor's chest
			[227792]=have1, -- everyday cache
			[227713]=have1, -- art consortium payout
			[226263]=have1, [239128]=have1, -- theater troupe's trove
			[226264]=have1, [239126]=have1, -- radiant cache
			[226273]=have1, [239121]=have1, -- awakened mechanical cache
			[225571]=have1, [225572]=have1, [225573]=have1, -- weaver/general/vizier weekly caches
			[239125]=have1, [239122]=have1, [239124]=have1, -- ditto, s2
			[226103]=have1, [226045]=have1, [226100]=have1, -- weaver/general/vizier rep troves
			[225247]=have1, [225246]=have1, [225239]=have1, [225245]=have1, [232463]=have1, -- overflowing troves [11.x]
			[229354]=have1, -- algari adventurer's cache
			[228361]=have1_lv80, [239120]=have1_lv80, [235610]=have1_lv80, [235639]=have1_lv80, -- seasoned adventurer's cache
			[224784]=have1_lv80, [239118]=have1_lv80, -- pinnacle cache
			[169219]=c1, -- brewfest sampler
			[225249]=c1, -- bag o' gold
			[235548]=have1, [232372]=have1, [234816]=c1, -- siren isle cache, bygone riches, bag of iron
			[236756]=c1, [236757]=c1, [236758]=c1, -- undermine tip chests
			[238207]=have1, [238208]=have1, -- surge dividends
			[229129]=have1, -- delver's spoils
			[220152]=c1, -- cursed ghoulfish
			[237743]=have1, [237759]=have1, [237760]=have1, -- nightfall participation coffers
			[239004]=have1, [239546]=have1, -- nightfall quest/scenario completion
		}
		filtered = {
			[228988]=ebIsNotRockReviver, -- siren isle rock reviver
			[230795]=ebIsNotGoPack, -- experimental go-pack, intro quest
			[227405]=haveInterestingNotes, -- siren isle research journal
			[224292]=have3, -- radiant fuel shard
		}
		for i in (CF_WRATH and "33634 35797 37888 37860 37859 37815 46847 47030 39213 42986 49278" or ""):gmatch("%d+") do
			include[i+0] = true
		end
	end
	local includeSpell = {
		[GetSpellInfo(375806) or 0]=3,
		[GetSpellInfo(411602) or 0]=3,
		[GetSpellInfo(409074) or 0]=3,
		[GetSpellInfo(409490) or 0]=3,
		[GetSpellInfo(409643) or 0]=3,
	}
	includeSpell[0] = nil
	disItems = {
		[198798]=3, [198800]=3, [201359]=3, [198675]=3, [198694]=3, [198689]=3, [198799]=3, [201358]=3,
		[201356]=3, [201357]=3, [201360]=3, [204990]=3, [205001]=3, [204999]=3,
		[200939]=3, [200940]=3, [200941]=3, [200942]=3, [200943]=3, [200945]=3, [200946]=3, [200947]=3,
		[210231]=3, [210228]=3, [210234]=3,
	}
	setmetatable(exclude, {__index={
		[204561]=1,
		[232466]=1, -- leave the storm, siren isle
	}})
	function IsQuestItem(iid, bag, slot)
		if exclude[iid] or not iid then
			return false
		elseif disItems[iid] then
			return true, false, disItems[iid]
		end
		local tinc, rcat
		local inc, ff, isQuest, startQuestId, isQuestActive = include[iid], filtered[iid], getContainerItemQuestInfo(bag, slot)
		isQuest = iid and ((isQuest and C_Item.GetItemSpell(iid)) or (inc == true) or (startQuestId and not isQuestActive and not C_QuestLog.IsQuestFlaggedCompleted(startQuestId)))
		if ff then
			isQuest, startQuestId, isQuestActive, rcat = ff(iid)
		end
		tinc = inc and not isQuest and type(inc)
		if tinc == "function" then
			isQuest, startQuestId, isQuestActive, rcat = inc(iid)
		elseif tinc then
			isQuest = not ff or isQuest
			for i=tinc == "number" and 1 or #inc, 1, -1 do
				local qid, wq = tinc == "number" and inc or inc[i]
				wq, qid = qid < 0, qid < 0 and -qid or qid
				if C_QuestLog.IsQuestFlaggedCompleted(qid) or
				   wq and not C_QuestLog.IsOnQuest(qid) then
					return false
				end
			end
		end
		if inc == nil and not isQuest then
			local isn, isid = C_Item.GetItemSpell(iid)
			if isid and includeSpell[isn] and IsUsableSpell(isid) then
				isQuest, startQuestId, rcat = true, false, includeSpell[isn]
			end
		end
		return isQuest, startQuestId and not isQuestActive, rcat
	end
	function IsQuestItemF(iid)
		local ff = filtered[iid]
		return ff == nil or ff(iid)
	end
else
	local include = PC:RegisterPVar("AutoQuestWhitelist", {}) do
		local hexclude = {}
		for i in ("12460 12451 12450 12455 12457 12458 12459"):gmatch("%d+") do
			hexclude[i+0] = true
		end
		setmetatable(exclude, {__index=hexclude})
	end
	local QUEST_ITEM = Enum.ItemClass.Questitem
	function IsQuestItem(iid, bag, slot, skipTypeCheck)
		local isQuest, startsQuest = false, false
		if exclude[iid] or not iid then
			return false
		elseif include[iid] then
			isQuest = true
		elseif not (C_Item.GetItemSpell(iid) and not exclude[iid]) then
		elseif select(12, C_Item.GetItemInfo(iid)) == QUEST_ITEM then
			isQuest = true
		elseif skipTypeCheck then
			include[iid], isQuest = true, true
		end
		if CF_WRATH and bag and slot then
			local _isQuestItem, startQuestId, isQuestActive = getContainerItemQuestInfo(bag, slot)
			startsQuest = startQuestId and not isQuestActive and not C_QuestLog.IsQuestFlaggedCompleted(startQuestId) or false
			isQuest = isQuest or startsQuest
		end
		return isQuest, startsQuest
	end
	function IsQuestItemF(_iid)
		return true
	end

	local lastQuestAcceptTime = GetTime()-20
	function EV.QUEST_ACCEPTED()
		lastQuestAcceptTime = GetTime()
	end
	function EV:CHAT_MSG_LOOT(text)
		local iid = text:match("|Hitem:(%d+).-|h")
		if iid and (GetTime()-lastQuestAcceptTime) < 1 then
			IsQuestItem(iid+0, nil, nil, true)
		end
	end
end
local GetQuestLogTitle = GetQuestLogTitle or function(i)
	local q = C_QuestLog.GetInfo(i)
	if q then
		local qid = q.questID
		return nil, nil, nil, q.isHeader, q.isCollapsed, C_QuestLog.IsComplete(qid), nil, qid
	end
end

local colId, current, changed, pendingChanges
local collection, inring, tokItemID, ctok = {__embed=true}, {}, {}, 0
local addSlice, sortQICollection do
	local tokCat, colOrder = {}, {}
	function addSlice(tok, cat, at, ...)
		if inring[tok] then
			inring[tok], tokCat[tok] = current, cat
		else
			local slot = AB:GetActionSlot(at, ...)
			if slot then
				inring[tok], tokCat[tok] = current, cat
				collection[#collection+1], collection[tok], changed = tok, slot, true
				if at == "item" or at == "disenchant" then
					tokItemID[tok] = ...
				end
			end
		end
		return tok
	end
	local function cmpEntry(a, b)
		local ac, bc = tokCat[a], tokCat[b]
		if ac ~= bc then
			if (not ac) ~= (not bc) then
				return not ac
			end
			return ac < bc
		end
		return colOrder[a] < colOrder[b]
	end
	function sortQICollection()
		for i=1, #collection do
			colOrder[collection[i]] = i
		end
		for k in pairs(tokCat) do
			if not inring[k] then
				tokCat[k], tokItemID[k] = nil
			end
		end
		table.sort(collection, cmpEntry)
	end
end
local function scanQuests(i)
	for i=i or 1, (MODERN and C_QuestLog.GetNumQuestLogEntries or GetNumQuestLogEntries)() do
		local _, _, _, isHeader, isCollapsed, isComplete, _, qid = GetQuestLogTitle(i)
		if isHeader and isCollapsed then
			ExpandQuestHeader(i)
			return scanQuests(i+1), CollapseQuestHeader(i)
		elseif questItems[qid] and not isComplete then
			for _, iid in ipairs(questItems[qid]) do
				if not exclude[iid] and IsQuestItemF(iid) then
					addSlice("OPbQIi" .. iid, 2, "item", iid)
					break
				end
			end
		elseif MODERN then
			local link, _, _, showWhenComplete = GetQuestLogSpecialItemInfo(i)
			if link and (showWhenComplete or not isComplete) then
				local iid = tonumber((link:match("item:(%d+)")))
				if not exclude[iid] and IsQuestItemF(iid) then
					addSlice("OPbQIi" .. iid, 2, "item", iid)
				end
			end
		end
	end
end
local function syncRing(_, event, upId)
	if event ~= "internal.collection.preopen" or upId ~= colId then return end
	changed, current = false, (ctok + 1) % 2

	local ns = C_Container.GetContainerNumSlots
	local giid = C_Container.GetContainerItemID
	for bag=0,MODERN and 5 or 4 do
		for slot=1, ns(bag) or 0 do
			local iid = giid(bag, slot)
			local include, startsQuestMark, qiCat = IsQuestItem(iid, bag, slot)
			if include then
				local tok = addSlice("OPbQIi" .. iid, qiCat or 2, disItems and disItems[iid] and "disenchant" or "item", iid)
				ORI:SetQuestHint(tok, startsQuestMark)
			end
		end
	end
	for i=0,INVSLOT_LAST_EQUIPPED do
		local tok = "OPbQIi" .. (GetInventoryItemID("player", i) or 0)
		if inring[tok] then
			inring[tok] = current
		end
	end
	scanQuests()

	local freePos, oldCount = 1, #collection
	for i=freePos, oldCount do
		local v = collection[i]
		collection[freePos], freePos, collection[v], inring[v] = collection[i], freePos + (inring[v] == current and 1 or 0), (inring[v] == current and collection[v] or nil), inring[v] == current and current or nil
	end
	for i=oldCount,freePos,-1 do
		collection[i] = nil
	end
	changed, ctok = changed or freePos <= oldCount, current

	if changed then
		sortQICollection()
	end
	if not (changed or pendingChanges) then
	elseif InCombatLockdown() then
		pendingChanges = true
	else
		AB:UpdateActionSlot(colId, collection)
		pendingChanges = nil
	end
end
colId = AB:CreateActionSlot(nil,nil, "collection",collection)
AB:AddObserver("internal.collection.preopen", syncRing)
function EV.PLAYER_REGEN_DISABLED()
	syncRing(nil, "internal.collection.preopen", colId)
end

local function createQI(name)
	return name == 1 and colId or nil
end
local function describeQI(name)
	if name == 1 then
		return L"Quest Items", L"Quest Items", [[Interface\AddOns\OPie\gfx\opie_ring_icon]], nil, nil, nil, "collection"
	end
end
AB:RegisterActionType("opie.autoquest", createQI, describeQI, 1)

local edFrame = CreateFrame("Frame") do
	edFrame:Hide()
	local clipRoot = CreateFrame("Frame", nil, edFrame)
	clipRoot:SetClipsChildren(true)
	clipRoot:SetPoint("TOPLEFT", 0, -2)
	clipRoot:SetPoint("BOTTOMRIGHT", -20, 0)
	local clipOrigin = CreateFrame("Frame", nil, clipRoot)
	clipOrigin:SetSize(0,1)
	clipOrigin:SetPoint("TOPLEFT")
	local bar = XU:Create("ScrollBar", nil, edFrame)
	bar:SetPoint("TOPRIGHT", -1, 0)
	bar:SetPoint("BOTTOMRIGHT", -1, 0)
	bar:SetCoverTarget(clipRoot)

	local rows, controller, idList, numRowsPV, visibleRange = {}, {}, {}, 2, 0 do
		clipRoot:SetScript("OnSizeChanged", function(self)
			clipOrigin:SetWidth(self:GetWidth() or clipOrigin:GetWidth() or 0)
			visibleRange = (self:GetHeight()+2)/26
			numRowsPV = 1 + math.ceil(visibleRange)
			bar:SetWindowRange(visibleRange)
			bar:SetStepsPerPage(math.max(1,numRowsPV-5))
			bar:SetMinMaxValues(0, controller:GetNumRows()-visibleRange)
			bar:SetShown(select(2, bar:GetMinMaxValues()) > 0)
			controller:SetOffset(bar:GetValue(), nil)
		end)
		edFrame:SetScript("OnMouseWheel", function(_, delta)
			bar:Step(-delta*math.max(1, math.ceil(numRowsPV/4)), true)
		end)
		bar:SetScript("OnValueChanged", function(_, nv, isInternal)
			controller:SetOffset(nv, isInternal)
		end)
		edFrame:SetScript("OnEvent", function(_, e, iid, ok)
			if e == "GET_ITEM_INFO_RECEIVED" and iid and ok then
				controller:CheckPendingItemIDs()
			end
		end)
	end

	function controller:NewRow(idx)
		local x, t = CreateFrame("Button", nil, clipRoot, nil, idx)
		x:SetPoint("TOPLEFT", clipOrigin, 0, 26 - 26*idx)
		x:SetPoint("TOPRIGHT", clipOrigin, 0, 26 - 26*idx)
		x:SetHeight(24)
		x:SetText(" ")
		x:SetNormalFontObject(GameFontNormalMed2)
		x:SetHighlightFontObject(GameFontHighlightMed2)
		t = x:CreateTexture(nil, "ARTWORK")
		t:SetPoint("LEFT", 34, 0)
		t:SetTexture("Interface/Icons/Temp")
		t:SetSize(24,24)
		t, x.Icon = x:GetFontString(), t
		t:ClearAllPoints()
		t:SetPoint("LEFT", 64, 0)
		t:SetPoint("RIGHT", -2, 0)
		t:SetHeight(20)
		t:SetJustifyH("LEFT")
		t, x.Text = x:CreateTexture(nil, "ARTWORK", nil, 0), t
		t:SetAtlas("checkbox-minimal", true)
		t:SetPoint("LEFT")
		t = x:CreateTexture(nil, "ARTWORK", nil, 1)
		t:SetAtlas("checkmark-minimal", true)
		t:SetPoint("LEFT")
		x.Mark = t
		x:SetScript("OnClick", controller.OnRowClick)
		x:SetScript("OnEnter", controller.OnRowEnter)
		x:SetScript("OnLeave", controller.OnRowLeave)
		return x
	end
	function controller:SetRow(w, idx)
		local iid = idList[idx]
		if not (iid and w) then
			return w and w:Hide()
		end
		local n, _, _iq, _, _, _, _, _, _, ico = C_Item.GetItemInfo(iid or 0)
		if n then
			w.pendingItemID = nil
		else
			w.pendingItemID, n, _, _, _, _, ico = iid, "item:" .. iid, C_Item.GetItemInfoInstant(iid or 0)
		end
		w.Text:SetText(n)
		w.Icon:SetTexture(ico)
		w.Mark:SetShown(not exclude[iid])
		w:SetID(idx)
		w:Show()
	end
	function controller.OnRowClick(w)
		local nv = not w.Mark:IsShown()
		w.Mark:SetShown(nv)
		PlaySound(SOUNDKIT[nv and "IG_MAINMENU_OPTION_CHECKBOX_ON" or "IG_MAINMENU_OPTION_CHECKBOX_OFF"])
		local iid = idList[w:GetID()]
		if not config.undo:search("opie.autoquest.state") then
			controller:SaveState()
		end
		exclude[iid] = nv ~= true or nil
	end
	function controller.OnRowEnter(w)
		local iid = idList[w:GetID()]
		if iid then
			GameTooltip:SetOwner(w, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPRIGHT", w, "TOPLEFT", -4, 4)
			GameTooltip:SetItemByID(iid)
			GameTooltip:Show()
		end
	end
	controller.OnRowLeave = config.ui.HideTooltip
	function controller:SetOffset(nv, _isInternal)
		local fv = nv % 1
		clipOrigin:SetPoint("TOPLEFT", 0, 26*fv)
		clipOrigin:SetPoint("TOPRIGHT", 0, 26*fv)
		local ofs, hadPendingGIIR = nv-fv, false
		for i=1, numRowsPV do
			local w = rows[i] or controller:NewRow(i)
			controller:SetRow(w, i + ofs)
			rows[i], hadPendingGIIR = w, hadPendingGIIR or w and w.pendingItemID
		end
		for i=numRowsPV+1, #rows do
			rows[i]:Hide()
		end
		edFrame[hadPendingGIIR and "RegisterEvent" or "UnregisterEvent"](edFrame, "GET_ITEM_INFO_RECEIVED")
	end
	function controller:GetNumRows()
		return #idList
	end

	function controller.CheckPendingItemIDs()
		local allDone = 1
		for i=1, numRowsPV do
			local pid = rows[i].pendingItemID
			local n = pid and C_Item.GetItemInfo(pid)
			allDone = allDone and (n or not pid)
			if n then
				rows[i].pendingItemID = nil
				rows[i].Text:SetText(n)
			end
		end
		if allDone or not edFrame:IsVisible() then
			edFrame:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
			edFrame:SetScript("OnShow", not allDone and controller.CheckPendingItemIDs or nil)
		end
	end
	function controller:SaveState()
		local clone = {}
		for k,v in pairs(exclude) do
			clone[k] = v
		end
		config.undo:push("opie.autoquest.state", controller.RestoreState, 1, clone)
	end
	function controller:RestoreState(msg, clone)
		if msg == "archive-unwind" then
			controller:SaveState()
		end
		wipe(exclude)
		for k,v in pairs(clone) do
			exclude[k] = v
		end
	end
	
	function edFrame:SetAction(owner, _action)
		local op = edFrame:GetParent()
		if op and op ~= owner and type(op.OnEditorRelease) == "function" then
			securecall(op.OnEditorRelease, op, self)
		end
		edFrame:SetParent(nil)
		edFrame:ClearAllPoints()
		edFrame:SetAllPoints(owner)
		edFrame:SetParent(owner)
		do -- load data
			local ni, nj = 1, 0
			wipe(idList)
			syncRing(nil, "internal.collection.preopen", colId)
			for iid, ex in pairs(exclude) do
				idList[ni], ni = ex and iid, ex and ni+1 or ni
			end
			table.sort(idList)
			for i=#collection,1,-1 do
				local iid = tokItemID[collection[i]]
				idList[nj], nj = iid, iid and nj-1 or nj
			end
			for i=nj < 0 and ni-nj-1 or 0, 1+nj, -1 do
				idList[i] = idList[i+nj]
			end
			bar:SetMinMaxValues(0, #idList-visibleRange)
		end
		edFrame:Show()
		edFrame:GetLeft()
		bar:SetValue(0)
		controller:SetOffset(0)
	end
	function edFrame:GetAction(into)
		into[1], into[2] = "opie.autoquest", 1
	end
	function edFrame:Release(owner)
		if edFrame:IsOwned(owner) then
			edFrame:SetParent(nil)
			edFrame:ClearAllPoints()
			edFrame:Hide()
		end
	end
	function edFrame:IsOwned(owner)
		return edFrame:GetParent() == owner
	end
	AB:RegisterEditorPanel("opie.autoquest", edFrame)
end


local function excludeItemID(iid)
	if iid > 0 then
		exclude[iid] = true
	else
		exclude[-iid] = nil
		if exclude[-iid] then
			exclude[-iid] = false
		end
	end
end
T.AddSlashSuffix(function(msg)
	local args = msg:match("^%s*%S+%s*(.*)$")
	if args:match("^[%d%s%-]+$") then
		for iid in args:gmatch("[%-]?%d+") do
			excludeItemID(tonumber(iid))
		end
	else
		local flag, _, link
		flag, args = args:match("^(%-?)(.*)$")
		_, link = C_Item.GetItemInfo(args:match("|H(item:%d+)") or args)
		local iid = link and link:match("item:(%d+)")
		if iid then
			excludeItemID(tonumber(iid) * (flag == "-" and -1 or 1))
		end
	end
end, "exclude-quest-item")