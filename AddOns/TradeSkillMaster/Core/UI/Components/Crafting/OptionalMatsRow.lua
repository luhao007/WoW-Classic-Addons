-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...) ---@type TSM
local Environment = TSM.Include("Environment")
local UIElements = TSM.Include("UI.UIElements")
local Profession = TSM.Include("Service.Profession")
local MatString = TSM.Include("Util.MatString")
local CraftString = TSM.Include("Util.CraftString")
local RecipeString = TSM.Include("Util.RecipeString")
local ItemString = TSM.Include("Util.ItemString")
local private = {
	optionalMatsTemp = {},
}
local MAX_NUM_OPTIONAL_MATS = 5
local MAX_NUM_FINISHING_MATS = 3
local KEY_SEP = "_"



-- ============================================================================
-- Element Definition
-- ============================================================================

local OptionalMatsRow = UIElements.Define("OptionalMatsRow", "Frame") ---@class OptionalMatsRow: Frame
OptionalMatsRow:_ExtendStateSchema()
	:AddOptionalStringField("recipeString", nil)
	:Commit()



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function OptionalMatsRow:__init(frame)
	self.__super:__init(frame)
	self._onRecipeStringChanged = nil
end

function OptionalMatsRow:Acquire()
	self.__super:Acquire()
	self:SetLayout("HORIZONTAL")

	local optionalLabel, finishingLabel = nil, nil
	if Environment.HasFeature(Environment.FEATURES.C_TRADE_SKILL_UI) then
		optionalLabel = PROFESSIONS_OPTIONAL_REAGENT_CONTAINER_LABEL
		finishingLabel = PROFESSIONS_CRAFTING_FINISHING_HEADER
	else
		optionalLabel = ""
		finishingLabel = ""
	end

	self:SetPadding(0, 0, 2, 2)
	self:SetRoundedBackgroundColor("FRAME_BG")
	self:AddChild(UIElements.New("Text", "optionalLabel")
		:SetWidth("AUTO")
		:SetMargin(8, 0, 0, 0)
		:SetFont("BODY_BODY3_MEDIUM")
		:SetText(optionalLabel)
	)
	for i = 1, MAX_NUM_OPTIONAL_MATS do
		self:AddChild(UIElements.New("ItemSelector", "optionalMat"..i)
			:SetSize(24, 24)
			:SetMargin(4, i == MAX_NUM_OPTIONAL_MATS and 4 or 0, 0, 0)
			:SetScript("OnSelectionChanged", self:__closure("_HandleItemSelectionChanged"))
		)
	end
	self:AddChild(UIElements.New("Text", "finishingLabel")
		:SetWidth("AUTO")
		:SetMargin(8, 0, 0, 0)
		:SetFont("BODY_BODY3_MEDIUM")
		:SetText(finishingLabel)
	)
	for i = 1, MAX_NUM_FINISHING_MATS do
		self:AddChild(UIElements.New("ItemSelector", "finishingMat"..i)
			:SetSize(24, 24)
			:SetMargin(4, i == MAX_NUM_FINISHING_MATS and 4 or 0, 0, 0)
			:SetScript("OnSelectionChanged", self:__closure("_HandleItemSelectionChanged"))
		)
	end
	self:AddChild(UIElements.New("Spacer", "spacer"))

	self._state:PublisherForKeyChange("recipeString")
		:MapWithFunction(private.RecipeStringToShown)
		:CallMethod(self, "SetShown")

	local numOptionalPublisher = self._state:PublisherForKeyChange("recipeString")
		:IgnoreNil()
		:MapWithFunction(CraftString.FromRecipeString)
		:MapWithFunction(private.CraftStringToNumOptionalMats)
		:IgnoreDuplicates()
		:Share(MAX_NUM_OPTIONAL_MATS + 1)
	numOptionalPublisher
		:MapBooleanNotEquals(0)
		:CallMethod(self:GetElement("optionalLabel"), "SetShown")
	for i = 1, MAX_NUM_OPTIONAL_MATS do
		local key = "optional"..KEY_SEP..i
		local itemSelector = self:GetElement("optionalMat"..i)
		numOptionalPublisher
			:MapBooleanGreaterThanOrEquals(i)
			:CallMethod(itemSelector, "SetShown")
		self._state:PublisherForKeyChange("recipeString")
			:IgnoreNil()
			:MapWithFunction(CraftString.FromRecipeString)
			:IgnoreDuplicates()
			:MapWithFunction(private.CraftStringToMatString, key)
			:Share(2)
			:CallMethod(itemSelector, "SetContext")
			:CallMethod(itemSelector, "SetMatString")
		self._state:PublisherForKeyChange("recipeString")
			:IgnoreNil()
			:MapWithFunction(private.RecipeStringToSelectedItem, key)
			:CallMethod(itemSelector, "SetSelection")
		self._state:PublisherForKeyChange("recipeString")
			:IgnoreNil()
			:MapWithFunction(CraftString.FromRecipeString)
			:IgnoreDuplicates()
			:MapWithFunction(private.CraftStringToOptionalMatTooltip, key)
			:CallMethod(itemSelector, "SetTooltip")
	end

	local numFinishingPublisher = self._state:PublisherForKeyChange("recipeString")
		:IgnoreNil()
		:MapWithFunction(CraftString.FromRecipeString)
		:MapWithFunction(private.CraftStringToNumFinishingMats)
		:IgnoreDuplicates()
		:Share(MAX_NUM_FINISHING_MATS + 1)
	numFinishingPublisher
		:MapBooleanNotEquals(0)
		:CallMethod(self:GetElement("finishingLabel"), "SetShown")
	for i = 1, MAX_NUM_FINISHING_MATS do
		local key = "finishing"..KEY_SEP..i
		local itemSelector = self:GetElement("finishingMat"..i)
		numFinishingPublisher
			:MapBooleanGreaterThanOrEquals(i)
			:CallMethod(itemSelector, "SetShown")
		self._state:PublisherForKeyChange("recipeString")
			:IgnoreNil()
			:MapWithFunction(CraftString.FromRecipeString)
			:IgnoreDuplicates()
			:MapWithFunction(private.CraftStringToMatString, key)
			:Share(2)
			:CallMethod(itemSelector, "SetContext")
			:CallMethod(itemSelector, "SetMatString")
		self._state:PublisherForKeyChange("recipeString")
			:IgnoreNil()
			:MapWithFunction(private.RecipeStringToSelectedItem, key)
			:CallMethod(itemSelector, "SetSelection")
		self._state:PublisherForKeyChange("recipeString")
			:IgnoreNil()
			:MapWithFunction(CraftString.FromRecipeString)
			:IgnoreDuplicates()
			:MapWithFunction(private.CraftStringToOptionalMatTooltip, key)
			:CallMethod(itemSelector, "SetTooltip")
	end
