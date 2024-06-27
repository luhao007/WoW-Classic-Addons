local lsfdd = LibStub("LibSFDropDown-1.5")
local cur_ver, ver = lsfdd._mbv, 1
if cur_ver and cur_ver >= ver then return end
lsfdd._mbv = ver
local menu1 = lsfdd:GetMenu(1)
local libMethods = lsfdd._m.__index


if not menu1.mediaBackdropFrame then
	menu1.mediaBackdropFrame = CreateFrame("FRAME", nil, menu1, "BackdropTemplate")
	menu1.mediaBackdropFrame:Hide()
	menu1.mediaBackdropFrame:SetAllPoints()
	menu1.mediaBackdropFrame:SetScript("OnHide", function(self) self:Hide() end)


	function menu1.mediaBackdropFrame:setBackdrop(btn, backdrop)
		if btn.value == "None" then
			if self.style then
				self.style:Show()
				self.style = nil
			end
			self:Hide()
			return
		end

		for name, style in next, menu1.styles do
			if style:IsShown() then
				self.style = style
				style:Hide()
				break
			end
		end

		self:SetBackdrop(backdrop)
		self:Show()
	end
end


local function media_setSelected(btn, ddBtn)
	ddBtn:ddSetSelectedValue(btn.value)
	if type(ddBtn.ddOnSelectedFunc) == "function" then ddBtn.ddOnSelectedFunc(btn.value) end
end


local function media_setOnSelectedFunc(self, func)
	self.ddOnSelectedFunc = func
end


local function selectedValueHook(self, value)
	self:ddSetSelectedText(value)
end


-- BACKGROUND
do
	local function onEnter(btn, ddBtn)
		menu1.mediaBackdropFrame:setBackdrop(btn, {bgFile = ddBtn.media:Fetch("background", btn.value)})
	end


	local function initFunc(self)
		local info = {list = {}}
		for i, name in ipairs(self.media:List("background")) do
			info.list[#info.list + 1] = {
				text = name,
				value = name,
				arg1 = self,
				func = media_setSelected,
				OnEnter = onEnter,
			}
		end
		self:ddAddButton(info)
	end


	local function mediaBackgroundInit(btn)
		btn.media = LibStub("LibSharedMedia-3.0")
		btn:ddSetInitFunc(initFunc)
		btn.ddSetOnSelectedFunc = media_setOnSelectedFunc
		hooksecurefunc(btn, "ddSetSelectedValue", selectedValueHook)
		return btn
	end


	function libMethods:CreateMediaBackgroundButtonOriginal(...)
		self.CreateMediaBackgroundButtonOriginal = nil

		local btn = self:CreateButtonOriginal(...)
		return mediaBackgroundInit(btn)
	end


	function libMethods:CreateMediaBackgroundButton(...)
		local btn = self:CreateButton(...)
		return mediaBackgroundInit(btn)
	end
end


-- BORDER
do
	local function onEnter(btn, ddBtn)
		menu1.mediaBackdropFrame:setBackdrop(btn, {
			edgeFile = ddBtn.media:Fetch("border", btn.value),
			bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})
	end


	local function initFunc(self)
		local info = {list = {}}
		for i, name in ipairs(self.media:List("border")) do
			info.list[#info.list + 1] = {
				text = name,
				value = name,
				arg1 = self,
				func = media_setSelected,
				OnEnter = onEnter,
			}
		end
		self:ddAddButton(info)
	end


	local function mediaBorderInit(btn)
		btn.media = LibStub("LibSharedMedia-3.0")
		btn:ddSetInitFunc(initFunc)
		btn.ddSetOnSelectedFunc = media_setOnSelectedFunc
		hooksecurefunc(btn, "ddSetSelectedValue", selectedValueHook)
		return btn
	end


	function libMethods:CreateMediaBorderButtonOriginal(...)
		self.CreateMediaBorderButtonOriginal = nil

		local btn = self:CreateButtonOriginal(...)
		return mediaBorderInit(btn)
	end


	function libMethods:CreateMediaBorderButton(...)
		local btn = self:CreateButton(...)
		return mediaBorderInit(btn)
	end
end


