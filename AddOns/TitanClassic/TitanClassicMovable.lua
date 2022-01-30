--[[ File
NAME: TitanMovable.lua
DESC: Contains the routines to adjust the Blizzard frames to make room for the Titan bars the user has selected.
There are a select set of Blizzard frames at the top of screen and at the bottom of the screen that Titan will move.
Each frame adjusted has an entry in MData which is local and not directly accessible via addons.
However addons can tell Titan to not adjust some or all frames using TitanUtils_AddonAdjust(frame, bool). 
Addons that replace all or parts of the Blizzard UI use this.

The user can turn turn on / off the adjusting of all top frames or all bottom frames.
:DESC
NOTE:
- Blizzard changed the way the main menu bar was handled in 8.0. The change was mainly on how the bar was
handled going in and out of combat.
This caused no end of grief to Titan which needs to move it properly adjust for Titan bottom bars.
With Classic this has been reverted so the code can be removed. SetUserPlaced & SetMovable
:NOTE
--]]
-- Globals

-- Locals
local _G = getfenv(0);
local InCombatLockdown = _G.InCombatLockdown;
local hooks_done = false;

local move_count = 0
--[[ Titan
Declare the Ace routines
 local AceTimer = LibStub("AceTimer-3.0")
 i.e. TitanPanelAce.ScheduleTimer("LDBToTitanSetText", TitanLDBRefreshButton, 2);
 or
 i.e. TitanPanelAce:ScheduleTimer(TitanLDBRefreshButton, 2);

 Be careful that the 'self' is proper to cancel timers!!!
--]]
local TitanPanelAce = LibStub("AceAddon-3.0"):NewAddon("TitanPanel", "AceHook-3.0", "AceTimer-3.0")

--Determines the optimal magic number based on resolution
--local menuBarTop = 55;
--local width, height = string.match((({GetScreenResolutions()})[GetCurrentResolution()] or ""), "(%d+).-(%d+)");
--if ( tonumber(width) / tonumber(height ) > 4/3 ) then
	--Widescreen resolution
--	menuBarTop = 75;
--end

--[[From Resike to prevent tainting stuff to override the SetPoint calls securely.
hooksecurefunc(FrameRef, "SetPoint", function(self)
	if self.moving then
		return
	end
	self.moving = true
	self:SetMovable(true)
	self:SetUserPlaced(true)
	self:ClearAllPoints()
	self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	self:SetMovable(false)
	self.moving = nil
end)
--]]

--[[ local
NAME: DoAdjust
DESC: See if Titan should adjust based only on its own flags.
VAR: place   - top or bottom
OUT: boolean - true to adjust, false if not
--]]
local function DoAdjust(place, force)
	local res = false -- assume we will not adjust
	-- force is passed to cover cases where the user has just deselected both top or bottom bars
	-- When that happens we need to adjust
	
	-- We did it to ourselves - if (Aux)ScreenAdjust is true it means the user wants Titan to NOT adjust...
	if place == TITAN_PANEL_PLACE_TOP then
		if TitanPanelGetVar("ScreenAdjust") == 1 then
			-- do not adjust
		else
			if force then
				res = true
			elseif TitanPanelGetVar("Bar_Show") or TitanPanelGetVar("Bar2_Show") then
				res = true
			end
		end
	elseif place == TITAN_PANEL_PLACE_BOTTOM then
		if TitanPanelGetVar("AuxScreenAdjust") == 1 then
			-- do not adjust
		else
			if force then
				res = true
			elseif TitanPanelGetVar("AuxBar_Show") or TitanPanelGetVar("AuxBar2_Show") then
				res = true
			end
		end
	end
	return res
end

--[[ Titan
NAME: TitanMovable_MenuBar_Disable
DESC: Handle the main menu bar so Blizzard does not get upset.
VAR: None
OUT: None
NOTE:
- Reverted from 8.0 changes
:NOTE
--]]
function TitanMovable_MenuBar_Disable()
	if DoAdjust(TITAN_PANEL_PLACE_BOTTOM, false) then
