local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
-- local gsub = _G.string.gsub
local match = _G.string.match
-- local lower=string.lower
-- local sub = _G.string.sub
-- local find = _G.string.find
-- local char=string.char
-- local L =addonTable.locale
local Fun = addonTable.Fun
-------------
--LFG副本信息
function Fun.PIG_GetCategories(baseFilters)
	local data={}
	local categories = C_LFGList.GetAvailableCategories(baseFilters);
	for i=1, #categories do
		local categoryID=categories[i]
		local CategoryInfo= C_LFGList.GetLfgCategoryInfo(categoryID)
		local renwuname=CategoryInfo.name:match(QUESTS_LABEL)
		if renwuname then CategoryInfo.name=QUESTS_LABEL end
		table.insert(data, {categoryID,CategoryInfo.name})
	end
	return data
end
--排序
local function ActivitySortComparator(lhs, rhs)
    local lhsMax = lhs[4]
    local rhsMax = rhs[4]
    if lhsMax ~= rhsMax then
        if lhsMax == 0 then
            return false
        elseif rhsMax == 0 then
            return true
        end
        return lhsMax < rhsMax
    end
    local lhsMin = lhs[3]
    local rhsMin = rhs[3]
    if lhsMin ~= rhsMin then
        return lhsMin < rhsMin
    end
    return false
end
local function PIG_GetActivityGroupInfo(groupID)
	local name = C_LFGList.GetActivityGroupInfo(groupID) or ""
	return name:gsub("Raids",RAIDS)
end
-- local function panduancunzaitongName(heji,name1)
-- 	for i=1,#heji do
-- 		if heji[i][1]==name1 then
-- 			return false
-- 		end
-- 	end
-- 	return true
-- end
local FiltersDiy = {[4]="PvE",[8]="PvP"}
local function IsBaseFilters(fullName,baseFilters)
	if FiltersDiy[baseFilters] and fullName:match(FiltersDiy[baseFilters]) then
		return true
	end
	return false
end
Fun.IsBaseFilters=IsBaseFilters
function Fun.PIG_GetGroups(categoryID,baseFilters)
	local data={{},{},{},{}}
	if PIG_MaxTocversion(50000) then
		--活动类型(地下城2/团队114/任务和地图116/PVP118/自定义120)
		local groups = C_LFGList.GetAvailableActivityGroups(categoryID);
		if categoryID==120 then
			local activityInfo= C_LFGList.GetActivityInfoTable(1064)
			table.insert(data[2],{1064,activityInfo.fullName,activityInfo.minLevelSuggestion,activityInfo.maxLevelSuggestion})
		else
			for groupIndex = 1, #groups do
				local groupID = groups[groupIndex];
				if not data[2][groupID] then
					local groupName = PIG_GetActivityGroupInfo(groupID)
					table.insert(data[1],{groupID,groupName})
					data[2][groupID]={}
				end
				local activities = C_LFGList.GetAvailableActivities(categoryID,groupID)
				for ii=1,#activities,1 do
					local activityID=activities[ii]
					local activityInfo= C_LFGList.GetActivityInfoTable(activityID)
					table.insert(data[2][groupID],{activityID,activityInfo.fullName,activityInfo.minLevelSuggestion,activityInfo.maxLevelSuggestion})
					if categoryID==2 or categoryID==114 then
						if not data[4][activityInfo.difficultyID] then
							local DifficultyName = GetDifficultyInfo(activityInfo.difficultyID) or NONE
							data[4][activityInfo.difficultyID]={activityInfo.difficultyID,DifficultyName}
						end
					else

					end
				end
				table.sort(data[2][groupID], ActivitySortComparator)
			end
			for k,v in pairs(data[4]) do
				table.insert(data[3],v)
			end
			-- table.sort(data[3], function(a, b)
			--     return a[1] < b[1]
			-- end)
		end
	else
		--活动类型(任务1/地下城2/团队3/竞技场4/自定义6/竞技场练习赛7/战场8/评级战场9/海岛探险111/121地下堡)
		local activities = C_LFGList.GetAvailableActivities(categoryID);
		for ii=1,#activities do
			local activityID=activities[ii]
			local activityInfo = C_LFGList.GetActivityInfoTable(activityID);
			if categoryID==1 then
				if not data[2][activityInfo.groupFinderActivityGroupID] then
					local groupName, groupOrderIndex = C_LFGList.GetActivityGroupInfo(activityInfo.groupFinderActivityGroupID);
					table.insert(data[1],{activityInfo.groupFinderActivityGroupID,groupName})
					data[2][activityInfo.groupFinderActivityGroupID]={}
				end
				table.insert(data[2][activityInfo.groupFinderActivityGroupID], {activityID,activityInfo.fullName,activityInfo.shortName})
			elseif categoryID==2 or categoryID==3 then
				if not data[2][activityInfo.difficultyID] then
					local DifficultyName = GetDifficultyInfo(activityInfo.difficultyID) or NONE
					table.insert(data[1],{activityInfo.difficultyID,DifficultyName})
					data[2][activityInfo.difficultyID]={}
				end
				table.insert(data[2][activityInfo.difficultyID], {activityID,activityInfo.fullName,activityInfo.shortName})
			elseif categoryID==6 or categoryID==121 then--自定义6/121地下堡
				if categoryID==6 then
					if baseFilters==4 or baseFilters==8 then
						if IsBaseFilters(activityInfo.fullName,baseFilters) then
							table.insert(data[2], {activityID,activityInfo.fullName,activityInfo.shortName})
						end
					else
						table.insert(data[2], {activityID,activityInfo.fullName,activityInfo.shortName})
					end
				else
					table.insert(data[2], {activityID,activityInfo.fullName,activityInfo.shortName})
				end
			else--if categoryID==4 or categoryID==7 then
				table.insert(data[2], {activityID,activityInfo.fullName,activityInfo.shortName})
			end
		end
		if #data[1]>0 then
			for diffID, group in pairs(data[2]) do
				table.sort(group, function(a, b)
					return a[1] < b[1]  --按activityID升序
				end)
			end
		end
	end
	return data[1],data[2],data[3]
