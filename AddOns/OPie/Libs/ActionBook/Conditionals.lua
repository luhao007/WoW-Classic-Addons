local _, T = ...
if T.SkipLocalActionBook then return end
local MODERN = select(4,GetBuildInfo()) >= 8e4
local KR, EV = assert(T.ActionBook:compatible("Kindred", 1,12), "A compatible version of Kindred is required"), T.Evie
local playerClassLocal, playerClass = UnitClass("player")

local safequote do
	local r = {u="\\117", ["{"]="\\123", ["}"]="\\125"}
	function safequote(s)
		return (("%q"):format(s):gsub("[{}u]", r))
	end
end

local RegisterStateConditional do
	local f = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
	f:SetFrameRef("KR", KR:seclib())
	f:Execute('KR, cndName, curValue = self:GetFrameRef("KR"), newtable(), newtable()')
	f:SetAttribute("_onattributechanged", [[--
		local state = name:match("^state%-(.+)")
		if state and value ~= "_" then
			KR:RunAttribute("UpdateStateConditional", cndName[state], value, curValue[state] or "")
			curValue[state] = value
		end
	]])
	function RegisterStateConditional(name, forName, conditional, usesExtendedConditionals)
		f:SetAttribute(forName, "_")
		f:Execute(([[-- KR-InternalStateConditionalRemap
			local name, forName, conditional, isExt = %q, %q, %s, %s
			cndName[name] = forName
			if isExt then
				KR:SetAttribute("frameref-RegisterStateDriver-frame", self)
				KR:RunAttribute("RegisterStateDriver", name, conditional)
			else
				RegisterStateDriver(self, name, conditional)
			end
		]]):format(name, forName, safequote(conditional), usesExtendedConditionals and 1 or "nil"))
	end
end

do -- zone:Zone/Sub Zone
	local function onZoneUpdate()
		local cz
		for i=1,4 do
			local z = (i == 1 and GetRealZoneText or i == 2 and GetSubZoneText or i == 3 and GetZoneText or GetMinimapZoneText)()
			if z and z ~= "" then
				cz = (cz and (cz .. "/") or "") .. z
			end
		end
		KR:SetStateConditionalValue("zone", cz or false)
	end
	onZoneUpdate()
	EV.ZONE_CHANGED = onZoneUpdate
	EV.ZONE_CHANGED_INDOORS = onZoneUpdate
	EV.ZONE_CHANGED_NEW_AREA = onZoneUpdate
	EV.PLAYER_ENTERING_WORLD = onZoneUpdate
end
do -- me:Player Name/Class
	KR:SetStateConditionalValue("me", UnitName("player") .. "/" .. playerClassLocal .. "/" .. playerClass)
end
do -- known:spell id
	KR:SetSecureExecConditional("known", [=[-- KR_KnownSpell
		local ids = ...
		for sid in (type(ids) == "string" and ids or ""):gmatch("[^/]+") do
			local id = tonumber(sid:match("^%s*(%d+)%s*$"))
			if id and (FindSpellBookSlotBySpellID(id, true) or FindSpellBookSlotBySpellID(id, false)) then
				return true
			end
		end
		return false
	]=])
	local resolved = true
	local function doPoke()
		resolved = true
		KR:PokeConditional("known")
	end
	local function queuePoke()
		if resolved then
			resolved = false
			C_Timer.After(0, doPoke)
		end
	end
	EV.LEARNED_SPELL_IN_TAB = queuePoke
	EV.PLAYER_SPECIALIZATION_CHANGED = queuePoke
	EV.PLAYER_ENTERING_WORLD = queuePoke
end
if MODERN then -- spec:id/name
	local s, _, _, cid = nil, UnitClass("player")
	for i=1,5 do
		local id, name = GetSpecializationInfoForClassID(cid, i)
		if id and name then
			s = ("%s[spec:%d] %d/%d/%s"):format(s and s .. "; " or "", i, i, id, name:lower())
		end
	end
	if s then
		RegisterStateConditional("spec", "spec", s, false)
	end
else
	KR:SetStateConditionalValue("spec", "")
