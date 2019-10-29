-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
TSM.CONST = {}

-- Miscellaneous constants which should never change
TSM.CONST.OPERATION_SEP = "\001"
TSM.CONST.GROUP_SEP = "`"
TSM.CONST.ROOT_GROUP_PATH = ""
TSM.CONST.TOOLTIP_SEP = "\001"
TSM.CONST.PET_CAGE_ITEMSTRING = "i:82800"
TSM.CONST.UNKNOWN_ITEM_ITEMSTRING = "i:0"
TSM.CONST.DB_INDEX_FIELD_SEP = "~"
TSM.CONST.DB_INDEX_VALUE_SEP = "\001"
TSM.CONST.OTHER_FIELD_QUERY_PARAM = newproxy()
TSM.CONST.BOUND_QUERY_PARAM = newproxy()
TSM.CONST.ITEM_MAX_ID = 999999
TSM.CONST.MIN_BONUS_ID_ITEM_LEVEL = 200
TSM.CONST.AUCTION_DURATIONS = {
	WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and AUCTION_DURATION_ONE or gsub(AUCTION_DURATION_ONE, "12", "2"),
	WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and AUCTION_DURATION_TWO or gsub(AUCTION_DURATION_TWO, "24", "8"),
	WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and AUCTION_DURATION_THREE or gsub(AUCTION_DURATION_THREE, "48", "24"),
}
