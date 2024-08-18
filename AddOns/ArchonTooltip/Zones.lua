---@class Private
local Private = select(2, ...)

Private.Zones[1023] = {
    id = 1023,
    hasMultipleSizes = true,
    encounters = {
        { id = 1035, },
        { id = 1034, },
        { id = 1027, },
        { id = 1024, },
        { id = 1022, },
        { id = 1023, },
        { id = 1025, },
        { id = 1026, },
        { id = 1030, },
        { id = 1032, },
        { id = 1028, },
        { id = 1029, },
        { id = 1082, },
    },
    difficultyIconMap = nil
}

Private.Zones[1026] = {
    id = 1026,
    hasMultipleSizes = true,
    encounters = {
        { id = 50744, },
        { id = 50745, },
        { id = 50746, },
        { id = 50747, },
        { id = 50748, },
        { id = 50749, },
        { id = 50750, },
        { id = 50751, },
        { id = 50752, },
        { id = 50753, },
        { id = 50754, },
        { id = 50755, },
        { id = 50756, },
        { id = 50757, },
    },
    difficultyIconMap = nil
}

Private.Zones[2012] = {
    id = 2012,
    hasMultipleSizes = false,
    encounters = {
        { id = 100663, },
        { id = 100664, },
        { id = 100665, },
        { id = 100666, },
        { id = 100667, },
        { id = 100668, },
        { id = 100669, },
        { id = 100670, },
        { id = 100671, },
        { id = 100672, },
        { id = 3018, },
    },
    difficultyIconMap = {
        [5] = "achievement_boss_ragnaros",
        [4] = "spell_fire_elemental_totem",
        [3] = "spell_fire_fire",
    }
}

for _, zone in pairs(Private.Zones) do
    for _, encounter in pairs(zone.encounters) do
        Private.EncounterZoneIdMap[encounter.id] = zone.id
    end
end