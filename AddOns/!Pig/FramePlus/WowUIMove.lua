local _, addonTable = ...;
local Create=addonTable.Create
local PIGFontString=Create.PIGFontString
local FramePlusfun=addonTable.FramePlusfun
--------
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
--初始系统已经加载的UI
local UINameList={
	{CharacterFrame,},
	{SpellBookFrame,},
	{QuestLogFrame,},
	{FriendsFrame,},
	{LFGParentFrame,},
	{PVEFrame,},
	{MailFrame,},
	{ChannelFrame,},--聊天频道
	{AddonList,},
	{MerchantFrame},--商人
	{GossipFrame},--NPC对话
	{QuestFrame,},--任务NPC对话
	{BankFrame},--银行
	--{LootFrame,},
	{WorldMapFrame,},--世界地图
	{WorldMapFrame,WorldMapTitleButton},--世界地图mini模式
}
if ContainerFrameCombinedBags then
	table.insert(UINameList,{ContainerFrameCombinedBags,"add",ContainerFrameCombinedBags.TitleContainer})
end
--根据事件加载的UI
local UINameList_AddOn={
	{"MacroFrame","Blizzard_MacroUI",},--宏命令UI
	{"AchievementFrame","Blizzard_AchievementUI",{"AchievementFrameHeader"}},--成就UI
	{"CommunitiesFrame","Blizzard_Communities",},--公会与社区
	{"CollectionsJournal","Blizzard_Collections",},--藏品
	{"EncounterJournal","Blizzard_EncounterJournal",},--冒险手册
	{"CraftFrame","Blizzard_CraftUI",},--附魔
	{"InspectFrame","Blizzard_InspectUI",},--观察
	{"GuildBankFrame","Blizzard_GuildBankUI",},--公会银行
	{"CalendarFrame","Blizzard_Calendar",},--日历
}
if PIG_MaxTocversion() then
	table.insert(UINameList_AddOn,{"TradeSkillFrame","Blizzard_TradeSkillUI"})--专业面板
else
	table.insert(UINameList_AddOn,{"ProfessionsBookFrame","Blizzard_ProfessionsBook"})--专业
	table.insert(UINameList_AddOn,{"ProfessionsFrame","Blizzard_Professions"})--专业面板
end
--天赋UI
if PIG_MaxTocversion() then
	table.insert(UINameList_AddOn,{"PlayerTalentFrame","Blizzard_TalentUI"})
elseif PIG_MaxTocversion(110000) then
	table.insert(UINameList_AddOn,{"ClassTalentFrame","Blizzard_ClassTalentUI",})
else
	--table.insert(UINameList_AddOn,{"PlayerSpellsFrame","Blizzard_PlayerSpells"})--有BUG
end
--拍卖
if PIG_MaxTocversion(50000) then
	table.insert(UINameList_AddOn,{"AuctionFrame","Blizzard_AuctionUI"})
else	
	table.insert(UINameList_AddOn,{"AuctionHouseFrame","Blizzard_AuctionHouseUI"})--拍卖
end

---
local function GetUIConfigDataV(MovingUIName,vvv)
	if vvv=="Scale" then
		if PIGA["Blizzard_UI"][MovingUIName] and PIGA["Blizzard_UI"][MovingUIName]["Scale"] then
			return PIGA["Blizzard_UI"][MovingUIName]["Scale"]
		else
			return 1
		end
	else
		if PIGA["Blizzard_UI"][MovingUIName] and PIGA["Blizzard_UI"][MovingUIName]["Point"] then
			return PIGA["Blizzard_UI"][MovingUIName]["Point"]
		else
			return nil
		end
	end	
end
local function SetUIConfigData(MovingUIName,vvv)
	PIGA["Blizzard_UI"][MovingUIName]=PIGA["Blizzard_UI"][MovingUIName] or {}
	if vvv=="Scale" then
		PIGA["Blizzard_UI"][MovingUIName]["Scale"]=PIGA["Blizzard_UI"][MovingUIName]["Scale"] or 1
	end
end
local function add_Movebiaoti(oldbiaoti)
	local Movebiaoti = CreateFrame("Frame", nil, oldbiaoti);
	Movebiaoti:SetPoint("TOPLEFT",oldbiaoti,"TOPLEFT",0,0);
	Movebiaoti:SetPoint("BOTTOMRIGHT",oldbiaoti,"BOTTOMRIGHT",0,0);
	Movebiaoti:EnableMouse(true)
	return Movebiaoti