end

function OptionalMatsRow:Release()
	self._onRecipeStringChanged = nil
	self.__super:Release()
end

function OptionalMatsRow:SetRecipeString(recipeString)
	self._state.recipeString = recipeString
	return self
end

---Registers a script handler.
---@param script "OnRecipeStringChanged"
---@param handler fun(optionalMatsRow: OptionalMatsRow, ...: any) The handler
---@return OptionalMatsRow
function OptionalMatsRow:SetScript(script, handler)
	if script == "OnRecipeStringChanged" then
		self._onRecipeStringChanged = handler
	else
		error("Invalid script: "..tostring(script))
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function OptionalMatsRow.__private:_HandleItemSelectionChanged(itemSelector, itemString)
	local matString = itemSelector:GetContext()
	if not matString then
		return
	end
	local slotId = MatString.GetSlotId(itemSelector:GetContext())
	assert(slotId)

	assert(not next(private.optionalMatsTemp))
	if itemString then
		local itemId = ItemString.ToId(itemString)
		for _, existingSlotId, existingItemId in RecipeString.OptionalMatIterator(self._state.recipeString) do
			-- Remove this item from any existing slots its in
			if existingItemId ~= itemId then
				private.optionalMatsTemp[existingSlotId] = existingItemId
			end
		end
		private.optionalMatsTemp[slotId] = itemId
	else
		for _, existingSlotId, existingItemId in RecipeString.OptionalMatIterator(self._state.recipeString) do
			if existingSlotId ~= slotId then
				private.optionalMatsTemp[existingSlotId] = existingItemId
			end
		end
	end
	local newRecipeString = RecipeString.SetOptionalMats(self._state.recipeString, private.optionalMatsTemp)
	wipe(private.optionalMatsTemp)
	self._state.recipeString = newRecipeString
	self:_onRecipeStringChanged(self._state.recipeString)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.RecipeStringToShown(recipeString)
	if not recipeString then
		return false
	end
	local craftString = CraftString.FromRecipeString(recipeString)
	return (private.CraftStringToNumOptionalMats(craftString) + private.CraftStringToNumFinishingMats(craftString)) > 0
end

function private.CraftStringToNumOptionalMats(craftString)
	return craftString and Profession.GetNumOptionalMats(craftString, MatString.TYPE.OPTIONAL) or 0
end

function private.CraftStringToNumFinishingMats(craftString)
	return craftString and Profession.GetNumOptionalMats(craftString, MatString.TYPE.FINISHING) or 0
end

function private.CraftStringToMatString(craftString, key)
	local matTypeStr, index = strsplit(KEY_SEP, key)
	local keyMatType = nil
	if matTypeStr == "optional" then
		keyMatType = MatString.TYPE.OPTIONAL
	elseif matTypeStr == "finishing" then
		keyMatType = MatString.TYPE.FINISHING
	else
		error("Invalid matTypeStr: "..tostring(matTypeStr))
	end
	index = tonumber(index)
	local resultMatString = nil
	for _, matString in Profession.MatIterator(craftString) do
		if MatString.GetType(matString) == keyMatType then
			index = index - 1
			if index == 0 then
				resultMatString = matString
			end
		end
	end
	return resultMatString
end

function private.CraftStringToOptionalMatTooltip(craftString, key)
	local matTypeStr, index = strsplit(KEY_SEP, key)
	local keyMatType = nil
	if matTypeStr == "optional" then
		keyMatType = MatString.TYPE.OPTIONAL
	elseif matTypeStr == "finishing" then
		keyMatType = MatString.TYPE.FINISHING
	else
		error("Invalid matTypeStr: "..tostring(matTypeStr))
	end
	index = tonumber(index)
	local resultMatString = nil
	for _, matString in Profession.MatIterator(craftString) do
		if MatString.GetType(matString) == keyMatType then
			index = index - 1
			if index == 0 then
				resultMatString = matString
			end
		end
	end

	local slotText = resultMatString and Profession.GetMatSlotText(craftString, resultMatString) or ""
	return slotText ~= "" and slotText or nil
end

function private.RecipeStringToSelectedItem(recipeString, key)
	local matString = private.CraftStringToMatString(CraftString.FromRecipeString(recipeString), key)
	local itemId = matString and RecipeString.GetOptionalMat(recipeString, MatString.GetSlotId(matString))
	return itemId and "i:"..itemId or nil
end
