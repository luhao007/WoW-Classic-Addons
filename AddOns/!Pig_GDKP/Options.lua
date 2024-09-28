local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
-----
local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGDiyBut=Create.PIGDiyBut
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGModCheckbutton=Create.PIGModCheckbutton
local PIGQuickBut=Create.PIGQuickBut
local PIGSetFont=Create.PIGSetFont

local SendAddonMessage = SendAddonMessage or C_ChatInfo and C_ChatInfo.SendAddonMessage
------
local GDKPInfo = {}
addonTable.GDKPInfo=GDKPInfo
------------
local GnName,GnUI,GnIcon,FrameLevel = L["PIGaddonList"][addonName],"PigGDKP_UI",133742,50
GDKPInfo.uidata={GnName,GnUI,GnIcon,FrameLevel}
local fuFrame,fuFrameBut = PIGOptionsList(GnName,"EXT")
GDKPInfo.fuFrame,GDKPInfo.fuFrameBut=fuFrame,fuFrameBut
function GDKPInfo.ADD_Options()
	local Key_fenge=Fun.Key_fenge
	local Tooltip = "!Pig金团助手功能，包含拾取记录，快速拍卖/出价，补助/罚款记录，分G助手"
	fuFrame.Open = PIGModCheckbutton(fuFrame,{GnName,Tooltip},{"TOPLEFT",fuFrame,"TOPLEFT",20,-20})
	fuFrame.Open:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Open"]=true;
			fuFrame.SetListF:Show()
			GDKPInfo.ADD_UI()
		else
			PIGA["GDKP"]["Open"]=false;
			fuFrame.SetListF:Hide()
			Pig_Options_RLtishi_UI:Show()
		end
		QuickButUI.ButList[15]()
	end);
	fuFrame.Open.QKBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["AddBut"]=true
			QuickButUI.ButList[15]()
		else
			PIGA["GDKP"]["AddBut"]=false
			Pig_Options_RLtishi_UI:Show();
		end
	end);
	QuickButUI.ButList[15]=function()
		if PIGA["QuickBut"]["Open"] and PIGA["GDKP"]["Open"] and PIGA["GDKP"]["AddBut"] then
			local QkButUI = "QkBut_PigGDKP"
			if _G[QkButUI] then return end
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF打开"..GnName.."|r\n"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r"
			local QkBut=PIGQuickBut(QkButUI,QuickTooltip,GnIcon,GnUI,FrameLevel)
			QkBut:HookScript("OnClick", function(self,button)
				if button=="RightButton" then
					if Pig_OptionsUI:IsShown() then
						Pig_OptionsUI:Hide()
					else
						Pig_OptionsUI:Show()
						Create.Show_TabBut(fuFrame,fuFrameBut)
					end
				end
			end);
		end
	end
	---重置配置
	fuFrame.CZ = PIGButton(fuFrame,{"TOPRIGHT",fuFrame,"TOPRIGHT",-20,-20},{60,22},"重置");  
	fuFrame.CZ:SetScript("OnClick", function ()
		StaticPopup_Show ("HUIFU_GDKP_INFO");
	end);
	StaticPopupDialogs["HUIFU_GDKP_INFO"] = {
		text = "此操作将\124cffff0000重置\124r"..GnName.."所有配置，需重载界面。\n确定重置?",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			PIGA["GDKP"] = Default["GDKP"];
			PIGA["GDKP"]["Open"] = true;
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	---------========
	fuFrame.SetListline = PIGLine(fuFrame,"TOP",-66)
	fuFrame.SetListF = PIGFrame(fuFrame)
	fuFrame.SetListF:SetPoint("TOPLEFT",fuFrame.SetListline,"BOTTOMLEFT",0,0);
	fuFrame.SetListF:SetPoint("BOTTOMRIGHT",fuFrame,"BOTTOMRIGHT",0,0);
	--
	local autofentishi = "开启后队长分配模式下且你是战利品分配人会自动分配掉落到自己背包(分配品质"..KEY_BUTTON2.."点击自己头像设置)\n"..
	"|cffFF0000不会分配任务物品，也不会分配埃提耶什的碎片/瓦兰奈尔的碎片/影霜碎片。|r\n开启此功能后会在队伍/团队频道发送拾取明细"
	fuFrame.SetListF.autofen = PIGCheckbutton_R(fuFrame.SetListF,{"自动分配物品给自己\124cff00FF00(你必须是战利品分配人)\124r",autofentishi},true)
	fuFrame.SetListF.autofen:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["autofen"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["autofen"]=false;
		end
		fuFrame.SetListF.AutoLootfenEvent()
	end);
	-------
	local bufenpei = {
		22726,--埃提耶什的碎片
		45038,--瓦兰奈尔的碎片
		50274,--影霜碎片
		30311,30312,30313,30314,30316,30317,30318,30319,30320,--七武器
	}
	local autofenffff = CreateFrame("Frame")
	autofenffff:SetScript("OnEvent",function(self,event,arg1,_,_,_,arg5)
		--是队长团长
		-- local isLeader = UnitIsGroupLeader("player");
		if IsInGroup() then
			local lootmethod, masterlooterPartyID, masterlooterRaidID= GetLootMethod();
			if lootmethod=="master" and masterlooterPartyID==0 then
				local lootNum = GetNumLootItems()
				local MSGyifasong = {}
				for x=1,lootNum do
					MSGyifasong[x]=false
				end
				for x = 1, lootNum do
					local link = GetLootSlotLink(x)
					if link then
						local itemID = GetItemInfoInstant(link)
						if itemID then
							self.bufenpei=true
							for ix=1,#bufenpei do	
								if itemID == bufenpei[ix] then
									self.bufenpei=false
									break
								end
							end
							---
							if self.bufenpei then
								local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(x)
								if not isQuestItem and lootQuality>=GetLootThreshold() then
									for ci = 1, GetNumGroupMembers() do
										local candidate = GetMasterLootCandidate(x, ci)
										if candidate == Pig_OptionsUI.Name then
											GiveMasterLoot(x, ci);
											if not MSGyifasong[x] then
												PIGSendChatRaidParty("!Pig:拾取"..link.."×"..lootQuantity)
												MSGyifasong[x]=true
											end
											break
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end)
	function fuFrame.SetListF.AutoLootfenEvent()
		if PIGA["GDKP"]["Rsetting"]["autofen"] then
			autofenffff:RegisterEvent("LOOT_READY");
			--autofenffff:RegisterEvent("LOOT_OPENED");
		else
			autofenffff:UnregisterAllEvents()
		end
	end
	fuFrame.SetListF.AutoLootfenEvent()
	----副本外
	fuFrame.SetListF.fubenwai = PIGCheckbutton_R(fuFrame.SetListF,{"记录副本外拾取","开启后会记录副本外的拾取信息（默认只记录团队副本内掉落）"},true)
	fuFrame.SetListF.fubenwai:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["fubenwai"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["fubenwai"]=false;
		end
	end);

	--5人本
	fuFrame.SetListF.wurenben = PIGCheckbutton_R(fuFrame.SetListF,{"记录5人本拾取","开启后会记录5人本拾取信息（默认只记录团队副本内掉落）"},true)
	fuFrame.SetListF.wurenben:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["wurenben"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["wurenben"]=false;
		end
	end);

	--手动添加物品
	fuFrame.SetListF.shoudongloot = PIGCheckbutton_R(fuFrame.SetListF,{"手动添加物品","开启后按住shift点击聊天栏物品链接添加物品到拾取目录（注意必须保持拾取目录列表为打开状态）"},true)
	fuFrame.SetListF.shoudongloot:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["shoudongloot"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["shoudongloot"]=false;
		end
	end);
	--拾取物品倒计时
	fuFrame.SetListF.jiaoyidaojishi = PIGCheckbutton_R(fuFrame.SetListF,{"物品可交易倒计时通告","启用后，物品可交易时间低于10分钟将会在团队频道提示，预估时间仅供参考\n注意此通告不会在战斗中执行"},true)
	fuFrame.SetListF.jiaoyidaojishi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["jiaoyidaojishi"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["jiaoyidaojishi"]=false;
		end
	end);

	--交易记录==================================
	local jiaoyijiluTS="开启后,交易拾取目录内的物品将会自动填入收入金额及成交人，交易多件物品收到金额将会被平分"
	fuFrame.SetListF.jiaoyijilu = PIGCheckbutton_R(fuFrame.SetListF,{"自动录入成交人/成交金额",jiaoyijiluTS},true)
	fuFrame.SetListF.jiaoyijilu:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["jiaoyijilu"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["jiaoyijilu"]=false;
		end
		fuFrame.SetListF.jiaoyijiluEvent()
	end);
	fuFrame.SetListF.tradetonggao = PIGCheckbutton_R(fuFrame.SetListF,{"通告交易详情","在团队频道通告交易详情"},true)
	fuFrame.SetListF.tradetonggao:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["tradetonggao"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["tradetonggao"]=false;
		end
	end);
	-------
	local PIGTradeFrame = PIGFrame(UIParent,{"TOP",UIParent,"TOP",0,-150},{400,360});
	PIGTradeFrame:PIGSetBackdrop()
	PIGTradeFrame:Hide()
	PIGTradeFrame.cancel = PIGButton(PIGTradeFrame,{"TOPRIGHT",PIGTradeFrame,"TOPRIGHT",0,0},{60,22},"不清欠");
	PIGTradeFrame.cancel:HookScript("OnClick",function (self)
		PIGTradeFrame:Hide()
	end)
	PIGTradeFrame.save = PIGButton(PIGTradeFrame,{"BOTTOM",PIGTradeFrame,"BOTTOM",0,10},{80,24},"执行清欠");
	PIGTradeFrame.save:HookScript("OnClick",function (self)
		PIGTradeFrame.qiankuan_InfoSave()
	end)
	PIGTradeFrame.biaoti = PIGFontString(PIGTradeFrame,{"TOPLEFT", PIGTradeFrame, "TOPLEFT", 10,-4}," ");
	PIGTradeFrame.biaoti:SetTextColor(1, 0, 1, 1);
	PIGTradeFrame.biaoti_1 = PIGFontString(PIGTradeFrame,{"LEFT", PIGTradeFrame.biaoti, "RIGHT", 4,0},"欠款信息:");
	--itemList
	local topjianju,qingqian_Height,qingqian_NUM = 50,18,10
	PIGTradeFrame.itemListF = PIGFrame(PIGTradeFrame,{"TOPLEFT",PIGTradeFrame,"TOPLEFT",0,-topjianju});
	PIGTradeFrame.itemListF:SetHeight((qingqian_Height+2)*qingqian_NUM);  
	PIGTradeFrame.itemListF:SetPoint("TOPRIGHT",PIGTradeFrame,"TOPRIGHT",0,-topjianju);
	-- 
	local qingqian_biaoti = {{"物品",16},{"欠款/G",220},{"还款/G",290},{"清账",360}}
	for id = 1, #qingqian_biaoti, 1 do
		local biaoti = PIGFontString(PIGTradeFrame.itemListF,{"BOTTOMLEFT", PIGTradeFrame.itemListF, "TOPLEFT", qingqian_biaoti[id][2],2},qingqian_biaoti[id][1],nil,nil,"qingqian_biaoti_"..id);
		if id==2 then
			biaoti:SetTextColor(1, 0, 0, 1);
		elseif id==3 then
			biaoti:SetTextColor(0, 1, 0, 1);
		else
			biaoti:SetTextColor(1, 1, 0, 1);
		end
	end
	for id = 1, qingqian_NUM do
		local hang = CreateFrame("Frame", "qingqian_hang_"..id, PIGTradeFrame.itemListF);
		hang:SetSize(PIGTradeFrame.itemListF:GetWidth()-25, qingqian_Height);
		if id==1 then
			hang:SetPoint("TOP",PIGTradeFrame.itemListF,"TOP",0,0);
		else
			hang:SetPoint("TOP",_G["qingqian_hang_"..(id-1)],"BOTTOM",0,-2);
		end
		PIGLine(hang,"TOP",nil,nil,nil,{0.3,0.3,0.3,0.3})
		hang.qianItem = PIGFontString(hang,{"LEFT", hang, "LEFT", 0,0});
		--
		hang.qianV = PIGFontString(hang,{"LEFT", hang, "LEFT", qingqian_biaoti[2][2]-8,0},0);
		hang.qianV:SetTextColor(0.8, 0.2, 0, 1);
		hang.qingV = CreateFrame("EditBox", nil, hang, "InputBoxInstructionsTemplate",id);
		hang.qingV:SetSize(54,qingqian_Height);
		hang.qingV:SetPoint("LEFT", hang, "LEFT", qingqian_biaoti[3][2]-8,0);
		PIGSetFont(hang.qingV, 14, "OUTLINE");
		hang.qingV:SetMaxLetters(6)
		hang.qingV:SetNumeric(true)
		hang.qingV:SetAutoFocus(false);
		hang.qingV:SetScript("OnEditFocusGained", function(self) 
			self:SetTextColor(1, 1, 1, 1);
		end);
		hang.qingV:SetScript("OnEditFocusLost", function(self)
			self:SetTextColor(0.7, 0.7, 0.7, 1);
			self:SetText(PIGTradeFrame.qiankuanInfo["itemL"][self:GetID()][2])
		end);
		hang.qingV:SetScript("OnEscapePressed", function(self) 
			self:ClearFocus()
		end);
		hang.qingV:SetScript("OnEnterPressed", function(self)
			PIGTradeFrame.qiankuanInfo["itemL"][self:GetID()][2]=self:GetNumber()
			PIGTradeFrame.Update_Show()
		end);
		hang.wancheng = hang:CreateTexture();
		hang.wancheng:SetTexture("interface/raidframe/readycheck-ready.blp");
		hang.wancheng:SetSize(qingqian_Height,qingqian_Height-4);
		hang.wancheng:SetPoint("LEFT", hang, "LEFT", qingqian_biaoti[4][2]-8,0);
	end
	PIGTradeFrame.itemListF.benci = PIGFontString(PIGTradeFrame.itemListF,{"TOPLEFT", PIGTradeFrame.itemListF, "BOTTOMLEFT", 10,-10},"本次交易收到/G: ");
	PIGTradeFrame.itemListF.benciG = PIGFontString(PIGTradeFrame.itemListF,{"LEFT", PIGTradeFrame.itemListF.benci, "RIGHT", 2,0},"0");
	PIGTradeFrame.itemListF.benciG:SetTextColor(1, 1, 1, 1);
	PIGTradeFrame.itemListF.qingxianhou = PIGFontString(PIGTradeFrame.itemListF,{"TOPLEFT", PIGTradeFrame.itemListF.benci, "BOTTOMLEFT", 0,-6},"玩家总欠款/G: ");
	PIGTradeFrame.itemListF.qingxianhouG = PIGFontString(PIGTradeFrame.itemListF,{"LEFT", PIGTradeFrame.itemListF.qingxianhou, "RIGHT", 2,0},"0");

	function PIGTradeFrame.qiankuan_InfoSave()
		local itemL=PIGTradeFrame.qiankuanInfo["itemL"]
		for id = 1, #itemL do
			local qiankwu = PIGA["GDKP"]["ItemList"][itemL[id][1]]
			if qiankwu then
				qiankwu[9]=qiankwu[9]+itemL[id][2]
				qiankwu[14]=qiankwu[14]-itemL[id][2]
			end
		end
		PIGTradeFrame:Hide()
		_G[GnUI].Update_Item();
	end
	function PIGTradeFrame.Update_Show()
		for id = 1, qingqian_NUM do
			local hang=_G["qingqian_hang_"..id]
			hang:Hide()
			hang.wancheng:Hide()
			hang.qingV:SetTextColor(0.6, 0.6, 0.6, 1);
		end
		PIGTradeFrame:Show()
		local TName=PIGTradeFrame.qiankuanInfo["name"]
		local TMoney=PIGTradeFrame.qiankuanInfo["Money"]
		local itemL=PIGTradeFrame.qiankuanInfo["itemL"]
		PIGTradeFrame.biaoti:SetText(TName)
		PIGTradeFrame.itemListF.benciG:SetText(TMoney)
		local itemLNum = #itemL
		for id = 1, itemLNum do
			local qiankwu = PIGA["GDKP"]["ItemList"][itemL[id][1]]
			if qiankwu then
				local hang=_G["qingqian_hang_"..id]
				hang:Show();
				hang.qianItem:SetText(qiankwu[2])
				hang.qianV:SetText(qiankwu[14])
				hang.qingV:SetText(itemL[id][2])
			end
		end
		for id = 1, itemLNum do
			local hang=_G["qingqian_hang_"..id]
			local qianV=tonumber(hang.qianV:GetText())
			local qingV=hang.qingV:GetNumber()
			if qingV>=qianV then
				hang.wancheng:Show()
			end
		end
		PIGTradeFrame.itemListF.qingxianhouG:SetText(TMoney-PIGTradeFrame.qiankuanInfo["shengyu"].." (差额"..PIGTradeFrame.qiankuanInfo["shengyu"]..")")
		if PIGTradeFrame.qiankuanInfo["shengyu"]>=0 then
			PIGTradeFrame.itemListF.qingxianhouG:SetTextColor(0, 1, 0, 1);
		else
			PIGTradeFrame.itemListF.qingxianhouG:SetTextColor(1, 0, 0, 1);
		end
	end
	function PIGTradeFrame.GetQiankuan_Info(TName,TMoney)
		PIGTradeFrame.qiankuanInfo = {["name"]=TName,["Money"]=TMoney*0.0001,["itemL"]={},["shengyu"]=TMoney*0.0001}
		local RRItemList = PIGA["GDKP"]["ItemList"]
		for x=1,#RRItemList do
			if RRItemList[x][8]==TName then
				if RRItemList[x][14]>0 then
					table.insert(PIGTradeFrame.qiankuanInfo["itemL"],{x,0})
				end
			end
		end
		local itemL = PIGTradeFrame.qiankuanInfo["itemL"]
		local itemLNum = #itemL
		if itemLNum>0 then
			for id = 1, itemLNum do
				local qiankwu = PIGA["GDKP"]["ItemList"][itemL[id][1]]
				if qiankwu then
					if PIGTradeFrame.qiankuanInfo["shengyu"]>0 then
						if PIGTradeFrame.qiankuanInfo["shengyu"]>=qiankwu[14] then
							itemL[id][2]=qiankwu[14]
						else
							itemL[id][2]=PIGTradeFrame.qiankuanInfo["shengyu"]
						end
					end
					PIGTradeFrame.qiankuanInfo["shengyu"] = PIGTradeFrame.qiankuanInfo["shengyu"]-qiankwu[14]
				end
			end
			PIGTradeFrame.Update_Show()
		end
	end
	--屏蔽交易产生的拾取记录
	local function PIGshiqulinshiStop()
		_G[GnUI].shiqulinshiStop=true
		C_Timer.After(0.2,function()
			_G[GnUI].shiqulinshiStop=nil
		end)
	end
	local function jiaoyi_InfoPD_1(TName,TMoney,ItemS)
		local Money=TMoney*0.0001
		local RRItemList = PIGA["GDKP"]["ItemList"]
		local wupinNum = #ItemS
		local pingjunfenG = TMoney/wupinNum
		for p=1,wupinNum do
			local itemLink_P = ItemS[p][1]
			local itemID_P = GetItemInfoInstant(itemLink_P) 
			for x=1,#RRItemList do
				if itemID_P==RRItemList[x][11] then
					if RRItemList[x][8]=="N/A" and RRItemList[x][9]==0 and RRItemList[x][14]==0 then
						RRItemList[x][8]=TName;
						RRItemList[x][9]=pingjunfenG;
						RRItemList[x][10]=GetServerTime();
						break
					end
				end
			end
		end
		if wupinNum>1 then
			C_Timer.After(0.4,function()
				PIGinfotip:TryDisplayMessage("多件物品收到金额会被平分");
			end)
		end
		_G[GnUI].Update_Item();
	end
	function PIGTradeFrame.jiaoyi_infoPD(TargetName,TargetMoney,PlayerItemS)
		local ItemS={}
		for i=1,#PlayerItemS do
			if PlayerItemS[i]~=NONE then
				table.insert(ItemS,PlayerItemS[i])
			end
		end
		if #ItemS>0 and TargetMoney>0 then--有物品交出和金币收入			
			PIGshiqulinshiStop()
			jiaoyi_InfoPD_1(TargetName,TargetMoney,ItemS)
		elseif TargetMoney>0 then--只有金币收入
			PIGTradeFrame.GetQiankuan_Info(TargetName,TargetMoney)
		end
	end
	PIGTradeFrame:HookScript("OnEvent",function (self,event,arg1,arg2,arg3,arg4,arg5)
		if event=="UI_INFO_MESSAGE" then
			if arg2==ERR_TRADE_COMPLETE then
				self.jiaoyi_infoPD(TradeFrame.PIG_Data.Name,TradeFrame.PIG_Data.MoneyT,TradeFrame.PIG_Data.ItemP)
			end
		end
	end)
	function fuFrame.SetListF.jiaoyijiluEvent()
		if PIGA["GDKP"]["Open"] and PIGA["GDKP"]["Rsetting"]["jiaoyijilu"] then
			PIGTradeFrame:RegisterEvent("UI_INFO_MESSAGE");
		else
			PIGTradeFrame:UnregisterEvent("UI_INFO_MESSAGE");
		end
	end
	fuFrame.SetListF.jiaoyijiluEvent();
	--================================================
	fuFrame.SetListF.zidonghuifuYY = PIGCheckbutton_R(fuFrame.SetListF,{"自动回复语音工具\124cff00FF00(你必须是队长或团长)\124r","开启后,收到队伍或者团队人员咨询语音工具(例：TS,YY)频道ID会自动回复预设内容"},true)
	fuFrame.SetListF.zidonghuifuYY:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["zidonghuifuVoice"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["zidonghuifuVoice"]=false;
		end
		fuFrame.SetListF.zidonghuifuEvent()
	end);
	--触发关键字
	fuFrame.SetListF.zidonghuifuYY.biaoti = PIGFontString(fuFrame.SetListF,{"TOPLEFT", fuFrame.SetListF.zidonghuifuYY, "BOTTOMLEFT", 0,-6},"触发关键字(用，分隔):");
	fuFrame.SetListF.zidonghuifuYY.F = PIGFrame(fuFrame.SetListF,{"TOPLEFT", fuFrame.SetListF.zidonghuifuYY.biaoti, "BOTTOMLEFT", 0,-2},{320,26});
	fuFrame.SetListF.zidonghuifuYY.F:PIGSetBackdrop()
	fuFrame.SetListF.zidonghuifuYY.E = CreateFrame("EditBox", nil, fuFrame.SetListF.zidonghuifuYY.F);
	fuFrame.SetListF.zidonghuifuYY.E:SetPoint("TOPLEFT", fuFrame.SetListF.zidonghuifuYY.F, "TOPLEFT", 8,-6);
	fuFrame.SetListF.zidonghuifuYY.E:SetPoint("BOTTOMRIGHT", fuFrame.SetListF.zidonghuifuYY.F, "BOTTOMRIGHT", -8,6);
	fuFrame.SetListF.zidonghuifuYY.E:SetFontObject(ChatFontNormal);
	fuFrame.SetListF.zidonghuifuYY.E:SetAutoFocus(false);
	fuFrame.SetListF.zidonghuifuYY.E:SetMaxLetters(22);
	fuFrame.SetListF.zidonghuifuYY.E:SetTextColor(0.6, 0.6, 0.6, 1);
	fuFrame.SetListF.zidonghuifuYY.E:SetScript("OnEditFocusGained", function(self) 
		self:SetTextColor(1, 1, 1, 1);
	end);
	fuFrame.SetListF.zidonghuifuYY.E:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus() 
	end);
	fuFrame.SetListF.zidonghuifuYY.E:SetScript("OnEnterPressed", function(self) 
		self:ClearFocus() 
	end);
	fuFrame.SetListF.zidonghuifuYY.E:SetScript("OnEditFocusLost", function(self)
		self:SetTextColor(0.6, 0.6, 0.6, 1);
		local guanjianV = self:GetText();
		local guanjianshuzu = guanjianV:gsub("，", ",")
		local guanjianzilist = Key_fenge(guanjianshuzu, ",")
		PIGA["GDKP"]["Rsetting"]["YYguanjianzi"]=guanjianzilist;
	end);
	--回复内容
	fuFrame.SetListF.zidonghuifuYY.NR_biaoti = PIGFontString(fuFrame.SetListF,{"TOPLEFT", fuFrame.SetListF.zidonghuifuYY.F, "BOTTOMLEFT", 0,-6},"回复内容:");
	fuFrame.SetListF.zidonghuifuYY.NR = PIGFrame(fuFrame.SetListF,{"TOPLEFT", fuFrame.SetListF.zidonghuifuYY.NR_biaoti, "BOTTOMLEFT", 0,-2},{320,26});
	fuFrame.SetListF.zidonghuifuYY.NR:PIGSetBackdrop()
	fuFrame.SetListF.zidonghuifuYY.NR_E = CreateFrame("EditBox", nil, fuFrame.SetListF.zidonghuifuYY.NR);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetPoint("TOPLEFT", fuFrame.SetListF.zidonghuifuYY.NR, "TOPLEFT", 8,-6);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetPoint("BOTTOMRIGHT", fuFrame.SetListF.zidonghuifuYY.NR, "BOTTOMRIGHT", -8,6);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetFontObject(ChatFontNormal);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetAutoFocus(false);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetMaxLetters(40);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetTextColor(0.6, 0.6, 0.6, 1);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetScript("OnEditFocusGained", function(self) 
		self:SetTextColor(1, 1, 1, 1);
	end);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetScript("OnEscapePressed", function(self) 
		self:ClearFocus() 
	end);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetScript("OnEnterPressed", function(self) 
		self:ClearFocus() 
	end);
	fuFrame.SetListF.zidonghuifuYY.NR_E:SetScript("OnEditFocusLost", function(self)
		self:SetTextColor(0.6, 0.6, 0.6, 1);
		PIGA["GDKP"]["Rsetting"]["YYneirong"]=self:GetText();
	end);
	local zidonghuifuFFF = CreateFrame("Frame")
	zidonghuifuFFF:SetScript("OnEvent",function(self, event,arg1,_,_,_,arg5)
		local isLeader = UnitIsGroupLeader("player");
		if isLeader then
			if arg5==Pig_OptionsUI.Name then return end
			if not arg1:match("[!Pig]") then
				local YYguanjianzi=PIGA["GDKP"]["Rsetting"]["YYguanjianzi"];
				for i=1,#YYguanjianzi do
					if arg1:match(YYguanjianzi[i]) then
						if event=="CHAT_MSG_WHISPER" then
							if IsInRaid() then
								for p=1,40 do
									local name = GetUnitName("raid"..p, true)
									if name~=nil then
										if arg5==name then
											SendChatMessage("[!Pig] "..PIGA["GDKP"]["Rsetting"]["YYneirong"], "WHISPER", nil, arg5);
											break
										end
									end
								end
							elseif IsInGroup() then
								for p=1,4 do
									local name = GetUnitName("party"..p, true)
									if name~=nil then
										if arg5==name then
											SendChatMessage("[!Pig] "..PIGA["GDKP"]["Rsetting"]["YYneirong"], "WHISPER", nil, arg5);
											break
										end
									end
								end
							end
						elseif event=="CHAT_MSG_PARTY" then
							SendChatMessage("[!Pig] "..PIGA["GDKP"]["Rsetting"]["YYneirong"], "PARTY");
						elseif event=="CHAT_MSG_RAID" then
							SendChatMessage("[!Pig] "..PIGA["GDKP"]["Rsetting"]["YYneirong"], "RAID_WARNING");
						end
						break
					end
				end
			end
		end
	end)
	function fuFrame.SetListF.zidonghuifuEvent()
		if PIGA["GDKP"]["Rsetting"]["zidonghuifuVoice"] then
			zidonghuifuFFF:RegisterEvent("CHAT_MSG_WHISPER") 
			zidonghuifuFFF:RegisterEvent("CHAT_MSG_PARTY");
			zidonghuifuFFF:RegisterEvent("CHAT_MSG_RAID");
		else
			zidonghuifuFFF:UnregisterAllEvents();
		end
	end
	fuFrame.SetListF.zidonghuifuEvent()
	--过滤排除物品============================================
	local paichu_Height,paichu_NUM  = 28.4, 15;
	-----------
	fuFrame.SetListF.Paichu = PIGFrame(fuFrame.SetListF,{"TOPLEFT", fuFrame.SetListF, "TOPRIGHT", -260, -28})
	fuFrame.SetListF.Paichu:SetPoint("BOTTOMRIGHT", fuFrame.SetListF, "BOTTOMRIGHT", -6, 6)
	fuFrame.SetListF.Paichu:PIGSetBackdrop()
	fuFrame.SetListF.Paichu.biaoti = PIGFontString(fuFrame.SetListF.Paichu,{"BOTTOMLEFT", fuFrame.SetListF.Paichu, "TOPLEFT", 4, 4},"\124cffFF0000忽略以下物品拾取记录\124r");
	--提示
	fuFrame.SetListF.Paichu.biaoti_tishi = CreateFrame("Frame", nil, fuFrame.SetListF.Paichu);
	fuFrame.SetListF.Paichu.biaoti_tishi:SetSize(30,30);
	fuFrame.SetListF.Paichu.biaoti_tishi:SetPoint("LEFT",fuFrame.SetListF.Paichu.biaoti,"RIGHT",-6,0);
	fuFrame.SetListF.Paichu.biaoti_tishi.Tex = fuFrame.SetListF.Paichu.biaoti_tishi:CreateTexture(nil, "BORDER");
	fuFrame.SetListF.Paichu.biaoti_tishi.Tex:SetTexture("interface/common/help-i.blp");
	fuFrame.SetListF.Paichu.biaoti_tishi.Tex:SetAllPoints(fuFrame.SetListF.Paichu.biaoti_tishi)
	PIGEnter(fuFrame.SetListF.Paichu.biaoti_tishi,"提示：","\124cff00ff00拾取记录页面"..KEY_BUTTON2.."点击物品名添加为不记录.\124r")
	----可滚动区域
	fuFrame.SetListF.Paichu.Scroll = CreateFrame("ScrollFrame",nil,fuFrame.SetListF.Paichu, "FauxScrollFrameTemplate");  
	fuFrame.SetListF.Paichu.Scroll:SetPoint("TOPLEFT",fuFrame.SetListF.Paichu,"TOPLEFT",0,0);
	fuFrame.SetListF.Paichu.Scroll:SetPoint("BOTTOMRIGHT",fuFrame.SetListF.Paichu,"BOTTOMRIGHT",-25,2);
	fuFrame.SetListF.Paichu.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, Paichu_Height, fuFrame.SetListF.Paichu.gengxinpaichu)
	end)
	--创建行
	local Paichuww = fuFrame.SetListF.Paichu:GetWidth()
	for id = 1, paichu_NUM do
		local Pcwupin = CreateFrame("Frame", "PaichuList"..id, fuFrame.SetListF.Paichu.Scroll:GetParent());
		Pcwupin:SetSize(Paichuww-25, paichu_Height);
		if id==1 then
			Pcwupin:SetPoint("TOP",fuFrame.SetListF.Paichu.Scroll,"TOP",0,0);
		else
			Pcwupin:SetPoint("TOP",_G["PaichuList"..(id-1)],"BOTTOM",0,-0);
		end
		if id~=paichu_NUM then
			Pcwupin.line = PIGLine(Pcwupin,"BOT")
		end
		Pcwupin.del=PIGDiyBut(Pcwupin,{"LEFT", Pcwupin, "LEFT", 4,0},{22})
		Pcwupin.del:SetScript("OnClick", function (self)
			table.remove(PIGA["GDKP"]["Rsetting"]["PaichuList"], self:GetID());
			fuFrame.SetListF.Paichu.gengxinpaichu(fuFrame.SetListF.Paichu.Scroll);
		end);
		Pcwupin.item = CreateFrame("Frame", nil, Pcwupin);
		Pcwupin.item:SetSize(Paichuww-51,paichu_Height);
		Pcwupin.item:SetPoint("LEFT",Pcwupin.del,"RIGHT",0,0);
		Pcwupin.item.icon = Pcwupin.item:CreateTexture(nil, "BORDER");
		Pcwupin.item.icon:SetSize(paichu_Height-4,paichu_Height-4);
		Pcwupin.item.icon:SetPoint("LEFT", Pcwupin.item, "LEFT", 0,0);
		Pcwupin.item.link = PIGFontString(Pcwupin.item,{"LEFT", Pcwupin.item.icon, "RIGHT", 1,0});
	end
	fuFrame.SetListF.Paichu:HookScript("OnShow", function (self)
		fuFrame.SetListF.Paichu.gengxinpaichu(self.Scroll);
	end)
	function fuFrame.SetListF.Paichu.gengxinpaichu(self)
		for k = 1, paichu_NUM do
			_G["PaichuList"..k]:Hide();
	    end
	    local paichumulu = PIGA["GDKP"]["Rsetting"]["PaichuList"]
	    local ItemsNum = #paichumulu
		if ItemsNum>0 then
			FauxScrollFrame_Update(self, ItemsNum, paichu_NUM, paichu_Height);
			local offset = FauxScrollFrame_GetOffset(self);
			for k = 1, paichu_NUM do
				local dangqianH = k+offset;
				if paichumulu[dangqianH] then
					local fujik=_G["PaichuList"..k]
					fujik:Show();
					fujik.del:SetID(dangqianH);
					local itemName, itemLink, _, _, _, _, _, _,_, itemTexture=GetItemInfo(paichumulu[dangqianH]);
			    	fujik.item.icon:SetTexture(itemTexture);
					fujik.item.link:SetText(itemLink);
					fujik.item:SetScript("OnMouseDown", function (self)
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
						GameTooltip:SetHyperlink(itemLink)
					end);
					fujik.item:SetScript("OnMouseUp", function ()
						GameTooltip:ClearLines();
						GameTooltip:Hide() 
					end);
				end
			end
		end
	end
	--=============================
	fuFrame.SetListF:HookScript("OnShow", function (self)
		self.autofen:SetChecked(PIGA["GDKP"]["Rsetting"]["autofen"]);
		self.jiaoyidaojishi:SetChecked(PIGA["GDKP"]["Rsetting"]["jiaoyidaojishi"]);
		self.fubenwai:SetChecked(PIGA["GDKP"]["Rsetting"]["fubenwai"]);
		self.wurenben:SetChecked(PIGA["GDKP"]["Rsetting"]["wurenben"]);
		self.shoudongloot:SetChecked(PIGA["GDKP"]["Rsetting"]["shoudongloot"]);
		self.jiaoyijilu:SetChecked(PIGA["GDKP"]["Rsetting"]["jiaoyijilu"]);
		self.tradetonggao:SetChecked(PIGA["GDKP"]["Rsetting"]["tradetonggao"]);
		self.zidonghuifuYY:SetChecked(PIGA["GDKP"]["Rsetting"]["zidonghuifuVoice"]);
		local huifuYY_guanjianzineirong="";
		for i=1,#PIGA["GDKP"]["Rsetting"]["YYguanjianzi"] do
			if i~=#PIGA["GDKP"]["Rsetting"]["YYguanjianzi"] then
				huifuYY_guanjianzineirong=huifuYY_guanjianzineirong..PIGA["GDKP"]["Rsetting"]["YYguanjianzi"][i].."，"
			else
				huifuYY_guanjianzineirong=huifuYY_guanjianzineirong..PIGA["GDKP"]["Rsetting"]["YYguanjianzi"][i]
			end
		end
		self.zidonghuifuYY.E:SetText(huifuYY_guanjianzineirong)
		self.zidonghuifuYY.NR_E:SetText(PIGA["GDKP"]["Rsetting"]["YYneirong"])
	end)
	----
