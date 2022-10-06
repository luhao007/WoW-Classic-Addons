local _, addon = ...

-- database of buff spells and reagents
addon.spells = {
	DEATHKNIGHT = {
		{	
			spells = {48289}, -- Raise Dead
			reagent = 37201, -- Corpse Dust
		},
	},
	DRUID = {
		{	
			spells = {20484}, -- Rebirth (Rank 1)
			reagent = 17034, -- Maple Seed
		},
		{	
			spells = {20739}, -- Rebirth (Rank 2)
			reagent = 17035, -- Stranglethorn Seed
		},
		{	
			spells = {20742}, -- Rebirth (Rank 3)
			reagent = 17036, -- Ashwood Seed
		},
		{	
			spells = {20747}, -- Rebirth (Rank 4)
			reagent = 17037, -- Hornbeam Seed
		},
		{	
			spells = {20748}, -- Rebirth (Rank 5)
			reagent = 17038, -- Maple Seed
		},
		{	
			spells = {26994}, -- Rebirth (Rank 6)
			reagent = 22147, -- Flintweed Seed
		},
		{	
			spells = {48477}, -- Rebirth (Rank 7)
			reagent = 44614, -- Starleaf Seed
		},
		{	
			spells = {21849}, -- Gift of the Wild (Rank 1)
			reagent = 17021, -- Wild Berries
		},
		{	
			spells = {21850}, -- Gift of the Wild (Rank 2)
			reagent = 17026, -- Wild Thornroot
		},
		{	
			spells = {26991}, -- Gift of the Wild (Rank 3)
			reagent = 22148, -- Wild Quillvine
		},
		{	
			spells = {48470}, -- Gift of the Wild (Rank 4)
			reagent = 44605, -- Wild Spineleaf
		},
	},
	MAGE = {
		{	-- Teleports
			spells = {
				3567,	-- Orgrimmar
				3563,	-- Undercity
				3566,	-- Thunder Bluff
				32272,  -- Silvermoon
				49358,  -- Stonard
				35715,  -- Shattrath (Horde)
				3561,	-- Stormwind
				3562,	-- Ironforge
				3565,	-- Darnassus
				32271,	-- Exodar
				49359,	-- Theramore
				33690,	-- Shattrath (Alliance)
			},
			reagent = 17031,
		},
		{	-- Portals
			spells = {
				11417,	-- Orgrimmar
				11418,	-- Undercity
				11420,	-- Thunder Bluff
				32267,	-- Silvermoon
				49361,	-- Stonard
				35717,	-- Shattrath (Horde)
				10059,	-- Stormwind
				11416,	-- Ironforge
				11419,	-- Darnassus
				32266,	-- Exodar
				49360,	-- Theramore
				33691,	-- Shattrath (Alliance)
			},
			reagent = 17032,
		},
		{	-- Slow fall
			spells = {130},
			reagent = 17056,
		},
        {	-- Arcane Powder spells
            spells = {
                23028,  -- Arcane Brilliance (Rank 1)
                27127,  -- Arcane Brilliance (Rank 2)
                43987,  -- Ritual of Refreshment
            },
            reagent = 17020,
        },
	},
	PALADIN = {
		{	-- Divine Intervention
			spells = {19752},
			reagent = 17033,	-- Symbol of Divinity
		},	
		{	-- Greater Blessings
			spells = {
				25782,	-- Might (Rank 1)
				25916,	-- Might (Rank 2)
				27141,	-- Might (Rank 3)
				25894,	-- Wisdom (Rank 1)
				25918,	-- Wisdom (Rank 2)
				27143,	-- Wisdom (Rank 3)
				25898,	-- Kings
				25895,	-- Salvation
				25899,	-- Sanctuary
				27169,	-- Sanctuary (Rank 2)
				25890,	-- Light
				27145,	-- Light (Rank 2)
			},
			reagent = 21177,	--Symbol of Kings
		},
	},
	PRIEST = {
		{	-- Levitate
			spells = {1706},
			reagent = 17056,	-- Light Feather
		},
		{	-- Prayer of Fortitude (Rank 1)
			spells = {21562},
			reagent = 17028,	-- Holy Candle
		},
		{
			spells = {
				27683,	-- Prayer of Shadow Protection
				39374,	-- Prayer of Shadow Protection (Rank 2)
				27681,	-- Prayer of Spirit
				32999,	-- Prayer of Spirit (Rank 2)
				21564,	-- Prayer of Fortitude (Rank 2)
				25392,	-- Prayer of Fortitude (Rank 3)
			},
			reagent = 17029,	-- Sacred Candle
		},
		{	
			spells = {
				48162,	-- Prayer of Fortitude (Rank 4)
				48170,	-- Prayer of Shadow Protection (Rank 3)
				48074,	-- Prayer of Spirit (Rank 3)
			},
			reagent = 44615,	-- Devout Candle
		},
	},
	-- using the "Poisons" skill for all poisons
	ROGUE = {
		{	-- Anesthetic
			spells = {2842},
			reagent = 21835,
		},
		{	-- Instant
			spells = {2842},
			reagent = 6947,
		},
		{	-- Instant II
			spells = {2842},
			reagent = 6949,
		},
		{	-- Instant III
			spells = {2842},
			reagent = 6950,
		},
		{	-- Instant IV
			spells = {2842},
			reagent = 8926,
		},
		{	-- Instant V
			spells = {2842},
			reagent = 8927,
		},
		{	-- Instant VI
			spells = {2842},
			reagent = 8928,
		},
		{	-- Instant VII
			spells = {2842},
			reagent = 21927,
		},
		{	-- Crippling
			spells = {2842},
			reagent = 3775,
		},
		{	-- Crippling II
			spells = {2842},
			reagent = 3776,
		},		
		{	-- Mind-numbing
			spells = {2842},
			reagent = 5237,
		},
		{	-- Mind-numbing II
			spells = {2842},
			reagent = 6951,
		},
		{	-- Mind-numbing III
			spells = {2842},
			reagent = 9186,
		},		
		{	-- Deadly
			spells = {2842},
			reagent = 2892,
		},
		{	-- Deadly II
			spells = {2842},
			reagent = 2893,
		},
		{	-- Deadly III
			spells = {2842},
			reagent = 8984,
		},
		{	-- Deadly IV
			spells = {2842},
			reagent = 8985,
		},
		{	-- Deadly V
			spells = {2842},
			reagent = 20844,
		},	
		{	-- Deadly VI
			spells = {2842},
			reagent = 22053,
		},	
		{	-- Deadly VII
			spells = {2842},
			reagent = 22054,
		},		
		{	-- Wound
			spells = {2842},
			reagent = 10918,
		},
		{	-- Wound II
			spells = {2842},
			reagent = 10920,
		},
		{	-- Wound III
			spells = {2842},
			reagent = 10921,
		},
		{	-- Wound IV
			spells = {2842},
			reagent = 10922,
		},
		{	-- Wound V
			spells = {2842},
			reagent = 22055,
		},
		{	--Vanish
			spells = {
					1856,
					1857,
					26889,
				},
			reagent = 5140,		-- Flash Powder
		},
		{	-- Blind
			spells = {2094},
			reagent = 5530,		-- Blinding Powder
		},
	},
	SHAMAN = {
		{	-- Reincarnation
			spells = {20608},
			reagent = 17030,
		},
		{	-- Water breathing
			spells = {131},
			reagent = 17057,
		},
		{	-- Water walking
			spells = {546},
			reagent = 17058,
		},
	},
	WARLOCK = {
		{	-- Does everything a warlock does require Soul Shards? Basically, yes, that is correct.
			spells = {
				697,	-- Summon Voidwalker
				698,	-- Ritual of Summoning
				712,	-- Summon Succubus
				691,	-- Summon Felhunter
				6353,	-- Soul Fire
				17924,	-- Soul Fire (Rank 2)
				27211,	-- Soul Fire (Rank 3)
				30545,	-- Soul Fire (Rank 4)
				29858,	-- Soulshatter
				29893,	-- Ritual of Souls
				693,	-- Create Soulstone (Minor)
				20752,	-- Create Soulstone (Lesser)
				20755,	-- Create Soulstone
				20756,	-- Create Soulstone (Greater)
				20757,	-- Create Soulstone (Major)
				27238,	-- Create Soulstone (Rank 6)
				6201,	-- Create Healthstone (Minor)
				6202,	-- Create Healthstone (Lesser)
				5699,	-- Create Healthstone
				11729,	-- Create Healthstone (Greater)
				11730,	-- Create Healthstone (Major)
				27230,	-- Create Healthstone (Rank 6)
				6366,	-- Create Firestone (Lesser)
				17951,	-- Create Firestone
				17952,	-- Create Firestone (Greater)				
				17953,	-- Create Firestone (Major)
				27250,	-- Create Firestone (Rank 5)
				2362,	-- Create Spellstone
				17727,	-- Create Spellstone (Greater)				
				17728,	-- Create Spellstone (Major)
				28172,	-- Create Spellstone (Rank 4)
				1098,	-- Enslave Demon
				11725,	-- Enslave Demon (Rank 2)
				11726,	-- Enslave Demon (Rank 3)				
			},
			reagent = 6265,
		},
		{	-- You'd think that, but there are two others.
			spells = {1122},	-- Inferno
			reagent = 5565,		-- Infernal Stone
		},
		{
			spells = {18540},	-- Ritual of Doom
			reagent = 16583,	-- Demonic Figurine
		},
	},
}
