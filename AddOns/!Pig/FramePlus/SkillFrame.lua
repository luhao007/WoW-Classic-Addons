local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local FramePlusfun=addonTable.FramePlusfun
local ActionFun=addonTable.Fun.ActionFun
local PIGUseKeyDown=ActionFun.PIGUseKeyDown
local Update_State=ActionFun.Update_State
----
local Data=addonTable.Data
local butW = ActionButton1:GetWidth()
local PIGSkillinfo={
	["bookType"]=nil,
	["butnum"]=10,
	["Width"]=butW,
	["Height"]=butW,
}
if tocversion<50000 then
	PIGSkillinfo.butnum= 8
	PIGSkillinfo.bookType=BOOKTYPE_SPELL
else
	PIGSkillinfo.bookType=Enum.SpellBookSpellBank.Player
end
local IsCurrentSpell=IsCurrentSpell or C_Spell and C_Spell.IsCurrentSpell
local GetSpellTexture=GetSpellTexture or C_Spell and C_Spell.GetSpellTexture
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
-----------------------
local function ADD_Skill_QK_Button(fujiui,uiname,ly)
	for F=1,PIGSkillinfo.butnum do
		local But
		if tocversion<40000 then
			But = CreateFrame("CheckButton", uiname.."_Button_"..F, fujiui, "SecureActionButtonTemplate,ActionButtonTemplate");
			But.NormalTexture:SetAlpha(0);
		else
			But = CreateFrame("CheckButton", uiname.."_Button_"..F, fujiui, "SecureActionButtonTemplate");
			But.icon = But:CreateTexture()
			But.icon:SetSize(54,54);
			But.icon:SetAllPoints(But)
			But.START = But:CreateTexture(nil, "OVERLAY");
			But.START:SetTexture(130724);
			But.START:SetBlendMode("ADD");
			But.START:SetAllPoints(But)
			But.START:Hide();
			hooksecurefunc(But, "SetChecked", function(self,bool)
				if bool then
					self.START:Show();
				else
					self.START:Hide();
				end
			end)
		end
		But:SetSize(PIGSkillinfo.Width,PIGSkillinfo.Height);
		PIGUseKeyDown(But)
		
		if F==1 then
			if ly~="Mainline" then
				But:SetPoint("TOPLEFT",fujiui,"TOPRIGHT",-37,-46);
			else
				But:SetPoint("TOPLEFT",fujiui,"TOPRIGHT",0,-46);
			end
		else
			But:SetPoint("TOP", _G[uiname.."_Button_"..(F-1)], "BOTTOM", 0, -16);
		end
		But:SetAttribute("type", "spell");
		But:Hide();
		-----------
		But.Border = But:CreateTexture(nil, "BACKGROUND");
		But.Border:SetDrawLayer("BACKGROUND", -8)
		if not IsAddOnLoaded("alaTradeSkill") then
			But.Border:SetTexture(136831);
		end
		if ly=="Mainline" then
			But:SetScale(0.88)
			But.Border:SetSize(PIGSkillinfo.Width*1.8,PIGSkillinfo.Height*1.8);
			But.Border:SetPoint("LEFT",But,"LEFT",-2,-6);
		else
			But:SetScale(0.88)
			But.Border:SetSize(PIGSkillinfo.Width*1.9,PIGSkillinfo.Height*1.9);
			But.Border:SetPoint("LEFT",But,"LEFT",-2,-5);
			But:RegisterEvent("CRAFT_CLOSE") 
		end
		But:RegisterEvent("TRADE_SKILL_CLOSE")
		But:RegisterEvent("ACTIONBAR_UPDATE_STATE");
		But:HookScript("OnEvent", function(self)
			Update_State(self)
		end)
	end
	local Skill_List = Data.Get_Skill_Info()
	for F=1, #Skill_List.top do
		local fujiK = _G[uiname.."_Button_"..F]
		fujiK.Type="spell"
		fujiK.SimID=Skill_List.top[F][2]
		fujiK.icon:SetTexture(GetSpellTexture(Skill_List.top[F][2]));
		fujiK:SetAttribute("spell", Skill_List.top[F][2]);
		fujiK:Show();
	end
	for F=1, #Skill_List.bot do
		local FF = F+#Skill_List.top;
		local fujiK = _G[uiname.."_Button_"..FF]
		if FF==(#Skill_List.top+1) then
			fujiK:SetPoint("TOP", _G[uiname.."_Button_"..(FF-1)], "BOTTOM", 0, -44);
		end
		fujiK.Type="spell"
		fujiK.SimID=Skill_List.bot[F][2]
		fujiK.icon:SetTexture(GetSpellTexture(Skill_List.bot[F][2]));
		fujiK:SetAttribute("spell", Skill_List.bot[F][2]);
		fujiK:Show();
	end
	fujiui:HookScript("OnShow", function(self)
		if ElvUI then
			for F=1, PIGSkillinfo.butnum do
				_G[uiname.."_Button_"..F].Border:Hide()
			end
		end	
	end);
end
local function ADD_Skill_QK()
	if Skill_Button_1 then return end
	if tocversion<50000 then
		ADD_Skill_QK_Button(TradeSkillFrame,"Skill")
	else
		ADD_Skill_QK_Button(ProfessionsFrame,"Skill","Mainline") 
	end
end
---
local function ADD_Craft_QK()	
	if Craft_Button_1 then return end
	ADD_Skill_QK_Button(CraftFrame,"Craft")
end
function FramePlusfun.Skill_QKbut()
	if not PIGA["FramePlus"]["Skill_QKbut"] then return end
	if NDui then return end
	if tocversion<50000 then
		if IsAddOnLoaded("Blizzard_TradeSkillUI") then
			ADD_Skill_QK()
		else
			local zhuanyeQuickQH = CreateFrame("FRAME")
			zhuanyeQuickQH:RegisterEvent("ADDON_LOADED")
			zhuanyeQuickQH:SetScript("OnEvent", function(self, event, arg1)
				if arg1 == "Blizzard_TradeSkillUI" then
					if InCombatLockdown() then
						zhuanyeQuickQH:RegisterEvent("PLAYER_REGEN_ENABLED")
					else
						ADD_Skill_QK()
					end
					zhuanyeQuickQH:UnregisterEvent("ADDON_LOADED")
				end
				if event=="PLAYER_REGEN_ENABLED" then
					ADD_Skill_QK()
					zhuanyeQuickQH:UnregisterEvent("PLAYER_REGEN_ENABLED")
				end
			end)
		end
		if IsAddOnLoaded("Blizzard_CraftUI") then
			ADD_Craft_QK()
		else
			local fumoQuickQH = CreateFrame("FRAME")
			fumoQuickQH:RegisterEvent("ADDON_LOADED")
			fumoQuickQH:SetScript("OnEvent", function(self, event, arg1)
				if arg1 == "Blizzard_CraftUI" then
					if InCombatLockdown() then
						fumoQuickQH:RegisterEvent("PLAYER_REGEN_ENABLED")
					else
						ADD_Craft_QK()
					end
					fumoQuickQH:UnregisterEvent("ADDON_LOADED")
				end
				if event=="PLAYER_REGEN_ENABLED" then
					ADD_Craft_QK()
					fumoQuickQH:UnregisterEvent("PLAYER_REGEN_ENABLED")
				end
			end)
		end
	else
		if IsAddOnLoaded("Blizzard_Professions") then
			ADD_Skill_QK()
		else
			local zhuanyeQuickQH = CreateFrame("FRAME")
			zhuanyeQuickQH:RegisterEvent("ADDON_LOADED")
			zhuanyeQuickQH:SetScript("OnEvent", function(self, event, arg1)
				if arg1 == "Blizzard_Professions" then
					if InCombatLockdown() then
						zhuanyeQuickQH:RegisterEvent("PLAYER_REGEN_ENABLED")
					else
						ADD_Skill_QK()
					end
					zhuanyeQuickQH:UnregisterEvent("ADDON_LOADED")
				end
				if event=="PLAYER_REGEN_ENABLED" then
					ADD_Skill_QK()
					zhuanyeQuickQH:UnregisterEvent("PLAYER_REGEN_ENABLED")
				end
			end)
		end
	end
end
--专业/附魔界面扩展
local function TradeSkillFunc()
	if TRADE_SKILLS_DISPLAYED==8 then	
			UIPanelWindows["TradeSkillFrame"].width = 13	
			TradeSkillFrame:SetWidth(713)
			TradeSkillFrame:SetHeight(487)

			-- 扩展配方列表到最高
			TradeSkillListScrollFrame:ClearAllPoints()
			TradeSkillListScrollFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 25, -75)
			TradeSkillListScrollFrame:SetSize(295, 336)

			--配方详情移到右边增加高度
			TradeSkillDetailScrollFrame:ClearAllPoints()
			TradeSkillDetailScrollFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 352, -74)
			TradeSkillDetailScrollFrame:SetSize(298, 336)
			-- 增加配方列表目录数
			local oldTradeSkillsDisplayed = TRADE_SKILLS_DISPLAYED
			for i = 1 + 1, TRADE_SKILLS_DISPLAYED do
				_G["TradeSkillSkill" .. i]:ClearAllPoints()
				_G["TradeSkillSkill" .. i]:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i-1)], "BOTTOMLEFT", 0, 1)
			end
			_G.TRADE_SKILLS_DISPLAYED = _G.TRADE_SKILLS_DISPLAYED + 14
			for i = oldTradeSkillsDisplayed + 1, TRADE_SKILLS_DISPLAYED do
				local button = CreateFrame("Button", "TradeSkillSkill" .. i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
				button:SetID(i)
				button:Hide()
				button:ClearAllPoints()
				button:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i-1)], "BOTTOMLEFT", 0, 1)
			end
			--选中高亮条宽度
			hooksecurefunc(_G["TradeSkillHighlightFrame"], "Show", function()
				_G["TradeSkillHighlightFrame"]:SetWidth(290)
			end)
			--技能点数条位置
			TradeSkillRankFrame:ClearAllPoints()
			TradeSkillRankFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 84, -36)
			TradeSkillRankFrameSkillRank:ClearAllPoints()
			TradeSkillRankFrameSkillRank:SetPoint("CENTER", TradeSkillRankFrame, "CENTER", 0, 0)
			--调整关闭按钮位置
			TradeSkillCancelButton:SetSize(80, 22)
			TradeSkillCancelButton:ClearAllPoints()
			TradeSkillCancelButton:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -42, 54)
			--调整全部制造按钮位置
			TradeSkillCreateButton:ClearAllPoints()
			TradeSkillCreateButton:SetPoint("RIGHT", TradeSkillCancelButton, "LEFT", -1, 0)
			--分类下拉菜单位置
			local SlotDropDown=TradeSkillInvSlotDropDown or TradeSkillInvSlotDropdown or CreateFrame("Frame")
			if SlotDropDown then
				SlotDropDown:ClearAllPoints()
				SlotDropDown:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -60, -44)
				-- local SubDropDown=TradeSkillSubClassDropDown or TradeSkillSubClassDropdown	
				-- if SubDropDown then
				-- 	SubDropDown:SetPoint("RIGHT", SlotDropDown, "RIGHT", -5, 0)
				-- end
			end
			--材料齐备
			if TradeSkillFrameAvailableFilterCheckButton then
				TradeSkillFrameAvailableFilterCheckButton:ClearAllPoints()
				TradeSkillFrameAvailableFilterCheckButton:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 70, -50)
			end
			--搜索位置
			if TradeSkillFrameEditBox then
				TradeSkillFrameEditBox:ClearAllPoints()
				TradeSkillFrameEditBox:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 190, -50)
			end
			if TradeSearchInputBox then
				TradeSearchInputBox:ClearAllPoints()
				TradeSearchInputBox:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 200, -52)
			end
			--纹理更新
			if ElvUI then
				TradeSkillFrame:HookScript("OnShow", function(self)
					if ElvUI then
						SlotDropDown:ClearAllPoints()
						SlotDropDown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 530, -30)
						self.backdrop:SetPoint("TOPLEFT",self,"TOPLEFT",0,0);
						self.backdrop:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",-32,42);
					end	
				end);
			else
				local regions = {TradeSkillFrame:GetRegions()}
				if tocversion<20000 then
					--隐藏全部折叠附近纹理
					TradeSkillExpandTabLeft:Hide()
					TradeSkillExpandTabRight:Hide()
					TradeSkillSkillBorderLeft:Hide()
					regions[2]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
					regions[2]:SetSize(512, 512)

					regions[3]:ClearAllPoints()
					regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
					regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
					regions[3]:SetSize(256, 512)
					regions[4]:Hide()
					regions[5]:Hide()
					regions[8]:Hide()
					regions[9]:Hide()
					regions[10]:Hide()
				elseif tocversion<30000 then
					--隐藏全部折叠附近纹理
					TradeSkillExpandTabLeft:Hide()
					TradeSkillHorizontalBarLeft:Hide()
					regions[2]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
					regions[2]:SetSize(512, 512)

					regions[3]:ClearAllPoints()
					regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
					regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
					regions[3]:SetSize(256, 512)
					regions[5]:Hide()
					regions[6]:Hide()
					regions[8]:Hide()
				elseif tocversion<50000 then
					--隐藏全部折叠附近纹理
					TradeSkillExpandTabLeft:Hide()
					TradeSkillExpandTabRight:Hide()
					TradeSkillHorizontalBarLeft:Hide()
					--regions[2]:Hide()
					regions[5]:Hide()
					regions[6]:Hide()
					--regions[7]:Hide()--标题
					--regions[8]:Hide()
					regions[9]:Hide()

					regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
					regions[3]:SetSize(512, 512)

					regions[4]:ClearAllPoints()
					regions[4]:SetPoint("TOPLEFT", regions[3], "TOPRIGHT", 0, 0)
					regions[4]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
					regions[4]:SetSize(256, 512)
				end
				if not IsAddOnLoaded("alaTradeSkill") then
					--调整配方列表底部纹理
					TradeSkillFrame.RecipeInset = TradeSkillFrame:CreateTexture(nil, "ARTWORK")
					TradeSkillFrame.RecipeInset:SetSize(304, 361)
					TradeSkillFrame.RecipeInset:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 16, -72)
					TradeSkillFrame.RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")
					-- 调整配方详细页纹理
					TradeSkillFrame.DetailsInset = TradeSkillFrame:CreateTexture(nil, "ARTWORK")
					TradeSkillFrame.DetailsInset:SetSize(302, 339)
					TradeSkillFrame.DetailsInset:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 348, -72)
					TradeSkillFrame.DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")
				end
			end
	end
