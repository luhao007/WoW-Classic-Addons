
local addonname,addon = ...
local L = addon.L
local MyName = L["HPet Options"] .. "New"

local SetupTable = {
	{
		name = "Config",
		type = "Title"
	},
	{
		name = "Message",
		type = "CheckBox",
		variable = "ShowMsg"
	},
	{
		name = "OnlyInPetInfo",
		type = "CheckBox",
		variable = "OnlyInPetInfo"
	},
	{
		name = "MiniTip",
		type = "CheckBox",
		variable = "MiniTip"
	},
	{
		name = "Sound",
		type = "CheckBox",
		variable = "Sound"
	},
	{
		name = "ACPEnable",
		type = "CheckBox",
		variable = "ACPEnable"
	},
	{
		name = "AHSFEnable",
		type = "CheckBox",
		variable = "AHSFEnable"
	},
	{
		name = "FastForfeit",
		type = "CheckBox",
		variable = "FastForfeit"
	},
	{
		name = "OtherTooltip",
		type = "CheckBox",
		variable = "Tooltip"
	},
	{
		name = "HighGlow",
		type = "CheckBox",
		variable = "HighGlow"
	},
	{
		name = "AutoSaveAbility",
		type = "CheckBox",
		variable = "AutoSaveAbility"
	},
	{
		name = "ShowBandageButton",
		type = "CheckBox",
		variable = "ShowBandageButton"
	},
	{
		name = "ShowHideID",
		type = "CheckBox",
		variable = "ShowHideID"
	},
	{
		name = "GrowInfo",
		type = "Title"
	},
	{
		name = "PetGrowInfo",
		type = "CheckBox",
		variable = "ShowGrowInfo"
	},
	{
		name = "BreedIDStyle",
		type = "CheckBox",
		variable = "BreedIDStyle",
		SetValue = function()
			if HPetAllInfoFrame and HPetAllInfoFrame.ready then
				HPetAllInfoFrame:Update()
			end
		end
	},
	{
		name = "PetGreedInfo",
		type = "CheckBox",
		variable = "PetGreedInfo"
	},
	{
		name = "PetBreedInfo",
		type = "CheckBox",
		variable = "PetBreedInfo"
	},
	{
		name = "ShowBreedID",
		type = "CheckBox",
		variable = "ShowBreedID"
	},
	{
		name = "AbilityIcon",
		type = "Title"
	},
	{
		name = "EnemyAbility",
		type = "CheckBox",
		variable = "EnemyAbility",
		SetValue = HPetBattleAny.AllAbilityRef
	},
	{
		name = "LockAbilitys",
		type = "CheckBox",
		variable = "LockAbilitys"
	},
	{
		name = "ShowAbilitysName",
		type = "CheckBox",
		variable = "ShowAbilitysName",
		SetValue = HPetBattleAny.AllAbilityRef
	},
	-- {
	-- 	name = "OtherAbility",
	-- 	type = "CheckBox",
	-- 	variable = "OtherAbility",
	-- 	SetValue = HPetBattleAny.AllAbilityRef,
	-- 	Children = {
	-- 		{
	-- 			name = "AllyAbility",
	-- 			type = "CheckBox",
	-- 			variable = "AllyAbility",
	-- 			SetValue = HPetBattleAny.AllAbilityRef
	-- 		}
	-- 	},
	-- 	modifiable = "GetValue"
	-- },
	{
		name = "OtherAbility",
		type = "CheckBox",
		variable = "OtherAbility",
		SetValue = HPetBattleAny.AllAbilityRef
	},
	{
		name = "AllyAbility",
		type = "CheckBox",
		variable = "AllyAbility",
		SetValue = HPetBattleAny.AllAbilityRef
	},
	{
		name = "AbilitysScale",
		type = "Slider",
		variable = "AbScale",
		SetValue = HPetBattleAny.AllAbilityRef
	}
}


local function CreateSetting(category, layout, table, parent, isModifiable)
	for key, value in pairs(table) do
		if L[value.name] or value.variable then
			if value.type == "Title" then
				layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L[value.name]))
			elseif value.type == "CheckBox" then
				--initializer:SetParentInitializer方法会导致污染??
				--关闭"选项"窗口居然会自动打断当前施法读条...这特么是什么操作
				-- if parent then
				-- 	initializer:SetParentInitializer(parent, isModifiable)
				-- end
				-- if value.Children then
				-- 	if value.modifiable and setting[value.modifiable] then
				-- 		CreateSetting(
				-- 			category,
				-- 			layout,
				-- 			value.Children,
				-- 			initializer,
				-- 			function()
				-- 				return setting[value.modifiable](setting)
				-- 			end
				-- 		)
				-- 	end
				-- end
				local setting = Settings.RegisterProxySetting(category, value.variable, HPetSaves, Settings.VarType.Boolean, L[value.name], HPetBattleAny.Default[value.variable] or Settings.Default.False, nil, value.SetValue)
				local initializer = Settings.CreateCheckBox(category, setting, L[value.name .. "Tooltip"])
			elseif value.type == "Slider" then
				local minValue, maxValue, step = 0, 1, 0.05
				local options = Settings.CreateSliderOptions(minValue, maxValue, step)
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
				local setting = Settings.RegisterProxySetting(category, value.variable, HPetSaves, Settings.VarType.Number, L[value.name], HPetBattleAny.Default[value.variable] or 1)
				Settings.CreateSlider(category, setting, options, L[value.name .. "Tooltip"])
			end
		else
			print("HPet:", value.name, "错误")
		end
	end
end
local function Register()
	local category, layout = Settings.RegisterVerticalLayoutCategory(MyName)

	CreateSetting(category, layout, SetupTable)
	-- for key, value in pairs(SetupTable) do
	-- 	if L[value.name] or value.variable then
	-- 		if value.type == "Title" then
	-- 			layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L[value.name]))
	-- 		elseif value.type == "CheckBox" then
	-- 			local setting = Settings.RegisterProxySetting(category, value.variable, HPetSaves, Settings.VarType.Boolean, L[value.name], HPetBattleAny.Default[value.variable] or Settings.Default.False, nil, value.SetValue)
	-- 			local initializer = Settings.CreateCheckBox(category, setting, L[value.name .. "Tooltip"])
	-- 			initializer:SetParentInitializer(nameplateInitializer, IsModifiable)
	-- 		end
	-- 	else
	-- 		print("HPet:", value.name, "错误")
	-- 	end
	-- end

	return category
end

-- Settings.RegisterAddOnCategory(Register())
