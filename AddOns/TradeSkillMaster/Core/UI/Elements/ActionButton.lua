-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- ActionButton UI Element Class.
-- An action button is a button which uses specific background textures and has a pressed state. It is a subclass of the
-- @{Text} class.
-- @classmod ActionButton

local _, TSM = ...
local ActionButton = TSM.Include("LibTSMClass").DefineClass("ActionButton", TSM.UI.Text)
local NineSlice = TSM.Include("Util.NineSlice")
local Vararg = TSM.Include("Util.Vararg")
local Event = TSM.Include("Util.Event")
local Theme = TSM.Include("Util.Theme")
local Color = TSM.Include("Util.Color")
local ScriptWrapper = TSM.Include("Util.ScriptWrapper")
local UIElements = TSM.Include("UI.UIElements")
UIElements.Register(ActionButton)
TSM.UI.ActionButton = ActionButton
local private = {}
local ICON_PADDING = 2
local CLICK_COOLDOWN = 0.2



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ActionButton.__init(self, name, isSecure)
	local frame = UIElements.CreateFrame(self, "Button", name, nil, isSecure and "SecureActionButtonTemplate" or nil)
	ScriptWrapper.Set(frame, isSecure and "PostClick" or "OnClick", private.OnClick, self)
	ScriptWrapper.Set(frame, "OnMouseDown", private.OnMouseDown, self)
	ScriptWrapper.Set(frame, "OnEnter", private.OnEnter, self)
	ScriptWrapper.Set(frame, "OnLeave", private.OnLeave, self)

	self.__super:__init(frame)

	self._nineSlice = NineSlice.New(frame)

	-- create the icon
	frame.icon = frame:CreateTexture(nil, "ARTWORK")
	frame.icon:SetPoint("RIGHT", frame.text, "LEFT", -ICON_PADDING, 0)

	Event.Register("MODIFIER_STATE_CHANGED", function()
		if self:IsVisible() and next(self._modifierText) then
			self:Draw()
			if GameTooltip:IsOwned(self:_GetBaseFrame()) then
				self:ShowTooltip(self._tooltip)
			end
		end
	end)

	self._iconTexturePack = nil
	self._pressed = nil
	self._disabled = false
	self._locked = false
	self._lockedColor = nil
	self._justifyH = "CENTER"
	self._font = "BODY_BODY2_MEDIUM"
	self._defaultText = ""
	self._modifierText = {}
	self._onClickHandler = nil
	self._onEnterHandler = nil
	self._onLeaveHandler = nil
	self._clickCooldown = nil
	self._clickCooldownDisabled = false
	self._defaultNoBackground = false
	self._isMouseDown = false
	self._manualRequired = false
end

function ActionButton.Release(self)
	self._iconTexturePack = nil
	self._pressed = nil
	self._disabled = false
	self._locked = false
	self._lockedColor = nil
	self._defaultText = ""
	wipe(self._modifierText)
	self._onClickHandler = nil
	self._onEnterHandler = nil
	self._onLeaveHandler = nil
	self._clickCooldown = nil
	self._clickCooldownDisabled = false
	self._defaultNoBackground = false
	self._manualRequired = false
	self._isMouseDown = false
	local frame = self:_GetBaseFrame()
	ScriptWrapper.Clear(frame, "OnUpdate")
	frame:Enable()
	frame:RegisterForClicks("LeftButtonUp")
	frame:UnlockHighlight()
	self.__super:Release()
	self._justifyH = "CENTER"
	self._font = "BODY_BODY2_MEDIUM"
end

--- Sets the icon that shows within the button.
-- @tparam ActionButton self The action button object
-- @tparam[opt=nil] string texturePack A texture pack string to set the icon and its size to
-- @treturn ActionButton The action button object
function ActionButton.SetIcon(self, texturePack)
	if texturePack then
		assert(TSM.UI.TexturePacks.IsValid(texturePack))
		self._iconTexturePack = texturePack
	else
		self._iconTexturePack = nil
	end
	return self
end

--- Set the text.
-- @tparam ActionButton self The action button object
-- @tparam ?string|number text The text
-- @treturn ActionButton The action button object
function ActionButton.SetText(self, text)
	self.__super:SetText(text)
	self._defaultText = self:GetText()
	return self
end

--- Sets a script handler.
-- @see Element.SetScript
-- @tparam ActionButton self The action button object
-- @tparam string script The script to register for (currently only supports `OnClick`)
-- @tparam function handler The script handler which will be called with the action button object followed by any
-- arguments to the script
-- @treturn ActionButton The action button object
function ActionButton.SetScript(self, script, handler)
	if script == "OnClick" then
		self._onClickHandler = handler
	elseif script == "OnEnter" then
		self._onEnterHandler = handler
	elseif script == "OnLeave" then
		self._onLeaveHandler = handler
	elseif script == "OnMouseDown" or script == "OnMouseUp" then
		self.__super:SetScript(script, handler)
	else
		error("Unknown ActionButton script: "..tostring(script))
	end
	return self
