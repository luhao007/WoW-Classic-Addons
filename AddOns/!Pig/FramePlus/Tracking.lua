local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create=addonTable.Create
local PIGDownMenu=Create.PIGDownMenu
--
local FramePlusfun=addonTable.FramePlusfun
-----------------------------------
function FramePlusfun.Zhuizong()
	if tocversion>19999 then return end
	if not PIGA["FramePlus"]["Zhuizong"] then return end
	if Zhuizong_UI then return end
	local Width,Height = 33,33;
	local Zhuizong = CreateFrame("Frame", "Zhuizong_UI", UIParent);
	Zhuizong:SetSize(Width,Height);
	if NDui then
		Zhuizong:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0);
	else
		Zhuizong:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 11, -26);
	end

	Zhuizong.search = Zhuizong:CreateTexture(nil, "BORDER");
	--Zhuizong.search:SetTexture("interface/common/ui-searchbox-icon.blp");
	Zhuizong.search:SetAtlas("None")
	Zhuizong.search:SetSize(Width*0.7,Height*0.7);
	Zhuizong.search:SetPoint("CENTER",Zhuizong,"CENTER",2,-2);
	Zhuizong.search:Hide()
	if NDui then
	else
		Zhuizong.Border = Zhuizong:CreateTexture(nil, "BORDER");
		Zhuizong.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
		Zhuizong.Border:SetPoint("TOPLEFT",Zhuizong,"TOPLEFT",0,0);
		Zhuizong.Border:Hide()
	end
	local MiniMapTrackingFrame = MiniMapTrackingFrame or MiniMapTracking
	Zhuizong:RegisterEvent("PLAYER_ENTERING_WORLD");
	Zhuizong:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	Zhuizong:HookScript("OnEvent", function(self,event,arg1)
		if event=="PLAYER_ENTERING_WORLD" then
			if ElvUI then
				Zhuizong.Border:SetAlpha(0)
				Zhuizong:SetSize(Width-6,Height-6);
				Zhuizong:ClearAllPoints();
				Zhuizong:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0);
			end
		end
		if GetTrackingTexture() then
			MiniMapTrackingFrame:Show()
			MiniMapTrackingIcon:SetTexture(GetTrackingTexture())
			if Zhuizong.Border then Zhuizong.Border:Hide() end
			Zhuizong.search:Hide()
		else
			if Zhuizong.Border then Zhuizong.Border:Show() end
			Zhuizong.search:Show()
		end
	end)
	Zhuizong.xiala=PIGDownMenu(Zhuizong,{"TOPLEFT",Zhuizong, "CENTER", -80,-10},{wwgg,hhgg},"EasyMenu")
	Zhuizong.xiala.Button:HookScript("OnClick", function(self, button)
		if button=="RightButton" then
			CancelTrackingBuff();
			Zhuizong.Border:Show()
			Zhuizong.search:Show()
		end
	end)
	function Zhuizong.xiala:PIGDownMenu_Update_But(level, menuList)
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