-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Frame UI Element Class.
-- A frame is a container which supports automated layout of its children. It also supports being the base element of a UI and anchoring/parenting directly to a WoW frame. It is a subclass of the @{Container} class.
-- @classmod Frame

local _, TSM = ...
local TempTable = TSM.Include("Util.TempTable")
local Table = TSM.Include("Util.Table")
local Color = TSM.Include("Util.Color")
local Theme = TSM.Include("Util.Theme")
local NineSlice = TSM.Include("Util.NineSlice")
local VALID_LAYOUTS = {
	NONE = true,
	HORIZONTAL = true,
	VERTICAL = true,
	FLOW = true,
}
local LAYOUT_CONTEXT = {
	VERTICAL = {
		primaryDimension = "HEIGHT",
		secondaryDimension = "WIDTH",
		sides = { primary = { "TOP", "BOTTOM" }, secondary = { "LEFT", "RIGHT" } },
	},
	HORIZONTAL = {
		primaryDimension = "WIDTH",
		secondaryDimension = "HEIGHT",
		sides = { primary = { "LEFT", "RIGHT" }, secondary = { "TOP", "BOTTOM" } },
	},
}
local Frame = TSM.Include("LibTSMClass").DefineClass("Frame", TSM.UI.Container)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(Frame)
TSM.UI.Frame = Frame



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Frame.__init(self)
	local frame = UIElements.CreateFrame(self, "Frame")

	self.__super:__init(frame)

	self._borderNineSlice = NineSlice.New(frame)
	self._borderNineSlice:Hide()

	self._backgroundNineSlice = NineSlice.New(frame, 1)
	self._backgroundNineSlice:Hide()

	self._layout = "NONE"
	self._backgroundColor = nil
	self._roundedCorners = false
	self._borderColor = nil
	self._borderSize = nil
	self._expandWidth = false
	self._strata = nil
	self._scale = 1
end

function Frame.Release(self)
	self._layout = "NONE"
	self._backgroundColor = nil
	self._roundedCorners = false
	self._borderColor = nil
	self._borderSize = nil
	self._expandWidth = false
	self._strata = nil
	self._scale = 1
	self._borderNineSlice:Hide()
	self._backgroundNineSlice:Hide()
	local frame = self:_GetBaseFrame()
	frame:RegisterForDrag(nil)
	frame:EnableMouse(false)
	frame:SetMovable(false)
	frame:EnableMouseWheel(false)
	frame:SetHitRectInsets(0, 0, 0, 0)
	self.__super:Release()
end

--- Sets the background of the frame.
-- @tparam Frame self The frame object
-- @tparam ?string|Color|nil color The background color as a theme color key, Color object, or nil
-- @tparam[opt=false] boolean roundedCorners Whether or not the corners should be rounded
-- @treturn Frame The frame object
function Frame.SetBackgroundColor(self, color, roundedCorners)
	assert(color == nil or Color.IsInstance(color) or Theme.GetColor(color))
	self._backgroundColor = color
	self._roundedCorners = roundedCorners
	return self
end

--- Sets the border color of the frame.
-- @tparam Frame self The frame object
-- @tparam ?string|nil color The border color as a theme color key or nil
-- @tparam[opt=1] ?number borderSize The border size
-- @treturn Frame The frame object
function Frame.SetBorderColor(self, color, borderSize)
	assert(color == nil or Color.IsInstance(color) or Theme.GetColor(color))
	self._borderColor = color
	self._borderSize = borderSize or 1
	return self
end

--- Sets the width of the frame.
-- @tparam Frame self The frame object
-- @tparam ?number|string width The width of the frame, "EXPAND" to set the width to expand to be
-- as large as possible, or nil to have an undefined width
-- @treturn Frame The frame object
function Frame.SetWidth(self, width)
	if width == "EXPAND" then
		self._expandWidth = true
	else
		self.__super:SetWidth(width)
	end
	return self
end

--- Sets the parent frame.
-- @tparam Frame self The frame object
-- @tparam frame parent The WoW frame to parent to
-- @treturn Frame The frame object
function Frame.SetParent(self, parent)
	self:_GetBaseFrame():SetParent(parent)
	return self
end

--- Sets the level of the frame.
-- @tparam Frame self The frame object
-- @tparam number level The frame level
-- @treturn Frame The frame object
function Frame.SetFrameLevel(self, level)
	self:_GetBaseFrame():SetFrameLevel(level)
	return self
end

