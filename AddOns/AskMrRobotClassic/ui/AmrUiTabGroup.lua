--[[-----------------------------------------------------------------------------
AMR TabGroup Container
Container that uses tabs on top to switch between groups.
This is adapted from AceGUIContainer-TabGroup, but has a custom look.
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiTabGroup", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")

-- Lua APIs
local pairs, ipairs, assert, type = pairs, ipairs, assert, type

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent
local _G = _G


--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]

local function tabSetSelected(frame, selected)
	frame.selected = selected
end

local function tabSetDisabled(frame, disabled)
	frame.disabled = disabled
end

local function buildTabsOnUpdate(frame)
	local self = frame.obj
	self:BuildTabs()
	frame:SetScript("OnUpdate", nil)
end


--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function tabOnClick(frame)
	if not (frame.selected or frame.disabled) then
		--PlaySound("igCharacterInfoTab")
		frame.obj:SelectTab(frame.value)
	end
end


--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self.tabSelector:Hide()
		self.frame:ClearAllPoints()
	end,

	["OnRelease"] = function(self)
		self.status = nil
		for k in pairs(self.localstatus) do
			self.localstatus[k] = nil
		end
		self.tablist = nil
		for _, tab in pairs(self.tabs) do
			tab:Hide()
		end
		self.tabSelector:Hide()
	end,

	["CreateTab"] = function(self, id, style)
		local tabname = ("AmrUiTabGroup%dTab%d"):format(self.num, id)
		
		local tab = CreateFrame("Button", tabname, self.border)
		tab.obj = self
		tab.id = id
		
		if style == "bold" then
			tab:SetNormalFontObject(Amr.CreateFont("Regular", 24, Amr.Colors.TextHeaderDisabled))
			tab:SetHighlightFontObject(Amr.CreateFont("Regular", 24, Amr.Colors.TextHover))
		else
			tab:SetNormalFontObject(Amr.CreateFont("Regular", 28, Amr.Colors.Text))
			tab:SetHighlightFontObject(Amr.CreateFont("Regular", 28, Amr.Colors.TextHover))
		end
		
		tab:SetScript("OnClick", tabOnClick)

		tab.SetSelected = tabSetSelected
		tab.SetDisabled = tabSetDisabled

		return tab
	end,

	["SetStatusTable"] = function(self, status)
		assert(type(status) == "table")
		self.status = status
	end,

	["SelectTab"] = function(self, value)
		local status = self.status or self.localstatus
		
		self.tabSelector:Hide()
		
		local found
		for i, v in ipairs(self.tabs) do
			if v.value == value then
				v:SetSelected(true)
				found = true
				
				-- show the tab selector under the proper tab
				if v.style == "underline" then
					self.tabSelector:SetWidth(v:GetWidth())
					self.tabSelector:ClearAllPoints()
					self.tabSelector:SetPoint("TOPLEFT", v, "BOTTOMLEFT", 0, -2)
					self.tabSelector:Show()
					v:SetNormalFontObject(Amr.CreateFont("Regular", 28, Amr.Colors.Text))
					v:SetHighlightFontObject(Amr.CreateFont("Regular", 28, Amr.Colors.Text))
				elseif v.style == "bold" then
					v:SetNormalFontObject(Amr.CreateFont("Bold", 28, Amr.Colors.TextHeaderActive))
					v:SetHighlightFontObject(Amr.CreateFont("Bold", 28, Amr.Colors.TextHeaderActive))
				end
			else
				v:SetSelected(false)
				if v.style == "bold" then
					v:SetNormalFontObject(Amr.CreateFont("Regular", 24, Amr.Colors.TextHeaderDisabled))
					v:SetHighlightFontObject(Amr.CreateFont("Regular", 24, Amr.Colors.TextHover))
				else
					v:SetNormalFontObject(Amr.CreateFont("Regular", 28, Amr.Colors.Text))
					v:SetHighlightFontObject(Amr.CreateFont("Regular", 28, Amr.Colors.TextHover))
				end
			end
		end
		status.selected = value
		
		-- call this to reposition after style change
		self:BuildTabs()
		
		if found then
			self:Fire("OnGroupSelected",value)
		end
	end,

	["SetTabs"] = function(self, tabs)
		self.tablist = tabs
		self:BuildTabs()
	end,

	["BuildTabs"] = function(self)
		local status = self.status or self.localstatus
		local tablist = self.tablist
		local tabs = self.tabs
		
		if not tablist then return end
		
		local first = true
		for i, v in ipairs(tablist) do
			local tab = tabs[i]
			if not tab then
				tab = self:CreateTab(i)
				tabs[i] = tab
			end
			
			local padding = 20
			if v.style == "bold" then padding = 0 end
			
			tab:Show()
			tab:SetText(v.text)
			tab:SetWidth(tab:GetTextWidth() + padding)
			tab:SetHeight(tab:GetTextHeight())
			tab:SetDisabled(v.disabled)
			tab.value = v.value			
			tab.style = v.style or "underline"
			
			tab:ClearAllPoints()
			if first then
				local firstOffset = 0
				if tab.style == "bold" then firstOffset = 4 end
				tab:SetPoint("BOTTOMLEFT", self.border, "TOPLEFT", firstOffset, 8)
				first = false
			else
				tab:SetPoint("LEFT", tabs[i - 1], "RIGHT", 30, 0)
			end
		end
	end,

	["OnWidthSet"] = function(self, width)
		local content = self.content
		local contentwidth = width - 60
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
		self:BuildTabs(self)
		self.frame:SetScript("OnUpdate", buildTabsOnUpdate)
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		local contentheight = height - (self.borderoffset + 23)
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end,
	
	["LayoutFinished"] = function(self, width, height)
		if self.noAutoHeight then return end
		self:SetHeight((height or 0) + (self.borderoffset + 23))
	end,
	
	["SetVisible"] = function(self, visible)
		if visible then
			self.frame:Show()
		else
			self.frame:Hide()
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local num = AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(100)
	frame:SetWidth(100)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")

	local border = CreateFrame("Frame", nil, frame)
	local borderoffset = 30
	border:SetPoint("TOPLEFT", 0, -borderoffset)
	border:SetPoint("BOTTOMRIGHT", 0, 3)
	
	local line = border:CreateTexture(nil, "ARTWORK")
	line:Hide()
	line:SetColorTexture(1, 1, 1, 1)
	line:SetHeight(4)

	local content = CreateFrame("Frame", nil, border)
	content:SetPoint("TOPLEFT", 0, 0)
	content:SetPoint("BOTTOMRIGHT", 0, 0)

	local widget = {
		num          = num,
		frame        = frame,
		localstatus  = {},
		alignoffset  = 18,
		border       = border,
		borderoffset = borderoffset,
		tabs         = {},
		tabSelector  = line,
		content      = content,
		type         = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	
	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
