--[[
Copyright 2008-2019 João Cardoso
Scrap is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of Scrap.
--]]

local NoVisuals = not Scrap.HasSpotlight
local HasPawn = IsAddOnLoaded('Pawn_Scrap')
local Patrons = {{title='Jenkins',people={'Gnare','Eitrigg A. Runefire','SirZooro','ProfessahX'}},{},{title='Ambassador',people={'Sembiance','Fernando Bandeira','Michael Irving','Julia Frizzell','Peggy Webb','Lolari','Craig Falb','Mary Barrentine','Grey Sample','Patryk Kalis','Lifeprayer'}}} -- generated patron list

local Options = SushiMagicGroup(ScrapOptions)
Options:SetAddon('Scrap')
Options:SetFooter('Copyright 2008-2019 João Cardoso')
Options:SetTitle(ScrapOptions.name)
Options:SetChildren(function(self)
	self:CreateHeader('Behaviour', 'GameFontHighlight', true)
	self:Create('CheckButton', 'AutoSell')
	self:Create('CheckButton', 'AutoRepair')
	self:Create('CheckButton', 'GuildRepair', nil, not Scrap_AutoRepair, true)
	self:Create('CheckButton', 'SafeMode', 'Safe')
	self:Create('CheckButton', 'Learn')

	self:CreateHeader('Filters', 'GameFontHighlight', true)
	self:Create('CheckButton', 'Unusable')
	self:Create('CheckButton', 'LowEquip', nil, HasPawn)
	self:Create('CheckButton', 'LowConsume')

	self:CreateHeader('Visuals', NoVisuals and 'GameFontNormalLeftGrey' or 'GameFontHighlight', true)
	self:Create('CheckButton', 'Glow', nil, NoVisuals)
	self:Create('CheckButton', 'Icons', nil, NoVisuals)

	Scrap:VARIABLES_LOADED()
end)

local Share = SushiCheckButton(Options)
Share:SetPoint('BOTTOM', Options, 'TOP', 115, 10)
Share:SetText(Scrap_Locals.CharSpecific)
Share:SetChecked(not Scrap_ShareList)
Share:SetScale(.9)
Share:SetCall('OnInput', function(self, v)
	Scrap_ShareList = not v
	Scrap:VARIABLES_LOADED()
end)

local Credits = SushiCreditsGroup:CreateOptionsCategory(Options:GetTitle())
Credits:SetFooter('Copyright 2008-2019 João Cardoso')
Credits:SetWebsite('http://www.patreon.com/jaliborc')
Credits:SetPeople(Patrons)
Credits:SetAddon('Scrap')

function ScrapOptions.default()
	Scrap_Version = nil
	Scrap:ResetTutorials()
	Scrap:VARIABLES_LOADED()

	Share:SetChecked(true)
	Options:Update()
end