end
function Fun.GetGroupName(selectedGroup,Groups)
	for Gid=1,#Groups do
		if selectedGroup==Groups[Gid][1] then
			return Groups[Gid][2]
		end
	end
	return NONE
end
function Fun.GetactivityName(selectedActivity,activities)
	for Gid=1,#activities do
		if selectedActivity==activities[Gid][1] then
			return activities[Gid][2]
		end
	end
	return NONE
end
function Fun.IsAvailGroups(activityID,Groups,Radio)
	if Radio then
		for i=1,#Groups do
			if activityID[Groups[i][1]] then
				return true
			end
		end
	else
		for i=1,#Groups do
			if Groups[i][1]==activityID then
				return true
			end
		end
	end
	return false
end


-- 	local function IsGroupsID(data,id)
-- 	    for i=1,#data do
-- 	    	if data[i]==id then
-- 	    		return true
-- 	    	end
-- 	    end
-- 	    return false
-- 	end
	-- function InvF.GetActivities(Ndata,selectedCategory,group)
	-- 	wipe(Ndata)
	-- 	if selectedCategory then
	-- 		Ndata.groups={}
	-- 		Ndata.Activs={}
	-- 		local Activities = C_LFGList.GetAvailableActivities(selectedCategory)
	-- 		for k,v in pairs(Activities) do
	-- 			local ActivityInfo= C_LFGList.GetActivityInfoTable(v)
	-- 			-- print(ActivityInfo.fullName,ActivityInfo.filters)
	-- 			-- for k,v in pairs(ActivityInfo) do
	-- 			-- 	--print(k,v)
	-- 			-- end
	-- 			local groupID=ActivityInfo.difficultyID..ActivityInfo.filters
	-- 			--local groupID=ActivityInfo.groupFinderActivityGroupID
	-- 			if not IsGroupsID(Ndata.groups,groupID) then
	-- 				local Difficultyname = GetDifficultyInfo(ActivityInfo.difficultyID)
	-- 				--local groupname = PIG_GetActivityGroupInfo(groupID);
	-- 				--print(ActivityInfo.groupFinderActivityGroupID,Difficultyname,groupname)
	-- 				table.insert(Ndata.groups,{groupID,Difficultyname..ActivityInfo.filters})
	-- 				Ndata.Activs[groupID]={}
	-- 				print(Difficultyname..ActivityInfo.filters)
	-- 			end
	-- 			-- if groupID==300 then
	-- 			-- 	if panduancunzaitongName(Ndata.Activs[groupID],ActivityInfo.fullName) then
	-- 			-- 		table.insert(Ndata.Activs[groupID],{ActivityInfo.fullName,Activities[ii],ActivityInfo.minLevelSuggestion,ActivityInfo.maxLevelSuggestion})
	-- 			-- 	end
	-- 			-- else
	-- 			-- 	table.insert(Ndata.Activs[groupID],{ActivityInfo.fullName,Activities[ii],ActivityInfo.minLevelSuggestion,ActivityInfo.maxLevelSuggestion})
	-- 			-- end
	-- 		end
	-- 		for k,v in pairs(Ndata.Activs) do
	-- 			table.sort(v, ActivitySortComparator)
	-- 		end
	-- 		for i=1,#Ndata.groups do
	-- 			--print(Ndata.groups[i][1],Ndata.groups[i][2])
	-- 		end
	-- 		-- local ActivityGroups = C_LFGList.GetAvailableActivityGroups(selectedCategory)
	-- 		-- for i=1,#ActivityGroups,1 do
	-- 		-- 	local groupID = ActivityGroups[i];
	-- 		-- 	local groupname = PIG_GetActivityGroupInfo(groupID);
	-- 		-- 	table.insert(Ndata.groups,{groupID,groupname})
	-- 		-- 	Ndata.Activs[groupID]={}
				
	-- 		-- 	local Activities = C_LFGList.GetAvailableActivities(selectedCategory,groupID)
	-- 		-- 	for ii=1,#Activities,1 do
	-- 		-- 		local ActivityInfo= C_LFGList.GetActivityInfoTable(Activities[ii])
	-- 		-- 		--print(groupname,ActivityInfo.fullName)
	-- 		-- 		if groupID==300 then
	-- 		-- 			if panduancunzaitongName(Ndata.Activs[groupID],ActivityInfo.fullName) then
	-- 		-- 				table.insert(Ndata.Activs[groupID],{ActivityInfo.fullName,Activities[ii],ActivityInfo.minLevelSuggestion,ActivityInfo.maxLevelSuggestion})
	-- 		-- 			end
	-- 		-- 		else
	-- 		-- 			table.insert(Ndata.Activs[groupID],{ActivityInfo.fullName,Activities[ii],ActivityInfo.minLevelSuggestion,ActivityInfo.maxLevelSuggestion})
	-- 		-- 		end
	-- 		-- 	end
	-- 		-- 	table.sort(Ndata.Activs[groupID], ActivitySortComparator)
	-- 		-- end
	-- 	end
	-- end
