-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local LibTSMUI = select(2, ...).LibTSMUI
local Tooltip = LibTSMUI:Include("Tooltip")
local UIElements = LibTSMUI:Include("Util.UIElements")
local L = LibTSMUI.Locale.GetTable()
local Math = LibTSMUI:From("LibTSMUtil"):Include("Lua.Math")
local TempTable = LibTSMUI:From("LibTSMUtil"):Include("BaseType.TempTable")
local Table = LibTSMUI:From("LibTSMUtil"):Include("Lua.Table")
local ClientInfo = LibTSMUI:From("LibTSMWoW"):Include("Util.ClientInfo")
local SessionInfo = LibTSMUI:From("LibTSMWoW"):Include("Util.SessionInfo")
local Theme = LibTSMUI:From("LibTSMService"):Include("UI.Theme")
local TextureAtlas = LibTSMUI:From("LibTSMService"):Include("UI.TextureAtlas")
local private = {}
local SECONDS_PER_HOUR = 60 * 60
local SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR
local APP_UPDATE_AGE_WARNING = SECONDS_PER_HOUR
local APP_UPDATE_AGE_ERROR = SECONDS_PER_DAY
local AUCTIONDB_REALM_AGE_WARNING = 12 * SECONDS_PER_HOUR
local AUCTIONDB_REALM_AGE_ERROR = 7 * SECONDS_PER_DAY
local AUCTIONDB_REGION_AGE_ERROR = 7 * SECONDS_PER_DAY
local CONTENT_FRAME_OFFSET = 8
local DIALOG_RELATIVE_LEVEL = 18
local HEADER_HEIGHT = 40
local MIN_SCALE = 0.3
local DIALOG_OPACITY_PCT = 65
local MIN_ON_SCREEN_PX = 50
local CORNER_RADIUS = 6
local function NoOp() end



-- ============================================================================
-- Element Definition
-- ============================================================================

local ApplicationFrame = UIElements.Define("ApplicationFrame", "Frame")



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ApplicationFrame:__init()
	self.__super:__init()
	self._contentFrame = nil
	self._contextTable = nil
	self._defaultContextTable = nil
	self._isScaling = nil
	self._protected = nil
	self._minWidth = 0
	self._minHeight = 0
	self._dialogStack = {}
	self._appRegion = "???"
	self._appTimes = {
		sync = 0,
		realm = 0,
		region = 0,
	}

	local frame = self:_GetBaseFrame()
	local globalFrameName = tostring(frame)
	_G[globalFrameName] = frame
	-- Insert our frames before other addons (i.e. Skillet) to avoid conflicts
	tinsert(UISpecialFrames, 1, globalFrameName)

	self._backgroundTexture = self:_CreateRectangle()
	self._backgroundTexture:SetCornerRadius(CORNER_RADIUS)

	frame.resizeIcon = self:_CreateTexture(frame)
	frame.resizeIcon:SetPoint("BOTTOMRIGHT")
	frame.resizeIcon:TSMSetTextureAndSize("iconPack.14x14/Resize")

	frame.resizeBtn = self:_CreateButton(frame)
	frame.resizeBtn:SetAllPoints(frame.resizeIcon)
	frame.resizeBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	frame.resizeBtn:TSMSetScript("OnEnter", private.ResizeOnEnter)
	frame.resizeBtn:TSMSetScript("OnLeave", private.ResizeOnLeave)
	frame.resizeBtn:TSMSetScript("OnMouseDown", self:__closure("_HandleResizeMouseDown"))
	frame.resizeBtn:TSMSetScript("OnMouseUp", self:__closure("_HandleResizeMouseUp"))
	frame.resizeBtn:TSMSetScript("OnClick", self:__closure("_HandleResizeClick"))
	Theme.RegisterChangeCallback(function()
		if self:IsVisible() then
			self:Draw()
		end
	end)
end

