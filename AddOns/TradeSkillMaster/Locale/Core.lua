-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Locale = TSM.Init("Locale")
local private = {
	locale = nil,
	tbl = nil,
}
local HAS_NO_LOCALE_TABLE = TSM.IsDevVersion() or TSM.IsTestEnvironment()



-- ============================================================================
-- Module Functions
-- ============================================================================

Locale:OnModuleLoad(function()
	private.locale = GetLocale()
	if private.locale == "enGB" then
		private.locale = "enUS"
	end
	if HAS_NO_LOCALE_TABLE then
		Locale.SetTable({})
	end
end)

function Locale.GetTable()
	assert(private.tbl)
	return private.tbl
end

function Locale.ShouldLoad(locale)
	assert(private.locale)
	return not HAS_NO_LOCALE_TABLE and locale == private.locale
end

function Locale.SetTable(tbl)
	assert(not private.tbl)
	private.tbl = setmetatable(tbl, {
		__index = function(t, k)
			local v = tostring(k)
			if not HAS_NO_LOCALE_TABLE then
				error(format("Locale string does not exist: \"%s\"", v))
			end
			rawset(t, k, v)
			return v
		end,
		__newindex = function()
			error("Cannot write to the locale table")
		end,
	})
end
