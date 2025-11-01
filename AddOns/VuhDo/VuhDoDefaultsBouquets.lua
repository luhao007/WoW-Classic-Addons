local GetSpellName = C_Spell.GetSpellName or VUHDO_getSpellName;

--
function VUHDO_makeFullColor(...)
	return {
		["R"] = select(1, ...), ["G"] = select(2, ...), ["B"] = select(3, ...), ["O"] = select(4, ...),
		["TR"] = select(5, ...), ["TG"] = select(6, ...), ["TB"] = select(7, ...), ["TO"] = select(8, ...),
		["useBackground"] = true, ["useText"] = true, ["useOpacity"] = true
	};
end



--
local function VUHDO_makeFullColorForBouquet(...)
	local tColor = VUHDO_makeFullColor(...);
	tColor["isManuallySet"] = true;
	return tColor;
end




VUHDO_DEFAULT_BOUQUETS = {
	["VERSION"] = 1,
	["SELECTED"] = VUHDO_I18N_DEF_BOUQUET_TANK_COOLDOWNS,
	["STORED"] = {
		[VUHDO_I18N_DEF_BOUQUET_TANK_COOLDOWNS] = {
			{
				["name"] = GetSpellName(12975), -- "Last Stand",
				["mine"] = true, ["others"] = true,	["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1,	["bright"] = 1.0 },
			},
			{
				["name"] = GetSpellName(871), -- "Shield Wall",
				["mine"] = true, ["others"] = true,	["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = GetSpellName(61336), -- "Survival Instincts",
				["mine"] = true, ["others"] = true, ["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = GetSpellName(22842), -- "Frenzied Regeneration",
				["mine"] = true, ["others"] = true, ["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1,	["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_PW_S_WEAKENED_SOUL] = {
			{
				["name"] = GetSpellName(17), -- "Powerword: Shield",
				["mine"] = true, ["icon"] = 8,
				["color"] = VUHDO_makeFullColorForBouquet(0.074, 0.749, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = GetSpellName(6788), -- "Weakened Soul",
				["mine"] = true, ["others"] = true,	["icon"] = 9,
				["color"] = VUHDO_makeFullColorForBouquet(1, 0.623, 0.305, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI_AGGRO] = {
			{
				["name"] = "AGGRO", -- "Aggro",
				["mine"] = false, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 0, 0, 1,   1, 0, 0, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "PLAYER_TARGET", -- "Player Target",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(0.9, 0.9, 0.9, 1,   0.7, 0.7, 0.7, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "MOUSE_TARGET", -- "Mouse Target",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(0.635, 0.470, 0.113, 1,   0.4, 0.4, 0.4, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "ALWAYS",
				["mine"] = true, ["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(0, 0, 0, 0.7,   0.1, 0.1, 0.1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI] = {
			{
				["name"] = "PLAYER_TARGET", -- "Player Target",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(0.9, 0.9, 0.9, 1,   0.7, 0.7, 0.7, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "MOUSE_TARGET", -- "Mouse Target",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(0.635, 0.470, 0.113, 1,   0.4, 0.4, 0.4, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "ALWAYS", -- "Always",
				["mine"] = true, ["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(0, 0, 0, 0.7,   0.1, 0.1, 0.1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BORDER_SIMPLE] = {
			{
				["name"] = "ALWAYS", -- "Always",
				["mine"] = true, ["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(0, 0, 0, 0.7,   0.1, 0.1, 0.1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_SWIFTMENDABLE] = {
			{
				["name"] = "STATUS_ACTIVE",
				["mine"] = true, ["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "SWIFTMEND",
				["mine"] = true, ["icon"] = 6,
				["color"] = VUHDO_makeFullColorForBouquet(1, 0, 0, 1,   1, 0, 0, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_SINGLE] = {
			{
				["name"] = "MOUSE_TARGET",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 0.7,   1, 1, 1, 0.75),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_MULTI] = {
			{
				["name"] = "MOUSE_TARGET",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 0.75,   1, 1, 1, 0.75),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "MOUSE_GROUP",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 0.6,   1, 1, 1, 0.25),
				["custom"] = { [1] = 1, ["radio"] = 1,	["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_AGGRO_INDICATOR] = {
			{
				["name"] = "AGGRO",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 0, 0, 1,   1, 0, 0, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_CLUSTER_MOUSE_HOVER] = {
			{
				["name"] = "STATUS_ACTIVE",
				["mine"] = true, ["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "MOUSE_CLUSTER",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 0.5, 0, 0.8,   1, 0.5, 0, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_THREAT_MARKS] = {
			{
				["name"] = "STATUS_ACTIVE",
				["mine"] = true, ["icon"] = 1,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "THREAT_LEVEL_HIGH",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 0, 0, 1,   1, 0.5, 0, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "THREAT_LEVEL_MEDIUM",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 0.5, 0, 1,   1, 0.5, 0, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ALL] = {
			{
				["name"] = "NO_RANGE",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
					["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
					["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 2, ["bright"] = 1.0 },
			},
			{
				["name"] = "STATUS_MANA",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(0, 0, 1, 1,   0, 0, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "STATUS_OTHER_POWERS",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ONLY] = {
			{
				["name"] = "NO_RANGE",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
					["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
					["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 2, ["bright"] = 1.0 },
			},
			{
				["name"] = "STATUS_MANA",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(0, 0, 1, 1,   0, 0, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BAR_THREAT] = {
			{
				["name"] = "THREAT_ABOVE",
				["mine"] = true, ["others"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(1, 0, 1, 1,   1, 0, 1, 1),
				["custom"] = { [1] = 85, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "STATUS_THREAT",
				["mine"] = true, ["icon"] = 2,
				["color"] = VUHDO_makeFullColorForBouquet(0, 1, 1, 1,   0, 1, 1, 1),
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},
	},
};



VUHDO_DEFAULT_BACKGROUND_BOUQUETS = {
	[VUHDO_I18N_DEF_BAR_BACKGROUND_SOLID] = {
		{
			["name"] = "DISCONNECTED",
			["mine"] = true, ["icon"] = 2,
			["color"] = VUHDO_makeFullColorForBouquet(0.298, 0.298, 0.298, 0.21,   0.576, 0.576, 0.576, 0.58),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "NO_RANGE",
			["mine"] = true, ["icon"] = 2,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
				["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
				["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "DEBUFF_BAR_COLOR",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 0.4 },
		},
		{
			["name"] = "ALWAYS",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(0, 0, 0, 0.7,   0.1, 0.1, 0.1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
	},


	[VUHDO_I18N_DEF_BAR_BACKGROUND_CLASS_COLOR] = {
		{
			["name"] = "DISCONNECTED",
			["mine"] = true, ["icon"] = 2,
			["color"] = VUHDO_makeFullColorForBouquet(0.298, 0.298, 0.298, 0.21,   0.576, 0.576, 0.576, 0.58),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "NO_RANGE",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
				["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
				["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "DEBUFF_BAR_COLOR",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "CLASS_COLOR",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(0, 0, 0, 0.7,   0.1, 0.1, 0.1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 0.4 },
		},
	},
};


VUHDO_DEFAULT_ALTERNATE_POWERS_BOUQUET = {
	[VUHDO_I18N_DEF_ALTERNATE_POWERS] = {
		{
			["name"] = "ALTERNATE_POWERS_ABOVE",
			["mine"] = true, ["icon"] = 2,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0, 0, 1,   1, 0, 0, 1),
			["custom"] = { [1] = 80, ["radio"] = 2, ["bright"] = 1 },
		},
		{
			["name"] = "ALTERNATE_POWERS_ABOVE",
			["mine"] = true, ["icon"] = 2,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0, 1,   1, 1, 0, 1),
			["custom"] = { [1] = 50, ["radio"] = 2, ["bright"] = 1 },
		},
		{
			["name"] = "STATUS_ALTERNATE_POWERS",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(0, 1, 0, 1,   0, 1, 0, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
};



VUHDO_DEFAULT_HOLY_POWER_BOUQUET = {
	[VUHDO_I18N_DEF_PLAYER_HOLY_POWER] = {
		{
			["name"] = "OWN_HOLY_POWER_EQUALS",
			["mine"] = true, ["icon"] = 14,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 5, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_HOLY_POWER_EQUALS",
			["mine"] = true, ["icon"] = 13,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 4, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_HOLY_POWER_EQUALS",
			["mine"] = true, ["icon"] = 12,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 3, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_HOLY_POWER_EQUALS",
			["mine"] = true, ["icon"] = 11,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.75, 0.4, 1,   1, 0.75, 0.4, 1),
			["custom"] = { [1] = 2, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "OWN_HOLY_POWER_EQUALS",
			["mine"] = true, ["icon"] = 10,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.4, 0.4, 1,   1, 0.4, 0.4, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
};



VUHDO_DEFAULT_CHI_BOUQUET = {
	[VUHDO_I18N_DEF_PLAYER_CHI] = {
		{
			["name"] = "OWN_CHI_EQUALS",
			["mine"] = true, ["icon"] = 14,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 6, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_CHI_EQUALS",
			["mine"] = true, ["icon"] = 14,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 5, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_CHI_EQUALS",
			["mine"] = true, ["icon"] = 13,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 4, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_CHI_EQUALS",
			["mine"] = true, ["icon"] = 12,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 3, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_CHI_EQUALS",
			["mine"] = true, ["icon"] = 11,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.75, 0.4, 1,   1, 0.75, 0.4, 1),
			["custom"] = { [1] = 2, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "OWN_CHI_EQUALS",
			["mine"] = true, ["icon"] = 10,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.4, 0.4, 1,   1, 0.4, 0.4, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
};



VUHDO_DEFAULT_COMBO_POINTS_BOUQUET = {
	[VUHDO_I18N_DEF_PLAYER_COMBO_POINTS] = {
		{
			["name"] = "OWN_COMBO_POINTS_EQUALS",
			["mine"] = true, ["icon"] = 14,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 6, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_COMBO_POINTS_EQUALS",
			["mine"] = true, ["icon"] = 14,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 5, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_COMBO_POINTS_EQUALS",
			["mine"] = true, ["icon"] = 13,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 4, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_COMBO_POINTS_EQUALS",
			["mine"] = true, ["icon"] = 12,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 3, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_COMBO_POINTS_EQUALS",
			["mine"] = true, ["icon"] = 11,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.75, 0.4, 1,   1, 0.75, 0.4, 1),
			["custom"] = { [1] = 2, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "OWN_COMBO_POINTS_EQUALS",
			["mine"] = true, ["icon"] = 10,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.4, 0.4, 1,   1, 0.4, 0.4, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
};



VUHDO_DEFAULT_SOUL_SHARDS_BOUQUET = {
	[VUHDO_I18N_DEF_PLAYER_SOUL_SHARDS] = {
		{
			["name"] = "OWN_SOUL_SHARDS_EQUALS",
			["mine"] = true, ["icon"] = 14,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 5, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_SOUL_SHARDS_EQUALS",
			["mine"] = true, ["icon"] = 13,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 4, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_SOUL_SHARDS_EQUALS",
			["mine"] = true, ["icon"] = 12,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 3, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_SOUL_SHARDS_EQUALS",
			["mine"] = true, ["icon"] = 11,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.75, 0.4, 1,   1, 0.75, 0.4, 1),
			["custom"] = { [1] = 2, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "OWN_SOUL_SHARDS_EQUALS",
			["mine"] = true, ["icon"] = 10,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.4, 0.4, 1,   1, 0.4, 0.4, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
};



VUHDO_DEFAULT_RUNES_BOUQUET = {
	[VUHDO_I18N_DEF_PLAYER_RUNES] = {
		{
			["name"] = "OWN_RUNES_EQUALS",
			["mine"] = true, ["icon"] = 14,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 6, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_RUNES_EQUALS",
			["mine"] = true, ["icon"] = 14,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 5, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_RUNES_EQUALS",
			["mine"] = true, ["icon"] = 13,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 4, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_RUNES_EQUALS",
			["mine"] = true, ["icon"] = 12,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 3, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_RUNES_EQUALS",
			["mine"] = true, ["icon"] = 11,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.75, 0.4, 1,   1, 0.75, 0.4, 1),
			["custom"] = { [1] = 2, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "OWN_RUNES_EQUALS",
			["mine"] = true, ["icon"] = 10,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.4, 0.4, 1,   1, 0.4, 0.4, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
};



VUHDO_DEFAULT_ARCANE_CHARGES_BOUQUET = {
	[VUHDO_I18N_DEF_PLAYER_ARCANE_CHARGES] = {
		{
			["name"] = "OWN_ARCANE_CHARGES_EQUALS",
			["mine"] = true, ["icon"] = 13,
			["color"] = VUHDO_makeFullColorForBouquet(0.6, 1, 0.6, 1,   0.6, 1, 0.6, 1),
			["custom"] = { [1] = 4, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_ARCANE_CHARGES_EQUALS",
			["mine"] = true, ["icon"] = 12,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 0.4, 1,   1, 1, 0.4, 1),
			["custom"] = { [1] = 3, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_ARCANE_CHARGES_EQUALS",
			["mine"] = true, ["icon"] = 11,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.75, 0.4, 1,   1, 0.75, 0.4, 1),
			["custom"] = { [1] = 2, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "OWN_ARCANE_CHARGES_EQUALS",
			["mine"] = true, ["icon"] = 10,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0.4, 0.4, 1,   1, 0.4, 0.4, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
};



VUHDO_DEFAULT_ROLE_ICON_BOUQUET = {
	[VUHDO_I18N_DEF_ROLE_ICON] = {
		{
			["name"] = "ROLE_ICON",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
};



VUHDO_DEFAULT_AOE_ADVICE_BOUQUET = {
	[VUHDO_I18N_DEF_AOE_ADVICE] = {
		{
			["name"] = "AOE_ADVICE",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
};



VUHDO_DEFAULT_DIRECTION_ARROW_BOUQUET = {
	[VUHDO_I18N_DEF_DIRECTION_ARROW] = {
		{
			["name"] = "DIRECTION",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
};



VUHDO_DEFAULT_TANKS_CDS_EXTD_BOUQUET = {
	[VUHDO_I18N_DEF_TANK_CDS_EXTENDED] = {
	},
};


VUHDO_DEFAULT_RAID_CDS_BOUQUET = {
	[VUHDO_I18N_DEF_RAID_CDS] = {
	},
};


VUHDO_DEFAULT_PVP_FLAGS_BOUQUET = {
	[VUHDO_I18N_DEF_PVP_FLAGS] = {
	},
};


VUHDO_DEFAULT_PALADIN_BEACON_BOUQUET = {
	[VUHDO_I18N_BOUQUET_PALADIN_BEACON] = {
	},
};


VUHDO_DEFAULT_OVERFLOW_COUNTER_BOUQUET = {
	[VUHDO_I18N_BOUQUET_OVERFLOW_COUNTER] = {
		{
			["name"] = "OVERFLOW_COUNTER",
			["mine"] = true, 
			["others"] = true,
			["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1, 1, 1, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1 },
		},
	},
};


VUHDO_DEFAULT_SPELL_TRACE_BOUQUET = {
	[VUHDO_I18N_DEF_SPELL_TRACE] = {
		{
			["name"] = "SPELL_TRACE",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
};


VUHDO_DEFAULT_SPELL_TRACE_INCOMING_BOUQUET = {
	[VUHDO_I18N_DEF_SPELL_TRACE_INCOMING] = {
		{
			["name"] = "SPELL_TRACE_INCOMING",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
};


VUHDO_DEFAULT_TRAIL_OF_LIGHT_BOUQUET = {
	[VUHDO_I18N_DEF_TRAIL_OF_LIGHT] = {
		{
			["name"] = "TRAIL_OF_LIGHT",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
};


VUHDO_DEFAULT_TRAIL_OF_LIGHT_NEXT_BOUQUET = {
	[VUHDO_I18N_DEF_TRAIL_OF_LIGHT_NEXT] = {
		{
			["name"] = "TRAIL_OF_LIGHT_NEXT",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
};


--
VUHDO_DEFAULT_GRID_BOUQUETS = {
	[VUHDO_I18N_GRID_MOUSEOVER_SINGLE] = {
		{
			["name"] = "MOUSE_TARGET",
			["mine"] = true, ["icon"] = 2,
			["color"] = VUHDO_makeFullColorForBouquet(0.619, 0.541, 0.184, 0.6,   1, 1, 1, 0.75),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1 },
		},
	},

	[VUHDO_I18N_GRID_BACKGROUND_BAR] = {
		{
			["name"] = "DISCONNECTED",
			["mine"] = true, ["icon"] = 2,
			["color"] = VUHDO_makeFullColorForBouquet(0.298, 0.298, 0.298, 0.21,   0.576, 0.576, 0.576, 0.58),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1 },
		},

		{
			["name"] = "NO_RANGE",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
				["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
				["isManuallySet"] = true, ["useBackground"] = false, ["useText"] = false, ["useOpacity"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1 },

		},

		{
			["name"] = "CLASS_COLOR",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(0, 0, 0, 0.7,   0.1, 0.1, 0.1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 0.2 },

		},
	},
};



--
VUHDO_DEFAULT_ROLE_COLOR_BOUQUET = {
	[VUHDO_I18N_DEF_ROLE_COLOR] = {
		{
			["name"] = "ROLE_TANK",
			["icon"] = 6,
			["color"] = VUHDO_makeFullColorForBouquet(0, 0, 1, 1,   0, 0, 1, 1),
			["custom"] = { [1] = 0, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "ROLE_DAMAGE",
			["icon"] = 6,
			["color"] = VUHDO_makeFullColorForBouquet(1, 0, 0, 1,   1, 0, 0, 1),
			["custom"] = { [1] = 0, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "ROLE_HEALER",
			["icon"] = 6,
			["color"] = VUHDO_makeFullColorForBouquet(0, 1, 0, 1,   0, 1, 0, 1),
			["custom"] = { [1] = 0, ["radio"] = 1, ["bright"] = 1	},
		},
	},
}



--
VUHDO_DEFAULT_BAR_MANA_HEALER_ONLY = {
	[VUHDO_I18N_DEF_BOUQUET_BAR_MANA_HEALER_ONLY] = {
		{
			["name"] = "NO_RANGE",
			["mine"] = true, ["icon"] = 2,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
				["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
				["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 2, ["bright"] = 1.0 },
		},
		{
			["name"] = "STATUS_MANA_HEALER_ONLY",
			["mine"] = true, ["icon"] = 2,
			["color"] = VUHDO_makeFullColorForBouquet(0, 0, 1, 1,   0, 0, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
		},
	},
}


--
VUHDO_DEFAULT_ICON_HAS_SUMMON = {
	[VUHDO_I18N_DEF_BOUQUET_HAS_SUMMON] = {
		{
			["name"] = "HAS_SUMMON_ICON",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}



--
VUHDO_DEFAULT_ICON_ROLE_AND_SUMMON = {
	[VUHDO_I18N_DEF_BOUQUET_ROLE_AND_SUMMON] = {
		{
			["name"] = "HAS_SUMMON_ICON",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
		{
			["name"] = "ROLE_ICON",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}



--
VUHDO_DEFAULT_ICON_IS_PHASED = {
	[VUHDO_I18N_DEF_BOUQUET_IS_PHASED] = {
		{
			["name"] = "IS_PHASED_ICON",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}



--
VUHDO_DEFAULT_BAR_MANA_TANK_ONLY = {
	[VUHDO_I18N_DEF_BOUQUET_BAR_MANA_TANK_ONLY] = {
		{
			["name"] = "NO_RANGE",
			["mine"] = true, ["icon"] = 2,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
				["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
				["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 2, ["bright"] = 1.0 },
		},
		{
			["name"] = "STATUS_POWER_TANK_ONLY",
			["mine"] = true, ["icon"] = 2,
			["color"] = VUHDO_makeFullColorForBouquet(0, 0, 1, 1,   0, 0, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
		},
	},
}



--
VUHDO_DEFAULT_MONK_STAGGER_BOUQUET = {
	[VUHDO_I18N_DEF_BOUQUET_MONK_STAGGER] = {
		{
			["name"] = GetSpellName(124273), -- "Heavy Stagger",
			["mine"] = true, ["others"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = GetSpellName(124274), -- "Moderate Stagger",
			["mine"] = true, ["others"] = true,	["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
		},
		{
			["name"] = GetSpellName(124275), -- "Light Stagger",
			["mine"] = true, ["others"] = true,	["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
		}
	}
}



--
VUHDO_DEFAULT_HEAL_ABSORB_COUNTER_BOUQUET = {
	[VUHDO_I18N_DEF_COUNTER_HEAL_ABSORB] = {
		{
			["name"] = "HEAL_ABSORB_COUNTER",
			["mine"] = true, 
			["others"] = true,
			["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1, 1, 1, 1, 1),
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1 },
		},
	},
};



--
VUHDO_DEFAULT_EVOKER_REVERSION_BOUQUET = {
	[VUHDO_I18N_BOUQUET_EVOKER_REVERSION] = {
	},
};

VUHDO_DEFAULT_EVOKER_REVERSION_ECHO_BOUQUET = {
	[VUHDO_I18N_BOUQUET_EVOKER_REVERSION_ECHO] = {
	},
};

VUHDO_DEFAULT_EVOKER_DREAM_BREATH_BOUQUET = {
	[VUHDO_I18N_BOUQUET_EVOKER_DREAM_BREATH] = {
	},
};

VUHDO_DEFAULT_EVOKER_DREAM_BREATH_ECHO_BOUQUET = {
	[VUHDO_I18N_BOUQUET_EVOKER_DREAM_BREATH_ECHO] = {
	},
};

VUHDO_DEFAULT_EVOKER_ALL_ECHO_BOUQUET = {
	[VUHDO_I18N_BOUQUET_EVOKER_ALL_ECHO] = {
	},
};



--
VUHDO_DEFAULT_CHI_HARMONY_ICON_MINE_BOUQUET = {
	[VUHDO_I18N_DEF_BOUQUET_CHI_HARMONY_ICON_MINE] = {
		{
			["name"] = "CHI_HARMONY_ICON_MINE",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}

VUHDO_DEFAULT_CHI_HARMONY_ICON_OTHERS_BOUQUET = {
	[VUHDO_I18N_DEF_BOUQUET_CHI_HARMONY_ICON_OTHERS] = {
		{
			["name"] = "CHI_HARMONY_ICON_OTHERS",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}

VUHDO_DEFAULT_CHI_HARMONY_ICON_BOTH_BOUQUET = {
	[VUHDO_I18N_DEF_BOUQUET_CHI_HARMONY_ICON_BOTH] = {
		{
			["name"] = "CHI_HARMONY_ICON_BOTH",
			["mine"] = true, ["icon"] = 1,
			["color"] = VUHDO_makeFullColorForBouquet(1, 1, 1, 1,   1, 1, 1, 1),
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}



--
VUHDO_DEFAULT_INDICATOR_CONFIG = {
	["VERSION"] = 2,
};



--
VUHDO_DEFAULT_INDICATOR_CONFIG_PER_PANEL = {
	["BOUQUETS"] = {
		["AGGRO_BAR"] = "",
		["BACKGROUND_BAR"] = VUHDO_I18N_DEF_BAR_BACKGROUND_SOLID,
		["BAR_BORDER"] = VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI_AGGRO,
		["CLUSTER_BORDER"] = "",
		["DAMAGE_FLASH_BAR"] = "",
		["HEALTH_BAR"] = VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_CLASS_COLOR,
		["INCOMING_BAR"] = "",
		["MANA_BAR"] = VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ONLY,
		["MOUSEOVER_HIGHLIGHT"] = "",
		["SWIFTMEND_INDICATOR"] = "",
		["THREAT_BAR"] = "",
		["THREAT_MARK"] = "",
		["SIDE_LEFT"] = "",
		["SIDE_RIGHT"] = "",
	},

	["CUSTOM"] = {
		["AGGRO_BAR"] = {
			["TEXTURE"] = "VuhDo - Polished Wood",
		},
		["BACKGROUND_BAR"] = {
			["TEXTURE"] = "VuhDo - Minimalist",
		},
		["BAR_BORDER"] = {
			["WIDTH"] = 1,
			["FILE"] = "Interface\\AddOns\\VuhDo\\Images\\white_square_16_16",
			["ADJUST"] = 0.000001,
		},
		["CLUSTER_BORDER"] = {
			["WIDTH"] = 2,
			["FILE"] = "Interface\\AddOns\\VuhDo\\Images\\white_square_16_16",
		},
		["MANA_BAR"] = {
			["TEXTURE"] = "VuhDo - Pipe, light",
			["invertGrowth"] = false,
			["turnAxis"] = false,
		},
		["MOUSEOVER_HIGHLIGHT"] = {
			["TEXTURE"] = "VuhDo - Aluminium",
		},
		["SWIFTMEND_INDICATOR"] = {
			["SCALE"] = 1,
		},
		["THREAT_BAR"] = {
			["HEIGHT"] = 4,
			["WARN_AT"] = 85,
			["TEXTURE"] = "VuhDo - Polished Wood",
			["invertGrowth"] = false,
			["turnAxis"] = false,
		},
		["HEALTH_BAR"] = {
			["invertGrowth"] = false,
			["vertical"] = false,
			["turnAxis"] = false,
			["turnAxisOvershield"] = false,
			["turnAxisHealAbsorb"] = false,
		},
		["SIDE_LEFT"] = {
			["TEXTURE"] = "VuhDo - Plain White",
			["invertGrowth"] = false,
			["vertical"] = true,
			["turnAxis"] = false,
		},
		["SIDE_RIGHT"] = {
			["TEXTURE"] = "VuhDo - Plain White",
			["invertGrowth"] = false,
			["vertical"] = true,
			["turnAxis"] = false,
		},
		["HOT_BARS"] = {
			["invertGrowth"] = false,
			["vertical"] = false,
			["turnAxis"] = false,
		}
	},


	["TEXT_INDICATORS"] = {
		["OVERHEAL_TEXT"] = {
			["TEXT_PROVIDER"] = "OVERHEAL_KILO_PLUS_N_K",
		},
		["MANA_BAR"] = {
			["TEXT"] = {
				["ANCHOR"] = "RIGHT",
				["X_ADJUST"] = 7,
				["Y_ADJUST"] = 2,
				["SCALE"] = 20,
				["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
				["COLOR"] = VUHDO_makeFullColor(0, 0, 0, 1,   0.36, 0.55, 1, 1),
				["USE_SHADOW"] = true,
				["USE_OUTLINE"] = false,
				["USE_MONO"] = false,
			},
			["TEXT_PROVIDER"] = "",
		},
		["SIDE_LEFT"] = {
			["TEXT"] = {
				["ANCHOR"] = "BOTTOM",
				["X_ADJUST"] = 3,
				["Y_ADJUST"] = 0,
				["SCALE"] = 18,
				["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
				["COLOR"] = VUHDO_makeFullColor(0, 0, 0, 1,   1, 1, 1, 1),
				["USE_SHADOW"] = false,
				["USE_OUTLINE"] = true,
				["USE_MONO"] = false,
			},
			["TEXT_PROVIDER"] = "",
		},
		["SIDE_RIGHT"] = {
			["TEXT"] = {
				["ANCHOR"] = "BOTTOM",
				["X_ADJUST"] = 4,
				["Y_ADJUST"] = 0,
				["SCALE"] = 18,
				["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
				["COLOR"] = VUHDO_makeFullColor(0, 0, 0, 1,   1, 1, 1, 1),
				["USE_SHADOW"] = false,
				["USE_OUTLINE"] = true,
				["USE_MONO"] = false,
			},
			["TEXT_PROVIDER"] = "",
		},
		["THREAT_BAR"] = {
			["TEXT"] = {
				["ANCHOR"] = "RIGHT",
				["X_ADJUST"] = 7,
				["Y_ADJUST"] = 2,
				["SCALE"] = 20,
				["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
				["COLOR"] = VUHDO_makeFullColor(0, 0, 0, 1,   1, 0, 0, 1),
				["USE_SHADOW"] = true,
				["USE_OUTLINE"] = false,
				["USE_MONO"] = false,
			},
			["TEXT_PROVIDER"] = "",
		},
	}
};



VUHDO_SANE_BOUQUET_ITEM = {
	["name"] = VUHDO_I18N_BOUQUET_NEW_ITEM_NAME,
	["mine"] = true,
	["others"] = true,
	["icon"] = 2,
	["color"] = {
		["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
		["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
		["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		["isManuallySet"] = false,
	},
	["custom"] = {
		[1] = 1,
		["radio"] = 1,
		["bright"] = 1.0,
		["function"] = "return true;",
		["spellTrace"] = "",
	},
};



local pairs = pairs;

--
local function VUHDO_addDefaultBouquet(aName)
	if (aName == nil) then
		return;
	end
	aName = VUHDO_decompressIfCompressed(aName);
	for tKey, _ in pairs(aName) do
		VUHDO_BOUQUETS["STORED"][tKey] = VUHDO_deepCopyTable(aName[tKey]);
	end
end



--
local tCopy;
local function VUHDO_deepCopyColor(aColorTable)
	tCopy = VUHDO_deepCopyTable(aColorTable);
	tCopy["R"] = tCopy["R"] or 1;
	tCopy["G"] = tCopy["G"] or 1;
	tCopy["B"] = tCopy["B"] or 1;
	tCopy["O"] = tCopy["O"] or 1;
	tCopy["TR"] = tCopy["TR"] or 1;
	tCopy["TG"] = tCopy["TG"] or 1;
	tCopy["TB"] = tCopy["TB"] or 1;
	tCopy["TO"] = tCopy["TO"] or 1;
	return tCopy;
end



--
local function VUHDO_createBouquetItem(anEvent, aColor)
	local tItem = VUHDO_deepCopyTable(VUHDO_SANE_BOUQUET_ITEM);
	tItem["name"] = anEvent;
	if aColor then tItem["color"] = VUHDO_deepCopyColor(aColor); end
	tItem["color"]["isManuallySet"] = true;
	return tItem;
end



--
local tItem;
local tBouquet;
local tTextColor;
local tColor;
local function _VUHDO_buildGenericHealthBarBouquet(aType, aName)
	tBouquet = { };

	-- Disconnected
	tItem = VUHDO_createBouquetItem("DISCONNECTED", VUHDO_PANEL_SETUP["BAR_COLORS"]["OFFLINE"]);
	tBouquet[1] = tItem;

	-- Out of Range
	tColor = VUHDO_PANEL_SETUP["BAR_COLORS"]["OUTRANGED"];
	if tColor["useText"] or tColor["useBackground"] or tColor["useOpacity"] then
		tItem = VUHDO_createBouquetItem("NO_RANGE", tColor);
		tBouquet[#tBouquet + 1] = tItem;
	end

	-- Resurrection
	tItem = VUHDO_createBouquetItem("RESURRECTION", { ["TR"] = 0.4, ["TG"] = 1, ["TB"] = 0.4, ["useText"] = true });
	tBouquet[#tBouquet + 1] = tItem;

	-- Dead
	tItem = VUHDO_createBouquetItem("DEAD", VUHDO_PANEL_SETUP["BAR_COLORS"]["DEAD"]);
	tBouquet[#tBouquet + 1] = tItem;

	-- Overheal Erheller
	if VUHDO_CONFIG["SHOW_OVERHEAL"] then
		tItem = VUHDO_createBouquetItem("OVERHEAL_HIGHLIGHT", nil);
		tBouquet[#tBouquet + 1] = tItem;
	end

	-- Debuff Color
	tItem = VUHDO_createBouquetItem("DEBUFF_BAR_COLOR", nil);
	tBouquet[#tBouquet + 1] = tItem;

	-- Raid Icon color
	if VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"]["enable"] and VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"]["enable"] then
		tItem = VUHDO_createBouquetItem("RAID_ICON_COLOR", nil);
		tBouquet[#tBouquet + 1] = tItem;
	end

	if VUHDO_CONFIG["MODE"] == VUHDO_MODE_NEUTRAL then
		-- Irrelevant
		if VUHDO_CONFIG["EMERGENCY_TRIGGER"] < 100 then
			tItem = VUHDO_createBouquetItem("HEALTH_ABOVE", VUHDO_PANEL_SETUP["BAR_COLORS"]["IRRELEVANT"]);
			tItem["custom"][1] = VUHDO_CONFIG["EMERGENCY_TRIGGER"];
			tBouquet[#tBouquet + 1] = tItem;
		end

		-- Health Bar Texts
		if VUHDO_PANEL_SETUP["PANEL_COLOR"]["classColorsName"] then
			tItem = VUHDO_createBouquetItem("CLASS_COLOR", nil);
			tItem["color"]["useBackground"] = false;
			tItem["color"]["useOpacity"] = false;
			tBouquet[#tBouquet + 1] = tItem;
		else
			tTextColor = VUHDO_PANEL_SETUP["PANEL_COLOR"]["TEXT"];
			tItem = VUHDO_createBouquetItem("ALWAYS", tTextColor);
			tItem["color"]["useBackground"] = false;
			tItem["color"]["useOpacity"] = false;
			tBouquet[#tBouquet + 1] = tItem;
		end

		-- Health Bar
		if aType == 0 then
			tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["GOOD"]);
			tItem["color"]["useOpacity"] = true;
			tItem["custom"]["grad_med"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["FAIR"]);
			tItem["custom"]["grad_med"]["useOpacity"] = true;
			tItem["custom"]["grad_low"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["LOW"]);
			tItem["custom"]["grad_low"]["useOpacity"] = true;
			tItem["custom"]["radio"] = 3; -- gradient

		elseif aType == 1 then
			tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["PANEL_COLOR"]["BARS"]);
			tItem["custom"]["radio"] = 2; -- class color

			if VUHDO_USER_CLASS_GRADIENT_COLORS and VUHDO_USER_CLASS_GRADIENT_COLORS["isClassGradient"] then
				tItem["custom"]["isClassGradient"] = true;
			end
		else -- Solid == 2, Chimaeron == 3
			tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["PANEL_COLOR"]["BARS"]);
			tItem["custom"]["radio"] = 1; -- solid

			if VUHDO_PANEL_SETUP["PANEL_COLOR"]["isSolidGradient"] then
				tItem["custom"]["isSolidGradient"] = true;

				tItem["custom"]["maxColor"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["PANEL_COLOR"]["solidMaxColor"]);
				tItem["custom"]["maxColor"]["useOpacity"] = true;
			end
		end

		tItem["color"]["mode"] = nil;
		tBouquet[#tBouquet + 1] = tItem;

	else
		if VUHDO_PANEL_SETUP["PANEL_COLOR"]["classColorsName"] then
			tItem = VUHDO_createBouquetItem("CLASS_COLOR", nil);
			tItem["color"]["useBackground"] = false;
			tItem["color"]["useOpacity"] = false;
			tBouquet[#tBouquet + 1] = tItem;
		end

		-- Emergency
		tItem = VUHDO_createBouquetItem("EMERGENCY_COLOR", VUHDO_PANEL_SETUP["BAR_COLORS"]["EMERGENCY"]);
		tItem["custom"][1] = VUHDO_CONFIG["EMERGENCY_TRIGGER"];
		tBouquet[#tBouquet + 1] = tItem;

		-- No Emergency Bar
		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["NO_EMERGENCY"]);
		tItem["custom"]["radio"] = 1; -- solid
		tBouquet[#tBouquet + 1] = tItem;
	end

	VUHDO_BOUQUETS["STORED"][aName] = tBouquet;
end



--
function VUHDO_buildGenericHealthBarBouquet()
	_VUHDO_buildGenericHealthBarBouquet(0, VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH);
	_VUHDO_buildGenericHealthBarBouquet(1, VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_CLASS_COLOR);
	_VUHDO_buildGenericHealthBarBouquet(2, VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_SOLID);
end



--
local tBouquet;
function VUHDO_buildGenericTargetHealthBouquet()
	tBouquet = { };

	-- Disconnected
	tItem = VUHDO_createBouquetItem("DISCONNECTED", VUHDO_PANEL_SETUP["BAR_COLORS"]["OFFLINE"]);
	tBouquet[1] = tItem;

	-- Out of Range
	tColor = VUHDO_PANEL_SETUP["BAR_COLORS"]["OUTRANGED"];
	if tColor["useText"] or tColor["useBackground"] or tColor["useOpacity"] then
		tItem = VUHDO_createBouquetItem("NO_RANGE", tColor);
		tBouquet[#tBouquet + 1] = tItem;
	end

	-- Dead
	tItem = VUHDO_createBouquetItem("DEAD", VUHDO_PANEL_SETUP["BAR_COLORS"]["DEAD"]);
	tBouquet[#tBouquet + 1] = tItem;

	-- Tapped
	tItem = VUHDO_createBouquetItem("TAPPED", VUHDO_PANEL_SETUP["BAR_COLORS"]["TAPPED"]);
	tBouquet[#tBouquet + 1] = tItem;

	-- Raid Icon color
	if VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"]["enable"] and VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"]["enable"] then
		tItem = VUHDO_createBouquetItem("RAID_ICON_COLOR", nil);
		tBouquet[#tBouquet + 1] = tItem;
	end

	-- 1=enemy, 2=solid, 3=class color, 4=gradient
	-- Health Bar Texts
	if VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeText"] == 1 then
		tItem = VUHDO_createBouquetItem("ENEMY_STATE", nil);
		tItem["color"]["useBackground"] = false;
		tItem["color"]["useOpacity"] = false;
		tBouquet[#tBouquet + 1] = tItem;
	elseif VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeText"] == 2 then
		tTextColor = VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"];
		tItem = VUHDO_createBouquetItem("ALWAYS", tTextColor);
		tItem["color"]["useBackground"] = false;
		tItem["color"]["useOpacity"] = false;
		tBouquet[#tBouquet + 1] = tItem;
	elseif VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeText"] == 3 then
		tItem = VUHDO_createBouquetItem("CLASS_COLOR", nil);
		tItem["color"]["useBackground"] = false;
		tItem["color"]["useOpacity"] = false;
		tBouquet[#tBouquet + 1] = tItem;
	end

	if VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeBack"] == 1 then
		tItem = VUHDO_createBouquetItem("ENEMY_STATE", nil);
		tItem["custom"]["radio"] = 1; -- solid
		tBouquet[#tBouquet + 1] = tItem;

		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]);
		tItem["custom"]["radio"] = 1; -- solid

	elseif VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeBack"] == 2 then
		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]);
		tItem["custom"]["radio"] = 1; -- solid

	elseif VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeBack"] == 3 then
		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]);
		tItem["custom"]["radio"] = 2; -- class color

	else
		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["GOOD"]);
		tItem["color"]["useOpacity"] = true;
		tItem["custom"]["grad_med"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["FAIR"]);
		tItem["custom"]["grad_med"]["useOpacity"] = true;
		tItem["custom"]["grad_low"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["LOW"]);
		tItem["custom"]["grad_low"]["useOpacity"] = true;
		tItem["custom"]["radio"] = 3; -- gradient
	end

	tBouquet[#tBouquet + 1] = tItem;
	VUHDO_BOUQUETS["STORED"][VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH] = tBouquet;
end



--
local function VUHDO_addSpellBouquetItem(aBouquetName, anIsAddById, ...)

	local tId, tNewItem, tName;

	for tCnt = 1, select("#", ...) do
		tId = select(tCnt, ...);

		tNewItem = VUHDO_deepCopyTable(VUHDO_SANE_BOUQUET_ITEM);

		if anIsAddById then
			tName = tostring(tId);
		else
			tName = GetSpellName(tId);
		end

		tNewItem["name"] = tName;
		tNewItem["icon"] = 1;
		tNewItem["color"]["isManuallySet"] = true;

		tinsert(VUHDO_BOUQUETS["STORED"][aBouquetName], tNewItem);
	end

	return tNewItem;

end



--
local tSpecial;
local tItem;
local function VUHDO_ensureBouquetItemSanity(aName, anIndex)
	VUHDO_BOUQUETS["STORED"][aName][anIndex] = VUHDO_ensureSanity(
		"VUHDO_BOUQUETS.STORED",
		VUHDO_BOUQUETS["STORED"][aName][anIndex],
		VUHDO_SANE_BOUQUET_ITEM
	);

	tItem = VUHDO_BOUQUETS["STORED"][aName][anIndex];
	if tItem["custom"]["radio"] == 3 then
		if tItem["custom"]["grad_med"] == nil then
			tItem["custom"]["grad_med"]  = {
				["R"] = 0.6, ["G"] = 0.6, ["B"] = 0.6, ["O"] = 1,
				["TR"] = 0.6, ["TG"] = 0.6, ["TB"] = 0.6, ["TO"] = 1,
				["useText"] = false, ["useBackground"] = true, ["useOpacity"] = true,
			};
		end

		if tItem["custom"]["grad_low"] == nil then
			tItem["custom"]["grad_low"] = {
				["R"] = 0.3, ["G"] = 0.3, ["B"] = 0.3, ["O"] = 1,
				["TR"] = 0.3, ["TG"] = 0.3, ["TB"] = 0.3, ["TO"] = 1,
				["useText"] = false, ["useBackground"] = true, ["useOpacity"] = true,
			};
		end

		tSpecial = VUHDO_BOUQUET_BUFFS_SPECIAL[tItem["name"]]; -- Statusbalken haben keine Textfarbe
		if tSpecial and tSpecial["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR then
			tItem["color"].TR, tItem["color"].TG, tItem["color"].TB, tItem["color"].useText = nil, nil, nil, false;
			tItem["custom"]["grad_med"].TR, tItem["custom"]["grad_med"].TG, tItem["custom"]["grad_med"].TB, tItem["custom"]["grad_med"].useText = nil, nil, nil, false;
			tItem["custom"]["grad_low"].TR, tItem["custom"]["grad_low"].TG, tItem["custom"]["grad_low"].TB, tItem["custom"]["grad_low"].useText = nil, nil, nil, false;
		end

	else -- kein gradient
		tItem["custom"]["grad_med"] = nil;
		tItem["custom"]["grad_low"] = nil;
	end
end



--
function VUHDO_ensureAllBouquetItemsSanity()
	VUHDO_decompressAllBouquets();

	for tName, tAllInfos in pairs(VUHDO_BOUQUETS["STORED"]) do

		if (tAllInfos == nil or "table" ~= type(tAllInfos)) then
			VUHDO_BOUQUETS["STORED"][tName] = { };
		end

		for tIndex, tInfo in pairs(VUHDO_BOUQUETS["STORED"][tName]) do
			tInfo["name"] = strtrim(tInfo["name"] or "");
			if (tInfo["name"] == "") then
				tremove(tAllInfos, tIndex);
			else
				VUHDO_ensureBouquetItemSanity(tName, tIndex);
			end
		end
	end
end



local tTankCdsExtended = {
	116888, --Shroud of Purgatory
	48792, --Icebound Fortitude
	49028, --Dancing Rune Weapon
	55233, --Vampiric Blood
	194679, --Rune Tap
	48707, --Anti-Magic Shell
	50461, --Anti-Magic Zone
	195181, --Bone Shield
	49039, --Lichborne
	81164, --Will of the Necropolis

	642, --Divine Shield
	498, --Divine Protection
	31850, --Ardent Defender
	86659, --Guardian of Ancient Kings
	53600, --Shield of the Righteous

	871, --Shield Wall
	12975, --Last Stand
	23920, --Spell Reflection
	190456, --Ignore Pain
	2565, --Shield Block

	102558, --Incarnation: Guardian of Ursoc
	61336, --Survival Instincts
	22842, --Frenzied Regeneration
	22812, --Barkskin
	102342, --Ironbark
	192081, --Ironfur

	187827, --Metamorphosis
	203720, --Demon Spikes

	115203, --Fortifying Brew
	122278, --Dampen Harm
	115176, --Zen meditation
	215479  --Shuffle
};



local tRaidCds = {
	-- Pally
	642, --Divine Shield
	498, --Divine Protection
	31850, --Ardent Defender
	1022, --Blessing of Protection
	204018, --Blessing of Spellwarding
	86659, --Guardian of Ancient Kings
	6940, --Blessing of Sacrifice
	31821, --Aura Mastery
	53600, --Shield of the Righteous

	-- Warrior
	97462, -- Rallying Cry
	871, --Shield Wall
	12975, --Last Stand
	23920, --Spell Reflection
	190456, --Ignore Pain
	2565, --Shield Block
	3411, --Intervene
	114028, --Mass Spell Reflect
	118038, --Die by the Sword
	184364, --Enraged Regeneration

	-- Druid
	102558, --Incarnation: Guardian of Ursoc
	61336, --Survival Instincts
	22842, --Frenzied Regeneration
	22812, --Barkskin
	102342, --Ironbark
	192081, --Ironfur
	740, --Tranquility

	-- Death Knight
	116888, --Shroud of Purgatory
	48792, --Icebound Fortitude
	49028, --Dancing Rune Weapon
	55233, --Vampiric Blood
	194679, --Rune Tap
	48707, --Anti-Magic Shell
	50461, --Anti-Magic Zone
	195181, --Bone Shield
	49039, --Lichborne
	81164, --Will of the Necropolis

	-- Warlock
	104773, --Unending Resolve
	108359, --Dark Regeneration
	108416, --Dark Pact

	-- Priest
	47585, --Dispersion
	64843, --Divine Hymn
	47788, --Guardian Spirit
	33206, --Pain Suppression
	62618, --Power Word: Barrier
	19236, --Desperate Prayer
	586, --Fade

	-- Shaman
	98008, --Spirit Link Totem
	16190, --Mana Tide Totem
	108280, --Healing Tide Totem
	118337, --Harden Skin
	108271, --Astral Shift
	114893, --Stone Bulwark

	-- Rogue
	5277, --Evasion
	185311, --Crimson Vial
	1966, --Feint
	31224, --Cloak of Shadows
	114018, --Shroud of Concealment
	76577, --Smoke Bomb
	31230, --Cheat death

	-- Mage,
	45438, --Ice Block
	86949, --Cauterize
	110959, --Greater Invisibility
	342246, --Alter Time
	414658, --Ice Cold
	55342, --Mirror Image

	-- Hunter
	186265, --Aspect of the Turtle
	264735, --Survival of the Fittest
	90361, --Spirit Mend

	-- Monk
	115203, --Fortifying Brew
	115176, --Zen meditation
	122278, --Dampen Harm
	116849, --Life Cocoon
	122783, --Diffuse Magic
	122470, --Touch of Karma

	-- Demon Hunter
	187827, --Metamorphosis
	203720, --Demon Spikes
	198589, --Blur
	196555, --Netherwalk
	196718, --Darkness

	-- Evoker
	370960, --Emerald Communion
	374348, --Renewing Blaze
	363916  --Obsidian Scales

};


local tPvPFlags = {
	23333, -- Horde Flag
	23335, -- Alliance Flag
	34976, -- Netherstorm Flag
	127163, -- Power Orb
	121164, -- Orb of Power
};


local tPaladinBeacons = {
	156910, -- Beacon of Faith
	197446, -- Beacon of the Lightbringer
	200025, -- Beacon of Virtue
	53563, -- Beacon of Light
};



local tEvokerReversionSpellIds = {
	366155, -- Reversion (non-echo)
};


local tEvokerReversionEchoSpellIds = {
	367364, -- Reversion (echo)
};


local tEvokerDreamBreathSpellIds = {
	355941, -- Dream Breath (non-echo)
};


local tEvokerDreamBreathEchoSpellIds = {
	376788, -- Dream Breath (echo)
};



--
function VUHDO_loadDefaultBouquets()

	if not VUHDO_BOUQUETS then
		VUHDO_BOUQUETS = VUHDO_decompressOrCopy(VUHDO_DEFAULT_BOUQUETS);
	end

	VUHDO_DEFAULT_BOUQUETS = VUHDO_compressAndPackTable(VUHDO_DEFAULT_BOUQUETS);

	if VUHDO_BOUQUETS["VERSION"] < 2 then
		VUHDO_BOUQUETS["VERSION"] = 2;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_BACKGROUND_BOUQUETS);
	end
	VUHDO_DEFAULT_BACKGROUND_BOUQUETS = nil;

	if VUHDO_BOUQUETS["VERSION"] < 3 then
		VUHDO_BOUQUETS["VERSION"] = 3;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ALTERNATE_POWERS_BOUQUET);
	end
	VUHDO_DEFAULT_ALTERNATE_POWERS_BOUQUET = nil;


	if VUHDO_BOUQUETS["VERSION"] < 4 then
		VUHDO_BOUQUETS["VERSION"] = 4;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_TANKS_CDS_EXTD_BOUQUET);
		VUHDO_addSpellBouquetItem(VUHDO_I18N_DEF_TANK_CDS_EXTENDED, false, unpack(tTankCdsExtended));
	end
	tTankCdsExtended = nil;

	if VUHDO_BOUQUETS["VERSION"] < 5 then
		VUHDO_BOUQUETS["VERSION"] = 5;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ROLE_ICON_BOUQUET);
	end
	VUHDO_DEFAULT_ROLE_ICON_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 6 then
		VUHDO_BOUQUETS["VERSION"] = 6;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_AOE_ADVICE_BOUQUET);
	end
	VUHDO_DEFAULT_AOE_ADVICE_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 8 then
		VUHDO_BOUQUETS["VERSION"] = 8;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_DIRECTION_ARROW_BOUQUET);
	end
	VUHDO_DEFAULT_DIRECTION_ARROW_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 9 then
		VUHDO_BOUQUETS["VERSION"] = 9;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_GRID_BOUQUETS);
	end
	VUHDO_DEFAULT_GRID_BOUQUETS = nil;

	if VUHDO_BOUQUETS["VERSION"] < 10 then
		VUHDO_BOUQUETS["VERSION"] = 10;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ROLE_COLOR_BOUQUET);
	end
	VUHDO_DEFAULT_ROLE_COLOR_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 11 then
		VUHDO_BOUQUETS["VERSION"] = 11;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_HOLY_POWER_BOUQUET);
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_CHI_BOUQUET);
	end
	VUHDO_DEFAULT_CHI_BOUQUET = nil;
	VUHDO_DEFAULT_HOLY_POWER_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 12 then
		VUHDO_BOUQUETS["VERSION"] = 12;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_RAID_CDS_BOUQUET);
		VUHDO_addSpellBouquetItem(VUHDO_I18N_DEF_RAID_CDS, false, unpack(tRaidCds));
	end
	tRaidCds = nil;

	if VUHDO_BOUQUETS["VERSION"] < 13 then
		VUHDO_BOUQUETS["VERSION"] = 13;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_PVP_FLAGS_BOUQUET);
		VUHDO_addSpellBouquetItem(VUHDO_I18N_DEF_PVP_FLAGS, false, unpack(tPvPFlags));
	end
	tPvPFlags = nil;

	if VUHDO_BOUQUETS["VERSION"] < 14 then
		VUHDO_BOUQUETS["VERSION"] = 14;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_PALADIN_BEACON_BOUQUET);
		VUHDO_addSpellBouquetItem(VUHDO_I18N_BOUQUET_PALADIN_BEACON, false, unpack(tPaladinBeacons));
	end
	tPaladinBeacons = nil;

	if VUHDO_BOUQUETS["VERSION"] < 15 then
		VUHDO_BOUQUETS["VERSION"] = 15;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_OVERFLOW_COUNTER_BOUQUET);
	end
	VUHDO_DEFAULT_OVERFLOW_COUNTER_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 16 then
		VUHDO_BOUQUETS["VERSION"] = 16;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_SPELL_TRACE_BOUQUET);
	end
	VUHDO_DEFAULT_SPELL_TRACE_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 17 then
		VUHDO_BOUQUETS["VERSION"] = 17;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_TRAIL_OF_LIGHT_BOUQUET);
	end
	VUHDO_DEFAULT_TRAIL_OF_LIGHT_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 18 then
		VUHDO_BOUQUETS["VERSION"] = 18;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_BAR_MANA_HEALER_ONLY);
	end
	VUHDO_DEFAULT_BAR_MANA_HEALER_ONLY = nil;

	if VUHDO_BOUQUETS["VERSION"] < 19 then
		VUHDO_BOUQUETS["VERSION"] = 19;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ICON_HAS_SUMMON);
	end
	VUHDO_DEFAULT_ICON_HAS_SUMMON = nil;

	if VUHDO_BOUQUETS["VERSION"] < 20 then
		VUHDO_BOUQUETS["VERSION"] = 20;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ICON_ROLE_AND_SUMMON);
	end
	VUHDO_DEFAULT_ICON_ROLE_AND_SUMMON = nil;

	if VUHDO_BOUQUETS["VERSION"] < 21 then
		VUHDO_BOUQUETS["VERSION"] = 21;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ICON_IS_PHASED);
	end
	VUHDO_DEFAULT_ICON_IS_PHASED = nil;

	if VUHDO_BOUQUETS["VERSION"] < 22 then
		VUHDO_BOUQUETS["VERSION"] = 22;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_COMBO_POINTS_BOUQUET);
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_SOUL_SHARDS_BOUQUET);
	end
	VUHDO_DEFAULT_COMBO_POINTS_BOUQUET = nil;
	VUHDO_DEFAULT_SOUL_SHARDS_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 23 then
		VUHDO_BOUQUETS["VERSION"] = 23;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_RUNES_BOUQUET);
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ARCANE_CHARGES_BOUQUET);
	end
	VUHDO_DEFAULT_RUNES_BOUQUET = nil;
	VUHDO_DEFAULT_ARCANE_CHARGES_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 24 then
		VUHDO_BOUQUETS["VERSION"] = 24;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_MONK_STAGGER_BOUQUET);
	end
	VUHDO_DEFAULT_MONK_STAGGER_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 25 then
		VUHDO_BOUQUETS["VERSION"] = 25;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_BAR_MANA_TANK_ONLY);
	end
	VUHDO_DEFAULT_BAR_MANA_TANK_ONLY = nil;

	if VUHDO_BOUQUETS["VERSION"] < 26 then
		VUHDO_BOUQUETS["VERSION"] = 26;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_HEAL_ABSORB_COUNTER_BOUQUET);
	end
	VUHDO_DEFAULT_HEAL_ABSORB_COUNTER_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 27 then
		VUHDO_BOUQUETS["VERSION"] = 27;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_EVOKER_REVERSION_BOUQUET);
		VUHDO_addSpellBouquetItem(VUHDO_I18N_BOUQUET_EVOKER_REVERSION, true, unpack(tEvokerReversionSpellIds));
	end
	tEvokerReversionSpellIds = nil;

	if VUHDO_BOUQUETS["VERSION"] < 28 then
		VUHDO_BOUQUETS["VERSION"] = 28;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_EVOKER_REVERSION_ECHO_BOUQUET);
		VUHDO_addSpellBouquetItem(VUHDO_I18N_BOUQUET_EVOKER_REVERSION_ECHO, true, unpack(tEvokerReversionEchoSpellIds));
	end

	if VUHDO_BOUQUETS["VERSION"] < 29 then
		VUHDO_BOUQUETS["VERSION"] = 29;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_EVOKER_DREAM_BREATH_BOUQUET);
		VUHDO_addSpellBouquetItem(VUHDO_I18N_BOUQUET_EVOKER_DREAM_BREATH, true, unpack(tEvokerDreamBreathSpellIds));
	end
	tEvokerDreamBreathSpellIds = nil;

	if VUHDO_BOUQUETS["VERSION"] < 30 then
		VUHDO_BOUQUETS["VERSION"] = 30;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_EVOKER_DREAM_BREATH_ECHO_BOUQUET);
		VUHDO_addSpellBouquetItem(VUHDO_I18N_BOUQUET_EVOKER_DREAM_BREATH_ECHO, true, unpack(tEvokerDreamBreathEchoSpellIds));
	end

	if VUHDO_BOUQUETS["VERSION"] < 31 then
		VUHDO_BOUQUETS["VERSION"] = 31;

		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_EVOKER_ALL_ECHO_BOUQUET);

		VUHDO_addSpellBouquetItem(VUHDO_I18N_BOUQUET_EVOKER_ALL_ECHO, true, unpack(tEvokerDreamBreathEchoSpellIds));
		VUHDO_addSpellBouquetItem(VUHDO_I18N_BOUQUET_EVOKER_ALL_ECHO, true, unpack(tEvokerReversionEchoSpellIds));
	end
	tEvokerDreamBreathEchoSpellIds = nil;
	tEvokerReversionEchoSpellIds = nil;

	if VUHDO_BOUQUETS["VERSION"] < 32 then
		VUHDO_BOUQUETS["VERSION"] = 32;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_TRAIL_OF_LIGHT_NEXT_BOUQUET);
	end
	VUHDO_DEFAULT_TRAIL_OF_LIGHT_NEXT_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 33 then
		VUHDO_BOUQUETS["VERSION"] = 33;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_SPELL_TRACE_INCOMING_BOUQUET);
	end
	VUHDO_DEFAULT_SPELL_TRACE_INCOMING_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 34 then
		VUHDO_BOUQUETS["VERSION"] = 34;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_CHI_HARMONY_ICON_MINE_BOUQUET);
	end
	VUHDO_DEFAULT_CHI_HARMONY_ICON_MINE_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 35 then
		VUHDO_BOUQUETS["VERSION"] = 35;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_CHI_HARMONY_ICON_OTHERS_BOUQUET);
	end
	VUHDO_DEFAULT_CHI_HARMONY_ICON_OTHERS_BOUQUET = nil;

	if VUHDO_BOUQUETS["VERSION"] < 36 then
		VUHDO_BOUQUETS["VERSION"] = 36;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_CHI_HARMONY_ICON_BOTH_BOUQUET);
	end
	VUHDO_DEFAULT_CHI_HARMONY_ICON_BOTH_BOUQUET = nil;

	VUHDO_buildGenericHealthBarBouquet();
	VUHDO_buildGenericTargetHealthBouquet();

	if not VUHDO_INDICATOR_CONFIG then
		VUHDO_INDICATOR_CONFIG = VUHDO_decompressOrCopy(VUHDO_DEFAULT_INDICATOR_CONFIG);
	end

	local tPanelIndicatorConfig;

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		if not VUHDO_INDICATOR_CONFIG[tPanelNum] then
			VUHDO_INDICATOR_CONFIG[tPanelNum] = VUHDO_decompressOrCopy(VUHDO_DEFAULT_INDICATOR_CONFIG_PER_PANEL);

			tPanelIndicatorConfig = VUHDO_INDICATOR_CONFIG[tPanelNum];

			tPanelIndicatorConfig["BOUQUETS"]["SWIFTMEND_INDICATOR"] = "DRUID" == VUHDO_PLAYER_CLASS and VUHDO_I18N_DEF_BOUQUET_SWIFTMENDABLE or VUHDO_I18N_DEF_BOUQUET_ROLE_AND_SUMMON;

			if not tPanelIndicatorConfig["CUSTOM"]["HOT_BARS"] then
				tPanelIndicatorConfig["CUSTOM"]["HOT_BARS"] = {
					["invertGrowth"]  = false,
					["vertical"] = false,
					["turnAxis"] = (tPanelIndicatorConfig["CUSTOM"]["HEALTH_BAR"]["turnAxis"] and
							not tPanelIndicatorConfig["CUSTOM"]["HEALTH_BAR"]["invertGrowth"]) or
							(not tPanelIndicatorConfig["CUSTOM"]["HEALTH_BAR"]["turnAxis"] and
							tPanelIndicatorConfig["CUSTOM"]["HEALTH_BAR"]["invertGrowth"])
				};
			end
		else
			tPanelIndicatorConfig = VUHDO_INDICATOR_CONFIG[tPanelNum];
		end

		-- old profiles will have no indicator config version and need a one time migration to the per panel model
		-- final model sanity check will ensure version is present moving forward
		if not VUHDO_INDICATOR_CONFIG["VERSION"] and
			VUHDO_INDICATOR_CONFIG["BOUQUETS"] and VUHDO_INDICATOR_CONFIG["CUSTOM"] and VUHDO_INDICATOR_CONFIG["TEXT_INDICATORS"] then
			tPanelIndicatorConfig["BOUQUETS"] = VUHDO_decompressOrCopy(VUHDO_INDICATOR_CONFIG["BOUQUETS"]);

			-- the old model supported per panel bouquets only for the Health Bar indicator
			if tPanelIndicatorConfig["BOUQUETS"]["HEALTH_BAR_PANEL"][tPanelNum] and
				tPanelIndicatorConfig["BOUQUETS"]["HEALTH_BAR_PANEL"][tPanelNum] ~= "" then
				tPanelIndicatorConfig["BOUQUETS"]["HEALTH_BAR"] = tPanelIndicatorConfig["BOUQUETS"]["HEALTH_BAR_PANEL"][tPanelNum];
			end

			tPanelIndicatorConfig["BOUQUETS"]["HEALTH_BAR_PANEL"] = nil;

			tPanelIndicatorConfig["TEXT_INDICATORS"] = VUHDO_decompressOrCopy(VUHDO_INDICATOR_CONFIG["TEXT_INDICATORS"]);

			for _, tTextIndicatorConfig in pairs(tPanelIndicatorConfig["TEXT_INDICATORS"]) do
				if type(tTextIndicatorConfig["TEXT_PROVIDER"]) == "table" then
					tTextIndicatorConfig["TEXT_PROVIDER"] = tTextIndicatorConfig["TEXT_PROVIDER"][tPanelNum] or "";

					break;
				end
			end

			tPanelIndicatorConfig["CUSTOM"] = VUHDO_decompressOrCopy(VUHDO_INDICATOR_CONFIG["CUSTOM"]);
		end

		VUHDO_INDICATOR_CONFIG[tPanelNum] = VUHDO_ensureSanity("VUHDO_INDICATOR_CONFIG[" .. tPanelNum .. "]", VUHDO_INDICATOR_CONFIG[tPanelNum], VUHDO_DEFAULT_INDICATOR_CONFIG_PER_PANEL);
	end

	if not VUHDO_INDICATOR_CONFIG["VERSION"] then
		VUHDO_INDICATOR_CONFIG["BOUQUETS"] = nil;
		VUHDO_INDICATOR_CONFIG["CUSTOM"] = nil;
		VUHDO_INDICATOR_CONFIG["TEXT_INDICATORS"] = nil;
	end

	VUHDO_INDICATOR_CONFIG = VUHDO_ensureSanity("VUHDO_INDICATOR_CONFIG", VUHDO_INDICATOR_CONFIG, VUHDO_DEFAULT_INDICATOR_CONFIG);
	VUHDO_DEFAULT_INDICATOR_CONFIG = VUHDO_compressAndPackTable(VUHDO_DEFAULT_INDICATOR_CONFIG);
	VUHDO_DEFAULT_INDICATOR_CONFIG_PER_PANEL = VUHDO_compressAndPackTable(VUHDO_DEFAULT_INDICATOR_CONFIG_PER_PANEL);

	VUHDO_ensureAllBouquetItemsSanity();

end
