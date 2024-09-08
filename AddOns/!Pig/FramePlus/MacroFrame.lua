local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
-------------
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local FramePlusfun=addonTable.FramePlusfun
FramePlusfun.pigMacroyijiazai = nil
function FramePlusfun.Macro()
	if not PIGA["FramePlus"]["Macro"] then return end
	if FramePlusfun.pigMacroyijiazai then return end
	local function SETMacroFrame()
		FramePlusfun.pigMacroyijiazai=true
		local WWW = MacroFrame:GetWidth()
		MacroFrame:SetWidth(WWW*2);
		MacroFrame.MacroSelector:SetHeight(326)
		MacroFrameSelectedMacroBackground:ClearAllPoints();
		MacroFrameSelectedMacroBackground:SetPoint("TOPLEFT",MacroFrame,"TOPLEFT",WWW,-60);
		MacroFrameTextBackground:ClearAllPoints();
		MacroFrameTextBackground:SetPoint("TOPLEFT",MacroFrame,"TOPLEFT",WWW,-132);
		MacroFrameTextBackground:SetHeight(250)
		MacroFrameScrollFrame:SetHeight(242)
		MacroFrameCharLimitText:ClearAllPoints();
		MacroFrameCharLimitText:SetPoint("TOP",MacroFrameTextBackground,"BOTTOM",0,0);
		MacroHorizontalBarLeft:ClearAllPoints();
	end
	if IsAddOnLoaded("Blizzard_MacroUI") then
		SETMacroFrame()
    else
        local shequFRAME = CreateFrame("FRAME")
        shequFRAME:RegisterEvent("ADDON_LOADED")
        shequFRAME:SetScript("OnEvent", function(self, event, arg1)
        	if arg1=="Blizzard_MacroUI" then
        		SETMacroFrame()
				shequFRAME:UnregisterEvent("ADDON_LOADED")
			end
        end)
    end
end