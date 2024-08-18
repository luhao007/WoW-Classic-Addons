---@class Private
local Private = select(2, ...)

-- TODO: consider separating this file too based on _Vanilla once behaviour is
-- more fleshed out in terms of reusability of code between the branches

if Private.IsRetail then
	Private.Print("use TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, fn)")
elseif Private.IsClassicEra or Private.IsCata or Private.IsWrath then
	---@param profile Profile
	---@return string
	local function GetHeader(profile)
		local headerStart = "Warcraft Logs:"

		local header

		if profile.average ~= nil then
			local percentile = Private.EncodeWithPercentileColor(profile.average, Private.FormatAveragePercentile(profile.average))

			header = format(
				"%s %s (%d/%d %s)",
				headerStart,
				percentile,
				profile.progress.count,
				profile.progress.total,
				Private.GetDifficultyString(profile.difficulty, profile.size, profile.zoneId)
			)
		else
			header = format("%s (%d/%d %s)", headerStart, profile.progress.count, profile.progress.total, Private.GetDifficultyString(profile.difficulty, profile.size, profile.zoneId))
		end

		return WrapTextInColorCode(header, "ff79b6c9")
	end

	---@param spec ProfileSpec
	---@param zoneId number|nil
	---@param maxPercentileLength number
	---@param maxAspLength number
	---@param maxRankLength number
	local function GetSpecString(spec, zoneId, maxPercentileLength, maxAspLength, maxRankLength)
		local percentile = spec.average == nil and "" or Private.FormatAveragePercentile(spec.average)
		local specIcon = Private.EncodeWithTexture(Private.GetSpecIcon(spec.type))
		local percentileString = string.rep("  ", maxPercentileLength - #percentile) .. percentile
		local aspString = string.rep("  ", maxAspLength - #tostring(spec.asp)) .. spec.asp
		local rankString = "-"
		if spec.rank ~= nil then
			rankString = string.rep("  ", maxRankLength - #tostring(spec.rank)) .. spec.rank
		end

		local line = format(
			"%s %s   %d/%d %s   %s: %s   %s: %s",
			specIcon,
			percentileString,
			spec.progress.count,
			spec.progress.total,
			Private.GetDifficultyString(spec.difficulty, spec.size, zoneId),
			Private.L["AllStars"],
			aspString,
			Private.L["Rank"],
			rankString
		)

		return spec.average == nil and line or Private.EncodeWithPercentileColor(spec.average, line)
	end

	---@param profile Profile
	local function DoGameTooltipUpdate(profile)
		GameTooltip:AddLine(GetHeader(profile))

		local shiftDown = IsShiftKeyDown()
		local specEntryCount = #profile.specs
		local hasPerEncounterData = false

		if specEntryCount > 0 and profile.specs[1].encounters then
			for _, _ in ipairs(profile.specs[1].encounters) do
				hasPerEncounterData = true
				break
			end
		end

		local maxAspLength = 0
		local maxRankLength = 0
		local maxPercentileLength = 0

		for _, spec in ipairs(profile.specs) do
			maxAspLength = math.max(maxAspLength, #tostring(spec.asp))
			maxRankLength = math.max(maxRankLength, #tostring(spec.rank))
			if spec.average ~= nil then
				maxPercentileLength = math.max(maxPercentileLength, #Private.FormatAveragePercentile(spec.average))
			end
		end

		for index, spec in ipairs(profile.specs) do
			GameTooltip:AddLine(GetSpecString(spec, profile.zoneId, maxPercentileLength, maxAspLength, maxRankLength))

			if hasPerEncounterData and shiftDown then
				for _, encounter in ipairs(spec.encounters) do
					local color = encounter.kills == 0 and "ff666666" or "ffffffff"
					local encounterName = Private.L["Encounter-" .. encounter.id] or Private.L.Unknown
					local progress = WrapTextInColorCode(format("%s (%s)", encounterName, encounter.kills), color)

					if encounter.best ~= nil then
						GameTooltip:AddDoubleLine(progress, Private.EncodeWithPercentileColor(encounter.best, Private.FormatPercentile(encounter.best)))
					else
						GameTooltip:AddDoubleLine(progress)
					end
				end
			end

			if hasPerEncounterData and shiftDown and index ~= specEntryCount then
				GameTooltip_AddBlankLineToTooltip(GameTooltip)
			end
		end

		if hasPerEncounterData and not shiftDown then
			GameTooltip:AddLine(WrapTextInColorCode(Private.L.ShiftToExpand, "ff696969"))
		end
	end

	---@param self Frame
	local function OnTooltipSetUnit(self)
		if self ~= GameTooltip or InCombatLockdown() then
			return
		end

		local unitToken = select(2, self:GetUnit())

		if not unitToken or not UnitIsPlayer(unitToken) then
			return
		end

		local name, realm = UnitName(unitToken)
		local profile = Private.GetProfile(name, realm)

		if profile == nil then
			return
		end

		GameTooltip_AddBlankLineToTooltip(GameTooltip)
		DoGameTooltipUpdate(profile)
	end

	local function OnTooltipCleared()
		GameTooltip:SetBackdropBorderColor(1, 1, 1, 1)
	end

	GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)
	GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)

	if Private.IsClassicEra then
		---@type number|nil
		local lastSelectedGuildMemberIndex = nil
		---@type number|nil
		local lastHoveredGuildMemberIndex = nil

		---@param index number
		local function DoGuildFrameTooltipUpdate(index)
			local fullName, _, _, _, classDisplayName = GetGuildRosterInfo(index)

			local name, realm = strsplit("-", fullName)
			local profile = Private.GetProfile(name, realm)

			if profile == nil then
				return
			end

			if GuildMemberDetailFrame:IsVisible() then
				-- the GuildMemberDetailFrame contains the tooltip info of a previously hovered guild member (and more)
				-- this frame doesn't have a tooltip by itself, so we add our info below
				GameTooltip:SetOwner(GuildMemberDetailFrame, "ANCHOR_BOTTOMRIGHT", -1 * GuildMemberDetailFrame:GetWidth())
			else
				GameTooltip:SetOwner(GuildFrame, "ANCHOR_NONE")
			end

			local coloredName = WrapTextInColorCode(name, select(4, GetClassColor(strupper(classDisplayName))))
			GameTooltip:AddLine(coloredName)
			DoGameTooltipUpdate(profile)

			GameTooltip:Show()

			-- can't know tooltip dimensions before showing, so adjust after.
			-- not needed for GuildMemberDetailFrame due to different anchor
			if GameTooltip:GetOwner() == GuildFrame then
				GameTooltip:SetPoint("TOPRIGHT", GuildFrame, GameTooltip:GetWidth(), 0)
			end
		end

		---@param self Frame
		local function OnGuildMemberDetailCloseButton(self)
			if GameTooltip:GetOwner() == GuildMemberDetailFrame then
				GameTooltip:SetOwner(GuildFrame, "ANCHOR_TOP")
				lastSelectedGuildMemberIndex = nil
			end
		end

		GuildMemberDetailCloseButton:HookScript("OnClick", OnGuildMemberDetailCloseButton)

		---@param self Frame
		local function OnGuildMemberDetailFrameEnter(self)
			if lastHoveredGuildMemberIndex or lastSelectedGuildMemberIndex then
				DoGuildFrameTooltipUpdate(lastSelectedGuildMemberIndex or lastHoveredGuildMemberIndex)
			end
		end

		GuildMemberDetailFrame:HookScript("OnEnter", OnGuildMemberDetailFrameEnter)

		---@param self Frame
		local function OnGuildFrameHide(self)
			lastSelectedGuildMemberIndex = nil
			lastHoveredGuildMemberIndex = nil
			GameTooltip:Hide()
		end

		FriendsFrame:HookScript("OnHide", OnGuildFrameHide)

		---@param self Frame
		local function OnGuildFrameButtonEnter(self)
			lastHoveredGuildMemberIndex = self.guildIndex
			DoGuildFrameTooltipUpdate(lastSelectedGuildMemberIndex or lastHoveredGuildMemberIndex)
		end

		---@param self Frame
		local function OnGuildFrameButtonLeave(self)
			lastHoveredGuildMemberIndex = nil
			GameTooltip:Hide()

			if GuildMemberDetailFrame:IsVisible() and lastSelectedGuildMemberIndex then
				DoGuildFrameTooltipUpdate(lastSelectedGuildMemberIndex)
			end
		end

		---@param self Frame
		---@param button string
		---@param down boolean
		local function OnGuildFrameButtonClick(self, button, down)
			if not down and button == "LeftButton" then
				local currentSelection = GetGuildRosterSelection()

				if currentSelection > 0 then
					lastSelectedGuildMemberIndex = currentSelection
					DoGuildFrameTooltipUpdate(lastSelectedGuildMemberIndex)
				else
					lastSelectedGuildMemberIndex = nil
					-- details no longer opened, but still hovering
					DoGuildFrameTooltipUpdate(lastHoveredGuildMemberIndex)
				end
			end
		end

		for i = 1, GUILDMEMBERS_TO_DISPLAY do
			---@type Frame|nil
			local guildFrameButton = _G["GuildFrameButton" .. i]
			local statusButton = _G["GuildFrameGuildStatusButton" .. i]

			if guildFrameButton then
				guildFrameButton:HookScript("OnEnter", OnGuildFrameButtonEnter)
				guildFrameButton:HookScript("OnLeave", OnGuildFrameButtonLeave)
				guildFrameButton:HookScript("OnClick", OnGuildFrameButtonClick)
			end

			if statusButton then
				statusButton:HookScript("OnEnter", OnGuildFrameButtonEnter)
				statusButton:HookScript("OnLeave", OnGuildFrameButtonLeave)
				statusButton:HookScript("OnClick", OnGuildFrameButtonClick)
			end
		end

		EventRegistry:RegisterFrameEventAndCallback(
			"MODIFIER_STATE_CHANGED",
			---@param owner number
			---@param key string
			---@param down number
			function(owner, key, down)
				if string.match(key, "SHIFT") ~= nil and GameTooltip:IsVisible() and not InCombatLockdown() then
					local unit = select(2, GameTooltip:GetUnit())

					if unit then
						GameTooltip:SetUnit(unit)
					elseif GuildFrame:IsVisible() and lastSelectedGuildMemberIndex then
						DoGuildFrameTooltipUpdate(lastSelectedGuildMemberIndex)
					end
				end
			end
		)
	elseif Private.IsCata or Private.IsWrath then
		---@param self Frame
		function LFGListApplicantMember_OnEnter(self)
			local applicantID = self:GetParent().applicantID
			local memberIdx = self.memberIdx

			local activeEntryInfo = C_LFGList.GetActiveEntryInfo()
			if not activeEntryInfo then
				return
			end

			local activityInfo = C_LFGList.GetActivityInfoTable(activeEntryInfo.activityID)
			if not activityInfo then
				return
			end
			local applicantInfo = C_LFGList.GetApplicantInfo(applicantID)
			local name, class, localizedClass, level, itemLevel, honorLevel, _, _, _, _, _, dungeonScore, pvpItemLevel = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
			local bestDungeonScoreForEntry = C_LFGList.GetApplicantDungeonScoreForListing(applicantID, memberIdx, activeEntryInfo.activityID)
			local pvpRatingForEntry = C_LFGList.GetApplicantPvpRatingInfoForListing(applicantID, memberIdx, activeEntryInfo.activityID)

			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 105, 0)

			if name then
				local classTextColor = RAID_CLASS_COLORS[class]
				GameTooltip:SetText(name, classTextColor.r, classTextColor.g, classTextColor.b)
				-- patch applied to fix error thrown by the game
				-- if UnitFactionGroup("player") ~= PLAYER_FACTION_GROUP[factionGroup] then
				-- 	GameTooltip_AddHighlightLine(GameTooltip, UNIT_TYPE_LEVEL_FACTION_TEMPLATE:format(level, localizedClass, FACTION_STRINGS[factionGroup]))
				-- else
				GameTooltip_AddHighlightLine(GameTooltip, UNIT_TYPE_LEVEL_TEMPLATE:format(level, localizedClass))
				-- end
			else
				GameTooltip:SetText(" ") --Just make it empty until we get the name update
			end

			if activityInfo.isPvpActivity then
				GameTooltip_AddColoredLine(GameTooltip, LFG_LIST_ITEM_LEVEL_CURRENT_PVP:format(pvpItemLevel), HIGHLIGHT_FONT_COLOR)
			else
				GameTooltip_AddColoredLine(GameTooltip, LFG_LIST_ITEM_LEVEL_CURRENT:format(itemLevel), HIGHLIGHT_FONT_COLOR)
			end

			if activityInfo.useHonorLevel then
				GameTooltip:AddLine(string.format(LFG_LIST_HONOR_LEVEL_CURRENT_PVP, honorLevel), 1, 1, 1)
			end
			if applicantInfo.comment and applicantInfo.comment ~= "" then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(
					string.format(LFG_LIST_COMMENT_FORMAT, applicantInfo.comment),
					LFG_LIST_COMMENT_FONT_COLOR.r,
					LFG_LIST_COMMENT_FONT_COLOR.g,
					LFG_LIST_COMMENT_FONT_COLOR.b,
					true
				)
			end
			if LFGApplicationViewerRatingColumnHeader:IsShown() then
				if pvpRatingForEntry then
					GameTooltip_AddNormalLine(
						GameTooltip,
						PVP_RATING_GROUP_FINDER:format(pvpRatingForEntry.activityName, pvpRatingForEntry.rating, PVPUtil.GetTierName(pvpRatingForEntry.tier))
					)
				else
					if not dungeonScore then
						dungeonScore = 0
					end
					GameTooltip_AddBlankLineToTooltip(GameTooltip)
					local color = C_ChallengeMode.GetDungeonScoreRarityColor(dungeonScore)
					if not color then
						color = HIGHLIGHT_FONT_COLOR
					end
					GameTooltip_AddNormalLine(GameTooltip, DUNGEON_SCORE_LEADER:format(color:WrapTextInColorCode(dungeonScore)))
					if bestDungeonScoreForEntry then
						local overAllColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(bestDungeonScoreForEntry.mapScore)
						if not overAllColor then
							overAllColor = HIGHLIGHT_FONT_COLOR
						end
						if bestDungeonScoreForEntry.mapScore == 0 then
							GameTooltip_AddNormalLine(GameTooltip, DUNGEON_SCORE_PER_DUNGEON_NO_RATING:format(bestDungeonScoreForEntry.mapName, bestDungeonScoreForEntry.mapScore))
						elseif bestDungeonScoreForEntry.finishedSuccess then
							GameTooltip_AddNormalLine(
								GameTooltip,
								DUNGEON_SCORE_DUNGEON_RATING:format(
									bestDungeonScoreForEntry.mapName,
									overAllColor:WrapTextInColorCode(bestDungeonScoreForEntry.mapScore),
									bestDungeonScoreForEntry.bestRunLevel
								)
							)
						else
							GameTooltip_AddNormalLine(
								GameTooltip,
								DUNGEON_SCORE_DUNGEON_RATING_OVERTIME:format(
									bestDungeonScoreForEntry.mapName,
									overAllColor:WrapTextInColorCode(bestDungeonScoreForEntry.mapScore),
									bestDungeonScoreForEntry.bestRunLevel
								)
							)
						end
					end
				end
			end

			--Add statistics
			local stats = C_LFGList.GetApplicantMemberStats(applicantID, memberIdx)
			local lastTitle = nil

			--Tank proving ground
			if stats[23690] and stats[23690] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_TANK_GOLD, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
				lastTitle = LFG_LIST_PROVING_GROUND_TITLE
			elseif stats[23687] and stats[23687] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_TANK_SILVER, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
				lastTitle = LFG_LIST_PROVING_GROUND_TITLE
			elseif stats[23684] and stats[23684] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_TANK_BRONZE, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
				lastTitle = LFG_LIST_PROVING_GROUND_TITLE
			end

			--Healer proving ground
			if stats[23691] and stats[23691] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_HEALER_GOLD, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
				lastTitle = LFG_LIST_PROVING_GROUND_TITLE
			elseif stats[23688] and stats[23688] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_HEALER_SILVER, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
				lastTitle = LFG_LIST_PROVING_GROUND_TITLE
			elseif stats[23685] and stats[23685] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_HEALER_BRONZE, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
				lastTitle = LFG_LIST_PROVING_GROUND_TITLE
			end

			--Damage proving ground
			if stats[23689] and stats[23689] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_DAMAGER_GOLD, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
			elseif stats[23686] and stats[23686] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_DAMAGER_SILVER, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
			elseif stats[23683] and stats[23683] > 0 then
				LFGListUtil_AppendStatistic(LFG_LIST_PROVING_DAMAGER_BRONZE, nil, LFG_LIST_PROVING_GROUND_TITLE, lastTitle)
			end

			GameTooltip:Show()
		end

		---@type ClubMemberInfo|nil
		local lastExpandedGuildMemberInfo = nil
		---@type ClubMemberInfo|nil
		local lastHoveredGuildMemberInfo = nil
		---@type CommunitiesMemberListEntryMixin|nil
		local hoveredCommunitiesMemberListEntry = nil
		---@type Frame|nil
		local lastHoveredLFGListApplicantMember = nil
		---@type number|nil
		local lastLFGListResultID = nil

		---@see LFGList:1789 -> LFGListApplicantMember_OnEnter
		---@param self Frame
		local function OnLFGListApplicantMemberEnter(self)
			lastHoveredLFGListApplicantMember = self
			lastExpandedGuildMemberInfo = nil
			hoveredCommunitiesMemberListEntry = nil
			lastLFGListResultID = nil

			local applicantID = self:GetParent().applicantID
			local memberIdx = self.memberIdx

			local characterName = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)

			local name, realm = strsplit("-", characterName)
			local profile = Private.GetProfile(name, realm)

			if profile == nil then
				return
			end

			GameTooltip_AddBlankLineToTooltip(GameTooltip)

			DoGameTooltipUpdate(profile)

			GameTooltip:Show()
		end

		hooksecurefunc("LFGListApplicantMember_OnEnter", OnLFGListApplicantMemberEnter)

		---@param memberInfo ClubMemberInfo
		local function DoGuildFrameTooltipUpdate(memberInfo)
			local name, realm = strsplit("-", memberInfo.name)
			local profile = Private.GetProfile(name, realm)

			if profile == nil then
				return
			end

			if memberInfo == lastHoveredGuildMemberInfo then
				GameTooltip_AddBlankLineToTooltip(GameTooltip)
			elseif CommunitiesFrame.GuildMemberDetailFrame:IsVisible() then
				-- the GuildMemberDetailFrame contains the tooltip info of a previously hovered guild member (and more)
				-- this frame doesn't have a tooltip by itself, so we add our info below
				GameTooltip:SetOwner(CommunitiesFrame.GuildMemberDetailFrame, "ANCHOR_BOTTOMRIGHT", -1 * CommunitiesFrame.GuildMemberDetailFrame:GetWidth() + 10)
			end

			if memberInfo == lastExpandedGuildMemberInfo and memberInfo.classID then
				local className = GetClassInfo(memberInfo.classID)
				local coloredName = WrapTextInColorCode(memberInfo.name, select(4, GetClassColor(strupper(className))))
				GameTooltip:AddLine(coloredName)
			end

			DoGameTooltipUpdate(profile)

			GameTooltip:Show()
		end

		---@param GuildMemberDetailFrame self
		---@param clubId number
		---@param memberInfo ClubMemberInfo
		local function OnGuildMemberDetailFrameDisplayed(self, clubId, memberInfo)
			lastExpandedGuildMemberInfo = memberInfo
			lastHoveredGuildMemberInfo = nil
			lastHoveredLFGListApplicantMember = nil

			DoGuildFrameTooltipUpdate(memberInfo)
		end

		local function OnGuildMemberDetailFrameClosed()
			lastExpandedGuildMemberInfo = nil
			hoveredCommunitiesMemberListEntry = nil

			if GameTooltip:GetOwner() == CommunitiesFrame.GuildMemberDetailFrame then
				GameTooltip:SetOwner(UIParent, "ANCHOR_TOP")
			end
		end

		local function OnCommunitiesFrameHidden()
			OnGuildMemberDetailFrameClosed()
		end

		local function OnGuildMemberDetailFrameEnter()
			if lastExpandedGuildMemberInfo then
				DoGuildFrameTooltipUpdate(lastExpandedGuildMemberInfo)
			end
		end

		---@param CommunitiesMemberListEntryMixin self
		---@param unknownBoolean boolean
		local function OnCommunitiesMemberListEntryEnter(self, unknownBoolean)
			local memberInfo = self:GetMemberInfo()

			if not memberInfo then
				return
			end

			hoveredCommunitiesMemberListEntry = self
			lastHoveredGuildMemberInfo = memberInfo
			lastHoveredLFGListApplicantMember = nil

			DoGuildFrameTooltipUpdate(memberInfo)
		end

		---@param owner number
		---@param loadedAddonName string
		local function OnBlizzardCommunitiesLoaded(owner, loadedAddonName)
			if loadedAddonName == "Blizzard_Communities" then
				EventRegistry:UnregisterFrameEventAndCallback("ADDON_LOADED", owner)
				hooksecurefunc(CommunitiesFrame.GuildMemberDetailFrame, "DisplayMember", OnGuildMemberDetailFrameDisplayed)
				CommunitiesFrame.GuildMemberDetailFrame:HookScript("OnEnter", OnGuildMemberDetailFrameEnter)
				CommunitiesFrame.GuildMemberDetailFrame.CloseButton:HookScript("OnClick", OnGuildMemberDetailFrameClosed)
				CommunitiesFrame:HookScript("OnHide", OnCommunitiesFrameHidden)
				hooksecurefunc(CommunitiesMemberListEntryMixin, "OnEnter", OnCommunitiesMemberListEntryEnter)
			end
		end

		EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", OnBlizzardCommunitiesLoaded)

		---@type string
		local localizedGroupLeaderString = strsplit(" ", LFG_LIST_TOOLTIP_LEADER_FACTION or LFG_LIST_TOOLTIP_LEADER or "")
		local lastSeenLeader = {
			name = nil,
			realm = nil,
		}

		---@param tooltip GameTooltip
		---@param resultID number
		local function OnLFGListEntrySelection(tooltip, resultID)
			lastLFGListResultID = resultID
		end

		local function OnPVEFrameHide()
			lastLFGListResultID = nil
			lastSeenLeader.name = nil
			lastSeenLeader.realm = nil
			lastHoveredLFGListApplicantMember = nil
		end

		---@param self GameTooltip
		---@param line string
		local function OnGameTooltipLineAdded(self, line)
			if not LFGListFrame:IsVisible() or not line then
				return
			end

			-- parse `Leader: NAME-REALM (FACTION)` info from GameTooltip:AddLine while its being added
			-- and store the current data
			if line:find(localizedGroupLeaderString) ~= nil then
				local withoutLeaderPrefix = line:gsub("^[^:]*:%s*", "")
				local withoutFaction = withoutLeaderPrefix:gsub("%s*%b()", "")
				---@type string
				local trimmed = withoutFaction:match("^%s*(.-)%s*$")
				local sanitized = trimmed:gsub("|cffffffff", ""):gsub("|r", "")

				local name, realm = strsplit("-", sanitized)
				lastSeenLeader.name = name
				lastSeenLeader.realm = realm or Private.CurrentRealm.name
				return
			end

			-- given a leader and seeing the `Members: x (0/1/2)` pattern, append profile data
			-- before `LFGListUtil_SetSearchEntryTooltip` calls :Show on the tooltip which finalizes layouting
			if lastSeenLeader.name ~= nil and line:find("(%d+)%s*%((%d+/%d+/%d+)%)") ~= nil then
				local profile = Private.GetProfile(lastSeenLeader.name, lastSeenLeader.realm)

				if profile == nil then
					return
				end

				GameTooltip_AddBlankLineToTooltip(GameTooltip)

				DoGameTooltipUpdate(profile)
			end
		end

		hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", OnLFGListEntrySelection)
		PVEFrame:HookScript("OnHide", OnPVEFrameHide)
		hooksecurefunc(GameTooltip, "AddLine", OnGameTooltipLineAdded)

		local function MeetingHornOnItemEnter() end
		local meetingHornItem = nil

		EventRegistry:RegisterFrameEventAndCallback(
			"MODIFIER_STATE_CHANGED",
			---@param owner number
			---@param key string
			---@param down number
			function(owner, key, down)
				if string.match(key, "SHIFT") ~= nil and GameTooltip:IsVisible() and not InCombatLockdown() then
					local unit = select(2, GameTooltip:GetUnit())

					if unit then
						GameTooltip:SetUnit(unit)
					elseif lastLFGListResultID then
						-- we call the hooked game fn so we don't have to clear up the tooltip ourselves
						LFGListUtil_SetSearchEntryTooltip(GameTooltip, lastLFGListResultID)
					elseif lastHoveredLFGListApplicantMember ~= nil then
						LFGListApplicantMember_OnEnter(lastHoveredLFGListApplicantMember)
					elseif CommunitiesFrame ~= nil then
						if CommunitiesFrame.GuildMemberDetailFrame:IsVisible() and GameTooltip:GetOwner() == CommunitiesFrame.GuildMemberDetailFrame and lastExpandedGuildMemberInfo then
							DoGuildFrameTooltipUpdate(lastExpandedGuildMemberInfo)
						elseif hoveredCommunitiesMemberListEntry then
							hoveredCommunitiesMemberListEntry:OnEnter()
						end
					elseif meetingHornItem then
						MeetingHornOnItemEnter(nil, nil, meetingHornItem)
					end
				end
			end
		)

		table.insert(Private.LoginFnQueue, function()
			if Private.CurrentRealm.region ~= "CN" then
				return
			end

			local fn = C_AddOns.IsAddOnLoaded or IsAddOnLoaded
			local addonName = "MeetingHorn"

			if not fn(addonName) or LibStub == nil then
				return
			end

			local MeetingHorn = LibStub("AceAddon-3.0"):GetAddon(addonName)
			local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
			local Browser = MeetingHorn.MainPanel.Browser
			local ActivityList = Browser.ActivityList

			MeetingHornOnItemEnter = function(_, button, item)
				local r, g, b = GetClassColor(item:GetLeaderClass())
				GameTooltip:SetOwner(Browser, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", Browser, "TOPRIGHT", 8, 60)
				GameTooltip:SetText(item:GetTitle())
				GameTooltip:AddLine(item:GetLeader(), r, g, b)
				local level = item:GetLeaderLevel()
				if level then
					local color = GetQuestDifficultyColor(level)
					GameTooltip:AddLine(format("%s |cff%02x%02x%02x%s|r", LEVEL, color.r * 255, color.g * 255, color.b * 255, item:GetLeaderLevel()), 1, 1, 1)
				end
				GameTooltip:AddLine(item:GetComment(), 0.6, 0.6, 0.6, true)
				GameTooltip_AddBlankLineToTooltip(GameTooltip)

				local profile = Private.GetProfile(item:GetLeader())
				if profile then
					DoGameTooltipUpdate(profile)
				end
				GameTooltip_AddBlankLineToTooltip(GameTooltip)

				if not item:IsActivity() then
					GameTooltip:AddLine(L["<Double-Click> Whisper to player"], 1, 1, 1)
				end
				GameTooltip:AddLine(L["<Right-Click> Open activity menu"], 1, 1, 1)
				GameTooltip:Show()

				meetingHornItem = item
			end

			ActivityList:SetCallback("OnItemEnter", MeetingHornOnItemEnter)
			ActivityList:SetCallback("OnItemLeave", function()
				meetingHornItem = nil
			end)
		end)
	end
end
