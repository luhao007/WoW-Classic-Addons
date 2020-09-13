-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local TexturePacks = TSM.UI:NewPackage("TexturePacks")
local NineSlice = TSM.Include("Util.NineSlice")
local Color = TSM.Include("Util.Color")
local Theme = TSM.Include("Util.Theme")
local private = {
	colorLookup = {},
}
local TEXTURE_FILE_INFO = {
	uiFrames = {
		path = "Interface\\Addons\\TradeSkillMaster\\Media\\UIFrames.tga",
		scale = 1,
		width = 256,
		height = 256,
		coord = {
			["AuctionCounterTexture"] = { 166, 189, 214, 225 },
			["DividerHandle"] = { 3, 11, 3, 85 },
			["GlobalEdgeBottomEdge"] = { 68, 78, 217, 227 },
			["GlobalEdgeBottomLeftCorner"] = { 83, 93, 217, 227 },
			["GlobalEdgeBottomRightCorner"] = { 194, 204, 3, 13 },
			["GlobalEdgeLeftEdge"] = { 194, 204, 18, 28 },
			["GlobalEdgeRightEdge"] = { 243, 253, 3, 13 },
			["GlobalEdgeTopEdge"] = { 243, 253, 18, 28 },
			["GlobalEdgeTopLeftCorner"] = { 194, 204, 33, 43 },
			["GlobalEdgeTopRightCorner"] = { 243, 253, 33, 43 },
			["HighlightDot"] = { 97, 105, 48, 56 },
			["InnerFrameBottomEdge"] = { 110, 120, 87, 97 },
			["InnerFrameBottomLeftCorner"] = { 110, 120, 102, 112 },
			["InnerFrameBottomRightCorner"] = { 118, 128, 66, 76 },
			["InnerFrameLeftEdge"] = { 133, 143, 3, 13 },
			["InnerFrameRightEdge"] = { 148, 158, 3, 13 },
			["InnerFrameTopEdge"] = { 133, 143, 18, 28 },
			["InnerFrameTopLeftCorner"] = { 148, 158, 18, 28 },
			["InnerFrameTopRightCorner"] = { 67, 77, 33, 43 },
			["LargeActiveButtonLeft"] = { 14, 26, 90, 114 },
			["LargeActiveButtonMiddle"] = { 14, 26, 119, 143 },
			["LargeActiveButtonRight"] = { 16, 28, 3, 27 },
			["LargeClickedButtonLeft"] = { 16, 28, 32, 56 },
			["LargeClickedButtonMiddle"] = { 16, 28, 61, 85 },
			["LargeClickedButtonRight"] = { 31, 43, 90, 114 },
			["LargeHoverButtonLeft"] = { 31, 43, 119, 143 },
			["LargeHoverButtonMiddle"] = { 33, 45, 3, 27 },
			["LargeHoverButtonRight"] = { 33, 45, 32, 56 },
			["LargeInactiveButtonLeft"] = { 33, 45, 61, 85 },
			["LargeInactiveButtonMiddle"] = { 48, 60, 90, 114 },
			["LargeInactiveButtonRight"] = { 48, 60, 119, 143 },
			["LoadingBarLeft"] = { 50, 62, 3, 27 },
			["LoadingBarMiddle"] = { 50, 62, 32, 56 },
			["LoadingBarRight"] = { 50, 62, 61, 85 },
			["MediumActiveButtonLeft"] = { 3, 15, 232, 252 },
			["MediumActiveButtonMiddle"] = { 20, 32, 232, 252 },
			["MediumActiveButtonRight"] = { 37, 49, 232, 252 },
			["MediumClickedButtonLeft"] = { 54, 66, 232, 252 },
			["MediumClickedButtonMiddle"] = { 65, 77, 117, 137 },
			["MediumClickedButtonRight"] = { 65, 77, 142, 162 },
			["MediumHoverButtonLeft"] = { 68, 80, 167, 187 },
			["MediumHoverButtonMiddle"] = { 68, 80, 192, 212 },
			["MediumHoverButtonRight"] = { 71, 83, 232, 252 },
			["MediumInactiveButtonLeft"] = { 88, 100, 232, 252 },
			["MediumInactiveButtonMiddle"] = { 82, 94, 117, 137 },
			["MediumInactiveButtonRight"] = { 82, 94, 142, 162 },
			["OuterFrameBottomEdge"] = { 67, 77, 48, 58 },
			["OuterFrameBottomLeftCorner"] = { 67, 77, 3, 13 },
			["OuterFrameBottomRightCorner"] = { 67, 77, 18, 28 },
			["OuterFrameLeftEdge"] = { 82, 92, 33, 43 },
			["OuterFrameRightEdge"] = { 82, 92, 48, 58 },
			["OuterFrameTopEdge"] = { 82, 92, 3, 13 },
			["OuterFrameTopLeftCorner"] = { 82, 92, 18, 28 },
			["OuterFrameTopRightCorner"] = { 97, 107, 33, 43 },
			["PopupBottomEdge"] = { 14, 26, 148, 160 },
			["PopupBottomLeftCorner"] = { 31, 43, 148, 160 },
			["PopupBottomRightCorner"] = { 48, 60, 148, 160 },
			["PopupLeftEdge"] = { 98, 110, 214, 226 },
			["PopupRightEdge"] = { 115, 127, 214, 226 },
			["PopupTopEdge"] = { 132, 144, 214, 226 },
			["PopupTopLeftCorner"] = { 149, 161, 214, 226 },
			["PopupTopRightCorner"] = { 65, 105, 90, 112 },
			["RoundDarkBottom"] = { 110, 118, 48, 56 },
			["RoundDarkBottomLeft"] = { 112, 120, 33, 41 },
			["RoundDarkBottomRight"] = { 123, 131, 46, 54 },
			["RoundDarkCenter"] = { 125, 133, 33, 41 },
			["RoundDarkLeft"] = { 149, 156, 55, 62 },
			["RoundDarkRight"] = { 138, 146, 33, 41 },
			["RoundDarkTop"] = { 133, 140, 59, 66 },
			["RoundDarkTopLeft"] = { 209, 216, 45, 52 },
			["RoundDarkTopRight"] = { 151, 159, 33, 41 },
			["RoundedBottomCenter"] = { 183, 187, 3, 11 },
			["RoundedBottomLeft"] = { 97, 105, 3, 11 },
			["RoundedBottomRight"] = { 97, 105, 16, 24 },
			["RoundedCenter"] = { 110, 118, 3, 11 },
			["RoundedLeft"] = { 149, 157, 46, 50 },
			["RoundedRight"] = { 149, 157, 46, 50 },
			["RoundedTop"] = { 183, 187, 3, 11 },
			["RoundedTopLeft"] = { 110, 118, 16, 24 },
			["RoundedTopRight"] = { 136, 144, 46, 54 },
			["SettingsNavShadow"] = { 3, 9, 90, 162 },
			["SmallActiveButtonLeft"] = { 99, 111, 117, 133 },
			["SmallActiveButtonMiddle"] = { 99, 111, 138, 154 },
			["SmallActiveButtonRight"] = { 209, 221, 3, 19 },
			["SmallClickedButtonLeft"] = { 166, 178, 3, 19 },
			["SmallClickedButtonMiddle"] = { 166, 178, 24, 40 },
			["SmallClickedButtonRight"] = { 226, 238, 3, 19 },
			["SmallHoverButtonLeft"] = { 209, 221, 24, 40 },
			["SmallHoverButtonMiddle"] = { 226, 238, 24, 40 },
			["SmallHoverButtonRight"] = { 166, 178, 45, 61 },
			["SmallInactiveButtonLeft"] = { 67, 79, 66, 82 },
			["SmallInactiveButtonMiddle"] = { 84, 96, 66, 82 },
			["SmallInactiveButtonRight"] = { 101, 113, 66, 82 },
			["SmallLogo"] = { 85, 161, 167, 186 },
			["TSMLogo"] = { 3, 63, 167, 227 },
			["ToggleDisabledOff"] = { 85, 132, 191, 209 },
			["ToggleDisabledOn"] = { 105, 152, 231, 249 },
			["ToggleOff"] = { 137, 184, 191, 209 },
			["ToggleOn"] = { 157, 204, 231, 249 },
		},
	},
	iconPack = {
		path = "Interface\\Addons\\TradeSkillMaster\\Media\\IconPack.tga",
		scale = 1,
		width = 256,
		height = 256,
		coord = {
			["12x12/Add/Circle"] = { 236, 248, 88, 100 },
			["12x12/Add/Default"] = { 92, 104, 92, 104 },
			["12x12/Attention"] = { 106, 118, 92, 104 },
			["12x12/Bid"] = { 120, 132, 92, 104 },
			["12x12/Caret/Down"] = { 134, 146, 92, 104 },
			["12x12/Caret/Right"] = { 148, 160, 92, 104 },
			["12x12/Checkmark/Circle"] = { 162, 174, 92, 104 },
			["12x12/Checkmark/Default"] = { 176, 188, 92, 104 },
			["12x12/Chevron/Down"] = { 190, 202, 92, 104 },
			["12x12/Chevron/Right"] = { 204, 216, 92, 104 },
			["12x12/Chevron/Up"] = { 218, 230, 92, 104 },
			["12x12/Circle"] = { 232, 244, 102, 114 },
			["12x12/Clock"] = { 88, 100, 116, 128 },
			["12x12/Close/Circle"] = { 88, 100, 130, 142 },
			["12x12/Close/Default"] = { 88, 100, 144, 156 },
			["12x12/Configure"] = { 88, 100, 158, 170 },
			["12x12/Delete"] = { 88, 100, 172, 184 },
			["12x12/DragHandle"] = { 88, 100, 186, 198 },
			["12x12/Duplicate"] = { 88, 100, 200, 212 },
			["12x12/Edit"] = { 88, 100, 214, 226 },
			["12x12/Expand All"] = { 88, 100, 228, 240 },
			["12x12/Export"] = { 88, 100, 242, 254 },
			["12x12/Filter"] = { 102, 114, 106, 118 },
			["12x12/Folder"] = { 116, 128, 106, 118 },
			["12x12/Grip"] = { 130, 142, 106, 118 },
			["12x12/Groups"] = { 144, 156, 106, 118 },
			["12x12/Hide"] = { 158, 170, 106, 118 },
			["12x12/Import"] = { 172, 184, 106, 118 },
			["12x12/Link"] = { 186, 198, 106, 118 },
			["12x12/Mailing"] = { 200, 212, 106, 118 },
			["12x12/More/Horizontal"] = { 214, 226, 106, 118 },
			["12x12/More/Vertical"] = { 228, 240, 116, 128 },
			["12x12/Operation"] = { 242, 254, 116, 128 },
			["12x12/PlayPause"] = { 102, 114, 120, 132 },
			["12x12/Popout"] = { 116, 128, 120, 132 },
			["12x12/Post"] = { 130, 142, 120, 132 },
			["12x12/Queue"] = { 144, 156, 120, 132 },
			["12x12/Reset"] = { 158, 170, 120, 132 },
			["12x12/Resize"] = { 172, 184, 120, 132 },
			["12x12/Running"] = { 186, 198, 120, 132 },
			["12x12/SaleRate"] = { 200, 212, 120, 132 },
			["12x12/Search"] = { 214, 226, 120, 132 },
			["12x12/Select All"] = { 228, 240, 130, 142 },
			["12x12/Shopping"] = { 242, 254, 130, 142 },
			["12x12/SkillUp"] = { 102, 114, 144, 156 },
			["12x12/Star/Filled"] = { 102, 114, 158, 170 },
			["12x12/Star/Unfilled"] = { 102, 114, 172, 184 },
			["12x12/Subtract/Circle"] = { 102, 114, 186, 198 },
			["12x12/Subtract/Default"] = { 102, 114, 200, 212 },
			["12x12/Visible"] = { 102, 114, 214, 226 },
			["12x12/WoW"] = { 102, 114, 228, 240 },
			["14x14/Add/Circle"] = { 240, 254, 56, 70 },
			["14x14/Add/Default"] = { 40, 54, 112, 126 },
			["14x14/Attention"] = { 40, 54, 128, 142 },
			["14x14/Bid"] = { 40, 54, 144, 158 },
			["14x14/Caret/Down"] = { 40, 54, 160, 174 },
			["14x14/Caret/Right"] = { 40, 54, 176, 190 },
			["14x14/Checkmark/Circle"] = { 40, 54, 192, 206 },
			["14x14/Checkmark/Default"] = { 40, 54, 208, 222 },
			["14x14/Chevron/Down"] = { 40, 54, 224, 238 },
			["14x14/Chevron/Right"] = { 40, 54, 240, 254 },
			["14x14/Chevron/Up"] = { 56, 70, 112, 126 },
			["14x14/Circle"] = { 60, 74, 72, 86 },
			["14x14/Clock"] = { 60, 74, 88, 102 },
			["14x14/Close/Circle"] = { 56, 70, 128, 142 },
			["14x14/Close/Default"] = { 56, 70, 144, 158 },
			["14x14/Configure"] = { 56, 70, 160, 174 },
			["14x14/Delete"] = { 56, 70, 176, 190 },
			["14x14/DragHandle"] = { 56, 70, 192, 206 },
			["14x14/Duplicate"] = { 56, 70, 208, 222 },
			["14x14/Edit"] = { 56, 70, 224, 238 },
			["14x14/Expand All"] = { 56, 70, 240, 254 },
			["14x14/Export"] = { 72, 86, 104, 118 },
			["14x14/Filter"] = { 76, 90, 72, 86 },
			["14x14/Folder"] = { 76, 90, 88, 102 },
			["14x14/Grip"] = { 72, 86, 120, 134 },
			["14x14/Groups"] = { 72, 86, 136, 150 },
			["14x14/Hide"] = { 72, 86, 152, 166 },
			["14x14/Import"] = { 72, 86, 168, 182 },
			["14x14/Link"] = { 72, 86, 184, 198 },
			["14x14/Mailing"] = { 72, 86, 200, 214 },
			["14x14/More/Horizontal"] = { 72, 86, 216, 230 },
			["14x14/More/Vertical"] = { 72, 86, 232, 246 },
			["14x14/Operation"] = { 92, 106, 60, 74 },
			["14x14/PlayPause"] = { 108, 122, 60, 74 },
			["14x14/Popout"] = { 124, 138, 60, 74 },
			["14x14/Post"] = { 140, 154, 60, 74 },
			["14x14/Queue"] = { 156, 170, 60, 74 },
			["14x14/Reset"] = { 172, 186, 60, 74 },
			["14x14/Resize"] = { 188, 202, 60, 74 },
			["14x14/Running"] = { 204, 218, 60, 74 },
			["14x14/SaleRate"] = { 220, 234, 60, 74 },
			["14x14/Search"] = { 236, 250, 72, 86 },
			["14x14/Select All"] = { 92, 106, 76, 90 },
			["14x14/Shopping"] = { 108, 122, 76, 90 },
			["14x14/SkillUp"] = { 124, 138, 76, 90 },
			["14x14/Star/Filled"] = { 140, 154, 76, 90 },
			["14x14/Star/Unfilled"] = { 156, 170, 76, 90 },
			["14x14/Subtract/Circle"] = { 172, 186, 76, 90 },
			["14x14/Subtract/Default"] = { 188, 202, 76, 90 },
			["14x14/Visible"] = { 204, 218, 76, 90 },
			["14x14/WoW"] = { 220, 234, 76, 90 },
			["18x18/Add/Circle"] = { 0, 18, 26, 44 },
			["18x18/Add/Default"] = { 0, 18, 46, 64 },
			["18x18/Attention"] = { 0, 18, 66, 84 },
			["18x18/Bid"] = { 0, 18, 86, 104 },
			["18x18/Caret/Down"] = { 0, 18, 106, 124 },
			["18x18/Caret/Right"] = { 0, 18, 126, 144 },
			["18x18/Checkmark/Circle"] = { 0, 18, 146, 164 },
			["18x18/Checkmark/Default"] = { 0, 18, 166, 184 },
			["18x18/Chevron/Down"] = { 0, 18, 186, 204 },
			["18x18/Chevron/Right"] = { 0, 18, 206, 224 },
			["18x18/Chevron/Up"] = { 0, 18, 226, 244 },
			["18x18/Circle"] = { 20, 38, 26, 44 },
			["18x18/Clock"] = { 26, 44, 0, 18 },
			["18x18/Close/Circle"] = { 20, 38, 46, 64 },
			["18x18/Close/Default"] = { 20, 38, 66, 84 },
			["18x18/Configure"] = { 20, 38, 86, 104 },
			["18x18/Delete"] = { 20, 38, 106, 124 },
			["18x18/DragHandle"] = { 20, 38, 126, 144 },
			["18x18/Duplicate"] = { 20, 38, 146, 164 },
			["18x18/Edit"] = { 20, 38, 166, 184 },
			["18x18/Expand All"] = { 20, 38, 186, 204 },
			["18x18/Export"] = { 20, 38, 206, 224 },
			["18x18/Filter"] = { 20, 38, 226, 244 },
			["18x18/Folder"] = { 46, 64, 0, 18 },
			["18x18/Grip"] = { 66, 84, 0, 18 },
			["18x18/Groups"] = { 86, 104, 0, 18 },
			["18x18/Hide"] = { 106, 124, 0, 18 },
			["18x18/Import"] = { 126, 144, 0, 18 },
			["18x18/Link"] = { 146, 164, 0, 18 },
			["18x18/Mailing"] = { 166, 184, 0, 18 },
			["18x18/More/Horizontal"] = { 186, 204, 0, 18 },
			["18x18/More/Vertical"] = { 206, 224, 0, 18 },
			["18x18/Operation"] = { 226, 244, 0, 18 },
			["18x18/PlayPause"] = { 40, 58, 20, 38 },
			["18x18/Popout"] = { 60, 78, 20, 38 },
			["18x18/Post"] = { 80, 98, 20, 38 },
			["18x18/Queue"] = { 100, 118, 20, 38 },
			["18x18/Reset"] = { 120, 138, 20, 38 },
			["18x18/Resize"] = { 140, 158, 20, 38 },
			["18x18/Running"] = { 160, 178, 20, 38 },
			["18x18/SaleRate"] = { 180, 198, 20, 38 },
			["18x18/Search"] = { 200, 218, 20, 38 },
			["18x18/Select All"] = { 220, 238, 20, 38 },
			["18x18/Shopping"] = { 40, 58, 40, 58 },
			["18x18/SkillUp"] = { 60, 78, 40, 58 },
			["18x18/Star/Filled"] = { 80, 98, 40, 58 },
			["18x18/Star/Unfilled"] = { 100, 118, 40, 58 },
			["18x18/Subtract/Circle"] = { 120, 138, 40, 58 },
			["18x18/Subtract/Default"] = { 140, 158, 40, 58 },
			["18x18/Visible"] = { 160, 178, 40, 58 },
			["18x18/WoW"] = { 180, 198, 40, 58 },
			["24x24/Close/Default"] = { 0, 24, 0, 24 },
			["Misc/Checkbox/Checked"] = { 200, 218, 40, 58 },
			["Misc/Checkbox/Unchecked"] = { 220, 238, 40, 58 },
			["Misc/Crafting"] = { 240, 256, 20, 36 },
			["Misc/Normal Search"] = { 240, 256, 38, 54 },
			["Misc/Radio/Checked"] = { 40, 58, 72, 90 },
			["Misc/Radio/Unchecked"] = { 40, 58, 92, 110 },
		},
	},
}
local NINE_SLICE_STYLES = {
	rounded = {
		topLeft = "uiFrames.RoundedTopLeft",
		bottomLeft = "uiFrames.RoundedBottomLeft",
		topRight = "uiFrames.RoundedTopRight",
		bottomRight = "uiFrames.RoundedBottomRight",
		left = "uiFrames.RoundedLeft",
		right = "uiFrames.RoundedRight",
		top = "uiFrames.RoundedTop",
		bottom = "uiFrames.RoundedBottomCenter",
		center = "uiFrames.RoundedCenter",
	},
	global = {
		topLeft = "uiFrames.GlobalEdgeTopLeftCorner",
		bottomLeft = "uiFrames.GlobalEdgeBottomLeftCorner",
		topRight = "uiFrames.GlobalEdgeTopRightCorner",
		bottomRight = "uiFrames.GlobalEdgeBottomRightCorner",
		left = "uiFrames.GlobalEdgeLeftEdge",
		right = "uiFrames.GlobalEdgeRightEdge",
		top = "uiFrames.GlobalEdgeTopEdge",
		bottom = "uiFrames.GlobalEdgeBottomEdge",
		center = nil,
	},
	outerFrame = {
		topLeft = "uiFrames.OuterFrameTopLeftCorner",
		bottomLeft = "uiFrames.OuterFrameBottomLeftCorner",
		topRight = "uiFrames.OuterFrameTopRightCorner",
		bottomRight = "uiFrames.OuterFrameBottomRightCorner",
		left = "uiFrames.OuterFrameLeftEdge",
		right = "uiFrames.OuterFrameRightEdge",
		top = "uiFrames.OuterFrameTopEdge",
		bottom = "uiFrames.OuterFrameBottomEdge",
		center = "__WHITE",
	},
	popup = {
		topLeft = "uiFrames.PopupTopLeftCorner",
		bottomLeft = "uiFrames.PopupBottomLeftCorner",
		topRight = "uiFrames.PopupTopRightCorner",
		bottomRight = "uiFrames.PopupBottomRightCorner",
		left = "uiFrames.PopupLeftEdge",
		right = "uiFrames.PopupRightEdge",
		top = "uiFrames.PopupTopEdge",
		bottom = "uiFrames.PopupBottomEdge",
		center = "__WHITE",
	},
	solid = {
		topLeft = "__WHITE",
		bottomLeft = "__WHITE",
		topRight = "__WHITE",
		bottomRight = "__WHITE",
		left = "__WHITE",
		right = "__WHITE",
		top = "__WHITE",
		bottom = "__WHITE",
		center = "__WHITE",
	}
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function TexturePacks.OnInitialize()
	for _, info in pairs(NINE_SLICE_STYLES) do
		-- extract the texture info
		for part, texturePack in pairs(info) do
			if texturePack == "__WHITE" then
				info[part] = {
					texture = "Interface\\Buttons\\WHITE8X8",
					coord = { 0, 1, 0, 1 },
					width = 8,
					height = 8,
				}
			else
				local width, height = TexturePacks.GetSize(texturePack)
				local fileInfo, coord, color, angle = private.SplitTexturePath(texturePack)
				assert(not color and not angle)
				info[part] = {
					texture = fileInfo.path,
					coord = { private.GetTexCoord(fileInfo, coord) },
					width = width,
					height = height,
				}
			end
		end
	end

	-- apply an offset to the topRight part of the popup style so it shows correctly
	NINE_SLICE_STYLES.popup.topRight.offset = {
		{ 0, 10 },
	}

	for key, info in pairs(NINE_SLICE_STYLES) do
		NineSlice.RegisterStyle(key, info)
	end
end

function TexturePacks.IsValid(key)
	local fileInfo, coord = private.SplitTexturePath(key)
	return fileInfo and coord and true or false
end

function TexturePacks.GetSize(key)
	local fileInfo, coord = private.SplitTexturePath(key)
	assert(fileInfo and coord)
	local minX, maxX, minY, maxY = unpack(coord)
	local width = (maxX - minX) / fileInfo.scale
	local height = (maxY - minY) / fileInfo.scale
	return width, height
end

function TexturePacks.GetWidth(key)
	local width = TexturePacks.GetSize(key)
	return width
end

function TexturePacks.GetHeight(key)
	local _, height = TexturePacks.GetSize(key)
	return height
end

function TexturePacks.SetTexture(texture, key)
	local fileInfo, coord, color, angle = private.SplitTexturePath(key)
	texture:SetTexture(fileInfo.path)
	if angle then
		texture:SetTexCoord(private.GetTexCoordRotated(fileInfo, coord, angle))
	else
		texture:SetTexCoord(private.GetTexCoord(fileInfo, coord))
	end
	if color then
		texture:SetVertexColor((private.colorLookup[color] or Theme.GetColor(color)):GetFractionalRGBA())
	else
		texture:SetVertexColor(1, 1, 1, 1)
	end
end

function TexturePacks.SetSize(texture, key)
	local width, height = TexturePacks.GetSize(key)
	texture:SetWidth(width)
	texture:SetHeight(height)
end

function TexturePacks.SetWidth(texture, key)
	texture:SetWidth(TexturePacks.GetWidth(key))
end

function TexturePacks.SetHeight(texture, key)
	texture:SetHeight(TexturePacks.GetHeight(key))
end

function TexturePacks.SetTextureAndWidth(texture, key)
	TexturePacks.SetTexture(texture, key)
	TexturePacks.SetWidth(texture, key)
end

function TexturePacks.SetTextureAndHeight(texture, key)
	TexturePacks.SetTexture(texture, key)
	TexturePacks.SetHeight(texture, key)
end

function TexturePacks.SetTextureAndSize(texture, key)
	TexturePacks.SetTexture(texture, key)
	TexturePacks.SetSize(texture, key)
end

function TexturePacks.GetTextureLink(key)
	local width, height = TexturePacks.GetSize(key)
	local fileInfo, coord, color = private.SplitTexturePath(key)
	assert(fileInfo and coord)
	local minX, maxX, minY, maxY = unpack(coord)
	local r, g, b, a = 255, 255, 255, 255
	if color then
		r, g, b, a = (private.colorLookup[color] or Theme.GetColor(color)):GetRGBA()
	end
	assert(a == 255)
	return "|T"..strjoin(":", fileInfo.path, width, height, 0, 0, fileInfo.width, fileInfo.height, minX, maxX, minY, maxY, r, g, b).."|t"
end

function TexturePacks.GetColoredKey(key, color)
	local fileInfo, _, existingColor = private.SplitTexturePath(key)
	assert(fileInfo and not existingColor)
	if type(color) == "string" then
		-- this is a theme color key, so just add it on
		return key.."#"..color
	elseif color:Equals(Color.GetFullWhite()) then
		return key
	end
	assert(not color:Equals(Color.GetTransparent()))
	local hex = color:GetHex()
	private.colorLookup[hex] = color
	return key..hex
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SplitTexturePath(key)
	local file, entry, color, angle, color2 = strmatch(key, "^([^%.]+)%.([^#@]+)(#?[0-9a-fA-Z_]*)@?([0-9]*)(#?[0-9a-fA-Z_]*)$")
	color = (color ~= "" and color) or (color2 ~= "" and color2) or nil
	angle = angle ~= "" and tonumber(angle) or nil
	local fileInfo = file and TEXTURE_FILE_INFO[file]
	if color and not strmatch(color, "^#[0-9a-fA-F]+$") then
		-- remove the leading '#' from theme color keys
		color = strsub(color, 2)
	end
	return fileInfo, fileInfo and fileInfo.coord[entry], color, angle
end

function private.GetTexCoord(fileInfo, coord)
	local minX, maxX, minY, maxY = unpack(coord)
	minX = minX / fileInfo.width
	maxX = maxX / fileInfo.width
	minY = minY / fileInfo.height
	maxY = maxY / fileInfo.height
	return minX, maxX, minY, maxY
end

function private.GetTexCoordRotated(fileInfo, coord, angle)
	local minX, maxX, minY, maxY = private.GetTexCoord(fileInfo, coord)
	local aspect = fileInfo.width / fileInfo.height
	local centerX = (minX + maxX) / 2
	local centerY = (minY + maxY) / 2
	local ULx, ULy = private.RotateCoordPair(minX, minY, centerX, centerY, angle, aspect)
	local LLx, LLy = private.RotateCoordPair(minX, maxY, centerX, centerY, angle, aspect)
	local URx, URy = private.RotateCoordPair(maxX, minY, centerX, centerY, angle, aspect)
	local LRx, LRy = private.RotateCoordPair(maxX, maxY, centerX, centerY, angle, aspect)
	return ULx, ULy, LLx, LLy, URx, URy, LRx, LRy
end

function private.RotateCoordPair(x, y, originX, originY, angle, aspect)
	local cosResult = cos(angle)
	local sinResult = sin(angle)
	y = y / aspect
	originY = originY / aspect
	local resultX = originX + (x - originX) * cosResult - (y - originY) * sinResult
	local resultY = (originY + (y - originY) * cosResult + (x - originX) * sinResult) * aspect
	return resultX, resultY
end
