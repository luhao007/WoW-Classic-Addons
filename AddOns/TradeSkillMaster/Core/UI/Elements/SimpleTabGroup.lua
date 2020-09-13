-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- SimpleTabGroup UI Element Class.
-- A simple table group uses text to denote tabs with the selected one colored differently. It is a subclass of the
-- @{ViewContainer} class.
-- @classmod SimpleTabGroup

local _, TSM = ...
local SimpleTabGroup = TSM.Include("LibTSMClass").DefineClass("SimpleTabGroup", TSM.UI.ViewContainer)
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(SimpleTabGroup)
TSM.UI.SimpleTabGroup = SimpleTabGroup
local private = {}
local BUTTON_HEIGHT = 24
local BUTTON_PADDING_BOTTOM = 2



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SimpleTabGroup.__init(self)
	self.__super:__init()
	self._buttons = {}
end

function SimpleTabGroup.Acquire(self)
	self.__super.__super:AddChildNoLayout(UIElements.New("Frame", "buttons")
		:SetLayout("HORIZONTAL")
		:AddAnchor("TOPLEFT")
		:AddAnchor("TOPRIGHT")
	)
	self.__super:Acquire()
end

function SimpleTabGroup.Release(self)
	wipe(self._buttons)
	self.__super:Release()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function SimpleTabGroup._GetContentPadding(self, side)
	if side == "TOP" then
		return BUTTON_HEIGHT + BUTTON_PADDING_BOTTOM
	end
	return self.__super:_GetContentPadding(side)
end

function SimpleTabGroup.Draw(self)
	self.__super.__super.__super:Draw()

	local selectedPath = self:GetPath()
	local buttons = self:GetElement("buttons")
	buttons:SetHeight(BUTTON_HEIGHT + BUTTON_PADDING_BOTTOM)
	buttons:ReleaseAllChildren()
	for i, buttonPath in ipairs(self._pathsList) do
		local isSelected = buttonPath == selectedPath
		buttons:AddChild(UIElements.New("Button", self._id.."_Tab"..i)
			:SetWidth("AUTO")
			:SetMargin(8, 8, 0, BUTTON_PADDING_BOTTOM)
			:SetJustifyH("LEFT")
			:SetFont("BODY_BODY1_BOLD")
			:SetTextColor(isSelected and "INDICATOR" or "TEXT_ALT")
			:SetContext(self)
			:SetText(buttonPath)
			:SetScript("OnEnter", not isSelected and private.OnButtonEnter)
			:SetScript("OnLeave", not isSelected and private.OnButtonLeave)
			:SetScript("OnClick", private.OnButtonClicked)
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
	self:SetPath(path, true)
end
