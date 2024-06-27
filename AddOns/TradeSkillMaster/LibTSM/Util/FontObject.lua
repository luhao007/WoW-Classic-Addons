-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local FontObject = TSM.Init("Util.FontObject") ---@class Util.FontObject
local FontObjectValue = TSM.Include("LibTSMClass").DefineClass("FontObjectValue") ---@class FontObjectValue



-- ============================================================================
-- Module Functions
-- ============================================================================

---Create an font object from a path and height.
---@param path string The path to the font file
---@param size number The size of the font in pixels
---@param lineHeight number The height of each line of text in pixels
---@param flags? 'OUTLINE'|'THICK'|'MONOCHROME' A set of flags
---@return FontObject @The font object
function FontObject.New(path, size, lineHeight, flags)
	assert(type(path) == "string" and type(size) == "number" and type(lineHeight) == "number" and (flags == nil or type(flags) == "string"))
	return FontObjectValue(path, size, lineHeight, flags or "")
end



-- ============================================================================
-- FontObjectValue Class Methods
-- ============================================================================

function FontObjectValue:__init(path, size, lineHeight, flags)
	self._path = path
	self._size = size
	self._lineHeight = lineHeight
	self._flags = flags
end

function FontObjectValue:__tostring()
	local shortPath = strmatch(self._path, "([^/\\]+)%.[A-Za-z]+$")
	return "FontObject:"..tostring(shortPath)..":"..tostring(self._size)..":"..tostring(self._lineHeight)
end

function FontObjectValue:GetWowFont()
	-- wow renders the font slightly bigger than the designs would indicate, so subtract one from the font height
	if self._path == "Fonts\\ARKai_C.ttf" then
		-- this font is a bit smaller than it should be, so increase it by 1
		return self._path, self._size + 1, self._flags
	else
		-- wow renders other fonts slightly bigger than the designs would indicate, so decrease the height by 1
		return self._path, self._size - 1, self._flags
	end
end

function FontObjectValue:GetSpacing()
	assert(self._lineHeight >= self._size)
	return self._lineHeight - self._size
end