function ApplicationFrame:Acquire()
	self:AddChildNoLayout(UIElements.New("Frame", "titleFrame")
		:SetLayout("HORIZONTAL")
		:SetHeight(24)
		:AddAnchor("TOPLEFT", 8, -8)
		:AddAnchor("TOPRIGHT", -8, -8)
		:SetBackgroundColor("FRAME_BG")
		:AddChild(UIElements.New("Texture", "icon")
			:SetMargin(0, 16, 0, 0)
			:SetTextureAndSize("uiFrames.SmallLogo")
		)
		:AddChild(UIElements.New("Text", "title")
			:AddAnchor("CENTER")
			:SetWidth("AUTO")
			:SetFont("BODY_BODY2_BOLD")
			:SetTextColor("TEXT_ALT")
		)
		:AddChild(UIElements.New("Spacer", "spacer"))
		:AddChild(UIElements.New("Button", "closeBtn")
			:SetBackgroundAndSize("iconPack.24x24/Close/Default")
			:SetScript("OnClick", private.CloseButtonOnClick)
		)
	)
	self.__super:Acquire()
	local frame = self:_GetBaseFrame()
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", self:__closure("_HandleDragStart"))
	self:SetScript("OnDragStop", self:__closure("_HandleDragStop"))

	self._backgroundTexture:SubscribeColor("FRAME_BG")
end

function ApplicationFrame:Release()
	if self._protected then
		tinsert(UISpecialFrames, 1, tostring(self:_GetBaseFrame()))
	end
	self._contentFrame = nil
	self._contextTable = nil
	self._defaultContextTable = nil
	self:_GetBaseFrame():SetResizeBounds(0, 0, 0, 0)
	self._isScaling = nil
	self._protected = nil
	self._minWidth = 0
	self._minHeight = 0
	self._appRegion = "???"
	self._appTimes.sync = 0
	self._appTimes.realm = 0
	self._appTimes.region = 0
	self.__super:Release()
end

---Adds player gold text to the title frame.
---@param settings SettingsView The settings view to pass to `PlayerGoldText:SetSettings()`
---@return ApplicationFrame
function ApplicationFrame:AddPlayerGold(settings)
	local titleFrame = self:GetElement("titleFrame")
	local prevId = titleFrame:HasChildById("switchBtn") and "switchBtn" or "closeBtn"
	titleFrame:AddChildBeforeById(prevId, UIElements.New("PlayerGoldText", "playerGold")
		:SetWidth("AUTO")
		:SetMargin(0, 8, 0, 0)
		:SetSettings(settings)
	)
	return self
end

---Adds the app status icon to the title frame.
---@return ApplicationFrame
---@param regionName string The name of the current region
---@param syncTime number The last sync
---@param realmTime number The last realm data update
---@param regionTime number The last region data update
---@return ApplicationFrame
function ApplicationFrame:AddAppStatusIcon(regionName, syncTime, realmTime, regionTime)
	self._appRegion = regionName
	self._appTimes.sync = syncTime
	self._appTimes.realm = realmTime
	self._appTimes.region = regionTime
	local color, texture = nil, nil
	local appUpdateAge = LibTSMUI.GetTime() - syncTime
	local auctionDBRealmAge = LibTSMUI.GetTime() - realmTime
	local auctionDBRegionAge = LibTSMUI.GetTime() - regionTime
	if appUpdateAge >= APP_UPDATE_AGE_ERROR or auctionDBRealmAge > AUCTIONDB_REALM_AGE_ERROR or auctionDBRegionAge > AUCTIONDB_REALM_AGE_ERROR then
		color = "FEEDBACK_RED"
		texture = "iconPack.14x14/Attention"
	elseif appUpdateAge >= APP_UPDATE_AGE_WARNING or auctionDBRealmAge >= AUCTIONDB_REALM_AGE_WARNING then
		color = "FEEDBACK_YELLOW"
		texture = "iconPack.14x14/Attention"
	else
		color = "FEEDBACK_GREEN"
		texture = "iconPack.14x14/Checkmark/Circle"
	end
	local titleFrame = self:GetElement("titleFrame")
	titleFrame:AddChildBeforeById("playerGold", UIElements.New("Button", "appStatus")
		:SetBackgroundAndSize(TextureAtlas.GetColoredKey(texture, color))
		:SetMargin(0, 8, 0, 0)
		:SetTooltip(self:__closure("_GetAppStatusTooltip"))
	)
	return self
end

---Adds a switch button to the title frame.
---@param onClickHandler function The handler for the OnClick script for the button
---@return ApplicationFrame
function ApplicationFrame:AddSwitchButton(onClickHandler)
	local titleFrame = self:GetElement("titleFrame")
	titleFrame:AddChildBeforeById("closeBtn", UIElements.New("ActionButton", "switchBtn")
		:SetSize(95, 20)
		:SetMargin(0, 8, 0, 0)
		:SetFont("BODY_BODY3_MEDIUM")
		:SetText(L["WOW UI"])
		:SetScript("OnClick", onClickHandler)
	)
	return self
