if select(4,GetBuildInfo()) >= 2e4 then return end
local AB, _, T = assert(OneRingLib.ext.ActionBook:compatible(2,14), "Requires a compatible version of ActionBook"), ...
local EV, L = T.Evie, T.L

do -- OPieAutoQuest
	local pwhitelist, blacklist, whitelist = {}, {}
	local collection, inring, ctok, colId = {}, {}, 0

	local itypeQuest, lastQEvent = nil, 0
	local function isActiveQuestItem(iid, popwhitelist)
		local _, _, _, _, _, iType = GetItemInfo(iid)
		itypeQuest = itypeQuest or select(6, GetItemInfo(9570)) or select(6, GetItemInfo(12900)) or select(6, GetItemInfo(3618))
		local itypeQuest = itypeQuest or "Quest"
		if (GetTime()-lastQEvent) < 1 and iType ~= itypeQuest and popwhitelist then
			-- Item received in shortly after starting a quest; add it just in case.
			whitelist[iid] = true
		end
		return iid and (iType == itypeQuest or whitelist[iid]) and GetItemSpell(iid) and not blacklist[iid]
	end
	local function syncRing(_, _, upId)
		if upId ~= colId then return end
		local current, changed = (ctok+1) % 2, false
		for bag=0,4 do
			for slot=1,GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				local iid = link and tonumber(link:match("item:(%d+)"))
				if link and iid and isActiveQuestItem(iid) then
					local tok = "OPieBundleQuest" .. iid
					if not inring[tok] then
						collection[#collection+1], collection[tok], changed = tok, AB:GetActionSlot("item", iid), true
					end
					inring[tok] = current
				end
			end
		end
		for i=0,INVSLOT_LAST_EQUIPPED do
			local iid = GetInventoryItemID("player", i) or 0
			if iid ~= 0 and isActiveQuestItem(iid) then
				local tok = "OPieBundleQuest" .. iid
				if not inring[tok] then
					collection[#collection+1], collection[tok], changed = tok, AB:GetActionSlot("item", iid), true
				end
				inring[tok] = current
			end
		end
		
		local freePos, oldCount = 1, #collection
		for i=freePos, oldCount do
			local v = collection[i]
			if inring[v] ~= current then
				whitelist[v:match("%d+")+0] = nil
			end
			collection[freePos], freePos, collection[v], inring[v] = collection[i], freePos + (inring[v] == current and 1 or 0), (inring[v] == current and collection[v] or nil), inring[v] == current and current or nil
		end
		for i=oldCount,freePos,-1 do
			collection[i] = nil
		end
		ctok = current
		
		if changed or freePos <= oldCount then
			AB:UpdateActionSlot(colId, collection)
		end
	end
	function EV.QUEST_ACCEPTED()
		lastQEvent = GetTime()
	end
	function EV:CHAT_MSG_LOOT(text)
		local iid = text:match("|Hitem:(%d+).-|h")
		if iid then
			isActiveQuestItem(iid+0, true)
		end
	end
	function EV.PLAYER_ENTERING_WORLD()
		itypeQuest = select(6, GetItemInfo(9570)) or select(6, GetItemInfo(12900)) or select(6, GetItemInfo(3618))
		return "remove"
	end
	function EV.GET_ITEM_INFO_RECEIVED()
		itypeQuest = itypeQuest or select(6, GetItemInfo(9570)) or select(6, GetItemInfo(12900)) or select(6, GetItemInfo(3618))
		return itypeQuest and "remove"
	end

	whitelist = setmetatable(OneRingLib:RegisterPVar("AutoQuestWhitelist", {}), {__index=pwhitelist})
	colId = AB:CreateActionSlot(nil,nil, "collection",collection)
	OneRingLib:SetRing("OPieAutoQuest", colId, {name=L"Quest Items", hotkey="ALT-Q"})
	AB:AddObserver("internal.collection.preopen", syncRing)
	function EV.PLAYER_REGEN_DISABLED()
		syncRing(nil, nil, colId)
	end
end