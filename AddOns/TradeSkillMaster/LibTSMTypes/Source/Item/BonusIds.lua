-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMTypes = select(2, ...).LibTSMTypes
local BonusIds = LibTSMTypes:Init("Item.BonusIds")
local Data = LibTSMTypes:From("LibTSMData"):Include("BonusId")
local private = {
	sortedBonusIdList = {},
	baseBonusIds = {},
	bonusIdCache = {},
	bonusIdTemp = {},
	curveDefaultValueCache = {},
}
local DEFAULT_PLAYER_LEVEL = 1



-- ============================================================================
-- Module Loading
-- ============================================================================

BonusIds:OnModuleLoad(function()
	for bonusId, info in pairs(Data.Info) do
		tinsert(private.sortedBonusIdList, bonusId)
		if info.base then
			private.baseBonusIds[info.base] = bonusId
		end
	end
	sort(private.sortedBonusIdList)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

function BonusIds.Filter(bonusIds)
	private.bonusIdCache[bonusIds] = private.bonusIdCache[bonusIds] or {}
	local cache = private.bonusIdCache[bonusIds]
	if not cache.num then
		wipe(private.bonusIdTemp)
		for idStr in gmatch(bonusIds, "[0-9]+") do
			local id = tonumber(idStr)
			if id and not private.bonusIdTemp[idStr] then
				private.bonusIdTemp[idStr] = true
				tinsert(private.bonusIdTemp, id)
			end
		end
		sort(private.bonusIdTemp)
		cache.num = #private.bonusIdTemp
		if cache.num == 0 then
			cache.value = ""
		else
			local str = table.concat(private.bonusIdTemp, ":")
			cache.value = strjoin(":", cache.num, str)
		end
	end
	return cache.value
end

function BonusIds.GetItemLevel(itemString)
	local numBonusIds, bonusIds = strmatch(itemString, "^i:[0-9]+:[0-9]*:([0-9]+):(.+)$")
	if not numBonusIds then
		return nil, false
	end
	numBonusIds = tonumber(numBonusIds)
	assert(numBonusIds > 0)
	local nextIsItemLevelModifier = false
	local itemLevelModifierValue = nil
	local relLevel = nil
	local importantBonusId = nil
	local baseLevel = nil
	for bonusId in gmatch(bonusIds, "([0-9]+)") do
		bonusId = tonumber(bonusId)
		if numBonusIds > 0 then
			local info = Data.Info[bonusId]
			if info then
				if info.rel then
					relLevel = (relLevel or 0) + info.rel
				elseif info.base then
					baseLevel = baseLevel or info.base
				else
					if not importantBonusId then
						importantBonusId = bonusId
					else
						-- sort bonusIds with a flat curve to the end - otherwise sort by the curveId
						local prevCurveId = Data.Info[importantBonusId].curveId
						local curveId = info.curveId
						if not prevCurveId and not curveId and importantBonusId < bonusId then
							importantBonusId = bonusId
						elseif prevCurveId and prevCurveId < (curveId or math.huge) then
							importantBonusId = bonusId
						end
					end
				end
			end
		elseif numBonusIds % 2 == 1 and bonusId == 9 then
			-- this is the level modifier key
			nextIsItemLevelModifier = true
		elseif nextIsItemLevelModifier then
			-- this is the level modifier value
			assert(not itemLevelModifierValue)
			itemLevelModifierValue = bonusId
			nextIsItemLevelModifier = false
		end
		numBonusIds = numBonusIds - 1
	end
	assert(not nextIsItemLevelModifier)
	if not importantBonusId then
		if baseLevel then
			return (relLevel or 0) + baseLevel, true
		else
			return relLevel, false
		end
	end
	local absLevel = nil
	local info = Data.Info[importantBonusId]
	if info.abs then
		absLevel = info.abs
	else
		itemLevelModifierValue = itemLevelModifierValue or DEFAULT_PLAYER_LEVEL
		absLevel = private.GetItemLevelFromCurve(info.curve, itemLevelModifierValue)
	end
	assert(absLevel)
	return absLevel, true
end

function BonusIds.GetBonusStringForLevel(itemLevel, isAbs)
	local curveBonusId, curveLevelModifier = nil, nil
	for _, bonusId in ipairs(private.sortedBonusIdList) do
		local info = Data.Info[bonusId]
		if info.hasOther then
			-- ignore this bonusId
		elseif (isAbs and info.abs == itemLevel) or (not isAbs and info.rel == itemLevel) then
			-- this is a match
			return "1:"..bonusId
		elseif isAbs and info.rel and private.baseBonusIds[itemLevel - info.rel] then
			-- This is a match with a base level bonusId
			local bonusId2 = private.baseBonusIds[itemLevel - info.rel]
			if bonusId < bonusId2 then
				return "2:"..bonusId..":"..bonusId2
			else
				return "2:"..bonusId2..":"..bonusId
			end
		elseif info.curveId and isAbs and not curveBonusId then
			-- check for this itemLevel on the curve
			local lowerLevelBound, upperLevelBound = nil, nil
			for curveLevel, curveItemLevel in pairs(info.curve) do
				if curveItemLevel == itemLevel then
					if not curveLevelModifier or curveLevel > curveLevelModifier then
						curveBonusId = bonusId
						curveLevelModifier = curveLevel
					end
				elseif curveItemLevel < itemLevel then
					lowerLevelBound = max(lowerLevelBound or -math.huge, curveLevel)
				else
					upperLevelBound = min(upperLevelBound or math.huge, curveLevel)
				end
			end
			if not curveLevelModifier and lowerLevelBound and upperLevelBound then
				-- check if we can iterpolate along the curve
				for level = lowerLevelBound, upperLevelBound do
					local lowerItemLevelBound = info.curve[lowerLevelBound]
					local upperItemLevelBound = info.curve[upperLevelBound]
					local curveItemLevel = floor(lowerItemLevelBound + ((level - lowerLevelBound) / (upperLevelBound - lowerLevelBound)) * (upperItemLevelBound - lowerItemLevelBound) + 0.5)
					if curveItemLevel == itemLevel then
						curveBonusId = bonusId
						curveLevelModifier = level
						break
					end
				end
			end
		end
	end
	if not curveBonusId then
		error(format("Could not find id (%s, %s)", tostring(itemLevel), tostring(isAbs)))
	end
	return "1:"..curveBonusId..":1:9:"..curveLevelModifier
end

function BonusIds.GetCraftingStatModifier(bonusId)
	return Data.CraftingStatModifier[bonusId]
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetItemLevelFromCurve(curve, playerLevel)
	if playerLevel == DEFAULT_PLAYER_LEVEL and private.curveDefaultValueCache[curve] then
		return private.curveDefaultValueCache[curve]
	end
	-- find the part of the curve which matches
	local lowerBound, upperBound = -math.huge, math.huge
	for level, itemLevel in pairs(curve) do
		if level == playerLevel then
			return itemLevel
		elseif level < playerLevel then
			lowerBound = max(lowerBound, level)
		elseif level > playerLevel then
			upperBound = min(upperBound, level)
		end
	end
	local result = nil
	if lowerBound == upperBound then
		result = curve[lowerBound]
	elseif lowerBound == -math.huge then
		result = curve[upperBound]
	elseif upperBound == math.huge then
		result = curve[lowerBound]
	else
		-- interpolate between the bounds
		result = floor(curve[lowerBound] + ((playerLevel - lowerBound) / (upperBound - lowerBound)) * (curve[upperBound] - curve[lowerBound]) + 0.5)
	end
	if playerLevel == DEFAULT_PLAYER_LEVEL then
		private.curveDefaultValueCache[curve] = result
	end
	return result
end
