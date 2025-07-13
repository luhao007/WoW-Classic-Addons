local COMPAT, _, T = select(4,GetBuildInfo()), ...
if T.SkipLocalActionBook then return end
if T.TenEnv then T.TenEnv() end

local MODERN, CF_CLASSIC, CI_ERA = COMPAT >= 10e4 or nil, COMPAT < 10e4 or nil, COMPAT < 2e4 or nil
local CF_WRATH, CF_CATA = COMPAT < 10e4 and COMPAT > 3e4 or nil, COMPAT < 10e4 and COMPAT > 4e4 or nil
local MODERN_MOUNTS = MODERN or CF_WRATH
local EV = T.Evie
local AB = T.ActionBook:compatible(2,43)
local RW = T.ActionBook:compatible("Rewire", 1,27)
local KR = T.ActionBook:compatible("Kindred", 1,14)
local IM = T.ActionBook:compatible("Imp", 1,0)
assert(EV and AB and RW and KR and IM and 1, "Incompatible library bundle")
local L = T.ActionBook.L
local FORCED_MOUNT_SPELLS = {}
local spellFeedback, itemHint, toyHint, mountHint

local NormalizeInRange = {[0]=0, 1, [true]=1, [false]=0}
local _, CLASS = UnitClass("player")
local lowered = setmetatable({}, {__index=function(t,k)
	if k ~= nil then
		local r = type(k) == "string" and k:lower() or k
		t[k] = r
		return r
	end
end})
local callMethod = setmetatable({}, {__index=function(t,k)
	t[k] = function(self, ...)
		return self[k](self, ...)
	end
	return t[k]
end})
local function newWidgetName(prefix)
	local bni, bn = 0 repeat
		bn, bni = prefix .. bni, bni + 1
	until GetClickFrame(bn) == nil
	return bn
end
local function getSpellMountID(sid)
	return sid and (FORCED_MOUNT_SPELLS[sid] or MODERN_MOUNTS and C_MountJournal.GetMountFromSpell(sid)) or false
end
local GetCachedItemName, PeekCachedItemName do
	local itemNames = {}
	function EV:GET_ITEM_INFO_RECEIVED(iid, ok)
		if itemNames[iid] == false and ok then
			itemNames[iid] = C_Item.GetItemInfo(iid) or false
		end
	end
	function GetCachedItemName(ident)
		local iid = tonumber(ident) or tonumber(type(ident) == "string" and ident:match("item:(%d+)"))
		if iid then
			local c, f = itemNames[iid], C_Item.GetItemInfo(iid)
			itemNames[iid] = f or c or false
			return f or c or nil
		end
	end
	function PeekCachedItemName(ident)
		return itemNames[tonumber(ident) or tonumber(type(ident) == "string" and ident:match("item:(%d+)"))]
	end
end
local function toCooldown(now, start, duration, enabled)
	if start and start > now then
		start = start - 2^32/1000
	end
	duration = duration or 0
	return duration > 0 and enabled ~= 0 and start+duration-now or 0, duration, enabled
end

