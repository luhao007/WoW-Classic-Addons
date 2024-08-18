---@class Private
local Private = select(2, ...)

---@type LibDropDownExtension
local LibDropDownExtension = LibStub and LibStub:GetLibrary("LibDropDownExtension-1.0", true)

if not LibDropDownExtension then
	return
end

local validTypes = {
	ARENAENEMY = true,
	BN_FRIEND = true,
	CHAT_ROSTER = true,
	COMMUNITIES_GUILD_MEMBER = true,
	COMMUNITIES_WOW_MEMBER = true,
	ENEMY_PLAYER = true,
	FOCUS = true,
	FRIEND = true,
	GUILD = true,
	GUILD_OFFLINE = true,
	PARTY = true,
	PLAYER = true,
	RAID = true,
	RAID_PLAYER = true,
	SELF = true,
	TARGET = true,
	WORLD_STATE_SCORE = true,
}

---@class CurrentDropdownSelection
---@field name string|nil
---@field realm string|number|nil
---@field projectId number
local currentDropDownSelection = {
	name = nil,
	realm = nil,
	projectId = WOW_PROJECT_ID,
}

---@type Frame
local COPY_PROFILE_URL_POPUP = {
	id = "WARCRAFTLOGS_COPY_URL",
	text = "%s",
	button2 = CLOSE,
	hasEditBox = true,
	hasWideEditBox = true,
	editBoxWidth = 350,
	preferredIndex = 3,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	OnShow = function(self)
		local editBox = _G[self:GetName() .. "WideEditBox"] or _G[self:GetName() .. "EditBox"]
		editBox:SetText(self.text.text_arg2)
		editBox:HighlightText()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
}

local function ShowStaticPopupDialog(...)
	local id = COPY_PROFILE_URL_POPUP.id

	if not StaticPopupDialogs[id] then
		StaticPopupDialogs[id] = COPY_PROFILE_URL_POPUP
	end

	return StaticPopup_Show(id, ...)
end

local function ShowCopyProfileUrlPopup()
	if currentDropDownSelection.name == nil then
		return
	end

	ShowStaticPopupDialog(currentDropDownSelection.name, Private.GetProfileUrl(currentDropDownSelection.name, currentDropDownSelection.realm, currentDropDownSelection.projectId))
end

---@type CustomDropDownOption[]
local customDropDownOptions = {
	---@diagnostic disable-next-line: missing-fields
	{
		text = Private.L.CopyProfileURL,
		func = ShowCopyProfileUrlPopup,
	},
}

---@param dropdown CustomDropDown
---@return boolean
local function IsValidDropDown(dropdown)
	return dropdown == LFGListFrameDropDown or dropdown == QuickJoinFrameDropDown or (type(dropdown.which) == "string" and validTypes[dropdown.which])
end

