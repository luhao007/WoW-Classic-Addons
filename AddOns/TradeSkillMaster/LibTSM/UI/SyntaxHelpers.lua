-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local SyntaxHelpers = TSM.Init("UI.SyntaxHelpers")
local CustomPrice = TSM.Include("Service.CustomPrice")
local Theme = TSM.Include("Util.Theme")
local Money = TSM.Include("Util.Money")
local private = {
	result = {},
	resultLen = nil,
	text = nil,
	pos = nil,
	cursor = nil,
	newCursor = nil,
	prevTokenLength = nil,
	prevTokenColored = nil,
}
local NEWLINE_CHAR = "\n"
local INDENT_STR = "    "
local TEXT_COLOR_SUFFIX = "|r"
local DIVIDER_COLOR = "GROUP_ONE"
local MATH_COLOR = "GROUP_FOUR"
local FUNCTION_COLOR = "GROUP_THREE"
local SOURCE_COLOR = "GROUP_TWO"
local CUSTOM_SOURCE_COLOR = "GROUP_FIVE"
local NUMBER_COLOR = "TEXT"
local UNKNOWN_COLOR = "FEEDBACK_RED"
local TOKENS = {
	UNKNOWN = newproxy(),
	NUMBER = newproxy(),
	MONEY = newproxy(),
	NEWLINE = newproxy(),
	WHITESPACE = newproxy(),
	IDENTIFIER = newproxy(),
	COMMA = newproxy(),
	LEFTPAREN = newproxy(),
	RIGHTPAREN = newproxy(),
	MATH_OPERATOR = newproxy(),
	COLORCODE = newproxy(),
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function SyntaxHelpers.StripWhitespace(text)
	text = gsub(text, "[\n\r ]", "")
	return text
end

function SyntaxHelpers.StripColors(value)
	value = gsub(value, "|c%x%x%x%x%x%x%x%x", "")
	value = gsub(value, TEXT_COLOR_SUFFIX, "")
	return value
end

function SyntaxHelpers.SetAutoIndent(text)
	assert(#private.result == 0)
	local writeIndex = 1
	for readIndex = 1, #text do
		local char = strsub(text, readIndex, readIndex)
		local nextChar = strsub(text, readIndex + 1, readIndex + 1)
		local shouldAddNewline = nil
		if (char == "(" or char == ",") and nextChar ~= "\n" then
			shouldAddNewline = true
		elseif char ~= "\n" and char ~= " " and nextChar == ")" then
			shouldAddNewline = true
		elseif char == ")" and nextChar ~= "\n" and nextChar ~= "," then
			shouldAddNewline = true
		else
			shouldAddNewline = false
		end
		if shouldAddNewline then
			tinsert(private.result, strsub(text, writeIndex, readIndex))
			tinsert(private.result, NEWLINE_CHAR)
			writeIndex = readIndex + 1
		end
	end
	tinsert(private.result, strsub(text, writeIndex))
	local result = table.concat(private.result)
	wipe(private.result)
	return result
end

function SyntaxHelpers.SetSyntaxColor(text, cursor)
	private.PrepareContext(private.StripColorsAtPos(text, cursor))
	private.SetSyntaxColor()
	return private.ClearContextAndReturnResult()
end

function SyntaxHelpers.SetIndent(text, cursor)
	private.PrepareContext(private.StripColorsAtPos(text, cursor))
	private.SetIndent()
	return private.ClearContextAndReturnResult()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PrepareContext(text, cursor)
	assert(#private.result == 0)
	assert(private.text == nil)
	private.text = text
	private.pos = 1
	private.cursor = cursor
	private.newCursor = nil
	private.prevTokenLength = 0
	private.prevTokenColored = false
	private.resultLen = 0
end

function private.ClearContextAndReturnResult()
	private.text = nil
	local result = table.concat(private.result)
	wipe(private.result)
	return result, private.newCursor
end

function private.SetSyntaxColor()
	while true do
		private.UpdateNewCursor()
		local tokenType, tokenStr = private.NextToken()
		if not tokenType then
			break
		end
		private.prevTokenColored = false
		if tokenType == TOKENS.NEWLINE or tokenType == TOKENS.WHITESPACE then
			private.InsertResult(tokenStr)
		else
			private.InsertColoredToken(tokenType, tokenStr)
		end
		private.prevTokenLength = #tokenStr
	end
end

function private.SetIndent()
	local newCursorPosFinalized = false
	local level = 0
	local hitNonWhitespace = false
	local hitIndentRight = false
	local preIndent = 0
	local postIndent = 0
	local bufferStartIndex = 1
	while true do
		private.UpdateNewCursor()
		private.prevTokenColored = false
		private.prevTokenLength = 0
		local tokenType, tokenStr = private.NextToken()
		if not tokenType or tokenType == TOKENS.NEWLINE then
			level = max(level + preIndent, 0)
			local indentStr = strrep(INDENT_STR, level)
			private.InsertResult(indentStr, bufferStartIndex)
			if private.newCursor and not newCursorPosFinalized then
				private.newCursor = private.newCursor + #indentStr
				newCursorPosFinalized = true
			end
			if not tokenType then
				break
			end
			private.InsertResult(tokenStr)
			bufferStartIndex = #private.result + 1
			level = max(level + postIndent, 0)
			hitNonWhitespace = false
			hitIndentRight = false
			preIndent = 0
			postIndent = 0
		elseif tokenType ~= TOKENS.WHITESPACE then
			hitNonWhitespace = true
			private.prevTokenLength = #tokenStr
			if tokenType == TOKENS.LEFTPAREN then
				if hitIndentRight then
					postIndent = postIndent + 1
				else
					hitIndentRight = true
					postIndent = postIndent + 1
				end
			elseif tokenType == TOKENS.RIGHTPAREN then
				if hitIndentRight then
					postIndent = postIndent - 1
				else
					preIndent = preIndent - 1
				end
			end
			private.InsertColoredToken(tokenType, tokenStr)
		elseif hitNonWhitespace then
			private.InsertResult(tokenStr)
			private.prevTokenLength = #tokenStr
		end
	end
end

function private.StripColorsAtPos(text, pos)
	local left = SyntaxHelpers.StripColors(strsub(text, 1, pos))
	local right = SyntaxHelpers.StripColors(strsub(text, pos + 1))
	return left..right, #left + 1
end

function private.UpdateNewCursor()
	if private.newCursor or private.pos < private.cursor then
		return
	end
	private.newCursor = private.resultLen
	if private.pos ~= private.cursor then
		local diff = private.pos - private.cursor
		if diff > private.prevTokenLength then
			diff = private.prevTokenLength
		end
		if private.prevTokenColored then
			diff = diff + #TEXT_COLOR_SUFFIX
		end
		private.newCursor = private.newCursor - diff
	end
end

function private.NextToken()
	local char = strsub(private.text, private.pos, private.pos)
	if char == "" then
		return
	end
	if char == "\n" then
		-- Newline
		private.pos = private.pos + 1
		return TOKENS.NEWLINE, char
	elseif char == " " or char == "\t" then
		-- Whitespace token
		local nextPos = strfind(private.text, "[^\t ]", private.pos + 1) or (#private.text + 1)
		local str = strsub(private.text, private.pos, nextPos - 1)
		private.pos = nextPos
		return TOKENS.WHITESPACE, str
	end
	if char == "." or tonumber(char) then
		-- Get the full number token
		local match = strmatch(private.text, "^[0-9%.]+", private.pos)
		private.pos = private.pos + #match
		if not tonumber(match) then
			return TOKENS.UNKNOWN, match
		end
		local nextChar = strsub(private.text, private.pos, private.pos)
		if nextChar == "e" or nextChar == "E" then
			-- Check if there's an exponent next
			local expMatch = strmatch(private.text, "^([eE]%-?[0-9]+)", private.pos)
			if not expMatch then
				return TOKENS.UNKNOWN, match
			end
			private.pos = private.pos + #expMatch
			return TOKENS.NUMBER, match .. expMatch
		elseif nextChar == "g" or nextChar == "s" or nextChar == "c" then
			-- There is a currency symbol next
			private.pos = private.pos + 1
			return TOKENS.MONEY, match .. nextChar
		end
		return TOKENS.NUMBER, match
	elseif char == "," then
		private.pos = private.pos + 1
		return TOKENS.COMMA, char
	elseif char == "(" then
		private.pos = private.pos + 1
		return TOKENS.LEFTPAREN, char
	elseif char == ")" then
		private.pos = private.pos + 1
		return TOKENS.RIGHTPAREN, char
	elseif char == "+" or char == "-" or char == "*" or char == "/" or char == "^" or char == "%" then
		private.pos = private.pos + 1
		return TOKENS.MATH_OPERATOR, char
	elseif char == "|" and strmatch(private.text, "^|c", private.pos) then
		local str = strsub(private.text, private.pos, private.pos + 9)
		private.pos = private.pos + 10
		return TOKENS.COLORCODE, str
	elseif char == "|" and strmatch(private.text, "^|r", private.pos) then
		private.pos = private.pos + 2
		return TOKENS.COLORCODE, "|r"
	else
		-- Find the end of this identifier
		local nextPos = strfind(private.text, "[\n \t/%.%-,%(%)%+%^%*%%|]", private.pos + 1) or (#private.text + 1)
		local str = strsub(private.text, private.pos, nextPos - 1)
		private.pos = nextPos
		return TOKENS.IDENTIFIER, str
	end
end

function private.InsertColoredToken(tokenType, str)
	local color = nil
	if tokenType == TOKENS.NUMBER then
		color = NUMBER_COLOR
	elseif tokenType == TOKENS.MONEY then
		color = NUMBER_COLOR
		local symbol = strsub(str, -1)
		local coloredSymbol = nil
		if symbol == "g" then
			coloredSymbol = Money.GetGoldText()
		elseif symbol == "s" then
			coloredSymbol = Money.GetSilverText()
		elseif symbol == "c" then
			coloredSymbol = Money.GetCopperText()
		else
			error("Unexpected currency symbol: "..symbol)
		end
		private.InsertResult(strsub(str, 1, -2))
		private.InsertResult(coloredSymbol)
		private.prevTokenColored = true
		return
	elseif tokenType == TOKENS.MATH_OPERATOR then
		color = MATH_COLOR
	elseif tokenType == TOKENS.LEFTPAREN or tokenType == TOKENS.RIGHTPAREN or tokenType == TOKENS.COMMA then
		color = DIVIDER_COLOR
	elseif tokenType == TOKENS.IDENTIFIER then
		if CustomPrice.IsMathFunction(str) then
			color = FUNCTION_COLOR
		elseif CustomPrice.IsSource(str) then
			color = SOURCE_COLOR
		elseif CustomPrice.IsCustomSource(str) then
			color = CUSTOM_SOURCE_COLOR
		else
			color = UNKNOWN_COLOR
		end
	elseif tokenType == TOKENS.UNKNOWN then
		color = UNKNOWN_COLOR
	else
		error("Unexpected token: "..tostring(tokenType))
	end
	private.prevTokenColored = true
	local prefix = Theme.GetColor(color):GetTextColorPrefix()
	private.InsertResult(prefix)
	private.InsertResult(str)
	private.InsertResult(TEXT_COLOR_SUFFIX)
end

function private.InsertResult(str, index)
	if index then
		tinsert(private.result, index, str)
	else
		tinsert(private.result, str)
	end
	private.resultLen = private.resultLen + #str
end