--TitanPrint("TitanMovable_MenuBar_Disable - DoAdjust", "warning")
		MainMenuBar:SetMovable(true);
--		MainMenuBar:SetUserPlaced(false);
	end
end

--[[ Titan
NAME: TitanMovable_MenuBar_Enable
DESC: Handle the main menu bar so Blizzard does not get upset.
VAR: None
OUT: None
NOTE:
- Reverted from 8.0 changes
- This is called for the various events Titan handles that do / may hide the main menu bar
- IF TitanMovable_MenuBar_Disable was called, this must be called before having Titan adjust frames. The 'is user placed' is required to work around a Blizzard 'feature' that adjusts the main menu bar while in combat.
:NOTE
--]]
function TitanMovable_MenuBar_Enable()
	if InCombatLockdown() then
		-- wait until out of combat...
		-- if player is in vehicle ...
	else
		if DoAdjust(TITAN_PANEL_PLACE_BOTTOM, false) then
			MainMenuBar:SetMovable(true);
			MainMenuBar:SetUserPlaced(true);
			MainMenuBar:SetMovable(false);
		end
	end
end

--[[ API
NAME: TitanMovable_GetPanelYOffset
DESC: Get the Y axis offset Titan needs (1 or 2 bars) at the given position - top or bottom.
VAR: framePosition - TITAN_PANEL_PLACE_TOP or TITAN_PANEL_PLACE_BOTTOM
OUT: Y axis offset, in pixels
NOTE:
- The preferred method to determine the Y offset needed by using TitanUtils_GetBarAnchors().
:NOTE
--]]
function TitanMovable_GetPanelYOffset(framePosition) -- used by other addons
-- TitanPanelTopAnchor, TitanPanelBottomAnchor


	-- Both top & bottom are figured out but only the
	-- requested position is returned
	local barnum_top = 0
	local barnum_bot = 0
	-- If user has the top adjust set then determine the
	-- top offset
	if not TitanPanelGetVar("ScreenAdjust") then
		if TitanPanelGetVar("Bar_Show") then
			barnum_top = 1
		end
		if TitanPanelGetVar("Bar2_Show") then
			barnum_top = 2
		end
	end
	-- If user has the top adjust set then determine the
	-- bottom offset
	if not TitanPanelGetVar("AuxScreenAdjust") then
		if TitanPanelGetVar("AuxBar_Show") then
			barnum_bot = 1
		end
		if TitanPanelGetVar("AuxBar2_Show") then
			barnum_bot = 2
		end
	end
	local scale = TitanPanelGetVar("Scale")
	-- return the requested offset
	-- 0 will be returned if the user has no bars showing
	-- or the scale is not valid
	if scale and framePosition then
		if framePosition == TITAN_PANEL_PLACE_TOP then
			return (-TITAN_PANEL_BAR_HEIGHT * scale)*(barnum_top);
		elseif framePosition == TITAN_PANEL_PLACE_BOTTOM then
			return (TITAN_PANEL_BAR_HEIGHT * scale)*(barnum_bot)-1; 
			-- no idea why -1 is needed... seems anchoring to bottom is off a pixel
		end
	end
	return 0
end

