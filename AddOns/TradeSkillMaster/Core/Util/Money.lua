-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Money Functions
-- @module Money

local _, TSM = ...
TSM.Money = {}
local Money = TSM.Money
local private =  { textMoneyParts = {} }
local GOLD_ICON = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
local SILVER_ICON = "|TInterface\\MoneyFrame\\UI-SilverIcon:0|t"
local COPPER_ICON = "|TInterface\\MoneyFrame\\UI-CopperIcon:0|t"
local GOLD_TEXT = "|cffffd70ag|r"
local SILVER_TEXT = "|cffc7c7cfs|r"
local COPPER_TEXT = "|cffeda55fc|r"
local GOLD_TEXT_DISABLED = "|cff5d5222g|r"
local SILVER_TEXT_DISABLED = "|cff464646s|r"
local COPPER_TEXT_DISABLED = "|cff402d22c|r"



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Converts a numeric money value (in copper) to a string for display in the UI.
-- Supported options:
--
-- * OPT\_ICON Use texture icons instead of g/s/c letters
-- * OPT\_TRIM Remove any non-significant 0 valued denominations (i.e. "1g" instead of "1g 0s 0c")
-- * OPT\_DISABLE Uses a muted color from the denomination text (not allowed with "OPT\_ICON" or "OPT\_NO\_COLOR")
-- @tparam number value The money value to be converted in copper (100 copper per silver, 100 silver per gold)
-- @tparam[opt] string color A color prefix to use for the numbers in the result (i.e. "|cff00ff00" for red)
-- @param[opt] ... One or more options to modify the format of the result
-- @return The string representation of the specified money value
function Money.ToString(value, color, ...)
	value = tonumber(value)
	if not value then
		return
	end
	assert(not color or strmatch(color, "^\124cff[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$"))

	-- parse the options
	local isIcon, trim, disabled = nil, nil, nil
	for i = 1, select('#', ...) do
		local opt = select(i, ...)
		if opt == nil then
			-- pass
		elseif opt == "OPT_ICON" then
			isIcon = true
		elseif opt == "OPT_TRIM" then
			trim = true
		elseif opt == "OPT_DISABLE" then
			disabled = true
		else
			error("Invalid option: "..tostring(opt))
		end
	end
	assert(not (isIcon and disabled), "Setting both OPT_ICON and OPT_DISABLE is not allowed")

	local isNegative = value < 0
	value = abs(value)
	local gold = floor(value / COPPER_PER_GOLD)
	local silver = floor((value % COPPER_PER_GOLD) / COPPER_PER_SILVER)
	local copper = floor(value % COPPER_PER_SILVER)
	local goldText, silverText, copperText = nil, nil, nil
	if isIcon then
		goldText, silverText, copperText = GOLD_ICON, SILVER_ICON, COPPER_ICON
	elseif disabled then
		goldText, silverText, copperText = GOLD_TEXT_DISABLED, SILVER_TEXT_DISABLED, COPPER_TEXT_DISABLED
	else
		goldText, silverText, copperText = GOLD_TEXT, SILVER_TEXT, COPPER_TEXT
	end

	if value == 0 then
		return private.FormatNumber(0, false, color)..copperText
	end

	local text = nil
	local shouldPad = false
	if trim then
		wipe(private.textMoneyParts)
		-- add gold
		if gold > 0 then
			tinsert(private.textMoneyParts, private.FormatNumber(gold, false, color, true)..goldText)
			shouldPad = true
		end
		-- add silver
		if silver > 0 then
			tinsert(private.textMoneyParts, private.FormatNumber(silver, shouldPad, color)..silverText)
			shouldPad = true
		end
		-- add copper
		if copper > 0 then
			tinsert(private.textMoneyParts, private.FormatNumber(copper, shouldPad, color)..copperText)
			shouldPad = true
		end
		text = table.concat(private.textMoneyParts, " ")
	else
		if gold > 0 then
			text = private.FormatNumber(gold, false, color, true)..goldText.." "..private.FormatNumber(silver, true, color)..silverText.." "..private.FormatNumber(copper, true, color)..copperText
		elseif silver > 0 then
			text = private.FormatNumber(silver, false, color)..silverText.." "..private.FormatNumber(copper, true, color)..copperText
		else
			text = private.FormatNumber(copper, false, color)..copperText
		end
	end

	if isNegative then
		return (color and (color.."-|r") or "-")..text
	else
		return text
	end
end

--- Converts a string money value to a number value (in copper).
-- The value passed to this function can contain colored text, but must use g/s/c for the denominations and not icons.
-- @tparam string value The money value to be converted as a string
-- @treturn string The numeric representation of the specified money value
function Money.FromString(value)
	-- remove any colors
	value = gsub(gsub(strtrim(value), "\124c([0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])", ""), "\124r", "")
	-- remove any separators
	value = gsub(value, TSM.String.Escape(LARGE_NUMBER_SEPERATOR), "")

	-- extract gold/silver/copper values
	local gold = tonumber(strmatch(value, "([0-9]+)g"))
	local silver = tonumber(strmatch(value, "([0-9]+)s"))
	local copper = tonumber(strmatch(value, "([0-9]+)c"))
	if not gold and not silver and not copper then return end

	-- test that there are no extra characters (other than spaces)
	value = gsub(value, "[0-9]+g", "", 1)
	value = gsub(value, "[0-9]+s", "", 1)
	value = gsub(value, "[0-9]+c", "", 1)
	if strtrim(value) ~= "" then return end

	return ((gold or 0) * COPPER_PER_GOLD) + ((silver or 0) * COPPER_PER_SILVER) + (copper or 0)
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.FormatNumber(num, pad, color, sep)
	if num < 10 and pad then
		num = "0"..num
	elseif sep and num >= 1000 then
		num = tostring(num)
		local result = ""
		for i = 4, #num, 3 do
			result = LARGE_NUMBER_SEPERATOR..strsub(num, -(i - 1), -(i - 3))..result
		end
		result = strsub(num, 1, (#num % 3 == 0) and 3 or (#num % 3))..result
		num = result
	end

	if color then
		return color..num.."|r"
	else
		return num
	end
end
