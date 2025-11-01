--[[
Copyright 2024 João Cardoso
StaleCheck is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this library give you permission to embed it
with independent modules to produce an addon, regardless of the license terms of these
independent modules, and to copy and distribute the resulting software under terms of your
choice, provided that you also meet, for each embedded independent module, the terms and
conditions of the license of that module. Permission is not granted to modify this library.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

This file is part of StaleCheck.
]]--

local Lib = LibStub:NewLibrary('StaleCheck-1.0', 3)
if not Lib then
	return
elseif not Lib.registry then
	C_ChatInfo.RegisterAddonMessagePrefix('Stale-1.0')
	EventRegistry:RegisterFrameEventAndCallback('CHAT_MSG_ADDON', function(...) Lib:OnMessage(...) end)
	EventRegistry:RegisterFrameEventAndCallback('GUILD_ROSTER_UPDATE', function() Lib:OnGuild() end)
	EventRegistry:RegisterFrameEventAndCallback('GROUP_ROSTER_UPDATE', function() Lib:OnGroup() end)
	C_Timer.NewTicker(60, function() Lib:Broadcast() end)
	Lib.registry = {}
end

local function int(version)
    local major, minor, patch = version:match('(%d+)%.*(%d*)%.*(%d*)')
    return tonumber(major) * 10000 + (tonumber(minor) or 0) * 100 + (tonumber(patch) or 0)
end

local function popup(text, addon, icon, who, version)
    print(format('|cffff0000' .. text:gsub('|c%x%x%x%x%x%x%x%x', '|cffffffff'):gsub('|n', ' ') .. '|r', addon, who, version))
    pcall(function()
        LibStub('Sushi-3.2').Popup {
			text = format(text, addon, who, version), button1 = OKAY,
			icon = icon or C_AddOns.GetAddOnMetadata(addon, 'icontexture') }
    end)
end


--[[ Detect Client ]]--

local nextExpansion = 0
for k, v in pairs(_G) do
    if type(k) == 'string' and type(v) == 'number' and k:match('^LE_EXPANSION_[%u_]+$') then
        nextExpansion = max(nextExpansion, (v+3) * 10000)
    end
end

local locale = GetLocale()
local outOfDate = 'Your |cffffd200%s|r version might be outdated!|n%s reported having|n|cff82c5ff%s|r, please update if true.'
local invalidBuild = 'Your copy of |cffffd200%s|r is either corrupted or illegal.|nPlease download an official build for free.'

if locale == 'frFR' then
    outOfDate = 'Votre version de |cffffd200%s|r pourrait être obsolète !|n%s a signalé avoir|n|cff82c5ff%s|r, veuillez mettre à jour si c\'est vrai.'
    invalidBuild = 'Votre copie de |cffffd200%s|r est soit corrompue, soit illégale.|nVeuillez télécharger une version officielle gratuitement.'
elseif locale == 'deDE' then
    outOfDate = 'Ihre Version von |cffffd200%s|r ist möglicherweise veraltet!|n%s hat gemeldet,|n|cff82c5ff%s|r zu haben, bitte aktualisieren Sie, falls dies zutrifft.'
    invalidBuild = 'Ihre Kopie von |cffffd200%s|r ist entweder beschädigt oder illegal.|nBitte laden Sie eine offizielle Version kostenlos herunter.'
elseif locale == 'esES' or locale == 'esMX' then
    outOfDate = '¡Tu versión de |cffffd200%s|r podría estar desactualizada!|n%s informó tener|n|cff82c5ff%s|r, por favor actualiza si es cierto.'
    invalidBuild = 'Tu copia de |cffffd200%s|r está corrupta o es ilegal.|nPor favor, descarga una versión oficial gratis.'
elseif locale == 'ruRU' then
    outOfDate = 'Ваша версия |cffffd200%s|r может быть устаревшей!|n%s сообщил, что у него|n|cff82c5ff%s|r, пожалуйста, обновите, если это так.'
    invalidBuild = 'Ваша копия |cffffd200%s|r повреждена или нелегальна.|nПожалуйста, скачайте официальную версию бесплатно.'
