local addonName, addonTable = ...;
local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGDiyBut=Create.PIGDiyBut
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGFontString=Create.PIGFontString
local PIGModCheckbutton=Create.PIGModCheckbutton
local PIGQuickBut=Create.PIGQuickBut
local PIGSetFont=Create.PIGSetFont
---
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
------
local GDKPInfo = {}
addonTable.GDKPInfo=GDKPInfo
------------
local QuickBut_xuhaoID=15
local GnName,GnUI,GnIcon,FrameLevel = L["PIGaddonList"][addonName],"PIG_GDKPUI",133784,50
GDKPInfo.uidata={GnName,GnUI,GnIcon,FrameLevel}
local fuFrame,fuFrameBut,Tooltip = unpack(Data.Ext[L.extLsit[2]])
if not fuFrame.OpenMode then return end
fuFrame.extaddonT:Hide()
local QuickButUI=_G[Data.QuickButUIname]
GDKPInfo.fuFrame,GDKPInfo.fuFrameBut=fuFrame,fuFrameBut
---
local function ADD_Options()
	local Key_fenge=Fun.Key_fenge
	fuFrame.Open = PIGModCheckbutton(fuFrame,{GnName,Tooltip},{"TOPLEFT",fuFrame,"TOPLEFT",20,-20})
	fuFrame.Open:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Open"]=true;
			fuFrame.SetListF:Show()
			GDKPInfo.ADD_UI()
		else
			PIGA["GDKP"]["Open"]=false;
			fuFrame.SetListF:Hide()
			PIG_OptionsUI.RLUI:Show()
		end
		QuickButUI.ButList[QuickBut_xuhaoID]()
	end);
	fuFrame.Open.QKBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["AddBut"]=true
			QuickButUI.ButList[QuickBut_xuhaoID]()
		else
			PIGA["GDKP"]["AddBut"]=false
			PIG_OptionsUI.RLUI:Show();
		end
	end);
	QuickButUI.ButList[QuickBut_xuhaoID]=function()
		if PIGA["QuickBut"]["Open"] and PIGA["GDKP"]["Open"] and PIGA["GDKP"]["AddBut"] then
			if QuickButUI.GDKPOpen then return end
			QuickButUI.GDKPOpen=true
			local QuickTooltip = KEY_BUTTON1.."-|cff00FFFF打开"..GnName.."|r\n"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r"
			local QkBut=PIGQuickBut(nil,QuickTooltip,GnIcon,GnUI,FrameLevel)
			QkBut:HookScript("OnClick", function(self,button)
				if button=="RightButton" then
					if PIG_OptionsUI:IsShown() then
						PIG_OptionsUI:Hide()
					else
						PIG_OptionsUI:Show()
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
	"|cffFF0000不会分配任务物品，也不会分配埃提耶什的碎片/瓦兰奈尔的碎片/影霜碎片/烂肠的酸性血液/腐面的酸性血液。|r\n开启此功能后会在队伍/团队频道发送拾取明细"
	fuFrame.SetListF.autofen = PIGCheckbutton_R(fuFrame.SetListF,{"自动分配物品给自己\124cff00FF00(你必须是战利品分配人)\124r",autofentishi},true)
	fuFrame.SetListF.autofen:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["autofen"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["autofen"]=false;
		end
		fuFrame.SetListF.AutoLootfenEvent()
	end);
	fuFrame.SetListF.autofenMsg = PIGCheckbutton_R(fuFrame.SetListF,{"分配后通告","自动分配物品后通告分配物品"},true)
	fuFrame.SetListF.autofenMsg:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["autofenMsg"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["autofenMsg"]=false;
		end
	end);
	-------
	local bufenpei = {
		22726,--埃提耶什的碎片
		45038,--瓦兰奈尔的碎片
		50274,--影霜碎片
		30311,30312,30313,30314,30316,30317,30318,30319,30320,--七武器
		50226,50231,--烂肠的酸性血液/腐面的酸性血液
	}
	local function funbufenpei(itemID)
		if itemID then
			for ix=1,#bufenpei do	
				if itemID == bufenpei[ix] then
					return true
				end
			end
		end
		return false
	end
	local autofenffff = CreateFrame("Frame")
	autofenffff.listdata={}
	autofenffff:SetScript("OnEvent",function(self,event,arg1,_,_,_,arg5)
		if event=="LOOT_CLOSED" then
			wipe(self.listdata)
		elseif IsInGroup() then
			local lootmethod, masterlooterPartyID, masterlooterRaidID= GetLootMethod();
			if lootmethod=="master" and masterlooterPartyID==0 then
				local lootNum = GetNumLootItems()
				if #self.listdata==0 then
					for x=1,lootNum do
						self.listdata[x]={false,false}
						local link = GetLootSlotLink(x)
						if link then
							local itemID = GetItemInfoInstant(link)
							if itemID then
								if funbufenpei(itemID) then
	
								else
									local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem= GetLootSlotInfo(x)
									if locked or isQuestItem or lootQuality<GetLootThreshold() then
										
									else
										self.listdata[x][1]=true
									end
								end
							end
						end
					end
				end
				for x = 1, lootNum do
					if self.listdata[x][1] then
						local link = GetLootSlotLink(x)
						local _, _, lootQuantity= GetLootSlotInfo(x)
						if link and lootQuantity and lootQuantity>0 then
							for ci = 1, GetNumGroupMembers() do
								local candidate = GetMasterLootCandidate(x, ci)
								if candidate == PIG_OptionsUI.Name then
									if CalculateTotalNumberOfFreeBagSlots() > 0 then
										GiveMasterLoot(x, ci);
										if PIGA["GDKP"]["Rsetting"]["autofenMsg"] then
											if not self.listdata[x][2] then
												if lootQuantity>1 then
													PIGSendChatRaidParty("拾取"..link.."×"..lootQuantity)
												else
													PIGSendChatRaidParty("拾取"..link)
												end
												self.listdata[x][2]=true
											end
										end
									end
									break
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
			autofenffff:RegisterEvent("LOOT_CLOSED");
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
	local jiaoyijiluTS="1.交易拾取目录内物品自动录入成交人/成交金额(交易多件物品收到金额将会被平分)\n2.对方交易欠款时自动清欠并显示明细\n3.你发放工资时自动扣除欠款并显示明细"
	fuFrame.SetListF.jiaoyijilu = PIGCheckbutton_R(fuFrame.SetListF,{"交易智能记账清欠",jiaoyijiluTS},true)
	fuFrame.SetListF.jiaoyijilu:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["jiaoyijilu"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["jiaoyijilu"]=false;
		end
	end);
	fuFrame.SetListF.tradetonggao = PIGCheckbutton_R(fuFrame.SetListF,{"通告交易详情","在团队频道通告交易详情"},true)
	fuFrame.SetListF.tradetonggao:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["tradetonggao"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["tradetonggao"]=false;
		end
	end);
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
			if arg5==PIG_OptionsUI.Name then return end
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
	local paichu_Height,paichu_NUM  = 23.6, 18;
	-----------
	fuFrame.SetListF.Paichu = PIGFrame(fuFrame.SetListF,{"TOPLEFT", fuFrame.SetListF, "TOPRIGHT", -260, -28})
	fuFrame.SetListF.Paichu:SetPoint("BOTTOMRIGHT", fuFrame.SetListF, "BOTTOMRIGHT", -6, 6)
	fuFrame.SetListF.Paichu:PIGSetBackdrop()
	fuFrame.SetListF.Paichu.biaoti = PIGFontString(fuFrame.SetListF.Paichu,{"BOTTOMLEFT", fuFrame.SetListF.Paichu, "TOPLEFT", 4, 4},"\124cffFF0000拾取忽略目录\124r");
	--提示
	fuFrame.SetListF.Paichu.biaoti_tishi = CreateFrame("Frame", nil, fuFrame.SetListF.Paichu);
	fuFrame.SetListF.Paichu.biaoti_tishi:SetSize(30,30);
	fuFrame.SetListF.Paichu.biaoti_tishi:SetPoint("LEFT",fuFrame.SetListF.Paichu.biaoti,"RIGHT",-6,0);
	fuFrame.SetListF.Paichu.biaoti_tishi.Tex = fuFrame.SetListF.Paichu.biaoti_tishi:CreateTexture(nil, "BORDER");
	fuFrame.SetListF.Paichu.biaoti_tishi.Tex:SetTexture("interface/common/help-i.blp");
	fuFrame.SetListF.Paichu.biaoti_tishi.Tex:SetAllPoints(fuFrame.SetListF.Paichu.biaoti_tishi)
	PIGEnter(fuFrame.SetListF.Paichu.biaoti_tishi,"提示：","\124cff00ff00拾取记录页面"..KEY_BUTTON2.."点击物品名添加为不记录.\124r")
	fuFrame.SetListF.Paichu.Scroll = CreateFrame("ScrollFrame",nil,fuFrame.SetListF.Paichu, "FauxScrollFrameTemplate");  
	fuFrame.SetListF.Paichu.Scroll:SetPoint("TOPLEFT",fuFrame.SetListF.Paichu,"TOPLEFT",0,0);
	fuFrame.SetListF.Paichu.Scroll:SetPoint("BOTTOMRIGHT",fuFrame.SetListF.Paichu,"BOTTOMRIGHT",-19,2);
	fuFrame.SetListF.Paichu.Scroll.ScrollBar:SetScale(0.8);
	fuFrame.SetListF.Paichu.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, paichu_Height, fuFrame.SetListF.Paichu.Update_hang)
	end)
	local Paichuww = fuFrame.SetListF.Paichu:GetWidth()
	fuFrame.SetListF.Paichu.ButList = {}
	for id = 1, paichu_NUM do
		local Pcwupin = CreateFrame("Frame", nil, fuFrame.SetListF.Paichu);
		fuFrame.SetListF.Paichu.ButList[id]=Pcwupin
		Pcwupin:SetSize(Paichuww-19, paichu_Height);
		if id==1 then
			Pcwupin:SetPoint("TOPLEFT",fuFrame.SetListF.Paichu.Scroll,"TOPLEFT",0,0);
		else
			Pcwupin:SetPoint("TOP",fuFrame.SetListF.Paichu.ButList[id-1],"BOTTOM",0,0);
		end
		if id~=paichu_NUM then
			Pcwupin.line = PIGLine(Pcwupin,"BOT",nil,nil,nil,{0.3,0.3,0.3,0.3})
		end
		Pcwupin.del=PIGDiyBut(Pcwupin,{"LEFT", Pcwupin, "LEFT", 4,0},{paichu_Height-6})
		Pcwupin.del:SetScript("OnClick", function (self)
			table.remove(PIGA["GDKP"]["Rsetting"]["PaichuList"], self:GetID());
			fuFrame.SetListF.Paichu.Update_hang(fuFrame.SetListF.Paichu.Scroll);
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
		fuFrame.SetListF.Paichu.Update_hang(self.Scroll);
	end)
	function fuFrame.SetListF.Paichu.Update_hang(self)
		for id = 1, paichu_NUM do
			fuFrame.SetListF.Paichu.ButList[id]:Hide();
	    end
	    local paichumulu = PIGA["GDKP"]["Rsetting"]["PaichuList"]
	    local ItemsNum = #paichumulu
		if ItemsNum>0 then
			FauxScrollFrame_Update(self, ItemsNum, paichu_NUM, paichu_Height);
			local offset = FauxScrollFrame_GetOffset(self);
			for id = 1, paichu_NUM do
				local dangqianH = id+offset;
				if paichumulu[dangqianH] then
					local fujik=fuFrame.SetListF.Paichu.ButList[id]
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
	fuFrame.SetListF:HookScript("OnShow", function (self)
		self.autofen:SetChecked(PIGA["GDKP"]["Rsetting"]["autofen"]);
		self.autofenMsg:SetChecked(PIGA["GDKP"]["Rsetting"]["autofenMsg"]);
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
	--
	GDKPInfo.ADD_UI()
end
---======
fuFrame:HookScript("OnShow", function (self)
	if PIGA["Ver"][addonName] and PIG_OptionsUI:GetVer_NUM(addonName)<PIGA["Ver"][addonName] then
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
fuFrame:RegisterEvent("ADDON_LOADED")   
fuFrame:RegisterEvent("PLAYER_LOGIN");
fuFrame:RegisterEvent("CHAT_MSG_ADDON"); 
fuFrame:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
	if event=="CHAT_MSG_ADDON" then
		PIG_OptionsUI.GetExtVerInfo(self,addonName,PIG_OptionsUI:GetVer_NUM(addonName), arg1, arg2, arg3, arg4, arg5)
	elseif event=="PLAYER_LOGIN" then
		PIGA["Ver"][addonName]=PIGA["Ver"][addonName] or 0
		if PIGA["Ver"][addonName]>PIG_OptionsUI:GetVer_NUM(addonName) then
			self.yiGenxing=true;
		else
			PIG_OptionsUI.SendExtVerInfo(addonName.."#U#"..PIG_OptionsUI:GetVer_NUM(addonName))
		end
	elseif event=="ADDON_LOADED" and arg1 == addonName then
		self:UnregisterEvent("ADDON_LOADED")
		addonTable.Load_Config()
		PIG_OptionsUI:SetVer_EXT(arg1)
		ADD_Options()
	end
end)
-------
function PIGCompartmentClick_GDKP()
end
function PIGCompartmentEnter_GDKP(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_BOTTOMLEFT",-2,16);
	GameTooltip:AddLine("|cffFF00FF"..addonName.."|r-"..PIGGetAddOnMetadata(addonName, "Version"))
	GameTooltip:Show();	
end
function PIGCompartmentLeave_GDKP(addonName, menuButtonFrame)
	GameTooltip:ClearLines();
	GameTooltip:Hide() 
end