end
do -- form:token
	if playerClass == "DRUID" then
		KR:SetAliasConditional("stance", "form")
		local map, curCnd, pending = {
			[GetSpellInfo(40120) or 1]="/flight",
			[GetSpellInfo(33943) or 1]="/flight",
			[GetSpellInfo(1066) or 1]="/aquatic",
			[GetSpellInfo(783) or 1]="/travel",
			[GetSpellInfo(24858) or 1]="/moon/moonkin",
			[GetSpellInfo(768) or 1]="/cat",
			[GetSpellInfo(171745) or 1]="/cat",
			[GetSpellInfo(5487) or 1]="/bear",
			[GetSpellInfo(114282) or 1]="/treant",
			[GetSpellInfo(210053) or 1]="/stag",
		}, nil
		local function syncForm()
			local s = ""
			for i=1,10 do
				local _, _, _, fsid = GetShapeshiftFormInfo(i)
				local name = GetSpellInfo(fsid)
				s = ("%s[form:%d] %d%s;"):format(s, i,i, map[name] or "")
			end
			if curCnd ~= s then
				RegisterStateConditional("form", "form", s, false)
			end
			pending = nil
			return "remove"
		end
		EV.PLAYER_LOGIN = syncForm
		function EV.UPDATE_SHAPESHIFT_FORMS()
			if InCombatLockdown() then
				pending = pending or EV.RegisterEvent("PLAYER_REGEN_ENABLED", syncForm) or 1
			else
				syncForm()
			end
		end
	end
end
do -- instance:arena/bg/ratedbg/lfr/raid/scenario + outland/northrend/...
	local mapTypes = {
		party="dungeon", pvp="battleground/bg", ratedbg="ratedbg/rgb", none="world",
		[1116]="world/draenor", [1464]="world/draenor", [1191]="world/draenor/ashran/worldpvp",
		[870]="world/pandaria", [1064]="world/pandaria",
		[530]="world/outland", [571]="world/northrend",
		[1220]="world/broken isles", [1669]="world/argus",
		[1642]="world/bfa/zandalar", [1643]="world/bfa/kul tiras",
		
		garrison="world/draenor/garrison",
		[1158]="garrison",
		[1331]="garrison",
		[1159]="garrison",
		[1152]="garrison",
		[1330]="garrison",
		[1153]="garrison",
		
		[1893]="island", -- The Dread Chain
		[1814]="island", -- Havenswood (?)
		[1879]="island", -- Jorundall (?)
		[1897]="island", -- Molten Cay
		[1892]="island", -- The Rotting Mire
		[1898]="island", -- Skittering Hollow
		[1813]="island", -- Un'gol Ruins
		[1955]="island", -- Uncharted Island (tutorial)
		[1882]="island", -- Verdant Wilds
		[1883]="island", -- Whispering Reef
	}
	function EV.PLAYER_ENTERING_WORLD()
		local _, itype, did, _, _, _, _, imid = GetInstanceInfo()
		if imid and mapTypes[imid] then
			itype = mapTypes[imid]
		elseif itype == "pvp" and MODERN and C_PvP.IsRatedBattleground() then
			itype = "ratedbg"
		elseif itype == "none" and MODERN and IsInActiveWorldPVP() then
			itype = "worldpvp"
		elseif itype == "raid" then
			if did == 7 then
				itype = "lfr"
			end
		end
		KR:SetStateConditionalValue("in", mapTypes[itype] or itype)
	end
	KR:SetAliasConditional("instance", "in")
	KR:SetStateConditionalValue("in", "daze")
end
do -- petcontrol
	local hasControl = (playerClass ~= "HUNTER" and playerClass ~= "WARLOCK") or UnitLevel("player") >= 10
	KR:SetStateConditionalValue("petcontrol", hasControl)
	if not hasControl then
		function EV.PLAYER_LEVEL_UP(_, level)
			if level >= 10 then
				KR:SetStateConditionalValue("petcontrol", "*")
				return "remove"
			end
		end
	end
