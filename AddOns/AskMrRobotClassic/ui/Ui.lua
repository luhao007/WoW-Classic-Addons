local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobotClassic", true)
local AceGUI = LibStub("AceGUI-3.0")

-- used to make some stuff layer correctly
Amr.FrameLevels = {
	High = 100,
	Highest = 125
}

-- standard colors used throughout the UI (in standard 0-255 RGB format, game uses 0-1 decimals, but we auto-convert it below)
Amr.Colors = {
	White =              { R = 255, G = 255, B = 255 },
	Black =              { R =   0, G =   0, B =   0 },
	Gray =               { R = 153, G = 153, B = 153 },
	Orange =             { R = 201, G =  87, B =   1 },
	Green =              { R =  77, G = 134, B =  45 },
	Blue =               { R =  54, G = 172, B = 204 },
	Red =                { R = 204, G =  38, B =  38 },
	Gold =               { R = 255, G = 215, B =   0 },
	BrightGreen =        { R =   0, G = 255, B =   0 },
	Text =               { R = 255, G = 255, B = 255 },
	TextHover =          { R = 255, G = 255, B =   0 },
	TextGray =           { R = 120, G = 120, B = 120 },
	TextHeaderActive =   { R = 223, G = 134, B =  61 },
	TextHeaderDisabled = { R = 188, G = 188, B = 188 },
	TextTan =            { R = 223, G = 192, B = 159 },
	BorderBlue =         { R =  26, G =  83, B =  98 },
	BorderGray =         { R =  96, G =  96, B =  96 },
	Bg =                 { R =  41, G =  41, B =  41 },
	BgInput =            { R =  17, G =  17, B =  17 },
	BarHigh =            { R = 114, G = 197, B =  66 },
	BarMed =             { R = 255, G = 196, B =  36 },
	BarLow =             { R = 201, G =  87, B =   1 }
}

-- convert from common RGB to 0-1 RGB values
for k,v in pairs(Amr.Colors) do
	v.R = v.R / 255
	v.G = v.G / 255
	v.B = v.B / 255
end

-- get colors for classes from WoW's constants
Amr.Colors.Classes = {}
for k,v in pairs(RAID_CLASS_COLORS) do
	Amr.Colors.Classes[k] = { R = v.r, G = v.g, B = v.b }
end

-- get colors for item qualities from WoW's constants
Amr.Colors.Qualities = {}
for k,v in pairs(ITEM_QUALITY_COLORS) do
	Amr.Colors.Qualities[k] = { R = v.r, G = v.g, B = v.b }
end

-- helper to take 0-1 value and turn into 2-digit hex value
local function decToHex(num)
	num = math.ceil(num * 255)
	num = string.format("%X", num)
	if string.len(num) == 1 then num = "0" .. num end
	return num
end

function Amr.ColorToHex(color, alpha)
	return decToHex(alpha) .. decToHex(color.R) .. decToHex(color.G) .. decToHex(color.B)
end

local function getFontPath(style)
	local locale = GetLocale()
	if locale == "koKR" then
		return "Fonts\\2002.TTF"
	elseif locale == "zhCN" then
		return "Fonts\\ARKai_T.ttf"
	elseif locale == "zhTW" then
		return "Fonts\\bLEI00D.ttf"
	elseif locale == "ruRU" then
		return "Fonts\\FRIZQT___CYR.TTF"
	else
		return "Interface\\AddOns\\" .. Amr.ADDON_NAME .. "\\Media\\Ubuntu-" .. style .. ".ttf"
	end
end

-- create a font with the specified style (Regular, Bold, Italic), size (pixels, max of 32), color (object with R, G, B), and alpha (if not specified, defaults to 1)
function Amr.CreateFont(style, size, color, a)
	local alpha = a or 1
	local id = string.format("%s_%d_%f_%f_%f_%f", style, size, color.R, color.G, color.B, alpha)
	local font = CreateFont(id)
	font:SetFont(getFontPath(style), size, "")
	font:SetTextColor(color.R, color.G, color.B, alpha)
	return font
end

-- helper to create a solid texture from a color with R,G,B properties
function Amr.CreateTexture(parent, color, alpha, layer)
	local t = parent:CreateTexture(nil, layer or "ARTWORK")
	t:SetColorTexture(color.R, color.G, color.B, alpha or 1)
	return t
