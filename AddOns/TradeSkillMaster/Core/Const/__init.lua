-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
TSM.CONST = {}

-- Miscellaneous constants which should never change
TSM.CONST.OPERATION_SEP = "\001"
TSM.CONST.GROUP_SEP = "`"
TSM.CONST.ROOT_GROUP_PATH = ""
TSM.CONST.MIN_BONUS_ID_ITEM_LEVEL = 200
TSM.CONST.AUCTION_DURATIONS = {
	not TSM.IsWowVanillaClassic() and AUCTION_DURATION_ONE or gsub(AUCTION_DURATION_ONE, "12", "2"),
	not TSM.IsWowVanillaClassic() and AUCTION_DURATION_TWO or gsub(AUCTION_DURATION_TWO, "24", "8"),
	not TSM.IsWowVanillaClassic() and AUCTION_DURATION_THREE or gsub(AUCTION_DURATION_THREE, "48", "24"),
}