---@type LibDropDownExtensionCallback
local function OnShow(dropdown, event, options, level, data)
	if not IsValidDropDown(dropdown) then
		return
	end

	local unit = dropdown.unit

	-- via party or target frames
	if UnitExists(unit) then
		if not UnitIsPlayer(unit) then
			return
		end

		local name, realm = UnitName(unit)
		currentDropDownSelection.name = name
		currentDropDownSelection.realm = realm
	end

	local battleNetAccountId = dropdown.bnetIDAccount

	-- via friendlist
	if not currentDropDownSelection.name and battleNetAccountId then
		local index = BNGetFriendIndex(battleNetAccountId)

		if not index then
			return
		end

		for i = 1, C_BattleNet.GetFriendNumGameAccounts(index), 1 do
			local accountInfo = C_BattleNet.GetFriendGameAccountInfo(index, i)

			if accountInfo and accountInfo.clientProgram == BNET_CLIENT_WOW then
				currentDropDownSelection.name = accountInfo.characterName

				if accountInfo.realmDisplayName then
					currentDropDownSelection.realm = accountInfo.realmDisplayName
				elseif accountInfo.richPresence then
					-- when checking a character from a different project id (classic <-> retail),
					-- realm name is always missing. accountInfo.realmID is misleading,
					-- it's the underlying connected realm id which cannot be resolved to a specific realm.
					-- however, the rich presence will always indicate "Zone - Realm".
					local realm = select(2, strsplit("-", accountInfo.richPresence))

					currentDropDownSelection.realm = realm
					currentDropDownSelection.projectId = accountInfo.wowProjectID
				else
					currentDropDownSelection.realm = Private.CurrentRealm.name
				end
				break
			end
		end
	end

	-- /who window
	-- Guild & Community window (Retail)
	if not currentDropDownSelection.name and dropdown.name then
		if dropdown.whoIndex then
			local info = C_FriendList.GetWhoInfo(dropdown.whoIndex)

			if info then
				local name, realm = strsplit("-", info.fullName)

				currentDropDownSelection.name = name
				currentDropDownSelection.realm = realm
			end
		elseif dropdown.clubInfo and dropdown.clubInfo.clubType == Enum.ClubType.Guild then -- Guild
			local info = dropdown.clubMemberInfo

			if info then
				local name, realm = strsplit("-", dropdown.name)

				currentDropDownSelection.name = name
				currentDropDownSelection.realm = realm
			end
		elseif dropdown.clubInfo and dropdown.clubInfo.clubType == Enum.ClubType.Character then -- Community
			local info = dropdown.clubMemberInfo

			if info then
				local name, realm = strsplit("-", info.name)

				currentDropDownSelection.name = name
				currentDropDownSelection.realm = realm
			end
		elseif dropdown.which ~= "BN_FRIEND" then
			-- ignore:
			-- BN_FRIEND because offline bn friends have the `name` set but that's their bnet name

			-- right-clicking a guild member in classic doesn't contain level info and is considered the same
			-- frame origin as the friend list
			if Private.IsClassicEra and dropdown.which == "FRIEND" and GuildFrame:IsVisible() then
				local matchFound = false

				for i = 1, GUILDMEMBERS_TO_DISPLAY do
					local fullName = GetGuildRosterInfo(i)

					if fullName == dropdown.chatTarget then
						matchFound = true
						currentDropDownSelection.name = dropdown.name
						currentDropDownSelection.realm = dropdown.server
						break
					end
				end

				-- could not find a match from guild view, fallback to showing it regardless
				if not matchFound then
					currentDropDownSelection.name = dropdown.name
					currentDropDownSelection.realm = dropdown.server
				end
			else
				currentDropDownSelection.name = dropdown.name
				currentDropDownSelection.realm = dropdown.realm
			end
		end
	end

	-- Quick Join
	if not currentDropDownSelection.name and dropdown.quickJoinButton then
		local memberInfo = dropdown.quickJoinButton.Members[1]

		local linkString = LinkUtil.SplitLink(memberInfo.playerLink)
		local linkType, linkDisplayText, bnetIDAccount = strsplit(":", linkString)

		if linkType == "BNplayer" then -- quick join entry is from a player in your friend list
			local index = BNGetFriendIndex(bnetIDAccount)

			for i = 1, C_BattleNet.GetFriendNumGameAccounts(index), 1 do
				local accountInfo = C_BattleNet.GetFriendGameAccountInfo(index, i)

				if accountInfo and accountInfo.clientProgram == BNET_CLIENT_WOW then
					currentDropDownSelection.name = accountInfo.characterName
					-- in contrast to the above branch where `realmDisplayName` can be missing for x-project bnet friend list entries,
					-- it must be always present for this scenario as LFG entries from a different project don't show up
					currentDropDownSelection.realm = accountInfo.realmDisplayName
					break
				end
			end
		elseif linkType == "player" then -- quick join entry is from a player on your realm
			currentDropDownSelection.name = linkDisplayText
			currentDropDownSelection.realm = Private.CurrentRealm.name
		end
	end

	-- Group Finder
	if not currentDropDownSelection.name and dropdown.menuList then
		for i = 1, #dropdown.menuList do
			local item = dropdown.menuList[i]

			if item and (item.text == WHISPER_LEADER or item.text == WHISPER) then
				local name, realm = strsplit("-", item.arg1)

				currentDropDownSelection.name = name
				currentDropDownSelection.realm = realm
			end
		end
	end

	if not currentDropDownSelection.name then
		return false
	end

	if options[1] then
		return true
	end

	local index = 0
	for i = 1, #customDropDownOptions do
		local option = customDropDownOptions[i]

		index = index + 1
		options[index] = option
	end

	return true
end

local function OnHide(dropdown, event, options, level, data)
	currentDropDownSelection.name = nil
	currentDropDownSelection.realm = nil
	currentDropDownSelection.projectId = WOW_PROJECT_ID

	if options[1] then
		for i = #options, 1, -1 do
			options[i] = nil
		end

		return true
	end
end

LibDropDownExtension:RegisterEvent("OnShow", OnShow, 1)
LibDropDownExtension:RegisterEvent("OnHide", OnHide, 1)
