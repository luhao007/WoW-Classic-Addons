--[[-----------------------------------------------------------------------------
Dropdown picker widget.
Simple version that handles our limited needs.
-------------------------------------------------------------------------------]]
local Type, Version = "AmrUiDropDown", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local CreateFrame, UIParent = CreateFrame, UIParent


--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function buttonOnClick(frame, ...)	
	if frame.obj.list:IsVisible() then
		frame.obj.list:Hide()
	else
		frame.obj.list:Show()
		frame.obj.list:SetFrameLevel(100)
		frame.obj:RenderItems()
	end
end

local function buttonOnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function buttonOnLeave(frame)
	frame.obj:Fire("OnLeave")
end

local function itemOnClick(frame, ...)
	frame.obj:SelectItem(frame.value)
	frame.obj.list:Hide()
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(24)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetFont(Amr.CreateFont("Regular", 14, Amr.Colors.Text))
		self:SetItems()
		self:SelectItem()
		self.frame:ClearAllPoints()
		self.list:Hide()
	end,
	
	["OnRelease"] = function(self)
		self.itemlist = nil
		for _, item in pairs(self.items) do
			item:Hide()
		end
	end,
	
	["OnWidthSet"] = function(self, width)
		self.frame:GetFontString():SetWidth(width)
		self.list:SetWidth(width)
	end,
	
	["OnHeightSet"] = function(self, height)
		self.frame:GetFontString():SetHeight(height)
	end,
	
	["SetFont"] = function(self, font)
		self.frame:SetNormalFontObject(font)
		
		local _, h = font:GetFont()
		self.fontHeight = h
	end,
	
	["SelectItem"] = function(self, value)
		-- clear any current selection
		self.frame:SetText()
		
		if not self.itemlist or not value then return end
		
		local found = nil
		for i, obj in ipairs(self.itemlist) do
			local wasSelected = obj.selected
			obj.selected = obj.value == value
			
			if obj.selected then
				self.frame:SetText(obj.text)
				if not wasSelected then
					found = obj.value
				end
			end
		end

		-- redraw the list if it is open
		if self.list:IsVisible() then
			self:RenderItems()
		end
		
		-- only fires if selection actually changed
		if found then
			self:Fire("OnChange", found)
		end
	end,
	
	-- the list of items to display, ordered list of objects with value, text, color, and selected properties, only supports single selection
	["SetItems"] = function(self, items)
		self.itemlist = items
		self:RenderItems()
	end,
	
	["CreateItem"] = function(self, index)
		local itemname = ("AmrUiDropDown%dItem%d"):format(self.num, index)
		
		local item = CreateFrame("Button", itemname, self.list)
		item.obj = self
		
		item:SetHeight(24)
		item:SetPoint("LEFT", self.list, "LEFT", 1, 0)
		item:SetPoint("RIGHT", self.list, "RIGHT", -1, 0)
		
		local txt = item:CreateFontString()
		item:SetFontString(txt)
		txt:SetPoint("LEFT", item, "LEFT", 4, 0)
		txt:SetPoint("RIGHT", item, "RIGHT", -4, 0)
		txt:SetJustifyH("LEFT")
		
		item:SetPushedTextOffset(0, 0)
		
		-- not perfect, but more or less achieves the effect of lightening the bg color slightly on hover
		local texHigh = item:CreateTexture(nil, "BORDER")
		texHigh:SetColorTexture(1, 1, 1, 0.1)
		texHigh:SetAllPoints(true)
		item:SetHighlightTexture(texHigh)
		
		item:SetScript("OnClick", itemOnClick)

		return item
	end,
	
	["RenderItems"] = function(self)
		if not self.itemlist then return end
		if not self.list:IsVisible() then return end
		
		local prev = nil
		local h = 0
		
		for i, obj in ipairs(self.itemlist) do
			local item = self.items[i]
			if not item then
				item = self:CreateItem(i)
				self.items[i] = item
			end
			
			item:Show()
			item:SetNormalFontObject(Amr.CreateFont(obj.selected and "Bold" or "Regular", obj.selected and self.fontHeight + 2 or self.fontHeight, obj.color or Amr.Colors.White, 1))
			item:SetText(obj.text)
			item.value = obj.value
			
			if prev then
				item:SetPoint("TOP", prev, "BOTTOM")
			else
				item:SetPoint("TOP", self.list, "TOP", 0, -1)
			end
			
			h = h + item:GetHeight()
			prev = item
		end
		
		self.list:SetHeight(h + 2)
	end,
	
	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
		else
			self.frame:Enable()
		end
	end,
	
	["SetVisible"] = function(self, visible)
		if visible then
			self.frame:Show()
		else
			self.frame:Hide()
			self.list:Hide()
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local num = AceGUI:GetNextWidgetNum(Type)
	local name = "AmrUiDropDown" .. num
	local frame = CreateFrame("Button", name, UIParent)
	frame:Hide()
	
	local txt = frame:CreateFontString()
	frame:SetFontString(txt)
	txt:SetPoint("LEFT", frame, "LEFT", 4, 0)
	txt:SetPoint("RIGHT", frame, "RIGHT", -24, 0)
	txt:SetJustifyH("LEFT")
	
	frame:SetPushedTextOffset(0, 0)

	frame:EnableMouse(true)
	frame:SetScript("OnEnter", buttonOnEnter)
	frame:SetScript("OnLeave", buttonOnLeave)
	frame:SetScript("OnClick", buttonOnClick)
	
	local border = Amr.CreateTexture(frame, Amr.Colors.BorderGray, 1, "BACKGROUND")
	border:SetAllPoints()
	
	local bg = Amr.CreateTexture(frame, Amr.Colors.BgInput, 1, "BORDER")
	bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
	bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
	
	local arrow = frame:CreateTexture(nil, "ARTWORK")
	arrow:SetWidth(16)
	arrow:SetHeight(16)
	arrow:SetTexture("Interface\\AddOns\\" .. Amr.ADDON_NAME .. "\\Media\\IconScrollDown")
	arrow:SetPoint("RIGHT", frame, "RIGHT", -4, 0)

	local list = CreateFrame("Frame", nil, frame)
	list:SetFrameStrata("TOOLTIP")
	list:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 1)
	list:Hide()
	
	local listBorder = Amr.CreateTexture(list, Amr.Colors.BorderGray, 1, "BACKGROUND")
	listBorder:SetAllPoints()
	
	local listBg = Amr.CreateTexture(list, Amr.Colors.BgInput, 1, "BORDER")
	listBg:SetPoint("TOPLEFT", list, "TOPLEFT", 1, -1)
	listBg:SetPoint("BOTTOMRIGHT", list, "BOTTOMRIGHT", -1, 1)
	
	local widget = {
		num       = num,
		list      = list,
		items     = {},
		frame     = frame,
		type      = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	frame.obj = widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