end

-- helper to create a cheater shadow without having to create custom images
function Amr.DropShadow(frame)
	local shadow = frame:CreateTexture(nil, "BACKGROUND")
	shadow:SetColorTexture(0, 0, 0, 0.4)
	shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
	shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
	
	shadow = frame:CreateTexture(nil, "BACKGROUND")
	shadow:SetColorTexture(0, 0, 0, 0.3)
	shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
	shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)
	
	shadow = frame:CreateTexture(nil, "BACKGROUND")
	shadow:SetColorTexture(0, 0, 0, 0.1)
	shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
	shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 3, -3)
end


-- a layout that does nothing, just lets the children position themselves how they prefer
AceGUI:RegisterLayout("None", function(content, children)
	if content.obj.LayoutFinished then	
		content.obj:LayoutFinished(nil, nil)
	end
end)


local _mainFrame = nil
local _mainTabs = nil
local _mainCover = nil
local _activeTab = "Export"

-- release everything when the UI is closed
local function onMainFrameClose(widget)
	AceGUI:Release(widget)
	Amr["ReleaseTab" .. _activeTab](Amr)
	_mainFrame = nil
	_mainTabs = nil
	_mainCover = nil
end

local function onMainTabSelected(container, event, group)
	container:ReleaseChildren()
	Amr["ReleaseTab" .. _activeTab](Amr)
	
	_activeTab = group
	
	-- each section defines its own render method in a separate file (options tab is defined in Core.lua, uses standard Ace config stuff to auto-generate)
	Amr["RenderTab" .. group](Amr, container)
end

-- refresh the currently displayed tab
function Amr:RefreshTab()
	if not _mainTabs then return end
	
	_mainTabs:ReleaseChildren()
	Amr["ReleaseTab" .. _activeTab](Amr)
	Amr["RenderTab" .. _activeTab](Amr, container)
end