--- Sets the strata of the frame.
-- @tparam Frame self The frame object
-- @tparam string strata The frame strata
-- @treturn Frame The frame object
function Frame.SetStrata(self, strata)
	self._strata = strata
	return self
end

--- Sets the scale of the frame.
-- @tparam Frame self The frame object
-- @tparam string scale The frame scale
-- @treturn Frame The frame object
function Frame.SetScale(self, scale)
	self._scale = scale
	return self
end

--- Sets the layout of the frame.
-- @tparam Frame self The frame object
-- @tparam string layout The frame layout (`NONE`, `HORIZONTAL`, `VERTICAL`, or `FLOW`)
-- @treturn Frame The frame object
function Frame.SetLayout(self, layout)
	assert(VALID_LAYOUTS[layout], format("Invalid layout (%s)", tostring(layout)))
	self._layout = layout
	return self
end

--- Sets whether mouse interaction is enabled.
-- @tparam Frame self The frame object
-- @tparam boolean enabled Whether mouse interaction is enabled
-- @treturn Frame The frame object
function Frame.SetMouseEnabled(self, enabled)
	self:_GetBaseFrame():EnableMouse(enabled)
	return self
end

--- Sets whether mouse wheel interaction is enabled.
-- @tparam Frame self The frame object
-- @tparam boolean enabled Whether mouse wheel interaction is enabled
-- @treturn Frame The frame object
function Frame.SetMouseWheelEnabled(self, enabled)
	self:_GetBaseFrame():EnableMouseWheel(enabled)
	return self
end

--- Allows dragging of the frame.
-- @tparam Frame self The frame object
-- @tparam string button The button to support dragging with
-- @treturn Frame The frame object
function Frame.RegisterForDrag(self, button)
	self:SetMouseEnabled(button and true or false)
	self:_GetBaseFrame():RegisterForDrag(button)
	return self
end

--- Gets whether the mouse is currently over the frame.
-- @tparam Frame self The frame object
-- @treturn boolean Whether or not the mouse is over the frame
function Frame.IsMouseOver(self)
	return self:_GetBaseFrame():IsMouseOver()
end

--- Sets the hit rectangle insets.
-- @tparam Frame self The frame object
-- @tparam number left The left hit rectangle inset
-- @tparam number right The right hit rectangle inset
-- @tparam number top The top hit rectangle inset
-- @tparam number bottom The bottom hit rectangle inset
-- @treturn Frame The frame object
function Frame.SetHitRectInsets(self, left, right, top, bottom)
	self:_GetBaseFrame():SetHitRectInsets(left, right, top, bottom)
	return self
end

--- Makes the element movable and starts moving it.
-- @tparam Frame self The element object
function Frame.StartMoving(self)
	self:_GetBaseFrame():SetMovable(true)
	self:_GetBaseFrame():StartMoving()
	return self
end

--- Stops moving the element, and makes it unmovable.
-- @tparam Frame self The element object
function Frame.StopMovingOrSizing(self)
	self:_GetBaseFrame():StopMovingOrSizing()
	self:_GetBaseFrame():SetMovable(false)
	return self
end

