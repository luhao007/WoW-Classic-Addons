-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

--- "What's New" Dialog
-- @module WhatsNew

local _, TSM = ...
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
local WHATS_NEW_VERSION = 2
local CONTENT_LINES = {
	Theme.GetColor("INDICATOR"):ColorText(L["Full Shadowlands Profession Support"]).." "..L["This includes support for optional reagents for your recipes as well as legendary craft ranks."],
	Theme.GetColor("INDICATOR"):ColorText(L["Improved Group & Item Management."]).." "..L["Now you can drag and drop selected items between Groups, without needing to remove them or have them on hand."],
	Theme.GetColor("INDICATOR"):ColorText(L["Custom Themes."]).." "..L["We've added the option to customise the colour palette to your own preferences, including the ability to export a string to share with your friends to import."],
	Theme.GetColor("INDICATOR"):ColorText(L["Addon Optimisations."]).." "..L["Various under-the-hood tweaks and tuning have been implemented, with an aim to improve stability and reduce lag throughout the addon."],
	Theme.GetColor("INDICATOR"):ColorText(L["DBRegionMinBuyoutAvg Retired."]).." "..L["The DBRegionMinBuyoutAvg price source has been retired, it can be removed from any operation or custom string you are using."],
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
		:SetSize(650, 390)
		:SetPadding(12, 12, 0, 12)
		:AddAnchor("CENTER")
		:SetBackgroundColor("FRAME_BG", true)
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
				:SetFormattedText(L["TSM %s: What's new"], "4.11")
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetMargin(0, -4, 0, 0)
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.DialogCloseBtnOnClick)
			)
		)
		:AddChild(UIElements.New("ScrollFrame", "body")
			:AddChild(UIElements.New("Text", "content1")
				:SetHeight(290)
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