local function createMainWindow()

	local f = AceGUI:Create("AmrUiFrame")
	f:SetStatusTable(Amr.db.profile.window) -- window position is remembered in db
	f:SetCallback("OnClose", onMainFrameClose)
	f:SetLayout("None")
	f:SetWidth(1000)
	f:SetHeight(700)
	f:SetBorderColor(Amr.Colors.BorderBlue)
	f:SetBackgroundColor(Amr.Colors.Bg)
	
	if Amr.db.profile.options.uiScale ~= 1 then
		local scale = tonumber(Amr.db.profile.options.uiScale)
		f:SetScale(scale)
	end
		
	-- some status text
	local lblStatus = AceGUI:Create("AmrUiLabel")
	f:AddChild(lblStatus)
	lblStatus:SetWidth(900)
	lblStatus:SetFont(Amr.CreateFont("Italic", 12, Amr.Colors.TextTan))
	lblStatus:SetText("Ask Mr. Robot " .. L.MainStatusText("v" .. GetAddOnMetadata(Amr.ADDON_NAME, "Version"), "https://www.askmrrobot.com/addon"))
	lblStatus:SetJustifyH("CENTER")
	lblStatus:SetWordWrap(false)
	lblStatus:SetPoint("TOP", f.content, "BOTTOM")
		
	-- create the main UI container
	local c = AceGUI:Create("AmrUiPanel")
	c:SetLayout("Fill")
	c:SetBackgroundColor(Amr.Colors.Black, 0)
	f:AddChild(c)
	c:SetPoint("TOPLEFT", f.content, "TOPLEFT")
	c:SetPoint("BOTTOMRIGHT", f.content, "BOTTOMRIGHT")
	
	-- create the main tab strip
	local t =  AceGUI:Create("AmrUiTabGroup")
	c:AddChild(t)
	t:SetLayout("None")
	t:SetTabs({
		{text=L.TabExportText, value="Export"}, 
		{text=L.TabGearText, value="Gear"}, 
		{text=L.TabLogText, value="Log"}, 
		--{text=L.TabTeamText, value="Team"},
		{text=L.TabOptionsText, value="Options"}
	})
	t:SetCallback("OnGroupSelected", onMainTabSelected)
	
	-- create the cover/overlay container
	c = AceGUI:Create("AmrUiPanel")
	c:SetLayout("None")
	c:EnableMouse(true)
	c:SetBackgroundColor(Amr.Colors.Black, 0.75)
	f:AddChild(c)
	c:SetPoint("TOPLEFT", f.frame, "TOPLEFT")
	c:SetPoint("BOTTOMRIGHT", f.frame, "BOTTOMRIGHT")

	-- after adding, set cover to sit on top of everything, then hide it
	c:SetStrata("FULLSCREEN_DIALOG")
	c:SetLevel(Amr.FrameLevels.High)
	c:SetVisible(false)

	-- put standard cover ui elements (label, cancel button)
	local coverMsg = AceGUI:Create("AmrUiLabel")
	c:AddChild(coverMsg)
	coverMsg:SetWidth(600)
	coverMsg:SetFont(Amr.CreateFont("Regular", 16, Amr.Colors.TextTan))
	coverMsg:SetJustifyH("MIDDLE")
	coverMsg:SetJustifyV("MIDDLE")
	coverMsg:SetText("")
	coverMsg:SetPoint("CENTER", c.frame, "CENTER", 0, 20)
	
	local coverCancel = AceGUI:Create("AmrUiTextButton")
	coverCancel:SetWidth(200)
	coverCancel:SetHeight(20)
	coverCancel:SetText(L.CoverCancel)
	coverCancel:SetFont(Amr.CreateFont("Italic", 14, Amr.Colors.TextHeaderDisabled))
	coverCancel:SetHoverFont(Amr.CreateFont("Italic", 14, Amr.Colors.TextHeaderActive))
	c:AddChild(coverCancel)
	coverCancel:SetPoint("CENTER", c.frame, "CENTER", 0, -20)
	
	coverCancel:SetCallback("OnClick", function(widget)
		Amr:HideCover()
	end)
	
	-- create cover content area for custom cover ui (sort of like a modal dialog)
	local coverContent = AceGUI:Create("AmrUiPanel")
	coverContent:SetLayout("None")
	coverContent:SetBackgroundColor(Amr.Colors.Black, 0)
	c:AddChild(coverContent)
	coverContent:SetPoint("TOPLEFT", c.frame, "TOPLEFT")
	coverContent:SetPoint("BOTTOMRIGHT", c.frame, "BOTTOMRIGHT")

	_mainFrame = f
	_mainTabs = t
	_mainCover = {
		panel   = c,
		content = coverContent,
		label   = coverMsg,
		cancel  = coverCancel
	}
end

function Amr:ShowCover(msgOrRenderFunc, disableCancel)
	if _mainCover then
		_mainCover.panel:SetVisible(true)
		
		if type(msgOrRenderFunc) == "function" then
			_mainCover.label:SetText("")
			_mainCover.cancel:SetVisible(false)
			
			-- render custom content into the cover
			msgOrRenderFunc(_mainCover.content)
		else
			-- standard loading/waiting message with optional cancel button
			_mainCover.label:SetText(msgOrRenderFunc or "")
			_mainCover.cancel:SetVisible(not disableCancel)
		end
	end
end

function Amr:HideCover()
	if _mainCover then
		_mainCover.panel:SetVisible(false)
		
		-- release any custom content rendered into the cover
		_mainCover.content:ReleaseChildren()
	end
end

-- shows a "modal" alert over the main UI
function Amr:ShowAlert(message, btnText)

	Amr:ShowCover(function(container)
		local border = AceGUI:Create("AmrUiPanel")
		border:SetLayout("None")
		border:SetBackgroundColor(Amr.Colors.BorderBlue)
		border:SetWidth(400)
		border:SetHeight(150)
		container:AddChild(border)
		border:SetPoint("CENTER", container.frame, "CENTER")

		local bg = AceGUI:Create("AmrUiPanel")
		bg:SetLayout("None")
		bg:SetBackgroundColor(Amr.Colors.Bg)
		border:AddChild(bg)
		bg:SetPoint("TOPLEFT", border.frame, "TOPLEFT", 1, -1)
		bg:SetPoint("BOTTOMRIGHT", border.frame, "BOTTOMRIGHT", -1, 1)
		
		local lbl = AceGUI:Create("AmrUiLabel")
		bg:AddChild(lbl)
		lbl:SetWidth(360)
		lbl:SetFont(Amr.CreateFont("Regular", 16, Amr.Colors.Text))
		lbl:SetJustifyH("CENTER")
		lbl:SetText(message)
		lbl:SetPoint("TOP", bg.content, "TOP", 0, -20)

		local btn = AceGUI:Create("AmrUiButton")
		btn:SetBackgroundColor(Amr.Colors.Orange)
		btn:SetFont(Amr.CreateFont("Bold", 16, Amr.Colors.White))
		btn:SetWidth(120)
		btn:SetHeight(26)
		btn:SetText(btnText)
		bg:AddChild(btn)
		btn:SetPoint("BOTTOM", bg.content, "BOTTOM", 0, 20)
		
		btn:SetCallback("OnClick", function(widget)
			Amr:HideCover()
		end)
	end)
