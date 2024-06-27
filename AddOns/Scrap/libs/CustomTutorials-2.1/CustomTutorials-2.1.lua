--[[
Copyright 2010-2024 João Cardoso
CustomTutorials is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of CustomTutorials.

CustomTutorials is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

CustomTutorials is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with CustomTutorials. If not, see <http://www.gnu.org/licenses/>.
--]]

local Lib = LibStub:NewLibrary('CustomTutorials-2.1', 13)
if Lib then
	Lib.NewFrame, Lib.NewButton, Lib.UpdateFrame = nil
	Lib.numFrames = Lib.numFrames or 1
	Lib.frames = Lib.frames or {}
else
	return
end

local Embeds = {'RegisterTutorials', 'TriggerTutorial', 'ResetTutorials', 'GetTutorials'}
local ButtonTextures = 'Interface\\Buttons\\UI-SpellbookIcon-%sPage-%s'
local Frames = Lib.frames


--[[ Internal API ]]--

local function UpdateFrame(frame, i)
	local data = frame.data[i]
	if not data then
		return
	end

	-- Callback
	if frame.data.onShow then
		frame.data.onShow(frame.data, i)
	end

	-- Frame
	local title = frame.TitleText or frame.TitleContainer.TitleText
	title:SetText(data.title or frame.data.title)

	frame.text:SetPoint('BOTTOM', frame, 0, (data.textY or 20) + 30)
	frame.text:SetWidth(frame:GetWidth() - (data.textX or 30) * 2)
	frame.text:SetText(data.text)

	frame:ClearAllPoints()
	frame:SetPoint(data.point or 'CENTER', data.anchor or UIParent, data.relPoint or data.point or 'CENTER', data.x or 0, data.y or 0)
	frame:SetHeight((data.height or data.image and 220 or 100) + (data.text and frame.text:GetHeight() + (data.textY or 20) or 0))
	frame.i = i
	frame:Show()

	-- Image
	for _, image in pairs(frame.images) do
		image:Hide()
	end

	if data.image then
		local img = frame.images[i] or frame:CreateTexture()
		img:SetPoint('TOP', frame, data.imageX or 0, (data.imageY or 40) * -1)
		img:SetSize(data.imageW or 0, data.imageH or 0)
		img:SetTexture(data.image)
		img:Show()

		frame.images[i] = img
	end

	-- Shine
	if data.shine then
		frame.shine:SetParent(data.shine)
		frame.shine:SetPoint('BOTTOMRIGHT', data.shineRight or 0, data.shineBottom or 0)
		frame.shine:SetPoint('TOPLEFT', data.shineLeft or 0, data.shineTop or 0)
		frame.shine:Show()
		frame.flash:Play()
	else
		frame.flash:Stop()
		frame.shine:Hide()
	end

	-- Buttons
	if i == 1 then
		frame.prev:Disable()
	else
		frame.prev:Enable()
	end

	-- Save
	local sv = frame.data.key or frame.data.savedvariable
	if sv then
		local table = frame.data.key and frame.data.savedvariable or _G
		table[sv] = max(i, table[sv] or 0)
	end

	if i < (frame.unlocked or 0) then
		frame.next:Enable()
	else
		frame.next:Disable()
	end
end

local function NewButton(frame, name, direction)
	local button = CreateFrame('Button', nil, frame)
	button:SetHighlightTexture('Interface\\Buttons\\UI-Common-MouseHilight')
	button:SetDisabledTexture(ButtonTextures:format(name, 'Disabled'))
	button:SetPushedTexture(ButtonTextures:format(name, 'Down'))
	button:SetNormalTexture(ButtonTextures:format(name, 'Up'))
	button:SetPoint('BOTTOM', 120 * direction, 2)
	button:SetSize(26, 26)
	button:SetScript('OnClick', function()
		UpdateFrame(frame, frame.i + direction)
	end)

	local text = button:CreateFontString(nil, nil, 'GameFontHighlightSmall')
	text:SetText(_G[strupper(name)])
	text:SetPoint('LEFT', (13 + text:GetStringWidth()/2) * direction, 0)

	return button
end

local function NewFrame()
	local frame = CreateFrame('Frame', 'CustomTutorials'..Lib.numFrames, UIParent, 'ButtonFrameTemplate')
	frame.Inset:SetPoint('TOPLEFT', 4, -23)
	frame.Inset.Bg:SetColorTexture(0,0,0)
	frame:SetFrameStrata('DIALOG')
	frame:SetClampedToScreen(true)
	frame:EnableMouse(true)
	frame:SetToplevel(true)
	frame:SetWidth(350)
	frame:SetScript('OnHide', function()
		frame.flash:Stop()
		frame.shine:Hide()
	end)

	local top = (frame.NineSlice or frame):CreateTexture(nil, 'OVERLAY', nil, 5) -- the blue top
	top:SetTexture('Interface\\TutorialFrame\\UI-Tutorial-Frame')
	top:SetTexCoord(0.0019531, 0.7109375, 0.0019531, 0.15625)
	top:SetPoint('TOPLEFT', -13, 13)
	top:SetPoint('TOPRIGHT', 0, 13)
	top:SetHeight(80)

	local text = frame:CreateFontString(nil, nil, 'GameFontHighlight')
	text:SetJustifyH('LEFT')

	local shine = CreateFrame('Frame', nil, UIParent, BackdropTemplateMixin and 'BackdropTemplate')
	shine:SetBackdrop({edgeFile = 'Interface\\TutorialFrame\\UI-TutorialFrame-CalloutGlow', edgeSize = 16})

	local flash = shine:CreateAnimationGroup()
	flash:SetLooping('BOUNCE')

	local step = flash:CreateAnimation('Alpha')
	step:SetDuration(.75)
	step:SetFromAlpha(1)
	step:SetToAlpha(.3)

	for i = 1, shine:GetNumRegions() do
		select(i, shine:GetRegions()):SetBlendMode('ADD')
	end

	frame.text, frame.shine, frame.flash = text, shine, flash
	frame.prev = NewButton(frame, 'Prev', -1)
	frame.next = NewButton(frame, 'Next', 1)
	frame.images = {}

	Lib.numFrames = Lib.numFrames + 1
	return frame
end


--[[ User API ]]--

function Lib:RegisterTutorials(data)
	assert(type(data) == 'table', 'RegisterTutorials: 2nd arg must be a table', 2)
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	if not Lib.frames[self] then
		Lib.frames[self] = NewFrame()
	end

	Lib.frames[self].data = data
end

function Lib:TriggerTutorial(index, maxAdvance)
	assert(type(index) == 'number', 'TriggerTutorial: 2nd arg must be a number', 2)
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	local frame = Lib.frames[self]
	if frame then
		local sv = frame.data.key or frame.data.savedvariable
		local table = frame.data.key and frame.data.savedvariable or _G
		local last = sv and table[sv] or 0

		if index > last then
			frame.unlocked = index
			UpdateFrame(frame, (maxAdvance == true or not sv) and index or last + (maxAdvance or 1))
		end
	end
end

function Lib:ResetTutorials()
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	local frame = Lib.frames[self]
	if frame then
		local sv = frame.data.key or frame.data.savedvariable
		if sv then
			local table = frame.data.key and frame.data.savedvariable or _G
			table[sv] = false
		end

		frame:Hide()
	end
end

function Lib:GetTutorials()
	return self and Lib.frames[self] and Lib.frames[self].data
end

function Lib:Embed(object)
	for _,k in ipairs(Embeds) do
		object[k] = self[k]
	end
end