--副本数据
-- local InstanceList = {{NONE,0}}
-- local InstanceID_id = {
-- 	["Party"]={
-- 		["Vanilla"]={33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,329,349,389,429,},
-- 		["TBC"]={269,540,542,543,545,546,547,552,553,554,555,556,557,558,560,585,},
-- 		["WLK"]={574,575,576,578,595,599,600,601,602,604,608,619,632,650,658,668,},
-- 	},
-- 	["Raid"] = {
-- 		["Vanilla"]={309,409,469,509,531},
-- 		["TBC"]={532,534,544,548,550,564,565,580},
-- 		["WLK"]={603,615,616,624,631,649,724},
-- 	},
-- }
-- if PIG_MaxTocversion(20000) then
-- 	table.insert(InstanceList,{DUNGEONS,"Party","Vanilla"})
-- 	table.insert(InstanceList,{GUILD_INTEREST_RAID,"Raid","Vanilla"})
-- 	table.insert(InstanceID_id["Raid"]["Vanilla"],249)--奥妮克希亚的巢穴
-- 	table.insert(InstanceID_id["Raid"]["Vanilla"],533)--纳克萨玛斯
-- else
-- 	table.insert(InstanceList,{DUNGEONS,"Party","Vanilla"})
-- 	table.insert(InstanceList,{DUNGEONS.."(TBC)","Party","TBC"})
-- 	table.insert(InstanceList,{GUILD_INTEREST_RAID,"Raid","Vanilla"})
-- 	table.insert(InstanceList,{GUILD_INTEREST_RAID.."(TBC)","Raid","TBC"})
-- 	if PIG_MaxTocversion(30000) then
-- 		table.insert(InstanceID_id["Raid"]["Vanilla"],249)
-- 		table.insert(InstanceID_id["Raid"]["Vanilla"],533)
-- 	else
-- 		table.insert(InstanceList,4,{DUNGEONS.."(WLK)","Party","WLK"})
-- 		table.insert(InstanceList,{GUILD_INTEREST_RAID.."(WLK)","Raid","WLK"})
-- 		table.insert(InstanceID_id["Raid"]["WLK"],249)
-- 		table.insert(InstanceID_id["Raid"]["WLK"],533)
-- 	end
-- end
--Data.FBdata={InstanceList,InstanceID}
-- local FBdataUI = CreateFrame("Frame")
-- FBdataUI.jicinum=0
-- FBdataUI.FBindex = {}
-- FBdataUI.FBindexName = {}
-- FBdataUI.FBdata = {}
-- FBdataUI.FBName = {["Category"]={},["Group"]={},["Difficulty"]={}}
-- FBdataUI:RegisterEvent("PLAYER_LOGIN");
-- local tihuankuohao=addonTable.Fun.tihuankuohao
-- local function Getfubendata()
-- 	if #C_LFGList.GetAvailableCategories()==0 and FBdataUI.jicinum<10 then
-- 		C_Timer.After(0.1,Getfubendata)
-- 		FBdataUI.jicinum=FBdataUI.jicinum+1
-- 		return
-- 	end
-- 	if PIG_MaxTocversion(40000) then
-- 		--系统活动类型(地下城2/团队114/任务和地图116/PVP118/自定义120)
-- 		local categories = C_LFGList.GetAvailableCategories();
-- 		for i=1, #categories do
-- 			local categoryID=categories[i]
-- 			if categoryID==2 or categoryID==114 then
-- 				local CategoryInfo= C_LFGList.GetLfgCategoryInfo(categoryID)
-- 				local activityGroups = C_LFGList.GetAvailableActivityGroups(categoryID);
-- 				for _,groupID in ipairs(activityGroups) do
-- 					local groupName, groupOrderIndex = C_LFGList.GetActivityGroupInfo(groupID);
-- 					local NewIDID = tonumber(categoryID..groupID)
-- 					if PIG_MaxTocversion(20000) or CategoryInfo.name==groupName then
-- 						FBdataUI.FBName.Category[NewIDID]=CategoryInfo.name
-- 					else
-- 						FBdataUI.FBName.Category[NewIDID]=CategoryInfo.name.."-"..groupName
-- 					end
-- 					FBdataUI.FBdata[NewIDID]={}
-- 					local activities = C_LFGList.GetAvailableActivities(categoryID,groupID)
-- 					for _,activityID in pairs(activities) do
-- 						local activityInfo = C_LFGList.GetActivityInfoTable(activityID);
-- 						local fullName = tihuankuohao(activityInfo.fullName)
-- 						FBdataUI.FBdata[NewIDID][activityID]={fullName,activityInfo.shortName}
-- 						-- if categoryID==114 then
-- 						-- 	if groupID==288 then
-- 						-- 		print(CategoryInfo.name.."-"..groupName,activityID,fullName,activityInfo.shortName)
-- 						-- 		if string.match(groupName,EXPANSION_NAME2) then
-- 						-- 		end
-- 						-- 	end
-- 						-- end
-- 					end	
-- 				end
-- 			end
-- 		end
-- 		for k,v in pairs(FBdataUI.FBdata) do
-- 			table.insert(FBdataUI.FBindex, k)
-- 		end
-- 		table.sort(FBdataUI.FBindex, function(a, b) return tonumber(a) < tonumber(b) end)
-- 	else
-- 		--系统活动类型(任务1/地下城2/团队3/竞技场4/自定义6/竞技场练习赛7/战场8/评级战场9/海岛探险111/121地下堡)
-- 		local categories = C_LFGList.GetAvailableCategories();
-- 		for i=1, #categories do
-- 			local categoryID=categories[i]
-- 			if not FBdataUI.FBindex[categoryID] then
-- 				FBdataUI.FBindex[categoryID]={}
-- 				FBdataUI.FBdata[categoryID]={}
-- 				--FBdataUI.FBindexName[categoryID]=CategoryInfo.name
-- 			end
-- 			local CategoryInfo= C_LFGList.GetLfgCategoryInfo(categoryID)
-- 			--print(categoryID,CategoryInfo.name)
-- 			FBdataUI.FBName.Category[categoryID]=CategoryInfo.name
-- 			if categoryID==2 or categoryID==3 then
-- 				local activities = C_LFGList.GetAvailableActivities(categoryID);
-- 				for ii=1,#activities do
-- 					local activityID=activities[ii]
-- 					local activityInfo = C_LFGList.GetActivityInfoTable(activityID);
-- 					local Difficultyname = GetDifficultyInfo(activityInfo.difficultyID) or NONE
-- 					--local Difficultyname = tihuankuohao(Difficultyname)
-- 					FBdataUI.FBName.Difficulty[activityInfo.difficultyID]=Difficultyname
-- 					local fullName = tihuankuohao(activityInfo.fullName)
-- 					if tonumber(activityInfo.difficultyID)>0 and Difficultyname then
-- 						if activityID==1506 then
-- 							activityInfo.difficultyID=15
-- 						end
-- 						--local Difficultyname = tihuankuohao(Difficultyname)
-- 						--print(categoryID,activityInfo.difficultyID)
-- 						local NewIDID = categoryID+activityInfo.difficultyID
-- 						--local NewIDID = tonumber(categoryID..activityInfo.difficultyID)
-- 						-- if not FBdataUI.FBName.Category[NewIDID] then
-- 						-- 	FBdataUI.FBName.Category[NewIDID]= {}
-- 						-- 	FBdataUI.FBName.Category[NewIDID]=CategoryInfo.name.."-"..Difficultyname
-- 						-- 	--table.insert(FBdataUI.FBindex, NewIDID)
-- 						-- end
-- 						--print(FBdataUI.FBdata[categoryID],fullName,activityInfo.shortName)
-- 						if not FBdataUI.FBindex[categoryID][NewIDID] then
-- 							--FBdataUI.FBindex[categoryID][NewIDID]= {}
							