--[[ local
NAME: TitanMovableFrame_GetXOffset
DESC: Get the x axis offset Titan needs to adjust the given frame.
VAR: frame - frame object
VAR: point - "LEFT" / "RIGHT" / "TOP" / "BOTTOM" / "CENTER"
OUT: int - X axis offset, in pixels
--]]
local function TitanMovableFrame_GetXOffset(frame, point)
	-- A valid frame and point is required
	-- Determine a proper X offset using the given point (position)
	local ret = 0 -- In case the inputs were invalid or the point was not relevant to the frame then return 0
	if frame and point then
		if point == "LEFT" and frame:GetLeft() and UIParent:GetLeft() then
			ret = frame:GetLeft() - UIParent:GetLeft();
		elseif point == "RIGHT" and frame:GetRight() and UIParent:GetRight() then
			ret = frame:GetRight() - UIParent:GetRight();			
		elseif point == "TOP" and frame:GetTop() and UIParent:GetTop() then
			ret = frame:GetTop() - UIParent:GetTop();
		elseif point == "BOTTOM" and frame:GetBottom() and UIParent:GetBottom() then
			ret = frame:GetBottom() - UIParent:GetBottom();
		elseif point == "CENTER" and frame:GetLeft() and frame:GetRight() 
				and UIParent:GetLeft() and UIParent:GetRight() then
			local framescale = frame.GetScale and frame:GetScale() or 1;
			ret = (frame:GetLeft()* framescale + frame:GetRight()
				* framescale - UIParent:GetLeft() - UIParent:GetRight()) / 2;
		end
	end

	return ret
end

--[[ local
NAME: SetPosition
DESC: Adjust a given frame with the passed in values.
VAR: frame - Text string of the frame name
VAR: ... - list of frame position info
NOTE: 
- Swiped from Vrul on wowinterface forum

- The table UIPARENT_MANAGED_FRAME_POSITIONS does not hold all Blizzard frames.
It is cleared for each frame in case the frame is in or might be in the table in the future.

- Titan does not control the frames as other addons so we honor a user placed frame
:NOTE
--]]
local function SetPosition(frame, ...)
    if type(frame) == 'string' then
        UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
        frame = _G[frame]
    end
    if type(frame) == 'table' and type(frame.IsObjectType) == 'function' and frame:IsObjectType('Frame') then
        local name = frame:GetName()
        if name then
            UIPARENT_MANAGED_FRAME_POSITIONS[name] = nil
        end
		-- Titan honors a user placed frame
        frame:SetDontSavePosition(true) 
        frame:SetAttribute('ignoreFramePositionManager', true)
        frame.ignoreFramePositionManager = true
        if ... then
            frame:ClearAllPoints()
            frame:SetPoint(...)
        end
    end
end

--[[ local
NAME: CheckConflicts
DESC: Check for other addons that control UI elements. Tell Titan to back off the frames the addon controls or can control.
VAR: <none>
NOTE: 
- This is messy routine because the internals of each addon must be known to check for the frames that are controlled.
- Some addons use different names where Titan uses the Blizzard frame names
:NOTE
--]]
local function CheckConflicts()
	local addon = "Bartender4"
--[[ 
-- Below is sample code. The ideal would be tell the user to disable the 
-- Titan bottom bar adjust...
	if (IsAddOnLoaded(addon)) then -- user has enabled
		-- Check would be : BT4Bar<BT bar name>.config.enabled to check if the frame exists and if it is enabled in BT4
		TitanMovable_AddonAdjust("MainMenuBar", true)
		TitanMovable_AddonAdjust("MicroButtonAndBagsBar", true)
		TitanMovable_AddonAdjust("MultiBarRight", true)
		TitanMovable_AddonAdjust("ExtraActionBarFrame", true)
		TitanMovable_AddonAdjust("OverrideActionBar", true) -- not sure about this one...
    end
--]]
end

--[[ local
NAME: MoveFrame
DESC: Adjust the given frame. Expected are frames where :GetPoint works
VAR: frame_ptr - Text string of the frame name
VAR: start_y - Any offset due to the specific frame
OUT: top_bottom - Frame is at top or bottom, expecting Titan constant for top or bottom
--]]
local function MoveFrame(frame_ptr, start_y, top_bottom, force)
	local frame = _G[frame_ptr]

	if frame then -- ensure a valid frame
		if frame:IsUserPlaced() then -- user (or another addon) may have placed this frame
		else
			if DoAdjust(top_bottom, force) and frame:IsShown() then
				local y = TitanMovable_GetPanelYOffset(top_bottom) + (start_y or 0) -- includes scale adjustment
				local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
				-- check for nil which will cause an error
				if point and relativeTo and relativePoint and xOfs then -- do not care about yOfs
					SetPosition(frame, point, relativeTo:GetName(), relativePoint, xOfs, y)
				else
					-- do not proceed
				end
			else
				--[[
				Some frames such as the ticket frame may not be visible or even created
				--]]
		end
		end
	else
		-- Should note get here...