end
local function CraftFunc()
	if CRAFTS_DISPLAYED==8 then  
		UIPanelWindows["CraftFrame"].width = 713
		--重新设置附魔框架大小
		CraftFrame:SetWidth(713)
		CraftFrame:SetHeight(487)
		--纹理调整替换
		if ElvUI then

		else
			local regions = {_G["CraftFrame"]:GetRegions()}
			regions[2]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
			regions[2]:SetSize(512, 512)
			regions[3]:ClearAllPoints()
			regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
			regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
			regions[3]:SetSize(256, 512)
			regions[4]:Hide()
			regions[5]:Hide()
			regions[9]:Hide()
			regions[10]:Hide()
			CraftSkillBorderLeft:SetAlpha(0)
			CraftSkillBorderRight:SetAlpha(0)
			---
			if tocversion<20000 then

			elseif tocversion<30000 then
				CraftFrameAvailableFilterCheckButton:ClearAllPoints()
				CraftFrameAvailableFilterCheckButton:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 84, -42)
				CraftFrameFilterDropDown:ClearAllPoints()
				CraftFrameFilterDropDown:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 498, -40)
			end
			-- 替换左侧列表纹理
			local RecipeInset = CraftFrame:CreateTexture(nil, "ARTWORK")
			RecipeInset:SetSize(304, 361)
			RecipeInset:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 16, -72)
			RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")
			-- 右侧底部纹理
			local DetailsInset = CraftFrame:CreateTexture(nil, "ARTWORK")
			DetailsInset:SetSize(302, 339)
			DetailsInset:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 348, -72)
			DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")
		end
		--技能点数条位置
		CraftRankFrame:ClearAllPoints()
		CraftRankFrame:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 184, -47)
		-- 附魔框架标题位置
		CraftFrameTitleText:ClearAllPoints()
		CraftFrameTitleText:SetPoint("TOP", CraftFrame, "TOP", 0, -18)
		-- 附魔列表增加高度
		CraftListScrollFrame:ClearAllPoints()
		CraftListScrollFrame:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 25, -75)
		CraftListScrollFrame:SetSize(295, 336)

		-- 增加附魔目录可显示数
		local oldCraftsDisplayed = CRAFTS_DISPLAYED
		Craft1Cost:ClearAllPoints()
		Craft1Cost:SetPoint("RIGHT", Craft1, "RIGHT", -30, 0)
		for i = 1 + 1, CRAFTS_DISPLAYED do
			_G["Craft" .. i]:ClearAllPoints()
			_G["Craft" .. i]:SetPoint("TOPLEFT", _G["Craft" .. (i-1)], "BOTTOMLEFT", 0, 1)
			_G["Craft" .. i .. "Cost"]:ClearAllPoints()
			_G["Craft" .. i .. "Cost"]:SetPoint("RIGHT", _G["Craft" .. i], "RIGHT", -30, 0)
		end
		_G.CRAFTS_DISPLAYED = _G.CRAFTS_DISPLAYED + 14
		for i = oldCraftsDisplayed + 1, CRAFTS_DISPLAYED do
			local button = CreateFrame("Button", "Craft" .. i, CraftFrame, "CraftButtonTemplate")
			button:SetID(i)
			button:Hide()
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", _G["Craft" .. (i-1)], "BOTTOMLEFT", 0, 1)
			_G["Craft" .. i .. "Cost"]:ClearAllPoints()
			_G["Craft" .. i .. "Cost"]:SetPoint("RIGHT", _G["Craft" .. i], "RIGHT", -30, 0)
		end
		
		-- 选中高亮条宽度
		hooksecurefunc(_G["CraftHighlightFrame"], "Show", function()
			_G["CraftHighlightFrame"]:SetWidth(290)
		end)
		-- 附魔材料细节移到右边增加高度
		CraftDetailScrollFrame:ClearAllPoints()
		CraftDetailScrollFrame:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 352, -74)
		CraftDetailScrollFrame:SetSize(298, 336)
		-- 细节滚动条隐藏
		CraftDetailScrollFrameTop:SetAlpha(0)
		CraftDetailScrollFrameBottom:SetAlpha(0)
		
		-- 关闭按钮位置
		CraftCancelButton:SetSize(80, 22)
		CraftCancelButton:SetText(CLOSE)
		CraftCancelButton:ClearAllPoints()
		CraftCancelButton:SetPoint("BOTTOMRIGHT", CraftFrame, "BOTTOMRIGHT", -42, 54)
		-- 附魔按钮
		CraftCreateButton:ClearAllPoints()
		CraftCreateButton:SetPoint("RIGHT", CraftCancelButton, "LEFT", -1, 0)
		
		-- 训练宠物
		CraftFramePointsLabel:ClearAllPoints()
		CraftFramePointsLabel:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 500, -46)
		CraftFramePointsText:ClearAllPoints()
		CraftFramePointsText:SetPoint("LEFT", CraftFramePointsLabel, "RIGHT", 3, 0)
	end
end
function FramePlusfun.Skill()
	if not PIGA["FramePlus"]["Skill"] then return end
	if NDui then return end
	if tocversion<50000 then
		if IsAddOnLoaded("Blizzard_TradeSkillUI") then
			TradeSkillFunc()
		else
			local zhuanyeFrame = CreateFrame("FRAME")
			zhuanyeFrame:RegisterEvent("ADDON_LOADED")
			zhuanyeFrame:SetScript("OnEvent", function(self, event, arg1)
				if arg1 == "Blizzard_TradeSkillUI" then
					TradeSkillFunc()
					zhuanyeFrame:UnregisterEvent("ADDON_LOADED")
				end
			end)
		end
		if IsAddOnLoaded("Blizzard_CraftUI") then
			CraftFunc();
		else
			local fumoFrame = CreateFrame("FRAME")
			fumoFrame:RegisterEvent("ADDON_LOADED")
			fumoFrame:SetScript("OnEvent", function(self, event, arg1)
				if arg1 == "Blizzard_CraftUI" then
					CraftFunc();
					fumoFrame:UnregisterEvent("ADDON_LOADED")
				end
			end)
		end
	end
end