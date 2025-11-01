local _, addonTable = ...;
-------------
local FramePlusfun=addonTable.FramePlusfun
FramePlusfun.pigMacroyijiazai = nil
function FramePlusfun.Macro()
	if not PIGA["FramePlus"]["Macro"] then return end
	if FramePlusfun.pigMacroyijiazai then return end
	local Fun=addonTable.Fun
	local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
	local function SETMacroFrame()
		FramePlusfun.pigMacroyijiazai=true
		--MacroFrame.MacroSelector:SetCustomStride(10);
		MacroFrame.MacroSelector.customStride=nil
		MacroFrame.MacroSelector.ScrollBar:Hide()
		
		local WWW = MacroFrame:GetWidth()
		local HHH = MacroFrame:GetHeight()
		local NewWWW = WWW*2.4
		MacroFrame:SetWidth(NewWWW);
		if PIG_OptionsUI.IsOpen_ElvUI() then
			C_Timer.After(0.1,function()
				MacroFrame:SetWidth(NewWWW);
			end)
		end
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
		hooksecurefunc(MacroPopupFrame, "OkayButton_OnClick", function(self)
			if InCombatLockdown() then return end
			local macroFrame = self:GetMacroFrame();
			local NewName= self.BorderBox.IconSelectorEditBox:GetText();
			C_Timer.After(0.02,function()
				local macroSlotIndex=0
				local AccMacros, CharMacros = GetNumMacros();
				local SelectedTab = PanelTemplates_GetSelectedTab(MacroFrame)
				if SelectedTab==1 then
					for Index=1,MAX_ACCOUNT_MACROS do
						local Name, Icon, Body = GetMacroInfo(Index);
						if Name then
							if NewName == Name and Body =="" then
								macroSlotIndex=Index
								break
							end
						end
					end
				else
					for Index=MAX_ACCOUNT_MACROS+1,MAX_ACCOUNT_MACROS+CharMacros do
						local Name, Icon, Body = GetMacroInfo(Index);
						if Name then
							if NewName == Name and Body =="" then
								macroSlotIndex=Index-MAX_ACCOUNT_MACROS
								break
							end
						end
					end
				end
				if macroSlotIndex>0 then
					macroFrame:SelectMacro(macroSlotIndex);
					macroFrame:Update(retainScrollPosition);
				end
			end)			
		end)
	end
	Fun.IsAddOnLoaded("Blizzard_MacroUI",function()
        SETMacroFrame()
	end)
end