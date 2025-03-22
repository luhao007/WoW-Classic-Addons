local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create=addonTable.Create
local PIGButton=Create.PIGButton
local CommonInfo=addonTable.CommonInfo
--任务完成
local AudioList = {
	{"任务完成(露露)","Interface/AddOns/"..addonName.."/Common/Common/ogg/QE_Rurutia1.ogg"},
	{"工作完成(露露)","Interface/AddOns/"..addonName.."/Common/Common/ogg/QE_Rurutia2.ogg"},
	{"Bingo(露露)","Interface/AddOns/"..addonName.."/Common/Common/ogg/QE_Rurutia3.ogg"},
	{"任务完成(饽饽)","Interface/AddOns/"..addonName.."/Common/Common/ogg/QE_bobo.ogg"},
	{"任务完成(樱雪)","Interface/AddOns/"..addonName.."/Common/Common/ogg/QE_yingxue1.ogg"},
	{"SAKURA(樱雪)","Interface/AddOns/"..addonName.."/Common/Common/ogg/QE_yingxue2.ogg"},
	{"喵(樱雪)","Interface/AddOns/"..addonName.."/Common/Common/ogg/QE_yingxue3.ogg"},
}
CommonInfo.AudioList=AudioList
local QuestsEndFrameUI = CreateFrame("Frame");
QuestsEndFrameUI.wanchengqingkuang={}
QuestsEndFrameUI.chucijiazai=false
local function GetQuestsInfo(event)
	if tocversion>40000 then
		local numShownEntries, numQuests = C_QuestLog.GetNumQuestLogEntries()
		for i=1,numShownEntries do
			local info = C_QuestLog.GetInfo(i)
			if info.isHeader then--不是标题
			else
				local objectives = C_QuestLog.GetQuestObjectives(info.questID)
				local renwuzixiang = #objectives
				if renwuzixiang>0 then
					local yiwancheng = true
					for ii=1,renwuzixiang do
						if not objectives[ii].finished then
							yiwancheng = objectives[ii].finished
							break
						end
					end
					if yiwancheng then
						if not QuestsEndFrameUI.wanchengqingkuang[info.questID] and QuestsEndFrameUI.chucijiazai then
							PlaySoundFile(AudioList[PIGA["Common"]["QuestsEndAudio"]][2], "Master")
						end		
					end
					QuestsEndFrameUI.wanchengqingkuang[info.questID]=yiwancheng
				end
			end
		end
	else
		if QuestMapFrame then QuestMapFrame.ignoreQuestLogUpdate = true; end
		if tocversion>20000 then ExpandQuestHeader(0) end
		local numShownEntries, numQuests = GetNumQuestLogEntries()
		for questIndex=1,numShownEntries do	
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(questIndex)
			if isHeader then--是标题
			else
				--print(title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID)
				if isComplete then
					if not QuestsEndFrameUI.wanchengqingkuang[questID] and QuestsEndFrameUI.chucijiazai then
						PlaySoundFile(AudioList[PIGA["Common"]["QuestsEndAudio"]][2], "Master")
					end
					-- local numQuestLogLeaderBoards,= GetNumQuestLeaderBoards(questID)--子项目完成情况
					-- for ii=1,1 do
					-- 	local description, objectiveType, isCompleted = GetQuestLogLeaderBoard(ii, questIndex)
					-- 	print(description, objectiveType, isCompleted)
					-- end
				end
				QuestsEndFrameUI.wanchengqingkuang[questID]=isComplete
			end
		end
		if tocversion>20000 then 
			local numEntries, numQuests = GetNumQuestLogEntries();
			for questLogIndex = 1, numEntries do
				local title, _, _, isHeader, _, _, _, _, _, _, isOnMap = GetQuestLogTitle(questLogIndex);
				if isHeader then
					if isOnMap then
						ExpandQuestHeader(questLogIndex, true);
					else
						CollapseQuestHeader(questLogIndex, true);
					end
				end
			end
		end
		if QuestMapFrame then QuestMapFrame.ignoreQuestLogUpdate = nil; end
	end
end
QuestsEndFrameUI:SetScript("OnEvent", function(self,event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		GetQuestsInfo(event)
		self.chucijiazai=true
		C_Timer.After(1,function()
			--self:RegisterEvent("QUEST_LOG_UPDATE")
			self:RegisterEvent("QUEST_WATCH_UPDATE")
			self:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
			self:RegisterUnitEvent("UNIT_QUEST_LOG_CHANGED","player")
		end)
	else
		GetQuestsInfo(event)
	end
end)
function CommonInfo.Commonfun.QuestsEnd()
	if PIGA["Common"]["QuestsEnd"] then
		if tocversion>20000 and QuestLogFrame and not QuestLogFrame.allopen then
			QuestLogFrame.allopen = PIGButton(QuestLogFrame,{"TOPLEFT",QuestLogFrame,"TOPLEFT",185,-38.6},{24,23},"+",nil,nil,nil,nil,0);
			QuestLogFrame.allopen:SetScript("OnClick", function(self)
				ExpandQuestHeader(0)
			end)
			QuestLogFrame.allopen.alloff = PIGButton(QuestLogFrame.allopen,{"LEFT",QuestLogFrame.allopen,"RIGHT",6,1.6},{24,23},"-",nil,nil,nil,nil,0);
			QuestLogFrame.allopen.alloff:SetScript("OnClick", function(self)
				CollapseQuestHeader(0) 
			end)
		end
		QuestsEndFrameUI:RegisterEvent("PLAYER_ENTERING_WORLD")
	else
		QuestsEndFrameUI:UnregisterAllEvents()
	end
end