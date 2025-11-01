local addonName, addonTable = ...;
local L=addonTable.locale
local Data=addonTable.Data
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGFontString=Create.PIGFontString
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGOptionsList_RF=Create.PIGOptionsList_RF
--
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
---
local PigConfigFun={}
addonTable.PigConfigFun=PigConfigFun
local fuFrame,fuFrameBut = PIGOptionsList(L["CONFIG_TABNAME"],"TOP")
PigConfigFun.fuFrame=fuFrame
PigConfigFun.fuFrameBut=fuFrameBut
--
local RTabFrame =Create.PIGOptionsList_RF(fuFrame)
local fujiF,fujiBut =PIGOptionsList_R(RTabFrame,L["CONFIG_DAOCHU"]..L["CONFIG_DAORU"],90)
fujiF:Show()
fujiBut:Selected()
--------
local cfbutW=fujiF:GetWidth()-20
local BiaotiName = CHAT_DEFAULT..L["CONFIG_TABNAME"]
local DefaultF=PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-10},{cfbutW,60})
DefaultF:PIGSetBackdrop(0.4)
DefaultF.button = PIGButton(DefaultF,{"LEFT",DefaultF,"LEFT",10,0},{90,24},BiaotiName)
DefaultF.title = PIGFontString(DefaultF,{"LEFT", DefaultF.button, "RIGHT", 6, 0},L["CONFIG_ERRTIPS"])
DefaultF.title:SetTextColor(0, 1, 0, 1);
DefaultF.title:SetJustifyH("LEFT");
DefaultF.title:SetWidth(cfbutW-120);
DefaultF.button:SetScript("OnClick", function ()
	StaticPopup_Show("PIG_CONFIG_ZAIRUQUEREN",BiaotiName,nil,{"Default",BiaotiName});
end);
StaticPopupDialogs["PIG_CONFIG_ZAIRUQUEREN"] = {
	text = L["CONFIG_LOADTIPS"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self,arg1)
		if addonTable[arg1[1]] then
			PIGA=addonTable[arg1[1]];
			PIGA_Per=addonTable[arg1[1].."_Per"];
			if DefaultF.ResetShareConfig then DefaultF.ResetShareConfig() end
			ReloadUI()
		else
			PIG_OptionsUI:ErrorMsg(string.format(ERR_ARENA_TEAM_PLAYER_NOT_FOUND_S,arg1[2]),"R")
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
--配置-------------------
local function Remove_Data(newdata,Per)--剔除数据类配置
	if Per then
		newdata["AutoSellBuy"]["Buy_List"]=nil
		newdata["AutoSellBuy"]["Save_List"]=nil
		newdata["AutoSellBuy"]["Take_List"]=nil
		--
		newdata["PigAction"]["ActionData"]=nil
		newdata["QuickBut"]["ActionData"]=nil
		newdata["QuickBut"]["EquipList"]=nil
		newdata["QuickBut"]["TrinketList"]=nil
		--
		newdata["Farm"]=nil
		-- if IsAddOnLoaded("!Pig_Farm") then
		-- 	newdata["Farm"]["Fuben_G"]=nil
		-- 	newdata["Farm"]["Auto_KeyList"]=nil
		-- 	newdata["Farm"]["Namelist"]=nil
		-- 	newdata["Farm"]["Timelist"]=nil
		-- end
	else
		--非必要信息
		newdata["Ver"]=nil
		newdata["Error"]["ErrorDB"]=nil
		newdata["ActionBarEnabled"]=nil
		--
		newdata["Hardcore"]["Deaths"]["Player"]=nil
		newdata["Hardcore"]["Deaths"]["List"]=nil
		--信息统计
		newdata["StatsInfo"]["Players"]=nil
		newdata["StatsInfo"]["PlayerSH"]=nil
		newdata["StatsInfo"]["InstancesCD"]=nil
		newdata["StatsInfo"]["SkillData"]=nil
		newdata["StatsInfo"]["Times"]=nil
		newdata["StatsInfo"]["Token"]=nil
		newdata["StatsInfo"]["Items"]=nil
		newdata["StatsInfo"]["TradeData"]=nil
		newdata["StatsInfo"]["AHData"]=nil
		--邮箱
		newdata["MailPlus"]["Coll"]=nil
		--售卖助手
		newdata["AutoSellBuy"]["Diuqi_List"]=nil
		newdata["AutoSellBuy"]["Sell_List"]=nil
		newdata["AutoSellBuy"]["Sell_Lsit_Filtra"]=nil
		newdata["AutoSellBuy"]["Open_List"]=nil
		newdata["AutoSellBuy"]["Fen_List"]=nil
		newdata["AutoSellBuy"]["Xuan_List"]=nil
		--AH
		newdata["AHPlus"]["CacheData"]=nil
		newdata["AHPlus"]["Coll"]=nil
		--聊天
		newdata["Chat"]["Channel_List"]=nil
		--聊天记录
		newdata["Chatjilu"]["WHISPER"]["record"]=nil
		newdata["Chatjilu"]["PARTY"]["record"]=nil
		newdata["Chatjilu"]["RAID"]["record"]=nil
		newdata["Chatjilu"]["GUILD"]["record"]=nil
		newdata["Chatjilu"]["INSTANCE_CHAT"]["record"]=nil
		--界面扩展
		newdata["FramePlus"]["AddonStatus"]=nil
		--扩展
		newdata["Tardis"]=nil
		newdata["GDKP"]=nil
		newdata["ConfigString"]=nil
		-- if IsAddOnLoaded("!Pig_Tardis") then
		-- 	newdata["Tardis"]["Plane"]["InfoList"]=nil
		-- end
		-- if IsAddOnLoaded("!Pig_GDKP") then
		-- 	newdata["GDKP"]["PaichuList"]=nil
		-- 	newdata["GDKP"]["ItemList"]=nil
		-- 	newdata["GDKP"]["History"]=nil
		-- 	newdata["GDKP"]["instanceName"]=nil
		-- end
	end
end
local function GetConfigNoData()--获取剔除数据后的默认配置
	local newdata={{},{}}
	newdata[1] = PIGCopyTable(addonTable.Default)
	Remove_Data(newdata[1])
	--Per
	newdata[2] = PIGCopyTable(addonTable.Default_Per)
	Remove_Data(newdata[2],true)
	return newdata[1],newdata[2]
end
--导入配置-------------------
local function Load_ImportTxt_1(newV,DqCF)
	for k,v in pairs(newV) do
		if type(v) == "table" then
			if type(DqCF[k]) == "table" then
				Load_ImportTxt_1(v,DqCF[k])
			else
				DqCF[k]=v 
			end
		else
			DqCF[k]=v
		end
	end
end
local function LoadSameValue(tabX,tabX_Per)
	local newtab,newtab_Per=GetConfigNoData()
	Load_ImportTxt_1(tabX,newtab)
	Load_ImportTxt_1(tabX_Per,newtab_Per)
	return newtab,newtab_Per
end
DefaultF.daorubut = PIGButton(DefaultF,{"TOPLEFT",DefaultF,"TOPLEFT",10, -200},{90,24},L["CONFIG_DAORU"]..L["CONFIG_TABNAME"])
DefaultF.daorubut:SetScript("OnClick", function ()
	_G[Data.ExportImportUIname]:daoruFun(addonName..ADDONS..L["CONFIG_TABNAME"],LoadSameValue)	
end);

--导出配置--------------------------
local ConfigUIList={PlayerFrame,TargetFrame,FocusFrame,}--如果选择则导出头像位置
local function Get_ExtData(newdata,Per)
	if Per then return end
	if DefaultF.I_ActionBar:GetChecked() then
		newdata["Config_ActionBar"] = {GetActionBarToggles()}
	else
		newdata["Config_ActionBar"]=nil
	end
	if DefaultF.I_UnitF:GetChecked() then--获取头像位置信息
		for k,v in pairs(ConfigUIList) do
	    	local uiname = v:GetName()
	    	if uiname then
	    		newdata["Config_Unit"]=newdata["Config_Unit"] or {}
	    		if v:IsUserPlaced() then
		        	local point, relativeTo, relativePoint, offsetX, offsetY = v:GetPoint()
		       		newdata["Config_Unit"][uiname]={point, relativePoint, offsetX, offsetY}
		       	else
		       		newdata["Config_Unit"][uiname]=nil
		       	end
		    end
		end
		if next(newdata["Config_Unit"])==nil then newdata["Config_Unit"]=nil end
	else
		newdata["Config_Unit"]=nil
	end
end
local function is_equal(value1, value2, memo)
    memo = memo or {}
    local memoKey = tostring(value1) .. ":" .. tostring(value2)
    if memo[memoKey] then return true end
    memo[memoKey] = true
    if type(value1) ~= type(value2) then return false end
    if type(value1) == "table" then
        if getmetatable(value1) and getmetatable(value1).__eq then
            return value1 == value2
        end
        local function is_array(t)
            local i = 0
            for k in pairs(t) do
                if type(k) ~= "number" or k <= 0 or k > #t or math.floor(k) ~= k then
                    return false
                end
                i = i + 1
            end
            return i == #t
        end
        if is_array(value1) and is_array(value2) then
            if #value1 ~= #value2 then return false end
            for i = 1, #value1 do
                if not is_equal(value1[i], value2[i], memo) then return false end
            end
            return true
        else
            for k, v in pairs(value1) do
                if not is_equal(v, value2[k], memo) then return false end
            end
            for k, _ in pairs(value2) do
                if value1[k] == nil then return false end
            end
            return true
        end
    else
        return value1 == value2
    end
end
local function Remove_RepeatValues(NewDataX, moren)
    for key, value in pairs(moren) do
        if NewDataX[key] ~= nil and is_equal(NewDataX[key], value) then
            NewDataX[key] = nil
        elseif type(NewDataX[key]) == "table" and type(value) == "table" then
        	if next(NewDataX[key])==nil and next(value)==nil then
            	NewDataX[key] = nil
            else
	            Remove_RepeatValues(NewDataX[key], value)
            	if next(NewDataX[key])==nil and next(value)==nil then
                	NewDataX[key] = nil
                end
	        end
        end
    end
end
local function PIGCopyTable_Duplicates_1(old,moren,Per)
	local NewDataX = PIGCopyTable(old)
	if not DefaultF.I_Data:GetChecked() then
		Remove_Data(NewDataX,Per)
	end
	Get_ExtData(NewDataX,Per)
	Remove_RepeatValues(NewDataX,moren)
	return NewDataX
end
local function PIGCopyTable_Duplicates()
	local NewDataX = PIGCopyTable_Duplicates_1(PIGA, addonTable.Default)
	local NewDataX_Per = PIGCopyTable_Duplicates_1(PIGA_Per, addonTable.Default_Per, true)
	return NewDataX,NewDataX_Per
end
DefaultF.daochubut = PIGButton(DefaultF,{"TOPLEFT",DefaultF.daorubut,"BOTTOMLEFT",0, -20},{90,24},L["CONFIG_DAOCHU"]..L["CONFIG_TABNAME"])
DefaultF.daochubut:SetScript("OnClick", function ()
	-- local NewDataX,NewDataX_Per =PIGCopyTable_Duplicates()
	-- for k,v in pairs(NewDataX) do
	-- 	if type(v)=="table" then
	-- 		--if k~="Pig_UI" then
	-- 			for k1,v1 in pairs(v) do
	-- 				if type(v1)=="table" then
	-- 					for k2,v2 in pairs(v1) do
	-- 						if type(v2)=="table" then
	-- 							for k3,v4 in pairs(v2) do
	-- 								print(k,k1,k2,v2,k3,v4)
	-- 							end
	-- 						else
	-- 							print(k,k1,k2,v2)
	-- 						end
	-- 					end
	-- 				else
	-- 					print(k,k1,v1)
	-- 				end
	-- 			end
	-- 		--end
	-- 	else
	-- 		print(k,v)
	-- 	end
	-- end
	_G[Data.ExportImportUIname]:daochuFun(addonName..ADDONS..L["CONFIG_TABNAME"],PIGCopyTable_Duplicates())
end);
DefaultF.I_UnitF=PIGCheckbutton(DefaultF,{"LEFT",DefaultF.daochubut,"RIGHT",20, 0},{"导出包含头像位置（自身/目标/焦点）","导出信息将包含头像位置数据，虽然这并不属于插件本身配置信息"})
DefaultF.I_UnitF:SetChecked(true)
DefaultF.I_ActionBar=PIGCheckbutton(DefaultF,{"TOPLEFT",DefaultF.I_UnitF,"BOTTOMLEFT",0, -10},{"导出包含动作条启用状态","导出信息将包含各个动作条启用状态，虽然这并不属于插件本身配置信息"})
DefaultF.I_ActionBar:SetChecked(true)
DefaultF.I_Chat=PIGCheckbutton(DefaultF,{"TOPLEFT",DefaultF.I_ActionBar,"BOTTOMLEFT",0, -10},{"导出包含聊天栏设置","导出信息将包含聊天栏设置，虽然这并不属于插件本身配置信息"})
DefaultF.I_Chat:Disable();
DefaultF.I_Data=PIGCheckbutton(DefaultF,{"TOPLEFT",DefaultF.I_Chat,"BOTTOMLEFT",0, -10},{"导出包含数据(离线银行，聊天记录，售卖信息等)","注意这将导致字符串长度大大增加"})
DefaultF.I_Data:Disable();
--执行动作条开启配置
local ActionBarUI = CreateFrame("Frame")        
ActionBarUI:SetScript("OnEvent",function(self, event, arg1)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not PIGA["ActionBarEnabled"][PIG_OptionsUI.AllName] then
		local function SetActionBarToggle(index, value)
			SetActionBarToggles(unpack(PIGA["Config_ActionBar"]));
			MultiActionBar_Update();
		end
		for kw,vw in pairs(PIGA["Config_ActionBar"]) do
			SetActionBarToggle(kw,vw)
		end
		PIGA["ActionBarEnabled"][PIG_OptionsUI.AllName]=true
	end
end)
local function Update_UIActionBarPoint()
	if PIGA["Config_ActionBar"] then
		PIGA["ActionBarEnabled"]=PIGA["ActionBarEnabled"] or {}
		ActionBarUI:RegisterEvent("PLAYER_ENTERING_WORLD");
	end
end
--执行头像位置配置
local function Update_UIUnitPoint()
	if PIGA["Config_Unit"] then
		local TopBarY = 0
		for k,v in pairs(PIGA["Config_Unit"]) do
			local point, relativePoint, offsetX, offsetY=unpack(v)
			if point and relativePoint and offsetX and offsetY then
				local uixx=_G[k]
				uixx:ClearAllPoints();
				if PIGA["PigLayout"]["TopBar"]["Open"] then
					if relativePoint=="TOP" or relativePoint=="TOPLEFT" or relativePoint=="TOPRIGHT" then
						TopBarY=PIGA["PigLayout"]["TopBar"]["Height"]
					end
				end
				uixx:SetPoint(point, UIParent, relativePoint, offsetX, offsetY+TopBarY);
				uixx:SetUserPlaced(true)
			end
		end
		PIGA["Config_Unit"]=nil
	end
end
--加载外部插件的PIG配置
addonTable.ShareConfig = function()
	for adname,adDB in pairs(addonTable.ShareDB) do
		PigConfigFun.fuFrameBut.Text:SetText(PigConfigFun.fuFrameBut.Text:GetText().."+|cff00FFFF("..adDB.TitleName..")|r")
		local fujiF,fujiBut =PIGOptionsList_R(RTabFrame,adDB.TitleName,100)
		_G[Data.ExportImportUIname].ClickButFunX=LoadSameValue
		fujiF.tispext1 = PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",10,-10})
		fujiF.tispext1:SetJustifyH("LEFT");
		local Title=PIGGetAddOnMetadata(adname, "Title")
		local VersionTXT=PIGGetAddOnMetadata(adname, "Version")
		fujiF.tispext1:SetText("检测到外部配置(来自|cff00FFFF<"..Title.."|r|cff00FF0Fv"..VersionTXT.."|r), 你的部分"..addonName.."配置将被接管")
		fujiF.tispext1:SetTextColor(1, 0.2, 0, 1);
		fujiF.tispext2 = PIGFontString(fujiF,{"TOPLEFT",fujiF.tispext1,"BOTTOMLEFT",0,-8},"外部配置载入状态:")
		fujiF.tispext2:SetJustifyH("LEFT");
		fujiF.tispext2:SetTextColor(1, 0.2, 0, 1);
		fujiF.tispext3 = PIGFontString(fujiF,{"LEFT",fujiF.tispext2,"RIGHT",0,0},"成功")
		fujiF.tispext3:SetTextColor(0, 1, 0, 1);
		fujiF.butRL = PIGButton(fujiF,{"LEFT",fujiF.tispext3,"RIGHT",4,0},{80,20},"重置设置")
		PIGEnter(fujiF.butRL,"如遇异常情况，请点此重置此作者配置\n注意只会重置被接管的那部分"..addonName.."设置")
		fujiF.butRL:SetScript("OnClick", function ()
			adDB.ResetConfig()
			ReloadUI()
		end);
		DefaultF.ResetShareConfig=adDB.ResetConfig
		fujiF.tabbot=PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",0,-72})
		fujiF.tabbot:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", 0, 0);
		fujiF.tabbot:PIGSetBackdrop(0,1)
		fujiF.tabbot.tisp=PIGFontString(fujiF.tabbot,{"BOTTOMLEFT",fujiF.tabbot,"TOPLEFT",10,2},"以下设置为外部插件提供，非"..addonName.."功能，相关问题请咨询对应作者")
		fujiF.tabbot.tisp:SetTextColor(1, 0.2, 0, 1);
		adDB.CreateSetting(fujiF.tabbot)
		--外部作者设置的加载配置的条件
		local ConfigDB = adDB.LoadingCondition(VersionTXT)
		if ConfigDB then
			local errtxt = _G[Data.ExportImportUIname].Is_PIGString(ConfigDB)
			if errtxt then
				fujiF.tispext3:SetTextColor(1, 0, 0, 1);
				fujiF.tispext3:SetText("失败,原因:"..errtxt)
			else
				Update_UIUnitPoint()
			end
		end
		Update_UIActionBarPoint()
		return
	end
end