end

---Sets whether or not the frame is protected (doesn't close with ESC).
---@param protected boolean
---@return ApplicationFrame
function ApplicationFrame:SetProtected(protected)
	self._protected = protected
	local globalFrameName = tostring(self:_GetBaseFrame())
	if protected then
		Table.RemoveByValue(UISpecialFrames, globalFrameName)
	else
		if not Table.KeyByValue(UISpecialFrames, globalFrameName) then
			-- Insert our frames before other addons (i.e. Skillet) to avoid conflicts
			tinsert(UISpecialFrames, 1, globalFrameName)
		end
	end
	return self
end

---Sets the title text.
---@param title string The title text
---@return ApplicationFrame
function ApplicationFrame:SetTitle(title)
	local titleFrame = self:GetElement("titleFrame")
	titleFrame:GetElement("title"):SetText(title)
	titleFrame:Draw()
	return self
end

---Sets the content frame.
---@param frame Frame The frame's content frame
---@return ApplicationFrame
function ApplicationFrame:SetContentFrame(frame)
	assert(UIElements.IsType(frame, "Frame"))
	frame:WipeAnchors()
	frame:AddAnchor("TOPLEFT", CONTENT_FRAME_OFFSET, -HEADER_HEIGHT)
	frame:AddAnchor("BOTTOMRIGHT", -CONTENT_FRAME_OFFSET, CONTENT_FRAME_OFFSET)
	frame:SetPadding(2)
	frame:SetBorderColor("ACTIVE_BG", 2)
	self._contentFrame = frame
	self:AddChildNoLayout(frame)
	return self
end

---Sets the context table which is used to persist position and size info.
---@param tbl table The context table
---@param defaultTbl table Default values (required attributes: `width`, `height`, `centerX`, `centerY`)
---@return ApplicationFrame
function ApplicationFrame:SetContextTable(tbl, defaultTbl)
	assert(defaultTbl.width > 0 and defaultTbl.height > 0)
	assert(defaultTbl.centerX and defaultTbl.centerY)
	tbl.width = tbl.width or defaultTbl.width
	tbl.height = tbl.height or defaultTbl.height
	tbl.centerX = tbl.centerX or defaultTbl.centerX
	tbl.centerY = tbl.centerY or defaultTbl.centerY
	tbl.scale = tbl.scale or defaultTbl.scale
	self._contextTable = tbl
	self._defaultContextTable = defaultTbl
	return self
end

---Sets the context table from a settings object.
---@param settings Settings The settings object
---@param key string The setting key
---@return ApplicationFrame
function ApplicationFrame:SetSettingsContext(settings, key)
	return self:SetContextTable(settings[key], settings:GetDefaultReadOnly(key))
end

---Sets the minimum size the application frame can be resized to.
---@param minWidth number The minimum width
---@param minHeight number The minimum height
---@return ApplicationFrame
function ApplicationFrame:SetMinResize(minWidth, minHeight)
	self._minWidth = minWidth
	self._minHeight = minHeight
	return self
end

---Shows a dialog frame.
---@param frame Element The element to show in a dialog
---@param context any The context to set on the dialog frame
function ApplicationFrame:ShowDialogFrame(frame, context)
	local dialogFrame = UIElements.New("Frame", "_dialog_"..random(1, 1000000))
		:SetRelativeLevel(DIALOG_RELATIVE_LEVEL * (#self._dialogStack + 1))
		:SetBackgroundColor("FULL_BLACK%"..DIALOG_OPACITY_PCT)
		:AddAnchor("TOPLEFT")
		:AddAnchor("BOTTOMRIGHT")
		:SetMouseEnabled(true)
		:SetMouseWheelEnabled(true)
		:SetContext(context)
		:SetScript("OnMouseWheel", NoOp)
		:SetScript("OnMouseUp", private.DialogOnMouseUp)
		:SetScript("OnHide", private.DialogOnHide)
		:AddChildNoLayout(frame)
	tinsert(self._dialogStack, dialogFrame)
	self._contentFrame:AddChildNoLayout(dialogFrame)
	dialogFrame:Show()
	dialogFrame:Draw()
end

---Show a confirmation dialog.
---@param title string The title of the dialog
---@param subTitle string The sub-title of the dialog
---@param callback function The callback for when the dialog is closed
---@param ... any Arguments to pass to the callback
function ApplicationFrame:ShowConfirmationDialog(title, subTitle, callback, ...)
	local context = TempTable.Acquire(...)
	context.callback = callback
	local frame = UIElements.New("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetSize(328, 158)
		:SetPadding(12, 12, 8, 12)
		:AddAnchor("CENTER")
		:SetRoundedBackgroundColor("FRAME_BG")
		:SetMouseEnabled(true)
		:AddChild(UIElements.New("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:AddChild(UIElements.New("Text", "title")
				:SetHeight(20)
				:SetMargin(32, 8, 0, 0)
				:SetFont("BODY_BODY2_BOLD")
				:SetJustifyH("CENTER")
				:SetText(title)
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.DialogCancelBtnOnClick)
			)
		)
		:AddChild(UIElements.New("Text", "desc")
			:SetMargin(0, 0, 16, 16)
			:SetFont("BODY_BODY3")
			:SetJustifyH("LEFT")
			:SetJustifyV("TOP")
			:SetText(subTitle)
		)
		:AddChild(UIElements.New("ActionButton", "confirmBtn")
			:SetHeight(24)
			:SetText(L["Confirm"])
			:SetScript("OnClick", private.DialogConfirmBtnOnClick)
		)
	self:ShowDialogFrame(frame, context)
end

---Show a dialog triggered by a "more" button.
---@param moreBtn Button The "more" button
---@param iter function A dialog menu row iterator with the following fields: `index, text, callback`
function ApplicationFrame:ShowMoreButtonDialog(moreBtn, iter)
	local frame = UIElements.New("PopupFrame", "moreDialog")
		:SetLayout("VERTICAL")
		:SetWidth(200)
		:SetPadding(0, 0, 8, 4)
		:AddAnchor("TOPRIGHT", moreBtn, "BOTTOM", 22, -16)
	local numRows = 0
	for i, text, callback in iter do
		frame:AddChild(UIElements.New("Button", "row"..i)
			:SetHeight(20)
			:SetFont("BODY_BODY2_MEDIUM")
			:SetText(text)
			:SetScript("OnClick", callback)
		)
		numRows = numRows + 1
	end
	frame:SetHeight(12 + numRows * 20)
	self:ShowDialogFrame(frame)
end

---Hides the current dialog.
function ApplicationFrame:HideDialog()
	local dialogFrame = tremove(self._dialogStack)
	if not dialogFrame then
		return
	end
	dialogFrame:GetParentElement():RemoveChild(dialogFrame)
end

function ApplicationFrame:Draw()
	local frame = self:_GetBaseFrame()
	frame:SetToplevel(true)
	frame:Raise()

	-- update the size if it's less than the set min size
	assert(self._minWidth > 0 and self._minHeight > 0)
	self._contextTable.width = max(self._contextTable.width, self._minWidth)
	self._contextTable.height = max(self._contextTable.height, self._minHeight)
	self._contextTable.scale = max(self._contextTable.scale, MIN_SCALE)

	-- set the frame size from the contextTable
	self:SetScale(self._contextTable.scale)
	self:SetSize(self._contextTable.width, self._contextTable.height)

	-- make sure at least 50px of the frame is on the screen and offset by at least 1 scaled pixel to fix some rendering issues
	local maxAbsCenterX = (UIParent:GetWidth() / self._contextTable.scale + self._contextTable.width) / 2 - MIN_ON_SCREEN_PX
	local maxAbsCenterY = (UIParent:GetHeight() / self._contextTable.scale + self._contextTable.height) / 2 - MIN_ON_SCREEN_PX
	local effectiveScale = UIParent:GetEffectiveScale()
	if self._contextTable.centerX < 0 then
		self._contextTable.centerX = min(max(self._contextTable.centerX, -maxAbsCenterX), -effectiveScale)
	else
		self._contextTable.centerX = max(min(self._contextTable.centerX, maxAbsCenterX), effectiveScale)
	end
	if self._contextTable.centerY < 0 then
		self._contextTable.centerY = min(max(self._contextTable.centerY, -maxAbsCenterY), -effectiveScale)
	else
		self._contextTable.centerY = max(min(self._contextTable.centerY, maxAbsCenterY), effectiveScale)
	end

	-- adjust the position of the frame based on the UI scale to make rendering more consistent
	self._contextTable.centerX = Math.Round(self._contextTable.centerX, effectiveScale)
	self._contextTable.centerY = Math.Round(self._contextTable.centerY, effectiveScale)

	-- set the frame position from the contextTable
	self:WipeAnchors()
	self:AddAnchor("CENTER", self._contextTable.centerX, self._contextTable.centerY)

	self.__super:Draw()
end



-- ============================================================================
-- Protected/Private Class Methods
-- ============================================================================

function ApplicationFrame.__private:_SavePositionAndSize(wasScaling)
	local frame = self:_GetBaseFrame()
	local parentFrame = frame:GetParent()
	local width = frame:GetWidth()
	local height = frame:GetHeight()
	if wasScaling then
		-- the anchor is in our old frame's scale, so convert the parent measurements to our old scale and then the resuslt to our new scale
		local scaleAdjustment = width / self._contextTable.width
		local frameLeftOffset = frame:GetLeft() - parentFrame:GetLeft() / self._contextTable.scale
		self._contextTable.centerX = (frameLeftOffset - (parentFrame:GetWidth() / self._contextTable.scale - width) / 2) / scaleAdjustment
		local frameBottomOffset = frame:GetBottom() - parentFrame:GetBottom() / self._contextTable.scale
		self._contextTable.centerY = (frameBottomOffset - (parentFrame:GetHeight() / self._contextTable.scale - height) / 2) / scaleAdjustment
		self._contextTable.scale = self._contextTable.scale * scaleAdjustment
	else
		self._contextTable.width = width
		self._contextTable.height = height
		-- the anchor is in our frame's scale, so convert the parent measurements to our scale
		local frameLeftOffset = frame:GetLeft() - parentFrame:GetLeft() / self._contextTable.scale
		self._contextTable.centerX = (frameLeftOffset - (parentFrame:GetWidth() / self._contextTable.scale - width) / 2)
		local frameBottomOffset = frame:GetBottom() - parentFrame:GetBottom() / self._contextTable.scale
		self._contextTable.centerY = (frameBottomOffset - (parentFrame:GetHeight() / self._contextTable.scale - height) / 2)
	end
end

function ApplicationFrame.__protected:_SetResizing(resizing)
	if resizing then
		self:GetElement("titleFrame"):Hide()
		self._contentFrame:_GetBaseFrame():SetAlpha(0)
		self._contentFrame:_GetBaseFrame():SetFrameStrata("LOW")
		self._contentFrame:Draw()
	else
		self:GetElement("titleFrame"):Show()
		self._contentFrame:_GetBaseFrame():SetAlpha(1)
		self._contentFrame:_GetBaseFrame():SetFrameStrata(self._strata)
	end
end

function ApplicationFrame.__private:_GetAppStatusTooltip()
	local tooltipLines = TempTable.Acquire()
	local regionRealmName = self._appRegion.."-"..SessionInfo.GetRealmName()
	if not ClientInfo.HasFeature(ClientInfo.FEATURES.CONNECTED_FACTION_AH) then
		regionRealmName = regionRealmName.."-"..SessionInfo.GetFactionName()
	end
	tinsert(tooltipLines, format(L["TSM Desktop App Status (%s)"], regionRealmName))

	local appUpdateAge = LibTSMUI.GetTime() - self._appTimes.sync
	if appUpdateAge < APP_UPDATE_AGE_WARNING then
		tinsert(tooltipLines, Theme.GetColor("FEEDBACK_GREEN"):ColorText(format(L["App Synced %s Ago"], SecondsToTime(appUpdateAge))))
	elseif appUpdateAge < APP_UPDATE_AGE_ERROR then
		tinsert(tooltipLines, Theme.GetColor("FEEDBACK_YELLOW"):ColorText(format(L["App Synced %s Ago"], SecondsToTime(appUpdateAge))))
	else
		tinsert(tooltipLines, Theme.GetColor("FEEDBACK_RED"):ColorText(L["App Not Synced"]))
	end

	local auctionDBRealmAge = LibTSMUI.GetTime() - self._appTimes.realm
	local auctionDBRegionAge = LibTSMUI.GetTime() - self._appTimes.region
	if auctionDBRealmAge < AUCTIONDB_REALM_AGE_WARNING then
		tinsert(tooltipLines, Theme.GetColor("FEEDBACK_GREEN"):ColorText(format(L["AuctionDB Realm Data is %s Old"], SecondsToTime(auctionDBRealmAge))))
	elseif auctionDBRealmAge < AUCTIONDB_REALM_AGE_ERROR then
		tinsert(tooltipLines, Theme.GetColor("FEEDBACK_YELLOW"):ColorText(format(L["AuctionDB Realm Data is %s Old"], SecondsToTime(auctionDBRealmAge))))
	else
		tinsert(tooltipLines, Theme.GetColor("FEEDBACK_RED"):ColorText(L["No AuctionDB Realm Data"]))
	end
	if auctionDBRegionAge < AUCTIONDB_REGION_AGE_ERROR then
		tinsert(tooltipLines, Theme.GetColor("FEEDBACK_GREEN"):ColorText(format(L["AuctionDB Region Data is %s Old"], SecondsToTime(auctionDBRegionAge))))
	else
		tinsert(tooltipLines, Theme.GetColor("FEEDBACK_RED"):ColorText(L["No AuctionDB Region Data"]))
	end

	return strjoin("\n", TempTable.UnpackAndRelease(tooltipLines)), true, 16
end

function ApplicationFrame.__private:_HandleResizeMouseDown(_, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	self._isScaling = IsShiftKeyDown()
	local frame = self:_GetBaseFrame()
	local width = frame:GetWidth()
	local height = frame:GetHeight()
	if self._isScaling then
		local minWidth = width * MIN_SCALE / self._contextTable.scale
		local minHeight = height * MIN_SCALE / self._contextTable.scale
		frame:SetResizeBounds(minWidth, minHeight, width * 10, height * 10)
	else
		frame:SetResizeBounds(self._minWidth, self._minHeight, width * 10, height * 10)
	end
	self:_SetResizing(true)
	frame:StartSizing("BOTTOMRIGHT", true)
end

function ApplicationFrame.__private:_HandleResizeMouseUp(_, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	self:_GetBaseFrame():StopMovingOrSizing()
	self:_SetResizing(false)
	self:_SavePositionAndSize(self._isScaling)
	self._isScaling = nil
	self:Draw()
end

function ApplicationFrame.__private:_HandleResizeClick(_, mouseButton)
	if mouseButton ~= "RightButton" then
		return
	end
	self._contextTable.scale = self._defaultContextTable.scale
	self._contextTable.width = self._defaultContextTable.width
	self._contextTable.height = self._defaultContextTable.height
	self._contextTable.centerX = self._defaultContextTable.centerX
	self._contextTable.centerY = self._defaultContextTable.centerY
	self:Draw()
end

function ApplicationFrame.__private:_HandleDragStart()
	self:_GetBaseFrame():StartMoving()
end

function ApplicationFrame.__private:_HandleDragStop()
	self:_GetBaseFrame():StopMovingOrSizing()
	self:_SavePositionAndSize()
	self:Draw()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ResizeOnEnter(btn)
	local text = strjoin("\n",
		L["Click and drag to resize this window."],
		L["Hold SHIFT while dragging to scale the window instead."],
		L["Right-Click to reset the window size, scale, and position to their defaults."]
	)
	Tooltip.Show(btn, text, true)
end

function private.ResizeOnLeave()
	Tooltip.Hide()
end

function private.CloseButtonOnClick(button)
	button:GetElement("__parent.__parent"):Hide()
end

function private.DialogOnMouseUp(dialog)
	dialog:GetParentElement():GetParentElement():HideDialog()
end

function private.DialogOnHide(dialog)
	local context = dialog:GetContext()
	if context then
		TempTable.Release(context)
	end
end

function private.DialogCancelBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end

function private.DialogConfirmBtnOnClick(button)
	local self = button:GetBaseElement()
	local dialogFrame = button:GetParentElement():GetParentElement()
	local context = dialogFrame:GetContext()
	dialogFrame:SetContext(nil)
	self:HideDialog()
	context.callback(TempTable.UnpackAndRelease(context))
end
