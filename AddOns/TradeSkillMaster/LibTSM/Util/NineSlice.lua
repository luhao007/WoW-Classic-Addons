-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- NineSlice Functions.
-- @module NineSlice

local _, TSM = ...
local NineSlice = TSM.Init("Util.NineSlice")
local private = {
	styles = {},
	context = {},
}
local PART_INFO = {
	topLeft = {
		points = {
			{ "TOPLEFT" },
		},
	},
	bottomLeft = {
		points = {
			{ "BOTTOMLEFT" },
		},
	},
	topRight = {
		points = {
			{ "TOPRIGHT" },
		},
	},
	bottomRight = {
		points = {
			{ "BOTTOMRIGHT" },
		},
	},
	left = {
		points = {
			{ "TOPLEFT", "topLeft", "BOTTOMLEFT" },
			{ "BOTTOMLEFT", "bottomLeft", "TOPLEFT" },
		},
	},
	right = {
		points = {
			{ "TOPRIGHT", "topRight", "BOTTOMRIGHT" },
			{ "BOTTOMRIGHT", "bottomRight", "TOPRIGHT" },
		},
	},
	top = {
		points = {
			{ "TOPLEFT", "topLeft", "TOPRIGHT" },
			{ "TOPRIGHT", "topRight", "TOPLEFT" },
		},
	},
	bottom = {
		points = {
			{ "BOTTOMLEFT", "bottomLeft", "BOTTOMRIGHT" },
			{ "BOTTOMRIGHT", "bottomRight", "BOTTOMLEFT" },
		},
	},
	center = {
		points = {
			{ "TOPLEFT", "topLeft", "BOTTOMRIGHT" },
			{ "BOTTOMRIGHT", "bottomRight", "TOPLEFT" },
		},
	},
}



-- ============================================================================
-- Metatable
-- ============================================================================

local NINE_SLICE_MT = {
	__index = {
		Hide = function(self)
			local context = private.context[self]
			for _, texture in pairs(context.parts) do
				texture:Hide()
			end
		end,
		SetStyle = function(self, key, inset)
			local context = private.context[self]
			local style = private.styles[key]
			for part, texture in pairs(context.parts) do
				local partStyle = style[part]
				if partStyle then
					texture:Show()
				else
					texture:Hide()
				end
			end
			if context.styleKey == key and context.inset == inset then
				return
			end
			context.styleKey = key
			context.inset = inset
			for part, texture in pairs(context.parts) do
				local partStyle = style[part]
				if partStyle then
					texture:ClearAllPoints()
					for i, point in ipairs(PART_INFO[part].points) do
						local anchor, relFrame, relAnchor, xOff, yOff = nil, nil, nil, 0, 0
						if partStyle.offset then
							xOff, yOff = unpack(partStyle.offset[i])
						end
						if #point == 1 then
							anchor = unpack(point)
						elseif #point == 3 then
							anchor, relFrame, relAnchor = unpack(point)
							relFrame = context.parts[relFrame]
							assert(relFrame)
						else
							error("Invalid point")
						end
						if relFrame then
							texture:SetPoint(anchor, relFrame, relAnchor, xOff, yOff)
						else
							if inset and xOff == 0 and strmatch(anchor, "LEFT") then
								xOff = inset
							elseif inset and xOff == 0 and strmatch(anchor, "RIGHT") then
								xOff = -inset
							end
							if inset and yOff == 0 and strmatch(anchor, "TOP") then
								yOff = -inset
							elseif inset and yOff == 0 and strmatch(anchor, "BOTTOM") then
								yOff = inset
							end
							texture:SetPoint(anchor, xOff, yOff)
						end
					end
					texture:SetSize(partStyle.width, partStyle.height)
					texture:SetTexture(partStyle.texture)
					texture:SetTexCoord(unpack(partStyle.coord))
				end
			end
		end,
		SetVertexColor = function(self, r, g, b, a)
			for part in pairs(PART_INFO) do
				self:SetPartVertexColor(part, r, g, b, a)
			end
		end,
		SetPartVertexColor = function(self, part, r, g, b, a)
			local context = private.context[self]
			context.parts[part]:SetVertexColor(r, g, b, a)
		end,
	},
	__newindex = function(self, key, value) error("NineSlice cannot be modified") end,
	__tostring = function(self) return "NineSlice:"..strmatch(tostring(private.context[self]), "table:[^0-9a-fA-F]*([0-9a-fA-F]+)") end,
	__metatable = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Registers a nine-slice style.
-- @tparam string key The style key
-- @tparam table info The style info table
function NineSlice.RegisterStyle(key, info)
	assert(not private.styles[key])
	private.styles[key] = info
	for part in pairs(PART_INFO) do
		-- allowed to be missing the center part
		if part ~= "center" or info[part] ~= nil then
			assert(type(info[part].texture) == "string")
			assert(#info[part].coord == 4)
			assert(info[part].width > 0)
			assert(info[part].height > 0)
		end
	end
end

--- Create an nine-slice object.
-- @tparam table frame The parent frame
-- @tparam[opt=0] number subLayer The texture subLayer
-- @treturn NineSlice The nine-slice object
function NineSlice.New(frame, subLayer)
	local obj = setmetatable({}, NINE_SLICE_MT)
	local context = {
		frame = frame,
		parts = {},
		styleKey = nil,
		inset = nil,
	}
	private.context[obj] = context

	-- create all the textures
	for part in pairs(PART_INFO) do
		local texture = frame:CreateTexture(nil, "BACKGROUND", nil, subLayer or 0)
		texture:SetBlendMode("BLEND")
		context.parts[part] = texture
	end

	-- set the points for all the textures
	for part, info in pairs(PART_INFO) do
		for _, point in ipairs(info.points) do
			if #point == 1 then
				context.parts[part]:SetPoint(unpack(point))
			elseif #point == 3 then
				local anchor, relFrame, relAnchor = unpack(point)
				relFrame = context.parts[relFrame]
				assert(relFrame)
				context.parts[part]:SetPoint(anchor, relFrame, relAnchor)
			else
				error("Invalid point")
			end
		end
	end

	return obj
end