-- 						end
-- 						if not FBdataUI.FBdata[categoryID][NewIDID] then
-- 							FBdataUI.FBdata[categoryID][NewIDID]={}
-- 							table.insert(FBdataUI.FBindex[categoryID], {categoryID,activityInfo.difficultyID})
-- 						end
-- 						FBdataUI.FBdata[categoryID][NewIDID][activityID]={fullName,activityInfo.shortName}

-- 						-- FBdataUI.FBName.Category[NewIDID]=CategoryInfo.name.."-"..Difficultyname
-- 						-- FBdataUI.FBdata[NewIDID]=FBdataUI.FBdata[NewIDID] or {}
-- 						-- FBdataUI.FBdata[NewIDID][activityID]={fullName,activityInfo.shortName}
-- 					else
-- 						FBdataUI.FBName.Category[categoryID]=CategoryInfo.name
-- 						FBdataUI.FBdata[categoryID]=FBdataUI.FBdata[categoryID] or {}
-- 						FBdataUI.FBdata[categoryID][activityID]={fullName,activityInfo.shortName}
-- 					end
-- 					-- if categoryID==2 then
-- 					-- 	--print(categoryID,activityID,fullName,activityInfo.shortName)
-- 					-- 	for k2,v2 in pairs(activityInfo) do
-- 					-- 		-- if activityID==4 or activityID==1505 then
-- 					-- 		-- 	print(categoryID,activityID,activityInfo.difficultyID,k2,v2)
-- 					-- 		-- end
-- 					-- 	end
-- 					-- end
-- 				end
-- 			end
-- 		end
-- 	end
-- 	Data.FBindex=FBdataUI.FBindex
-- 	Data.FBdata=FBdataUI.FBdata
-- 	Data.FBName=FBdataUI.FBName
-- end
-- FBdataUI:SetScript("OnEvent", function(self,event)
-- 	Getfubendata()
-- end)
	--InvF.FavoriteFilters={}
	-- InvF.ActTypeFilters={}
	-- InvF.FilterData3={}
	-- fujiF.F.CategorieCC=0
	-- local function GetCategorieData(baseFilters)
	-- 	local listD,nameD={},{}
	-- 	local cunzail = C_LFGList.GetAvailableCategories()
	-- 	if #cunzail==0 and fujiF.F.CategorieCC<5 then
	-- 		fujiF.F.CategorieCC=fujiF.F.CategorieCC+1
	-- 		C_Timer.After(0.1,function() GetCategorieData() end)
	-- 	else
	-- 		--系统活动类型(地下城2/团队114/任务和地图116/PVP118/自定义120){{DUNGEONS,2},{GUILD_INTEREST_RAID,114},{OTHER,120}}--活动类型
	-- 		--1任务2地下城3团队副本6自定义121地下堡
	-- 		--local baseFilters = LFGListFrame and LFGListFrame.baseFilters;
	-- 		for _,v in pairs(C_LFGList.GetAvailableCategories(baseFilters)) do
	-- 			--InvF.FavoriteFilters[v]={ALL,FAVORITES.."司机"}--,IGNORE.."司机"
	-- 			if C_LFGList.GetPremadeGroupFinderStyle()==1 then
	-- 			elseif C_LFGList.GetPremadeGroupFinderStyle()==2 then
	-- 				InvF.ActTypeFilters[v]={ALL,L["TARDIS_CHEDUI_1"],L["TARDIS_CHEDUI_2"]}
	-- 				---90001-欢迎新手90002-适合当前级别
	-- 				InvF.FilterData3[v]={{"符合"..LEVEL,90001},{LFG_LIST_NEW_PLAYER_FRIENDLY_HEADER,90002}}
	-- 			end
	-- 			local kkdfin= C_LFGList.GetLfgCategoryInfo(v)
	-- 			local renwuname=kkdfin.name:match(QUESTS_LABEL)
	-- 			--print(v,kkdfin.name)
	-- 			if renwuname then
	-- 				nameD[kkdfin.name]=QUESTS_LABEL
	-- 				kkdfin.name=QUESTS_LABEL
	-- 			end
	-- 			if kkdfin.name==CUSTOM then
	-- 				table.insert(listD,{v,kkdfin.name})
	-- 			else
	-- 				table.insert(listD,{v,kkdfin.name})
	-- 			end
	-- 		end
	-- 		for i=1,#listD do
	-- 			if listD[i][1]==114 then
	-- 				table.remove(listD,i);
	-- 				table.insert(listD,1,{114,GUILD_INTEREST_RAID})
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- 	return listD,nameD
	-- end

