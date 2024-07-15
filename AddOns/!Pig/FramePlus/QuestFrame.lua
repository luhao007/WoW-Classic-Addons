local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local FramePlusfun=addonTable.FramePlusfun
--任务界面扩展--------------------
function FramePlusfun.Quest()
	if not PIGA["FramePlus"]["Quest"] then return end
	if NDui then return end
	if tocversion<50000 then
		local function gengxinLVQR()--显示任务等级
			local numEntries, numQuests = GetNumQuestLogEntries();
			if (numEntries == 0) then return end
			for i = 1, QUESTS_DISPLAYED, 1 do
				local questIndex = i + FauxScrollFrame_GetOffset(QuestLogListScrollFrame);		
				if (questIndex <= numEntries) then
					local title, level, _, isHeader = GetQuestLogTitle(questIndex)
					if not isHeader then
						QuestLogDummyText:SetText(" ["..level.."]"..title)
						if tocversion<30000 then
							local questLogTitle = _G["QuestLogTitle"..i.."NormalText"]
							local questCheck = _G["QuestLogTitle"..i.."Check"]
							questLogTitle:SetText(" ["..level.."]"..title)
							questCheck:SetPoint("LEFT", questLogTitle, "LEFT", QuestLogDummyText:GetWidth()+2, 0);
						elseif tocversion<50000 then
							local questLogbut = _G["QuestLogListScrollFrameButton"..i]
							questLogbut.normalText:SetText(" ["..level.."]"..title)
							local TitleWWW =QuestLogDummyText:GetWidth()
							questLogbut.normalText:SetWidth(TitleWWW+16)
							questLogbut.check:SetPoint("LEFT", questLogbut.normalText, "RIGHT", -16, 0);	
						end		
					end
				end  
			end
		end
		QuestLogListScrollFrame:HookScript("OnMouseWheel", function()
		    gengxinLVQR()
		end)
		hooksecurefunc("QuestLog_Update", function()
			gengxinLVQR()
		end)
		if tocversion<30000 then
			if QUESTS_DISPLAYED==6 then 
				local xssdadas = 714
				UIPanelWindows["QuestLogFrame"].width = xssdadas
				--缩放任务框架以匹配新纹理
				QuestLogFrame:SetWidth(xssdadas)
				QuestLogFrame:SetHeight(487)

				--任务日志标题移到中间
				QuestLogTitleText:ClearAllPoints();
				QuestLogTitleText:SetPoint("TOP", QuestLogFrame, "TOP", 0, -18);

				-- 任务详细说明移到右边，并增加高度
				QuestLogDetailScrollFrame:ClearAllPoints();
				QuestLogDetailScrollFrame:SetPoint("TOPLEFT", QuestLogListScrollFrame,"TOPRIGHT", 30, 0);
				QuestLogDetailScrollFrame:SetHeight(335);

				-- 任务目录增加高度
				QuestLogListScrollFrame:SetHeight(335);

				-- 增加可显示任务目录数
				local oldQuestsDisplayed = QUESTS_DISPLAYED;
				QUESTS_DISPLAYED = QUESTS_DISPLAYED + 16;
				for i = oldQuestsDisplayed + 1, QUESTS_DISPLAYED do
				    local button = CreateFrame("Button", "QuestLogTitle" .. i, QuestLogFrame, "QuestLogTitleButtonTemplate");
				    button:SetID(i);
				    button:Hide();
				    button:ClearAllPoints();
				    button:SetPoint("TOPLEFT", _G["QuestLogTitle" .. (i-1)], "BOTTOMLEFT", 0, 1);
				end

				--更换纹理
				local regions = { QuestLogFrame:GetRegions() }
				regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
				regions[3]:SetSize(512,512)

				regions[4]:ClearAllPoints()
				regions[4]:SetPoint("TOPLEFT", regions[3], "TOPRIGHT", 0, 0)
				regions[4]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
				regions[4]:SetSize(256,512)

				regions[5]:Hide()
				regions[6]:Hide()
				--调整放弃任务按钮大小位置
				QuestLogFrameAbandonButton:SetSize(110, 21)
				QuestLogFrameAbandonButton:SetText(ABANDON_QUEST_ABBREV)
				QuestLogFrameAbandonButton:ClearAllPoints()
				QuestLogFrameAbandonButton:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 17, 54)
				--调整共享任务按钮大小
				QuestFramePushQuestButton:SetSize(100, 21)
				QuestFramePushQuestButton:SetText(SHARE_QUEST_ABBREV)
				QuestFramePushQuestButton:ClearAllPoints()
				QuestFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", -3, 0)
				-- 增加显示地图按钮
				local logMapButton = CreateFrame("Button", "logMapButton_UI", QuestLogFrame, "UIPanelButtonTemplate")
				logMapButton:SetText("显示地图")
				logMapButton:ClearAllPoints()
				logMapButton:SetPoint("LEFT", QuestFramePushQuestButton, "RIGHT", -3, 0)
				logMapButton:SetSize(100, 21)
				logMapButton:SetScript("OnClick", ToggleWorldMap)
				-- 调整没有任务文字提示位置
				QuestLogNoQuestsText:ClearAllPoints();
				QuestLogNoQuestsText:SetPoint("TOP", QuestLogListScrollFrame, 0, -90);
				--隐藏没有任务时纹理
				local txset = { EmptyQuestLogFrame:GetRegions();}
				txset[1]:Hide();
				txset[2]:Hide();
				txset[3]:Hide();
				txset[4]:Hide();
			end
		end
	end
end