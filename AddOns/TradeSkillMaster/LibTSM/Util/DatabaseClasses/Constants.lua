-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Constants = TSM.Init("Util.DatabaseClasses.Constants")
Constants.DB_INDEX_FIELD_SEP = "~"
Constants.DB_INDEX_VALUE_SEP = "\001"
Constants.OTHER_FIELD_QUERY_PARAM = newproxy()
Constants.BOUND_QUERY_PARAM = newproxy()
