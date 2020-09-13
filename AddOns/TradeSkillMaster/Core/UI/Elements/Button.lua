-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- Button UI Element Class.
-- A button is a clickable element which has text drawn over top of it. It is a subclass of the @{Text} class.
-- @classmod Button

local _, TSM = ...
local Button = TSM.Include("LibTSMClass").DefineClass("Button", TSM.UI.Text)
local Theme = TSM.Include("Util.Theme")
local ItemInfo = TSM.Include("Service.ItemInfo")
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(Button)
TSM.UI.Button = Button
local ICON_SPACING = 4



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Button.__init(self)
	local frame = UIElements.CreateFrame(self, "Button")

	self.__super:__init(frame)

	frame.backgroundTexture = frame:CreateTexture(nil, "BACKGROUND")

	-- create the highlight
	frame.highlight = frame:CreateTexture(nil, "HIGHLIGHT")
	frame.highlight:SetAllPoints()
	frame.highlight:SetBlendMode("BLEND")
	frame:SetHighlightTexture(frame.highlight)

	-- create the icon
	frame.icon = frame:CreateTexture(nil, "ARTWORK")

	self._font = "BODY_BODY1"
	self._justifyH = "CENTER"
	self._background = nil
	self._iconTexturePack = nil
	self._iconPosition = nil
	self._highlightEnabled = false
end

function Button.Acquire(self)
	self:_GetBaseFrame():Enable()
	self:_GetBaseFrame():RegisterForClicks("LeftButtonUp")
	self:_GetBaseFrame():SetHitRectInsets(0, 0, 0, 0)
	self.__super:Acquire()
end

function Button.Release(self)
	local frame = self:_GetBaseFrame()
	frame:UnlockHighlight()
	self._background = nil
	self._iconTexturePack = nil
	self._iconPosition = nil
	self._highlightEnabled = false
	self.__super:Release()
	self._font = "BODY_BODY1"
	self._justifyH = "CENTER"
end

--- Sets the background of the button.
-- @tparam Button self The button object
-- @tparam ?string|number|nil background Either a texture pack string, itemString, WoW file id, theme color key, or nil
-- @treturn Button The button object
function Button.SetBackground(self, background)
	assert(background == nil or type(background) == "string" or type(background) == "number")
	self._background = background
	return self
end

--- Sets the background and size of the button based on a texture pack string.
-- @tparam Button self The button object
-- @tparam string texturePack A texture pack string to set the background to and base the size on
-- @treturn Button The button object
function Button.SetBackgroundAndSize(self, texturePack)
	self:SetBackground(texturePack)
	self:SetSize(TSM.UI.TexturePacks.GetSize(texturePack))
	return self
end

--- Sets whether or not the highlight is enabled.
-- @tparam Button self The button object
-- @tparam boolean enabled Whether or not the highlight is enabled
-- @treturn Button The button object
function Button.SetHighlightEnabled(self, enabled)
	self._highlightEnabled = enabled
	return self
end

--- Sets the icon that shows within the button.
-- @tparam Button self The button object
-- @tparam[opt=nil] string texturePack A texture pack string to set the icon and its size to
-- @tparam[opt=nil] string position The positin of the icon
-- @treturn Button The button object
function Button.SetIcon(self, texturePack, position)
	if texturePack or position then
		assert(TSM.UI.TexturePacks.IsValid(texturePack))
		assert(position == "LEFT" or position == "LEFT_NO_TEXT" or position == "CENTER" or position == "RIGHT")
		self._iconTexturePack = texturePack
		self._iconPosition = position
	else
		self._iconTexturePack = nil
		self._iconPosition = nil
	end
	return self
end

--- Set whether or not the button is disabled.
-- @tparam Button self The button object
-- @tparam boolean disabled Whether or not the button should be disabled
-- @treturn Button The button object
function Button.SetDisabled(self, disabled)
	if disabled then
		self:_GetBaseFrame():Disable()
	else
		self:_GetBaseFrame():Enable()
	end
	return self
end

--- Registers the button for drag events.
-- @tparam Button self The button object
-- @tparam string button The mouse button to register for drag events from
-- @treturn Button The button object
function Button.RegisterForDrag(self, button)
	self:_GetBaseFrame():RegisterForDrag(button)
	return self
end

--- Click on the button.
-- @tparam Button self The button object
function Button.Click(self)
	self:_GetBaseFrame():Click()
end

--- Enable right-click events for the button.
-- @tparam Button self The button object
-- @treturn Button The button object
function Button.EnableRightClick(self)
	self:_GetBaseFrame():RegisterForClicks("LeftButtonUp", "RightButtonUp")
	return self
end

--- Set the hit rectangle insets for the button.
-- @tparam Button self The button object
-- @tparam number left How much the left side of the hit rectangle is inset
-- @tparam number right How much the right side of the hit rectangle is inset
-- @tparam number top How much the top side of the hit rectangle is inset
-- @tparam number bottom How much the bottom side of the hit rectangle is inset
-- @treturn Button The button object
function Button.SetHitRectInsets(self, left, right, top, bottom)
	self:_GetBaseFrame():SetHitRectInsets(left, right, top, bottom)
	return self
end

--- Set whether or not to lock the button's highlight.
-- @tparam Button self The action button object
-- @tparam boolean locked Whether or not to lock the action button's highlight
-- @treturn Button The action button object
function Button.SetHighlightLocked(self, locked)
	if locked then
		self:_GetBaseFrame():LockHighlight()
	else
		self:_GetBaseFrame():UnlockHighlight()
	end
	return self
