-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- ProgressBar UI Element Class.
-- The progress bar element is a left-to-right progress bar with an anaimated progress indicator and text. It is a
-- subclass of the @{Text} class.
-- @classmod ProgressBar

local _, TSM = ...
local Theme = TSM.Include("Util.Theme")
local UIElements = TSM.Include("UI.UIElements")
local ProgressBar = TSM.Include("LibTSMClass").DefineClass("ProgressBar", TSM.UI.Text)
UIElements.Register(ProgressBar)
TSM.UI.ProgressBar = ProgressBar
local PROGRESS_PADDING = 2
local PROGRESS_ICON_PADDING = 4



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ProgressBar.__init(self)
	local frame = UIElements.CreateFrame(self, "Frame")

	self.__super:__init(frame)

	self._bgLeft = frame:CreateTexture(nil, "BACKGROUND")
	self._bgLeft:SetPoint("TOPLEFT")
	self._bgLeft:SetPoint("BOTTOMLEFT")
	TSM.UI.TexturePacks.SetTextureAndWidth(self._bgLeft, "uiFrames.LoadingBarLeft")

	self._bgRight = frame:CreateTexture(nil, "BACKGROUND")
	self._bgRight:SetPoint("TOPRIGHT")
	self._bgRight:SetPoint("BOTTOMRIGHT")
	TSM.UI.TexturePacks.SetTextureAndWidth(self._bgRight, "uiFrames.LoadingBarRight")

	self._bgMiddle = frame:CreateTexture(nil, "BACKGROUND")
	self._bgMiddle:SetPoint("TOPLEFT", self._bgLeft, "TOPRIGHT")
	self._bgMiddle:SetPoint("BOTTOMRIGHT", self._bgRight, "BOTTOMLEFT")
	TSM.UI.TexturePacks.SetTexture(self._bgMiddle, "uiFrames.LoadingBarMiddle")

	-- create the progress textures
	self._progressLeft = frame:CreateTexture(nil, "ARTWORK")
	self._progressLeft:SetPoint("TOPLEFT", PROGRESS_PADDING, -PROGRESS_PADDING)
	self._progressLeft:SetPoint("BOTTOMLEFT", PROGRESS_PADDING, PROGRESS_PADDING)
	self._progressLeft:SetBlendMode("BLEND")
	TSM.UI.TexturePacks.SetTexture(self._progressLeft, "uiFrames.LoadingBarLeft")

	self._progressMiddle = frame:CreateTexture(nil, "ARTWORK")
	self._progressMiddle:SetPoint("TOPLEFT", self._progressLeft, "TOPRIGHT")
	self._progressMiddle:SetPoint("BOTTOMLEFT", self._progressLeft, "BOTTOMRIGHT")
	self._progressMiddle:SetBlendMode("BLEND")
	TSM.UI.TexturePacks.SetTexture(self._progressMiddle, "uiFrames.LoadingBarMiddle")

	self._progressRight = frame:CreateTexture(nil, "ARTWORK")
	self._progressRight:SetPoint("TOPLEFT", self._progressMiddle, "TOPRIGHT")
	self._progressRight:SetPoint("BOTTOMLEFT", self._progressMiddle, "BOTTOMRIGHT")
	self._progressRight:SetBlendMode("BLEND")
	TSM.UI.TexturePacks.SetTexture(self._progressRight, "uiFrames.LoadingBarRight")

	-- create the progress icon
	frame.progressIcon = frame:CreateTexture(nil, "OVERLAY")
	frame.progressIcon:SetPoint("RIGHT", frame.text, "LEFT", -PROGRESS_ICON_PADDING, 0)
	frame.progressIcon:Hide()

	frame.progressIcon.ag = frame.progressIcon:CreateAnimationGroup()
	local spin = frame.progressIcon.ag:CreateAnimation("Rotation")
	spin:SetDuration(2)
	spin:SetDegrees(360)
	frame.progressIcon.ag:SetLooping("REPEAT")

	self._progress = 0
	self._progressIconHidden = false
	self._justifyH = "CENTER"
	self._font = "BODY_BODY2_MEDIUM"
	self._textColor = "INDICATOR"
end

