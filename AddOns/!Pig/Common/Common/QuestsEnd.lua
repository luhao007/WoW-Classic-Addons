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
	if tocversion<100000 then
		if QuestMapFrame then QuestMapFrame.ignoreQuestLogUpdate = true; end
		local numShownEntries, numQuests = GetNumQuestLogEntries()
		ExpandQuestHeader(0) 
		local numShownEntries, numQuests = GetNumQuestLogEntries()
		for i=1,numShownEntries do	
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(i)
			if isHeader then--是标题
			else
				if isComplete==1 then
					if not QuestsEndFrameUI.wanchengqingkuang[questID] and QuestsEndFrameUI.chucijiazai then
						PlaySoundFile(AudioList[PIGA["Common"]["QuestsEndAudio"]][2], "Master")
					end
				end
				-- local numQuestLogLeaderBoards,= GetNumQuestLeaderBoards(questID)--子项目完成情况
				-- for ii=1,1 do
				-- 	local description, objectiveType, isCompleted = GetQuestLogLeaderBoard(ii, i)
				-- 	print(description, objectiveType, isCompleted)
				-- end
				QuestsEndFrameUI.wanchengqingkuang[questID]=isComplete or false
			end
		end
		--恢复
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
		--
	else
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
	end
	if QuestMapFrame then QuestMapFrame.ignoreQuestLogUpdate = nil; end
end
QuestsEndFrameUI:SetScript("OnEvent", function(self,event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		GetQuestsInfo(event)
		if not self.chucijiazai then self.chucijiazai=true end
		self:RegisterEvent("QUEST_WATCH_UPDATE")
		self:RegisterEvent("UNIT_QUEST_LOG_CHANGED","player")
		--self:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
		--self:RegisterEvent("QUEST_LOG_UPDATE")
	else
		GetQuestsInfo(event)
	end
end)
function CommonInfo.Commonfun.QuestsEnd()
	if PIGA["Common"]["QuestsEnd"] then
		if QuestLogFrame and not QuestLogFrame.allopen then
			QuestLogFrame.allopen = PIGButton(QuestLogFrame,{"TOPLEFT",QuestLogFrame,"TOPLEFT",181,-38.6},{24,21},"+",nil,nil,nil,nil,0);
			QuestLogFrame.allopentxt="-"
			QuestLogFrame.allopen:SetScript("OnClick", function(self)
				if QuestLogFrame.allopentxt=="-" then
					ExpandQuestHeader(0)
					QuestLogFrame.allopentxt="+"
				elseif QuestLogFrame.allopentxt=="+" then
					CollapseQuestHeader(0) 
					QuestLogFrame.allopentxt="-"
				end
				self:SetText(QuestLogFrame.allopentxt)
			end)
		end
		QuestsEndFrameUI:RegisterEvent("PLAYER_ENTERING_WORLD")
	else
		QuestsEndFrameUI:UnregisterAllEvents()
	end
end