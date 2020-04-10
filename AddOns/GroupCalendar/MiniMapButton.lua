local _G = getfenv(0)
local LibStub = _G.LibStub
local MiniMapButton = {}
GroupCalendarMiniMapButton = MiniMapButton
local GCButton = LibStub("LibDBIcon-1.0")

gGroupCalendar_MiniMapSettings = 
{
	shown = true,
	locked = false,
	minimapPos = 218
}

-- LDB
if not LibStub:GetLibrary("LibDataBroker-1.1", true) then return end


local MiniMapLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("GroupCalendar", {
	type = "launcher",
	text = GroupCalendar_cTitle,
	icon = "Interface\\AddOns\\GroupCalendar\\Textures\\CalendarIcon",
	OnTooltipShow = function(tooltip)		
		tooltip:AddLine(GroupCalendar_cTitle)		
	end,
	OnClick = function(self, button)
		if GroupCalendarFrame:IsVisible() then
          HideUIPanel(GroupCalendarFrame);
        else
          ShowUIPanel(GroupCalendarFrame);		  
        end
	end,
})

function MiniMapButton.Init()
	GCButton:Register("GroupCalendar", MiniMapLDB, gGroupCalendar_MiniMapSettings);
end

function MiniMapButton.ResetFrames()
	gGroupCalendar_MiniMapSettings.minimapPos = 218;
	GCButton:Refresh("GroupCalendar");
end

function MiniMapButton.Toggle()
	gGroupCalendar_MiniMapSettings.shown = not gGroupCalendar_MiniMapSettings.shown
	gGroupCalendar_MiniMapSettings.hide = not gGroupCalendar_MiniMapSettings.hide
	if not gGroupCalendar_MiniMapSettings.hide then
		GCButton:Show("GroupCalendar")
	else
		GCButton:Hide("GroupCalendar")
	end
end

function MiniMapButton.ApplySettings()
	if not gGroupCalendar_MiniMapSettings.hide then
		GCButton:Show("GroupCalendar")
	else
		GCButton:Hide("GroupCalendar")
	end
end

function MiniMapButton.Lock_Toggle()
	if gGroupCalendar_MiniMapSettings.locked then
		GCButton:Lock("GroupCalendar");
	else
		GCButton:Unlock("GroupCalendar");
	end
end