end

function Button.Draw(self)
	local frame = self:_GetBaseFrame()
	frame.text:Show()
	self.__super:Draw()

	frame.backgroundTexture:SetTexture(nil)
	frame.backgroundTexture:SetTexCoord(0, 1, 0, 1)
	frame.backgroundTexture:SetVertexColor(1, 1, 1, 1)

	if self._background == nil then
		frame.backgroundTexture:Hide()
	elseif type(self._background) == "string" and TSM.UI.TexturePacks.IsValid(self._background) then
		-- this is a texture pack
		frame.backgroundTexture:Show()
		frame.backgroundTexture:ClearAllPoints()
		frame.backgroundTexture:SetPoint("CENTER")
		TSM.UI.TexturePacks.SetTextureAndSize(frame.backgroundTexture, self._background)
	elseif type(self._background) == "string" and strmatch(self._background, "^[ip]:%d+") then
		-- this is an itemString
		frame.backgroundTexture:Show()
		frame.backgroundTexture:ClearAllPoints()
		frame.backgroundTexture:SetAllPoints()
		frame.backgroundTexture:SetTexture(ItemInfo.GetTexture(self._background))
	elseif type(self._background) == "string" then
		-- this is a theme color key
		frame.backgroundTexture:Show()
		frame.backgroundTexture:ClearAllPoints()
		frame.backgroundTexture:SetAllPoints()
		frame.backgroundTexture:SetColorTexture(Theme.GetColor(self._background):GetFractionalRGBA())
	elseif type(self._background) == "number" then
		-- this is a wow file id
		frame.backgroundTexture:Show()
		frame.backgroundTexture:ClearAllPoints()
		frame.backgroundTexture:SetAllPoints()
		frame.backgroundTexture:SetTexture(self._background)
	else
		error("Invalid background: "..tostring(self._background))
	end

	-- set the text color
	local textColor = frame:IsEnabled() and self:_GetTextColor() or Theme.GetColor("ACTIVE_BG_ALT")
	frame.text:SetTextColor(textColor:GetFractionalRGBA())

	-- set the highlight texture
	if self._highlightEnabled then
		frame.highlight:SetColorTexture(Theme.GetColor(self._background):GetTint("+HOVER"):GetFractionalRGBA())
	else
		frame.highlight:SetColorTexture(0, 0, 0, 0)
	end

	if self._iconTexturePack then
		TSM.UI.TexturePacks.SetTextureAndSize(frame.icon, self._iconTexturePack)
		frame.icon:Show()
		frame.icon:ClearAllPoints()
		frame.icon:SetVertexColor(textColor:GetFractionalRGBA())
		local iconWidth = TSM.UI.TexturePacks.GetWidth(self._iconTexturePack) + ICON_SPACING
		if self._iconPosition == "LEFT" then
			frame.icon:SetPoint("RIGHT", frame.text, "LEFT", -ICON_SPACING, 0)
			frame.text:ClearAllPoints()
			if self._justifyH == "CENTER" then
				local xOffset = iconWidth / 2
				frame.text:SetPoint("TOP", xOffset, -self:_GetPadding("TOP"))
				frame.text:SetPoint("BOTTOM", xOffset, self:_GetPadding("BOTTOM"))
				frame.text:SetWidth(frame.text:GetStringWidth())
			elseif self._justifyH == "LEFT" then
				frame.text:SetPoint("TOPLEFT", iconWidth + self:_GetPadding("LEFT"), -self:_GetPadding("TOP"))
				frame.text:SetPoint("BOTTOMRIGHT", -self:_GetPadding("RIGHT"), self:_GetPadding("BOTTOM"))
			else
				error("Unsupported justifyH: "..tostring(self._justifyH))
			end
		elseif self._iconPosition == "LEFT_NO_TEXT" then
			frame.icon:SetPoint("LEFT", self:_GetPadding("LEFT"), 0)
			frame.text:ClearAllPoints()
			frame.text:Hide()
		elseif self._iconPosition == "CENTER" then
			frame.icon:SetPoint("CENTER")
			frame.text:ClearAllPoints()
			frame.text:Hide()
		elseif self._iconPosition == "RIGHT" then
			frame.icon:SetPoint("RIGHT", -self:_GetPadding("RIGHT"), 0)
			local xOffset = iconWidth
			frame.text:ClearAllPoints()
			-- TODO: support non-left-aligned text
			frame.text:SetPoint("TOPLEFT", self:_GetPadding("LEFT"), -self:_GetPadding("TOP"))
			frame.text:SetPoint("BOTTOMRIGHT", -xOffset, self:_GetPadding("BOTTOM"))
		else
			error("Invalid iconPosition: "..tostring(self._iconPosition))
		end
	else
		frame.icon:Hide()
		frame.text:ClearAllPoints()
		frame.text:SetPoint("TOPLEFT", self:_GetPadding("LEFT"), -self:_GetPadding("TOP"))
		frame.text:SetPoint("BOTTOMRIGHT", -self:_GetPadding("RIGHT"), self:_GetPadding("BOTTOM"))
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Button._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" and self._autoWidth then
		return self:GetStringWidth() + (self._iconTexturePack and TSM.UI.TexturePacks.GetWidth(self._iconTexturePack) or 0)
	else
		return self.__super:_GetMinimumDimension(dimension)
	end
end