end
if MODERN then -- outpost
	local map, state, name = {
		[161676]="garrison", [161332]="garrison",
		[164012]="arena", [164050]="lumber yard/yard",
		[161767]="sanctum", [162075]="arsenal",
		[168499]="brewery", [168487]="brewery", [170108]="smuggling run/run", [170097]="smuggling run/run",
		[164222]="corral", [165803]="corral", [160240]="tankworks", [160241]="tankworks",
	}, false, GetSpellInfo(161691)
	local function syncOutpost()
		local ns = map[select(7, GetSpellInfo(name))]
		if state ~= ns then
			KR:SetStateConditionalValue("outpost", ns or "")
			state = ns
		end
	end
	EV.SPELLS_CHANGED = syncOutpost
	syncOutpost()
end
do -- glyph:(defunct)
	KR:SetStateConditionalValue("glyph", "")
end
do -- level:floor
	local function syncLevel()
		KR:SetThresholdConditionalValue("level", UnitLevel("player") or 0)
	end
	syncLevel()
	EV.PLAYER_LEVEL_UP = syncLevel
end
do -- horde/alliance
	local function syncFactionGroup(e, u)
		if e ~= "UNIT_FACTION" or u == "player" then
			local fg = UnitFactionGroup("player", true)
			KR:SetStateConditionalValue("horde", fg == "Horde" and "*" or "")
			KR:SetStateConditionalValue("alliance", fg == "Alliance" and "*" or "")
		end
	end
	syncFactionGroup()
	EV.PLAYER_ENTERING_WORLD, EV.UNIT_FACTION = syncFactionGroup, syncFactionGroup
end
do -- moving
	KR:SetNonSecureConditional("moving", function()
		return GetUnitSpeed("player") > 0
	end)