end

--- Sets a script to propagate to the parent element.
-- @tparam ActionButton self The action button object
-- @tparam string script The script to propagate
-- @treturn ActionButton The action button object
function ActionButton.PropagateScript(self, script)
	if script == "OnMouseDown" or script == "OnMouseUp" then
		self.__super:PropagateScript(script)
	else
		error("Cannot propagate ActionButton script: "..tostring(script))
	end
	return self
end

--- Set whether or not the action button is disabled.
-- @tparam ActionButton self The action button object
-- @tparam boolean disabled Whether or not the action button should be disabled
-- @treturn ActionButton The action button object
function ActionButton.SetDisabled(self, disabled)
	self._disabled = disabled
	self:_UpdateDisabled()
	return self
end

--- Set whether or not the action button is pressed.
-- @tparam ActionButton self The action button object
-- @tparam boolean locked Whether or not to lock the action button's highlight
-- @tparam[opt=nil] string color The locked highlight color as a theme color key
-- @treturn ActionButton The action button object
function ActionButton.SetHighlightLocked(self, locked, color)
	self._locked = locked
	self._lockedColor = color
	if locked then
		self:_GetBaseFrame():LockHighlight()
	else
		self:_GetBaseFrame():UnlockHighlight()
	end
	return self
end

--- Set whether or not the action button is pressed.
-- @tparam ActionButton self The action button object
-- @tparam boolean pressed Whether or not the action button should be pressed
-- @treturn ActionButton The action button object
function ActionButton.SetPressed(self, pressed)
	self._pressed = pressed and private.GetModifierKey(IsShiftKeyDown(), IsControlKeyDown(), IsAltKeyDown()) or nil
	self:_UpdateDisabled()
	return self
end

--- Disables the default click cooldown to allow the button to be spammed (i.e. for macro-able buttons).
-- @tparam ActionButton self The action button object
-- @treturn ActionButton The action button object
function ActionButton.DisableClickCooldown(self)
	self._clickCooldownDisabled = true
	return self
end

function ActionButton.SetDefaultNoBackground(self)
	self._defaultNoBackground = true
	return self
end

function ActionButton.SetModifierText(self, text, ...)
	local key = private.GetModifierKey(private.ParseModifiers(...))
	assert(key and key ~= "NONE")
	self._modifierText[key] = text
	return self
end

--- Set whether a manual click (vs. a macro) is required.
-- @tparam ActionButton self The action button object
-- @tparam boolean required Whether or not a manual click is required
-- @treturn ActionButton The action button object
function ActionButton.SetRequireManualClick(self, required)
	self._manualRequired = required
	return self
end

--- Click on the action button.
-- @tparam ActionButton self The action button object
function ActionButton.Click(self)
	local frame = self:_GetBaseFrame()
	if frame:IsEnabled() and frame:IsVisible() then
		private.OnClick(self)
	end
end