elseif locale == 'koKR' then
    outOfDate = '|cffffd200%s|r 버전이 오래되었을 수 있습니다!|n%s 님이|n|cff82c5ff%s|r을 사용 중이라고 보고했습니다. 사실이라면 업데이트해 주십시오.'
    invalidBuild = '사용 중인 |cffffd200%s|r 복사본이 손상되었거나 불법적인 것입니다.|n공식 빌드를 무료로 다운로드하십시오.'
elseif locale == 'zhCN' then
    outOfDate = '您的|cffffd200%s|r版本可能已过期！|n%s报告的版本为|n|cff82c5ff%s|r，请确认并更新。'
    invalidBuild = '您的|cffffd200%s|r副本可能已损坏或为非法版本。|n请下载官方版本。'
elseif locale == 'zhTW' then
    outOfDate = '您的|cffffd200%s|r版本可能已過期！|n%s報告的版本為|n|cff82c5ff%s|r，請確認並更新。'
    invalidBuild = '您的|cffffd200%s|r副本可能已損壞或為非法版本。|n請下載官方版本。'
elseif locale == 'itIT' then
    outOfDate = 'La tua versione di |cffffd200%s|r potrebbe essere obsoleta!|n%s ha segnalato di avere|n|cff82c5ff%s|r, per favore aggiorna se è vero.'
    invalidBuild = 'La tua copia di |cffffd200%s|r è corrotta o illegale.|nPer favore scarica una versione ufficiale gratuitamente.'
elseif locale == 'ptBR' or locale == 'ptPT' then
    outOfDate = 'A sua versão do |cffffd200%s|r pode estar desatualizada!|n%s relatou estar a usar|n|cff82c5ff%s|r, por favor, atualize se for verdade.'
    invalidBuild = 'Sua cópia de |cffffd200%s|r está corrompida ou é ilegal.|Faça download de uma versão oficial gratuitamente.'
end


--[[ Public API ]]--

function Lib:CheckForUpdates(addon, sets, icon)
	local installed = C_AddOns.GetAddOnMetadata(addon, 'version')
	local ours = int(installed)

    if ours >= nextExpansion then
        return popup(invalidBuild, addon, icon)
	else
		local latest = sets.latest
		if latest and latest.id and int(latest.id) > ours and GetServerTime() >= (latest.cooldown or 0) then
			popup(outOfDate, addon, icon, latest.who, latest.id)
			sets.latest = {cooldown = GetServerTime() + 7 * 24 * 60 * 60}
		end

		Lib.registry[addon] = {sets = sets, queue = {}, installed = installed, istest = installed:find('[ab]')}
		sets.latest = sets.latest or {}
    end
end

function Lib:Embed(object)
	object.CheckForUpdates = Lib.CheckForUpdates
end


--[[ Events ]]--

function Lib:OnMessage(_, prefix, message, channel, sender)
	if prefix == 'Stale-1.0' then
		local addon, version = strsplit('|', message)
		local handler = Lib.registry[addon]
		if handler then
			local latest = handler.sets.latest
			local ours, theirs = int(latest.id or handler.installed), int(version)
			local better = theirs > ours and theirs < nextExpansion
			if better then
				latest.id, latest.who = version, sender
			end

			handler.queue[channel] = handler.queue[channel] and not better or nil
		end
	end
end

function Lib:OnGuild()
    if IsInGuild() then
		for _, handler in pairs(Lib.registry) do
			handler.queue.GUILD = true
		end
    end
end

function Lib:OnGroup()
	local channel = 
		IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 'INSTANCE_CHAT' or
		IsInGroup(LE_PARTY_CATEGORY_HOME) and 'PARTY' or
		IsInRaid(LE_PARTY_CATEGORY_HOME) and 'RAID'

	if channel then
		for _, handler in pairs(Lib.registry) do
			handler.queue[channel] = true
		end
	end
end

function Lib:Broadcast()
	for addon, handler in pairs(Lib.registry) do
		if not handler.istest then
			for channel in pairs(handler.queue) do
				C_ChatInfo.SendAddonMessage('Stale-1.0', strjoin('|', addon, handler.installed), channel)
			end
		end

		wipe(handler.queue)
	end
end