-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local GroupPath = TSM.Init("Util.GroupPath") ---@class Util.GroupPath
local String = TSM.Include("Util.String")
local Table = TSM.Include("Util.Table")
local ROOT_GROUP_PATH = ""
local GROUP_SEP = "`"
local private = {
	sortLookupTemp = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function GroupPath.GetRoot()
	return ROOT_GROUP_PATH
end

function GroupPath.IsValid(groupPath)
	return not strmatch(groupPath, GROUP_SEP..GROUP_SEP)
end

function GroupPath.GetSortableString(groupPath)
	local str = gsub(groupPath, GROUP_SEP, "\001")
	return strlower(str)
end

function GroupPath.GetName(groupPath)
	local _, name = private.SplitPath(groupPath)
	return name
end

function GroupPath.GetParent(groupPath)
	local parentPath = private.SplitPath(groupPath)
	return parentPath
end

function GroupPath.Split(groupPath)
	return private.SplitPath(groupPath)
end

function GroupPath.Join(...)
	if select(1, ...) == ROOT_GROUP_PATH then
		return GroupPath.Join(select(2, ...))
	end
	return strjoin(GROUP_SEP, ...)
end

function GroupPath.IsChild(groupPath, parentPath)
	if parentPath == ROOT_GROUP_PATH then
		return groupPath ~= ROOT_GROUP_PATH
	end
	local parentSearchStr = parentPath..GROUP_SEP
	return strsub(groupPath, 1, #parentSearchStr) == parentSearchStr
end

function GroupPath.IsTopLevel(groupPath)
	return not strmatch(groupPath, GROUP_SEP)
end

function GroupPath.IsRoot(groupPath)
	return groupPath == ROOT_GROUP_PATH
end

function GroupPath.Format(groupPath)
	if not groupPath then
		return
	end
	local result = gsub(groupPath, GROUP_SEP, "->")
	return result
end

function GroupPath.GetRelative(groupPath, prefixGroupPath)
	if groupPath == prefixGroupPath then
		return ROOT_GROUP_PATH
	end
	local relativePath, numSubs = gsub(groupPath, "^"..String.Escape(prefixGroupPath)..GROUP_SEP, "")
	assert(numSubs == 1 and relativePath)
	return relativePath
end

function GroupPath.GetTopLevel(groupPath)
	assert(groupPath ~= ROOT_GROUP_PATH)
	return strmatch(groupPath, "^([^"..GROUP_SEP.."]+)")
end

function GroupPath.SortPaths(list)
	assert(not next(private.sortLookupTemp))
	for _, groupPath in ipairs(list) do
		private.sortLookupTemp[groupPath] = GroupPath.GetSortableString(groupPath)
	end
	Table.SortWithValueLookup(list, private.sortLookupTemp)
	wipe(private.sortLookupTemp)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SplitPath(groupPath)
	local parentPath, groupName = strmatch(groupPath, "^(.+)"..GROUP_SEP.."([^"..GROUP_SEP.."]+)$")
	if parentPath then
		return parentPath, groupName
	elseif groupPath ~= ROOT_GROUP_PATH then
		return ROOT_GROUP_PATH, groupPath
	else
		return nil, groupPath
	end
end
