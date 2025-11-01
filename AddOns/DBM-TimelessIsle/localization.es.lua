if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then
	return
end
local L = DBM:GetModLocalization("IsleTimeless")

L:SetGeneralLocalization({
	name			= "Isla Intemporal"
})

L:SetWarningLocalization({
	specWarnShip	= "¡Barco aterrador invocado!",
	specWarnGolg	= "¡Golganarr ha aparecido!"
})

L:SetOptionLocalization({
	specWarnShip	= "Show special warning when Dread Ship Vazuvius is summoned",
	specWarnGolg	= "Show special warning when Golganarr has spawned"
})

L:SetMiscLocalization({
	shipSummon		= "¡Ja, ja, ja!",
	golgSpawn		= "Los eones me han despertado.",
	grieversMessage	= "Saboteadores de la Isla Intemporal conocidos en tu reino: %s"
})