-- function PIG_Activities(categoryID,farm)
-- 	local data={}
-- 	local activities = C_LFGList.GetAvailableActivities(categoryID);
-- 	for ii=1,#activities do
-- 		local activityID=activities[ii]
-- 		--local activityInfo = C_LFGList.GetActivityInfoTable(activityID);
-- 		-- local Difficultyname = GetDifficultyInfo(activityInfo.difficultyID) or NONE
-- 		table.insert(data, activityID)
-- 	end
-- 	return data
-- end
-- local Categories=PIG_GetCategories()
-- for i=1,#Categories do
-- 	print(Categories[i][2])
-- end

--获取队伍等级
local is_slist=Fun.is_slist
function Fun.Get_GroupLv()
	if is_slist() then return "G#0#0#0#0";end
	local MsgNr="";
	if IsInRaid() then
		MsgNr = "R#40#"..GetNumGroupMembers()
	elseif IsInGroup() then
		MsgNr="G#"
		for id = 1, MAX_PARTY_MEMBERS, 1 do
			if UnitExists("Party"..id) then
				local dengjiKk = UnitLevel("Party"..id)
				if id==numgroup then
					MsgNr=MsgNr..dengjiKk
				else
					MsgNr=MsgNr..dengjiKk.."#";
				end
			else
				if id==numgroup then
					MsgNr=MsgNr.."-"
				else
					MsgNr=MsgNr.."-".."#";
				end
			end
		end
	else
		MsgNr="G#-#-#-#-";
	end
	return MsgNr