function ProgressBar.Release(self)
	self._progress = 0
	self._progressIconHidden = false
	self:_GetBaseFrame().progressIcon.ag:Stop()
	self:_GetBaseFrame().progressIcon:Hide()
	self.__super:Release()
	self._justifyH = "CENTER"
	self._font = "BODY_BODY2_MEDIUM"
	self._textColor = "INDICATOR"
end

--- Sets the progress.
-- @tparam ProgressBar self The progress bar object
-- @tparam number progress The progress from a value of 0 to 1 (inclusive)
-- @tparam boolean isDone Whether or not the progress is finished
-- @treturn ProgressBar The progress bar object
function ProgressBar.SetProgress(self, progress, isDone)
	self._progress = progress
	return self
end

--- Sets whether or not the progress indicator is hidden.
-- @tparam ProgressBar self The progress bar object
-- @tparam boolean hidden Whether or not the progress indicator is hidden
-- @treturn ProgressBar The progress bar object
function ProgressBar.SetProgressIconHidden(self, hidden)
	self._progressIconHidden = hidden
	return self
end

function ProgressBar.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()

	self._bgLeft:SetVertexColor(Theme.GetColor("PRIMARY_BG"):GetFractionalRGBA())
	self._bgMiddle:SetVertexColor(Theme.GetColor("PRIMARY_BG"):GetFractionalRGBA())
	self._bgRight:SetVertexColor(Theme.GetColor("PRIMARY_BG"):GetFractionalRGBA())

	local text = frame.text
	text:ClearAllPoints()
	text:SetWidth(self:_GetDimension("WIDTH"))
	text:SetWidth(frame.text:GetStringWidth())
	text:SetHeight(self:_GetDimension("HEIGHT"))
	text:SetPoint("CENTER", self._progressIconHidden and 0 or ((TSM.UI.TexturePacks.GetWidth("iconPack.18x18/Running") + PROGRESS_ICON_PADDING) / 2), 0)

	TSM.UI.TexturePacks.SetTextureAndSize(frame.progressIcon, "iconPack.18x18/Running")
	frame.progressIcon:SetVertexColor(self:_GetTextColor():GetFractionalRGBA())
	if self._progressIconHidden and frame.progressIcon:IsVisible() then
		frame.progressIcon.ag:Stop()
		frame.progressIcon:Hide()
	elseif not self._progressIconHidden and not frame.progressIcon:IsVisible() then
		frame.progressIcon:Show()
		frame.progressIcon.ag:Play()
	end

	if self._progress == 0 then
		self._progressLeft:Hide()
		self._progressMiddle:Hide()
		self._progressRight:Hide()
	else
		self._progressLeft:Show()
		self._progressMiddle:Show()
		self._progressRight:Show()
		self._progressLeft:SetVertexColor(Theme.GetColor("ACTIVE_BG"):GetFractionalRGBA())
		self._progressMiddle:SetVertexColor(Theme.GetColor("ACTIVE_BG"):GetFractionalRGBA())
		self._progressRight:SetVertexColor(Theme.GetColor("ACTIVE_BG"):GetFractionalRGBA())
		local leftTextureWidth = TSM.UI.TexturePacks.GetWidth("uiFrames.LoadingBarLeft")
		local rightTextureWidth = TSM.UI.TexturePacks.GetWidth("uiFrames.LoadingBarRight")
		local maxProgressWidth = self:_GetDimension("WIDTH") - PROGRESS_PADDING * 2
		local progressWidth = maxProgressWidth * self._progress
		if progressWidth <= leftTextureWidth then
			self._progressLeft:SetWidth(progressWidth)
			self._progressMiddle:Hide()
			self._progressRight:Hide()
		elseif progressWidth < maxProgressWidth - rightTextureWidth then
			self._progressLeft:SetWidth(leftTextureWidth)
			self._progressMiddle:SetWidth(progressWidth - leftTextureWidth)
			self._progressRight:Hide()
		else
			self._progressLeft:SetWidth(leftTextureWidth)
			self._progressMiddle:SetWidth(progressWidth - leftTextureWidth - rightTextureWidth)
			self._progressRight:SetWidth(rightTextureWidth)
		end
	end
end
