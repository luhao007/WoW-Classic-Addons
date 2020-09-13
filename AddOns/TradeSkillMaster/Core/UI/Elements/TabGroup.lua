-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- TabGroup UI Element Class.
-- A tab group uses text and a horizontal line to denote the tabs, with coloring indicating the one which is selected.
-- It is a subclass of the @{ViewContainer} class.
-- @classmod TabGroup

local _, TSM = ...
local TabGroup = TSM.Include("LibTSMClass").DefineClass("TabGroup", TSM.UI.ViewContainer)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(TabGroup)
TSM.UI.TabGroup = TabGroup
local private = {}
local BUTTON_HEIGHT = 24
local BUTTON_PADDING_BOTTOM = 4
local LINE_THICKNESS = 2
local LINE_THICKNESS_SELECTED = 2



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function TabGroup.__init(self)
	self.__super:__init()
	self._buttons = {}
end

function TabGroup.Acquire(self)
	self.__super.__super:AddChildNoLayout(UIElements.New("Frame", "buttons")
		:SetLayout("HORIZONTAL")
		:AddAnchor("TOPLEFT")
		:AddAnchor("TOPRIGHT")
	)
	self.__super:Acquire()
end

function TabGroup.Release(self)
	wipe(self._buttons)
	self.__super:Release()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function TabGroup._GetContentPadding(self, side)
	if side == "TOP" then
		return BUTTON_HEIGHT + BUTTON_PADDING_BOTTOM + LINE_THICKNESS
	end
	return self.__super:_GetContentPadding(side)
end

function TabGroup.Draw(self)
	self.__super.__super.__super:Draw()

	local selectedPath = self:GetPath()
	local buttons = self:GetElement("buttons")
	buttons:SetHeight(BUTTON_HEIGHT + BUTTON_PADDING_BOTTOM + LINE_THICKNESS)
	buttons:ReleaseAllChildren()
	for i, buttonPath in ipairs(self._pathsList) do
		local isSelected = buttonPath == selectedPath
		buttons:AddChild(UIElements.New("Frame", self._id.."_Tab"..i)
			:SetLayout("VERTICAL")
			:AddChild(UIElements.New("Button", "button")
				:SetMargin(0, 0, 0, BUTTON_PADDING_BOTTOM)
				:SetFont("BODY_BODY1_BOLD")
				:SetJustifyH("CENTER")
				:SetTextColor(isSelected and "INDICATOR" or "TEXT_ALT")
				:SetContext(self)
				:SetText(buttonPath)
				:SetScript("OnEnter", not isSelected and private.OnButtonEnter)
				:SetScript("OnLeave", not isSelected and private.OnButtonLeave)
				:SetScript("OnClick", private.OnButtonClicked)
			)
			:AddChild(UIElements.New("Texture", "line")
				:SetHeight(isSelected and LINE_THICKNESS_SELECTED or LINE_THICKNESS)
				:SetTexture(isSelected and "INDICATOR" or "TEXT_ALT")
			)
		)
	end

	self.__super:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnButtonEnter(button)
	button:SetTextColor("TEXT")
		:Draw()
end

function private.OnButtonLeave(button)
	button:SetTextColor("TEXT_ALT")
		:Draw()
end

function private.OnButtonClicked(button)
	local self = button:GetContext()
	local path = button:GetText()
	self:SetPath(path, self:GetPath() ~= path)
end