end
function Fun.Get_GroupLvTxt()
	if is_slist() then return Fun.Base64_decod("LOmYn+WGhSgwLDAsMCwwKQ=="); end
	if IsInRaid() then
		local numgroup =GetNumGroupMembers()
		if numgroup>0 then
			local MsgNr=",队内("
			for id=2,numgroup do
				local name, rank, subgroup, dengjiKk = GetRaidRosterInfo(id)
				if name and PIGA_Per["Farm"]["Other_RaidMode"] and PIGA_Per["Farm"]["Other_RaidModeShow"][subgroup] then
					MsgNr=MsgNr..dengjiKk..",";
				end
			end
			MsgNr=MsgNr..")";
			return MsgNr
		end
	elseif IsInGroup() then
		local numgroup = GetNumSubgroupMembers()
		if numgroup>0 then
			local MsgNr=",队内("
			for id=1,numgroup do
				local dengjiKk = UnitLevel("Party"..id);
				if id==numgroup then
					MsgNr=MsgNr..dengjiKk..")";
				else
					MsgNr=MsgNr..dengjiKk..",";
				end
			end
			return MsgNr
		end
	end
	return ""
end
local function IsdanjiaOK(fubenID,danjiaCF)
	if danjiaCF[fubenID] then
		local hangD=danjiaCF[fubenID]
		for id = 1, 4, 1 do
			if hangD[id][1]>0 and hangD[id][2]>0 then
				return danjiaCF[fubenID]
			end
		end
	end
	return false