--[[
		TitanDebug ("MoveFrame nil found :"
			.." "..tostring(frame_ptr)
			)
--]]
	end
end

--[[ local
NAME: MoveMenuFrame
DESC: Adjust the MainMenuBar frame. Needed because :GetPoint does NOT always work for MainMenuBar. 
This is modeled after MoveFrame to keep it similar.
Titan sets the IsUserPlaced for the MainMenuBar frame so Titan needs to adjust.
VAR: frame_ptr - Text string of the frame name
VAR: start_y - Any offset due to the specific frame
OUT: top_bottom - Frame is at top or bottom, expecting Titan constant for top or bottom
--]]
local function MoveMenuFrame(frame_ptr, start_y, top_bottom, force)
	local frame = _G[frame_ptr]
	local adj = false
	if frame and DoAdjust(top_bottom, force)
	then
		local yOffset = TitanMovable_GetPanelYOffset(top_bottom) -- includes scale adjustment
		xOfs = TitanPanelGetVar("MainMenuBarXAdj")

		SetPosition(frame, "BOTTOM", "UIParent", "BOTTOM", xOfs, yOffset)
		adj = true
	else
		-- Unknown frame...
	end
end

--[[ Titan
NAME: Titan_FCF_UpdateDockPosition
DESC: Secure post hook to help adjust the chat / log frame.
VAR:  None
OUT:  None
NOTE:
- This is required because Blizz adjusts the chat frame relative to other frames so some of the Blizz code is copied.
- If in combat or if the user has moved the chat frame then no action is taken.
- The frame is adjusted in the Y axis only.
:NOTE
--]]
local function Titan_FCF_UpdateDockPosition()
	if not Titan__InitializedPEW
	or not TitanPanelGetVar("LogAdjust") 
	or TitanPanelGetVar("AuxScreenAdjust") then 
		return 
	end
	
	if not InCombatLockdown() or (InCombatLockdown() 
	and not _G["DEFAULT_CHAT_FRAME"]:IsProtected()) then
		local panelYOffset = TitanMovable_GetPanelYOffset(TITAN_PANEL_PLACE_BOTTOM);
		local scale = TitanPanelGetVar("Scale");
		if scale then
			panelYOffset = panelYOffset + (24 * scale) -- after 3.3.5 an additional adjust was needed. why? idk
		end

--[[ Blizz code
		if _G["DEFAULT_CHAT_FRAME"]:IsUserPlaced() then
			if _G["SIMPLE_CHAT"] ~= "1" then return end
		end
		
		local chatOffset = 85 + panelYOffset;
		if GetNumShapeshiftForms() > 0 or HasPetUI() or PetHasActionBar() then
			if MultiBarBottomLeft:IsVisible() then
				chatOffset = chatOffset + 55;
			else
				chatOffset = chatOffset + 15;
			end
		elseif MultiBarBottomLeft:IsVisible() then
			chatOffset = chatOffset + 15;
		end
		_G["DEFAULT_CHAT_FRAME"]:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, chatOffset);
		FCF_DockUpdate();
--]]
		if ( DEFAULT_CHAT_FRAME:IsUserPlaced() ) then
			return;
		end
		
		local chatOffset = 85 + panelYOffset; -- Titan change to adjust Y offset
		if ( GetNumShapeshiftForms() > 0 or HasPetUI() or PetHasActionBar() ) then
			if ( MultiBarBottomLeft:IsShown() ) then
				chatOffset = chatOffset + 55;
			else
				chatOffset = chatOffset + 15;
			end
		elseif ( MultiBarBottomLeft:IsShown() ) then
			chatOffset = chatOffset + 15;
		end
		DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 
			32, chatOffset);
		FCF_DockUpdate();
	end