function ActionButton.Draw(self)
	local maxRank, maxRankKey, numMaxRank = nil, nil, nil
	local currentModifier = self._pressed or private.GetModifierKey(IsShiftKeyDown(), IsControlKeyDown(), IsAltKeyDown())
	local currentShift, currentControl, currentAlt = private.ParseModifiers(strsplit("-", currentModifier))
	for key in pairs(self._modifierText) do
		local hasShift, hasControl, hasAlt = private.ParseModifiers(strsplit("-", key))
		if (not hasShift or currentShift) and (not hasControl or currentControl) and (not hasAlt or currentAlt) then
			-- this key matches the current state
			local rank = select("#", strsplit("-", key))
			if not maxRank or rank > maxRank then
				maxRank = rank
				numMaxRank = 1
				maxRankKey = key
			elseif rank == maxRank then
				numMaxRank = numMaxRank + 1
			end
		end
	end
	if maxRank then
		assert(numMaxRank == 1)
		self.__super:SetText(self._modifierText[maxRankKey])
	else
		self.__super:SetText(self._defaultText)
	end
	self.__super:Draw()

	local frame = self:_GetBaseFrame()

	-- set nine-slice and text color depending on the state
	local textColor, nineSliceTheme, nineSliceColor = nil, nil, nil
	if self._pressed or self._clickCooldown then
		textColor = Color.GetFullBlack()
		nineSliceTheme = "rounded"
		nineSliceColor = Theme.GetColor("INDICATOR")
	elseif self._disabled then
		textColor = Theme.GetColor("ACTIVE_BG_ALT")
		nineSliceTheme = "global"
		nineSliceColor = Theme.GetColor("ACTIVE_BG")
	elseif self._locked then
		textColor = Color.GetFullBlack()
		nineSliceTheme = "rounded"
		nineSliceColor = Theme.GetColor(self._lockedColor or "ACTIVE_BG+HOVER")
	elseif frame:IsMouseOver() then
		textColor = Theme.GetColor("TEXT")
		nineSliceTheme = "rounded"
		nineSliceColor = Theme.GetColor("ACTIVE_BG+HOVER")
	else
		textColor = self:_GetTextColor()
		if not self._defaultNoBackground then
			nineSliceTheme = "rounded"
			nineSliceColor = Theme.GetColor("ACTIVE_BG")
		end
	end
	frame.text:SetTextColor(textColor:GetFractionalRGBA())
	if nineSliceTheme then
		self._nineSlice:SetStyle(nineSliceTheme)
		self._nineSlice:SetVertexColor(nineSliceColor:GetFractionalRGBA())
	else
		self._nineSlice:Hide()
	end

	if self._iconTexturePack then
		TSM.UI.TexturePacks.SetTextureAndSize(frame.icon, self._iconTexturePack)
		frame.icon:Show()
		frame.icon:SetVertexColor(textColor:GetFractionalRGBA())
		local xOffset = self:GetText() ~= "" and ((TSM.UI.TexturePacks.GetWidth(self._iconTexturePack) + ICON_PADDING) / 2) or (self:_GetDimension("WIDTH") / 2)
		frame.text:ClearAllPoints()
		frame.text:SetPoint("TOP", xOffset, 0)
		frame.text:SetPoint("BOTTOM", xOffset, 0)
		frame.text:SetWidth(frame.text:GetStringWidth())
	else
		frame.icon:Hide()
		frame.text:ClearAllPoints()
		frame.text:SetPoint("TOPLEFT")
		frame.text:SetPoint("BOTTOMRIGHT")
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ActionButton._UpdateDisabled(self)
	local frame = self:_GetBaseFrame()
	if self._disabled or self._pressed or self._clickCooldown then
		frame:Disable()
	else
		frame:Enable()
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnClick(self)
	if not self._acquired then
		return
	end
	if self._manualRequired and not self._isMouseDown then
		return
	end
	self._isMouseDown = false
	if not self._clickCooldownDisabled then
		self._clickCooldown = CLICK_COOLDOWN
		self:_UpdateDisabled()
		ScriptWrapper.Set(self:_GetBaseFrame(), "OnUpdate", private.OnUpdate, self)
	end
	self:Draw()
	if self._onClickHandler then
		self:_onClickHandler()
	end
end

function private.OnMouseDown(self)
	self._isMouseDown = true
end

function private.OnEnter(self)
	if self._onEnterHandler then
		self:_onEnterHandler()
	end
	if self._disabled or self._pressed or self._clickCooldown then
		return
	end
	self:Draw()
end

function private.OnLeave(self)
	if not self:IsVisible() then
		return
	end
	if self._onLeaveHandler then
		self:_onLeaveHandler()
	end
	if self._disabled or self._pressed or self._clickCooldown then
		return
	end
	self:Draw()
end

function private.OnUpdate(self, elapsed)
	self._clickCooldown = self._clickCooldown - elapsed
	if self._clickCooldown <= 0 then
		ScriptWrapper.Clear(self:_GetBaseFrame(), "OnUpdate")
		self._clickCooldown = nil
		self:_UpdateDisabled()
		self:Draw()
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetModifierKey(hasShift, hasControl, hasAlt)
	if hasShift and hasControl and hasAlt then
		return "SHIFT-CTRL-ALT"
	elseif hasShift and hasControl then
		return "SHIFT-CTRL"
	elseif hasShift and hasAlt then
		return "SHIFT-ALT"
	elseif hasShift then
		return "SHIFT"
	elseif hasControl and hasAlt then
		return "CTRL-ALT"
	elseif hasControl then
		return "CTRL"
	elseif hasAlt then
		return "ALT"
	else
		return "NONE"
	end
end

function private.ParseModifiers(...)
	local hasShift, hasControl, hasAlt, hasNone = false, false, false, false
	for _, modifier in Vararg.Iterator(...) do
		if modifier == "SHIFT" then
			assert(not hasShift and not hasNone)
			hasShift = true
		elseif modifier == "CTRL" then
			assert(not hasControl and not hasNone)
			hasControl = true
		elseif modifier == "ALT" then
			assert(not hasAlt and not hasNone)
			hasAlt = true
		elseif modifier == "NONE" then
			assert(not hasShift and not hasControl and not hasAlt and not hasNone)
			hasNone = true
		else
			error("Invalid modifier: "..tostring(modifier))
		end
	end
	return hasShift, hasControl, hasAlt
end
