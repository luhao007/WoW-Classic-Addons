local addonName, addonTable = ...;
local L=addonTable.locale
local Fun=addonTable.Fun
local Data=addonTable.Data
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGCheckbutton=Create.PIGCheckbutton
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
-- --------------
local PigConfigFun=addonTable.PigConfigFun
local RTabFrame =PigConfigFun.RTabFrame
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
			ReloadUI()
		else
			PIG_OptionsUI:ErrorMsg(string.format(ERR_ARENA_TEAM_PLAYER_NOT_FOUND_S,arg1[2]),"R")
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}
--导出/导入----------
local function Remove_Data(newdata,Per)--剔除数据配置
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
local function CZ_ConfigData()
	local newdata={{},{}}
	newdata[1] = PIGCopyTable(addonTable.Default)
	Remove_Data(newdata[1])
	--Per
	newdata[2] = PIGCopyTable(addonTable.Default_Per)
	Remove_Data(newdata[2],true)
	return newdata[1],newdata[2]
end
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
	local newtab,newtab_Per=CZ_ConfigData()
	Load_ImportTxt_1(tabX,newtab)
	Load_ImportTxt_1(tabX_Per,newtab_Per)
	return newtab,newtab_Per
end
DefaultF.daorubut = PIGButton(DefaultF,{"TOPLEFT",DefaultF,"TOPLEFT",10, -200},{90,24},L["CONFIG_DAORU"]..L["CONFIG_TABNAME"])
DefaultF.daorubut:SetScript("OnClick", function ()
	_G[Data.ExportImportUIname]:daoruFun(addonName..ADDONS..L["CONFIG_TABNAME"],LoadSameValue)	
end);
local ConfigUIList={--导出UI位置，只加载一次
	PlayerFrame,
	TargetFrame,
	FocusFrame,
}
local function is_equal(value1, value2)
    if type(value1) == "table" and type(value2) == "table" then
        for k, v in pairs(value1) do
            if not is_equal(v, value2[k]) then
                return false
            end
        end
        -- 确保 value2 中没有多余的键
        for k, _ in pairs(value2) do
            if value1[k] == nil then
                return false
            end
        end
        return true
    else
        return value1 == value2
    end
end
local function Remove_ExtData(newdata,Per)
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
	if DefaultF.I_ActionBar:GetChecked() then
		newdata["Config_ActionBar"] = {GetActionBarToggles()}
	else
		newdata["Config_ActionBar"]=nil
	end
	if not DefaultF.I_Data:GetChecked() then--数据配置
		Remove_Data(newdata,Per)
	end
end
local function Remove_RepeatValues(NewDataX, moren)
    for key, value in pairs(moren) do
        -- 如果 NewDataX 中存在相同的键，并且值相等（包括递归比较）
        if NewDataX[key] ~= nil and is_equal(NewDataX[key], value) then
            NewDataX[key] = nil -- 移除该键
        elseif type(NewDataX[key]) == "table" and type(value) == "table" then
        	if next(NewDataX[key])==nil and next(value)==nil then
            	NewDataX[key] = nil
            else
	            -- 如果值是表，则递归处理子表
	            Remove_RepeatValues(NewDataX[key], value)
	            -- 如果子表变为空
            	if next(NewDataX[key])==nil and next(value)==nil then
                	NewDataX[key] = nil
                end
	        end
        end
    end
end
local function PIGCopyTable_Duplicates_1(old,moren,Per)
	local NewDataX = PIGCopyTable(old)
	Remove_ExtData(NewDataX,Per)
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
	-- for k,v in pairs(PIGCopyTable_Duplicates_1(PIGA_Per, addonTable.Default_Per, true)) do
	-- 	--print(k,v)
	-- 	--if k~="Pig_UI" then
	-- 		for k1,v1 in pairs(v) do
	-- 			if type(v1)=="table" then
	-- 				for k2,v2 in pairs(v1) do
	-- 					print(k,k1,k2,v2)
	-- 				end
				
	-- 			else
	-- 				print(k,k1,v1)
	-- 			end
	-- 		end
	-- 	--end
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
-----------
-----============
local Locale = GetLocale()
local ShareList={
	["QFUI"]={
		["namex"]={["zhCN"]="清风",["zhTW"]="清风",["enUS"]="Qingfeng",}
	},
	["Rurutia"]={
		["namex"]={["zhCN"]="露露",["zhTW"]="露露",["enUS"]="Rurutia",}
	},
	["LvSir"]={
		["namex"]={["zhCN"]="二哈吕老师",["zhTW"]="二哈吕老师",["enUS"]="LvSir",}
	},
}
local function add_ShareUI(shv)
	local PIGButton = Create.PIGButton
	local PIGFontString=Create.PIGFontString
	local PIGOptionsList_R=Create.PIGOptionsList_R
	local ShareName=ShareList[shv].namex[Locale] or ShareList[shv].namex["zhCN"]
	local fujiF,fujiBut =PIGOptionsList_R(RTabFrame,ShareName,100)
	----
	local cfbutW=fujiF:GetWidth()-20
	fujiF.title1 = PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-30})
	fujiF.title1:SetTextColor(0, 1, 0, 1);
	fujiF.title1:SetJustifyH("LEFT");
	fujiF.title1:SetWidth(cfbutW);
	fujiF.title2 = PIGFontString(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-70},"载入状态: ")
	fujiF.title3 = PIGFontString(fujiF,{"LEFT",fujiF.title2,"RIGHT",4,0})
	fujiF.button = PIGButton(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",20,-180},{90,24},"重新载入")
	fujiF.button.title = PIGFontString(fujiF.button,{"LEFT",fujiF.button,"RIGHT",10,0},"如果你因为某些原因丢失分享者配置，请点此重新载入")
	fujiF.button:SetScript("OnClick", function ()
		PIGA["Ver"][shv]=nil
		ReloadUI()
	end);
	return fujiF.title1,fujiF.title3,ShareName
end
addonTable.ShareConfig = function()
	for k,v in pairs(addonTable.ShareDB) do
		local VerTitle,errTitle,ShareName=add_ShareUI(k)
		local VersionTXT=PIGGetAddOnMetadata(k, "Version")
		VerTitle:SetText(string.format("检测到你在使用|cff00FFFF<%s>|r的配置分享|cffFFFFFF<版本%s>|r, 将尝试载入此分享作者的专属"..addonName.."配置",ShareName,VersionTXT))
		local bendijiluV=PIGA["Ver"][k] or 0
		if tonumber(VersionTXT)>bendijiluV then
			_G[Data.ExportImportUIname].ClickButFunX=LoadSameValue
			local errtxt = _G[Data.ExportImportUIname].Is_PIGString(v)
			if errtxt then
				errTitle:SetTextColor(1, 0, 0, 1);
				errTitle:SetText("载入失败,原因:"..errtxt)
			else
				PigConfigFun.fuFrameBut.Text:SetText(PigConfigFun.fuFrameBut.Text:GetText().."+|cff00FFFF("..ShareName..")|r")
				PIGA["Ver"][k]=tonumber(VersionTXT)
				errTitle:SetText("|cff00FF00成功|r  |cffFFFF00(版本"..VersionTXT.."初次载入)|r")
			end
		else
			PigConfigFun.fuFrameBut.Text:SetText(PigConfigFun.fuFrameBut.Text:GetText().."+|cff00FFFF("..ShareName..")|r")
			errTitle:SetText("|cff00FF00成功|r  |cffFFFF00(版本"..VersionTXT.."非初次载入，在下一次分享者更新前将不会重复载入)|r")
		end
		return
	end
end