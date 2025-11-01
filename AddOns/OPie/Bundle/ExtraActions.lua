local COMPAT, _, T = select(4, GetBuildInfo()), ...
local MODERN = COMPAT > 11e4

local L, EV, PC, AB, KR = T.L, T.Evie, T.OPieCore, T.ActionBook
AB, KR = AB and AB:compatible(2, 45), AB and AB:compatible("Kindred", 1, 33)
assert(EV and PC and AB and KR and 1, "Incompatible library bundle")
if T.TenEnv then T.TenEnv() end

KR:SetStateConditionalValue("dupeab", false) do
	local DUP_SPELL_ID = {
		[1257665]=1, [1250255]=1, -- Exit K'aresh Phasedive
	}
	local function syncDupEAB()
		local at, sid = GetActionInfo(GetExtraBarIndex()*12-11)
		KR:SetStateConditionalValue("dupeab", not not (at == "spell" and DUP_SPELL_ID[sid]))
	end
	EV.UPDATE_EXTRA_ACTIONBAR = syncDupEAB
end
do -- action handler
	local col, state, dropInfo, cid = {__embed=true}, 0
	local PlayerHasBuff do
		local sid1, aid1, sid2, aid2
		function PlayerHasBuff(sid)
			local s1 = sid1 == sid
			local aid = s1 and aid1 or sid2 == sid and aid2 or nil
			if aid == nil or C_UnitAuras.IsAuraFilteredOutByInstanceID("player", aid, "HELPFUL") then
				local ad = C_UnitAuras.GetPlayerAuraBySpellID(sid)
				sid2, aid2 = s1 and sid2 or sid1, s1 and aid2 or aid1
				sid1, aid1 = sid, ad and ad.auraInstanceID
			elseif not s1 then
				sid1, aid1, sid2, aid2 = sid2, aid2, sid1, aid1
			end
			return aid1 ~= nil
		end
	end
	local function syncZoneContextActions()
		local _,_,_,_, _,_,_,imid = GetInstanceInfo()
		local wantDrop = imid == 2127 and PlayerHasBuff(458069) and 1 or imid == 2738 and PlayerHasBuff(1214374) and 2
		local wantGoPack = imid == 2127 and C_Item.GetItemCount(230728) > 0 and not PlayerHasBuff(469809) and 8
		local newState, ni = (wantDrop or 0) + (wantGoPack or 0), 1
		if state == newState then
			return
		end
		state = newState
		if wantDrop then
			col[ni], ni = dropInfo[wantDrop][5], ni + 1
		end
		if wantGoPack then
			col[ni], ni = "OPZCAxSIGP", ni + 1
		end
		for i=ni,#col do
			col[i] = nil
		end
		AB:UpdateActionSlot(cid, col)
	end
	local function mcallSetSpellByID(self, sid)
		return self:SetSpellByID(sid)
	end
	local function hintDrop(did)
		local di = dropInfo[did]
		return PlayerHasBuff(di[2]), 0, di[3], di[4], 0,0,0, mcallSetSpellByID, di[1]
	end
	local function zcaDropAura(tok, fakeSpellID, buffSpellID)
		return {fakeSpellID, buffSpellID, GetSpellTexture(fakeSpellID), GetSpellInfo(fakeSpellID), tok}
	end
	local function initZoneContextActions()
		initZoneContextActions = nil
		cid = AB:CreateActionSlot(nil,nil, "collection",col)
		col.OPZCAxSIGP = AB:GetActionSlot("item", 230728, 1)
		dropInfo = {
			zcaDropAura("OPZCAxDrST", 470530, 458069), -- Seafury Tempest (Siren Isle)
			zcaDropAura("OPZCAxDrPD", 1250255, 1214374), -- Phase Diving (K'aresh)
		}
		for i=1,#dropInfo do
			local di = dropInfo[i]
			col[di[5]] = AB:CreateActionSlot(hintDrop, i, "attribute", "type","cancelaura", "spell",(GetSpellInfo(di[2])))
		end
		AB:AddObserver("internal.collection.preopen", function(_, _, id)
			if id == cid and not InCombatLockdown() then
				syncZoneContextActions()
			end
		end)
		EV.PLAYER_REGEN_DISABLED = syncZoneContextActions
		return cid
	end
	local function createXact(_kind)
		return MODERN and (cid or initZoneContextActions()) or nil
	end
	local function describeXact(_kind)
		return L"Extra Actions", L"Extra Actions", "Interface/Icons/INV_Misc_Lantern_01", nil, nil, nil, "collection"
	end
	PC:RegisterExtAction("xact", createXact, describeXact)
end
if MODERN then
	AB:AddActionToCategory("Miscellaneous", "opie.ext", "xact")
end