end

--[[ Titan
NAME: Titan_ContainerFrames_Relocate
DESC: Secure post hook to help adjust the bag frames.
VAR:  None
OUT:  None
NOTE:
- The frame is adjusted in the Y axis only.
- The Blizz routine "ContainerFrames_Relocate" should be examined for any conditions it checks and any changes to the SetPoint.
If Blizz changes the anchor points the SetPoint here must change as well!!
The Blizz routine calculates X & Y offsets to UIParent (screen) so there is not need to store the prior offsets.
Like the Blizz routine we search through the visible bags. Unlike the Blizz routine we only care about the first of each column to adjust for Titan.
This way the Blizz code does not need to be copied here.
:NOTE
--]]
local function Titan_ContainerFrames_Relocate()
	if not TitanPanelGetVar("BagAdjust") then 
		return 
	end

	local panelYOffset = TitanMovable_GetPanelYOffset(TITAN_PANEL_PLACE_BOTTOM)
	local off_y = 10000 -- something ridiculously high
	local bottom_y = 0
	local right_x = 0

	for index, frameName in ipairs(ContainerFrame1.bags) do
		frame = _G[frameName];
		if frame:GetBottom() then bottom_y = frame:GetBottom() end
		if ( bottom_y < off_y ) then
			-- Start a new column
			right_x = frame:GetRight()
			frame:ClearAllPoints();		
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), 
				"BOTTOMLEFT", -- changed because we are taking the current x value
				right_x, -- x is not adjusted
				bottom_y + panelYOffset -- y
			)
		end
		off_y = bottom_y
	end
end

local function has_pet_bar()
	local hasPetBar = false
	if ( ( PetActionBarFrame and PetActionBarFrame:IsShown() ) or ( StanceBarFrame and StanceBarFrame:IsShown() ) or
		 ( MultiCastActionBarFrame and MultiCastActionBarFrame:IsShown() ) or ( PossessBarFrame and PossessBarFrame:IsShown() ) or
		 ( MainMenuBarVehicleLeaveButton and MainMenuBarVehicleLeaveButton:IsShown() ) ) then
		hasPetBar = true;
	end
	return hasPetBar
end

