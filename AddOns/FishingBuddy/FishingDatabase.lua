-- FishingBuddy
--
-- Handle collecting data about fishies.

-- 5.0.4 has a problem with a global "_" (see some for loops below)
local _

local FL = LibStub("LibFishing-1.0");
local LO = LibStub("LibOptionsFrame-1.0");

local zmto = FishingBuddy.ZoneMarkerTo;
local zmex = FishingBuddy.ZoneMarkerEx;

-- Nat Pagle fish
local PagleFish = {};
PagleFish[86545] = {
	["enUS"] = "Mimic Octopus",
	quest = 31446,
};
PagleFish[86544] = {
	["enUS"] = "Spinefish Alpha",
	quest = 31444,
};
PagleFish[86542] = {
	["enUS"] = "Flying Tiger Gourami",
	quest = 31443,
};

-- Lunkers
PagleFish[116817] = {
	["enUS"] = "Blackwater Whiptail Lunker",
	lunker = true,
};
PagleFish[116818] = {
	["enUS"] = "Abyssal Gulper Lunker",
	lunker = true,
};
PagleFish[116819] = {
	["enUS"] = "Fire Ammonite Lunker",
	lunker = true,
};
PagleFish[116820] = {
	["enUS"] = "Blind Lake Lunker",
	lunker = true,
};
PagleFish[116821] = {
	["enUS"] = "Fat Sleeper Lunker",
	lunker = true,
};
PagleFish[116822] = {
	["enUS"] = "Jawless Skulker Lunker",
	lunker = true,
};
PagleFish[127994] = {
	["enUS"] = "Felmouth Frenzy Lunker",
	lunker = true,
};

PagleFish[116158] = {
	["enUS"] = "Lunarfall Carp",
	limit = 5
};
PagleFish[112633] = {
	["enUS"] = "Frostdeep Minnow",
};
PagleFish[122696] = {
	["enUS"] = "Sea Scorpion Minnow",
};
PagleFish[110508] = {
	["enUS"] = "Sea Scorpion Minnow",
};

FishingBuddy.PagleFish = PagleFish;

-- we should collect these, but then they would be in the cache
local QuestItems = {};
	QuestItems[6717] = {
		["enUS"] = "Gaffer Jack",
		["deDE"] = "Klemm-Muffen",
		["esES"] = "Mecanismo el�ctrico",
		["frFR"] = "Rouage �lectrique",
	};
	QuestItems[6718] = {
		["enUS"] = "Electropeller",
		["deDE"] = "Elektropeller",
		["esES"] = "Electromuelle",
		["frFR"] = "Electropeller",
	};
	QuestItems[16970] = {
		["enUS"] = "Misty Reed Mahi Mahi",
		["deDE"] = "Nebelschilf-Mahi-Mahi",
		["frFR"] = "Mahi Mahi de Brumejonc",
	};
	QuestItems[16968] = {
		["enUS"] = "Sar'theris Striker",
		["deDE"] = "Sar'theris-Barsch",
		["frFR"] = "Frappeur Sar'theris",
	};
	QuestItems[16969] = {
		["enUS"] = "Savage Coast Blue Sailfin",
		["deDE"] = "Blauwimpel von der ungez�hmten K�ste",
		["frFR"] = "Sailfin bleu de la C�te sauvage",
	};
	QuestItems[16967] = {
		["enUS"] = "Feralas Ahi",
		["frFR"] = "Ahi de Feralas",
	};
	QuestItems[34865] = {
		["enUS"] = "Blackfin Darter",
	};
	QuestItems[45328] = {
		["enUS"] = "Bloated Slippery Eel",
		open = true,
	};
	QuestItems[35313] = {
		["enUS"] = "Bloated Barbed Gill Trout",
		open = true,
	};
	QuestItems[58856] = {
		["enUS"] = "Royal Monkfish",
		open = true,
	};
	QuestItems[69914] = {
		["enUS"] = "Giant Catfish",
		open = true,
	};
	QuestItems[69956] = {
		["enUS"] = "Blind Cavefish",
		open = true,
	};
	FishingBuddy.QuestItems = QuestItems;

-- handle the vagaries of zones and subzones
local subzonemapping;

local function ResetMappings()
	subzonemapping = nil;
end
FishingBuddy.ResetMappings = ResetMappings;

