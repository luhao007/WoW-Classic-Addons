if GetLocale() ~= "ruRU" then
	return
end
local L = DBM:GetModLocalization("IsleTimeless")

L:SetGeneralLocalization({
	name = "Мир: Вневременной остров"
})

L:SetWarningLocalization({
	specWarnShip	= "Корабль вызван!",
	specWarnGolg	= "Появление Голганарра!"
})

L:SetOptionLocalization({
	specWarnShip	= "Показывать спецпредупреждение при вызове Проклятого корабля 'Вазувий'",
	specWarnGolg	= "Показывать спецпредупреждение при появлении Голганарра"
})

L:SetMiscLocalization({
	shipSummon		= "Ха-ха-ха!",
	golgSpawn		= "Меня разбудила вечность.",
	grieversMessage	= "Known TI grievers on your realm: %s"
})