end
local stringArgCache = {} do
	local empty = {}
	setmetatable(stringArgCache, {__index=function(t,k)
		if k then
			local at
			for s in k:gmatch("[^/]+") do
				s = s:match("^%s*(.-)%s*$")
				if #s > 0 then
					at = at or {}
					at[#at + 1] = s
				end
			end
			at = at or empty
			t[k] = at
			return at
		end
		return empty
	end})
end
do -- ready:spell name/spell id/item name/item id
	KR:SetNonSecureConditional("ready", function(_name, args)
		if not args or args == "" then
			local gcS, gcL = GetSpellCooldown(61304)
			return gcS == 0 and gcL == 0
		end
		
		local at = stringArgCache[args]

		local gcS, gcL = GetSpellCooldown(61304)
		local gcE = gcS and gcL and (gcS + gcL) or math.huge
		for i=1,#at do
			local rc = at[i]
			local cdS, cdL, _cdA = GetSpellCooldown(rc)
			if cdL == nil then
				local _, iid = GetItemInfo(rc)
				iid = tonumber((iid or rc):match("item:(%d+)"))
				if iid then
					cdS, cdL, _cdA = GetItemCooldown(iid)
				end
			end
			if cdL == 0 or (cdS and cdL and (cdS + cdL) <= gcE) then
				return true
			end
		end
		
		return false
	end)
end
do -- have:item name/id
	KR:SetNonSecureConditional("have", function(_name, args)
		if not args or args == "" then
			return false
		end
		
		local at = stringArgCache[args]
		for i=1,#at do
			if (GetItemCount(at[i]) or 0) > 0 then
				return true
			end
		end
		
		return false
	end)
end
do -- selfbuff:name
	local function checkSelf(name, args)
		if not args or args == "" then
			return false
		end
		
		local at, query = stringArgCache[args], name == "selfbuff" and UnitBuff or UnitDebuff
		for i=1,#at do
			local ati = at[i]
			local j, r = 2, query("player", 1)
			while r do
				if strcmputf8i(r, ati) == 0 then
					return true
				end
				j, r = j + 1, query("player", j)
			end
		end
		
		return false
	end
	KR:SetNonSecureConditional("selfbuff", checkSelf)
	KR:SetNonSecureConditional("selfdebuff", checkSelf)
end
do -- debuff:name
	local function checkAura(name, args, target)
		if not args or args == "" then
			return false
		end
		target = target or "target"
		local at = stringArgCache[args], name == "owndebuff" and "PLAYER" or ""
		local filter = (name == "owndebuff" or name == "ownbuff") and "PLAYER" or ""
		local query = (name == "debuff" or name == "owndebuff") and UnitDebuff or UnitBuff
		for i=1,#at do
			local ati = at[i]
			local j, r = 2, query(target, 1, filter)
			while r do
				if strcmputf8i(r, ati) == 0 then
					return true
				end
				j, r = j + 1, query(target, j, filter)
			end
		end
		return false
	end
	KR:SetNonSecureConditional("debuff", checkAura)
	KR:SetNonSecureConditional("owndebuff", checkAura)
	KR:SetNonSecureConditional("buff", checkAura)
	KR:SetNonSecureConditional("ownbuff", checkAura)
	KR:SetNonSecureConditional("cleanse", function(_, _, target)
		target = target or "target"
		return UnitIsFriend("player", target) and (UnitDebuff(target, 1, "RAID") ~= nil)
	end)
end
do -- combo:count
	local power, powerMap = 4, {[265]=7, [267]=14, [258]=13, PALADIN=9, MONK=12}
	local defaultPower = powerMap[playerClass] or 4
	KR:SetNonSecureConditional("combo", function(_name, args)
		return UnitPower("player", power) >= (tonumber(args) or 1)
	end)
	local function syncComboPower()
		power = powerMap[MODERN and GetSpecializationInfo(GetSpecialization() or 0)] or defaultPower
	end
	EV.PLAYER_SPECIALIZATION_CHANGED, EV.PLAYER_LOGIN = syncComboPower, syncComboPower
end
do -- race:token
	local map, _, raceToken = {
		Scourge="Scourage/Undead/Forsaken",
		LightforgedDraenei="LightforgedDraenei/Lightforged",
		HighmountainTauren="HighmountainTauren/Highmountain",
		MagharOrc="MagharOrc/Maghar",
		ZandalariTroll="ZandalariTroll/Zandalari",
	}, UnitRace("player")
	KR:SetStateConditionalValue("race", map[raceToken] or raceToken)
end
do -- professions
	local ct, ot, syncProfInner = {}, {}
	local map = MODERN and {
		[197]="tail", [165]="lw", [164]="bs",
		[171]="alch", [202]="engi", [333]="ench", [755]="jc", [773]="scri",
		[182]="herb", [794]="arch", [185]="cook", [356]="fish",
		[20219]="nomeng", [20222]="gobeng",
	}
	map = map or {
		[GetSpellInfo(3908) or ""]="tail",
		[GetSpellInfo(2108) or ""]="lw",
		[GetSpellInfo(2018) or ""]="bs",
		[GetSpellInfo(2259) or ""]="alch",
		[GetSpellInfo(2366) or ""]="herb",
		[GetSpellInfo(2575) or ""]="miner",
		[GetSpellInfo(4036) or ""]="engi",
		[GetSpellInfo(7411) or ""]="ench",
		[GetSpellInfo(8613) or ""]="skin",
		[GetSpellInfo(2550) or ""]="cook",
		[GetSpellInfo(3273) or ""]="faid",
		[GetSpellInfo(7620) or ""]="fish",
		[GetSpellInfo(20221) or ""]="gobeng",
		[GetSpellInfo(20222) or ""]="gobeng",
		[GetSpellInfo(20220) or ""]="nomeng",
		[GetSpellInfo(20219) or ""]="nomeng",
	}
	local spellIDProfs = {
		[264636]="cook3",
		[264620]="tail3", [264626]="tail6",
		[271662]="fish5",
		[264588]="lw6", [264590]="lw7",
		[264479]="eng2", [264481]="eng3", [264483]="eng4", [264485]="eng5", [264488]="eng6", [264490]="eng7",
	}
	map[""]=nil
	syncProfInner = MODERN and function(id, ...)
		if id then
			local _1, _2, cur, _cap, ns, sofs, skid, _bonus, specIdx, _ = GetProfessionInfo(id)
			local et, sid = GetSpellBookItemInfo(ns == 2 and sofs and specIdx > -1 and sofs+2 or 0, "spell")
			local e1, e2 = map[skid], map[et == "SPELL" and sid or nil]
			if e1 then ct[e1] = cur end
			if e2 then ct[e2] = cur end
		end
		if select("#", ...) > 0 then
			return syncProfInner(...)
		end
	end or function()
		local idx, wasCollapsed
		for i=1,GetNumSkillLines() do
			local text, isHeader, isExpanded = GetSkillLineInfo(i)
			if isHeader and text == TRADE_SKILLS then
				idx, wasCollapsed = i, not isExpanded
				ExpandSkillHeader(i)
				break
			end
		end
		if not idx then return end
		local j, text, isHeader, _, curSkill = idx+1
		repeat
			j, text, isHeader, _, curSkill = j+1, GetSkillLineInfo(j)
			local skey = map[text]
			if skey and not isHeader then
				ct[skey] = curSkill
			end
		until isHeader or not text
		if wasCollapsed then
			CollapseSkillHeader(idx)
		end
	end
	local function syncProf()
		ct, ot = ot, ct
		for k in pairs(ct) do ct[k] = nil end
		if MODERN then
			syncProfInner(GetProfessions())
		else
			syncProfInner()
		end
		for sid, cnd in pairs(spellIDProfs) do
			ct[cnd] = GetSpellInfo(GetSpellInfo(sid) or "\1") and 1 or nil
		end
		for k,v in pairs(ct) do
			if ot[k] ~= v then
				KR:SetThresholdConditionalValue(k, v)
				ot[k] = v
			end
		end
		for k,v in pairs(ot) do
			if ct[k] ~= v then
				KR:SetThresholdConditionalValue(k, false)
				ot[k] = nil
			end
		end
	end
	for _, v in pairs(map) do
		KR:SetThresholdConditionalValue(v, false)
	end
	for _, v in pairs(spellIDProfs) do
		KR:SetThresholdConditionalValue(v, false)
	end
	for alias, real in ("tailoring:tail leatherworking:lw alchemy:alch engineering:engi enchanting:ench jewelcrafting:jc blacksmithing:bs inscription:scri herbalism:herb archaeology:arch cooking:cook fishing:fish firstaid:faid"):gmatch("(%a+):(%a+)") do
		KR:SetAliasConditional(alias, real)
	end
	EV.PLAYER_LOGIN, EV.CHAT_MSG_SKILL = syncProf, syncProf
end
if playerClass == "HUNTER" then -- pet:stable id; havepet:stable id
	local pt, noPendingSync = {}, true
	local function syncPet(e)
		if InCombatLockdown() then
			if noPendingSync then
				EV.PLAYER_REGEN_ENABLED, noPendingSync = syncPet, false
			end
			return
		end
		for k in pairs(pt) do pt[k] = nil end
		local o, hpo
		for i=1,5 do
			local _, n, _, r = GetStablePetInfo(i)
			if n and r then
				local k = n == r and n or (n .. "/" .. r)
				pt[k] = (pt[k] or ("[pet:" .. n .. (n ~= r and ",pet:" .. r .. "] " or "] ") .. k)) .. "/" .. i
				hpo = (hpo and hpo .. "/" .. i or i)
			end
		end
		for k, v in pairs(pt) do
			o = k:match("/") and (v .. (o and "; " .. o or "")) or ((o and o .. "; " or "") .. v)
		end
		RegisterStateConditional("pet", "pet", "[nopet]; " .. (o and o .. "; 0" or " 0"), false)
		KR:SetStateConditionalValue("havepet", hpo and tostring(hpo) or "")
		noPendingSync = true
		if hpo == nil and (e == "PLAYER_LOGIN" or e == nil) then
			-- TODO (8.1.5) the missing PET_STABLE_UPDATE might reappear in the future.
			C_Timer.After(0, syncPet)
		end
		return e == "PLAYER_REGEN_ENABLED" and "remove" or nil
	end
	KR:SetStateConditionalValue("havepet", false)
	EV.PLAYER_LOGIN, EV.PET_STABLE_UPDATE, EV.LOCALPLAYER_PET_RENAMED = syncPet, syncPet, syncPet
else
	KR:SetStateConditionalValue("havepet", false)
end

KR:SetStateConditionalValue("modern", MODERN)

do -- Managed role units
	local mh = CreateFrame("Frame", nil, nil, "SecureFrameTemplate")
	SecureHandlerSetFrameRef(mh, "KR", KR:seclib())
	SecureHandlerExecute(mh, [=[-- MRU_Init_Manager
		KR, uf, ul, spare = self:GetFrameRef("KR"), newtable(), newtable(), newtable()
		self:SetAttribute("frameref-KR", nil)
	]=])
	local syncUnits = [==[-- MRU_Sync
		local nl, key, nj, fa = spare, %q, 1
		ul[key], spare, fa = nl, ul[key], uf[key]
		for i=1,40 do
			local u = fa[i]:GetAttribute("unit")
			if u then
				nl[i] = u
			else
				for j=i,#nl do
					nl[j] = nil
				end
				break
			end
		end
		for i=1,#nl do
			local u = nl[i]
			if u ~= playerUnit then
				KR:RunAttribute("SetAliasUnit", key .. nj, u)
				nj = nj + 1
			end
		end
		for i=nj,#spare do
			KR:RunAttribute("SetAliasUnit", key .. i, "raid42")
		end
		self:Show()
	]==]
	local function SpawnHeader(key, ...)
		local h = CreateFrame("Frame", nil, nil, "SecureGroupHeaderTemplate")
		for i=1,40 do
			local c = CreateFrame("Frame", nil, h, "SecureFrameTemplate")
			h:SetAttribute("child" .. i, c)
			SecureHandlerSetFrameRef(mh, "u" .. i, c)
			KR:SetAliasUnit(key .. i, "raid42")
		end
		SecureHandlerExecute(mh, ([[-- MRU_SpawnHeader_Init
			local a, k = newtable(), %q
			for i=1,40 do
				a[i] = self:GetFrameRef("u" .. i)
				self:SetAttribute("frameref-u" .. i, nil)
			end
			uf[k], ul[k] = a, newtable()
		]]):format(key))
		local cu = CreateFrame("Frame", nil, h, "SecureFrameTemplate")
		SecureHandlerWrapScript(cu, "OnHide", mh, syncUnits:format(key))
		h:SetAttribute("child41", cu)
		h:SetAttribute("template", "ImpossibleFrameTemplate")
		h:SetAttribute("templateType", "Frame")
		h:SetAttribute("showRaid", true)
		h:SetAttribute("showParty", true)
		h:SetAttribute("showPlayer", false)
		h:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8")
		h:SetAttribute("sortMethod", "NAME")
		for i=1, select("#", ...), 2 do
			local k, v = select(i, ...)
			h:SetAttribute(k, v)
		end
		return h
	end
	local ph = CreateFrame("Frame", nil, nil, "SecureGroupHeaderTemplate") do
		local c = CreateFrame("Frame", nil, ph, "SecureFrameTemplate")
		ph:SetAttribute("child1", c)
		SecureHandlerWrapScript(c, "OnAttributeChanged", mh, [=[-- MRU_Player_Change
			if name ~= "unit" or value == playerUnit then return end
			playerUnit = value
			for key, v in pairs(ul) do
				local nj = 1
				for i=1,#v do
					local u = v[i]
					if u ~= playerUnit then
						KR:RunAttribute("SetAliasUnit", key .. nj, u)
						nj = nj + 1
					end
				end
				KR:RunAttribute("SetAliasUnit", key .. nj, "raid42")
			end
		]=])
		ph:SetAttribute("showRaid", true)
		ph:SetAttribute("showParty", false)
		ph:SetAttribute("showPlayer", false)
		ph:SetAttribute("nameList", (UnitName("player")))
		ph:Show()
	end
	SpawnHeader("tank", "roleFilter","TANK"):Show()
	SpawnHeader("mtank", "roleFilter","MAINTANK"):Show()
	SpawnHeader("assist", "roleFilter","MAINASSIST"):Show()
	SpawnHeader("healer", "roleFilter","HEALER"):Show()
end