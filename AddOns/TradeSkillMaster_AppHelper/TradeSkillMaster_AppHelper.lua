-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_AppHelper                           --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
TSMAPI.AppHelper = {}
local private = { data = {} }



function TSM.LoadData(tag, ...)
	private.data[tag] = private.data[tag] or {}
	tinsert(private.data[tag], {...})
end

function TSMAPI.AppHelper:FetchData(tag)
	local data = private.data[tag]
	private.data[tag] = nil
	return data
end

function TSMAPI.AppHelper:IsCurrentRealm(realm)
	realm = gsub(realm, "\226", "'")
	local currentRealmName = gsub(GetRealmName(), "\226", "'")
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		currentRealmName = currentRealmName.."-"..UnitFactionGroup("player")
	end
	return strlower(realm) == strlower(currentRealmName)
end
