-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local StoryBoard = TSM.UI:NewPackage("StoryBoard")
local Environment = TSM.Include("Environment")
local Log = TSM.Include("Util.Log")
local Reactive = TSM.Include("Util.Reactive")
local Settings = TSM.Include("Service.Settings")
local Profession = TSM.Include("Service.Profession")
local UIElements = TSM.Include("UI.UIElements")
local UIManager = TSM.Include("UI.UIManager")
local private = {
	manager = nil,
	settings = nil,
	dividedContainerContext = {},
}
local MIN_FRAME_SIZE = { width = 400, height = 300 }
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = { leftWidth = 200 }
local STATE_SCHEMA = Reactive.CreateStateSchema()
	:AddOptionalTableField("frame")
	:Commit()
local ITEM_LIST = Environment.IsRetail() and {"i:2770", "i:2771", "i:2772", "i:3858", "i:10620", "i:189143", "i:188658", "i:190311", "i:190312", "i:190313", "i:190314"} or {"i:2770", "i:2771", "i:2772", "i:3858", "i:10620"}



-- ============================================================================
-- Module Functions
-- ============================================================================

function StoryBoard.OnEnable()
	private.settings = Settings.NewView()
		:AddKey("global", "storyBoardUIContext", "frame")

	local state = STATE_SCHEMA:CreateState()
	private.manager = UIManager.Create(state, private.ActionHandler)
end

function StoryBoard.OnDisable()
	private.manager:ProcessAction("ACTION_ON_DISABLE")
end

function StoryBoard.Toggle()
	private.manager:ProcessAction("ACTION_TOGGLE")
end



-- ============================================================================
-- Action Handler
-- ============================================================================

function private.ActionHandler(state, action)
	Log.Info("Handling action %s", action)
	if action == "ACTION_FRAME_SHOW" then
		assert(not state.frame)
		state.frame = private.CreateMainFrame(state)
		state.frame:Show()
		state.frame:Draw()
	elseif action == "ACTION_FRAME_ON_HIDE" then
		assert(state.frame)
		state.frame:Hide()
		state.frame:Release()
		state.frame = nil
	elseif action == "ACTION_TOGGLE" then
		if state.frame then
			state.frame:Hide()
		else
			return "ACTION_FRAME_SHOW"
		end
	elseif action == "ACTION_ON_DISABLE" then
		if not state.frame then
			return
		end
		state.frame:Hide()
	else
		error("Unknown action: "..tostring(action))
	end
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame(state)
	return UIElements.New("ApplicationFrame", "base")
		:SetParent(UIParent)
		:SetSettingsContext(private.settings, "frame")
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetStrata("HIGH")
		:SetTitle("TSM Storyboard")
		:SetScript("OnHide", private.FrameOnHide)
		:SetContentFrame(UIElements.New("DividedContainer", "container")
			:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
			:SetBackgroundColor("PRIMARY_BG")
			:SetMinWidth(100, 100)
			:SetLeftChild(UIElements.New("ScrollFrame", "left")
				:SetBackgroundColor("PRIMARY_BG")
				:AddChild(UIElements.New("Text", "controlsHeading")
					:SetHeight(20)
					:SetMargin(8, 0, 0, 0)
					:SetFont("BODY_BODY3")
					:SetJustifyH("LEFT")
					:SetText("Controls")
				)
				:AddChild(UIElements.New("Button", "actionButton")
					:SetHeight(20)
					:SetPadding(24, 0, 0, 0)
					:SetFont("BODY_BODY3")
					:SetJustifyH("LEFT")
					:SetBackground("PRIMARY_BG", true)
					:SetText("ActionButton")
					:SetScript("OnClick", private.CreateActionButtonPage)
				)
				:AddChild(UIElements.New("Button", "button")
					:SetHeight(20)
					:SetPadding(24, 0, 0, 0)
					:SetFont("BODY_BODY3")
					:SetJustifyH("LEFT")
					:SetBackground("PRIMARY_BG", true)
					:SetText("Button")
					:SetScript("OnClick", private.CreateButtonPage)
				)
				:AddChild(UIElements.New("Button", "itemSelector")
					:SetHeight(20)
					:SetPadding(24, 0, 0, 0)
					:SetFont("BODY_BODY3")
					:SetJustifyH("LEFT")
					:SetBackground("PRIMARY_BG", true)
					:SetText("Item Selector")
					:SetScript("OnClick", private.CreateItemSelectorPage)
				)

				:AddChild(UIElements.New("Button", "button")
					:SetHeight(20)
					:SetPadding(24, 0, 0, 0)
					:SetFont("BODY_BODY3")
					:SetJustifyH("LEFT")
					:SetBackground("PRIMARY_BG", true)
					:SetDisabled(not Profession.HasScanned())
					:SetText("CraftTierButton")
					:SetScript("OnClick", private.CreateCraftTierButtonPage)
				)
			)
			:SetRightChild(UIElements.New("ScrollFrame", "right")
				:SetPadding(16)
			)
		)
end

function private.GetAndClearContent(button)
	button:SetHighlightLocked(true)
		:Draw()
	local right = button:GetElement("__parent.__parent.right")
	local prevButton = right:GetContext()
	if prevButton then
		prevButton:SetHighlightLocked(false)
			:Draw()
	end
	right:SetContext(button)
	right:ReleaseAllChildren()
	return right
end

