local _, addonTable = ...;
local Create=addonTable.Create
local PIGDownMenu=Create.PIGDownMenu
--
local FramePlusfun=addonTable.FramePlusfun
-----------------------------------
function FramePlusfun.Zhuizong()
	if not PIGA["FramePlus"]["Zhuizong"] then return end
	if Zhuizong_UI then return end
	local Width,Height = 33,33;
	local Zhuizong = CreateFrame("Frame", "Zhuizong_UI", UIParent);
	Zhuizong:SetSize(Width,Height);
	if NDui then
		Zhuizong:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0);
	else
		Zhuizong:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -15, 0);
	end

	Zhuizong.search = Zhuizong:CreateTexture(nil, "BORDER");
	Zhuizong.search:SetTexture("interface/common/ui-searchbox-icon.blp");
	Zhuizong.search:SetSize(Width*0.6,Height*0.6);
	Zhuizong.search:SetPoint("CENTER",Zhuizong,"CENTER",3,-3);
	Zhuizong.search:Hide()
	if NDui then
	else
		Zhuizong.Border = Zhuizong:CreateTexture(nil, "BORDER");
		Zhuizong.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
		Zhuizong.Border:SetPoint("TOPLEFT",Zhuizong,"TOPLEFT",0,0);
		Zhuizong.Border:Hide()
	end
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
	function Zhuizong.xiala:PIGDownMenu_Update_But(self, level, menuList)
		local spells ={1494,19883,19884,19885,19880,19878,19882,19879,5225,5500,5502,2383,2580,2481}
		local info = {}
		local Bufficon = GetTrackingTexture()
		for i=1,#spells,1 do
			if IsPlayerSpell(spells[i]) then
				local spellName = GetSpellInfo(spells[i])
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
				Zhuizong.xiala:PIGDownMenu_AddButton(info)
			end
		end 
	end
end