local function initmappings()
	if ( not subzonemapping ) then
		subzonemapping = {};
		for mapId,_ in pairs(FishingBuddy_Info["KnownZones"]) do
			local zidm = zmto(mapId,0);
			local count = FishingBuddy_Info["SubZones"][zidm];
			if ( count and count > 0 ) then
				subzonemapping[mapId] = {};
				for s=1,count,1 do
					zidm = zmto(mapId, s);
					local sz = FishingBuddy_Info["SubZones"][zidm];
					subzonemapping[mapId][sz] = s;
				end
			end
		end
	end
end

local function GetCurrentMapIdInfo()
	local mapId, subzone = FL:GetZoneInfo()
	return mapId, subzone
end
FishingBuddy.GetCurrentMapIdInfo = GetCurrentMapIdInfo

local function GetZoneIndex(mapId, subzone, marker)
	initmappings();
	if ( not subzonemapping[mapId] ) then
		subzonemapping[mapId] = {};
	end

	subzone = FL:GetBaseSubZone(subzone);
	if ( subzone == "The Great Sea" ) then
		-- Not sure what to do here, but we might be able to do something...
	end

	if ( not subzone or not subzonemapping[mapId][subzone] ) then
		if ( marker ) then
			return zmto(mapId, 0);
		else
			return mapId;
		end
	end

	if ( marker ) then
		return zmto(mapId, subzonemapping[mapId][subzone]);
	else
		return mapId, subzonemapping[mapId][subzone];
	end
end
FishingBuddy.GetZoneIndex = GetZoneIndex;

local function GetCurrentZoneIndex(marker)
	initmappings();
	local mapId, subzone = GetCurrentMapIdInfo();
	return GetZoneIndex(mapId, subzone, marker)
end
FishingBuddy.GetCurrentZoneIndex = GetCurrentZoneIndex;

local function AddZoneIndex(mapId, subzone, marker)
	if ( not mapId ) then
		mapId, subzone = GetCurrentMapIdInfo();
	end
	subzone = FL:GetBaseSubZone(subzone);
	FishingBuddy_Info["KnownZones"][mapId] = subzone

	local loczone = FL:GetLocZone(mapId);
	local zidx, sidx = GetZoneIndex(mapId, subzone);

	if ( FishingBuddy.SortedZones ) then
		if not FishingBuddy.MappedZones[loczone] then
			tinsert(FishingBuddy.SortedZones, loczone);
			table.sort(FishingBuddy.SortedZones);
		end
		FishingBuddy.MappedZones[loczone] = mapId
	end

	local zidm = zmto(zidx, 0);
	if ( not subzone ) then
		if ( marker ) then
			return zidm;
		else
			return zidx;
		end
	end

	initmappings();
	local locsubzone = FL:GetLocSubZone(subzone);
	if ( not subzonemapping[zidx] ) then
		subzonemapping[zidx] = {};
	end
	local newsubzone = false;
	if ( not subzonemapping[zidx][subzone] ) then
		newsubzone = true;
		sidx = FishingBuddy_Info["SubZones"][zidm];
		if ( not sidx ) then
			sidx = 1;
		else
			sidx = sidx + 1;
		end
		FishingBuddy_Info["SubZones"][zidm] = sidx;
		local sidm = zmto(zidx, sidx);
		FishingBuddy_Info["SubZones"][sidm] = subzone;
		subzonemapping[zidx][subzone] = sidx;
	end
	-- keep sort helpers up to date
	if ( newsubzone and FishingBuddy.SortedByZone ) then
		if ( not FishingBuddy.SortedByZone[loczone] ) then
			FishingBuddy.SortedByZone[loczone] = {};
		end
		tinsert(FishingBuddy.SortedByZone[loczone], locsubzone);
		table.sort(FishingBuddy.SortedByZone[loczone]);

		if ( not FishingBuddy.UniqueSubZones[locsubzone] ) then
			FishingBuddy.UniqueSubZones[locsubzone] = 1;
			tinsert(FishingBuddy.SortedSubZones, locsubzone);
			table.sort(FishingBuddy.SortedSubZones);
		end

		if ( not FishingBuddy.SubZoneMap[subzone] ) then
			FishingBuddy.SubZoneMap[subzone] = {};
		end
		local sidm = zmto(zidx, sidx);
		FishingBuddy.SubZoneMap[subzone][sidm] = 1;
	end
	if ( marker ) then
		return zmto(zidx, subzonemapping[zidx][subzone]);
	else
		return zidx, subzonemapping[zidx][subzone];
	end
end
FishingBuddy.AddZoneIndex = AddZoneIndex;