function private.CreateActionButtonPage(button)
	private.GetAndClearContent(button)
		:AddChild(private.CreateActionButton("pressed", "Default Button"))
		:AddChild(private.CreateActionButton("pressed", "Disabled Button")
			:SetDisabled(true)
		)
		:AddChild(private.CreateActionButton("pressed", "Pressed Button")
			:SetPressed(true)
		)
		:AddChild(private.CreateActionButton("modifier", "Modifier Button (Shift Not Pressed)")
			:SetModifierText("Modifier Button (Shift Pressed)", "SHIFT")
		)
		:AddChild(private.CreateActionButton("cooldown", "No Click Cooldown")
			:DisableClickCooldown()
		)
		:Draw()
end

function private.CreateActionButton(id, text)
	return UIElements.New("ActionButton", id)
		:SetHeight(24)
		:SetMargin(0, 0, 32, 0)
		:SetText(text)
		:SetScript("OnClick", private.ButtonOnClick)
end

function private.CreateButtonPage(button)
	private.GetAndClearContent(button)
		:AddChild(private.CreateButton("colored")
			:SetBackground("ACTIVE_BG")
			:SetText("Solid Color")
		)
		:AddChild(private.CreateButton("coloredHighlight")
			:SetBackground("ACTIVE_BG", true)
			:SetText("Solid Color with Highlight")
		)
		:AddChild(private.CreateButton("iconLeft")
			:SetIcon("iconPack.14x14/Add/Circle", "LEFT")
			:SetText("Button With Left Icon")
		)
		:AddChild(UIElements.New("Frame", "iconRow")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(0, 0, 32, 0)
			:AddChild(UIElements.New("Spacer", "spacer1"))
			:AddChild(UIElements.New("Button", "icon")
				:SetScript("OnClick", private.ButtonOnClick)
				:SetBackgroundAndSize("iconPack.14x14/Attention")
			)
			:AddChild(UIElements.New("Spacer", "spacer2"))
			:AddChild(UIElements.New("Button", "texture")
				:SetSize(24, 24)
				:SetBackground(136254)
				:SetScript("OnClick", private.ButtonOnClick)
			)
			:AddChild(UIElements.New("Spacer", "spacer3"))
		)
		:AddChildIf(Environment.IsRetail(), UIElements.New("Frame", "itemButtonRow")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(0, 0, 32, 0)
			:AddChild(UIElements.New("Spacer", "spacer1"))
			:AddChild(UIElements.New("ItemButton", "itemButton")
				:SetSize(40, 40)
				:SetMargin(0, 16, 32, 0)
				:SetScript("OnClick", private.ButtonOnClick)
				:SetItem("i:198414")
			)
			:AddChild(UIElements.New("Spacer", "spacer2"))
			:AddChild(UIElements.New("ItemButton", "itemButton2")
				:SetSize(40, 40)
				:SetMargin(0, 0, 32, 0)
				:SetScript("OnClick", private.ButtonOnClick)
				:SetItem("i:191461")
				:SetSelected(true)
			)
			:AddChild(UIElements.New("Spacer", "spacer3"))
		)
		:Draw()
end

function private.CreateButton(id)
	return UIElements.New("Button", id)
		:SetHeight(24)
		:SetMargin(0, 0, 32, 0)
		:SetScript("OnClick", private.ButtonOnClick)
end

function private.CreateItemSelectorPage(button)
	private.GetAndClearContent(button)
		:AddChild(UIElements.New("Text", "controlsHeading")
			:SetHeight(20)
			:SetFont("BODY_BODY2")
			:SetJustifyH("LEFT")
			:SetText("Normal ItemSelector")
		)
		:AddChild(private.CreateItemSelector("select")
			:SetMargin(0, 0, 4, 0)
		)
		:AddChild(UIElements.New("Text", "controlsHeading")
			:SetHeight(20)
			:SetMargin(0, 0, 32, 0)
			:SetFont("BODY_BODY2")
			:SetJustifyH("LEFT")
			:SetText("Disabled ItemSelector")
		)
		:AddChild(private.CreateItemSelector("disabledSelect")
			:SetMargin(0, 0, 4, 0)
			:SetDisabled(true)
		)
		:Draw()
end

function private.CreateItemSelector(id)
	return UIElements.New("ItemSelector", id)
		:SetSize(32, 32)
		:SetItems(ITEM_LIST)
		:SetScript("OnSelectionChanged", private.SelectionChanged)
end

function private.CreateCraftTierButtonPage(button)
	private.GetAndClearContent(button)
		:AddChild(private.CreateCraftTierButton(1, 137000, -15000, 1))
		:AddChild(private.CreateCraftTierButton(2, 546100, 15400, 1))
		:AddChild(private.CreateCraftTierButton(3, 1576400, 456400, 1))
		:AddChild(private.CreateCraftTierButton(4, 4610500, 640000, 1))
		:AddChild(private.CreateCraftTierButton(5, 8087600, -5046500, 0.15))
		:Draw()
end

function private.CreateCraftTierButton(quality, cost, profit, chance)
	return UIElements.New("Frame", "q"..quality)
		:SetLayout("HORIZONTAL")
		:SetHeight(80)
		:SetMargin(0, 0, 0, 16)
		:AddChild(UIElements.New("CraftTierButton", "button")
			:SetWidth(120)
			:SetCraftString("c:0:q"..quality, chance)
			:SetPrices(cost, profit)
			:SetScript("OnClick", private.ButtonOnClick)
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnHide()
	private.manager:ProcessAction("ACTION_FRAME_ON_HIDE")
end

function private.ButtonOnClick()
	print("Click!")
end

function private.SelectionChanged(_, selection)
	print("SELECTED", selection)
end
