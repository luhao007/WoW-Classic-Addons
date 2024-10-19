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
		--MacroFrame.MacroSelector:SetCustomStride(10);
		MacroFrame.MacroSelector.customStride=nil
		MacroFrame.MacroSelector.ScrollBar:Hide()
		
		local WWW = MacroFrame:GetWidth()
		local HHH = MacroFrame:GetHeight()
		local NewWWW = WWW*2.4
		MacroFrame:SetWidth(NewWWW);
		local NewHHH = HHH*1.63
		MacroFrame:SetHeight(NewHHH);
		
		MacroFrame.MacroSelector:SetWidth(WWW*1.51)--按钮box
		MacroFrame.MacroSelector:SetHeight(NewHHH*0.85)--按钮box

		MacroFrameSelectedMacroBackground:ClearAllPoints();
		MacroFrameSelectedMacroBackground:SetPoint("TOPLEFT",MacroFrame,"TOPLEFT",WWW*1.50,-60);

		MacroSaveButton:ClearAllPoints();
		MacroSaveButton:SetPoint("TOPLEFT",MacroFrameSelectedMacroBackground,"BOTTOMLEFT",8,-10);
		MacroCancelButton:ClearAllPoints();
		MacroCancelButton:SetPoint("LEFT",MacroSaveButton,"RIGHT",18,0);
		MacroDeleteButton:ClearAllPoints();
		MacroDeleteButton:SetPoint("LEFT",MacroCancelButton,"RIGHT",18,0);

		MacroFrameEnterMacroText:SetPoint("TOPLEFT",MacroFrameSelectedMacroBackground,"BOTTOMLEFT",8,-60)
		MacroFrameScrollFrame:SetPoint("TOPLEFT",MacroFrameSelectedMacroBackground,"BOTTOMLEFT",11,-86)
		MacroFrameScrollFrame:SetSize(274,NewHHH*0.58)--字符box
		MacroFrameText:SetWidth(274)
		MacroFrameScrollFrame.ScrollBar:Hide()
		MacroFrameTextBackground:ClearAllPoints();
		MacroFrameTextBackground:SetPoint("TOPLEFT",MacroFrameScrollFrame,"TOPLEFT",-8,8);
		MacroFrameTextBackground:SetPoint("BOTTOMRIGHT",MacroFrameScrollFrame,"BOTTOMRIGHT",8,-8);
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