--[[ local
NAME: MData table
DESC: MData is a local table that holds each frame Titan may need to adjust. It controls the offsets needed to make room for the Titan bar(s).
Each frame can be adjusted by modifying its 'move' function.
The index is the frame name. Each record contains:
frameName - frame name (string) to adjust
addonAdj - true if another addon is taking responsibility of adjusting this frame, if false Titan will use the user settings to adjust or not
:DESC
NOTE:
- Of course Blizzard had to make the MainMenuBar act differently <sigh>. :GetPoint() does not work on it so a special helper routine was needed.
:NOTE
--]]
local MData = {
	[1] = {frameName = "PlayerFrame", 
		move = function (force) MoveFrame("PlayerFrame", 0, TITAN_PANEL_PLACE_TOP, force) end, 
		addonAdj = false, },
	[2] = {frameName = "TargetFrame", 
		move = function (force) MoveFrame("TargetFrame", 0, TITAN_PANEL_PLACE_TOP, force) end, 
		addonAdj = false, },
	[3] = {frameName = "PartyMemberFrame1", 
		move = function (force) MoveFrame("PartyMemberFrame1", 0, TITAN_PANEL_PLACE_TOP, force) end, 
		addonAdj = false, },
	[4] = {frameName = "TicketStatusFrame", 
		move = function (force) MoveFrame("TicketStatusFrame", 0, TITAN_PANEL_PLACE_TOP, force) end, 
		addonAdj = false, },
	[5] = {frameName = "BuffFrame", 
		move = function (force) 
			-- properly adjust buff frame(s) if GM Ticket is visible

			-- Use IsShown rather than IsVisible. In some cases (after closing
			-- full screen map) the ticket may not yet be visible.
			local yOffset = 0
			if TicketStatusFrame:IsShown()
			and TitanPanelGetVar("TicketAdjust") 
			then
				yOffset = (-TicketStatusFrame:GetHeight())
			else
				yOffset = TitanPanelGetVar("BuffIconVerticalAdj")  --  -13
			end
			MoveFrame("BuffFrame", yOffset, TITAN_PANEL_PLACE_TOP, force) end, 
		addonAdj = false, },
	[6] = {frameName = "MinimapCluster", 
		move = function (force) 
			local yOffset = 0
			if MinimapBorderTop 
			and not MinimapBorderTop:IsShown() then
				yOffset = yOffset + (MinimapBorderTop:GetHeight() * 3/5) - 5
			end
			MoveFrame("MinimapCluster", yOffset, TITAN_PANEL_PLACE_TOP, force) end, 
		addonAdj = false, },
	[7] = {frameName = "MultiBarRight", 
		move = function (force) 
			MoveFrame("MultiBarRight", 0, TITAN_PANEL_PLACE_BOTTOM, force) end, 
		addonAdj = false, },
	[8] = {frameName = "OverrideActionBar", 
		move = function (force) MoveFrame("OverrideActionBar", 0, TITAN_PANEL_PLACE_BOTTOM, force) end, 
		addonAdj = false, },
	[9] = {frameName = "MicroButtonAndBagsBar", 
		move = function (force) MoveFrame("MicroButtonAndBagsBar", 0, TITAN_PANEL_PLACE_BOTTOM, force) end, 
		addonAdj = false, },
	[10] = {frameName = "MainMenuBar", -- MainMenuBar
		move = function (force) 
			MoveMenuFrame("MainMenuBar", 0, TITAN_PANEL_PLACE_BOTTOM, force) end, 
		addonAdj = false, },
	[11] = {frameName = "ExtraActionBarFrame",
		move = function (force)
			-- Only spend cycles if the frame is shown.
			if ExtraActionBarFrame
			and ExtraActionBarFrame:IsShown() then
				-- Need to calc Y because Y depends on what else is shown
				--[=[ UIParent
				Look at UIParent.lua for logic (UIParent_ManageFramePosition)
				--]=]
				local actionBarOffset = 45;
				local menuBarTop = 55;
				local overrideActionBarTop = 40;
				local petBattleTop = 60;
				
				local yOfs = 18 -- FramePositionDelegate:UIParentManageFramePositions
				if MainMenuBar and MainMenuBar:IsShown() then
					yOfs = yOfs + menuBarTop
				end
				if (MultiBarBottomLeft and MultiBarBottomLeft:IsShown())
				or (MultiBarBottomRight and MultiBarBottomRight:IsShown())
				then
					yOfs = yOfs + actionBarOffset
				end
				if (has_pet_bar())
				and (MultiBarBottomRight and MultiBarBottomRight:IsShown())
				then
					yOfs = yOfs + petBattleTop
				end
				MoveFrame("ExtraActionBarFrame", yOfs, TITAN_PANEL_PLACE_BOTTOM, force)
			end
			end,
		addonAdj = false, },
	[12] = {frameName = "UIWidgetTopCenterContainerFrame", 
		move = function (force) MoveFrame("UIWidgetTopCenterContainerFrame", 0, TITAN_PANEL_PLACE_TOP, force) end, 
		addonAdj = false, },
}

--[[ Titan
NAME: TitanMovable_AdjustTimer
DESC: Cancel then add the given timer. The timer must be in TitanTimers.
VAR: ttype - The timer type (string) as defined in TitanTimers
OUT:  None
--]]
function TitanMovable_AdjustTimer(ttype)
	local timer = TitanTimers[ttype]
	if timer then
		TitanPanelAce.CancelAllTimers(timer.obj)
		TitanPanelAce.ScheduleTimer(timer.obj, timer.callback, timer.delay)
	end
end

