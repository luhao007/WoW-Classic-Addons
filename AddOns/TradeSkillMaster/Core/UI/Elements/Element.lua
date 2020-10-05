-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Base UI Element Class.
-- This the base class for all other UI element classes.
-- @classmod Element

local _, TSM = ...
local Element = TSM.Include("LibTSMClass").DefineClass("Element", nil, "ABSTRACT")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local Analytics = TSM.Include("Util.Analytics")
local Tooltip = TSM.Include("UI.Tooltip")
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(Element)
TSM.UI.Element = Element
local private = {}
local ANCHOR_REL_PARENT = newproxy()



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Element.__init(self, frame)
	self._tags = {}
	self._frame = frame
	self._scripts = {}
	self._baseElementCache = nil
	self._parent = nil
	self._context = nil
	self._acquired = nil
	self._tooltip = nil
	self._width = nil
	self._height = nil
	self._margin = { left = 0, right = 0, top = 0, bottom = 0 }
	self._padding = { left = 0, right = 0, top = 0, bottom = 0 }
	self._relativeLevel = nil
	self._anchors = {}
end

function Element.__tostring(self)
	local parentId = self._parent and self._parent._id
	return self.__class.__name..":"..(parentId and (parentId..".") or "")..(self._id or "?")
end

function Element.SetId(self, id)
	-- should only be called by core UI code before acquiring the element
	assert(not self._acquired)
	self._id = id or tostring(self)
end

