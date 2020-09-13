-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CustomSources = TSM.MainUI.Settings:NewPackage("CustomSources")
local L = TSM.Include("Locale").GetTable()
local TempTable = TSM.Include("Util.TempTable")
local Theme = TSM.Include("Util.Theme")
local CustomPrice = TSM.Include("Service.CustomPrice")
local UIElements = TSM.Include("UI.UIElements")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function CustomSources.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage(L["Custom Sources"], "middle", private.GetCustomSourcesSettingsFrame)
end



-- ============================================================================
-- Custom Sources Settings UI
-- ============================================================================

function private.GetCustomSourcesSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "custom_sources")
	return UIElements.New("ScrollFrame", "content")
		:SetPadding(8, 8, 8, 0)
		:AddChild(TSM.MainUI.Settings.CreateExpandableSection("Custom Price", "general", L["Custom Sources"], format(L["Custom sources allow you to create more advanced prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as %s and %s."], Theme.GetColor("INDICATOR"):ColorText("vendorsell"), Theme.GetColor("INDICATOR"):ColorText("vendorbuy")), 60)
			:AddChild(UIElements.New("Frame", "tableHeading")
				:SetLayout("HORIZONTAL")
				:SetHeight(20)
				:AddChild(UIElements.New("Text", "col1")
					:SetWidth(162)
					:SetMargin(0, 8, 0, 0)
					:SetFont("BODY_BODY3_MEDIUM")
					:SetText(L["Name"])
				)
				:AddChild(UIElements.New("Text", "col2")
					:SetFont("BODY_BODY3_MEDIUM")
					:SetText(L["String"])
				)
			)
			:AddChild(UIElements.New("Texture", "line1")
				:SetHeight(1)
				:SetTexture("ACTIVE_BG")
			)
			:AddChildrenWithFunction(private.AddCustomPriceRows)
			:AddChild(UIElements.New("ActionButton", "addNewBtn")
				:SetHeight(24)
				:SetMargin(0, 0, 32, 0)
				:SetFont("BODY_BODY2_MEDIUM")
				:SetText(L["Add a new custom source"])
				:SetScript("OnClick", private.AddNewButtonOnClick)
			)
		)
end

function private.CreateCustomPriceRow(name)
	local priceString = TSM.db.global.userData.customPriceSources[name]
	local row = UIElements.New("Frame", "row_"..name)
		:SetLayout("HORIZONTAL")
		:SetHeight(28)
		:SetMargin(-12, -12, 0, 0)
		:SetPadding(12, 12, 0, 0)
		:SetBackgroundColor("PRIMARY_BG_ALT")
		:SetContext(name)
		:SetScript("OnEnter", private.CustomPriceRowOnEnter)
		:SetScript("OnLeave", private.CustomPriceRowOnLeave)
		:AddChild(UIElements.New("Text", "nameText")
			:SetWidth(162)
			:SetMargin(0, 8, 0, 0)
			:SetFont("BODY_BODY3_MEDIUM")
			:SetText(name)
		)
		:AddChild(UIElements.New("Text", "valueText")
			:SetFont("BODY_BODY3")
			:SetText(priceString)
		)
		:AddChild(UIElements.New("Button", "editBtn")
			:SetMargin(4, 0, 0, 0)
			:SetBackgroundAndSize("iconPack.18x18/Edit")
			:SetScript("OnClick", private.EditCustomPriceOnClick)
			:PropagateScript("OnEnter")
			:PropagateScript("OnLeave")
		)
		:AddChild(UIElements.New("Button", "deleteBtn")
			:SetMargin(4, 0, 0, 0)
			:SetBackgroundAndSize("iconPack.18x18/Delete")
			:SetScript("OnClick", private.DeleteCustomPriceOnClick)
			:PropagateScript("OnEnter")
			:PropagateScript("OnLeave")
		)
	row:GetElement("editBtn"):Hide()
	row:GetElement("deleteBtn"):Hide()
	return row
end

function private.AddCustomPriceRows(frame)
	local names = TempTable.Acquire()
	for name in pairs(TSM.db.global.userData.customPriceSources) do
		tinsert(names, name)
	end
	sort(names)
	for _, name in ipairs(names) do
		frame:AddChild(private.CreateCustomPriceRow(name))
	end
	TempTable.Release(names)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.CustomPriceRowOnEnter(frame)
	frame:SetBackgroundColor("FRAME_BG")
	frame:GetElement("editBtn"):Show()
	frame:GetElement("deleteBtn"):Show()
	frame:Draw()
end

function private.CustomPriceRowOnLeave(frame)
	frame:SetBackgroundColor("PRIMARY_BG_ALT")
	frame:GetElement("editBtn"):Hide()
	frame:GetElement("deleteBtn"):Hide()
	frame:Draw()
end

function private.EditCustomPriceOnClick(button)
	private.ShowEditDialog(button)
end