--[[ Titan
NAME: TitanMovable_AddonAdjust
DESC: Set the given frame to be adjusted or not by another addon. This is called from TitanUtils for a developer API.
VAR: frame - frame name (string)
VAR: bool - true (addon will adjust) or false (Titan will use its settings) 
OUT:  None
--]]
function TitanMovable_AddonAdjust(frame, bool)
	for i = 1,#MData,1 do
		local fData = MData[i]
		local fName = nil
		if fData then
			fName = fData.frameName;
		end

		if (frame == fName) then
			fData.addonAdj = bool
		end
	end
end

--[[ local
NAME: TitanMovableFrame_MoveFrames
DESC: Loop through MData calling each frame's 'move' function for each Titan controlled frame.
Then update the chat and open bag frames.
OUT: None
--]]
local function TitanMovableFrame_MoveFrames(force)
	local move_count = 0 -- debug
	local str = "" -- debug
	--[[
	Setting the MainMenuBar as user placed is needed because in 8.0.0 Blizzard changed something in the 
	way they controlled the frame. With Titan panel and bottom bars enabled the MainMenuBar
	would 'bounce'. Figuring out the true root cause was a bust.
	This idea of user placed came from a Titan user who is an addon developer.
	However setting user placed causes the main menu bar to not act as we desire due to the way Blizzard coded the bar.
	For now we will try to minimize the side effects...
	
	Later Titan checks rely on the user placed flag so it needs to be set early.
	--]]
	if DoAdjust(TITAN_PANEL_PLACE_BOTTOM, force) then
		TitanMovable_MenuBar_Enable()
	end

	if not InCombatLockdown() then
		for i = 1,#MData,1 do
			if MData[i] then
				if MData[i].addonAdj then
					-- An addon has taken control of the frame so skip
				else
					-- Adjust the frame per MData
					MData[i].move(force)
--[[
					local ok, msg = pcall(function () MData[i].move() end)
					if ok then
						-- all is well
					else
						TitanPrint("Cannot Move"
							.." '"..(MData[i].frameName or "?").."."
							.." "..msg, "error")
					end
--]]
				end
			end
		end
		Titan_FCF_UpdateDockPosition(); -- chat
		UpdateContainerFrameAnchors(); -- Move bags as needed
	else
		-- nothing to do
	end
end

--[[ local
NAME: Titan_AdjustUIScale
DESC: Adjust the scale of Titan bars and plugins to the user selected scaling. This is called by the secure post hooks to the 'Video Options Frame'.
VAR:  None
OUT:  None
--]]
local function Titan_AdjustUIScale()	
	Titan_AdjustScale()
end

--[[ Titan
NAME: TitanPanel_AdjustFrames
DESC: Adjust the frames for the Titan visible bars.
This is a shell for the actual Movable routine used by other Titan routines and secure hooks
OUT:  None
NOTE:
:NOTE
--]]
function TitanPanel_AdjustFrames(force)
	-- force is passed to cover cases where Titan should always adjust
	-- such as when the user has just de/selected top or bottom bars
	local f = force or false -- do not require the parameter

	-- Adjust frame positions top and bottom based on user choices
	if hooks_done then
		TitanMovableFrame_MoveFrames(f)
	end
end

--[[ Titan
NAME: Titan_AdjustScale
DESC: Update the bars and plugins to the user selected scale.
VAR:  None
OUT:  None
NOTE:
- Ensure Titan has done its initialization before this is run.
:NOTE
--]]
function Titan_AdjustScale()
	-- Only adjust if Titan is fully initialized
	if Titan__InitializedPEW then 
		TitanPanel_SetScale();
		
		TitanPanel_ClearAllBarTextures()
		TitanPanel_CreateBarTextures()

		for idx,v in pairs (TitanBarData) do
			TitanPanel_SetTexture(TITAN_PANEL_DISPLAY_PREFIX..TitanBarData[idx].name
				, TITAN_PANEL_PLACE_TOP);
		end

		TitanMovableFrame_MoveFrames()
--		TitanPanelBarButton_DisplayBarsWanted()
		TitanPanel_RefreshPanelButtons();
	end
