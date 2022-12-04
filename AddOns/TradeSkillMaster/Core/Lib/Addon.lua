-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                          https://tradeskillmaster.com                          --
--    All Rights Reserved - Detailed license information included with addon.     --
-- ------------------------------------------------------------------------------ --

local ADDON_NAME = select(1, ...)
local TSM = select(2, ...) ---@type TSM
local Analytics = TSM.Include("Util.Analytics")
local Event = TSM.Include("Util.Event")
local Log = TSM.Include("Util.Log")
local LibTSMClass = TSM.Include("LibTSMClass")
local private = {
	eventFrames = {},
	initializeQueue = {},
	enableQueue = {},
	disableQueue = {},
	totalInitializeTime = 0,
	totalEnableTime = 0,
}
local TIME_WARNING_THRESHOLD_MS = 20
local MAX_TIME_PER_EVENT_MS = 12000
local NUM_EVENT_FRAMES = 10



-- ============================================================================
-- Event Handling
-- ============================================================================

function private.DoInitialize()
	local eventStartTime = debugprofilestop()
	while #private.initializeQueue > 0 and debugprofilestop() < (eventStartTime + MAX_TIME_PER_EVENT_MS) do
		local addon = tremove(private.initializeQueue, 1)
		if addon.OnInitialize then
			local addonStartTime = debugprofilestop()
			addon.OnInitialize()
			local addonTimeTaken = debugprofilestop() - addonStartTime
			if addonTimeTaken > TIME_WARNING_THRESHOLD_MS then
				Log.Warn("OnInitialize (%s) took %0.2fms", addon, addonTimeTaken)
			end
		end
		tinsert(private.enableQueue, addon)
	end
	if private.totalInitializeTime == 0 then
		for _, path, moduleLoadTime, settingsLoadTime in TSM.ModuleInfoIterator() do
			if moduleLoadTime > TIME_WARNING_THRESHOLD_MS then
				Log.Warn("Loading module %s took %0.2fms", path, moduleLoadTime)
			end
			if settingsLoadTime > TIME_WARNING_THRESHOLD_MS then
				Log.Warn("Loading settings for %s took %0.2fms", path, settingsLoadTime)
			end
		end
	end
	private.totalInitializeTime = private.totalInitializeTime + debugprofilestop() - eventStartTime
	return #private.initializeQueue == 0
end

function private.DoEnable()
	local eventStartTime = debugprofilestop()
	while #private.enableQueue > 0 and debugprofilestop() < (eventStartTime + MAX_TIME_PER_EVENT_MS) do
		local addon = tremove(private.enableQueue, 1)
		if addon.OnEnable then
			local addonStartTime = debugprofilestop()
			addon.OnEnable()
			local addonTimeTaken = debugprofilestop() - addonStartTime
			if addonTimeTaken > TIME_WARNING_THRESHOLD_MS then
				Log.Warn("OnEnable (%s) took %0.2fms", addon, addonTimeTaken)
			end
		end
		tinsert(private.disableQueue, addon)
	end
	if private.totalEnableTime == 0 then
		for _, path, _, _, gameDataLoadTime in TSM.ModuleInfoIterator() do
			if (gameDataLoadTime or 0) > TIME_WARNING_THRESHOLD_MS then
				Log.Warn("Loading game data for %s took %0.2fms", path, gameDataLoadTime)
			end
		end
	end
	private.totalEnableTime = private.totalEnableTime + debugprofilestop() - eventStartTime
	return #private.enableQueue == 0
end

function private.PlayerLogoutHandler()
	private.OnDisableHelper()
	wipe(private.disableQueue)
end

function private.OnDisableHelper()
	local disableStartTime = debugprofilestop()
	for _, addon in ipairs(private.disableQueue) do
		-- defer the main TSM.OnDisable() call to the very end
		if addon.OnDisable and addon ~= TSM then
			local startTime = debugprofilestop()
			addon.OnDisable()
			local timeTaken = debugprofilestop() - startTime
			if timeTaken > TIME_WARNING_THRESHOLD_MS then
				Log.Warn("OnDisable (%s) took %0.2fms", addon, timeTaken)
			end
		end
	end
	local totalDisableTime = debugprofilestop() - disableStartTime
	Analytics.Action("ADDON_DISABLE", floor(totalDisableTime))
	if TSM.OnDisable then
		TSM.OnDisable()
	end
end

do
	-- Blizzard did something silly in 8.1 where scripts time throw an error after 19 seconds, but nothing prevents us
	-- from just splitting the processing across multiple script handlers, so we do that here.
	local function EventHandler(self, event, arg)
		if event == "ADDON_LOADED" and arg == "TradeSkillMaster" then
			if private.DoInitialize() then
				-- we're done
				for _, frame in ipairs(private.eventFrames) do
					frame:UnregisterEvent(event)
				end
				Analytics.Action("ADDON_INITIALIZE", floor(private.totalInitializeTime))
			elseif self == private.eventFrames[#private.eventFrames] then
				error("Ran out of event frames to initialize TSM")
			end
		elseif event == "PLAYER_LOGIN" then
			if private.DoEnable() then
				-- we're done
				for _, frame in ipairs(private.eventFrames) do
					frame:UnregisterEvent(event)
				end
				Analytics.Action("ADDON_ENABLE", floor(private.totalEnableTime))
			elseif self == private.eventFrames[#private.eventFrames] then
				error("Ran out of event frames to enable TSM")
			end
		end
	end
	for _ = 1, NUM_EVENT_FRAMES do
		local frame = CreateFrame("Frame")
		frame:SetScript("OnEvent", EventHandler)
		frame:RegisterEvent("ADDON_LOADED")
		frame:RegisterEvent("PLAYER_LOGIN")
		tinsert(private.eventFrames, frame)
	end
	Event.Register("PLAYER_LOGOUT", private.PlayerLogoutHandler)
end



-- ============================================================================
-- AddonPackage Class
-- ============================================================================

local AddonPackage = LibTSMClass.DefineClass("AddonPackage")

function AddonPackage.__init(self, name)
	self.name = name
	tinsert(private.initializeQueue, self)
end

function AddonPackage.__tostring(self)
	return self.name
end

function AddonPackage.NewPackage(self, name)
	local package = AddonPackage(name)
	assert(not self[name])
	self[name] = package
	return package
end



-- ============================================================================
-- Addon Class
-- ============================================================================

local Addon = LibTSMClass.DefineClass("Addon", AddonPackage)

function Addon.__init(self, name)
	self.__super:__init(name)
end



-- ============================================================================
-- Initialization Code
-- ============================================================================

do
	LibTSMClass.ConstructWithTable(TSM, Addon, ADDON_NAME)
end



-- ============================================================================
-- Module Functions (Debug Only)
-- ============================================================================

function TSM.AddonTestLogout()
	private.OnDisableHelper()
	TSM.DebugLogout()
	for _, path, _, _, _, moduleUnloadTime in TSM.ModuleInfoIterator() do
		if moduleUnloadTime > TIME_WARNING_THRESHOLD_MS then
			Log.Warn("Unloading %s took %0.2fms", path, moduleUnloadTime)
		end
	end
end
