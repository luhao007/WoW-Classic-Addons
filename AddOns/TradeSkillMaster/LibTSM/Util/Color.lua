-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Color Functions.
-- @module Color

local _, TSM = ...
local Color = TSM.Init("Util.Color")
local Math = TSM.Include("Util.Math")
local HSLuv = TSM.Include("Util.HSLuv")
local private = {
	context = {},
	transparent = nil,
	fullWhite = nil,
	fullBlack = nil,
}
local TINT_VALUES = {
	SELECTED = 15,
	HOVER = 12,
	SELECTED_HOVER = 20,
	DISABLED = -40,
}
local OPACITY_VALUES = {
	HIGHLIGHT = 50,
}



-- ============================================================================
-- Metatable
-- ============================================================================

local COLOR_MT = {
	__index = {
		GetTint = function(self, tintPct)
			local context = private.context[self]
			assert(context.hex)
			if type(tintPct) == "string" then
				local sign, tintKey = strmatch(tintPct, "^([%+%-])([A-Z_]+)$")
				assert(TINT_VALUES[tintKey])
				tintPct = tonumber(TINT_VALUES[tintKey]) * (sign == "+" and 1 or -1)
			end
			assert(type(tintPct) == "number")
			if tintPct == 0 then
				return self
			end
			if not context.tints[tintPct] then
				local l = context.l + tintPct
				l = min(l, 100)
				assert(private.IsValidValue(l, 100))
				local r, g, b = HSLuv.ToRGB(context.h, context.s, l)
				context.tints[tintPct] = private.NewColorHelper(r, g, b, context.a)
			end
			return context.tints[tintPct]
		end,
		GetOpacity = function(self, opacityPct)
			local context = private.context[self]
			assert(context.hex)
			if type(opacityPct) == "string" then
				assert(OPACITY_VALUES[opacityPct])
				opacityPct = tonumber(OPACITY_VALUES[opacityPct])
			end
			assert(private.IsValidValue(opacityPct, 100))
			if opacityPct == 100 then
				return self
			end
			if not context.opacities[opacityPct] then
				assert(context.a == 255)
				local a = Math.Round(255 * opacityPct / 100)
				assert(private.IsValidValue(a, 255))
				context.opacities[opacityPct] = private.NewColorHelper(context.r, context.g, context.b, a)
			end
			return context.opacities[opacityPct]
		end,
		GetRGBA = function(self)
			local context = private.context[self]
			assert(context.hex)
			return context.r, context.g, context.b, context.a
		end,
		GetFractionalRGBA = function(self)
			local context = private.context[self]
			assert(context.hex)
			return context.r / 255, context.g / 255, context.b / 255, context.a / 255
		end,
		IsLight = function(self)
			local context = private.context[self]
			assert(context.hex)
			return context.l >= 50
		end,
		GetHex = function(self)
			local context = private.context[self]
			assert(context.hex)
			return context.hex
		end,
		ColorText = function(self, text)
			return self:GetTextColorPrefix()..text.."|r"
		end,
		GetTextColorPrefix = function(self)
			local context = private.context[self]
			assert(context.hex)
			return format("|c%02x%02x%02x%02x", context.a, context.r, context.g, context.b)
		end,
		Equals = function(self, other)
			return self:GetHex() == other:GetHex()
		end,
	},
	__newindex = function(self, key, value) error("Color cannot be modified") end,
	__metatable = false,
	__tostring = function(self)
		local context = private.context[self]
		return "Color:"..context.hex
	end,
}



-- ============================================================================
-- Module Loading
-- ============================================================================

Color:OnModuleLoad(function()
	private.transparent = private.NewColorHelper(0, 0, 0, 0)
	private.fullWhite = private.NewColorHelper(255, 255, 255, 255)
	private.fullBlack = private.NewColorHelper(0, 0, 0, 255)
end)



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Create a new color object from a hex string.
-- @tparam string hex The hex string which represents the color (in either "#AARRGGBB" or "#RRGGBB" format)
-- @treturn Color The color object
function Color.NewFromHex(hex)
	return private.NewColorHelper(private.HexToRGBA(hex))
end

--- Returns whether or not the argument is a color object.
-- @param arg The argument to check
-- @treturn boolean Whether or not the argument is a color object.
function Color.IsInstance(arg)
	return type(arg) == "table" and private.context[arg] and true or false
end

--- Gets a predefined fully-transparent color.
-- @treturn Color The color object
function Color.GetTransparent()
	return private.transparent
end

--- Gets a predefined fully-opaque white color.
-- @treturn Color The color object
function Color.GetFullWhite()
	return private.fullWhite
end

--- Gets a predefined fully-opaque black color.
-- @treturn Color The color object
function Color.GetFullBlack()
	return private.fullBlack
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.NewColorHelper(r, g, b, a)
	assert(private.IsValidValue(r, 255) and private.IsValidValue(g, 255) and private.IsValidValue(b, 255) and private.IsValidValue(a, 255))
	if a == 0 then
		assert(r == 0 and g == 0 and b == 0, "Invalid color with alpha of 0")
	end
	local context = {
		tints = {},
		opacities = {},
		r = r,
		g = g,
		b = b,
		a = a,
		h = nil,
		s = nil,
		l = nil,
		hex = private.RGBAToHex(r, g, b, a),
	}
	context.h, context.s, context.l = HSLuv.FromRGB(r, g, b)
	context.hex = private.RGBAToHex(r, g, b, a)
	local color = setmetatable({}, COLOR_MT)
	private.context[color] = context
	return color
end

function private.IsValidValue(value, maxValue)
	return type(value) == "number" and value >= 0 and value <= maxValue and value == floor(value)
end

function private.HexToRGBA(hex)
	local a, r, g, b = strmatch(strlower(hex), "^#([0-9a-f]?[0-9a-f]?)([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])$")
	return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16), tonumber(a ~= "" and a or "ff", 16)
end

function private.RGBAToHex(r, g, b, a)
	return format("#%02x%02x%02x%02x", Math.Round(a), Math.Round(r), Math.Round(g), Math.Round(b))
end