-- User interface handling
local function IsRareFish(id, forced)
	-- always skip extravaganza fish
	if ( FishingBuddy.Extravaganza and FishingBuddy.Extravaganza.Fish[id] ) then
		return true;
	end
	return ( not forced and QuestItems[id] );
end

local function IsQuestFish(id)
	if ( FishingBuddy_Info["Fishies"][id].quest or QuestItems[id] ) then
		return true;
	end
	-- return nil;
end
FishingBuddy.IsQuestFish = IsQuestFish;

FishingBuddy.IsCountedFish = function(id)
	id = tonumber(id);
	if ( IsQuestFish(id) or IsRareFish(id) or FL:IsMissedFish(id) ) then
		return false;
	end
	if ( id == 40199 ) then
		return false; -- Pygmy Suckerfish
	end
	return true;
end

local questType = _G.GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM);
local CurLoc = GetLocale();
local function AddFishie(color, id, name, mapId, subzone, texture, quantity, quality, level, it, st, poolhint)
	local GSB = FishingBuddy.GetSettingBool;
	if ( id and not FishingBuddy_Info["Fishies"][id] ) then
		if ( not color ) then
			local _,_,_,hex = GetItemQualityColor(quality);
			_,_,color = string.find(hex, "|c(%a+)");
		end
		FishingBuddy_Info["Fishies"][id] = { };
		FishingBuddy_Info["Fishies"][id][CurLoc] = name;
		FishingBuddy_Info["Fishies"][id].texture = texture;
		FishingBuddy_Info["Fishies"][id].quality = quality;
		if ( color ~= "ffffffff" ) then
			FishingBuddy_Info["Fishies"][id].color = color;
		end
		if ( FishingBuddy.SortedFishies ) then
			tinsert(FishingBuddy.SortedFishies, { text = name, id = id });
			FishingBuddy.FishSort(FishingBuddy.SortedFishies, true);
		end
	end
	if ( name and not FishingBuddy_Info["Fishies"][id][CurLoc] ) then
		FishingBuddy_Info["Fishies"][id][CurLoc] = name;
	end
	-- Only quest items have matching itemType and subType values, as well
	if ( (it and it == questType) or QuestItems[id] ) then
		-- subtype is Quest as well
		if ( FishingBuddy_Info["Fishies"][id].canopen == nil ) then
			FishingBuddy_Info["Fishies"][id].quest = true;
			local canopen, locked;
			if ( QuestItems[id] and QuestItems[id].open ) then
				canopen = QuestItems[id].open;
			else
				canopen, locked = FL:IsOpenable(id);
			end
			-- if it's locked, let's not deal with it (not that I can think of any
			-- quest items that are locked and openable...)
			if ( not locked ) then
				FishingBuddy_Info["Fishies"][id].canopen = canopen;
			end
		end
		if ( FishingBuddy_Info["Fishies"][id].canopen ) then
			table.insert(FishingBuddy.OpenThisFishId, id);
		end
	end

	-- Play a sound on Nat Pagle rep
	if ( PagleFish[id] and GSB("DingQuestFish") ) then
		PlaySound(SOUNDKIT.IG_QUEST_LIST_COMPLETE, "master");
	end

	if ( not subzone ) then
		_, subzone = GetCurrentMapIdInfo();
	end

	local zidx, sidx = AddZoneIndex(mapId, subzone);
	local idx = zmto(zidx, sidx);

	local ft = FishingBuddy_Info["FishTotals"];
	local totidx = zmto(zidx, 0);
	if( not ft[totidx] ) then
		ft[totidx] = quantity;
	else
		ft[totidx] = ft[totidx] + quantity;
	end
	if( not ft[idx] ) then
		ft[idx] = quantity;
	else
		ft[idx] = ft[idx] + quantity;
	end

	local fh = FishingBuddy_Info["FishingHoles"];
	if ( not fh[idx] ) then
		fh[idx] = {};
	end
	if ( not fh[idx][id] ) then
		fh[idx][id] = quantity;
		if ( GSB("ShowNewFishies") ) then
			FishingBuddy.Print(FBConstants.ADDFISHINFOMSG, name or UNKNOWN, subzone or FL:GetLocZone(mapId));
		end
	else
		fh[idx][id] = fh[idx][id] + quantity;
	end

	if ( FishingBuddy.ByFishie ) then
		if ( not FishingBuddy.ByFishie[id] ) then
			FishingBuddy.ByFishie[id] = {};
		end
		if ( not FishingBuddy.ByFishie[id][idx] ) then
			FishingBuddy.ByFishie[id][idx] = quantity;
		else
			FishingBuddy.ByFishie[id][idx] = FishingBuddy.ByFishie[id][idx] + quantity;
		end
	end

	if ( level ) then
		if ( not FishingBuddy_Info["Fishies"][id].level or
				  level < FishingBuddy_Info["Fishies"][id].level ) then
			FishingBuddy_Info["Fishies"][id].level = level;
		else
			level = FishingBuddy_Info["Fishies"][id].level;
		end
	end

	local fs = FishingBuddy_Info["FishingSkill"];
	if ( not fs[idx] ) then
		fs[idx] = 0;
	end
	local skill, mods, _ = FL:GetCurrentSkill();
	local skillcheck = 0;
	if ( not skillcheck ) then
		skillcheck = skill + mods;
	end
	if ( skillcheck > 0 ) then
		if ( not fs[idx] or skillcheck < fs[idx] ) then
			fs[idx] = skillcheck;
		end
		if ( id ) then
			if ( not FishingBuddy_Info["Fishies"][id].level or
				  skillcheck < FishingBuddy_Info["Fishies"][id].level ) then
				FishingBuddy_Info["Fishies"][id].level = skillcheck;
				FishingBuddy_Info["Fishies"][id].skill = skill;
				FishingBuddy_Info["Fishies"][id].mods = mods;
			end
		end
	end

	FishingBuddy.RunHandlers(FBConstants.ADD_FISHIE_EVT, id, name, mapId, subzone, texture, quantity, quality, level, idx, poolhint);