end
---======
fuFrame:HookScript("OnShow", function (self)
	if self.VersionID<PIGA["Ver"][addonName] then
		self.UpdateVer:Show()
	end
	self.Open:SetChecked(PIGA["GDKP"]["Open"])
	self.Open.QKBut:SetChecked(PIGA["GDKP"]["AddBut"])
	if PIGA["GDKP"]["Open"] then
		self.SetListF:Show()
	else
		self.SetListF:Hide()
	end
end);
--==================================
local GetExtVer=Pig_OptionsUI.GetExtVer
local SendMessage=Pig_OptionsUI.SendMessage
fuFrame.VersionID=0
fuFrame.GetVer=addonName.."#U#0"
fuFrame.FasVer=addonName.."#D#0"
fuFrame:RegisterEvent("ADDON_LOADED")   
fuFrame:RegisterEvent("PLAYER_LOGIN");
fuFrame:RegisterEvent("CHAT_MSG_ADDON"); 
fuFrame:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event=="ADDON_LOADED" and arg1 == addonName then
		self:UnregisterEvent("ADDON_LOADED")
		addonTable.Load_Config()
		Pig_OptionsUI:SetVer_EXT(arg1,self)
	end
	if event=="PLAYER_LOGIN" then
		PIGA["Ver"][addonName]=PIGA["Ver"][addonName] or 0
		fuFrame.GetVer=addonName.."#U#"..self.VersionID;
		fuFrame.FasVer=addonName.."#D#"..self.VersionID;
		if PIGA["Ver"][addonName]>self.VersionID then
			self.yiGenxing=true;
		else
			SendMessage(fuFrame.GetVer)
		end
		GDKPInfo.ADD_Options()
		GDKPInfo.ADD_UI()
		QuickButUI.ButList[15]()
	end
	if event=="CHAT_MSG_ADDON" then
		GetExtVer(self,addonName,self.VersionID, fuFrame.FasVer, arg1, arg2, arg4)
	end
end)
-------
function PIGCompartmentClick_GDKP()
end
function PIGCompartmentEnter_GDKP(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_BOTTOMLEFT",-2,16);
	GameTooltip:AddLine("|cffFF00FF"..addonName.."|r-"..GetAddOnMetadata(addonName, "Version"))
	GameTooltip:Show();	
end
function PIGCompartmentLeave_GDKP(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:Hide() 
end