function private.ShowEditDialog(editBtn)
	local dialogFrame = UIElements.New("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetSize(478, 314)
		:SetPadding(12)
		:AddAnchor("CENTER")
		:SetMouseEnabled(true)
		:SetBackgroundColor("FRAME_BG", true)
		:SetContext(editBtn)
		:AddChild(UIElements.New("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetHeight(24)
			:SetMargin(0, 0, -4, 14)
			:AddChild(UIElements.New("Spacer", "spacer")
				:SetWidth(20)
			)
			:AddChild(UIElements.New("Text", "title")
				:SetJustifyH("CENTER")
				:SetFont("BODY_BODY1_BOLD")
				:SetText(L["Edit Custom Source"])
			)
			:AddChild(UIElements.New("Button", "closeBtn")
				:SetMargin(0, -4, 0, 0)
				:SetBackgroundAndSize("iconPack.24x24/Close/Default")
				:SetScript("OnClick", private.EditPriceCloseBtnOnClick)
			)
		)
		:AddChild(UIElements.New("Text", "name")
			:SetHeight(20)
			:SetFont("BODY_BODY2_MEDIUM")
			:SetJustifyH("LEFT")
			:SetText(L["Name"])
		)
		:AddChild(UIElements.New("Input", "nameInput")
			:SetHeight(24)
			:SetBackgroundColor("PRIMARY_BG_ALT")
			:SetValue(editBtn:GetElement("__parent.nameText"):GetText())
			:SetTabPaths("__parent.valueInput", "__parent.valueInput")
			:SetValidateFunc(private.NameValidateFunc)
			:SetScript("OnValidationChanged", private.ConfirmOnValidationChanged)
		)
		:AddChild(UIElements.New("Text", "string")
			:SetHeight(20)
			:SetMargin(0, 0, 6, 0)
			:SetFont("BODY_BODY2_MEDIUM")
			:SetJustifyH("LEFT")
			:SetText(L["String"])
		)
		:AddChild(UIElements.New("MultiLineInput", "valueInput")
			:SetBackgroundColor("PRIMARY_BG_ALT")
			:SetValue(editBtn:GetElement("__parent.valueText"):GetText())
			:SetTabPaths("__parent.nameInput", "__parent.nameInput")
			:SetValidateFunc(private.ValueValidateFunc)
			:SetScript("OnValidationChanged", private.ConfirmOnValidationChanged)
		)
		:AddChild(UIElements.New("ActionButton", "confirm")
			:SetHeight(24)
			:SetMargin(0, 0, 12, 0)
			:SetFont("BODY_BODY2_MEDIUM")
			:SetText(L["Confirm"])
			:SetContext(editBtn:GetElement("__parent.__parent"))
			:SetScript("OnClick", private.ConfirmOnClick)
		)
	editBtn:GetBaseElement():ShowDialogFrame(dialogFrame)
	return dialogFrame
end

function private.EditPriceCloseBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end

function private.NameValidateFunc(input, value)
	if value == "" then
		return false
	elseif gsub(value, "([a-z]+)", "") ~= "" then
		return false, L["Custom price names can only contain lowercase letters."]
	elseif value ~= input:GetParentElement():GetContext():GetParentElement():GetContext() then
		return CustomPrice.ValidateName(value)
	end
	return true
end

function private.ConfirmOnValidationChanged(input)
	input:GetElement("__parent.confirm")
		:SetDisabled(not input:IsValid())
		:Draw()
end

function private.ValueValidateFunc(input, value)
	value = strlower(strtrim(value))
	local isValid, errMsg = CustomPrice.Validate(value)
	if not isValid and value ~= "" then
		return false, errMsg
	end
	return true
end

function private.ConfirmOnClick(button)
	local baseElement = button:GetBaseElement()
	local oldName = button:GetParentElement():GetContext():GetParentElement():GetContext()
	local newName = button:GetElement("__parent.nameInput"):GetValue()
	if oldName ~= newName then
		CustomPrice.RenameCustomPriceSource(oldName, newName)
		CustomPrice.SetCustomPriceSource(newName, button:GetElement("__parent.valueInput"):GetValue())
		local generalContainer = button:GetParentElement():GetContext():GetParentElement():GetParentElement()
		local rowFrame = button:GetParentElement():GetContext():GetParentElement()
		generalContainer:AddChildBeforeById("addNewBtn", private.CreateCustomPriceRow(newName))
		generalContainer:RemoveChild(rowFrame)
		rowFrame:Release()
		generalContainer:GetElement("__parent.__parent")
			:Draw()
	else
		CustomPrice.SetCustomPriceSource(newName, button:GetElement("__parent.valueInput"):GetValue())
		button:GetParentElement():GetContext():GetElement("__parent.nameText")
			:SetText(newName)
			:Draw()
		button:GetParentElement():GetContext():GetElement("__parent.valueText")
			:SetText(button:GetElement("__parent.valueInput"):GetValue())
			:Draw()
	end
	baseElement:HideDialog()
end

function private.DeleteCustomPriceOnClick(button)
	CustomPrice.DeleteCustomPriceSource(button:GetParentElement():GetContext())
	local rowFrame = button:GetParentElement()
	local parentFrame = rowFrame:GetParentElement()
	parentFrame:RemoveChild(rowFrame)
	rowFrame:Release()
	parentFrame:GetElement("__parent.__parent")
		:Draw()
end

function private.AddNewButtonOnClick(button)
	-- generate a placeholder name
	local newName = nil
	local suffix = ""
	while not newName do
		for i = strbyte("a"), strbyte("z") do
			newName = "customprice"..suffix..strchar(i)
			if not TSM.db.global.userData.customPriceSources[newName] then
				break
			end
			newName = nil
		end
		suffix = suffix..strchar(random(strbyte("a"), strbyte("z")))
	end

	CustomPrice.CreateCustomPriceSource(newName, "")
	button:GetParentElement()
		:AddChildBeforeById("addNewBtn", private.CreateCustomPriceRow(newName))
	button:GetElement("__parent.__parent.__parent")
		:Draw()
	local dialogFrame = private.ShowEditDialog(button:GetElement("__parent.row_"..newName..".editBtn"))
	dialogFrame:GetElement("valueInput"):SetFocused(true)
end
