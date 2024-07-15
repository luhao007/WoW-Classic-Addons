local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local _, _, _, tocversion = GetBuildInfo()
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
-----------
local Mapfun=addonTable.Mapfun
----------------------------------------
local paichulist = {
	"MiniMapTrackingFrame",
	"MiniMapMeetingStoneFrame",
	"MiniMapMailFrame",
	"MiniMapBattlefieldFrame",
	"MiniMapWorldMapButton",
	"MiniMapPing",
	"MinimapBackdrop",
	"MinimapZoomIn",
	"MinimapZoomOut",
	"BookOfTracksFrame",
	"GatherNote",
	"FishingExtravaganzaMini",
	"MiniNotePOI",
	"RecipeRadarMinimapIcon",
	"FWGMinimapPOI",
	"CartographerNotesPOI",
	"MBB_MinimapButtonFrame",
	"EnhancedFrameMinimapButton",
	"GFW_TrackMenuFrame",
	"GFW_TrackMenuButton",
	"TDial_TrackingIcon",
	"TDial_TrackButton",
	"MiniMapTracking",
	"GatherMatePin",
	"HandyNotesPin",
	"TimeManagerClockButton",
	"GameTimeFrame",
	"DA_Minimap",
	"ElvConfigToggle",
	"MiniMapInstanceDifficulty",
	"MinimapZoneTextButton",
	"GuildInstanceDifficulty",
	"MiniMapVoiceChatFrame",
	"MiniMapRecordingButton",
	"QueueStatusMinimapButton",
	"GatherArchNote",
	"ZGVMarker",
	"QuestPointerPOI",
	"poiMinimap",
	"MiniMapLFGFrame",
	"PremadeFilter_MinimapButton",
	"QuestieFrame",
	"Guidelime",
	"MiniMapBattlefieldFrame",
	"PigMinimapBut_UI",
	"MinimapLayerFrame",
	"NWBNaxxMarkerMini",
	"NWBMini",
	"SexyMapCustomBackdrop",
	"SexyMapCoordFrame",
	"SexyMapPingFrame",
	"SexyMapZoneTextButton",
	"ElvUI_MinimapHolder",
	"QueueStatusButton",
	"MinimapPanel",
	"RecycleBinToggleButton",
}
local ShouNaButHeji={};
local function gengxinMBweizhi(newValue)
	local meipaishu=newValue or PIGA["Map"]["MiniButShouNa_hang"];--每排按钮数
	PigMinimapBut_UI.Snf:SetSize(meipaishu*35+30, math.ceil(#ShouNaButHeji/meipaishu)*35+30)
	for i=1, #ShouNaButHeji,1 do
		_G[ShouNaButHeji[i]]:SetParent(PigMinimapBut_UI.Snf)
		_G[ShouNaButHeji[i]]:HookScript("OnEnter", function()
			PigMinimapBut_UI.Snf.zhengzaixianshi = nil;
		end)
		_G[ShouNaButHeji[i]]:HookScript("OnLeave", function()
			PigMinimapBut_UI.Snf.xiaoshidaojishi = 1.5;
			PigMinimapBut_UI.Snf.zhengzaixianshi = true;
		end)
		-- _G[ShouNaButHeji[i]]:HookScript("PostClick", function ()
		-- 	PigMinimapBut_UI.Snf:Hide();
		-- end);
	end	
	for iiii=1, math.ceil(#ShouNaButHeji/meipaishu),1 do
		if iiii==1 then
			for xxxx=1, iiii*meipaishu, 1 do
				if xxxx==1 then
					_G[ShouNaButHeji[xxxx]]:ClearAllPoints();
					_G[ShouNaButHeji[xxxx]]:SetPoint("TOPLEFT", PigMinimapBut_UI.Snf, "TOPLEFT", 15, -15)
				else
					if _G[ShouNaButHeji[xxxx]] then
						_G[ShouNaButHeji[xxxx]]:ClearAllPoints();
						_G[ShouNaButHeji[xxxx]]:SetPoint("TOPLEFT", PigMinimapBut_UI.Snf, "TOPLEFT", 35*(xxxx-1)+15, -15)
					end
				end
			end
		else
			for xxxx=(iiii-1)*meipaishu+1, iiii*meipaishu, 1 do
				if xxxx-(iiii-1)*meipaishu==1 then
					_G[ShouNaButHeji[xxxx]]:ClearAllPoints();
					_G[ShouNaButHeji[xxxx]]:SetPoint("TOPLEFT", PigMinimapBut_UI.Snf, "TOPLEFT", 15, -35*(iiii-1)-15)
				else
					if _G[ShouNaButHeji[xxxx]] then
						_G[ShouNaButHeji[xxxx]]:ClearAllPoints();
						_G[ShouNaButHeji[xxxx]]:SetPoint("TOPLEFT", PigMinimapBut_UI.Snf, "TOPLEFT", 35*(xxxx-(iiii-1)*meipaishu-1)+15, -35*(iiii-1)-15)
					end
				end
				
			end
		end
	end
end
local function SN_MiniMapBut()
	local children = { Minimap:GetChildren() };
	local NewPaichulist = {}
	for i=1,10 do
		table.insert(NewPaichulist,"Spy_MapNoteList_mini"..i)
	end
	for i=1,#paichulist do
		table.insert(NewPaichulist,paichulist[i])
	end
	local data = PIGA["Map"]["MinimapBpaichu"]
	for i=1,#data do
		table.insert(NewPaichulist,data[i])
	end
	for i=1,#children do
		if children[i]:GetName() then
			--print(children[i]:GetName())
			local shifouzaiguolvliebiao = true;
			for ii=1,#NewPaichulist do
					if children[i]:GetName():match(NewPaichulist[ii]) then
						shifouzaiguolvliebiao = false;
					end
			end
			if shifouzaiguolvliebiao then
				table.insert(ShouNaButHeji,children[i]:GetName())
			end
		end
	end
	gengxinMBweizhi(newValue)
end
function PigMinimapBut_UI.SN_MiniMapBut()
	if PIGA["Map"]["MiniButShouNa_YN"]==1 and not NDui then	
		SN_MiniMapBut()
		C_Timer.After(3, SN_MiniMapBut);
		C_Timer.After(8, SN_MiniMapBut);
		C_Timer.After(14, SN_MiniMapBut);
	end
end
--==============================
function PigMinimapBut_UI.MinimapBut()
	if PIGA["Map"]["MinimapBut"] then
		PigMinimapBut_UI:Show()
		if PIGA["Map"]["MiniButShouNa_YN"]==2 or NDui then
			PigMinimapBut_UI:SetParent(Minimap)
			PigMinimapBut_UI:SetFrameStrata("MEDIUM")
		elseif PIGA["Map"]["MiniButShouNa_YN"]==1 then
			PigMinimapBut_UI:SetParent(UIParent)		
		end
		if PIGA["Error"]["ErrorTishi"] then
			table.insert(paichulist,"LibDBIcon10_BugSack")
		end
	else
		PigMinimapBut_UI:Hide()
	end
end