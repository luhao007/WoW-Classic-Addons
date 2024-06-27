-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- "What's New" Dialog
-- @module WhatsNew

local TSM = select(2, ...) ---@type TSM
local WhatsNew = TSM.UI:NewPackage("WhatsNew")
local L = TSM.Include("Locale").GetTable()
local Theme = TSM.Include("Util.Theme")
local Analytics = TSM.Include("Util.Analytics")
local Settings = TSM.Include("Service.Settings")
local UIElements = TSM.Include("UI.UIElements")
local private = {
	settings = nil,
	showTime = nil,
}
local WHATS_NEW_VERSION = 4
local CONTENT_LINES = {
	Theme.GetColor("INDICATOR"):ColorText(L["Retail Region-Wide Tracking"]).." "..L["In retail, there's a new option in the settings to get TSM to make inventory and accounting data available from every realm in your region."],
	Theme.GetColor("INDICATOR"):ColorText(L["Grouping Pets by Level"]).." "..L["You can now group pets by level, just like items."],
	Theme.GetColor("INDICATOR"):ColorText(L["Crafting UI Improvements"]).." "..L["Many UI improvements have been made to the Dragonflight crafting experience, including support for mass milling / prospecting and easier quality and optional material selection."],
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function WhatsNew.OnInitialize()
	private.settings = Settings.NewView()
		:AddKey("global", "internalData", "whatsNewVersion")
end

function WhatsNew.GetDialog()
	if private.settings.whatsNewVersion == WHATS_NEW_VERSION then
		return
	end
	private.showTime = GetTime()
	return UIElements.New("Frame", "whatsnew")
		:SetLayout("VERTICAL")
		:SetSize(650, 300)
		:SetPadding(12, 12, 0, 12)
		:AddAnchor("CENTER")
		:SetRoundedBackgroundColor("FRAME_BG")
		:AddChild(UIElements.New("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(0, 0, 8, 16)
			:AddChild(UIElements.New("Spacer", "spacer")
				:SetWidth(20)
			)
			:AddChild(UIElements.New("Text", "title")
				:SetJustifyH("CENTER")
				:SetFont("BODY_BODY1_BOLD")
				:SetFormattedText(L["TSM %s: What's new"], "4.13")
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetMargin(0, -4, 0, 0)
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.DialogCloseBtnOnClick)
			)
		)
		:AddChild(UIElements.New("ScrollFrame", "body")
			:AddChild(UIElements.New("Text", "content1")
				:SetHeight(200)
				:SetFont("BODY_BODY2")
				:SetText(table.concat(CONTENT_LINES, "\n\n"))
			)
		)
		:AddChild(UIElements.New("Text", "footer1")
			:SetHeight(20)
			:SetMargin(0, 0, 12, 0)
			:SetFont("BODY_BODY3")
			:SetFormattedText(L["For more info, visit %s. For help, join us in Discord: %s."], Theme.GetColor("INDICATOR_ALT"):ColorText("blog.tradeskillmaster.com"), Theme.GetColor("INDICATOR_ALT"):ColorText("discord.gg/woweconomy"))
		)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.DialogCloseBtnOnClick(button)
	private.settings.whatsNewVersion = WHATS_NEW_VERSION
	button:GetBaseElement():HideDialog()
	Analytics.Action("WHATS_NEW_TIME", floor((GetTime() - private.showTime) * 1000), WHATS_NEW_VERSION)
end
