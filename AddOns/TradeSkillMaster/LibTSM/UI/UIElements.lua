-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- UI element functions.
-- @module UIElements

local _, TSM = ...
local UIElements = TSM.Init("UI.UIElements")
local ObjectPool = TSM.Include("Util.ObjectPool")
local Table = TSM.Include("Util.Table")
local private = {
	elementClasses = {},
	objectPools = {},
	namedElements = {},
	activeFrameElementMap = {},
	debugNameElementLookup = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================


--- Registers a UI Element subclass.
-- @tparam Element class The element subclass
function UIElements.Register(class)
	private.elementClasses[class.__name] = class
end

--- Creates a new UI element.
-- @tparam string elementType The name of the element class
-- @tparam string id The id to assign to the element
-- @param ... Tags to set on the element
-- @treturn Element The created UI element object
function UIElements.New(elementType, id, ...)
	return private.NewElementHelper(elementType, id, nil, ...)
end

--- Creates a new named UI element.
-- @tparam string elementType The name of the element class
-- @tparam string id The id to assign to the element
-- @tparam string name The global name of the element
-- @treturn Element The created UI element object
function UIElements.NewNamed(elementType, id, name, ...)
	assert(name)
	return private.NewElementHelper(elementType, id, name, ...)
end

--- Recycles a UI element.
-- @tparam Element element The UI element object
function UIElements.Recycle(element)
	private.activeFrameElementMap[element:_GetBaseFrame()] = nil
	if not Table.KeyByValue(private.namedElements, element) then
		private.objectPools[element.__class]:Recycle(element)
	end
end

--- Gets a UI element by its frame (for TSM's frame stack).
-- @tparam table frame The frame
-- @treturn ?Element The element or nil if the frame doesn't correspond to an element
function UIElements.GetByFrame(frame)
	return private.activeFrameElementMap[frame]
end

--- Creates a WoW UI object and tracks it for easier debugging.
-- @tparam Element element The TSM UI element object
-- @tparam string frameType The type of the WoW UI object
-- @tparam ?string frameName The global name
-- @tparam ?table parentFrame The parent WoW UI object
-- @tparam ?string inheritsFrame A WoW UI template to inherit from
-- @treturn table The WoW UI object
function UIElements.CreateFrame(element, frameType, frameName, parentFrame, inheritsFrame)
	local isNamed = frameName and true or false
	if not frameName then
		-- generate a debug name to aid in later lookup
		frameName = private.GetDebugName(element)
	end
	private.debugNameElementLookup[frameName] = element
	local frame = CreateFrame(frameType, frameName, parentFrame, inheritsFrame)
	if not isNamed then
		_G[frameName] = nil
	end
	return frame
end

--- Creates a WoW UI font string and tracks it for easier debugging.
-- @tparam Element element The TSM UI element object
-- @tparam table parentFrame The parent WoW UI frame
-- @treturn table The WoW UI font string
function UIElements.CreateFontString(element, parentFrame)
	local name = private.GetDebugName(element)
	private.debugNameElementLookup[name] = element
	local fontString = parentFrame:CreateFontString(name)
	_G[name] = nil
	return fontString
end

--- Gets the debug name translations.
-- @tparam table result The result table
function UIElements.GetDebugNameTranslation(result)
	for name, element in pairs(private.debugNameElementLookup) do
		result[name] = "<"..tostring(element)..">"
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.NewElementHelper(elementType, id, name, ...)
	local class = private.elementClasses[elementType]
	local element = nil
	if name then
		private.namedElements[name] = private.namedElements[name] or class(name)
		element = private.namedElements[name]
		assert(_G[name] == element:_GetBaseFrame())
	else
		if not private.objectPools[class] then
			private.objectPools[class] = ObjectPool.New("UI_"..class.__name, class, 1)
		end
		element = private.objectPools[class]:Get()
	end
	private.activeFrameElementMap[element:_GetBaseFrame()] = element
	element:SetId(id)
	element:SetTags(...)
	element:Acquire()
	return element
end

function private.GetDebugName(element)
	return "TSM_UI_ELEMENT:"..element.__class.__name..":"..format("%06x", random(0, 2 ^ 24 - 1))
end