-- STATUSBAR
do
	local function getLangFontObject()
		local lang = GetLocale()
		if lang == "zhTW" or lang == "zhCN" then
			return GameFontHighlightOutline
		else
			return Game10Font_o1
		end
	end


	local function initFunc(self)
		local info = {list = {}}
		local iconInfo = {
			tSizeX = 0,
			tSizeY = 14,
		}
		local fontObject = getLangFontObject()
		local statusbars = self.media:HashTable("statusbar")
		for i, name in ipairs(self.media:List("statusbar")) do
			info.list[#info.list + 1] = {
				text = name,
				value = name,
				fontObject = fontObject,
				icon = statusbars[name],
				iconOnly = true,
				iconInfo = iconInfo,
				arg1 = self,
				func = media_setSelected,
			}
		end
		self:ddAddButton(info)
	end


	local function selectedvalueStatusbarHook(self, value)
		local icon = self.media:Fetch("statusbar", value)
		local iconInfo = {
			tSizeX = 0,
			tSizeY = 14,
		}
		self:ddSetSelectedText(value, icon, iconInfo, true, getLangFontObject())
	end


	local function mediaStatusbarInit(btn)
		btn.media = LibStub("LibSharedMedia-3.0")
		btn:ddSetMinMenuWidth(280)
		btn:ddSetInitFunc(initFunc)
		btn.ddSetOnSelectedFunc = media_setOnSelectedFunc
		hooksecurefunc(btn, "ddSetSelectedValue", selectedvalueStatusbarHook)
		return btn
	end


	function libMethods:CreateMediaStatusbarButtonOriginal(...)
		self.CreateMediaStatusbarButtonOriginal = nil

		local btn = self:CreateButtonOriginal(...)
		return mediaStatusbarInit(btn)
	end


	function libMethods:CreateMediaStatusbarButton(...)
		local btn = self:CreateButton(...)
		return mediaStatusbarInit(btn)
	end
end


-- FONT
do
	local function initFunc(self)
		local info = {list = {}}
		local fonts = self.media:HashTable("font")
		for i, name in ipairs(self.media:List("font")) do
			info.list[#info.list + 1] = {
				text = name,
				value = name,
				fontObject = GameFontHighlightLeft,
				font = fonts[name],
				arg1 = self,
				func = media_setSelected,
			}
		end
		self:ddAddButton(info)
	end


	local function selectedValueFontHook(self, value)
		self:ddSetSelectedText(value, nil, nil, nil, nil, self.media:Fetch("font", value))
	end


	local function mediaFontInit(btn)
		btn.media = LibStub("LibSharedMedia-3.0")
		btn:ddSetInitFunc(initFunc)
		btn.ddSetOnSelectedFunc = media_setOnSelectedFunc
		hooksecurefunc(btn, "ddSetSelectedValue", selectedValueFontHook)
		return btn
	end


	function libMethods:CreateMediaFontButtonOriginal(...)
		self.CreateMediaFontButtonOriginal = nil

		local btn = self:CreateButtonOriginal(...)
		return mediaFontInit(btn)
	end

	function libMethods:CreateMediaFontButton(...)
		local btn = self:CreateButton(...)
		return mediaFontInit(btn)
	end
end


-- SOUND
do
	local function sound_OnClick(btn, ddBtn)
		PlaySoundFile(ddBtn.media:Fetch("sound", btn.value), "Master")
	end


	local function initFunc(self)
		local info = {list = {}}
		local widgets = {
			{
				icon = "Interface/Common/VoiceChat-Speaker",
				OnClick = sound_OnClick,
			}
		}
		for i, name in ipairs(self.media:List("sound")) do
			info.list[#info.list + 1] = {
				text = name,
				value = name,
				arg1 = self,
				func = media_setSelected,
				widgets = widgets
			}
		end
		self:ddAddButton(info)
	end


	local function mediaSoundInit(btn)
		btn.media = LibStub("LibSharedMedia-3.0")
		btn:ddSetInitFunc(initFunc)
		btn.ddSetOnSelectedFunc = media_setOnSelectedFunc
		hooksecurefunc(btn, "ddSetSelectedValue", selectedValueHook)
		return btn
	end


	function libMethods:CreateMediaSoundButtonOriginal(...)
		self.CreateMediaSoundButtonOriginal = nil

		local btn = self:CreateButtonOriginal(...)
		return mediaSoundInit(btn)
	end


	function libMethods:CreateMediaSoundButton(...)
		local btn = self:CreateButton(...)
		return mediaSoundInit(btn)
	end
end