end
--根据等级计算单价
function Fun.Get_LvDanjia(lv,fubenID,danjiaCF)
	if lv==0 then return 0 end
	if is_slist() then return 0 end
	local hangD = IsdanjiaOK(fubenID,danjiaCF)
	if hangD then
		for id = 1, 4, 1 do
			local SavetG = hangD[id]
			if SavetG[1]>0 and SavetG[2]>0 then
				if lv>=SavetG[1] and lv<=SavetG[2] then
					return SavetG[3]
				end
			end
		end
	end
	return 0
end
--获取所带副本级别单价文本
function Fun.Get_LvDanjiaYC(fubenID,danjiaCF)
	if is_slist() then return "-" end
	local hangD = IsdanjiaOK(fubenID,danjiaCF)
	if hangD then
		local MsgNr = ""
		for id = 1, 4, 1 do
			local SavetG = hangD[id]
			if SavetG[1]>0 and SavetG[2]>0 then
				MsgNr=MsgNr..SavetG[1].."@"..SavetG[2].."@"..SavetG[3].."#"
			end
		end
		local MsgNr = MsgNr:sub(1,-2)
		return MsgNr
	end
	return "-"
end
function Fun.Get_LvDanjiaTxt(fubenID,danjiaCF)
	if is_slist() then
		return Fun.Base64_decod("PDEtODA+5YWN6LS5")
	end
	local MsgNr = ""
	local hangD = IsdanjiaOK(fubenID,danjiaCF)
	if hangD then
		for id = 1, 4, 1 do
			local SavetG = hangD[id]
			if SavetG[1]>0 and SavetG[2]>0 then
				if SavetG[3]>0 then
					MsgNr=MsgNr.."<"..SavetG[1].."-"..SavetG[2]..">"..SavetG[3].."G"
				else
					MsgNr=MsgNr.."<"..SavetG[1].."-"..SavetG[2]..">"..Fun.Base64_decod("5YWN6LS5")
				end
			end
		end
	end
	return MsgNr
end
--获取设置的最小和最大级别
local function Get_LVminmax(fubenID,danjiaCF)
	if is_slist() then return 0,0 end
	local min,max = nil,nil
	local hangD = IsdanjiaOK(fubenID,danjiaCF)
	if hangD then
		for id = 1, 4, 1 do
			local SavetG = hangD[id]
			if SavetG[1]>0 and SavetG[2]>0 then
				if min then
					if SavetG[1]<min then
						min=SavetG[1]
					end
				else
					min=SavetG[1]
				end
				if max then
					if SavetG[2]>max then
						max=SavetG[2]
					end
				else
					max=SavetG[2]
				end
			end
		end
	end
	return min or 0,max or 0	
end
function Fun.Get_LVminmaxTxt(fubenID,danjiaCF)
	local min,max = Get_LVminmax(fubenID,danjiaCF)
	return min.."#"..max
end