end
FishingBuddy.AddFishie = AddFishie;

-- we want to dismiss the loot window as fast as possible
local lootframe = CreateFrame("Frame");
lootframe:Hide();

local lootcache = {}
local lootcheck = false;
local lootcount = 0;
local function ProcessFishLoot()
	local mapId, subzone = GetCurrentMapIdInfo();
	while (table.getn(lootcache) > 0) do
		local info = table.remove(lootcache)
		local texture, fishie, quantity, quality, link = info.texture, info.fishie, info.quantity, info.quality, info.link;
		local nm,link,_,_,it,st,_,el,_,il = FL:GetItemInfo(link);
		local color, id, name = FL:SplitLink(link, true);

		-- handle things we can't actually count that might be in our fish (e.g. Garrison Resources)
		if (id) then
			-- Fishing pool check? poolhint and (index == 1)
			AddFishie(color, id, name, mapId, subzone, texture, quantity, quality, nil, it, st, false);
		end
		lootcount = lootcount + 1;
		lootcheck = true;
	end
	lootframe:Hide();
	lootcache = {};
end
lootframe:SetScript("OnUpdate", ProcessFishLoot);

local function GetLootState()
	return lootcount, lootcheck;
end
FishingBuddy.GetLootState = GetLootState;

local function AddLootCache(texture, fishie, quantity, quality, link, poolhint)
	tinsert(lootcache, {texture = texture, fishie = fishie, quantity = quantity, quality = quality, link = link, poolhint = poolhint});
	lootframe:Show()
end
FishingBuddy.AddLootCache = AddLootCache

FishingBuddy.Commands[FBConstants.UPDATEDB] = {};
FishingBuddy.Commands[FBConstants.UPDATEDB].help = FBConstants.UPDATEDB_HELP;
FishingBuddy.Commands[FBConstants.UPDATEDB].func =
	function(what)
		local ff = FishingBuddy_Info["Fishies"];
		local forced;
		if ( what and what == FBConstants.FORCE ) then
			forced = true;
		end
		FishingBuddyTooltip:SetOwner(FishingBuddyFrame, "ANCHOR_RIGHT");
		FishingBuddyTooltip:Show();
		local count = 0;
		for id,info in pairs(ff) do
			local item = id..":0:0:0";
			if ( forced or not FL:IsLinkableItem(item) or not info.name ) then
				if ( not IsRareFish(id, forced) ) then
					local link = "item:"..item;
					-- fetch the data (may disconnect)
					FishingBuddyTooltip:SetHyperlink(link);
					-- now that we have it in our cache, get the name
					local nm,li,ra,ml,it,st,sc,el,tx,il = FL:GetItemInfo(link);
					if ( nm ) then
						count = count + 1;
						FishingBuddy_Info["Fishies"][id][CurLoc] = nm;
						FishingBuddy_Info["Fishies"][id].quest = (it == st);
					end
				end
			end
		end
		FishingBuddy.Print(FBConstants.UPDATEDB_MSG, count);
		return true;
	end;

