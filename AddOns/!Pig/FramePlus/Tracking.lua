local _, addonTable = ...;
local Create=addonTable.Create
local PIGDownMenu=Create.PIGDownMenu
--
local FramePlusfun=addonTable.FramePlusfun
-----------------------------------
function FramePlusfun.Tracking()
	if PIG_MaxTocversion(20000,true) then return end
	if not PIGA["FramePlus"]["Tracking"] then return end
	if FramePlusfun.TrackingOpen then return end
	FramePlusfun.TrackingOpen=true
	local Width,Height = 33,33;
	local MiniMapTrackingFrame = MiniMapTrackingFrame or MiniMapTracking
	MiniMapTracking.TrackingX = CreateFrame("Frame", nil, MiniMapTrackingFrame);
	local Tracking=MiniMapTrackingFrame.TrackingX
	Tracking:SetAllPoints(MiniMapTrackingFrame)
	Tracking.search = Tracking:CreateTexture(nil, "BORDER");
	Tracking.search:SetAtlas("None")
	Tracking.search:SetSize(Width*0.7,Height*0.7);
	if MiniMapTrackingFrame.noBorder then
		Tracking.search:SetPoint("CENTER",Tracking,"CENTER",0,0);
	else
		Tracking.search:SetPoint("CENTER",Tracking,"CENTER",2,-2);
	end
	Tracking.search:Hide()
	if NDui then
	else
		Tracking.Border = Tracking:CreateTexture(nil, "OVERLAY");
		Tracking.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
		Tracking.Border:SetPoint("TOPLEFT",Tracking,"TOPLEFT",0,0);
		Tracking.Border:Hide()
	end
	Tracking:RegisterEvent("PLAYER_ENTERING_WORLD");
	Tracking:RegisterEvent("MINIMAP_UPDATE_TRACKING");
	Tracking:HookScript("OnEvent", function(self,event,arg1)
		if event=="PLAYER_ENTERING_WORLD" then
			MiniMapTrackingFrame:Show()
			if ElvUI then
				Tracking.Border:SetAlpha(0)
				Tracking:SetSize(Width-6,Height-6);
				Tracking:ClearAllPoints();
				Tracking:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0);
			end
		elseif event=="MINIMAP_UPDATE_TRACKING" then
			MiniMapTrackingFrame:Show()
		end
		if GetTrackingTexture() then
			Tracking.search:Hide()
			MiniMapTrackingIcon:Show()
			MiniMapTrackingIcon:SetTexture(GetTrackingTexture())
			if not MiniMapTrackingFrame.noBorder and Tracking.Border then Tracking.Border:Hide() end
		else
			Tracking.search:Show()
			MiniMapTrackingIcon:Hide()
			if not MiniMapTrackingFrame.noBorder and Tracking.Border then Tracking.Border:Show() end
		end
	end)
	Tracking.xiala=PIGDownMenu(Tracking,{"TOPLEFT",Tracking, "CENTER", -80,-10},{wwgg,hhgg},"EasyMenu")
	Tracking.xiala.Button:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight");
	Tracking.xiala.Button:HookScript("OnClick", function(self, button)
		if button=="RightButton" then
			CancelTrackingBuff();
		end
	end)
	function Tracking.xiala:PIGDownMenu_Update_But(level, menuList)
		local spells ={1494,19883,19884,19885,19880,19878,19882,19879,5225,5500,5502,2383,2580,2481}
		local info = {}
		local Bufficon = GetTrackingTexture()
		for i=1,#spells,1 do
			if IsPlayerSpell(spells[i]) then
				local spellName = PIGGetSpellInfo(spells[i])
			    info.text, info.arg1 = spellName, spells[i]
			    info.icon = GetSpellTexture(spells[i])
			    if Bufficon==info.icon then
					info.checked = true
				else
					info.checked = false
				end
				info.func = function()
					CastSpellByID(spells[i])
					PIGCloseDropDownMenus()
				end
				self:PIGDownMenu_AddButton(info)
			end
		end 
	end
end