function Element.SetTags(self, ...)
	-- should only be called by core UI code before acquiring the element
	assert(not self._acquired)
	assert(#self._tags == 0)
	for i = 1, select("#", ...) do
		local tag = select(i, ...)
		tinsert(self._tags, tag)
	end
end

function Element.Acquire(self)
	assert(not self._acquired)
	self._acquired = true
	self:Show()
end

function Element.Release(self)
	assert(self._acquired)
	local frame = self:_GetBaseFrame()

	-- clear the OnLeave script before hiding the frame (otherwise it'll get called)
	if self._scripts.OnLeave then
		frame:SetScript("OnLeave", nil)
		self._scripts.OnLeave = nil
	end

	if self._tooltip and Tooltip.IsVisible(frame) then
		-- hide the tooltip
		Tooltip.Hide()
	end

	self:Hide()
	frame:ClearAllPoints()
	frame:SetParent(nil)
	frame:SetScale(1)
	-- clear scripts
	for script in pairs(self._scripts) do
		frame:SetScript(script, nil)
	end

	wipe(self._tags)
	wipe(self._scripts)
	self._baseElementCache = nil
	self._parent = nil
	self._context = nil
	self._acquired = nil
	self._tooltip = nil
	self._width = nil
	self._height = nil
	self._margin.left = 0
	self._margin.right = 0
	self._margin.top = 0
	self._margin.bottom = 0
	self._padding.left = 0
	self._padding.right = 0
	self._padding.top = 0
	self._padding.bottom = 0
	self._relativeLevel = nil
	wipe(self._anchors)

	UIElements.Recycle(self)
end

--- Shows the element.
-- @tparam Element self The element object
function Element.Show(self)
	self:_GetBaseFrame():Show()
	return self
end

--- Hides the element.
-- @tparam Element self The element object
function Element.Hide(self)
	self:_GetBaseFrame():Hide()
	return self
end

--- Returns whether or not the element is visible.
-- @tparam Element self The element object
-- @treturn boolean Whether or not the element is currently visible
function Element.IsVisible(self)
	return self:_GetBaseFrame():IsVisible()
end

--- Sets the width of the element.
-- @tparam Element self The element object
-- @tparam ?number width The width of the element, or nil to have an undefined width
-- @treturn Element The element object
function Element.SetWidth(self, width)
	assert(width == nil or type(width) == "number")
	self._width = width
	return self
end

--- Sets the height of the element.
-- @tparam Element self The element object
-- @tparam ?number height The height of the element, or nil to have an undefined height
-- @treturn Element The element object
function Element.SetHeight(self, height)
	assert(height == nil or type(height) == "number")
	self._height = height
	return self
end

--- Sets the width and height of the element.
-- @tparam Element self The element object
-- @tparam ?number width The width of the element, or nil to have an undefined width
-- @tparam ?number height The height of the element, or nil to have an undefined height
-- @treturn Element The element object
function Element.SetSize(self, width, height)
	self:SetWidth(width)
	self:SetHeight(height)
	return self
end

--- Sets the padding of the element.
-- @tparam Element self The element object
-- @tparam number left The left padding value if all arguments are passed or the value of all sides if a single argument is passed
-- @tparam[opt] number right The right padding value if all arguments are passed
-- @tparam[opt] number top The top padding value if all arguments are passed
-- @tparam[opt] number bottom The bottom padding value if all arguments are passed
-- @treturn Element The element object
function Element.SetPadding(self, left, right, top, bottom)
	if not right and not top and not bottom then
		right = left
		top = left
		bottom = left
	end
	assert(type(left) == "number" and type(right) == "number" and type(top) == "number" and type(bottom) == "number")
	self._padding.left = left
	self._padding.right = right
	self._padding.top = top
	self._padding.bottom = bottom
	return self
end

--- Sets the margin of the element.
-- @tparam Element self The element object
-- @tparam number left The left margin value if all arguments are passed or the value of all sides if a single argument is passed
-- @tparam[opt] number right The right margin value if all arguments are passed
-- @tparam[opt] number top The top margin value if all arguments are passed
-- @tparam[opt] number bottom The bottom margin value if all arguments are passed
-- @treturn Element The element object
function Element.SetMargin(self, left, right, top, bottom)
	if not right and not top and not bottom then
		right = left
		top = left
		bottom = left
	end
	assert(type(left) == "number" and type(right) == "number" and type(top) == "number" and type(bottom) == "number")
	self._margin.left = left
	self._margin.right = right
	self._margin.top = top
	self._margin.bottom = bottom
	return self
end

--- Sets the relative level of this element with regards to its parent.
-- @tparam Element self The element object
-- @tparam number level The relative level of this element
-- @treturn Element The element object
function Element.SetRelativeLevel(self, level)
	self._relativeLevel = level
	return self
end

--- Wipes the element's anchors.
-- @treturn Element The element object
function Element.WipeAnchors(self)
	wipe(self._anchors)
	return self
end

--- Adds an anchor to the element.
-- @tparam Element self The element object
-- @param ... The anchor arguments (following WoW's SetPoint() arguments)
-- @treturn Element The element object
function Element.AddAnchor(self, ...)
	local numArgs = select("#", ...)
	local point, relFrame, relPoint, x, y = nil, nil, nil, nil, nil
	if numArgs == 1 then
		point = ...
	elseif numArgs == 2 then
		point, relFrame = ...
	elseif numArgs == 3 then
		local arg2 = select(2, ...)
		if type(arg2) == "number" then
			point, x, y = ...
		else
			point, relFrame, relPoint = ...
		end
	elseif numArgs == 4 then
		point, relFrame, x, y = ...
	elseif numArgs == 5 then
		point, relFrame, relPoint, x, y = ...
	else
		error("Invalid anchor")
	end
	tinsert(self._anchors, point)
	tinsert(self._anchors, relFrame or ANCHOR_REL_PARENT)
	tinsert(self._anchors, relPoint or point)
	tinsert(self._anchors, x or 0)
	tinsert(self._anchors, y or 0)
	return self
end

--- Gets the top-most element in the tree.
-- @tparam Element self The element object
-- @treturn Element The top-most element object
function Element.GetBaseElement(self)
	if not self._baseElementCache then
		local element = self
		local parent = element:GetParentElement()
		while parent do
			local temp = element
			element = parent
			parent = temp:GetParentElement()
		end
		self._baseElementCache = element
	end
	return self._baseElementCache
end

--- Gets the parent element's base frame.
-- @tparam Element self The element object
-- @treturn Element The parent element's base frame
function Element.GetParent(self)
	return self:GetParentElement():_GetBaseFrame()
end

--- Gets the parent element.
-- @tparam Element self The element object
-- @treturn Element The parent element object
function Element.GetParentElement(self)
	return self._parent
end

--- Gets another element in the tree by relative path.
-- The path consists of element ids separated by `.`. `__parent` may also be used to indicate the parent element.
-- @tparam Element self The element object
-- @tparam string path The relative path to the element
-- @treturn Element The desired element
function Element.GetElement(self, path)
	-- First try to find the element as a child of self
	local result = private.GetElementHelper(self, path)
	if not result then
		Analytics.Action("GET_ELEMENT_FAIL", tostring(self), path)
	end
	-- TODO: is this needed?
	result = result or private.GetElementHelper(self:GetBaseElement(), path)
	return result
end

--- Sets the tooltip of the element.
-- @tparam Element self The element object
-- @param tooltip The value passed to @{Tooltip.Show} when the user hovers over the element, or nil to clear it
-- @treturn Element The element object
function Element.SetTooltip(self, tooltip)
	self._tooltip = tooltip
	if tooltip then
		-- setting OnEnter/OnLeave will implicitly enable the mouse, so make sure it's previously been enabled
		assert(self:_GetBaseFrame():IsMouseEnabled())
		self:SetScript("OnEnter", private.OnEnter)
		self:SetScript("OnLeave", private.OnLeave)
	else
		self:SetScript("OnEnter", nil)
		self:SetScript("OnLeave", nil)
	end
	return self
end

--- Shows a tooltip on the element.
-- @tparam Element self The element object
-- @param tooltip The value passed to @{Tooltip.Show} when the user hovers over the element
-- @tparam ?boolean noWrapping Disables wrapping of text lines
-- @tparam[opt=0] number xOffset An extra x offset to apply to the anchor of the tooltip
-- @treturn Element The element object
function Element.ShowTooltip(self, tooltip, noWrapping, xOffset)
	Tooltip.Show(self:_GetBaseFrame(), tooltip, noWrapping, xOffset)
	return self
end

--- Sets the context value of the element.
-- @tparam Element self The element object
-- @param context The context value
-- @treturn Element The element object
function Element.SetContext(self, context)
	self._context = context
	return self
end

--- Gets the context value from the element.
-- @tparam Element self The element object
-- @return The context value
function Element.GetContext(self)
	return self._context
end

--- Registers a script handler.
-- @tparam Element self The element object
-- @tparam string script The script to register for
-- @tparam function handler The script handler which will be called with the element object followed by any arguments to
-- the script
-- @treturn Element The element object
function Element.SetScript(self, script, handler)
	self._scripts[script] = handler
	if handler then
		ScriptWrapper.Set(self:_GetBaseFrame(), script, handler, self)
	else
		ScriptWrapper.Clear(self:_GetBaseFrame(), script)
	end
	return self
end

--- Sets a script to propagate to the parent element.
-- @tparam Element self The element object
-- @tparam string script The script to propagate
-- @treturn Element The element object
function Element.PropagateScript(self, script)
	self._scripts[script] = "__PROPAGATE"
	ScriptWrapper.SetPropagate(self:_GetBaseFrame(), script, self)
	return self
end

function Element.Draw(self)
	assert(self._acquired)
	local frame = self:_GetBaseFrame()
	local numAnchors = self:_GetNumAnchors()
	if numAnchors > 0 then
		frame:ClearAllPoints()
		for i = 1, numAnchors do
			local point, relFrame, relPoint, x, y = self:_GetAnchor(i)
			if relFrame == ANCHOR_REL_PARENT then
				relFrame = frame:GetParent()
			elseif type(relFrame) == "string" then
				-- this is a relative element
				relFrame = self:GetParentElement():GetElement(relFrame):_GetBaseFrame()
			end
			frame:SetPoint(point, relFrame, relPoint, x, y)
		end
	end
	local width = self._width
	if width then
		self:_SetDimension("WIDTH", width)
	end
	local height = self._height
	if height then
		self:_SetDimension("HEIGHT", height)
	end
	local relativeLevel = self._relativeLevel
	if relativeLevel then
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + relativeLevel)
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Element._GetNumAnchors(self)
	assert(#self._anchors % 5 == 0)
	return #self._anchors / 5
end

function Element._GetAnchor(self, index)
	index = (index - 1) * 5 + 1
	assert(index < #self._anchors)
	return unpack(self._anchors, index, index + 4)
end

function Element._SetParentElement(self, parent)
	self._parent = parent
	self:_ClearBaseElementCache()
end

function Element._ClearBaseElementCache(self)
	self._baseElementCache = nil
end

function Element._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" then
		local width = self._width
		return width or 0, width == nil
	elseif dimension == "HEIGHT" then
		local height = self._height
		return height or 0, height == nil
	else
		error("Invalid dimension: " .. tostring(dimension))
	end
end

function Element._GetPreferredDimension(self, dimension)
	if dimension == "WIDTH" then
		return nil
	elseif dimension == "HEIGHT" then
		return nil
	else
		error("Invalid dimension: " .. tostring(dimension))
	end
end

function Element._GetDimension(self, dimension)
	if dimension == "WIDTH" then
		return self:_GetBaseFrame():GetWidth()
	elseif dimension == "HEIGHT" then
		return self:_GetBaseFrame():GetHeight()
	else
		error("Invalid dimension: " .. tostring(dimension))
	end
end

function Element._SetDimension(self, dimension, ...)
	if dimension == "WIDTH" then
		self:_GetBaseFrame():SetWidth(...)
	elseif dimension == "HEIGHT" then
		self:_GetBaseFrame():SetHeight(...)
	else
		error("Invalid dimension: " .. tostring(dimension))
	end
end

function Element._GetBaseFrame(self)
	return self._frame
end

function Element._GetPadding(self, side)
	return self._padding[strlower(side)]
end

function Element._GetPaddingAnchorOffsets(self, anchor)
	local xPart, yPart = private.SplitAnchor(anchor)
	local x = xPart and ((xPart == "LEFT" and 1 or -1) * self:_GetPadding(xPart)) or 0
	local y = yPart and ((yPart == "BOTTOM" and 1 or -1) * self:_GetPadding(yPart)) or 0
	return x, y
end

function Element._GetMargin(self, side)
	return self._margin[strlower(side)]
end

function Element._GetMarginAnchorOffsets(self, anchor)
	local xPart, yPart = private.SplitAnchor(anchor)
	local x = xPart and ((xPart == "LEFT" and 1 or -1) * self:_GetMargin(xPart)) or 0
	local y = yPart and ((yPart == "BOTTOM" and 1 or -1) * self:_GetMargin(yPart)) or 0
	return x, y
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.GetElementHelper(element, path)
	local numParts = select("#", strsplit(".", path))
	local partIndex = 1
	while partIndex <= numParts do
		local part = select(partIndex, strsplit(".", path))
		if part == "__parent" then
			local parentElement = element:GetParentElement()
			if not parentElement then
				error(format("Element (%s) has no parent", tostring(element._id)))
			end
			element = parentElement
		elseif part == "__base" then
			local baseElement = element:GetBaseElement()
			if not baseElement then
				error(format("Element (%s) has no base element", tostring(element._id)))
			end
			element = baseElement
		else
			local found = false
			for _, child in ipairs(element._children) do
				if child._id == part then
					element = child
					found = true
					break
				end
			end
			if not found then
				element = nil
				break
			end
		end
		partIndex = partIndex + 1
	end
	return element
end

function private.SplitAnchor(anchor)
	if anchor == "BOTTOMLEFT" then
		return "LEFT", "BOTTOM"
	elseif anchor == "BOTTOM" then
		return nil, "BOTTOM"
	elseif anchor == "BOTTOMRIGHT" then
		return "RIGHT", "BOTTOM"
	elseif anchor == "RIGHT" then
		return "RIGHT", nil
	elseif anchor == "TOPRIGHT" then
		return "RIGHT", "TOP"
	elseif anchor == "TOP" then
		return nil, "TOP"
	elseif anchor == "TOPLEFT" then
		return "LEFT", "TOP"
	elseif anchor == "LEFT" then
		return "LEFT", nil
	else
		error("Invalid anchor: "..tostring(anchor))
	end
end

function private.OnEnter(element)
	element:ShowTooltip(element._tooltip)
end

function private.OnLeave(element)
	Tooltip.Hide()
end