securecall(function() -- mount: mount ID
	if not MODERN_MOUNTS then
		function mountHint()
		end
		return
	end
	local function callSummonMount(mountID)
		C_MountJournal.SummonByID(mountID)
	end
	local function summonAction(mountID)
		return "func", callSummonMount, mountID
	end
	if CLASS == "DRUID" then
		local actType, clickPrefix do
			local bn = newWidgetName("AB:M!")
			local b = CreateFrame("Button", bn, nil)
			b:SetScript("OnClick", function(_, btn)
				btn = tonumber(btn)
				if btn then
					C_MountJournal.SummonByID(btn)
				end
			end)
			actType, clickPrefix = "macrotext", SLASH_CLICK1 .. " " .. bn .. " "
			if MODERN then
				actType, clickPrefix = "retext", SLASH_CANCELFORM1 .. " [form,noform:moonkin,nocombat]\n" .. clickPrefix
			end
		end
		summonAction = function(mountID)
			return actType, clickPrefix .. mountID
		end
	end

	local function checkUsableMountID(mid)
		local _1, sid, _3, _4, _5, _6, _7, factionLocked, factionId, hide, have = C_MountJournal.GetMountInfoByID(mid)
		return (have and sid ~= 0 and not hide
		        and (not factionLocked or factionId == (UnitFactionGroup("player") == "Horde" and 0 or 1)) and sid ~= 0
		        and RW:IsSpellCastable(sid, 2)) and mid or nil, sid
	end
	function mountHint(id)
		local usable = (not (InCombatLockdown() or IsIndoors())) and HasFullControl() and not UnitIsDeadOrGhost("player")
		local cname, sid, icon, active, usable2 = C_MountJournal.GetMountInfoByID(id)
		local cdLeft, cdLength = toCooldown(GetTime(), GetSpellCooldown(sid))
		return usable and cdLeft == 0 and usable2, active and 1 or 0, icon, cname, 0, cdLeft, cdLength, callMethod.SetMountBySpellID, sid
	end
	local actionMap = {}
	local function createMount(id)
		if type(id) == "number" and not actionMap[id] and checkUsableMountID(id) then
			actionMap[id] = AB:CreateActionSlot(mountHint, id, summonAction(id))
		end
		return actionMap[id]
	end
	local function describeMount(id)
		local name, sid, icon, _4, _5, _6, _7, factionLocked, factionId = C_MountJournal.GetMountInfoByID(id)
		if name and factionLocked then
			name = name .. (factionId == 0 and "|A:QuestPortraitIcon-Horde-small:14:14:0:-1|a" or "|A:QuestPortraitIcon-Alliance-small:15:13:-1:-1|a")
		end
		return L"Mount", name, icon, nil, callMethod.SetMountBySpellID, sid
	end
	AB:RegisterActionType("mount", createMount, describeMount, 1)
	if MODERN then -- random
		local mjID, rname, _, ricon = C_MountJournal.GetMountFromSpell(150544), GetSpellInfo(150544)
		actionMap[0] = AB:CreateActionSlot(function()
			return HasFullControl() and not IsIndoors(), IsMounted() and 1 or 0, ricon, rname, 0, 0, 0, callMethod.SetMountBySpellID, 150544
		end, nil, summonAction(0))
		FORCED_MOUNT_SPELLS[150544], actionMap[mjID or 0] = 0, 0
		RW:SetCastEscapeAction(rname, actionMap[0])
		RW:SetCastEscapeAction("spell:150544", actionMap[0])
	end
	local function mountSync()
		AB:NotifyObservers("mount")
	end
	EV.NEW_MOUNT_ADDED, EV.PLAYER_ENTERING_WORLD, EV.COMPANION_LEARNED = mountSync, mountSync, mountSync
end)
securecall(function() -- spell: spell ID + mount spell ID
	local actionMap, spellMap = {}, {}
	local function isCurrentForm(q, qsid)
		local id = GetShapeshiftForm()
		if id == 0 then return end
		local _, _, _, sid = GetShapeshiftFormInfo(id)
		return q == sid or qsid == sid or q == GetSpellInfo(sid or 0) or (sid and q and ("" .. sid) == q)
	end
	local SetSpellBookItem, SetSpellByID, SetSpellByExactID do
		if MODERN then
			function SetSpellBookItem(self, id)
				return self:SetSpellBookItem(id, BOOKTYPE_SPELL)
			end
			function SetSpellByID(self, ...)
				return self:SetSpellByID(...)
			end
			function SetSpellByExactID(self, id)
				return self:SetSpellByID(id, false, true, true)
			end
		else
			local tr1 = {}
			local function SetRankText(self, sid, ...)
				if sid then
					local tr = tr1[self]
					if tr == nil and self then
						local n = self:GetName()
						tr = n and _G[n .. "TextRight1"]
						tr = type(tr) == "table" and type(tr.IsObjectType) == "function" and tr:IsObjectType("FontString") and tr
						tr1[self] = tr or false
					end
					local sr = tr and not tr:IsShown() and GetSpellSubtext(sid) or ""
					if sr ~= "" then
						tr:SetText(sr)
						tr:SetTextColor(0.5, 0.5, 0.5)
						tr:Show()
						self:Show()
					end
				end
				return ...
			end
			function SetSpellBookItem(self, id)
				local st, sid = GetSpellBookItemInfo(id, "spell")
				return SetRankText(self, st == "SPELL" and sid, self:SetSpellBookItem(id, "spell"))
			end
			function SetSpellByID(self, ...)
				return SetRankText(self, (...), self:SetSpellByID(...))
			end
			function SetSpellByExactID(self, sid)
				return SetRankText(self, sid, self:SetSpellByID(sid, nil, nil, true))
			end
		end
	end
	local getSpellIDFromName = CI_ERA and function(n)
		return (select(7, GetSpellInfo(n or "")))
	end or function(n)
		return tonumber(((GetSpellLink(n) or ""):match("spell:(%d+)")))
	end
	local RUNE_BASESPELL_CACHE, RUNE_SPELLS = {}, {} if CI_ERA then
		for sid in ("399967 417346 399954 417347 415450 417345 399966 417348 415449"):gmatch("%d+") do
			RUNE_SPELLS[sid+0] = GetSpellInfo(sid+0)
		end
		setmetatable(RUNE_BASESPELL_CACHE, {__index=function(t, k)
			t[k] = RUNE_SPELLS[FindBaseSpellByID(k)] or false
			return t[k]
		end})
	end
	local iconOverrideHandlers = {}
	local function spellHint(n, _modState, target)
		if not n then return end
		local sname, _, _, _, _, _, sid = GetSpellInfo(n)
		local mjID = sid and getSpellMountID(sid)
		if mjID then return mountHint(mjID) end
		if not sname then return end
		local now, msid = GetTime(), spellMap[lowered[n]] or sid
		local inRange, usable, nomana, hasRange = NormalizeInRange[IsSpellInRange(sid and RUNE_BASESPELL_CACHE[sid] or n, target or "target")], IsUsableSpell(n)
		inRange, hasRange = inRange ~= 0, inRange ~= nil
		local cdLeft, cdLength, enabled = toCooldown(now, GetSpellCooldown(n))
		local count, charges, maxCharges, ccdStart, ccdLength = GetSpellCount(n), GetSpellCharges(n)
		local state = ((IsSelectedSpellBookItem(n) or IsCurrentSpell(n) or isCurrentForm(n, sid) or enabled == 0) and 1 or 0) +
		              (MODERN and IsSpellOverlayed(msid or 0) and 2 or 0) + (nomana and 8 or 0) + (inRange and 0 or 16) + (charges and charges > 0 and 64 or 0) +
		              (hasRange and 512 or 0) + (usable and 0 or 1024) + (enabled == 0 and 2048 or 0)
		usable = not not (usable and inRange and (cdLeft == 0 or enabled == 0))
		if charges and maxCharges and charges < maxCharges and cdLeft == 0 then
			cdLeft, cdLength = toCooldown(now, ccdStart, ccdLength, 1)
		end
		local ih, ico, ohUsable = iconOverrideHandlers[msid], nil
		if ih then
			ico, ohUsable = ih(msid, n)
			if ohUsable ~= nil then
				usable = ohUsable == true
			end
		end
		local sbslot = msid and msid ~= 161691 and FindSpellBookSlotBySpellID(msid)
		return usable, state, ico or GetSpellTexture(n), sname or n, count <= 1 and charges or count, cdLeft, cdLength, sbslot and SetSpellBookItem or msid and SetSpellByID, sbslot or msid
	end
	function spellFeedback(sname, target, spellId)
		spellMap[sname] = spellId or spellMap[sname] or getSpellIDFromName(sname)
		return spellHint(sname, nil, target)
	end
	local function createSpell(id, flags)
		if type(id) ~= "number" then return end
		local mjID = getSpellMountID(id)
		if mjID then
			return AB:GetActionSlot("mount", mjID)
		end
		
		local laxRank, action = CF_CLASSIC and flags ~= 16 and "lax-rank"
		local castable, rwCastType = RW:IsSpellCastable(id, nil, laxRank)
		if not castable then
			return
		elseif rwCastType == "forced-id-cast" then
			action = id
		elseif rwCastType == "rewire-escape" then
			return AB:GetActionSlot("macrotext", SLASH_CAST1 .. " " .. GetSpellInfo(id))
		else
			local s0, r0 = GetSpellInfo(id), GetSpellSubtext(id)
			local o, s = pcall(GetSpellInfo, s0, r0)
			if laxRank and not (o and s) then
				o, s = pcall(GetSpellInfo, s0)
			end
			if not (o and s and s0) then
				return
			end
			local r1 = laxRank and r0 or GetSpellSubtext(s0)
			action = (r0 and r1 ~= r0 and (CF_CLASSIC or FindSpellBookSlotBySpellID(id))) and (s0 .. "(" .. r0 .. ")") or s0
			id = CF_CLASSIC and select(7, GetSpellInfo(action)) or id
		end
		
		if action then
			if not actionMap[action] then
				actionMap[action] = AB:CreateActionSlot(spellHint, action, "attribute", "type","spell", "spell",action, "checkselfcast",true, "checkfocuscast",true)
			end
			if type(action) == "string" and spellMap[action] ~= id then
				spellMap[lowered[action]] = id
			end
		end
		return actionMap[action]
	end
	local function describeSpell(q, id, flags)
		local name2, sid2, icon2, rank, name, _, icon, _, _, _, _, icon1 = nil, nil, nil, GetSpellSubtext(id), GetSpellInfo(id)
		local laxRank = CF_CLASSIC and flags ~= 16 and "lax-rank"
		local _, castType = RW:IsSpellCastable(id, nil, laxRank)
		if castType == "rune-ability-spell" then
			_, icon2 = GetSpellTexture(id)
		elseif name and castType ~= "forced-id-cast" then
			local qRank = (MODERN or q == "list-query" or not laxRank) and rank or nil
			rank, name2, _, icon2, _, _, _, sid2 = GetSpellSubtext(name, rank), GetSpellInfo(name, qRank)
			if MODERN and sid2 and IsPassiveSpell(sid2) or RUNE_SPELLS[id] then
				icon, name2, icon2 = icon1 or icon, nil, nil
			end
		end
		local srank = rank and rank ~= "" and (rank ~= GetSpellSubtext(name) or (CF_CLASSIC and rank ~= GetSpellSubtext(name, (rank:gsub("%d+", "1"))))) and " (" .. rank .. ")" or ""
		local ts, ns = q == "list-query" and srank or "", (laxRank or q == "list-query") and "" or srank
		local mjID = getSpellMountID(id)
		return mjID and L"Mount" or (L"Spell" .. ts), (name2 or name or "?") .. ns, icon2 or icon, nil, SetSpellByExactID, id
	end
	AB:RegisterActionType("spell", createSpell, describeSpell, 2, true)
	if MODERN then -- specials
		local gab = GetSpellInfo(161691)
		actionMap[gab] = AB:CreateActionSlot(spellHint, gab, "conditional", "[outpost]", "attribute", "type","spell", "spell",gab)
		spellMap[lowered[gab]] = 161691
		actionMap[150544] = AB:GetActionSlot("mount", 0)
	end
	
	function EV.SPELLS_CHANGED()
		wipe(RUNE_BASESPELL_CACHE)
		for k, v in pairs(spellMap) do
			if v ~= 161691 then
				spellMap[k] = nil
			end
		end
		AB:NotifyObservers("spell")
	end
	function AB.HUM:SetSpellIconOverride(id, f)
		if not (type(id) == "number" and (f == nil or type(f) == "function")) then
			return error('SetSpellIconOverride: invalid arguments', 2)
		end
		iconOverrideHandlers[id] = f
	end
end)
securecall(function() -- item: items ID/inventory slot
	local actionMap, itemIdMap, LAST_EQUIP_SLOT = {}, {}, INVSLOT_LAST_EQUIPPED
	local countOverrideHandlers = {}
	local function containerTip(self, bagslot)
		local slot = bagslot % 100
		self:SetBagItem((bagslot-slot)/100, slot)
	end
	local function playerInventoryTip(self, slot)
		self:SetInventoryItem("player", slot)
	end
	local function GetItemLocation(iid, name, name2)
		local name2, cb, cs, n = name2 and lowered[name2]
		for i=1, LAST_EQUIP_SLOT do
			if GetInventoryItemID("player", i) == iid then
				n = C_Item.GetItemInfo(GetInventoryItemLink("player", i))
				if n == name or n and name2 and lowered[n] == name2 then
					return nil, i
				elseif not cs then
					cb, cs = nil, i
				end
			end
		end
		local ns, giid, gil = C_Container.GetContainerNumSlots, C_Container.GetContainerItemID, C_Container.GetContainerItemLink
		for i=0,4 do
			for j=1, ns(i) do
				if iid == giid(i, j) then
					n = C_Item.GetItemInfo(gil(i, j))
					if n == name or n and name2 and lowered[n] == name2 then
						return i, j
					elseif not cs then
						cb, cs = i, j
					end
				end
			end
		end
		return cb, cs
	end
	function itemHint(ident, _modState, target, purpose, ibag, islot)
		local name, link, icon, _, bag, slot, tip, tipArg
		if type(ident) == "number" and ident <= LAST_EQUIP_SLOT then
			local invid = GetInventoryItemID("player", ident)
			if invid == nil then return end
			bag, slot, name, link = nil, invid, C_Item.GetItemInfo(GetInventoryItemLink("player", ident) or invid)
			ident = name or ident
		elseif ident then
			name, link, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(ident)
		else
			return
		end
		local iid, cdLeft, cdLength, enabled = (link and tonumber(link:match("item:([x%x]+)"))) or itemIdMap[ident]
		if MODERN and iid and PlayerHasToy(iid) and C_Item.GetItemCount(iid) == 0 then
			return toyHint(iid, nil, target)
		elseif iid then
			cdLeft, cdLength, enabled = toCooldown(GetTime(), C_Container.GetItemCooldown(iid))
		end
		target = target or "target"
		local canRange = not (InCombatLockdown() and (UnitIsFriend("player", target) or not UnitExists(target))) or nil
		local inRange, hasRange = canRange and NormalizeInRange[C_Item.IsItemInRange(ident, target)]
		inRange, hasRange = inRange ~= 0, inRange ~= nil
		if ibag and islot then
			bag, slot = ibag, islot
		elseif iid then
			bag, slot = GetItemLocation(iid, name, ident)
		end
		if bag and slot then
			tip, tipArg = containerTip, bag * 100 + slot
		elseif slot then
			tip, tipArg = playerInventoryTip, slot
		elseif iid then
			tip, tipArg = callMethod.SetItemByID, iid
		end
		local nCharge = C_Item.GetItemCount(ident, false, true) or 0
		local usable = nCharge > 0 and (C_Item.GetItemSpell(ident) == nil or C_Item.IsUsableItem(ident))
		local qual = MODERN and ident and (C_TradeSkillUI.GetItemReagentQualityByItemInfo(ident) or C_TradeSkillUI.GetItemCraftedQualityByItemInfo(ident))
		qual = qual and qual > 0 and qual < 8 and (qual * 16384) or 0
		local state = (C_Item.IsCurrentItem(ident) and 1 or 0) + (inRange and 0 or 16) + (slot and C_Item.IsEquippableItem(ident) and (bag and (purpose == "equip" and 128 or 0) or (slot and 256 or 0)) or 0) + (hasRange and 512 or 0) + (usable and 0 or 1024) + (enabled == 0 and 2048 or 0) + qual
		usable = not not (usable and inRange and cdLeft == 0)
		icon = icon or C_Item.GetItemIconByID(ident)
		local oh = countOverrideHandlers[iid]
		if oh then
			local ohCharge, ohUsable = oh(iid, nCharge)
			nCharge = ohCharge or nCharge
			if ohUsable == true or ohUsable == false then
				usable = ohUsable
			end
		end
		return usable, state, icon, name or ident, nCharge, cdLeft, cdLength or 0, tip, tipArg
	end
	local function createItem(id, flags)
		local byName, forceShow, onlyEquipped
		if type(id) ~= "number" then return end
		if type(flags) == "number" then
			byName, forceShow, onlyEquipped = flags % 4 >= 2, flags % 2 >= 1, flags % 8 >= 4
		end
		local name = id <= LAST_EQUIP_SLOT and id or (byName and GetCachedItemName(id) or ("item:" .. id))
		if not forceShow and onlyEquipped and not ((id > LAST_EQUIP_SLOT and C_Item.IsEquippedItem(name)) or (id <= LAST_EQUIP_SLOT and GetInventoryItemLink("player", id))) then return end
		if not forceShow and C_Item.GetItemCount(name) == 0 then return end
		if not actionMap[name] then
			actionMap[name], itemIdMap[name] = AB:CreateActionSlot(itemHint, name, "attribute", "type","item", "item",name, "checkselfcast",true, "checkfocuscast",true), id
		end
		return actionMap[name]
	end
	local function describeItem(id, _flags)
		local cat, cq = L"Item", MODERN and id and (C_TradeSkillUI.GetItemReagentQualityByItemInfo(id) or C_TradeSkillUI.GetItemCraftedQualityByItemInfo(id))
		cat = cq and cat .. "|A:Professions-Icon-Quality-Tier" .. cq .. "-Small:0:0:2:0|a" or cat
		return cat, C_Item.GetItemNameByID(id) or PeekCachedItemName(id), C_Item.GetItemIconByID(id), nil, callMethod.SetItemByID, tonumber(id)
	end
	AB:RegisterActionType("item", createItem, describeItem, 2)
	function EV.BAG_UPDATE()
		AB:NotifyObservers("item")
	end
	RW:SetCommandHint(SLASH_EQUIP1, 70, function(_, _, clause, target)
		if clause and clause ~= "" and C_Item.GetItemNameByID(clause) then
			return true, itemHint(clause, nil, target, "equip")
		end
	end)
	RW:SetCommandHint(SLASH_EQUIP_TO_SLOT1, 70, function(_, _, clause)
		local item = clause and clause:match("^%s*%d+%s+(.*)")
		if item then
			return RW:GetCommandAction(SLASH_EQUIP1, item)
		end
	end)
	function AB.HUM:SetItemCountOverride(id, f)
		if not (type(id) == "number" and (f == nil or type(f) == "function")) then
			error('SetItemCountOverride: invalid arguments', 2)
		end
		countOverrideHandlers[id] = f
	end
end)
securecall(function() -- peq: slot token
	local slots = {
		head="HEADSLOT", neck="NECKSLOT", shoulders="SHOULDERSLOT", shirt="SHIRTSLOT", chest="CHESTSLOT",
		waist="WAISTSLOT", legs="LEGSSLOT", feet="FEETSLOT", wrist="WRISTSLOT", hands="HANDSSLOT",
		finger1="FINGER0SLOT", finger2="FINGER1SLOT", trinket1="TRINKET0SLOT", trinket2="TRINKET1SLOT",
		back="BACKSLOT", tabard="TABARDSLOT",
	}
	for tk, sk in pairs(slots) do
		local sn, suf, ok, slot = _G[sk], tk:match("%d+$"), pcall(GetInventorySlotInfo, sk)
		slots[tk] = ok and slot and {sk, sn and suf and (sn .. " " .. suf) or sn or sk} or nil
		if ok and slot then
			RW:SetCastAlias(tk, tostring(slot), false)
		end
	end
	local function describePlayerEquipmentSlot(tk)
		local si = slots[tk]
		if si then
			local _, tex = GetInventorySlotInfo(si[1])
			return L"Equipment Slot", si[2], tex
		end
	end
	local function createPlayerEquipmentSlot(tk)
		local si = slots[tk]
		if si and not si[3] then
			local slot = GetInventorySlotInfo(si[1])
			si[3] = AB:CreateActionSlot(itemHint, slot, "conditional","[uslot:" .. tk .. "]", "attribute", "type","item", "item",slot)
		end
		return si and si[3]
	end
	AB:RegisterActionType("peq", createPlayerEquipmentSlot, describePlayerEquipmentSlot, 1)
end)
securecall(function() -- macrotext
	local map = {}
	local function macroHint(mtext, modLockState)
		return RW:GetMacroAction(mtext, modLockState)
	end
	local function createMacrotext(macrotext)
		if type(macrotext) ~= "string" then return end
		if not map[macrotext] then
			map[macrotext] = AB:CreateActionSlot(macroHint, macrotext, "retext", macrotext, false, true)
		end
		return map[macrotext]
	end
	local function describeMacrotext(macrotext)
		if macrotext == "" then return L"Custom Macro", L"New Macro", "Interface/Icons/INV_Misc_Note_03" end
		local _, _, ico = RW:GetMacroAction(macrotext)
		return L"Custom Macro", "", ico
	end
	AB:RegisterActionType("macrotext", createMacrotext, describeMacrotext, 1)
	local function checkReturn(pri, ...)
		if select("#", ...) > 0 then return pri, ... end
	end
	local function checkCountReturn(pri, ...)
		if select("#", ...) > 0 then
			local _, _, _, _, nc = ...
			return nc == 0 and pri - 5 or pri, ...
		end
	end
	local function canUseViaSCUI(clause)
		if (tonumber(clause) or 0) > INVSLOT_LAST_EQUIPPED then
			-- SCUI will pass to UseInventoryItem
			return false
		end
		return true
	end
	RW:SetCommandHint("/use", 100, function(_, _, clause, target, _, _, msg)
		if not clause or clause == "" then return end
		local isItemReturn, link, bag, slot = false, SecureCmdItemParse(clause)
		if (bag and slot) or (link and C_Item.GetItemInfoInstant(link)) then
			if msg == "castrandom-fallback" or canUseViaSCUI(clause) then
				isItemReturn = true
			end
		end
		if isItemReturn then
			return checkCountReturn(90, itemHint(link, nil, target, nil, bag, slot))
		end
		local sid = clause:match("^spell:(%d+)$")
		if sid or not tonumber(clause, 10) then
			return checkReturn(true, spellFeedback(sid or clause, target))
		end
	end)
	RW:SetCommandHint("/cast", 100, function(_, _, clause, target, _, _, msg)
		if not clause or clause == "" then return end
		local sex = DoesSpellExist(clause) and not tonumber(clause, 10)
		local sid = not sex and clause:match("^spell:(%d+)$")
		if sex or sid then
			return checkReturn(true, spellFeedback(sid or clause, target))
		else
			local link, bag, slot = SecureCmdItemParse(clause)
			if ((bag and slot) or (link and C_Item.GetItemInfoInstant(link))) and
			   (msg == "castrandom-fallback" or canUseViaSCUI(clause)) then
				return checkCountReturn(90, itemHint(link, nil, target, nil, bag, slot))
			end
		end
	end)
	RW:SetCommandHint(SLASH_CASTSEQUENCE1, 100, function(_, _, clause, target)
		if not clause or clause == "" then return end
		local _, item, spell = QueryCastSequence(clause)
		clause = (item or spell)
		if clause then
			return RW:GetCommandAction("/use", clause, target)
		end
	end)
	do -- /userandom + /qsequence
		local f = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
		f:SetFrameRef("RW", RW:seclib())
		f:SetFrameRef("KR", KR:seclib())
		f:Execute([[-- AB_userandom_init 
			seed, crState, qsState = math.random(2^30), newtable(), newtable()
			RW = self:GetFrameRef('RW'), self:SetAttribute('frameref-RW', nil)
			KR = self:GetFrameRef('KR'), self:SetAttribute('frameref-KR', nil)
		]])
		f:SetAttribute("RunSlashCmd", [=[-- AB_userandom 
			local cmd, v, target, s, q = ...
			local isRand = cmd ~= "/qsequence"
			local tv, i, vt, _ = (isRand and crState or qsState)[v]
			if v == "" or not v then
				return
			elseif not tv then
				local iv, tn, np = newtable(), 1, 1 --@init_clause_start
				while np do
					local sp, spc, ev, eo = np, np
					repeat
						sp, spc = spc, v:match("^%s*<[^<]->()%s*", sp)
					until not spc
					eo = sp > np and v:sub(np, sp-1):gsub("<(.-)>", "[%1]") or nil
					ev, np = v:match("^%s*([^%s,][^,]*),?%s*()", sp)
					ev = ev and ev:match("^%s*(.-)%s*$") or ""
					if ev ~= "" then
						iv[-tn], iv[tn], tn = eo, ev, tn + 1
					end
				end
				tv, (isRand and crState or qsState)[v], iv[0] = iv, iv, isRand and 1 + seed % #iv or 1 --@init_clause_end
			end
			i = tv[0]
			v, vt, tv[0] = tv[i], tv[-i], isRand and math.random(#tv) or (1 + i % #tv)
			if v then
				if vt then
					_, vt = KR:RunAttribute("EvaluateCmdOptions", vt)
				end
				return RW:RunAttribute("RunSlashCmd", "/cast", v, vt or target, isRand and "opt-into-cr-fallback")
			end
		]=])
		local getNextCast do -- (kind, v, target) -> (v, target)
			local senv = GetManagedEnvironment(f)
			local uenv = setmetatable({qsState={}, crState={}, newtable=function() return {} end}, {__index=senv})
			local initF = setfenv(loadstring("return function(isRand, v)\n" .. f:GetAttribute("RunSlashCmd"):match("[^\n]+@init_clause_start.-@init_clause_end") .. "\nreturn iv end"), {})
			initF = setfenv(initF(), uenv)
			function getNextCast(k, c, target)
				local t1, ucache, tv, i, v, vt = senv[k][c], uenv[k]
				tv = t1 or ucache[c] or initF(k == "crState", c)
				if t1 then
					ucache[c] = nil
				end
				i = tv[0]
				v, vt = tv[i], tv[-i]
				if vt then
					_, vt = KR:EvaluateCmdOptions(vt)
				end
				return v, vt or target
			end
		end
		RW:RegisterCommand(SLASH_USERANDOM1, true, true, f)
		local function hintCastRandom(_, _, clause, target)
			if (clause or "") == "" then return end
			local v, vt = getNextCast("crState", clause, target)
			if v then
				local nextN = tonumber(v)
				if nextN and nextN > 20 and C_Item.GetItemNameByID(nextN) then
					v = "item:" .. v
				end
				return RW:GetCommandAction("/use", v, vt or target, nil, "castrandom-fallback")
			end
		end
		local function hintQuickSequence(_slash, _unparsed, clause, target)
			if (clause or "") == "" then return end
			local v, vt = getNextCast("qsState", clause, target)
			if v then
				return RW:GetCommandAction("/cast", v, vt)
			end
		end
		RW:SetCommandHint(SLASH_USERANDOM1, 50, hintCastRandom)
		SLASH_ACTIONBOOK_QSEQUENCE1, SLASH_ACTIONBOOK_QSEQUENCE2 = "/qsequence", "/quicksequence"
		RW:RegisterCommand(SLASH_ACTIONBOOK_QSEQUENCE1, true, true, f)
		RW:AddCommandAliases(SLASH_ACTIONBOOK_QSEQUENCE1, SLASH_ACTIONBOOK_QSEQUENCE2)
		RW:SetCommandHint(SLASH_ACTIONBOOK_QSEQUENCE1, 100, hintQuickSequence)
		IM:AddTokenizableCommand("ACTIONBOOK_QSEQUENCE", SLASH_CASTRANDOM1)
		SLASH_ACTIONBOOK_QSEQUENCE1, SLASH_ACTIONBOOK_QSEQUENCE2 = nil, nil
	end
end)
securecall(function() -- macro: name
	local map, sm = {}, {} do
		local wmSynced, owner = true, RW:RegisterNamedMacroTextOwner("ab-macro-wrapper", 10)
		local function syncWMacros()
			local notify, numGlobal, numChar = false, GetNumMacros()
			for k in pairs(sm) do
				if not GetMacroInfo(k) then
					notify, sm[k] = RW:SetNamedMacroText(k, nil, owner, true) or notify, nil
				end
			end
			local ofs = MAX_ACCOUNT_MACROS - numGlobal
			for i=1,numGlobal + numChar do
				local k, _, text = GetMacroInfo((i > numGlobal and ofs or 0)+i)
				if k and text ~= sm[k] then
					notify, sm[k] = RW:SetNamedMacroText(k, "#abmacrowrap " .. k .. "\n" .. text, owner, true) or notify, text
				end
			end
			if notify then
				AB:NotifyObservers("macro")
			end
			wmSynced = true
			return "remove"
		end
		function EV.UPDATE_MACROS()
			if not InCombatLockdown() then
				syncWMacros()
			elseif wmSynced then
				EV.PLAYER_REGEN_ENABLED, wmSynced = syncWMacros, nil
			end
		end
	end
	RW:SetMetaHintFilter("abmacrowrap", "macroFallback", false, function(_meta, v)
		if sm[v] then
			local n, ico = GetMacroInfo(v)
			return true, not not n, ico, v
		end
	end)
	local function namedMacroHint(name, cndState)
		return RW:GetNamedMacroAction(name, cndState)
	end
	local function createNamedMacro(name, flags)
		local forceShow = flags == 1
		if type(name) == "string" and (forceShow or RW:IsNamedMacroKnown(name)) then
			if not map[name] then
				map[name] = AB:CreateActionSlot(namedMacroHint, name, "reslash", "/runmacro", name)
			end
			return map[name]
		end
	end
	local function describeMacro(name)
		local _, ico
		if RW:IsNamedMacroKnown(name) then
			_, _, ico = RW:GetNamedMacroAction(name)
		end
		return L"Macro", name, ico
	end
	AB:RegisterActionType("macro", createNamedMacro, describeMacro, 2)
end)
securecall(function() -- battlepet: pet ID, species ID
	if not (MODERN or CF_WRATH) then
		return
	end
	local petAction, special = {}, {}
	local BPET_ATYPE_NAME, SummonCompanion = not MODERN and COMPANIONS or L"Battle Pet"
	local function SetBattlePetByID(self, id)
		local sid, cname, lvl, _, _, _, _, name, _, ptype, _, _, desc, _, cb = C_PetJournal.GetPetInfoByPetID(id)
		if not sid then return false end
		local hp, mhp, ap, spd, rarity = C_PetJournal.GetPetStats(id)
		local qc, hc, icof = ITEM_QUALITY_COLORS[rarity-1], HIGHLIGHT_FONT_COLOR, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:%d:%d:%d:%d|t %s"
		self:AddLine(cname or name, qc.r, qc.g, qc.b)
		if cb then
			self:AddLine(UNIT_TYPE_LEVEL_TEMPLATE:format(lvl, _G["BATTLE_PET_NAME_".. ptype]), hc.r, hc.g, hc.b)
			self:AddLine(icof:format(0, 16, 0, 16, ap) .. "   " .. icof:format(0, 16, 16, 32, spd) .. "   " .. icof:format(16,32,16,32, hp < mhp and (hp .. "/" .. mhp) or hp), hc.r, hc.g, hc.b)
		elseif desc then
			local nc = NORMAL_FONT_COLOR
			self:AddLine(desc, nc.r, nc.g, nc.b, 1)
		end
	end
	if CF_WRATH then
		SetBattlePetByID = callMethod.SetCompanionPet
		function SummonCompanion(guid)
			if C_PetJournal.IsCurrentlySummoned(guid) then
				C_PetJournal.DismissSummonedPet(guid)
			else
				DoEmote("STAND")
				C_PetJournal.SummonPetByGUID(guid)
			end
		end
	end
	local function battlepetHint(pid)
		local sid, cn, _, _, _, _, _, n, tex = C_PetJournal.GetPetInfoByPetID(pid)
		local cdLeft, cdLength, enabled = toCooldown(GetTime(), C_PetJournal.GetPetCooldownByGUID(pid))
		local state = (CF_WRATH and (C_PetJournal.IsCurrentlySummoned(pid) and 1 or 0) or strcmputf8i(C_PetJournal.GetSummonedPetGUID() or "", pid) == 0 and 1 or 0)
		            + (enabled == 0 and 2048 or 0)
		return sid and cdLeft == 0 and C_PetJournal.PetIsSummonable(pid), state, tex, cn or n or "", 0, cdLeft, cdLength, SetBattlePetByID, pid
	end
	if MODERN then -- random favorite pet
		local rname, _, ricon = GetSpellInfo(243819)
		local function randFaveHint()
			return HasFullControl(), C_PetJournal.GetSummonedPetGUID() and 1 or 0, ricon, rname, 0, 0, 0, callMethod.SetSpellByID, 243819
		end
		petAction.fave = AB:CreateActionSlot(randFaveHint, nil, "macrotext", SLASH_RANDOMFAVORITEPET1)
		RW:ImportSlashCmd("RANDOMFAVORITEPET", true, false, 20, function(_, _, clause, _target)
			if clause then
				return true, randFaveHint()
			end
		end)
		RW:SetCastEscapeAction(rname, petAction.fave)
		RW:SetCastEscapeAction("spell:243819", petAction.fave)
		function special.fave()
			return BPET_ATYPE_NAME, rname, ricon, nil, callMethod.SetSpellByID, 243819
		end
	end
	local GetBattlePetInfo do -- (petID[, speciesID])
		local function checkInfoReturn(pid, spid, ok, ...)
			if ok and ... then
				return pid, ...
			elseif spid then
				local sn = C_PetJournal.GetPetInfoBySpeciesID(spid)
				local _, pid = C_PetJournal.FindPetIDByName(sn ~= "" and sn or "---")
				if pid then
					return GetBattlePetInfo(pid)
				end
			end
		end
		function GetBattlePetInfo(pid, spid)
			return checkInfoReturn(pid, spid, pcall(C_PetJournal.GetPetInfoByPetID, pid))
		end
	end
	local function createBattlePet(pid, spid)
		if special[pid] then return petAction[pid] end
		local rpid = GetBattlePetInfo(pid, spid)
		if not rpid then return end
		local pk = rpid:upper()
		if not petAction[pk] then
			if MODERN then
				petAction[pk] = AB:CreateActionSlot(battlepetHint, rpid, "macrotext", EMOTE143_CMD1 .. "\n" .. SLASH_SUMMON_BATTLE_PET1 .. " " .. rpid)
			else -- no /summonbattlepet implementation as of 4.4.0
				petAction[pk] = AB:CreateActionSlot(battlepetHint, rpid, "func", SummonCompanion, rpid)
			end
		end
		return petAction[pk]
	end
	local function describeBattlePet(pid, spid)
		if special[pid] then return special[pid]() end
		local rpid, _, cn, lvl, _, _, _, _, n, tex = GetBattlePetInfo(pid, spid)
		if not rpid then return BPET_ATYPE_NAME, "?" end
		if (cn or n) and ((lvl or 0) > 1) then cn = "[" .. lvl .. "] " .. (cn or n) end
		return BPET_ATYPE_NAME, cn or n or ("#" .. tostring(rpid)), tex, nil, SetBattlePetByID, rpid
	end
	AB:RegisterActionType("battlepet", createBattlePet, describeBattlePet, 2)
	RW:SetCommandHint(SLASH_SUMMON_BATTLE_PET1, 60, function(_, _, clause)
		if clause and clause ~= "" then
			local _, petID = C_PetJournal.FindPetIDByName(clause:trim())
			if petID then
				return true, battlepetHint(petID)
			end
		end
	end)
end)
securecall(function() -- equipmentset: equipment sets by name
	if not (MODERN or CF_WRATH) then
		return
	end
	local setMap = {}
	local function resolveIcon(fid)
		return type(fid) == "number" and fid or ("Interface/Icons/" .. (fid or "INV_Misc_QuestionMark"))
	end
	local function equipmentsetHint(name)
		local esid = name and C_EquipmentSet.GetEquipmentSetID(name) or -1
		local _, icon, _, active, total, equipped, available = C_EquipmentSet.GetEquipmentSetInfo(esid)
		if icon then
			return total == equipped or (available > 0), active and 1 or 0, resolveIcon(icon), name, nil, 0, 0, callMethod.SetEquipmentSet, esid
		end
	end
	local function wrapCommandHint(...)
		local _, state = ...
		if state then
			return true, ...
		end
	end
	function EV.EQUIPMENT_SETS_CHANGED()
		AB:NotifyObservers("equipmentset")
	end
	local function equipSetActionSpec(name)
		return "attribute", "type","equipmentset", "equipmentset",name
	end
	local function equipSetActionSpec_SLASH(name)
		-- [3.4.2] [4.4.1] /equipset exists but the SABT action type does not
		return "macrotext", SLASH_EQUIP_SET1 .. " " .. name
	end
	equipSetActionSpec, equipSetActionSpec_SLASH = MODERN and equipSetActionSpec or equipSetActionSpec_SLASH, nil
	local function createEquipSet(name)
		local sid = type(name) == "string" and C_EquipmentSet.GetEquipmentSetID(name)
		if not sid then return end
		if not setMap[name] and (MODERN or name:match("^[^%[;%]]*$")) then
			setMap[name] = AB:CreateActionSlot(equipmentsetHint, name, equipSetActionSpec(name))
		end
		return setMap[name]
	end
	local function describeEquipSet(name)
		local esid = name and C_EquipmentSet.GetEquipmentSetID(name) or -1
		local _, ico = C_EquipmentSet.GetEquipmentSetInfo(esid)
		return L"Equipment Set", name, ico and resolveIcon(ico) or "Interface/Icons/INV_Misc_QuestionMark", nil, callMethod.SetEquipmentSet, esid
	end
	AB:RegisterActionType("equipmentset", createEquipSet, describeEquipSet, 1)
	RW:SetCommandHint(SLASH_EQUIP_SET1, 80, function(_, _, clause)
		if clause and clause ~= "" then
			return wrapCommandHint(equipmentsetHint(clause))
		end
	end)
end)
securecall(function() -- raidmark
	local map, waitingToClearSelf = {}
	local function CanChangeRaidTargets(unit)
		return not not ((not IsInRaid() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and not (unit and UnitIsPlayer(unit) and UnitIsEnemy("player", unit)))
	end
	local function setRaidTarget(id)
		SetRaidTarget("target", GetRaidTargetIndex("target") == id and 0 or id)
	end
	local function raidmarkHint(i, _, target)
		local target = target or "target"
		return CanChangeRaidTargets(target), GetRaidTargetIndex(target) == i and 1 or 0, "Interface/TargetingFrame/UI-RaidTargetingIcon_" .. i, _G["RAID_TARGET_" .. i], 0, 0, 0
	end
	local function removeHint()
		return CanChangeRaidTargets(), 0, "Interface/Icons/INV_Gauntlets_02", REMOVE_WORLD_MARKERS, 0, 0, 0
	end
	local function FinishClearRaidTargets()
		if waitingToClearSelf and GetRaidTargetIndex("player") == 1 then
			waitingToClearSelf = nil
			if CanChangeRaidTargets() then
				SetRaidTarget("player", 0)
			end
			return "remove"
		end
	end
	map[0] = AB:CreateActionSlot(removeHint, nil, "func", function()
		if not CanChangeRaidTargets() then return end
		local pt = GetRaidTargetIndex("player")
		for i=8, 0, -1 do
			SetRaidTarget("player", i == pt and 1 or i == 1 and pt or i)
		end
		if not (pt or waitingToClearSelf) and IsInGroup() then
			waitingToClearSelf, EV.RAID_TARGET_UPDATE = 1, FinishClearRaidTargets
		end
	end)
	for i=1,8 do
		map[i] = AB:CreateActionSlot(raidmarkHint, i, "func", setRaidTarget, i)
	end
	local function createRaidMark(id)
		return map[id]
	end
	local function describeRaidMark(id)
		if id == 0 then return L"Raid Marker", REMOVE_WORLD_MARKERS, "Interface/Icons/INV_Gauntlets_02" end
		return L"Raid Marker", _G["RAID_TARGET_" .. id], "Interface/TargetingFrame/UI-RaidTargetingIcon_" .. id
	end
	AB:RegisterActionType("raidmark", createRaidMark, describeRaidMark, 1)
	RW:ImportSlashCmd("TARGET_MARKER", true, false, 40, function(_, _, clause, target)
		clause = tonumber(clause)
		if clause == 0 then
			return true, removeHint()
		elseif clause then
			return true, raidmarkHint(clause, nil, target)
		end
	end)
end)
securecall(function() -- worldmarker
	if not (MODERN or CF_CATA) then
		return
	end
	local NUM_WORLD_MARKERS = CF_CATA and NUM_WORLD_RAID_MARKERS_CATA == 5 and 5 or 8
	local map, icons = {}, {[0]="Interface/Icons/INV_Misc_PunchCards_White",
		"Interface/Icons/INV_Misc_QirajiCrystal_04","Interface/Icons/INV_Misc_QirajiCrystal_03",
		"Interface/Icons/INV_Misc_QirajiCrystal_05","Interface/Icons/INV_Misc_QirajiCrystal_02",
		"Interface/Icons/INV_Misc_QirajiCrystal_01",
		MODERN and "Interface/Icons/INV_Elemental_Primal_Fire" or 'Interface/TargetingFrame/UI-RaidTargetingIcon_2',
		MODERN and "Interface/Icons/INV_jewelcrafting_taladiterecrystal" or 'Interface/TargetingFrame/UI-RaidTargetingIcon_5',
		MODERN and "Interface/Icons/INV_jewelcrafting_taladitecrystal" or 'Interface/TargetingFrame/UI-RaidTargetingIcon_8'
	}
	local function Tooltip_SetWorldMark(tip, i)
		tip:SetText(i == 0 and REMOVE_WORLD_MARKERS or _G["WORLD_MARKER" .. i])
		if not IsInGroup() then
			tip:AddLine(ERR_NOT_IN_GROUP, 0.95, 0.15, 0, 1)
		elseif IsInRaid() and not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			tip:AddLine(ERR_NOT_LEADER, 0.95, 0.15, 0, 1)
		end
	end
	local function worldmarkHint(i)
		local canMark = not not (IsInGroup() and (not IsInRaid() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()))
		return canMark, i > 0 and IsRaidMarkerActive(i) and 1 or 0, icons[i], i == 0 and REMOVE_WORLD_MARKERS or _G["WORLD_MARKER" .. i], 0, 0, 0, Tooltip_SetWorldMark, i
	end
	for i=1, NUM_WORLD_MARKERS do
		map[i] = AB:CreateActionSlot(worldmarkHint, i, "attribute", "type","worldmarker", "action","toggle", "marker",i)
	end
	map[0] = AB:CreateActionSlot(worldmarkHint, 0, "macrotext", SLASH_CLEAR_WORLD_MARKER1 .. " " .. ALL)
	local function createWorldmark(id)
		return map[id]
	end
	local function describeWorldmark(id)
		if map[id] == nil then return L"Raid World Marker", "?" end
		return L"Raid World Marker", id == 0 and REMOVE_WORLD_MARKERS or _G["WORLD_MARKER" .. id], icons[id]
	end
	AB:RegisterActionType("worldmark", createWorldmark, describeWorldmark, 1)
	RW:SetCommandHint(SLASH_WORLD_MARKER1, 40, function(_, _, clause)
		clause = tonumber(clause)
		if map[clause] and clause > 0 then
			return true, worldmarkHint(clause)
		end
	end)
end)
securecall(function() -- extrabutton
	local slot = (MODERN or CF_CATA) and GetExtraBarIndex and (GetExtraBarIndex()*12 - 11)
	local function extrabuttonHint()
		if not HasExtraActionBar() then
			return false, 0, "Interface/Icons/temp", "", 0, 0, 0
		end
		local now, at, aid = GetTime(), GetActionInfo(slot)
		local inRange, usable, nomana, hasRange = NormalizeInRange[IsActionInRange(slot)], IsUsableAction(slot)
		inRange, hasRange = inRange ~= 0, inRange ~= nil
		local cdLeft, cdLength, enabled = toCooldown(now, GetActionCooldown(slot))
		local count, charges, maxCharges, ccdStart, ccdLength = GetActionCount(slot), GetActionCharges(slot)
		local state = ((IsCurrentAction(slot) or enabled == 0) and 1 or 0) +
		              (at == "spell" and IsSpellOverlayed(aid) and 2 or 0) +
		              (nomana and 8 or 0) + (inRange and 0 or 16) + (charges and charges > 0 and 64 or 0) + (hasRange and 512 or 0) + (usable and 0 or 1024) + (enabled == 0 and 2048 or 0)
		if charges and maxCharges and charges < maxCharges and cdLeft == 0 then
			cdLeft, cdLength = toCooldown(now, ccdStart, ccdLength, 1)
		end
		usable = not not (usable and inRange and (cdLeft == 0 or enabled == 0 or charges > 0))
		return usable, state, GetActionTexture(slot), GetActionText(slot) or (at == "spell" and GetSpellInfo(aid)), count <= 1 and charges or count, cdLeft, cdLength, callMethod.SetAction, slot
	end
	local aid = slot and AB:CreateActionSlot(extrabuttonHint, nil, "conditional", "[extrabar]", "attribute", "type","action", "action",slot)
	local aid2 = slot and AB:CreateActionSlot(extrabuttonHint, nil, "attribute", "type","action", "action",slot)
	local function createExtraButton(id, flags)
		local forceShow = flags == 1
		return id == 1 and (forceShow and aid2 or aid) or nil
	end
	local function describeExtraButton(_id)
		local name, tex = L"Extra Action Button", "Interface/Icons/Spell_Shadow_Teleport"
		if slot and HasExtraActionBar() then
			local at, aid = GetActionInfo(slot)
			name, tex = GetActionText(slot) or (at == "spell" and GetSpellInfo(aid)) or name, GetActionTexture(slot) or tex
		end
		return L"Extra Action Button", name, tex
	end
	AB:RegisterActionType("extrabutton", createExtraButton, describeExtraButton, 2)
	if slot then
		RW:SetClickHint("ExtraActionButton1", 95, function()
			if HasExtraActionBar() then
				return true, extrabuttonHint()
			end
		end)
	end
end)
securecall(function() -- zoneability auto-collection
	local skipZoneAbilities = {
		[436521]=1, [436524]=1, -- Pandaria remix: Extract Gem + Unraveling Sands
	}
	local col, tpos, colId = MODERN and {__embed=true} or nil, {}
	local function createZoneAbility(id)
		return id == 0 and colId or nil
	end
	local function describeZoneAbility(id)
		if id == 0 then
			return L"Zone Abilities", L"Zone Abilities", MODERN and [[Interface\Icons\Icon_TreasureMap]] or "Interface/Icons/Spell_Shadow_Teleport", nil, nil, nil, "collection"
		end
	end
	local function onZoneCollectionOpen(_, event, cid)
		if event ~= "internal.collection.preopen" or cid ~= colId then return end
		local changed, ni, za = nil, 1, C_ZoneAbility and C_ZoneAbility.GetActiveAbilities()
		for i=1, za and #za or 0 do
			local asid = za[i].spellID
			if asid and not (skipZoneAbilities[asid] or IsPassiveSpell(asid)) then
				local tk, aid = "INTZAs" .. asid, AB:GetActionSlot("spell", asid)
				if aid and not ((tpos[tk] or ni) < ni and col[tpos[tk]] == tk) then
					changed = changed or col[ni] ~= tk or col[tk] ~= aid
					col[ni], col[tk], tpos[tk], ni = tk, aid, ni, ni + 1
				end
			end
		end
		for i=ni, #col do
			local tk = col[i]
			changed, col[i], col[tpos[tk] == i and tk or i] = 1, nil, nil
		end
		if changed then
			AB:UpdateActionSlot(colId, col)
		end
	end
	colId = col and AB:CreateActionSlot(nil,nil, "collection",col)
	AB:RegisterActionType("zoneability", createZoneAbility, describeZoneAbility, 1)
	if col then
		AB:AddObserver("internal.collection.preopen", onZoneCollectionOpen)
		function EV:PLAYER_REGEN_DISABLED()
			onZoneCollectionOpen(nil, "internal.collection.preopen", colId)
		end
	end
end)
securecall(function() -- petspell: spell ID
	local actionInfo = {
		stay={"Interface\\Icons\\Spell_Nature_TimeStop", "PET_ACTION_WAIT"},
		move={"Interface\\Icons\\Ability_Hunter_Pet_Goto", "PET_ACTION_MOVE_TO", 1},
		follow={"Interface\\Icons\\Ability_Tracking", "PET_ACTION_FOLLOW"},
		attack={"Interface\\Icons\\Ability_GhoulFrenzy", "PET_ACTION_ATTACK"},
		defend={"Interface\\Icons\\Ability_Defend", "PET_MODE_DEFENSIVE"},
		assist={"Interface\\Icons\\Ability_Hunter_Pet_Assist", "PET_MODE_ASSIST"},
		passive={"Interface\\Icons\\Ability_Seal", "PET_MODE_PASSIVE"},
		dismiss={CLASS == "WARLOCK" and "Interface\\Icons\\spell_shadow_sacrificialshield" or "Interface\\Icons\\spell_nature_spiritwolf"}
	}
	local actionID = {}
	local petTip = MODERN and function(self, slot)
		return self:SetSpellBookItem(slot, BOOKTYPE_PET)
	end or function(self, slot)
		return self:SetPetAction(slot)
	end
	local petCommandFeedback = MODERN and function(info)
		local ico, name, slot = info[1], info[2], info[3]
		if GetSpellBookItemTexture(slot or 0, "pet") ~= ico then
			slot = nil
			for i=1,HasPetSpells() or 0 do
				if GetSpellBookItemTexture(i, "pet") == ico and GetSpellBookItemInfo(i, "pet") == "PETACTION" then
					info[3], slot = i, i
					break
				end
			end
		end
		return not not slot, slot and IsSelectedSpellBookItem(slot, "pet") and 1 or 0, ico, _G[name] or (slot and GetSpellBookItemName(slot, "pet")) or "", 0, 0, 0, slot and petTip or nil, slot
	end or function(info)
		local ico, name, slot = info[1], info[2], info[3]
		local sname, _icokey, _isToken, isActive, _autoCastAllowed, _autoCastEnabled, _spellID, hasRange, inRange = GetPetActionInfo(slot or 0)
		if sname ~= name then
			info[3], slot = nil
			for i=1,10 do
				sname, _icokey, _isToken, isActive, _autoCastAllowed, _autoCastEnabled, _spellID, hasRange, inRange = GetPetActionInfo(i)
				if sname == name then
					info[3], slot = i, i
					break
				end
			end
		end
		local flags = slot and (isActive and 1 or 0 + (hasRange and not inRange and 16 or 0) + (hasRange and 512 or 0)) or 0
		return not not slot and (inRange or not hasRange), flags, ico, _G[name] or name, 0, 0, 0, slot and petTip or nil, slot
	end
	local function petHint(sid)
		local info = actionInfo[sid]
		if sid == "dismiss" then
			if CLASS == "HUNTER" and PetCanBeAbandoned() then
				return spellFeedback(2641, nil, 2641)
			end
			return HasFullControl() and UnitExists("pet") and PetCanBeDismissed(), 0, info[1], PET_ACTION_DISMISS
		elseif info then
			return petCommandFeedback(info)
		elseif sid then
			return spellFeedback(sid, nil, sid)
		end
	end
	local function createPetAction(id)
		if type(id) == "number" and id > 0 and not actionID[id] and not IsPassiveSpell(id) and GetSpellInfo(id) then
			actionID[id] = AB:CreateActionSlot(petHint, id, "conditional","[petcontrol,known:" .. GetSpellInfo(id) .. "];hide", "attribute", "type","spell", "spell",id)
		end
		return actionID[id]
	end
	local function describePetAction(id)
		if type(id) == "number" then
			local name, _, icon = GetSpellInfo(id)
			return L"Pet Ability", name, icon, nil, callMethod.SetSpellByID, id
		elseif actionID[id] then
			local st, _, _, icon, name, _, _, _, tipf, tipa = nil, petHint(id)
			_, st = GetSpellBookItemName(tipa or 0, "pet")
			return MODERN and st or L"Pet Ability", name, icon, nil, tipf, tipa
		end
	end
	AB:RegisterActionType("petspell", createPetAction, describePetAction, 1)
	do
		local cnd, macroMap = "[petcontrol,@pet,help,novehicleui]", {}
		local function check(...)
			if ... ~= nil then
				return true, ...
			end
		end
		local function petmacroHint(slash, _, clause, _target)
			local aid = clause and macroMap[slash]
			if aid then
				return check(petHint(aid))
			end
		end
		local function addPetCommand(cmd, key)
			actionID[key] = AB:CreateActionSlot(petHint, key, "conditional", cnd, "macrotext", cmd)
			RW:SetCommandHint(cmd, 75, petmacroHint)
			macroMap[cmd:lower()] = key
		end
		addPetCommand(SLASH_PET_STAY1, "stay")
		addPetCommand(SLASH_PET_FOLLOW1, "follow")
		addPetCommand(SLASH_PET_ATTACK1, "attack")
		addPetCommand(SLASH_PET_DEFENSIVE1, "defend")
		addPetCommand(SLASH_PET_PASSIVE1, "passive")
		actionID.dismiss = AB:CreateActionSlot(petHint, "dismiss", "conditional", cnd, "macrotext", SLASH_PET_DISMISS1)
		if MODERN then
			addPetCommand(SLASH_PET_MOVE_TO1, "move")
			addPetCommand(SLASH_PET_ASSIST1, "assist")
		else
			actionInfo.assist = {"Interface/Icons/Ability_Racial_BloodRage", "PET_MODE_AGGRESSIVE"}
			addPetCommand(SLASH_PET_AGGRESSIVE1, "assist")
		end
	end
end)
securecall(function() -- toy: item ID, flags[FORCE_SHOW]
	if not (MODERN or CF_WRATH) then
		return
	end
	local map, lastUsability, uq, whinedAboutGIIR = {}, {}, {}
	local OVERRIDE_TOY_ACQUIRED, IGNORE_TOY_USABILITY = {}, {
		[129149]=1, [129279]=1, [129367]=1, [130157]="[in:broken isles]", [130158]=1, [130170]=1,
		[130191]=1, [130199]=1, [130232]=1, [131812]=1, [131814]=1, [140325]=1, [147708]=1,
		[165021]=1,
		[153039]=1, [119421]=1, [128462]="[alliance]", [128471]="[horde]", [95589]="[alliance]", [95590]="[horde]",
		[89222]=1, [63141]="[alliance]", [64997]="[horde]", [66888]=1, [89869]=1, [90175]=1,
		[103685]=1, [115468]="[horde]", [115472]="[alliance]", [119160]="[horde]", [119182]="[alliance]",
		[122283]=1, [142531]=1, [142532]=1, [163211]=1,
		[85500]="[fish5]",
		[182773]="[coven:necro][acoven80:necro]", [184353]="[coven:kyrian][acoven80:kyrian]", [180290]="[coven:fae][acoven80:fae]", [183716]="[coven:venthyr][acoven80:venthyr]", [190237] = 1,
	}
	local function playerHasToy(id)
		local f = OVERRIDE_TOY_ACQUIRED[id]
		if f then
			return f == true or f(id)
		end
		return f == nil and PlayerHasToy(id)
	end
	function toyHint(iid, _modState, target)
		local state, count, hasUsableCharge, now = 0, 0, false, GetTime()
		local _, name, icon = C_ToyBox.GetToyInfo(iid)
		local cdLeft, cdLength, enabled = toCooldown(now, C_Container.GetItemCooldown(iid))
		local ignUse, usable = IGNORE_TOY_USABILITY[iid]
		local _, sid = C_Item.GetItemSpell(iid)
		if not playerHasToy(iid) then
			usable = false
		elseif ignUse == nil then
			usable = C_ToyBox.IsToyUsable(iid) ~= false
		else
			usable = ignUse == 1 or (not not KR:EvaluateCmdOptions(ignUse))
		end
		target = target or "target"
		local canRange = not (InCombatLockdown() and (UnitIsFriend("player", target) or not UnitExists(target))) or nil
		local inRange, hasRange = canRange and NormalizeInRange[C_Item.IsItemInRange(iid, target)]
		inRange, hasRange = inRange ~= 0, inRange ~= nil
		state = state + (inRange and 0 or 16) + (hasRange and 512 or 0) + (enabled == 0 and 2048 or 0)
		if sid then
			local charges, maxCharges, ccdStart, ccdLength = GetSpellCharges(sid)
			-- BUG[11.0.2/2409]: GetSpellCharges[The Innkeeper's Daughter] returns the unified hearthstone state,
			-- but the *item cooldown* is actually enforced (longer + no second charge for Humans).
			count = charges and charges > 0 and cdLength == 0 and charges or count
			if charges and maxCharges and charges < maxCharges and cdLength == 0 then
				hasUsableCharge, cdLeft, cdLength = charges > 0, toCooldown(now, ccdStart, ccdLength, 1)
				state = state + (hasUsableCharge and 64 or 0)
			end
		end
		icon = icon or C_Item.GetItemIconByID(iid)
		usable = name and (hasUsableCharge or cdLeft == 0) and inRange and usable or false
		return usable, state, icon, name, count, cdLeft, cdLength, callMethod.SetToyByItemID, iid
	end
	function EV:GET_ITEM_INFO_RECEIVED(iid, ok)
		if not (ok and uq[iid]) then
			return
		end
		local iu = C_ToyBox.IsToyUsable(iid)
		if iu ~= nil then
			lastUsability[iid], uq[iid] = iu, nil
		elseif not whinedAboutGIIR then
			whinedAboutGIIR = true
			error("Curse your sudden but inevitable betrayal [" .. iid .. "]")
		end
	end
	local function wrapCondition(cnd, ...)
		if (cnd or 1) == 1 then
			return ...
		else
			return "conditional", cnd, ...
		end
	end
	local function createToy(id, flags)
		local forceShow = flags == 1
		local mid, ignUse = map[id], IGNORE_TOY_USABILITY[id]
		if not (mid or ignUse or type(id) == "number") or not (forceShow or playerHasToy(id)) then
			return
		end
		local isUsable = ignUse or C_ToyBox.IsToyUsable(id)
		if isUsable == nil then
			isUsable, uq[id] = lastUsability[id], 1
			C_Item.GetItemInfo(id)
		elseif not ignUse then
			lastUsability[id] = isUsable
		end
		if not (forceShow or isUsable) then
			mid = nil
		elseif mid == nil then
			mid = AB:CreateActionSlot(toyHint, id, wrapCondition(ignUse, "attribute", "type","toy", "toy",id))
			map[id] = mid
		end
		return mid
	end
	local function describeToy(id)
		if type(id) ~= "number" then return end
		local _, name, tex = C_ToyBox.GetToyInfo(id)
		return L"Toy", name, tex or C_Item.GetItemIconByID(id), nil, callMethod.SetToyByItemID, id
	end
	AB:RegisterActionType("toy", createToy, describeToy, 2)
	RW:SetCommandHint(SLASH_USE_TOY1, 60, function(_, _, clause, target)
		if clause and clause ~= "" then
			local iid = C_Item.GetItemIDForItemInfo(clause)
			if iid then
				return true, toyHint(iid, nil, target)
			end
		end
	end)
	function AB.HUM:SetPlayerHasToyOverride(id, filter)
		local tf = type(filter)
		if not (type(id) == "number" and (tf == "nil" or tf == "boolean" or tf == "function")) then
			return error('SetPlayerHasToyOverride: invalid arguments', 2)
		end
		OVERRIDE_TOY_ACQUIRED[id] = filter
	end
end)
securecall(function() -- disenchant: iid
	local map, DISENCHANT_SID = {}, 13262
	local DISENCHANT_SN = GetSpellInfo(DISENCHANT_SID)
	local ICON_PREFIX = "|TInterface/Buttons/UI-GroupLoot-DE-Up:0:0|t "
	local SLASH_SPELL_TARGET_ITEM1 = '/spelltargetitem' do
		local wn = newWidgetName("AB:I!")
		local w = CreateFrame("Button", wn, nil, "SecureActionButtonTemplate")
		w:SetAttribute("pressAndHoldAction", 1)
		w:Hide()
		SecureHandlerWrapScript(w, "OnClick", w, [[return nil, 'post']], [[self:SetAttribute("target-item", nil)]])
		local er = {u="\\117", ["{"]="\\123", ["}"]="\\125"}
		local function escape(s)
			return ("%q"):format(s):gsub('[{u}]', er):sub(2,-2)
		end
		w:SetAttribute("RunSlashCmd", ([[-- AB_SPELLTARGET_ITEM_RUN 
			local cmd, v = ...
			if cmd == "%s" and v then
				self:SetAttribute("target-item", v)
				return "%s"
			end
		]]):format(escape(SLASH_SPELL_TARGET_ITEM1), escape(SLASH_CLICK1 .. " " .. wn .. " 1")))
		RW:RegisterCommand(SLASH_SPELL_TARGET_ITEM1, true, false, w)
	end
	local function disenchantTip(self, iid)
		self:SetItemByID(iid)
		self:AddLine(ICON_PREFIX .. DISENCHANT_SN, 0, 1, 0)
		self:Show()
	end
	local function disenchantHint(ident)
		local count = C_Item.GetItemCount(ident, false, false, false)
		local usable = IsPlayerSpell(DISENCHANT_SID) and count > 0
		local name = C_Item.GetItemNameByID(ident)
		local qual = MODERN and ident and (C_TradeSkillUI.GetItemReagentQualityByItemInfo(ident) or C_TradeSkillUI.GetItemCraftedQualityByItemInfo(ident))
		qual = qual and qual > 0 and qual < 8 and (qual * 16384) or 0
		local cdLeft, cdLength, enabled = toCooldown(GetTime(), GetSpellCooldown(DISENCHANT_SID))
		local state = (C_Item.IsCurrentItem(ident) and 1 or 0) + (usable and 0 or 1024) + qual + 131072 + (enabled == 0 and 2048 or 0)
		local disName = ICON_PREFIX .. (name or ("item:" .. ident))
		return not not (usable and cdLeft == 0), state, C_Item.GetItemIconByID(ident), disName, count,
			cdLeft or 0, cdLength or 0, disenchantTip, ident
	end
	local function createDisenchant(iid)
		if not (IsPlayerSpell(13262) and type(iid) == "number" and C_Item.GetItemCount(iid) > 0) then
			return
		end
		local mid = map[iid]
		if not mid then
			local macrotext = ("%s\n%s [@none] spell:%d\n%s item:%d\n%1$s"):format(SLASH_STOPSPELLTARGET1, SLASH_CAST1, DISENCHANT_SID, SLASH_SPELL_TARGET_ITEM1, iid)
			mid = AB:CreateActionSlot(disenchantHint, iid, "retext", macrotext)
			map[iid] = mid
		end
		return mid
	end
	local function describeDisenchant(iid)
		if type(iid) ~= "number" then return end
		local icon, name = C_Item.GetItemIconByID(iid), C_Item.GetItemNameByID(iid)
		return DISENCHANT_SN, name or ("item:" .. iid), icon, nil, disenchantTip, iid
	end
	AB:RegisterActionType("disenchant", createDisenchant, describeDisenchant, 1)
end)
securecall(function() -- /ping
	if not MODERN then
		return
	end
	local TOKENS, INFO = {}, {
		{PING, "Ping_Marker_Icon_NonThreat"},
		{PING, "Ping_Marker_Icon_Threat"},
		assist={PING_TYPE_ASSIST, "Ping_Wheel_Icon_Assist"},
		attack={PING_TYPE_ATTACK, "Ping_Wheel_Icon_Attack"},
		onmyway={PING_TYPE_ON_MY_WAY, "Ping_Marker_Icon_OnMyWay"},
		warning={PING_TYPE_WARNING, "Ping_Wheel_Icon_Warning"},
	}
	for k,v in pairs(INFO) do
		if type(k) == "string" then
			TOKENS[v[1]:lower()] = k
		end
	end
	RW:SetCommandHint(SLASH_PING1, 40, function(_, _, clause, target)
		if clause then
			clause = lowered[clause]
			local ci = INFO[TOKENS[clause] or clause] or INFO[C_Ping.GetContextualPingTypeForUnit(UnitGUID(target ~= "cursor" and target or "mouseover") or nil) == 4 and 2 or 1]
			local perm = (not IsInRaid() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or not C_PartyInfo.GetRestrictPings())
			local cdInfo, nowMs = C_Ping.GetCooldownInfo(), GetTime()*1000
			local cd = cdInfo.endTimeMs > nowMs and (cdInfo.endTimeMs-nowMs)/1000 or 0
			return true, perm and cd == 0 or false, 262144, ci[2], ci[1], 0, cd, cd > 0 and (cdInfo.endTimeMs-cdInfo.startTimeMs)/1000 or 0
		end
	end)
end)
securecall(function() -- uipanel: token
	local CLICK, pyCLICK, widgetClickCommand, widgetAttrCommand, closeButton = SLASH_CLICK1 .. " " do
		local pyName, attrCounter = newWidgetName("AB:PY!"), 500
		local py = CreateFrame("Button", pyName, nil, "SecureActionButtonTemplate")
		py:SetAttribute("type", "click")
		py:SetAttribute("pressAndHoldAction", 1)
		pyCLICK = CLICK .. pyName .. " "
		function widgetClickCommand(k, w)
			if w == nil then return "" end
			local tn = type(w) == "string" and w or w.GetName and w:GetName()
			if tn == nil then
				local w1 = py:GetAttribute("clickbutton-" .. k)
				k = (w1 and w1 ~= w) and k .. "2" or k
				py:SetAttribute("clickbutton-" .. k, w)
				tn = pyName .. " " .. k
			end
			return CLICK .. tn .. " 1\n"
		end
		function widgetAttrCommand(w, ...)
			local r = ""
			for i=1,select("#", ...), 2 do
				local bs, k,v = "-at" .. attrCounter, select(i, ...)
				py:SetAttribute("type" .. bs, "attribute")
				py:SetAttribute("attribute-frame" .. bs, w)
				py:SetAttribute("attribute-name" .. bs, k)
				py:SetAttribute("attribute-value" .. bs, v)
				r, attrCounter = r .. CLICK .. pyName .. " at" .. attrCounter .. " 1\n", attrCounter + 1
			end
			return r
		end
		function closeButton(p, reg)
			local r = CreateFrame("Button", nil, p, "UIPanelCloseButton")
			r:Hide()
			return r, reg and widgetClickCommand(reg, r)
		end
	end
	local ShowVaultTip if MODERN then
		local unlockedRewards, needRefresh
		function EV:WEEKLY_REWARDS_UPDATE()
			unlockedRewards = nil
		end
		local function genRewardPreview()
			needRefresh = nil
			if C_WeeklyRewards.HasGeneratedRewards() then
				local a, ni = C_WeeklyRewards.GetActivities(), 1
				local getRewardLink, getItemLevel = C_WeeklyRewards.GetItemHyperlink, C_Item.GetDetailedItemLevelInfo
				for i=1, a and #a or 0 do
					local ai = a[i]
					if ai and ai.rewards and ai.rewards[1] then
						local ilink, q = getRewardLink(ai.rewards[1].itemDBID), ai.rewards[1].quantity
						local ilvl = (ilink and getItemLevel(ilink) or -1)
						local suf = (q or 1) > 1 and " (x" .. q .. ")" or (" (" .. ITEM_LEVEL_ABBR .. " " .. ilvl .. ")")
						a[ni], ni, needRefresh = ilink .. suf, ni + 1, needRefresh or ilvl == -1
					end
				end
				unlockedRewards = table.concat(a, "\n", 1, ni-1) or ""
				return
			end
			local getExampleReward, getItemLevel = C_WeeklyRewards.GetExampleRewardItemHyperlinks, C_Item.GetDetailedItemLevelInfo
			local a, ni = not C_WeeklyRewards.HasAvailableRewards() and C_WeeklyRewards.GetActivities(), 1
			for i=1,a and #a or 0 do
				local ai = a[i]
				if ai and ai.progress >= ai.threshold then
					local ilink = getExampleReward(ai.id)
					local ilvl = ilink and getItemLevel(ilink) or -1
					a[ni], ni, needRefresh = ilvl, ni + 1, needRefresh or ilvl == -1
				end
			end
			unlockedRewards = ""
			if ni > 1 then
				for i=#a, ni, -1 do
					a[i] = nil
				end
				table.sort(a)
				local ec = ITEM_QUALITY_COLORS[4].hex
				local si, j, ilvl, sj = ni, ni-1
				while j > 0 do
					ilvl, sj = a[j], j
					repeat j = j - 1 until a[j] ~= ilvl
					a[ni], ni = ec .. ITEM_LEVEL:format(ilvl) .. (sj > j+1 and "|r (x" .. (sj-j) .. ")" or "|r"), ni + 1
				end
				unlockedRewards = table.concat(a, "\n", si, ni-1)
			end
		end
		function ShowVaultTip(GameTooltip)
			local hc = HIGHLIGHT_FONT_COLOR
			GameTooltip:SetText(DELVES_GREAT_VAULT_LABEL)
			if unlockedRewards == nil or needRefresh then
				genRewardPreview()
			end
			if (unlockedRewards or "") ~= "" then
				GameTooltip:AddLine(unlockedRewards, hc.r, hc.g, hc.b)
			elseif C_WeeklyRewards.HasAvailableRewards() then
				GameTooltip:AddLine(GREAT_VAULT_REWARDS_WAITING, 0.1, 0.9, 0.1, 1)
			else
				GameTooltip:AddLine(WEEKLY_REWARDS_ADD_ITEMS, 0.75, 0.75, 0.75, 1)
			end
			if InCombatLockdown() and not WeeklyRewardsFrame:IsShown() then
				GameTooltip:AddLine("|A:gmchat-icon-blizz:0:0|a " .. ERR_NOT_IN_COMBAT, 1, 0, 0, 1)
			end
			GameTooltip:Show()
		end
	end
	local function openPanelFallback(panel)
		return not InCombatLockdown() and ShowUIPanel(panel)
	end
	local panelMap, panels = {}, {
		character={CHARACTER, icon="Interface/PVPFrame/Icons/prestige-icon-7-3", gw=PaperDollFrame, tw=CharacterFrameTab1},
		reputation={REPUTATION, icon="Interface/Icons/Achievement_Reputation_01", gw=ReputationFrame, tw=MODERN and CharacterFrameTab2 or CharacterFrameTab3},
		currency={CURRENCY, icon="Interface/Icons/INV_Misc_Coin_17", gw=TokenFrame, tw=MODERN and CharacterFrameTab3 or CF_WRATH and CharacterFrameTab5},
		spellbook={SPELLBOOK, icon="Interface/Icons/INV_Misc_Book_09", gw=CF_CLASSIC and SpellBookFrame, tmt="/click SpellbookMicroButton\n/click SpellBookFrameCloseButton", cw=SpellBookFrameCloseButton},
		talents={TALENTS_BUTTON, icon="Interface/Icons/Ability_Marksmanship", gn=CF_CLASSIC and "PlayerTalentFrame", tw=CF_CLASSIC and TalentMicroButton, req=function() return (UnitLevel("player") or 0) >= 10 end},
		achievements={ACHIEVEMENTS, atlas="UI-HUD-MicroMenu-Achievements-Up", gn="AchievementFrame", tw=AchievementMicroButton, tcr=1},
		quests={QUESTLOG_BUTTON, icon="Interface/Icons/INV_Misc_Book_08", gw=MODERN and QuestMapFrame or QuestLogFrame, tw=QuestLogMicroButton},
		groupfinder={DUNGEONS_BUTTON, icon=MODERN and "Interface/Icons/LEVELUPICON-LFD" or "Interface/LFGFrame/BattlenetWorking0", gw=PVEFrame, tw=LFDMicroButton},
		collections=MODERN and {COLLECTIONS, icon="Interface/Icons/INV_Box_01", gn="CollectionsJournal", tw=CollectionsMicroButton},
		adventureguide=MODERN and {ADVENTURE_JOURNAL, icon="Interface/EncounterJournal/UI-EJ-PortraitIcon", gn="EncounterJournal", tw=EJMicroButton},
		guild=MODERN and {GUILD_AND_COMMUNITIES, icon="Interface/Icons/INV_Shirt_GuildTabard_01", gn="CommunitiesFrame", tw=GuildMicroButton}
		              or {title=GUILD, icon="Interface/Icons/INV_Shirt_GuildTabard_01", gw=GuildFrame, ow=FriendsFrameTab3, cw=FriendsFrameCloseButton, req=IsInGuild},
		map={WORLD_MAP, icon=CI_ERA and "Interface/Worldmap/WorldMap-Icon" or "Interface/Icons/Inv_Misc_Map08", gw=WorldMapFrame, tw=MODERN and MinimapCluster.ZoneTextButton or MiniMapWorldMapButton},
		social={SOCIAL_BUTTON, icon=MODERN and "Interface/Icons/UI_Chat" or "Interface/Icons/INV_Scroll_03", gw=FriendsFrame, tw=MODERN and QuickJoinToastButton or FriendsMicroButton},
		calendar={L"Calendar", icon="Interface/Icons/Spell_Holy_BorrowedTime", gn="CalendarFrame", tw=GameTimeFrame},
		options={OPTIONS, icon=MODERN and "Interface/Icons/Misc_RnRWrenchButtonRight" or "Interface/Icons/INV_Misc_Wrench_01", gw=SettingsPanel, noduck=1, open=function() Settings.OpenToCategory(nil) end},
		macro={MACROS, icon="Interface/Icons/INV_Misc_Note_06", gn="MacroFrame", tmt=SLASH_MACRO1, cw=closeButton(MacroFrame), postmt=pyCLICK .. "csp 1\n" .. pyCLICK .. "cgm 1"},
		profs=MODERN and {TRADE_SKILLS, icon="interface/icons/inv_pick_02", tw=ProfessionMicroButton},
		gamemenu={MAINMENU_BUTTON, icon=CF_CLASSIC and "Interface/Icons/INV_Misc_PunchCards_Red", atlas="UI-HUD-MicroMenu-GameMenu-Up", gw=GameMenuFrame, tmt="/click GameMenuButtonContinue", noduck=1, pre=function() return not GameMenuFrame:IsShown() or nil end, post=function() RatingMenuFrame:Show() RatingMenuFrame:Hide() PlaySound(SOUNDKIT.IG_MAINMENU_OPEN) end},
		vault=MODERN and {DELVES_GREAT_VAULT_LABEL, icon="Interface/Icons/INV_Cape_Special_Treasure_C_01", gn="WeeklyRewardsFrame", skipCloseSound=169062, req=function() return UnitLevel("player") == 80 end, tip=ShowVaultTip, open=openPanelFallback},
		csp={gw=SettingsPanel, cpreamble=true, cw=closeButton(SettingsPanel, "csp")},
		cgm={gw=GameMenuFrame, cpreamble=true, cw=closeButton(GameMenuFrame, "cgm")},
		csf={pre=function() return StoreFrame_IsShown and StoreFrame_SetShown and StoreFrame_IsShown() and StoreFrame_SetShown(false) end, cpreamble=true},
	}
	do
		local exName = newWidgetName("AB:PX!")
		local clickEx = CLICK .. " " .. exName .. " "
		local cmdPrefix = clickEx .. "csf 1\n" .. clickEx
		local cmdDuckPrefix = cmdPrefix .. "csp 1\n" .. clickEx .. "cgm 1\n" .. clickEx
		local ex = CreateFrame("Button", exName, nil, "SecureActionButtonTemplate")
		ex:SetAttribute("type", "macro")
		ex:SetAttribute("pressAndHoldAction", 1)
		local function prerun(k)
			local i, r = panels[k], 0
			local tw, gw, cw, ow, ofun, scs = i.tw, i.gw, i.cw, i.ow, i.open, i.skipCloseSound
			if tw and not tw:IsEnabled() then
				r = i.tcr and r + 1 or r; tw:Enable()
			end
			if cw or ow or scs or ofun then
				local gh, cd, od = not (gw and gw:IsShown()), not (cw and cw:IsEnabled()), not (ow and ow:IsEnabled())
				if cw and gh ~= cd then
					r = r + (gh and 6 or 2); cw:SetEnabled(not gh)
				end
				if ow and gh == od then
					r = r + (gh and 8 or 24); ow:SetEnabled(gh)
				end
				if scs and not gh then
					local ok, sh = PlaySound(scs)
					if ok and sh then
						r, i.stopSoundHandle = r + 32, sh
					end
				end
				if ofun and gh == od then
					securecall(ofun, gw, k)
				end
			end
			return r ~= 0 and r or nil
		end
		local function postrun(k, m)
			local i, m1, m3, m5 = panels[k], m % 2, m % 8, m % 32
			if m5 >= 8 then i.ow:SetEnabled(m5 > 8) end
			if m3 >= 2 then i.cw:SetEnabled(m3 > 2) end
			if m1 >= 1 then i.tw:Disable() end
			local ssh = i.stopSoundHandle
			i.stopSoundHandle = ssh and StopSound(ssh) and nil
		end
		ex:SetScript("PreClick", function(_, b)
			local i = panels[b]
			if i and i.pre then
				i.postMessage = i.pre(b)
			end
		end)
		ex:SetScript("PostClick", function(_, b)
			local i, bp, pm = panels[b]
			bp = i and i.cpreamble and b or b:match("^post%-(.*)")
			i = panels[bp]
			pm = i and i.postMessage
			if pm ~= nil and i.post then
				i.postMessage = nil
				i.post(bp, pm)
			end
		end)
		local function prepareMacroText(k, v)
			local tmt = v.tmt
			if tmt then
				tmt = tmt:gsub("/click ", CLICK)
			elseif v.tw then
				tmt = widgetClickCommand(k, v.tw)
			elseif v.cw or v.ow then
				tmt = widgetClickCommand(k, v.ow) .. widgetClickCommand(k, v.cw)
			end
			if v.tw or v.cw or v.ow or v.open or v.cwrap then
				v.pre, v.post = v.pre or prerun, v.post or postrun
			end
			if tmt and v.premt then
				tmt = v.premt .. "\n" .. tmt
			end
			if tmt and v.postmt then
				tmt = tmt .. "\n" .. v.postmt
			end
			if v.post then
				tmt = tmt .. (tmt:sub(-1) ~= "\n" and "\n" or "") .. clickEx .. "post-" .. k
			end
			tmt = tmt and ((v.noduck and cmdPrefix or cmdDuckPrefix) .. k .. " 1\n" .. tmt)
			return tmt
		end
		local pmeta = {__index=function(t, k)
			local n, r = k == "gw" and t.gn
			if n then
				r = _G[n]
			elseif k == "mainText" then
				r = prepareMacroText(t.pk, t)
			end
			if k ~= nil then
				t[k] = r
			end
			return r
		end}
		for k,v in pairs(panels) do
			v.pk = k
			setmetatable(v, pmeta)
		end
	end
	do -- further panels init
		local fpd = CF_WRATH and securecall(function()
			local tf, x2, x = CreateFrame("Frame"), EnumerateFrames(), nil
			tf:SetAttribute("UIPanelLayout-defined", 1)
			tf:SetAttribute("UIPanelLayout-area", "none")
			HideUIPanel(tf)
			repeat
				x, x2 = EnumerateFrames(x), x2 and EnumerateFrames(x2)
				x2 = x2 and (x2 == x and x2 or EnumerateFrames(x2))
				if x and x.ShowUIPanel and x.GetAttribute and x:GetAttribute("panel-frame") == tf then
					return x
				end
			until x == nil or x == x2
		end)
		panels.options.cw = panels.csp.cw
		panels.macro.postmt = widgetClickCommand("cmf", panels.macro.cw)
		if MODERN then
			panels.gamemenu.cw, panels.gamemenu.tmt = panels.cgm.cw, nil
			panels.spellbook.tmt, panels.spellbook.cwrap, panels.spellbook.cw, panels.spellbook.ow = "/click PlayerSpellsFrameCloseButton\n/click PlayerSpellsMicroButton\n" .. pyCLICK .. " spelltab 1", 1, nil
			panels.talents.tmt, panels.talents.cwrap, panels.talents.tw = "/click PlayerSpellsFrameCloseButton\n/click PlayerSpellsMicroButton\n" .. pyCLICK .. " talenttab 1", 1, nil
			function EV.PLAYER_LOGIN()
				pcall(C_AddOns.LoadAddOn, "Blizzard_PlayerSpells")
				panels.spellbook.gw = PlayerSpellsFrame.SpellBookFrame
				panels.talents.gw, panels.talents.gn = PlayerSpellsFrame.TalentsFrame, nil
				panels.spellbook.ow, panels.talents.ow = PlayerSpellsFrameCloseButton, PlayerSpellsFrameCloseButton
				if PlayerSpellsFrame and PlayerSpellsFrame.tabSystem and PlayerSpellsFrame.tabSystem.tabs then
					widgetClickCommand("spelltab", PlayerSpellsFrame.tabSystem.tabs[PlayerSpellsFrame.spellBookTabID])
					widgetClickCommand("talenttab", PlayerSpellsFrame.tabSystem.tabs[PlayerSpellsFrame.talentTabID])
				end
				if (UnitLevel("player") or 0) < 80 then
					function EV:PLAYER_LEVEL_UP(nlvl)
						if nlvl == 80 then
							AB:NotifyObservers("uipanel")
							return "remove"
						end
					end
				end
				return "remove"
			end
			pcall(C_AddOns.LoadAddOn, "Blizzard_WeeklyRewards")
			panels.vault.cw = closeButton(panels.vault.gw)
		else -- not MODERN
			if CF_WRATH then
				panels.achievements.icon = "Interface/PvPFrame/Icons/prestige-icon-4"
				local gfp = panels.groupfinder
				gfp.tw, gfp.cw, gfp.skipCloseSound = nil, closeButton(gfp.gw), 839
				if fpd then
					gfp.premt = widgetClickCommand("groupfinder", gfp.cw) .. widgetAttrCommand(fpd, "panel-force",false, "panel-frame",gfp.gw, "panel-show",true) .. CLICK .. "GroupFinderFrameGroupButton1"
				else
					gfp.open, gfp.premt = openPanelFallback, CLICK .. "GroupFinderFrameGroupButton1"
				end
				function panels.currency.req()
					return GetCurrencyListSize() > 0
				end
			else
				panels.achievements = nil
				panels.groupfinder = nil
				panels.currency = nil
				panels.calendar = nil
				panels.reputation.icon = "Interface/Icons/INV_MISC_NOTE_02"
			end
		end
		function EV.ADDON_LOADED()
			if MacroFrame then
				panels.macro.cw:SetParent(MacroFrame)
				return "remove"
			end
		end
	end
	local function panelHint(tk)
		local i = panels[tk]
		if not i then return end
		local gw, icon, s = i.gw, i.icon, 0
		s = (gw and gw:IsVisible()) and s + 1 or s
		if icon == nil then
			icon, s = i.atlas, s + 262144
		end
		local tf = i.tip or nil
		local willFail = MODERN and AreAllPanelsDisallowed() or (gw and i.open == openPanelFallback and InCombatLockdown() and not gw:IsVisible())
		return tk == "gamemenu" or not willFail, s, icon, i[1], nil, nil, nil, tf, tf and tk
	end
	local function createPanel(tk)
		local r = panelMap[tk]
		local pi = r == nil and panels[tk]
		if pi and pi[1] and pi.mainText and (pi.req == nil or pi.req()) then
			r = AB:CreateActionSlot(panelHint, tk, "macrotext", pi.mainText)
			panelMap[tk] = r
		end
		return r
	end
	local function describePanel(tk)
		local i = panels[tk]
		if i and i[1] then
			return L"Interface Panel", i[1], i.icon or i.atlas
		end
		return L"Interface Panel"
	end
	AB:RegisterActionType("uipanel", createPanel, describePanel, 1)
end)