function Frame.Draw(self)
	local layout = self._layout
	self.__super.__super:Draw()
	local frame = self:_GetBaseFrame()

	if self._backgroundColor then
		self._backgroundNineSlice:SetStyle(self._roundedCorners and "rounded" or "solid", self._borderColor and self._borderSize or nil)
		local color = Color.IsInstance(self._backgroundColor) and self._backgroundColor or Theme.GetColor(self._backgroundColor)
		self._backgroundNineSlice:SetVertexColor(color:GetFractionalRGBA())
	else
		assert(not self._borderColor)
		self._backgroundNineSlice:Hide()
	end
	if self._borderColor then
		assert(self._backgroundColor)
		self._borderNineSlice:SetStyle(self._roundedCorners and "rounded" or "solid")
		local color = Color.IsInstance(self._borderColor) and self._borderColor or Theme.GetColor(self._borderColor)
		self._borderNineSlice:SetVertexColor(color:GetFractionalRGBA())
	else
		self._borderNineSlice:Hide()
	end

	frame:SetScale(self._scale)

	local strata = self._strata
	if strata then
		frame:SetFrameStrata(strata)
	end

	if layout == "NONE" then
		-- pass
	elseif layout == "FLOW" then
		local width = self:_GetDimension("WIDTH")
		local height = self:_GetDimension("HEIGHT") - self:_GetPadding("TOP") - self:_GetPadding("BOTTOM")
		local rowHeight = 0
		for _, child in self:LayoutChildrenIterator() do
			child:_GetBaseFrame():ClearAllPoints()
			local childPrimary = child:_GetMinimumDimension("WIDTH")
			child:_SetDimension("WIDTH", childPrimary)
			local childSecondary = child:_GetMinimumDimension("HEIGHT")
			rowHeight = childSecondary + child:_GetMargin("BOTTOM") + child:_GetMargin("TOP")
			child:_SetDimension("HEIGHT", childSecondary)
		end
		local xOffset = self:_GetPadding("LEFT")
		-- calculate the Y offset to properly position stuff with the padding of this frame taken into account
		local yOffset = -self:_GetPadding("TOP")
		for _, child in self:LayoutChildrenIterator() do
			local childFrame = child:_GetBaseFrame()
			local childWidth = childFrame:GetWidth() + child:_GetMargin("LEFT") + child:_GetMargin("RIGHT")
			if xOffset + childWidth + self:_GetPadding("RIGHT") > width then
				-- move to the next row
				xOffset = self:_GetPadding("LEFT")
				yOffset = yOffset - rowHeight
			end
			local childYOffset = yOffset + (height - childFrame:GetHeight()) / 2 - child:_GetMargin("TOP")
			childFrame:SetPoint("LEFT", xOffset + child:_GetMargin("LEFT"), childYOffset)
			xOffset = xOffset + childWidth
		end
	else
		local context = LAYOUT_CONTEXT[layout]
		assert(context)
		local primary = self:_GetDimension(context.primaryDimension) - self:_GetPadding(context.sides.primary[1]) - self:_GetPadding(context.sides.primary[2])
		local secondary = self:_GetDimension(context.secondaryDimension) - self:_GetPadding(context.sides.secondary[1]) - self:_GetPadding(context.sides.secondary[2])

		local expandChildren = TempTable.Acquire()
		local preferredChildren = TempTable.Acquire()
		for _, child in self:LayoutChildrenIterator() do
			child:_GetBaseFrame():ClearAllPoints()
			local childPrimary, childPrimaryCanExpand = child:_GetMinimumDimension(context.primaryDimension)
			if childPrimaryCanExpand then
				local childPreferredPrimary = child:_GetPreferredDimension(context.primaryDimension)
				if childPreferredPrimary then
					assert(childPreferredPrimary > childPrimary, "Invalid preferred dimension")
					preferredChildren[child] = childPreferredPrimary
				else
					expandChildren[child] = childPrimary
				end
			else
				child:_SetDimension(context.primaryDimension, childPrimary)
			end
			primary = primary - childPrimary - child:_GetMargin(context.sides.primary[1]) - child:_GetMargin(context.sides.primary[2])
			local childSecondary, childSecondaryCanExpand = child:_GetMinimumDimension(context.secondaryDimension)
			childSecondary = min(childSecondary, secondary)
			if childSecondaryCanExpand and childSecondary < secondary then
				childSecondary = secondary
			end
			child:_SetDimension(context.secondaryDimension, childSecondary - child:_GetMargin(context.sides.secondary[1]) - child:_GetMargin(context.sides.secondary[2]))
		end
		for child, preferredPrimary in pairs(preferredChildren) do
			local childPrimary = min(primary, preferredPrimary)
			child:_SetDimension(context.primaryDimension, childPrimary)
			primary = primary - (childPrimary - child:_GetMinimumDimension(context.primaryDimension))
		end
		local numExpandChildren = Table.Count(expandChildren)
		for child, childPrimary in pairs(expandChildren) do
			childPrimary = max(childPrimary, childPrimary + primary / numExpandChildren)
			child:_SetDimension(context.primaryDimension, childPrimary)
		end
		TempTable.Release(expandChildren)
		TempTable.Release(preferredChildren)
		if layout == "HORIZONTAL" then
			local xOffset = self:_GetPadding("LEFT")
			-- calculate the Y offset to properly position stuff with the padding of this frame taken into account
			local yOffset = (self:_GetPadding("BOTTOM") - self:_GetPadding("TOP")) / 2
			for _, child in self:LayoutChildrenIterator() do
				local childFrame = child:_GetBaseFrame()
				xOffset = xOffset + child:_GetMargin("LEFT")
				local childYOffset = (child:_GetMargin("BOTTOM") - child:_GetMargin("TOP")) / 2
				childFrame:SetPoint("LEFT", xOffset, childYOffset + yOffset)
				xOffset = xOffset + childFrame:GetWidth() + child:_GetMargin("RIGHT")
			end
		elseif layout == "VERTICAL" then
			local yOffset = -self:_GetPadding("TOP")
			-- calculate the X offset to properly position stuff with the padding of this frame taken into account
			local xOffset = (self:_GetPadding("LEFT") - self:_GetPadding("RIGHT")) / 2
			for _, child in self:LayoutChildrenIterator() do
				local childFrame = child:_GetBaseFrame()
				yOffset = yOffset - child:_GetMargin("TOP")
				local childXOffset = (child:_GetMargin("LEFT") - child:_GetMargin("RIGHT")) / 2
				childFrame:SetPoint("TOP", childXOffset + xOffset, yOffset)
				yOffset = yOffset - childFrame:GetHeight() - child:_GetMargin("BOTTOM")
			end
		else
			error()
		end
	end
	for _, child in self:LayoutChildrenIterator() do
		child:Draw()
	end
	for _, child in ipairs(self._noLayoutChildren) do
		child:Draw()
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Frame._GetMinimumDimension(self, dimension)
	assert(dimension == "WIDTH" or dimension == "HEIGHT")
	local styleResult = nil
	if dimension == "WIDTH" then
		styleResult = self._width
	elseif dimension == "HEIGHT" then
		styleResult = self._height
	else
		error("Invalid dimension: "..tostring(dimension))
	end
	local layout = self._layout
	local context = LAYOUT_CONTEXT[layout]
	if styleResult then
		return styleResult, false
	elseif self:GetNumLayoutChildren() == 0 or layout == "NONE" then
		return 0, true
	elseif layout == "FLOW" then
		-- calculate our minimum width which is the largest of the widths of the children
		local minWidth = 0
		for _, child in self:LayoutChildrenIterator() do
			local childMin = child:_GetMinimumDimension("WIDTH")
			childMin = childMin + child:_GetMargin("LEFT") + child:_GetMargin("RIGHT")
			minWidth = max(minWidth, childMin)
		end
		minWidth = minWidth + self:_GetPadding("LEFT") + self:_GetPadding("RIGHT")
		if dimension == "WIDTH" then
			return minWidth, true
		end

		-- calculate the row height (all children should be the exact same height)
		local rowHeight = nil
		for _, child in self:LayoutChildrenIterator() do
			local childMin, childCanExpand = child:_GetMinimumDimension("HEIGHT")
			childMin = childMin + child:_GetMargin("TOP") + child:_GetMargin("BOTTOM")
			rowHeight = rowHeight or childMin
			assert(childMin == rowHeight and not childCanExpand)
		end
		rowHeight = rowHeight or 0

		local parentElement = self:GetParentElement()
		local parentWidth = parentElement:_GetDimension("WIDTH") - parentElement:_GetPadding("LEFT") - parentElement:_GetPadding("RIGHT")
		if minWidth > parentWidth then
			-- we won't fit, so just pretend we're a single row
			return rowHeight, false
		end

		-- calculate our height based on our parent's width
		local height = rowHeight
		local currentRowWidth = 0
		for _, child in self:LayoutChildrenIterator() do
			local childWidth = child:_GetMinimumDimension("WIDTH") + child:_GetMargin("LEFT") + child:_GetMargin("RIGHT")
			if currentRowWidth + childWidth > parentWidth then
				-- this child will go on the next row
				height = height + rowHeight
				currentRowWidth = childWidth
			else
				-- this child fits on the current row
				currentRowWidth = currentRowWidth + childWidth
			end
		end

		return height, false
	elseif context then
		-- calculate the dimension based on the children
		local sides = (dimension == context.primaryDimension) and context.sides.primary or context.sides.secondary
		local result = 0
		local canExpand = false
		for _, child in self:LayoutChildrenIterator() do
			local childMin, childCanExpand = child:_GetMinimumDimension(dimension)
			childMin = childMin + child:_GetMargin(sides[1]) + child:_GetMargin(sides[2])
			canExpand = canExpand or childCanExpand
			if dimension == context.primaryDimension then
				result = result + childMin
			else
				result = max(result, childMin)
			end
		end
		result = result + self:_GetPadding(sides[1]) + self:_GetPadding(sides[2])
		return result, self._expandWidth or canExpand
	else
		error(format("Invalid layout (%s)", tostring(layout)))
	end
end