end
local PIG_SetPoint=Create.PIG_SetPoint
local function MovingFun(MovingUI,Frame)
	if MovingUI then
		local Frame = Frame or MovingUI
		local MovingUIName=MovingUI:GetName()
		--位置
	 	Frame:RegisterForDrag("LeftButton")
	    Frame:HookScript("OnDragStart",function()
	        MovingUI:StartMoving();
	    end)
	    Frame:HookScript("OnDragStop",function()
	        MovingUI:StopMovingOrSizing()
	        if PIGA["FramePlus"]["BlizzardUI_Move_Save"] then
	        	SetUIConfigData(MovingUIName)
	        	local point, relativeTo, relativePoint, offsetX, offsetY = MovingUI:GetPoint()
	        	local offsetX = floor(offsetX*100+0.5)*0.01
				local offsetY = floor(offsetY*100+0.5)*0.01
	       		PIGA["Blizzard_UI"][MovingUIName]["Point"]={point, relativePoint, offsetX, offsetY}
	       		--if not InCombatLockdown() then SetUIPanelAttribute(MovingUI, "area", nil) end
				-- print(offsetX,offsetY)
				-- SetUIPanelAttribute(MovingUI, "xoffset", offsetX);
				-- SetUIPanelAttribute(MovingUI, "yoffset", offsetY);
	       	end
	    end)
	    MovingUI:HookScript("OnShow",function(self)
	    	if MovingUIName=="WorldMapFrame" then return end
	    	if not InCombatLockdown() and GetUIConfigDataV(MovingUIName) then
		    	PIG_SetPoint(MovingUIName,true)
		    	C_Timer.After(0,function() PIG_SetPoint(MovingUIName,true) end)
		    	C_Timer.After(0.001,function() PIG_SetPoint(MovingUIName,true) end)
		    end
	    end)
	    --缩放
	    local function funxx(self)
	    	MovingUI:EnableMouse(true)
			MovingUI:SetMovable(true)
	 		MovingUI:SetClampedToScreen(true)
	    	MovingUI:SetScale(GetUIConfigDataV(MovingUIName,"Scale"));
			MovingUI:EnableMouseWheel(true) 
	    end
		if MovingUIName=="CollectionsJournal" and InCombatLockdown() then
			MovingUI:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			funxx()
		end
		MovingUI:HookScript("OnEvent", function(self, event)
			if event=="PLAYER_REGEN_ENABLED" then
				funxx()
			end
		end)
	    MovingUI:HookScript("OnMouseWheel", function(self, arg1)
			if IsControlKeyDown() and IsAltKeyDown() then
				SetUIConfigData(MovingUIName,"Scale")
	    		local vera = arg1*0.1
	    		local newbvv = PIGA["Blizzard_UI"][MovingUIName]["Scale"]+vera
	    		if newbvv>=1.8 then
	    			PIG_OptionsUI:ErrorMsg("已达最大缩放比例: 1.8")
	    			PIGA["Blizzard_UI"][MovingUIName]["Scale"]=1.8
	    		elseif newbvv<=0.6 then
	    			PIG_OptionsUI:ErrorMsg("已达最小缩放比例: 0.6")
	    			PIGA["Blizzard_UI"][MovingUIName]["Scale"]=0.6
	    		else
	    			PIGA["Blizzard_UI"][MovingUIName]["Scale"]=newbvv
	    			PIG_OptionsUI:ErrorMsg("当前缩放: "..PIGA["Blizzard_UI"][MovingUIName]["Scale"])
	    		end
	    		if newbvv==1 then PIGA["Blizzard_UI"][MovingUIName]["Scale"]=nil end
	    		self:SetScale(GetUIConfigDataV(MovingUIName,"Scale"));
			end
		end)
	end
end
--
local function SetMovingEvent(v)
	if v[3] then
		for k1,v1 in pairs(v[3]) do
			MovingFun(_G[v[1]],_G[v1])
		end
	else
		MovingFun(_G[v[1]])
	end
end
function FramePlusfun.BlizzardUI_Move()
	if not PIGA['FramePlus']['BlizzardUI_Move'] then return end
	if PIGA["FramePlus"]["BlizzardUI_Move_Save"] then
		local oldshowframe = nil
		hooksecurefunc("UpdateUIPanelPositions", function(Frame)
			local Frame = Frame or oldshowframe
			if Frame and PIGA["Blizzard_UI"][UIName] then
				local UIName = Frame:GetName()
				if UIName then
					oldshowframe=Frame
					if PIGA["Blizzard_UI"][UIName]["Point"] and #PIGA["Blizzard_UI"][UIName]["Point"]>0 then
				    	PIG_SetPoint(UIName,true)
				    end
				end
			end
		end)
	end
	for k,v in pairs(UINameList) do
		if v[2] then
			if v[2]=="add" then
				MovingFun(v[1],add_Movebiaoti(v[3]))
			else
				MovingFun(v[1],v[2])
			end
		else
			MovingFun(v[1])
		end
	end
	for k,v in pairs(UINameList_AddOn) do
		if IsAddOnLoaded(v[2]) then
			SetMovingEvent(v)
	    else
	        local bizzUIFRAME = CreateFrame("Frame")
	        bizzUIFRAME:RegisterEvent("ADDON_LOADED")
	        bizzUIFRAME:SetScript("OnEvent", function(self, event, arg1)
	            if arg1 == v[2] then
	            	self:UnregisterEvent("ADDON_LOADED")
	            	if arg1=="Blizzard_Collections" then
	            		if WardrobeTransmogFrame then
		            		local checkBox = _G.WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox;
						    local label = checkBox.Label;
						    label:ClearAllPoints();
						    label:SetPoint('LEFT', checkBox, 'RIGHT', 2, 1);
						    label:SetPoint('RIGHT', checkBox, 'RIGHT', 160, 1);
						end
					end
					SetMovingEvent(v)
	            end
	        end)
	    end
	end
end