end

-- toggle visibility of the UI
function Amr:Toggle()
	if not self:IsEnabled() then return end
	
	if not _mainFrame then
		self:Show()
	else
		self:Hide()
	end
end

-- hide the UI if not already hidden
function Amr:Hide()
	if not self:IsEnabled() then return end
	if not _mainFrame then return end
	
	_mainFrame:Hide()
end

-- show the UI if not shown already, and display the last active tab
function Amr:Show()
	if not self:IsEnabled() then return end
	
	if InCombatLockdown() then return end

	if _mainFrame then 
		_mainFrame:Show()
	else	
		createMainWindow()
	end
	
	-- show the active tab
	_mainTabs:SelectTab(_activeTab)
end

function Amr:Reset()
	if not self:IsEnabled() then return end
	
	Amr:Hide()
	--Amr:HideLootWindow()
	Amr:HideShopWindow()
	Amr:HideJunkWindow()
	Amr.db.profile.options.uiScale = 1
	Amr.db.profile.window = {}
	Amr.db.profile.lootWindow = {}
	Amr.db.profile.shopWindow = {}
	Amr.db.profile.junkWindow = {}
end

-- show the UI if not shown already, and select the specified tab
function Amr:ShowTab(tab)
	if not self:IsEnabled() then return end
	
	_activeTab = tab
	self:Show()
end

function Amr:GetActiveUiTab()
	return _activeTab
end

----------------------------------------------------------------------------------------
-- Tooltips
----------------------------------------------------------------------------------------

-- set an item tooltip on any AceGUI widget with OnEnter and OnLeave events
function Amr:SetItemTooltip(obj, itemLink, anchor, x, y)
	obj:SetUserData("ttItemLink", itemLink)
	obj:SetCallback("OnEnter", function(widget)
		local tooltipLink = widget:GetUserData("ttItemLink")
		if tooltipLink then
			GameTooltip:SetOwner(widget.frame, anchor and anchor or "ANCHOR_CURSOR", x, y)
			GameTooltip:SetHyperlink(tooltipLink)
		end
	end)
	obj:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)			
end

function Amr:SetSpellTooltip(obj, spellId, anchor, x, y)
	obj:SetUserData("ttSpellId", spellId)
	obj:SetCallback("OnEnter", function(widget)
		local ttSpellId = widget:GetUserData("ttSpellId")
		if ttSpellId then
			GameTooltip:SetOwner(widget.frame, anchor and anchor or "ANCHOR_CURSOR", x, y)
			GameTooltip:SetSpellByID(ttSpellId)
		end
	end)
	obj:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
end

function Amr:RenderCoverChrome(container, width, height)

	local border = AceGUI:Create("AmrUiPanel")
	border:SetLayout("None")
	border:SetBackgroundColor(Amr.Colors.BorderBlue)
	border:SetWidth(width + 2)
	border:SetHeight(height + 2)
	container:AddChild(border)
	border:SetPoint("CENTER", container.frame, "CENTER")

	local bg = AceGUI:Create("AmrUiPanel")
	bg:SetLayout("None")
	bg:SetBackgroundColor(Amr.Colors.Bg)
	border:AddChild(bg)
	bg:SetPoint("TOPLEFT", border.frame, "TOPLEFT", 1, -1)
	bg:SetPoint("BOTTOMRIGHT", border.frame, "BOTTOMRIGHT", -1, 1)
	
	return bg, border
end
