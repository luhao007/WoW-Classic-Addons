local Amr = LibStub("AceAddon-3.0"):GetAddon("AskMrRobotClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("AskMrRobotClassic", true)
local AceGUI = LibStub("AceGUI-3.0")

local _lblLogging = nil
local _btnToggle = nil
local _panelUndoWipe = nil
local _chkAutoAll = nil
local _autoChecks = nil

local function createDifficultyCheckBox(instanceId, difficultyId, container)
	local chk = AceGUI:Create("AmrUiCheckBox")
	container:AddChild(chk)
	chk:SetText(L.DifficultyNames[difficultyId])
	chk:SetCallback("OnClick", function(widget)
		Amr:ToggleAutoLog(instanceId, difficultyId)
	end)
	
	_autoChecks[instanceId][difficultyId] = chk
	return chk
end

-- render a group of controls for auto-logging of a raid zone
local function renderAutoLogSection(instanceId, container, i, autoLbls, autoChks)
	_autoChecks[instanceId] = {}
	
	local lbl = AceGUI:Create("AmrUiLabel")
	container:AddChild(lbl)
	lbl:SetWidth(200)
	lbl:SetText(L.InstanceNames[instanceId])
	lbl:SetFont(Amr.CreateFont("Regular", 20, Amr.Colors.White))
	
	if i == 1 then
		lbl:SetPoint("TOPLEFT", _chkAutoAll.frame, "BOTTOMLEFT", -1, -15)
	elseif (i + 1) % 4 == 0 then
		lbl:SetPoint("TOPLEFT", autoLbls[i - 1].frame, "TOPRIGHT", 40, 0)
	elseif (i + 2) % 4 == 0 then
		lbl:SetPoint("TOPLEFT", autoLbls[i - 1].frame, "TOPRIGHT", 40, 0)
	elseif i % 4 == 0 then
		lbl:SetPoint("TOPLEFT", autoLbls[i - 1].frame, "TOPRIGHT", 40, 0)		
	else
		lbl:SetPoint("TOPLEFT", autoChks[i - 4].frame, "BOTTOMLEFT", 0, -30)
	end

	local line = AceGUI:Create("AmrUiPanel")
	container:AddChild(line)
	line:SetHeight(1)
	line:SetBackgroundColor(Amr.Colors.White)
	line:SetPoint("TOPLEFT", lbl.frame, "BOTTOMLEFT", 1, -7)
	line:SetPoint("TOPRIGHT", lbl.frame, "BOTTOMRIGHT", 0, -7)
	
	local chkMythic = createDifficultyCheckBox(instanceId, Amr.Difficulties.Normal, container)
	chkMythic:SetPoint("TOPLEFT", line.frame, "BOTTOMLEFT", 0, -8)

	local chkNormal = createDifficultyCheckBox(instanceId, Amr.Difficulties.Normal25, container)
	chkNormal:SetPoint("TOPLEFT", line.frame, "BOTTOMLEFT", 0, -30)

	if #Amr.InstanceDifficulties[instanceId] > 2 then
		-- find the widest of mythic/normal
		local w = math.max(chkMythic:GetWidth(), chkNormal:GetWidth())
		
		local chkHeroic = createDifficultyCheckBox(instanceId, Amr.Difficulties.Heroic, container)
		chkHeroic:SetPoint("TOPLEFT", line.frame, "BOTTOMLEFT", w + 20, -8)
		
		local chkLfr = createDifficultyCheckBox(instanceId, Amr.Difficulties.Heroic25, container)
		chkLfr:SetPoint("TOPLEFT", line.frame, "BOTTOMLEFT", w + 20, -30)
	end

	return lbl, chkNormal
end

-- renders the main UI for the Combat Log tab
function Amr:RenderTabLog(container)

	-- main commands
	_btnToggle = AceGUI:Create("AmrUiButton")
	container:AddChild(_btnToggle)
	_btnToggle:SetText(L.LogButtonStartText)
	_btnToggle:SetBackgroundColor(Amr.Colors.Green)
	_btnToggle:SetFont(Amr.CreateFont("Bold", 16, Amr.Colors.White))
	_btnToggle:SetWidth(200)
	_btnToggle:SetHeight(26)
	_btnToggle:SetCallback("OnClick", function() Amr:ToggleLogging() end)
	_btnToggle:SetPoint("TOPLEFT", container.content, "TOPLEFT", 0, -40)
	
	_lblLogging = AceGUI:Create("AmrUiLabel")
	container:AddChild(_lblLogging)
	_lblLogging:SetText(L.LogNote)
	_lblLogging:SetWidth(200)	
	_lblLogging:SetFont(Amr.CreateFont("Italic", 14, Amr.Colors.BrightGreen))
	_lblLogging:SetJustifyH("MIDDLE")
	_lblLogging:SetPoint("TOP", _btnToggle.frame, "BOTTOM", 0, -5)
	
	local btnReload = AceGUI:Create("AmrUiButton")
	container:AddChild(btnReload)
	btnReload:SetText(L.LogButtonReloadText)
	btnReload:SetBackgroundColor(Amr.Colors.Blue)
	btnReload:SetFont(Amr.CreateFont("Bold", 16, Amr.Colors.White))
	btnReload:SetWidth(200)
	btnReload:SetHeight(26)
	btnReload:SetCallback("OnClick", ReloadUI)
	btnReload:SetPoint("TOPLEFT", _btnToggle.frame, "TOPRIGHT", 40, 0)
	
	-- auto-logging controls
	local lbl = AceGUI:Create("AmrUiLabel")
	container:AddChild(lbl)
	lbl:SetWidth(600)
	lbl:SetText(L.LogAutoTitle)
	lbl:SetFont(Amr.CreateFont("Bold", 24, Amr.Colors.TextHeaderActive))
	lbl:SetPoint("TOPLEFT", _btnToggle.frame, "BOTTOMLEFT", 0, -40)
	
	_chkAutoAll = AceGUI:Create("AmrUiCheckBox")
	container:AddChild(_chkAutoAll)
	_chkAutoAll:SetText(L.LogAutoAllText)
	_chkAutoAll:SetCallback("OnClick", function(widget) Amr:ToggleAllAutoLog() end)
	_chkAutoAll:SetPoint("TOPLEFT", lbl.frame, "BOTTOMLEFT", 1, -15)
	
	_autoChecks = {}
	
	-- go through all supported instances, rendering in a left->right pattern, 2 per row
	local autoLbls = {}
	local autoChks = {}
	for i, instanceId in ipairs(Amr.InstanceIdsOrdered) do
		local autoLbl, autoChk = renderAutoLogSection(instanceId, container, i, autoLbls, autoChks)		
		
		table.insert(autoLbls, autoLbl)
		table.insert(autoChks, autoChk)
	end
	autoLbls = nil
	autoChks = nil
	
	-- initialize state of controls
	Amr:RefreshLogUi()
end

function Amr:ReleaseTabLog()
	_lblLogging = nil
	_btnToggle = nil
	_panelUndoWipe = nil
	_chkAutoAll = nil
	_autoChecks = nil
end

-- update the game's logging state
local function updateGameLogging(enabled)
	if enabled then
		-- always enable advanced combat logging via our addon, gathers more detailed data for better analysis
		SetCVar("advancedCombatLogging", 1)
		LoggingCombat(true)
	else
		LoggingCombat(false)
	end
end

local function isAnyAutoLoggingEnabled()
	local anyChecked = false
	for i, instanceId in ipairs(Amr.InstanceIdsOrdered) do
		for j, difficultyId in ipairs(Amr.InstanceDifficulties[instanceId]) do
			if Amr.db.profile.Logging.Auto[instanceId][difficultyId] then
				anyChecked = true
				break
			end
		end
		if anyChecked then break end
	end
	
	return anyChecked
end

local function isAllAutoLoggingEnabled()
	-- see if all auto-logging options are enabled
	local allChecked = true
	for i, instanceId in ipairs(Amr.InstanceIdsOrdered) do
		for j, difficultyId in ipairs(Amr.InstanceDifficulties[instanceId]) do
			if not Amr.db.profile.Logging.Auto[instanceId][difficultyId] then
				allChecked = false
				break
			end
		end
		if not allChecked then break end
	end
	
	return allChecked
end

-- check current zone and auto-logging settings, and enable logging if appropriate
local function updateAutoLogging(force, noWait)
	
	local hasAuto = isAnyAutoLoggingEnabled()
	
	-- before doing anything, make sure logging matches the user's current setting, deals with any inconsistency due to a crash or disconnect
	if hasAuto then
		updateGameLogging(Amr:IsLogging())
	end
	
	-- get the info about the instance
	local zone, _, difficultyId, _, _, _, _, instanceId = GetInstanceInfo()

	-- always use difficulty 1 for classic
	difficultyId = 1

	if Amr.IsSupportedInstanceId(instanceId) and difficultyId == 0 and not noWait then
		-- the game is sometimes returning no difficulty id for raid zones... not sure why, wait 10 seconds and check again
		Amr.Wait(10, function()
			updateAutoLogging(false, false)
		end)
		return
	end
	
	if not force and zone == Amr.db.char.Logging.LastZone and difficultyId == Amr.db.char.Logging.LastDiff then
	  -- do nothing if the zone hasn't actually changed, otherwise we may override the user's manual enable/disable
		return
	end

	Amr.db.char.Logging.LastZone = zone
	Amr.db.char.Logging.LastDiff = difficultyId

	if Amr.IsSupportedInstanceId(instanceId) then
		if not Amr.db.profile.Logging.Auto[tonumber(instanceId)] then
			Amr.db.profile.Logging.Auto[tonumber(instanceId)] = {}
		end
	end
	
	if Amr.IsSupportedInstanceId(instanceId) and Amr.db.profile.Logging.Auto[tonumber(instanceId)][tonumber(difficultyId)] then
		-- we are in a supported zone that we want to auto-log, turn logging on 
		
		-- (supported check is probably redundant, but just in case someone has old settings lying around)
		if not Amr:IsLogging() then
			Amr:StartLogging()
		end
	elseif hasAuto then
		-- not in a zone that we want to auto-log, turn logging off
		if Amr:IsLogging() then
			Amr:StopLogging()
		end
	end
end

-- refresh the state of the tab based on current settings
function Amr:RefreshLogUi()
	if not _btnToggle or Amr:GetActiveUiTab() ~= "Log" then return end
	
	-- set state of logging button based on whether it is on or off
	if self:IsLogging() then
		_btnToggle:SetBackgroundColor(Amr.Colors.Red)
		_btnToggle:SetText(L.LogButtonStopText)
	else
		_btnToggle:SetBackgroundColor(Amr.Colors.Green)
		_btnToggle:SetText(L.LogButtonStartText)
	end
	
	_lblLogging:SetVisible(self:IsLogging())
	
	-- hide/show undo wipe button based on whether a wipe has been called recently
	if _panelUndoWipe then
		_panelUndoWipe:SetVisible(Amr.db.char.Logging.LastWipe and true or false)
	end
	
	for i, instanceId in ipairs(Amr.InstanceIdsOrdered) do
		if not Amr.db.profile.Logging.Auto[instanceId] then
			Amr.db.profile.Logging.Auto[instanceId] = {}
		end
		for j, difficultyId in ipairs(Amr.InstanceDifficulties[instanceId]) do
			_autoChecks[instanceId][difficultyId]:SetChecked(Amr.db.profile.Logging.Auto[instanceId][difficultyId])
		end
	end

	-- no fuckin idea why... but waiting to set the state of the all checkbox avoids some ui rendering issues
	Amr.Wait(0.1, function()
		local all = isAllAutoLoggingEnabled()
		_chkAutoAll:SetChecked(all)
	end)
end

function Amr:IsLogging()
	return Amr.db.char.Logging.Enabled
end

function Amr:ToggleLogging()
	if not Amr.db.char.Logging.Enabled then
		Amr:StartLogging()
	else
		Amr:StopLogging()
	end
end

function Amr:StartLogging()	
	
	-- enable game log file
	updateGameLogging(true)
	Amr.db.char.Logging.Enabled = true
	
	self:Print(L.LogChatStart)
	
	self:UpdateMinimap()
	self:RefreshLogUi()
end

function Amr:StopLogging()
	
	updateGameLogging(false)
	Amr.db.char.Logging.Enabled = false
	
	self:Print(L.LogChatStop)
	
	self:UpdateMinimap()
	self:RefreshLogUi()
end

function Amr:ToggleAutoLog(instanceId, difficultyId)

	local byDiff = Amr.db.profile.Logging.Auto[instanceId]	
	byDiff[difficultyId] = not byDiff[difficultyId]
	
	self:RefreshLogUi()
	
	-- see if we should turn logging on right now	
	updateAutoLogging(true)
end

function Amr:ToggleAllAutoLog()
	
	local val = not isAllAutoLoggingEnabled()
	
	for i, instanceId in ipairs(Amr.InstanceIdsOrdered) do
		for j, difficultyId in ipairs(Amr.InstanceDifficulties[instanceId]) do
			Amr.db.profile.Logging.Auto[instanceId][difficultyId] = val
		end
	end
	
	self:RefreshLogUi()
	
	-- see if we should turn logging on right now	
	updateAutoLogging(true)
end

function Amr:InitializeCombatLog()
	updateAutoLogging()
end

Amr:AddEventHandler("UPDATE_INSTANCE_INFO", updateAutoLogging)
Amr:AddEventHandler("ENCOUNTER_START", updateAutoLogging)
