-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- FontObject Functions.
-- @module FontObject

local _, TSM = ...
local FontObject = TSM.Init("Util.FontObject")
local private = {
	context = {},
}



-- ============================================================================
-- Metatable
-- ============================================================================

local FONT_OBJECT_MT = {
	__index = {
		SetPath = function(self, path)
			assert(type(path) == "string")
			local context = private.context[self]
			context.path = path
			return self
		end,
		SetSize = function(self, size)
			assert(type(size) == "number")
			local context = private.context[self]
			context.size = size
			return self
		end,
		SetLineHeight = function(self, lineHeight)
			assert(type(lineHeight) == "number")
			local context = private.context[self]
			context.lineHeight = lineHeight
			return self
		end,
		GetWowFont = function(self)
			local context = private.context[self]
			-- wow renders the font slightly bigger than the designs would indicate, so subtract one from the font height
			if context.path == "Fonts\\ARKai_C.ttf" then
				-- this font is a bit smaller than it should be, so increase it by 1
				return context.path, context.size + 1
			else
				-- wow renders other fonts slightly bigger than the designs would indicate, so decrease the height by 1
				return context.path, context.size - 1
			end
		end,
		GetSpacing = function(self)
			local context = private.context[self]
			assert(context.lineHeight >= context.size)
			return context.lineHeight - context.size
		end,
	},
	__newindex = function(self, key, value) error("FontObject cannot be modified") end,
	__metatable = false,
	__tostring = function(self)
		local context = private.context[self]
		local shortPath = strmatch(context.path, "([^/\\]+)%.[A-Za-z]+$")
		return "FontObject:"..tostring(shortPath)..":"..tostring(context.size)..":"..tostring(context.lineHeight)
	end,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Create an font object from a path and height.
-- @tparam string path The path to the font file
-- @tparam number size The size of the font in pixels
-- @tparam number lineHeight The height of each line of text in pixels
-- @treturn FontObject The font object
function FontObject.New(path, size, lineHeight)
	local obj = setmetatable({}, FONT_OBJECT_MT)
	private.context[obj] = {
		path = nil,
		size = nil,
		lineHeight = nil,
	}
	obj:SetPath(path)
	obj:SetSize(size)
	obj:SetLineHeight(lineHeight)
	return obj
end

function FontObject.IsInstance(obj)
	return type(obj) == "table" and private.context[obj] and true or false
end