end

--[[ Titan
NAME: TitanMovable_SecureFrames
DESC: Once Titan is initialized create the post hooks we need to help adjust frames properly.
VAR:  None
OUT:  None
NOTE:
- The secure post hooks are required because Blizz adjusts frames Titan is interested in at times other than the events Titan registers for.
- This used to be inline code but was moved to a routine to avoid errors as Titan loaded.
:NOTE
--]]
function TitanMovable_SecureFrames()
	if not TitanPanelAce:IsHooked("FCF_UpdateDockPosition", Titan_FCF_UpdateDockPosition) then
		TitanPanelAce:SecureHook("FCF_UpdateDockPosition", Titan_FCF_UpdateDockPosition) -- FloatingChatFrame
	end
	if not TitanPanelAce:IsHooked("UIParent_ManageFramePositions", TitanPanel_AdjustFrames) then
		TitanPanelAce:SecureHook("UIParent_ManageFramePositions", TitanPanel_AdjustFrames) -- UIParent.lua
		TitanPanel_AdjustFrames()
	end

	if not TitanPanelAce:IsHooked(TicketStatusFrame, "Show", TitanPanel_AdjustFrames) then
		TitanPanelAce:SecureHook(TicketStatusFrame, "Show", TitanPanel_AdjustFrames) -- HelpFrame.xml
		TitanPanelAce:SecureHook(TicketStatusFrame, "Hide", TitanPanel_AdjustFrames) -- HelpFrame.xml
		TitanPanelAce:SecureHook("TargetFrame_Update", TitanPanel_AdjustFrames) -- TargetFrame.lua
--		TitanPanelAce:SecureHook(MainMenuBar, "Show", TitanPanel_AdjustFrames) -- HelpFrame.xml
--		TitanPanelAce:SecureHook(MainMenuBar, "Hide", TitanPanel_AdjustFrames) -- HelpFrame.xml
--		TitanPanelAce:SecureHook(OverrideActionBar, "Show", TitanPanel_AdjustFrames) -- HelpFrame.xml
--		TitanPanelAce:SecureHook(OverrideActionBar, "Hide", TitanPanel_AdjustFrames) -- HelpFrame.xml
		TitanPanelAce:SecureHook("UpdateContainerFrameAnchors", Titan_ContainerFrames_Relocate) -- ContainerFrame.lua
--		TitanPanelAce:SecureHook(WorldMapFrame.BorderFrame.MaximizeMinimizeFrame.MinimizeButton, "Show", TitanPanel_AdjustFrames) -- WorldMapFrame.lua
--		TitanPanelAce:SecureHook("OrderHall_CheckCommandBar", TitanPanel_AdjustFrames)
	end
		
	if not TitanPanelAce:IsHooked("VideoOptionsFrameOkay_OnClick", Titan_AdjustUIScale) then
		-- Properly Adjust UI Scale if set
		-- Note: These are the least intrusive hooks we could think of, to properly adjust the Titan Bar(s)
		-- without having to resort to a SetCvar secure hook. Any addon using SetCvar should make sure to use the 3rd
		-- argument in the API call and trigger the CVAR_UPDATE event with an appropriate argument so that other addons
		-- can detect this behavior and fire their own functions (where applicable).
		TitanPanelAce:SecureHook("VideoOptionsFrameOkay_OnClick", Titan_AdjustUIScale) -- VideoOptionsFrame.lua
		TitanPanelAce:SecureHook(VideoOptionsFrame, "Hide", Titan_AdjustUIScale) -- VideoOptionsFrame.xml
	end
	
	-- Check for other addons that control UI frames. 
	-- Tell Titan to back off of the frames these addons could control
	-- Look in this routine for any special code or directions
	CheckConflicts()
	
	hooks_done = true
end
function TitanMovable_Unhook_SecureFrames()
--[[
This is a debug attempt to fix an issue when a player is dumped from a vehicle while still in combat.
--]]
	TitanPanelAce:UnhookAll()
end
