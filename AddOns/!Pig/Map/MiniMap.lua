local addonName, addonTable = ...;
local L=addonTable.locale
local match = _G.string.match
local Create = addonTable.Create
local PIGFontString=Create.PIGFontString
-----------
local Mapfun=addonTable.Mapfun
local IsNoDIYpaichu=Mapfun.IsNoDIYpaichu
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
	"PIG_OptionsUI.MiniMapBut",
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
	"BFGPSButton",
	"LibDBIcon10_HandyNotes_NPCs",
	--"EA_MinimapOption",--EventAlertMod
	--"LibDBIcon10_DetailsStreamer",
}
for i=1,10 do
	table.insert(paichulist,"GatherLite"..i)
end
for i=1,10 do
	table.insert(paichulist,"Spy_MapNoteList_mini"..i)
end
PIG_OptionsUI.MiniMapBut.ShouNaButList={};
PIG_OptionsUI.MiniMapBut.MiniList={};
local function gengxinMBweizhi(newValue)
	local meipaishu=newValue or PIGA["Map"]["MiniButShouNa_hang"];--每排按钮数
	local hangshuV = math.ceil(#PIG_OptionsUI.MiniMapBut.ShouNaButList/meipaishu)
	PIG_OptionsUI.MiniMapBut.Snf:SetSize(meipaishu*35+30, hangshuV*35+30)
	for i=1, #PIG_OptionsUI.MiniMapBut.ShouNaButList,1 do
		_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[i]]:Show()
		_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[i]]:SetParent(PIG_OptionsUI.MiniMapBut.Snf)
		_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[i]]:HookScript("OnEnter", function()
			PIG_OptionsUI.MiniMapBut.Snf.zhengzaixianshi = nil;
		end)
		_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[i]]:HookScript("OnLeave", function()
			PIG_OptionsUI.MiniMapBut.Snf.xiaoshidaojishi = 1.5;
			PIG_OptionsUI.MiniMapBut.Snf.zhengzaixianshi = true;
		end)
		-- _G[PIG_OptionsUI.MiniMapBut.ShouNaButList[i]]:HookScript("PostClick", function ()
		-- 	PIG_OptionsUI.MiniMapBut.Snf:Hide();
		-- end);
	end	
	for iiii=1, hangshuV,1 do
		if iiii==1 then
			for xxxx=1, iiii*meipaishu, 1 do
				if xxxx==1 then
					_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]]:ClearAllPoints();
					_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]]:SetPoint("TOPLEFT", PIG_OptionsUI.MiniMapBut.Snf, "TOPLEFT", 15, -15)
				else
					if _G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]] then
						_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]]:ClearAllPoints();
						_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]]:SetPoint("TOPLEFT", PIG_OptionsUI.MiniMapBut.Snf, "TOPLEFT", 35*(xxxx-1)+15, -15)
					end
				end
			end
		else
			for xxxx=(iiii-1)*meipaishu+1, iiii*meipaishu, 1 do
				if xxxx-(iiii-1)*meipaishu==1 then
					_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]]:ClearAllPoints();
					_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]]:SetPoint("TOPLEFT", PIG_OptionsUI.MiniMapBut.Snf, "TOPLEFT", 15, -35*(iiii-1)-15)
				else
					if _G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]] then
						_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]]:ClearAllPoints();
						_G[PIG_OptionsUI.MiniMapBut.ShouNaButList[xxxx]]:SetPoint("TOPLEFT", PIG_OptionsUI.MiniMapBut.Snf, "TOPLEFT", 35*(xxxx-(iiii-1)*meipaishu-1)+15, -35*(iiii-1)-15)
					end
				end
				
			end
		end
	end
end

local function IsNopaichu(uiname)
	for x=1,#paichulist do
		if uiname:match(paichulist[x]) then
			return false;
		end
	end
	return true
end
local function insertminiBut(data,uiname)
	for x=1,#data do
		if uiname==data[x] then
			return
		end
	end
	table.insert(data,uiname)
end
local function SN_MiniMapBut()
	if RecycleBinToggleButton then return end
	local children = { Minimap:GetChildren() };
	for i=1,#children do
		local uiname = children[i]:GetName()
		if uiname then
			if IsNopaichu(uiname) then
				insertminiBut(PIG_OptionsUI.MiniMapBut.MiniList,uiname)
				if not IsNoDIYpaichu(uiname) then
					insertminiBut(PIG_OptionsUI.MiniMapBut.ShouNaButList,uiname)
				end
			end
		end
	end
	gengxinMBweizhi(newValue)
end
function PIG_OptionsUI.MiniMapBut.SN_MiniMapBut()
	if PIGA["Map"]["MiniButShouNa_YN"]==1 then	
		C_Timer.After(0.1, SN_MiniMapBut);
		C_Timer.After(1, SN_MiniMapBut);
		C_Timer.After(6, SN_MiniMapBut);
		C_Timer.After(14, SN_MiniMapBut);
	end
end
--==============================
function PIG_OptionsUI.MiniMapBut.MinimapBut()
	if PIGA["Map"]["MinimapBut"] then
		PIG_OptionsUI.MiniMapBut:Show()
		if PIGA["Map"]["MiniButShouNa_YN"]==2 then
			PIG_OptionsUI.MiniMapBut:SetParent(Minimap)
			PIG_OptionsUI.MiniMapBut:SetFrameStrata("MEDIUM")
		elseif PIGA["Map"]["MiniButShouNa_YN"]==1 then
			PIG_OptionsUI.MiniMapBut:SetParent(UIParent)		
		end
		if PIGA["Error"]["ErrorTishi"] then
			table.insert(paichulist,"LibDBIcon10_BugSack")
		end
	else
		PIG_OptionsUI.MiniMapBut:Hide()
	end
end