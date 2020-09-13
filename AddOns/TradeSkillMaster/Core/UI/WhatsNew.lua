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
local WHATS_NEW_VERSION = 1
local CONTENT_LINES = {
	Theme.GetColor("INDICATOR"):ColorText(L["A brand new and improved user interface."]).." "..L["The entirety of the addon has been redesigned from the ground up. Highlights include: a more modern UI that maximizes on available space, new appearances that allow you to change the theme, updated Dashboard, more powerful tables and much, much more."],
	Theme.GetColor("INDICATOR"):ColorText(L["New price sources."]).." "..L["We've added new price sources to give you even more flexibility in how you use TSM to manage your gold making. You can now reference NumInventory, SaleRate, and much more throughout the addon. SmartAvgBuy has also been moved from an option to its own separate price source."],
	Theme.GetColor("INDICATOR"):ColorText(L["Improved Import / Export."]).." "..L["Now embedded within the Groups tab of the main TSM window with dedicated buttons to help with both importing and exporting."],
	Theme.GetColor("INDICATOR"):ColorText(L["New Base Group search."]).." "..L["Trouble making groups? You can now search any item in the game from within the base group and easily add them to existing groups or simply create a new group for them."],
	Theme.GetColor("INDICATOR"):ColorText(L["Per-Character group selections."]).." "..L["To make it easier to use TSM across different characters, the groups you have selected in various UIs will now be persistent on a per-character basis and selected by default."],
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
	return UIElements.New("Frame")
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
				:SetText(L["TSM 4.10: What's new"])
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetMargin(0, -4, 0, 0)
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.DialogCloseBtnOnClick)
			)
		)
		:AddChild(UIElements.New("ScrollFrame", "body")
			:AddChild(UIElements.New("Text", "content1")
				:SetHeight(400)
				:SetFont("BODY_BODY2")
				:SetText(table.concat(CONTENT_LINES, "\n\n"))
			)
		)
		:AddChild(UIElements.New("Text", "footer1")
			:SetHeight(20)
			:SetMargin(0, 0, 12, 0)
			:SetFont("BODY_BODY3")
			:SetText(format(L["For more info, visit %s. For help, join us in Discord: %s."], Theme.GetColor("INDICATOR_ALT"):ColorText("blog.tradeskillmaster.com"), Theme.GetColor("INDICATOR_ALT"):ColorText("discord.gg/woweconomy")))
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
