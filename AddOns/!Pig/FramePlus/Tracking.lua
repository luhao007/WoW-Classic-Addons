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
	local Tracking = CreateFrame("Frame", nil, Minimap);
	Tracking:SetSize(Width,Height);
	if NDui then
		Tracking:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0);
	else
		Tracking:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 11, -26);
	end
	Tracking.search = Tracking:CreateTexture(nil, "BORDER");
	Tracking.search:SetAtlas("None")
	Tracking.search:SetSize(Width*0.7,Height*0.7);
	Tracking.search:SetPoint("CENTER",Tracking,"CENTER",2,-2);
	Tracking.search:Hide()
	if NDui then
	else
		Tracking.Border = Tracking:CreateTexture(nil, "OVERLAY");
		Tracking.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
		Tracking.Border:SetPoint("TOPLEFT",Tracking,"TOPLEFT",0,0);
		Tracking.Border:Hide()
	end
	local MiniMapTrackingFrame = MiniMapTrackingFrame or MiniMapTracking
	Tracking:RegisterEvent("PLAYER_ENTERING_WORLD");
	Tracking:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	Tracking:HookScript("OnEvent", function(self,event,arg1)
		if event=="PLAYER_ENTERING_WORLD" then
			if ElvUI then
				Tracking.Border:SetAlpha(0)
				Tracking:SetSize(Width-6,Height-6);
				Tracking:ClearAllPoints();
				Tracking:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0);
			end
		end
		if GetTrackingTexture() then
			MiniMapTrackingFrame:Show()
			MiniMapTrackingIcon:SetTexture(GetTrackingTexture())
			if Tracking.Border then Tracking.Border:Hide() end
			Tracking.search:Hide()
		else
			if Tracking.Border then Tracking.Border:Show() end
			Tracking.search:Show()
		end
	end)
	Tracking.xiala=PIGDownMenu(Tracking,{"TOPLEFT",Tracking, "CENTER", -80,-10},{wwgg,hhgg},"EasyMenu")
	Tracking.xiala.Button:HookScript("OnClick", function(self, button)
		if button=="RightButton" then
			CancelTrackingBuff();
			Tracking.Border:Show()
			Tracking.search:Show()
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