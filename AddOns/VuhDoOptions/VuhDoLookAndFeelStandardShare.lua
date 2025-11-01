local _;

VUHDO_BUDDY_NAME_MODEL = { };
VUHDO_SELECTED_COMBO_BUDDY = "";
VUHDO_NONE_SELECTED_BUDDY = "Enter Player Name";


--
local function VUHDO_addBuddyNameToComboModel(aName)
	if (VUHDO_strempty(aName) or aName == VUHDO_PLAYER_NAME) then
		return;
	end

	for _, tInfo in pairs(VUHDO_BUDDY_NAME_MODEL) do
		if (tInfo[2] == aName) then
			return;
		end
	end

	tinsert(VUHDO_BUDDY_NAME_MODEL, { aName, aName } );
end



--
local tName;
local tIsOnline;
function VUHDO_initBuddyNameModel()
	table.wipe(VUHDO_BUDDY_NAME_MODEL);

	-- Target
	if (UnitIsFriend("player", "target") and UnitIsPlayer("target")) then
		VUHDO_addBuddyNameToComboModel(UnitName("target"));
	end

	-- Raid/Party
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		if (not tInfo["isPet"] and tInfo["connected"] and UnitIsPlayer(tUnit)) then
			VUHDO_addBuddyNameToComboModel(tInfo["name"]);
		end
	end

	-- Friends
	local tNumFriends = C_FriendList.GetNumFriends();
	local tFriendInfo;
	for tCnt = 1, tNumFriends do
		tFriendInfo = C_FriendList.GetFriendInfoByIndex(tCnt);

		if (tFriendInfo.connected) then
			VUHDO_addBuddyNameToComboModel(tFriendInfo.name);
		end
	end

	-- Guild
	tNumFriends = GetNumGuildMembers();
	for tCnt = 1, tNumFriends do
		tName, _, _, _, _, _, _, _, tIsOnline = GetGuildRosterInfo(tCnt);
		if (tIsOnline) then
			VUHDO_addBuddyNameToComboModel(tName);
		end
	end

	table.sort(VUHDO_BUDDY_NAME_MODEL,
		function(anInfo, anotherInfo)
			return anInfo[1] < anotherInfo[1];
		end
	);

end



--
function VUHDO_hookBuddyUpdater(aScrollPanel)
	aScrollPanel:SetScript("OnShow",
		function(self)
			VUHDO_initBuddyNameModel();
			VUHDO_lnfComboBoxInitFromModel(self:GetParent());
		end
	);
end



--
function VUHDO_optionsExecShare(aPanel)
	local tSelection = _G[aPanel:GetAttribute("model")[2]];
	if (VUHDO_strempty(tSelection)) then
		VUHDO_Msg("You must select an item to share.", 1, 0.4, 0.4);
		return false;
	end

	if (VUHDO_strempty(VUHDO_SELECTED_COMBO_BUDDY)
		or VUHDO_SELECTED_COMBO_BUDDY == VUHDO_NONE_SELECTED_BUDDY) then
		VUHDO_Msg("You must select a player name.", 1, 0.4, 0.4);
		return false;
	end

	if (VUHDO_SELECTED_COMBO_BUDDY == VUHDO_PLAYER_NAME) then
		VUHDO_Msg("You can't share stuff with yourself.", 1, 0.4, 0.4);
		return false;
	end


	_G[aPanel:GetAttribute("model")[1]](VUHDO_SELECTED_COMBO_BUDDY, tSelection);
	return true;
end
