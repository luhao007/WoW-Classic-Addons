
local addon = AddonUsage

local settings -- will become savedvar
local profilingCPU = nil -- becomes true if cpu profiling is enabled
local updateInfo = true -- also becomes true in ADDON_LOADED, to know whether to look for new addons in GatherUsage
local addonInfo = {} -- unordered table of all addons and their usage, indexed by addonIndex
_addonInfo = addonInfo
-- [addonIndex] = {
--		name = string, the folder name of the addon
--		title = string, the display name of the addon (color codes stripped out)
--		memory = number, memory usage of the addon (in k)
--		cpu = number, cpu usage of the addon (in ms)
local displayedList = {} -- ordered list of indexes into addonList of addons to show in the list
local addonIndexes = {} -- indexed by addon name, the addonIndex of the named addon
local totals = {
	memory=0,	-- total memory used by all addons
	cpu=0, -- total cpu time used by all addons
	start=0, -- start time when tracking begins
	duration=0, -- total time since tracking began
}

local maxMemValue = 1000 -- memory column will be sized for 1000.0 to start
local maxCPUValue = 10 -- cpu column will be sized for 100.00 to start
local updateWidths = true -- first pass will calculate following widths
local widthMem = 0 -- width of memory column
local widthCPU = 0 -- width of cpu column
local widthPercent -- width of percent columns will be fixed to "100%" size

local patternMem = "%.1f"
local patternCPU = "%.2f"
local patternPercent = "%d%%"

local sortOrder -- will be the sort order (1=name, 2=mem, 3=cpu; negative for reverse sort)

local updateTimer = 0 -- elapsed timer for continuous update (play/pause)
local updateFrequency = 1 -- seconds between updates during continuous updates

local TWW_CLIENT = select(4,GetBuildInfo())>=110000

-- Bindings.xml globals
BINDING_HEADER_ADDONUSAGE = "Addon Usage"
BINDING_NAME_ADDONUSAGE_TOGGLE = "Toggle Addon Usage"

function addon:Toggle()
	addon:SetShown(not addon:IsVisible())
end
AddonUsageToggleWindow = addon.Toggle

function addon:OnEvent(event,...)
	if addon[event] then
		addon[event](self,...)
	end
end

function addon:OnShow()
	addon.ColumnDividers:SetFrameLevel(addon:GetFrameLevel()+6)
	addon:UpdateContinuousUpdate()
	addon:Update()
end

function addon:Update()
	if addon:IsVisible() then
		addon:GatherUsage() -- grab usage data
		addon:PopulateList() -- generate displayedList of addons
		addon:UpdateTotals() -- update totals at bottom of window
	end
end

function addon:ADDON_LOADED()
	updateInfo = true
end

function addon:PLAYER_LOGIN()

	if type(AddonUsageSettings)~="table" then
		AddonUsageSettings = {}
	end
	settings = AddonUsageSettings

	profilingCPU = GetCVarBool("scriptProfile")
	totals.start = GetTime()

	addon.TitleText:SetText("Addon Usage")

	-- create AutoScrollFrame where displayedList will be shown
	local template = format("AddonUsageListButton%sTemplate",profilingCPU and "WithCPU" or "WithoutCPU")
	addon.List = AutoScrollFrame:Create(addon,template,displayedList,addon.FillButton)
	addon.List:SetPoint("TOPLEFT",4,-45)
	addon.List:SetPoint("BOTTOMRIGHT",-6,33)
	addon.List:WrapUpdate(nil,addon.PostUpdate)

	-- set up width of percent column
	widthPercent = addon:GetCellWidth("100%")

	addon.ColumnDividers:SetPoint("TOPLEFT",addon.MemHeader,"BOTTOMLEFT",0,-3)
	if profilingCPU then
		addon.ColumnDividers:SetPoint("TOPRIGHT",addon.CPUHeader,"BOTTOMLEFT",1,-3)
		addon.Totals.Divider:Show()
	else
		addon.ColumnDividers:SetPoint("TOPRIGHT",addon.MemHeader,"BOTTOMLEFT",1,-3)
		addon.ColumnDividers.CPUColumn:Hide()
		-- remove CPU header if not profiling cpu
		addon.CPUHeader:Hide()
		addon.MemHeader:SetPoint("TOPRIGHT",-28,-24)
		addon.Totals.CPU:Hide()
		addon.Totals.Mem:SetPoint("RIGHT")
	end
	addon.ColumnDividers:SetPoint("BOTTOM",addon.List.frame,"BOTTOM",0,3)

	-- to remove influence of startup initialization on numbers (since we can't guarantee all
	-- addons' initialization was captured), going to reset 1/4 second after login for a baseline
	-- (not using first frame since some addons wait until first frame to do their stuff)
	C_Timer.After(0.25,addon.ResetUsage)

	addon.CPUCheckButton:SetChecked(profilingCPU)
	addon.CPUCheckButton.Text:SetText("CPU Usage")

	addon:RegisterEvent("ADDON_LOADED")

	SLASH_ADDONUSAGE1 = "/addonusage"
	SlashCmdList.ADDONUSAGE = addon.Toggle

end

-- resets usage stats
function addon:ResetUsage()
	totals.start = GetTime()-0.01 -- back in time a hundredth of a sec to prevent division by zero
	ResetCPUUsage()
	collectgarbage()
	addon:Update()
end

function addon:GetNumAddOns()
	if TWW_CLIENT then
		return C_AddOns.GetNumAddOns()
	else
		return GetNumAddOns()
	end
end

function addon:IsAddOnLoaded(index)
	if TWW_CLIENT then
		return C_AddOns.IsAddOnLoaded(index)
	else
		return IsAddOnLoaded(index)
	end
end

function addon:GetAddOnInfo(index)
	if TWW_CLIENT then
		return C_AddOns.GetAddOnInfo(index)
	else
		return GetAddOnInfo(index)
	end
end

-- fills addonInfo, addonIndexes and totals from the currently loaded addons and their usage
function addon:GatherUsage()
	-- look for any new addons loaded (first run or any load on demand after first run)
	if updateInfo then
		for i=1,addon:GetNumAddOns() do
			if not addonInfo[i] and addon:IsAddOnLoaded(i) then
				local name,title = addon:GetAddOnInfo(i)
				title = title:gsub("\124c%x%x%x%x%x%x%x%x",""):gsub("\124r",""):gsub("[<>]","") -- strip color codes from titles
				addonInfo[i] = {name=name,title=title}
				addonIndexes[name] = i
			end
		end
		updateInfo = nil
	end
	-- call update APIs to refresh mem/cpu usage
	UpdateAddOnMemoryUsage()
	if profilingCPU then
		UpdateAddOnCPUUsage()
	end
	-- and log the values for each addon
	totals.memory = 0
	totals.cpu = 0
	totals.duration = GetTime()-totals.start
	for addonIndex,info in pairs(addonInfo) do
		info.memory = GetAddOnMemoryUsage(addonIndex)
		totals.memory = totals.memory + info.memory
		if profilingCPU then
			info.cpu = GetAddOnCPUUsage(addonIndex)
			totals.cpu = totals.cpu + info.cpu
		end
	end
	-- now adjust cpu time to ms/s based on totals.start time, if cpu being profiled
	if profilingCPU then
		local timePassed = GetTime() - totals.start
		timePassed = max(timePassed,0.01) -- prevent divide by zero errors
		totals.cpu = totals.cpu / timePassed
		for addonIndex,info in pairs(addonInfo) do
			info.cpu = info.cpu / timePassed
		end
	end
end

-- fills displayedList and sorts it, fills formattedData with results to display
function addon:PopulateList()

	wipe(displayedList)
	for addonIndex,info in pairs(addonInfo) do
		tinsert(displayedList,addonIndex)
	end

	-- sort list; settings.sortOrder should be one of the following integers:
	-- 1=name, 2=memory, 3=cpu, -1=reverse name, -2=reverse memory, -3=reverse cpu
	if type(settings.sortOrder)~="number" then
		settings.sortOrder = 3 -- if no sort defined, try cpu as default
	end
	if abs(settings.sortOrder)==3 and not profilingCPU then
		settings.sortOrder = 2 -- if cpu sort defined and not profiling cpu, sort by memory
	end
	sortOrder = settings.sortOrder

	table.sort(displayedList,addon.SortList)

	-- update the displayed list (this will note max widths too)
	addon.List:Update()

end

-- table.sort function for the displayedList; e1 and e2 are addon indexes
function addon.SortList(e1,e2)
	local info1 = addonInfo[e1]
	local info2 = addonInfo[e2]
	-- if sorting by memory
	if sortOrder==2 or sortOrder==-2 then
		local mem1 = info1.memory
		local mem2 = info2.memory
		if mem1~=mem2 then
			if sortOrder==2 then
				return mem2<mem1
			else
				return mem1<mem2
			end
		end
	end
	-- if sorting by cpu
	if sortOrder==3 or sortOrder==-3 then
		local cpu1 = info1.cpu
		local cpu2 = info2.cpu
		if cpu1~=cpu2 then
			if sortOrder==3 then
				return cpu2<cpu1
			else
				return cpu1<cpu2
			end
		end
	end
	-- sort by title next
	local title1 = info1.title
	local title2 = info2.title
	if title1~=title2 then
		if sortOrder>0 then
			return title1<title2
		else
			return title2<title1
		end
	end
	-- if we reached here two addons shared same title, sort by addon name
	if sortOrder>0 then
		return info1.name<info2.name
	else
		return info2.name<info1.name
	end
end

-- breaks up large numbers by inserting commas for thousands, millions, etc
local function formatNumber(number,pattern)
	local isBig = number>=1000
  number = string.format(pattern,number)
	if isBig then
	  local subCount
	  repeat
	    number,subCount = number:gsub("^(-?%d+)(%d%d%d)","%1,%2")
	  until subCount==0
	end
  return number
end

function addon:UpdateTotals()
	addon.Totals.Mem:SetText(formatNumber(totals.memory,"%.1f \124cffffd200k"))
	addon.Totals.CPU:SetText(formatNumber(totals.cpu,"%.2f \124cffffd200ms/s"))
	addon.NameHeader:SetText(format("%d Addons",#displayedList))
end


function addon:FillButton(info)
	info = addonInfo[info]
	if info then
		self.Stripe:SetShown(self.index%2==0)
		self.Name:SetText(info.title)

		local mem = formatNumber(info.memory,patternMem)
		self.Mem:SetText(mem)
		if info.memory > maxMemValue then
			maxMemValue = info.memory
			updateWidths = true
		end
		local memPercent = format(patternPercent,totals.memory>0 and info.memory*100/totals.memory or 0)
		self.MemPercent:SetText(fillTotals and "100%" or memPercent)
		self.MemPercent:SetWidth(widthPercent)

		if profilingCPU then
			local cpu = formatNumber(info.cpu,patternCPU)
			self.CPU:SetText(cpu)
			if info.cpu > maxCPUValue then
				maxCPUValue = info.cpu
				updateWidths = true
			end
			local cpuPercent = format(patternPercent,totals.cpu>0 and info.cpu*100/totals.cpu or 0)
			self.CPUPercent:SetText(fillTotals and "100%" or cpuPercent)
			self.CPUPercent:SetWidth(widthPercent)
		end
	end
end

-- function to run after AutoScrollFrame does an update
-- adjusts width of all number cells based on their maximum width
function addon:PostUpdate()

	-- if needed, calculate widthMem and widthCPU
	if updateWidths then
		updateWidths = nil
		-- substituting digits with 0's for a consistent width
		widthMem = addon:GetCellWidth(formatNumber(maxMemValue,patternMem):gsub("%d","0"))
		if profilingCPU then
			widthCPU = addon:GetCellWidth(formatNumber(maxCPUValue,patternCPU):gsub("%d","0"))
		end
		-- update width of memory and cpu headers
		local widthMemColumn = widthMem+24+widthPercent
		local widthCPUColumn = 0
		addon.MemHeader:SetWidth(widthMemColumn)
		addon.Totals.Mem:SetWidth(widthMemColumn-4)
		if profilingCPU then
			widthCPUColumn = widthCPU+15+widthPercent
			addon.CPUHeader:SetWidth(widthCPUColumn)
			addon.Totals.CPU:SetWidth(widthCPUColumn-4)
			addon.Totals.Divider:ClearAllPoints()
			addon.Totals.Divider:SetPoint("RIGHT",-widthCPUColumn-1,0)
		end
		addon.Totals:SetWidth(widthMemColumn+widthCPUColumn+4)
		-- in next frame, after Totals hitrects defined, change minimum width to 200+Totals width
		C_Timer.After(0,addon.UpdateMinResize)
	end

	-- update width of list button memory and cpu cells
	-- being done outside updateWidths because new rows can be created
	local buttons = addon.List:GetListButtons()
	for i=1,#buttons do
		local button = buttons[i]
		button.Mem:SetWidth(widthMem)
		if profilingCPU then
			button.CPU:SetWidth(widthCPU)
		end
	end

end

function addon:UpdateMinResize()
	-- 200 is the width of the window outside the cpu and memory columns
	local minWidth = addon.Totals:GetWidth() + 200
	addon:SetResizeBounds(minWidth,200)
	if addon:GetWidth()<minWidth then
		addon:SetWidth(minWidth)
		addon:SetUserPlaced(true)
	end
end

-- returns the width that text would take up in a fontstring
-- a separate fontstring (WidthTest) is used to get the width because cells are bounded
-- by size and we need the unbounded width to expand
function addon:GetCellWidth(text)
	addon.WidthTest:SetText(text)
	return addon.WidthTest:GetStringWidth()
end

-- click of the name/memory/cpu headers to sort list
function addon:HeaderOnClick()
	local id = self:GetID()
	if id == abs(sortOrder) then
		settings.sortOrder = -sortOrder
	else
		settings.sortOrder = id
	end
	addon:Update()
end

function addon:CPUCheckButtonOnClick()
	local check = addon.CPUCheckButton
	local enable = check:GetChecked()
	-- todo: see if these still cause taint; not that big a deal since seeing one means a reload will probably happen
	StaticPopupDialogs["ADDONUSAGEPROFILE"] = {
			text = enable and "Do you want to turn on CPU monitoring and reload the UI?\n\nCPU monitoring causes overhead that will slightly affect performance while enabled.\n\nRemember to turn it off when done testing." or "Turn off CPU monitoring and reload the UI?",
			button1="Yes", button2="No", timeout=30, whileDead=1, showAlert=enable, hideOnEscape=1,
			OnAccept=function() SetCVar("scriptProfile",enable and 1 or 0) ReloadUI() end,
			OnCancel=function() check:Enable() check:SetChecked(not enable) end
		}
	check:Disable()
	StaticPopup_Show("ADDONUSAGEPROFILE")
end

-- this updates the icon on the play button which is cropped from
-- down is true if the button should be pushed down, false otherwise
function addon:UpdateButtonIcon(down)
	local icon = self.Icon
	local yoff = self==addon.UpdateButton and -1 or 0 -- nudge update icon down a little
	if down then
		icon:SetPoint("CENTER",-2,-2+yoff)
		icon:SetVertexColor(0.5,0.5,0.5)
	else
		icon:SetPoint("CENTER",-1,yoff)
		local color = (self==addon.PlayButton and settings.Play) and 0.8 or 1 -- dim pause icon slightly (its yellow is too bright)
		icon:SetVertexColor(color,color,color)
	end
end

-- click of the play/pause button
function addon:PlayButtonOnClick()
	if IsShiftKeyDown() then
		addon:Update() -- if shift is down just do a one-off update and don't change state
	else
		settings.Play = not settings.Play
		addon.UpdateButtonIcon(addon.PlayButton,false,true)
		addon:UpdateContinuousUpdate()
		if settings.Play then
			addon:Update() -- kick off an immediate update when hitting play
		end
	end
end

-- turns on or off the OnUpdate depending on settings.Play
function addon:UpdateContinuousUpdate()
	updateTimer = 0
	addon:SetScript("OnUpdate",settings.Play and addon.ContinuousUpdate or nil)
	addon.PlayButton.Icon:SetTexture(settings.Play and "Interface\\TimeManager\\PauseButton" or "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
end

-- the OnUpdate for the continuous update ("play" button) only defined while settings.Play enabled
function addon:ContinuousUpdate(elapsed)
	updateTimer = updateTimer + elapsed
	if updateTimer > updateFrequency then
		updateTimer = 0
		addon:Update()
	end
end

-- tooltip of little buttons
function addon:ButtonOnEnter()
	addon.MiniTooltip:SetPoint("BOTTOM",self,"TOP",0,-4)
	addon.MiniTooltip.Text:SetText(self.tooltip)
	addon.MiniTooltip:SetWidth(addon.MiniTooltip.Text:GetStringWidth()+16)
	addon.MiniTooltip:Show()
end
