local addonName, addonTable = ...;
local L=addonTable.locale
local gsub = _G.string.gsub 
local match = _G.string.match
local _, _, _, tocversion = GetBuildInfo()
local InviteUnit=C_PartyInfo and C_PartyInfo.InviteUnit or InviteUnit
---
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList=Create.PIGOptionsList
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGFontStringBG=Create.PIGFontStringBG
local PIGCloseBut=Create.PIGCloseBut
-----------------------------------------
local Fun=addonTable.Fun
local TihuanBiaoqing=Fun.TihuanBiaoqing
local QuickChatfun=addonTable.QuickChatfun
GMChatStatusFrameDescription=GMChatStatusFrameDescription or CreateFrame("Frame")
GMChatStatusFrameTitleText=GMChatStatusFrameTitleText or CreateFrame("Frame")
---
function QuickChatfun.QuickBut_Jilu()
	local fuFrame=QuickChatFFF_UI
	local fuWidth = fuFrame.Width
	local Width,Height = fuWidth,fuWidth
	local ziframe = {fuFrame:GetChildren()}
	if PIGA["Chat"]["QuickChat_style"]==1 then
		fuFrame.ChatJilu = CreateFrame("Button",nil,fuFrame, "TruncatedButtonTemplate"); 
	elseif PIGA["Chat"]["QuickChat_style"]==2 then
		fuFrame.ChatJilu = CreateFrame("Button",nil,fuFrame, "UIMenuButtonStretchTemplate"); 
	end
	fuFrame.ChatJilu:SetSize(Width,Height);
	fuFrame.ChatJilu:SetFrameStrata("LOW")
	fuFrame.ChatJilu:SetPoint("LEFT",fuFrame,"LEFT",#ziframe*Width,0);
	fuFrame.ChatJilu.Tex = fuFrame.ChatJilu:CreateTexture(nil, "BORDER");
	fuFrame.ChatJilu.Tex:SetTexture("interface/chatframe/ui-chatwhispericon.blp");
	fuFrame.ChatJilu.Tex:SetPoint("CENTER",0,0);
	fuFrame.ChatJilu.Tex:SetSize(Width-6,Height-4);
	PIGEnter(fuFrame.ChatJilu,"|cff00FFff"..KEY_BUTTON1.."-|r|cffFFFF00"..L["CHAT_WHISPER"]..GUILD_BANK_LOG.."\n|cff00FFff"..KEY_BUTTON2.."-|r|cffFFFF00"..CHAT_MSG_PARTY..CHAT_MSG_RAID..GUILD_BANK_LOG.."|r")
	fuFrame.ChatJilu:HookScript("OnEnter", function (self)	
		fuFrame:PIGEnterAlpha()
	end);
	fuFrame.ChatJilu:HookScript("OnLeave", function (self)
		fuFrame:PIGLeaveAlpha()
	end);
	fuFrame.ChatJilu:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",1,-1);
	end);
	fuFrame.ChatJilu:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",0,0);
	end);
	fuFrame.ChatJilu:RegisterForClicks("LeftButtonUp","RightButtonUp")
	fuFrame.youNEWxiaoxinlai=false;
	fuFrame.ChatJilu:SetScript("OnClick", function(self, event)
		if event=="LeftButton" then
			ChatjiluMianban_UI:Hide()
			if miyijiluF_UI:IsShown() then
				miyijiluF_UI:Hide()
			else
				fuFrame.youNEWxiaoxinlai=false;
				miyijiluF_UI:Show()
			end
		else
			miyijiluF_UI:Hide()
			if ChatjiluMianban_UI:IsShown() then
				ChatjiluMianban_UI:Hide()
			else
				ChatjiluMianban_UI:SetFrameLevel(70)
				ChatjiluMianban_UI:Show()	
			end
		end
	end);
	--密语提醒
	local function miyuMGStishi()
		if fuFrame.ChatJilu.Tex:IsShown() then
			fuFrame.ChatJilu.Tex:Hide()
		else
			fuFrame.ChatJilu.Tex:Show()
		end
		if fuFrame.youNEWxiaoxinlai then
			C_Timer.After(0.8,miyuMGStishi)
		else
			fuFrame.ChatJilu.Tex:Show()
		end
	end
	--删除过期记录====================
	local baocuntianshu=PIGA["Chatjilu"]["tianshu"];
	local jilupindaoID={"PARTY","RAID","GUILD"};
	for id=1,#jilupindaoID do
		PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]=PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]] or {["kaiguan"]=true,["tixing"]=true,["neirong"]={}}
	end
	for id=1,#jilupindaoID do
		local shujuyaun=PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]["neirong"];
		if #shujuyaun>0 then
			if #shujuyaun[1]>0 then
				for ii=#shujuyaun[1], 1, -1 do
						local dangqianday=floor(GetServerTime()/60/60/24);
						local jiluday=shujuyaun[1][ii];
						if (dangqianday-jiluday)>baocuntianshu then
							table.remove(shujuyaun[1],ii);
							table.remove(shujuyaun[2],ii);
						end
				end
			end
		end
	end
	--
	local DefaultVV={["kaiguan"]=true,["tixing"]=true,["neirong"]={},["jichengBlack"]=true}
	PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"] or {}
	for k,v in pairs(DefaultVV) do
		if PIGA["Chatjilu"]["jiluinfo"]["WHISPER"][k]==nil then
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"][k]=v
		end
	end
	local miyushuju=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["neirong"];
	if #miyushuju>0 then
		local paixulist = miyushuju[1]
		for iv=#paixulist,1,-1 do
			if paixulist[iv][2]=="BN" then
				miyushuju[2][paixulist[iv][1]]=nil
			end
		end
		for k,v in pairs(miyushuju[2]) do
			for i=#v,1,-1 do
				local baocunTime=baocuntianshu*60*60*24;
				if (GetServerTime()-v[i][2])>baocunTime then
					table.remove(v,i);					
				end
			end
			if #v==0 then
				table.removekey(miyushuju[2],k)
			end
		end
		for x=#miyushuju[1],1,-1 do
			if miyushuju[2][miyushuju[1][x][1]] then
				if #miyushuju[2][miyushuju[1][x][1]]==0 then
					table.remove(miyushuju[1],x);
				end
			else
				table.remove(miyushuju[1],x);
			end
		end
	end
	----
	--密语记录UI=======================================
	local www,hhh,hang_Height,hang_NUM = 170,310,24,12
	local miyijiluF=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,70},{www,hhh},"miyijiluF_UI",true)
	miyijiluF:PIGSetBackdrop()
	miyijiluF:PIGSetMovable()
	miyijiluF:PIGClose()
	miyijiluF.biaoti=PIGFontString(miyijiluF,{"TOP", miyijiluF, "TOP", 0, -4},L["CHAT_WHISPER"]..GUILD_BANK_LOG)
	miyijiluF.biaoti:SetTextColor(1, 0.843, 0, 1);
	PIGLine(miyijiluF,"TOP",-20)
	miyijiluF.kaiguanOpen=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["kaiguan"]
	miyijiluF.tixingOpen=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["tixing"]
	miyijiluF.jichengBlackOpen=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["jichengBlack"]

	miyijiluF.shezhi = CreateFrame("Button",nil,miyijiluF);
	miyijiluF.shezhi:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	miyijiluF.shezhi:SetSize(18,18);
	miyijiluF.shezhi:SetPoint("TOPLEFT",miyijiluF,"TOPLEFT",4,-1.8);
	miyijiluF.shezhi.Tex = miyijiluF.shezhi:CreateTexture(nil,"OVERLAY");
	miyijiluF.shezhi.Tex:SetTexture("interface/gossipframe/bindergossipicon.blp");
	miyijiluF.shezhi.Tex:SetPoint("CENTER", 0, 0);
	miyijiluF.shezhi.Tex:SetSize(16,16);
	miyijiluF.shezhi:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",-1,-1);
	end);
	miyijiluF.shezhi:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER");
	end);
	miyijiluF.shezhi:SetScript("OnClick", function (self)
		if miyijiluF.shezhiF:IsShown() then
			miyijiluF.shezhiF:Hide();
		else
			miyijiluF.shezhiF:Show();
		end
	end)
	miyijiluF.shezhiF=PIGFrame(miyijiluF.shezhi,{"TOPRIGHT",miyijiluF,"TOPLEFT",-1,0},{www,hhh})
	miyijiluF.shezhiF:PIGSetBackdrop()
	miyijiluF.shezhiF:PIGClose()
	miyijiluF.shezhiF:Hide()
	miyijiluF.shezhiF.biaoti=PIGFontString(miyijiluF.shezhiF,{"TOP", miyijiluF.shezhiF, "TOP", 0, -4},L["OPTUI_SET"])
	PIGLine(miyijiluF.shezhiF,"TOP",-20)

	miyijiluF.shezhiF.kaiguan = PIGCheckbutton(miyijiluF.shezhiF,{"TOPLEFT", miyijiluF.shezhiF, "TOPLEFT", 10,-30},{ENABLE..L["CHAT_WHISPER"]..GUILD_BANK_LOG,ENABLE..L["CHAT_WHISPER"]..GUILD_BANK_LOG})
	miyijiluF.shezhiF.kaiguan:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["kaiguan"]=true 
		else
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["kaiguan"]=false 
		end
	end)
	miyijiluF.shezhiF.tixing = PIGCheckbutton(miyijiluF.shezhiF,{"TOPLEFT", miyijiluF.shezhiF, "TOPLEFT", 10,-60},{L["CHAT_WHISPERTIXING"],L["CHAT_WHISPERTIXINGTOP"]})
	miyijiluF.shezhiF.tixing:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["tixing"]=true 
		else
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["tixing"]=false 
		end
	end)
	miyijiluF.shezhiF.jichengBlack = PIGCheckbutton(miyijiluF.shezhiF,{"TOPLEFT", miyijiluF.shezhiF, "TOPLEFT", 10,-90},{"继承"..L["CHAT_FILTERS"]..SETTINGS,"继承过滤设置，被过滤["..WHISPER.."]将不会记录，(具体设置请在聊天过滤中设置，在密语按钮右边)"})
	miyijiluF.shezhiF.jichengBlack:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["jichengBlack"]=true 
		else
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["jichengBlack"]=false 
		end
	end)
	---重置密语记录
	miyijiluF.shezhiF.MIYUJILUBUT = PIGButton(miyijiluF.shezhiF, {"BOTTOMLEFT",miyijiluF.shezhiF,"BOTTOMLEFT",30,10},{76,20},L["ERROR_CLEAR"]..GUILD_BANK_LOG);  
	miyijiluF.shezhiF.MIYUJILUBUT:SetScript("OnClick", function ()
		StaticPopup_Show("CHONGZHI_MIYUJILU");
	end);
	miyijiluF.shezhiF:SetScript("OnShow", function (self)
		self.kaiguan:SetChecked(PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["kaiguan"])
		self.tixing:SetChecked(PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["tixing"])
		self.jichengBlack:SetChecked(PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["jichengBlack"])
	end)

	--右键功能
	local listName={INVITE..GROUPS,STATUS_TEXT_TARGET..INFO,ADD_FRIEND,INVITE..GUILD,CALENDAR_COPY_EVENT..NAME,INVTYPE_RANGED..INSPECT,CANCEL}
	local FasongYCqingqiu=addonTable.Fun.FasongYCqingqiu
	local function RGongNeng(menuName,name)
		local fullnameX = name
		if menuName==listName[1] then
			InviteUnit(fullnameX)
		elseif menuName==listName[2] then
			C_FriendList.SendWho(fullnameX)
		elseif menuName==listName[3] then
			C_FriendList.AddFriend(fullnameX)
		elseif menuName==listName[4] then
			GuildInvite(fullnameX)
		elseif menuName==listName[5] then
			local editBoxXX
			editBoxXX = ChatEdit_ChooseBoxForSend()
	        local hasText = (editBoxXX:GetText() ~= "")
	        ChatEdit_ActivateChat(editBoxXX)
			editBoxXX:Insert(fullnameX)
	        if (not hasText) then editBoxXX:HighlightText() end
		elseif menuName==listName[6] then
			FasongYCqingqiu(fullnameX)
		end
	end
	local caidanW,caidanH=www,20
	local beijingico=DropDownList1MenuBackdrop.NineSlice.Center:GetTexture()
	local beijing1,beijing2,beijing3,beijing4=DropDownList1MenuBackdrop.NineSlice.Center:GetVertexColor()
	local Biankuang1,Biankuang2,Biankuang3,Biankuang4=DropDownList1MenuBackdrop:GetBackdropBorderColor()
	miyijiluF.RGN=PIGFrame(miyijiluF,nil,{caidanW,caidanH*#listName+12+16})
	miyijiluF.RGN:SetFrameLevel(10)
	miyijiluF.RGN:PIGSetBackdrop(0.9)
	miyijiluF.RGN:SetScript("OnUpdate", function(self, ssss)
		if not self.zhengzaixianshi then return end
		if self.zhengzaixianshi then
			if self.xiaoshidaojishi<= 0 then
				self:Hide();
				self.zhengzaixianshi = nil;
			else
				self.xiaoshidaojishi = self.xiaoshidaojishi - ssss;	
			end
		end
	end)
	miyijiluF.RGN:SetScript("OnEnter", function(self)
		self.zhengzaixianshi = nil;
	end)
	miyijiluF.RGN:SetScript("OnLeave", function(self)
		self.xiaoshidaojishi = 1.5;
		self.zhengzaixianshi = true;
	end)
	---
	miyijiluF.RGN.name = PIGFontString(miyijiluF.RGN,{"TOP",miyijiluF.RGN,"TOP",0,-4});
	------
	for i=1,#listName do
		local RGNTAB = CreateFrame("Frame", "RGNTAB_"..i, miyijiluF.RGN);
		RGNTAB:SetSize(caidanW,caidanH);
		if i==1 then
			RGNTAB:SetPoint("TOPLEFT", miyijiluF.RGN, "TOPLEFT", 4, -22);
		else
			RGNTAB:SetPoint("TOPLEFT", _G["RGNTAB_"..(i-1)], "BOTTOMLEFT", 0, 0);
		end
		RGNTAB.Title = PIGFontString(RGNTAB,{"LEFT", RGNTAB, "LEFT", 6, 0},listName[i]);
		RGNTAB.Title:SetTextColor(1, 1, 1, 1)
		RGNTAB.highlight1 = RGNTAB:CreateTexture(nil, "BORDER");
		RGNTAB.highlight1:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		RGNTAB.highlight1:SetPoint("CENTER", RGNTAB, "CENTER", -3,0);
		RGNTAB.highlight1:SetSize(caidanW-18,16);
		RGNTAB.highlight1:SetAlpha(0.9);
		RGNTAB.highlight1:Hide();
		RGNTAB:SetScript("OnEnter", function(self)
			self.highlight1:Show()
			miyijiluF.RGN.zhengzaixianshi = nil;
		end);
		RGNTAB:SetScript("OnLeave", function(self)
			self.highlight1:Hide()
			miyijiluF.RGN.xiaoshidaojishi = 1.5;
			miyijiluF.RGN.zhengzaixianshi = true;
		end);
		RGNTAB:SetScript("OnMouseDown", function(self)
			self.Title:SetPoint("LEFT", self, "LEFT", 7.4, -1.4);
		end);
		RGNTAB:SetScript("OnMouseUp", function(self)
			self.Title:SetPoint("LEFT", self, "LEFT", 6, 0);
			miyijiluF.RGN:Hide();
			RGongNeng(self.Title:GetText(),miyijiluF.RGN.name.X)
		end);
	end
	---------
	local function PIG_GetbetIDName(duibiID)
		local numBNetTotal = BNGetNumFriends()
		for bnid=1,numBNetTotal do
			local bninfo=C_BattleNet.GetAccountInfoByID(bnid)		
			local _, batdaima = strsplit("#", bninfo.battleTag);
			if duibiID==batdaima then
				return bninfo.accountName,bnid
			end
		end
		return UNKNOWNOBJECT,0
	end
	miyijiluF.F = CreateFrame("Frame", nil, miyijiluF);
	miyijiluF.F:SetPoint("TOPLEFT",miyijiluF,"TOPLEFT",0,-20);
	miyijiluF.F:SetPoint("BOTTOMRIGHT",miyijiluF,"BOTTOMRIGHT",0,0);
	local function gengxinhang(self)
		if not miyijiluF_UI:IsShown() then return end
		for id = 1, hang_NUM do
			_G["MSGhang_"..id]:Hide()
	    end
	    local shuju=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["neirong"]
		if #shuju>0 then
			local ItemsNum = #shuju[1];
			FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
			local offset = FauxScrollFrame_GetOffset(self);
		    for id = 1, hang_NUM do
				local dangqian = id+offset;
				if shuju[1][dangqian] then
					local hang = _G["MSGhang_"..id]
					hang:Show();
					hang.name.Xlx=shuju[1][dangqian][2]
					hang.name.X=shuju[1][dangqian][1]
					if shuju[1][dangqian][2]=="BN_1" then
						hang.zhiye:SetTexture("interface/friendsframe/battlenet-portrait.blp");
						hang.zhiye:SetTexCoord(0,1,0,1);
						local PIGaccountName=PIG_GetbetIDName(shuju[1][dangqian][1])
						hang.name:SetText(PIGaccountName);
					else
						hang.zhiye:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
						local coords = CLASS_ICON_TCOORDS[shuju[1][dangqian][2]]
						hang.zhiye:SetTexCoord(unpack(coords));
						local name1,name2 = strsplit("-", shuju[1][dangqian][1]);
						if name2 and name2 ~= Pig_OptionsUI.Realm then
							hang.name:SetText(name1.."(*)");
						else
							hang.name:SetText(name1);
						end
					end
					local nrname=shuju[1][dangqian][1]
					local nrheji=shuju[2][nrname]
					if nrheji[#nrheji][1]=="CHAT_MSG_WHISPER" then
						hang.name.Xlx=shuju[1][dangqian][2]
						if shuju[1][dangqian][3] then
							local color = PIG_CLASS_COLORS[shuju[1][dangqian][2]];
							hang.name:SetTextColor(color.r, color.g, color.b, 1);
						else
							hang.name:SetTextColor(0.9, 0.9, 0.9, 1);
						end
					elseif nrheji[#nrheji][1]=="CHAT_MSG_BN_WHISPER" then
						
						if shuju[1][dangqian][3] then
							hang.name:SetTextColor(0, 1, 0.9647, 1);
						else
							hang.name:SetTextColor(0.9, 0.9, 0.9, 1);
						end
					else
						hang.name:SetTextColor(0.5, 0.5, 0.5, 1);
					end
					hang.del:SetID(dangqian);
				end
			end
		end
	end
	StaticPopupDialogs["CHONGZHI_MIYUJILU"] = {
		text = string.format(L["CHAT_JILUTDEL"],L["CHAT_WHISPER"]),
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["neirong"] = {["kaiguan"]=true,["tixing"]=true,["neirong"]={}}
			gengxinhang(miyijiluF.F.Scroll)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	miyijiluF.F.Scroll = CreateFrame("ScrollFrame",nil,miyijiluF.F, "FauxScrollFrameTemplate");  
	miyijiluF.F.Scroll:SetPoint("TOPLEFT",miyijiluF.F,"TOPLEFT",0,-1);
	miyijiluF.F.Scroll:SetPoint("BOTTOMRIGHT",miyijiluF.F,"BOTTOMRIGHT",-20,0);
	miyijiluF.F.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, gengxinhang)
	end)
	miyijiluF.F.Scroll.ScrollBar:SetScale(0.8);
	for id = 1, hang_NUM do
		local hang = CreateFrame("Frame", "MSGhang_"..id, miyijiluF.F.Scroll:GetParent());
		hang:SetSize(www, hang_Height);
		if id==1 then
			hang:SetPoint("TOPLEFT",miyijiluF.F.Scroll,"TOPLEFT",0,0);
		else
			hang:SetPoint("TOP",_G["MSGhang_"..(id-1)],"BOTTOM",0,0);
		end
		hang:SetScript("OnEnter",  function(self)
			miyijiluF.zhengzaixianshi = nil;
			local WowWidth=GetScreenWidth()*0.5-300;
			local offset = miyijiluF:GetLeft();
			miyijiluF.nr:ClearAllPoints();
			if offset<WowWidth then
				miyijiluF.nr:SetPoint("TOPLEFT",miyijiluF,"TOPRIGHT",1,0);
			else
				miyijiluF.nr:SetPoint("TOPRIGHT",miyijiluF,"TOPLEFT",-1,0);
			end
			miyijiluF.nr:Show()
			self.highlight:Show();
			miyijiluF.nr.Scroll:Clear()

			local idxx=self.del:GetID()
			local shuju=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["neirong"]
			shuju[1][idxx][3]=false

			self.Aname = UNKNOWNOBJECT
			self.argbHex="ffffffff"
			if shuju[1][idxx][2]=="BN_1" then
				local PIGaccountName=PIG_GetbetIDName(self.name.X)
				self.Aname = PIGaccountName
				self.argbHex="ff00fff6"
				miyijiluF.nr.text:SetText("|c"..self.argbHex..PIGaccountName.."|r "..L["CHAT_WHISPER"]..GUILD_BANK_LOG);
			else
				local name1,name2 = strsplit("-", self.name.X);
				self.Aname = name1
				local color = PIG_CLASS_COLORS[shuju[1][idxx][2]];
				self.argbHex=color.colorStr
				miyijiluF.nr.text:SetText("|c"..self.argbHex..shuju[1][idxx][1].."|r "..L["CHAT_WHISPER"]..GUILD_BANK_LOG);
			end
			if self.Aname == UNKNOWNOBJECT then return end
		
			local nering=shuju[2][shuju[1][idxx][1]]
			local zonghhh=#nering
			if nering[zonghhh][1]=="CHAT_MSG_WHISPER_INFORM"  or nering[zonghhh][1]=="CHAT_MSG_BN_WHISPER_INFORM" then
				self.name:SetTextColor(0.5, 0.5, 0.5, 1);
			else
				self.name:SetTextColor(0.9, 0.9, 0.9, 1);
			end
			miyijiluF.nr.Scroll.ScrollToBottomButton:Hide()
			if zonghhh>9 then
				if zonghhh>21 then
					miyijiluF.nr.Scroll.ScrollToBottomButton:Show()
					miyijiluF.nr:SetHeight(310);
				else
					miyijiluF.nr:SetHeight(zonghhh*16+20);
				end
			else
				miyijiluF.nr:SetHeight(150);
			end
			--
			for ix=1,zonghhh do
				local Event =nering[ix][1];
				local info2 ="[\124cffC0C0C0"..date("%m-%d %H:%M",nering[ix][2]).."]\124r ";
				local info4_jiluxiaoxineirong =nering[ix][3];
				local textCHATINFO="";
				if Event=="CHAT_MSG_WHISPER_INFORM" then
					local xinxi_1 = string.format(CHAT_WHISPER_INFORM_GET,"|Hplayer:"..self.Aname..":000:WHISPER:"..self.Aname.."|h[|cff888888"..self.Aname.."|r]|h")
					textCHATINFO=info2.."\124cff888888"..xinxi_1..info4_jiluxiaoxineirong.."\124r";						
				elseif Event=="CHAT_MSG_WHISPER" then
					local xinxi_2 = string.format(CHAT_WHISPER_GET,"[|c"..self.argbHex..self.Aname.."|r]|h")
					textCHATINFO=info2.."\124cffFF80FF|Hplayer:"..self.Aname..":000:WHISPER:"..self.Aname.."|h"..xinxi_2..info4_jiluxiaoxineirong.."\124r";
				elseif Event=="CHAT_MSG_BN_WHISPER" then
					local xinxi_2 = string.format(CHAT_WHISPER_GET,"|HBNplayer:"..self.Aname..":1:299:BN_WHISPER:"..self.Aname.."|h["..self.Aname.."]|h")
					textCHATINFO=info2.."\124c"..self.argbHex..xinxi_2..info4_jiluxiaoxineirong.."\124r";
				elseif Event=="CHAT_MSG_BN_WHISPER_INFORM" then
					local xinxi_2 = string.format(CHAT_WHISPER_INFORM_GET,"|HBNplayer:"..self.Aname..":12:298:BN_WHISPER:"..self.Aname.."|h["..self.Aname.."]|h")
					textCHATINFO=info2.."\124cff888888"..xinxi_2..info4_jiluxiaoxineirong.."\124r";
				end
				miyijiluF.nr.Scroll:AddMessage(textCHATINFO, nil, nil, nil, nil, true);
				miyijiluF.nr.Scroll:Show()
			end
		end)
		hang:SetScript("OnLeave",  function(self)
			miyijiluF.xiaoshidaojishi = 0.2;
			miyijiluF.zhengzaixianshi = true;
			self.highlight:Hide();
		end)
		hang:SetScript("OnMouseUp", function(self,button)
			local nameinfo = self.name.X
			if self.name.Xlx=="BN_1" then
				local _,bnetIDAccount=PIG_GetbetIDName(self.name.X)
				local displayName = BNGetDisplayName(bnetIDAccount);
				ChatFrame_SendBNetTell(displayName)
			else
				local nameyc1, nameyc2 = strsplit("-", nameinfo)
				if nameyc2 and nameyc2==Pig_OptionsUI.Realm then
					nameinfo=nameyc1;
				end
				if button=="LeftButton" then
					ChatFrame_SendTell(nameinfo.." ".. ChatEdit_ChooseBoxForSend():GetText(), DEFAULT_CHAT_FRAME);
				elseif button=="RightButton" then
					miyijiluF.RGN:ClearAllPoints();
					miyijiluF.RGN:SetPoint("TOPLEFT",self,"BOTTOMLEFT",0,0);
					miyijiluF.RGN:Show()
					miyijiluF.RGN.name:SetText(nameinfo);
					miyijiluF.RGN.name.X=nameinfo;
					miyijiluF.RGN.xiaoshidaojishi = 1.5;
					miyijiluF.RGN.zhengzaixianshi = true;
				end
			end
		end)
		hang.highlight = hang:CreateTexture(nil, "BORDER");
		hang.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		hang.highlight:SetBlendMode("ADD")
		hang.highlight:SetPoint("CENTER", hang, "CENTER", 0,0);
		hang.highlight:SetSize(www, hang_Height-2);
		hang.highlight:SetAlpha(0.4);
		hang.highlight:Hide();
		if id~=hang_NUM then
			PIGLine(hang,"BOT",0,nil,nil,{0.14,0.14,0.14,0.9})
		end
		hang.zhiye = hang:CreateTexture(nil, "BORDER");
		hang.zhiye:SetPoint("LEFT", hang, "LEFT", 4,0);
		hang.zhiye:SetSize(hang_Height-5,hang_Height-5);
		hang.name = PIGFontString(hang,{"LEFT", hang.zhiye, "RIGHT", 4,0},nil,nil,13)
		hang.del = PIGCloseBut(hang,{"RIGHT",hang,"RIGHT",-14,-0});
		hang.del.Tex:SetAlpha(0.5)
		hang.del:HookScript("OnClick", function (self)
			local idid=self:GetID()
			local shuju=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["neirong"]	
			table.removekey(shuju[2],shuju[1][idid][1])
			table.remove(shuju[1],idid);
			gengxinhang(miyijiluF.F.Scroll)
		end)
	end
	---聊天内容显示区域---
	miyijiluF.nr=PIGFrame(miyijiluF,{"TOPRIGHT",miyijiluF,"TOPLEFT",-1,0},{400,120})
	miyijiluF.nr:PIGSetBackdrop()
	miyijiluF.nr:Hide()
	miyijiluF.nr:HookScript("OnEnter",  function(self)
		self:Show();
		miyijiluF.zhengzaixianshi = nil;
	end)
	miyijiluF.nr:HookScript("OnLeave",  function(self)
		miyijiluF.xiaoshidaojishi = 0.2;
		miyijiluF.zhengzaixianshi = true;
	end)
	miyijiluF.nr:HookScript("OnUpdate", function(self, ssss)
		if miyijiluF.zhengzaixianshi==nil then
			return;
		else
			if miyijiluF.zhengzaixianshi==true then
				if miyijiluF.xiaoshidaojishi<= 0 then
					miyijiluF.nr:Hide();
					miyijiluF.zhengzaixianshi = nil;
				else
					miyijiluF.xiaoshidaojishi = miyijiluF.xiaoshidaojishi - ssss;	
				end
			end
		end
	end)
	miyijiluF.nr.text = PIGFontString(miyijiluF.nr,{"TOPLEFT",miyijiluF.nr,"TOPLEFT",4,-1});
	PIGLine(miyijiluF.nr,"TOP",-20)
	---
	miyijiluF.nr.Scroll = CreateFrame("ScrollingMessageFrame", "ChatFrame89", miyijiluF.nr, "ChatFrameTemplate")
	miyijiluF.nr.Scroll:SetPoint("TOPLEFT",miyijiluF.nr,"TOPLEFT",4,-22);
	miyijiluF.nr.Scroll:SetPoint("BOTTOMRIGHT",miyijiluF.nr,"BOTTOMRIGHT",-2,3);
	miyijiluF.nr.Scroll:UnregisterAllEvents()
	--miyijiluF.nr.Scroll:SetHyperlinksEnabled(true)--可点击
	miyijiluF.nr.Scroll:SetMaxLines(9984)
	miyijiluF.nr.Scroll:SetFading(false)
	miyijiluF.nr.Scroll:SetFrameStrata("HIGH")
	miyijiluF.nr.Scroll:HookScript("OnEnter",  function(self)
		miyijiluF.nr:Show();
		miyijiluF.zhengzaixianshi = nil;
	end)
	miyijiluF.nr.Scroll:HookScript("OnLeave",  function(self)
		miyijiluF.xiaoshidaojishi = 0.2;
		miyijiluF.zhengzaixianshi = true;
	end)
	miyijiluF.nr.Scroll:HookScript("OnMouseWheel", function(self, delta)
		if delta == 1 then
			self:ScrollUp()
			self.ScrollToBottomButton.hilight:Show();
		elseif delta == -1 then
			self:ScrollDown()
			if self:GetScrollOffset()==0 then
				self.ScrollToBottomButton.hilight:Hide();
			end
		end
	end)
	---翻页按钮---
	local anniudaxiaoF = 24
	miyijiluF.nr.Scroll.ScrollToBottomButton = CreateFrame("Button",nil,miyijiluF.nr.Scroll, "TruncatedButtonTemplate");
	miyijiluF.nr.Scroll.ScrollToBottomButton:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
	miyijiluF.nr.Scroll.ScrollToBottomButton:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	miyijiluF.nr.Scroll.ScrollToBottomButton:SetPushedTexture("interface/chatframe/ui-chaticon-scrollend-down.blp")
	miyijiluF.nr.Scroll.ScrollToBottomButton:SetSize(anniudaxiaoF,anniudaxiaoF);
	miyijiluF.nr.Scroll.ScrollToBottomButton:SetPoint("BOTTOMRIGHT",miyijiluF.nr.Scroll,"BOTTOMRIGHT",0,4);
	miyijiluF.nr.Scroll.ScrollToBottomButton.hilight = miyijiluF.nr.Scroll.ScrollToBottomButton:CreateTexture(nil,"OVERLAY");
	miyijiluF.nr.Scroll.ScrollToBottomButton.hilight:SetTexture("interface/chatframe/ui-chaticon-blinkhilight.blp");
	miyijiluF.nr.Scroll.ScrollToBottomButton.hilight:SetSize(anniudaxiaoF,anniudaxiaoF);
	miyijiluF.nr.Scroll.ScrollToBottomButton.hilight:SetPoint("CENTER", 0, 0);
	miyijiluF.nr.Scroll.ScrollToBottomButton.hilight:Hide();
	miyijiluF.nr.Scroll.ScrollToBottomButton:HookScript("OnEnter",  function(self)
		miyijiluF.nr:Show();
		miyijiluF.zhengzaixianshi = nil;
	end)
	miyijiluF.nr.Scroll.ScrollToBottomButton:HookScript("OnLeave",  function(self)
		miyijiluF.xiaoshidaojishi = 0.2;
		miyijiluF.zhengzaixianshi = true;
	end)
	miyijiluF.nr.Scroll.ScrollToBottomButton:HookScript("OnClick", function (self)
		miyijiluF.nr.Scroll:ScrollToBottom()
		self.hilight:Hide();
	end);
	---
	miyijiluF:HookScript("OnShow", function(self)
		gengxinhang(miyijiluF.F.Scroll)
	end)
	----
	miyijiluF:RegisterEvent("CHAT_MSG_BN_WHISPER");
	miyijiluF:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM");
	miyijiluF:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
	miyijiluF:RegisterEvent("CHAT_MSG_WHISPER");
	miyijiluF:HookScript("OnEvent", function (self,event,arg1,arg2,arg3,arg4,arg5,_,_,_,_,_,_,arg12,arg13)
		if not miyijiluF.kaiguanOpen then return end
		if not arg2 then return end
		if not arg12 and not arg13 then return end
		if arg1:match("!Pig:") then return end
		if event=="CHAT_MSG_WHISPER" then
			if miyijiluF.jichengBlackOpen then
				if QuickChatfun.QuickBut_miyijiluGL(arg2,arg5,arg1) then
					return
				end
			end
		end
		if event=="CHAT_MSG_WHISPER_INFORM" or event=="CHAT_MSG_BN_WHISPER_INFORM" then
			if miyijiluF.tixingOpen and fuFrame.youNEWxiaoxinlai==true and not miyijiluF_UI:IsVisible() then
				fuFrame.youNEWxiaoxinlai=false
			end
		end
		if event=="CHAT_MSG_WHISPER" or event=="CHAT_MSG_BN_WHISPER" then
			if miyijiluF.tixingOpen and fuFrame.youNEWxiaoxinlai==false and not miyijiluF_UI:IsVisible() then
				fuFrame.youNEWxiaoxinlai=true 
				miyuMGStishi() 
			end
		end
		if arg12 then
			self.miyuren=arg2
			local izedClass, englishClass, localizedRace, englishRace, sex, name, realm = GetPlayerInfoByGUID(arg12)
			self.englishClass=englishClass
			local name1,name2 = strsplit("-", arg2);
			if not name2 then
				if realm and realm~="" and realm~=" " then
					self.miyuren=arg2.."-"..realm
				else
					self.miyuren=arg2.."-"..Pig_OptionsUI.Realm
				end
			end
		elseif arg13 then
			local bninfo=C_BattleNet.GetAccountInfoByID(arg13)		
			local _, batdaima = strsplit("#", bninfo.battleTag);
			self.miyuren=batdaima
			self.englishClass="BN_1"	
		end
		local xiaoxiTime=GetServerTime()
		local huancunshuju=PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["neirong"]
		if #huancunshuju>0 then
			self.yijingcunzairiqi=false
			for f=#huancunshuju[1], 1, -1 do
				if huancunshuju[1][f][1]==self.miyuren then
					table.remove(huancunshuju[1],f);
					table.insert(huancunshuju[1],1,{self.miyuren,self.englishClass,true});
					if not huancunshuju[2] then
						huancunshuju[2][self.miyuren]={}
					end
					table.insert(huancunshuju[2][self.miyuren], {event,xiaoxiTime,arg1});
					self.yijingcunzairiqi=true;
					break
				end
			end
			if self.yijingcunzairiqi==false then
				table.insert(huancunshuju[1],1,{self.miyuren,self.englishClass,true});
				huancunshuju[2][self.miyuren]={{event,xiaoxiTime,arg1}}
			end
		else
			PIGA["Chatjilu"]["jiluinfo"]["WHISPER"]["neirong"]={
				{{self.miyuren,self.englishClass,true}},{[self.miyuren]={{event,xiaoxiTime,arg1}}}
			}
		end
		C_Timer.After(0.1,function() gengxinhang(miyijiluF.F.Scroll) end)
	end)
	
	--队伍/团队聊天记录--------------
	local jilupindaoEvent={
		["PARTY"]={"CHAT_MSG_PARTY","CHAT_MSG_PARTY_LEADER"},
		["RAID"]={"CHAT_MSG_RAID","CHAT_MSG_RAID_LEADER","CHAT_MSG_RAID_WARNING"},
		["GUILD"]={"CHAT_MSG_GUILD"}
	};
	local pindaoColor = {["PARTY"]={0.6667, 0.6667, 1},["RAID"]={1, 0.498, 0},["GUILD"]={0.25, 1, 0.25}};
	local pindaoColorCFF={["PARTY"]="AAAAFF",["RAID"]="FF7F00",["GUILD"]="40FF40"};
	local ChatWidth,ChatHeight=220,260;
	local ChatjiluMianban=PIGFrame(UIParent,{"CENTER",UIParent,"CENTER",0,80},{ChatWidth*4,ChatHeight*2},"ChatjiluMianban_UI",true)
	ChatjiluMianban:PIGSetBackdrop()
	ChatjiluMianban:PIGSetMovable()
	ChatjiluMianban:PIGClose()
	ChatjiluMianban.biaoti=PIGFontString(ChatjiluMianban,{"TOP", ChatjiluMianban, "TOP", 0, -4},L["CHAT_TABNAME"]..GUILD_BANK_LOG)
	PIGLine(ChatjiluMianban,"TOP",-20)

	--保存天数
	ChatjiluMianban.baocuntianchu=PIGFontString(ChatjiluMianban,{"TOPLEFT",ChatjiluMianban,"TOPLEFT",580,-29},SAVE..TIME_LABEL)
	local baocuntianshulist ={7,31,180,365};
	local baocuntianshulistN ={[7]=L["CHAT_JILUTIME"][1],[31]=L["CHAT_JILUTIME"][2],[180]=L["CHAT_JILUTIME"][3],[365]=L["CHAT_JILUTIME"][4]};
	ChatjiluMianban.tianshuxiala=PIGDownMenu(ChatjiluMianban,{"LEFT",ChatjiluMianban.baocuntianchu,"RIGHT", 2,0},{70,22})
	ChatjiluMianban.tianshuxiala:SetFrameLevel(ChatjiluMianban.tianshuxiala:GetFrameLevel()+5)
	ChatjiluMianban.tianshuxiala:PIGDownMenu_SetText(baocuntianshulistN[PIGA["Chatjilu"]["tianshu"]])
	function ChatjiluMianban.tianshuxiala:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#baocuntianshulist,1 do
		    info.text, info.arg1, info.arg2 = baocuntianshulistN[baocuntianshulist[i]], baocuntianshulist[i], baocuntianshulist[i]
		    info.checked = baocuntianshulist[i]==PIGA["Chatjilu"]["tianshu"]
			ChatjiluMianban.tianshuxiala:PIGDownMenu_AddButton(info)
		end 
	end
	function ChatjiluMianban.tianshuxiala:PIGDownMenu_SetValue(value,arg1,arg2)
		ChatjiluMianban.tianshuxiala:PIGDownMenu_SetText(value)
		PIGA["Chatjilu"]["tianshu"]=arg1
		PIGCloseDropDownMenus()
	end

	ChatjiluMianban.qingkong = PIGButton(ChatjiluMianban,{"TOPRIGHT",ChatjiluMianban,"TOPRIGHT",-40,-24},{90,22},L["ERROR_CLEAR"]..GUILD_BANK_LOG);
	ChatjiluMianban.qingkong:SetFrameLevel(ChatjiluMianban.qingkong:GetFrameLevel()+5)
	ChatjiluMianban.qingkong:SetScript("OnClick", function (self)
		StaticPopup_Show ("QINGKONGLIAOTIANJILU");
	end);
	StaticPopupDialogs["QINGKONGLIAOTIANJILU"] = {
		text = string.format(L["CHAT_JILUTDEL"],PARTY.."/"..RAID.."/"..GUILD),
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			for id=1,#jilupindaoID do
				PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]= {["kaiguan"]=true,["tixing"]=true,["neirong"]={}}
			end
			ChatjiluMianban:Hide()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}

	---显示区域
	ChatjiluMianban.nr=PIGOptionsList_RF(ChatjiluMianban,50)
	ChatjiluMianban.nr.tishiliulan = PIGFontString(ChatjiluMianban.nr,{"CENTER",ChatjiluMianban.nr,"CENTER",0,0},L["CHAT_JILUTISHI"]);
	-------
	function ChatjiluMianban.shijianzhucequxiao(pindaoID,onoff,shijianUI)
		if onoff then
			PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[pindaoID]]["kaiguan"]=true;
			for jj=1,#jilupindaoEvent[jilupindaoID[pindaoID]] do
				shijianUI:RegisterEvent(jilupindaoEvent[jilupindaoID[pindaoID]][jj]);
			end
		else
			PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[pindaoID]]["kaiguan"]=false;
			for jj=1,#jilupindaoEvent[jilupindaoID[pindaoID]] do
				shijianUI:UnregisterEvent(jilupindaoEvent[jilupindaoID[pindaoID]][jj]);
			end
		end
	end
	local TabWidth,TabHeight,hang_Height,hang_NUM = 80,26,21.4, 20;
	for id=1,#jilupindaoID do
		local PindaolistF =PIGOptionsList_R(ChatjiluMianban.nr,_G[jilupindaoID[id]],TabWidth)
		PindaolistF:HookScript("OnShow", function (self)
			ChatjiluMianban.nr.tishiliulan:Hide()
		end);
		--记录频道选择
		PindaolistF.CheckBUT = PIGCheckbutton(PindaolistF,nil,{GUILD_BANK_LOG.."|cff"..pindaoColorCFF[jilupindaoID[id]].."[".._G[jilupindaoID[id]].."]|r"..CHAT_CHANNELS,nil});
		PindaolistF.CheckBUT:SetPoint("TOPLEFT",PindaolistF,"TOPLEFT",360,20);
		PindaolistF.CheckBUT:SetChecked(PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]["kaiguan"]);
		PindaolistF.CheckBUT:SetScript("OnClick", function (self)
			ChatjiluMianban.shijianzhucequxiao(id,self:GetChecked(),PindaolistF)
		end);

		---左边日期目录
		PindaolistF.riqi_list = PIGFrame(PindaolistF);
		PindaolistF.riqi_list:PIGSetBackdrop()
		PindaolistF.riqi_list:SetWidth(130);
		PindaolistF.riqi_list:SetPoint("TOPLEFT",PindaolistF,"TOPLEFT",4,-4);
		PindaolistF.riqi_list:SetPoint("BOTTOMLEFT",PindaolistF,"BOTTOMLEFT",0,4);
		PindaolistF.riqi_list:HookScript("OnShow", function (self)
		    PindaolistF.riqi_list_gengxin(self.Scroll);
		end);
		PindaolistF.riqi_list.Scroll = CreateFrame("ScrollFrame",nil,PindaolistF.riqi_list, "FauxScrollFrameTemplate");  
		PindaolistF.riqi_list.Scroll:SetPoint("TOPLEFT",PindaolistF.riqi_list,"TOPLEFT",0,-2);
		PindaolistF.riqi_list.Scroll:SetPoint("BOTTOMRIGHT",PindaolistF.riqi_list,"BOTTOMRIGHT",-24,2);
		PindaolistF.riqi_list.Scroll:SetScript("OnVerticalScroll", function(self, offset)
		    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, PindaolistF.riqi_list_gengxin)
		end)
		local hang_Width  = PindaolistF.riqi_list:GetWidth()
		for i=1, hang_NUM, 1 do
			local riqi_list = CreateFrame("Button", "Chatjilu_riqi_list_"..id.."_"..i,PindaolistF.riqi_list);
			riqi_list:SetSize(hang_Width,hang_Height);
			if i==1 then
				riqi_list:SetPoint("TOPLEFT", PindaolistF.riqi_list.Scroll, "TOPLEFT", 0, -1);
			else
				riqi_list:SetPoint("TOPLEFT", _G["Chatjilu_riqi_list_"..id.."_"..(i-1)], "BOTTOMLEFT", 0, 0);
			end
			riqi_list.Title = PIGFontString(riqi_list,{"LEFT", riqi_list, "LEFT", 6, 0})
			riqi_list.Title:SetTextColor(0,250/255,154/255, 1);
			riqi_list.highlight = riqi_list:CreateTexture();
			riqi_list.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
			riqi_list.highlight:SetBlendMode("ADD")
			riqi_list.highlight:SetPoint("LEFT", riqi_list, "LEFT", 2,0);
			riqi_list.highlight:SetSize(hang_Width-6,hang_Height);
			riqi_list.highlight:SetAlpha(0.4);
			riqi_list.highlight:Hide();
			riqi_list.highlight1 = riqi_list:CreateTexture();
			riqi_list.highlight1:SetTexture("interface/buttons/ui-listbox-highlight.blp");
			riqi_list.highlight1:SetPoint("LEFT", riqi_list, "LEFT", 2,0);
			riqi_list.highlight1:SetSize(hang_Width-6,hang_Height);
			riqi_list.highlight1:SetAlpha(0.9);
			riqi_list.highlight1:Hide();
			riqi_list:SetScript("OnEnter", function (self)
				if not self.highlight1:IsShown() then
					self.Title:SetTextColor(1,1,1,1);
					self.highlight:Show();
				end
			end);
			riqi_list:SetScript("OnLeave", function (self)
				if not self.highlight1:IsShown() then
					self.Title:SetTextColor(0,250/255,154/255,1);	
				end
				self.highlight:Hide();
			end);
			riqi_list:SetScript("OnClick", function (self)
				for v=1,hang_NUM do
					local fujix = _G["Chatjilu_riqi_list_"..id.."_"..v]
					fujix.highlight1:Hide();
					fujix.highlight:Hide();
					fujix.Title:SetTextColor(0,250/255,154/255,1);
				end
				self.Title:SetTextColor(1,1,1,1);
				self.highlight1:Show();
				---
				_G["CHatjilu_Msg_Scroll"..id].ShowID=self:GetID()
				_G["CHatjilu_Msg_Scroll"..id]:Clear()
				PindaolistF.zairuliaotianINFO(self:GetID(),id)
			end)
		end

		---右边聊天内容显示区域
		local butWWW,butHHH = 30,30
		PindaolistF.Msg = PIGFrame(PindaolistF);
		PindaolistF.Msg:PIGSetBackdrop()
		PindaolistF.Msg:SetPoint("TOPLEFT",PindaolistF.riqi_list,"TOPRIGHT",4,0);
		PindaolistF.Msg:SetPoint("BOTTOMRIGHT",PindaolistF,"BOTTOMRIGHT",-4,24);
		PindaolistF.Msg.Scroll = CreateFrame("ScrollingMessageFrame", "CHatjilu_Msg_Scroll"..id, PindaolistF.Msg, "ChatFrameTemplate")
		PindaolistF.Msg.Scroll:SetPoint("TOPLEFT",PindaolistF.Msg,"TOPLEFT",4,-4);
		PindaolistF.Msg.Scroll:SetPoint("BOTTOMRIGHT",PindaolistF.Msg,"BOTTOMRIGHT",-26,4);
		PindaolistF.Msg.Scroll:SetFading(false)
		PindaolistF.Msg.Scroll:SetMaxLines(9984)
		PindaolistF.Msg.Scroll:UnregisterAllEvents()
		PindaolistF.Msg.Scroll:SetFrameStrata("MEDIUM")
		PindaolistF.Msg.Scroll:SetToplevel(false)
		PindaolistF.Msg.Scroll:Hide()
		PindaolistF.Msg.Scroll:SetHyperlinksEnabled(true)
		PindaolistF.Msg.Scroll:EnableMouseWheel(true)
		---按钮
		PindaolistF.Msg.Scroll.ScrollToBottomButton = CreateFrame("Button",nil,PindaolistF.Msg.Scroll, "TruncatedButtonTemplate");
		PindaolistF.Msg.Scroll.ScrollToBottomButton:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
		PindaolistF.Msg.Scroll.ScrollToBottomButton:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		PindaolistF.Msg.Scroll.ScrollToBottomButton:SetPushedTexture("interface/chatframe/ui-chaticon-scrollend-down.blp")
		PindaolistF.Msg.Scroll.ScrollToBottomButton:SetSize(butWWW,butHHH);
		PindaolistF.Msg.Scroll.ScrollToBottomButton:SetPoint("BOTTOMLEFT",PindaolistF.Msg.Scroll,"BOTTOMRIGHT",-2,4);
		PindaolistF.Msg.Scroll.ScrollToBottomButton.hilight = PindaolistF.Msg.Scroll.ScrollToBottomButton:CreateTexture(nil,"OVERLAY");
		PindaolistF.Msg.Scroll.ScrollToBottomButton.hilight:SetTexture("interface/chatframe/ui-chaticon-blinkhilight.blp");
		PindaolistF.Msg.Scroll.ScrollToBottomButton.hilight:SetSize(butWWW,butHHH);
		PindaolistF.Msg.Scroll.ScrollToBottomButton.hilight:SetPoint("CENTER", 0, 0);
		PindaolistF.Msg.Scroll.ScrollToBottomButton.hilight:Hide();
		PindaolistF.Msg.Scroll.down = CreateFrame("Button",nil,PindaolistF.Msg.Scroll, "TruncatedButtonTemplate");
		PindaolistF.Msg.Scroll.down:SetNormalTexture("interface/chatframe/ui-chaticon-scrolldown-up.blp")
		PindaolistF.Msg.Scroll.down:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		PindaolistF.Msg.Scroll.down:SetPushedTexture("interface/chatframe/ui-chaticon-scrolldown-down.blp")
		PindaolistF.Msg.Scroll.down:SetSize(butWWW,butHHH);
		PindaolistF.Msg.Scroll.down:SetPoint("BOTTOM",PindaolistF.Msg.Scroll.ScrollToBottomButton,"TOP",0,6);
		PindaolistF.Msg.Scroll.up = CreateFrame("Button",nil,PindaolistF.Msg.Scroll, "TruncatedButtonTemplate");
		PindaolistF.Msg.Scroll.up:SetNormalTexture("interface/chatframe/ui-chaticon-scrollup-up.blp")
		PindaolistF.Msg.Scroll.up:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		PindaolistF.Msg.Scroll.up:SetPushedTexture("interface/chatframe/ui-chaticon-scrollup-down.blp")
		PindaolistF.Msg.Scroll.up:SetSize(butWWW,butHHH);
		PindaolistF.Msg.Scroll.up:SetPoint("BOTTOM",PindaolistF.Msg.Scroll.down,"TOP",0,6);
		PindaolistF.Msg.Scroll.shuaxin = CreateFrame("Button","PindaolistF.Msg_shuaxin"..id.."_UI",PindaolistF.Msg.Scroll, "UIMenuButtonStretchTemplate",0);
		PindaolistF.Msg.Scroll.shuaxin:SetHighlightTexture(0);
		PindaolistF.Msg.Scroll.shuaxin:SetSize(butWWW-4,butHHH-4);
		PindaolistF.Msg.Scroll.shuaxin:SetPoint("BOTTOM",PindaolistF.Msg.Scroll.up,"TOP",-0.4,40);
		PindaolistF.Msg.Scroll.shuaxin.highlight = PindaolistF.Msg.Scroll.shuaxin:CreateTexture(nil, "HIGHLIGHT");
		PindaolistF.Msg.Scroll.shuaxin.highlight:SetTexture("interface/buttons/ui-common-mousehilight.blp");
		PindaolistF.Msg.Scroll.shuaxin.highlight:SetBlendMode("ADD")
		PindaolistF.Msg.Scroll.shuaxin.highlight:SetPoint("CENTER", PindaolistF.Msg.Scroll.shuaxin, "CENTER", 0,0);
		PindaolistF.Msg.Scroll.shuaxin.highlight:SetSize(butWWW,butHHH);
		PindaolistF.Msg.Scroll.shuaxin.Normal = PindaolistF.Msg.Scroll.shuaxin:CreateTexture(nil, "BORDER");
		PindaolistF.Msg.Scroll.shuaxin.Normal:SetTexture("interface/buttons/ui-refreshbutton.blp");
		PindaolistF.Msg.Scroll.shuaxin.Normal:SetBlendMode("ADD")
		PindaolistF.Msg.Scroll.shuaxin.Normal:SetPoint("CENTER", PindaolistF.Msg.Scroll.shuaxin, "CENTER", 0,0);
		PindaolistF.Msg.Scroll.shuaxin.Normal:SetSize(butWWW-14,butHHH-14);
		PindaolistF.Msg.Scroll.shuaxin:HookScript("OnMouseDown", function (self)
			PindaolistF.Msg.Scroll.shuaxin.Normal:SetPoint("CENTER", PindaolistF.Msg.Scroll.shuaxin, "CENTER", -1.5,-1.5);
		end);
		PindaolistF.Msg.Scroll.shuaxin:HookScript("OnMouseUp", function (self)
			PindaolistF.Msg.Scroll.shuaxin.Normal:SetPoint("CENTER", PindaolistF.Msg.Scroll.shuaxin, "CENTER", 0,0);
		end);
		-------------
		PindaolistF.Msg.Scroll.kaishi = CreateFrame("Button",nil,PindaolistF.Msg.Scroll, "TruncatedButtonTemplate");
		PindaolistF.Msg.Scroll.kaishi:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		PindaolistF.Msg.Scroll.kaishi:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
		PindaolistF.Msg.Scroll.kaishi:SetPushedTexture("interface/chatframe/ui-chaticon-scrollend-down.blp")
		PindaolistF.Msg.Scroll.kaishi:SetSize(butWWW,butHHH);
		PindaolistF.Msg.Scroll.kaishi:SetPoint("BOTTOM",PindaolistF.Msg.Scroll.shuaxin,"TOP",0,50);
		local buttonNormal=PindaolistF.Msg.Scroll.kaishi:GetNormalTexture() 
		buttonNormal:SetRotation(math.rad(180))
		local buttonPushed=PindaolistF.Msg.Scroll.kaishi:GetPushedTexture() 
		buttonPushed:SetRotation(math.rad(180))
		PindaolistF.Msg.Scroll.del =PIGCloseBut(PindaolistF.Msg.Scroll,{"TOPLEFT",PindaolistF.Msg.Scroll,"TOPRIGHT",1,-4},nil,"PindaolistF.Msg_del"..id.."_UI")

		PindaolistF.Msg.Scroll.kaishi:SetScript("OnClick", function (self)
			PindaolistF.Msg.Scroll:ScrollToTop()
			PindaolistF.Msg.Scroll.kaishi:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-disabled.blp")
			PindaolistF.Msg.Scroll.up:SetNormalTexture("interface/chatframe/ui-chaticon-scrollup-disabled.blp")
			PindaolistF.Msg.Scroll.down:SetNormalTexture("interface/chatframe/ui-chaticon-scrolldown-up.blp")
			PindaolistF.Msg.Scroll.ScrollToBottomButton:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
		end);
		PindaolistF.Msg.Scroll.up:SetScript("OnClick", function (self)
			for i=1,20 do
				PindaolistF.Msg.Scroll:ScrollUp()
			end
			PindaolistF.Msg.Scroll.down:SetNormalTexture("interface/chatframe/ui-chaticon-scrolldown-up.blp")
			PindaolistF.Msg.Scroll.ScrollToBottomButton:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
		end);
		PindaolistF.Msg.Scroll.down:SetScript("OnClick", function (self)
			for i=1,20 do
				PindaolistF.Msg.Scroll:ScrollDown()
			end
			PindaolistF.Msg.Scroll.kaishi:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
			PindaolistF.Msg.Scroll.up:SetNormalTexture("interface/chatframe/ui-chaticon-scrollup-up.blp")
			PindaolistF.Msg.Scroll.Downdaodile()
		end);
		PindaolistF.Msg.Scroll.ScrollToBottomButton:SetScript("OnClick", function (self)
			PindaolistF.Msg.Scroll:ScrollToBottom()
			PindaolistF.Msg.Scroll.kaishi:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
			PindaolistF.Msg.Scroll.up:SetNormalTexture("interface/chatframe/ui-chaticon-scrollup-up.blp")
			PindaolistF.Msg.Scroll.down:SetNormalTexture("interface/chatframe/ui-chaticon-scrolldown-disabled.blp")
			PindaolistF.Msg.Scroll.ScrollToBottomButton:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-disabled.blp")
			PindaolistF.Msg.Scroll.Downdaodile()
		end);
		PindaolistF.Msg.Scroll.shuaxin:SetScript("OnClick", function (self)
			PindaolistF.Msg.Scroll.kaishi:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
			PindaolistF.Msg.Scroll.up:SetNormalTexture("interface/chatframe/ui-chaticon-scrollup-up.blp")
			PindaolistF.Msg.Scroll.down:SetNormalTexture("interface/chatframe/ui-chaticon-scrolldown-disabled.blp")
			PindaolistF.Msg.Scroll.ScrollToBottomButton:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-disabled.blp")
			local ShowID = self:GetParent().ShowID
			if ShowID>0 then
				PindaolistF.Msg.Scroll:Clear()
				PindaolistF.zairuliaotianINFO(ShowID,id)
			end
		end);
		PindaolistF.Msg.Scroll.del:SetScript("OnClick", function (self)
			local fujiK = self:GetParent()
			local ShowID = fujiK.ShowID
			if ShowID and ShowID>0 then
				PindaolistF.Msg.Scroll:Clear()
				table.remove(PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]["neirong"][1],ShowID);
				table.remove(PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]["neirong"][2],ShowID);
			    PindaolistF.riqi_list_gengxin(PindaolistF.riqi_list.Scroll);
			    fujiK.ShowID=0
			end
		end);
		PindaolistF.Msg.Scroll:SetScript("OnMouseWheel", function(self, delta)
			if delta == 1 then
				self.down:SetNormalTexture("interface/chatframe/ui-chaticon-scrolldown-up.blp")
				self.ScrollToBottomButton:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
				self:ScrollUp()
				self.ScrollToBottomButton.hilight:Show();
			elseif delta == -1 then
				self.kaishi:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-up.blp")
				self.up:SetNormalTexture("interface/chatframe/ui-chaticon-scrollup-up.blp")
				self:ScrollDown()
				PindaolistF.Msg.Scroll.Downdaodile()
			end
		end)
		function PindaolistF.Msg.Scroll.Downdaodile()
			if PindaolistF.Msg.Scroll:GetScrollOffset()==0 then
				PindaolistF.Msg.Scroll.ScrollToBottomButton.hilight:Hide();
				PindaolistF.Msg.Scroll.down:SetNormalTexture("interface/chatframe/ui-chaticon-scrolldown-disabled.blp")
				PindaolistF.Msg.Scroll.ScrollToBottomButton:SetNormalTexture("interface/chatframe/ui-chaticon-scrollend-disabled.blp")
			end
		end
		---总行数
		PindaolistF.Msg.Scroll.allhang =PIGFontString(PindaolistF.Msg.Scroll,{"TOP",PindaolistF.Msg,"BOTTOM",0,-4})
		--刷新左边日期列表
		function PindaolistF.riqi_list_gengxin(self)
			for i = 1, hang_NUM do
				local fuji = _G["Chatjilu_riqi_list_"..id.."_"..i]
				fuji:Hide()
				fuji.Title:SetText("");
				fuji.Title:SetTextColor(0,250/255,154/255, 1);
				fuji.highlight1:Hide();
			end
			local laiyuan=jilupindaoID[id];
			if #PIGA["Chatjilu"]["jiluinfo"][laiyuan]["neirong"]>0 then
			    local ItemsNum = #PIGA["Chatjilu"]["jiluinfo"][laiyuan]["neirong"][1];
			    FauxScrollFrame_Update(self, ItemsNum, hang_NUM, hang_Height);
			    local offset = FauxScrollFrame_GetOffset(self);
			    for i = 1, hang_NUM do
					local dangqian = (ItemsNum+1)-i-offset;
					if dangqian>0 then
						local fuji = _G["Chatjilu_riqi_list_"..id.."_"..i]
						fuji:Show()
						fuji:SetID(dangqian)
						fuji.Title:SetText(date("%Y-%m-%d",PIGA["Chatjilu"]["jiluinfo"][laiyuan]["neirong"][1][dangqian]*86400));
						local yijihuohang=_G["CHatjilu_Msg_Scroll"..id].ShowID
						if dangqian==yijihuohang then
							fuji.Title:SetTextColor(1,1,1, 1);
							fuji.highlight1:Show();
						end
					end
				end
			end
		end
		--加载聊天记录
		local JJM = L["CHAT_QUKBUTNAME"]
		local JXname = L["CHAT_JXNAME"]
		function PindaolistF.zairuliaotianINFO(ShowID,id)
			local laiyuan=PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]["neirong"];
			local jilulist=laiyuan[2][ShowID];
			for x=1,#jilulist do
				local Event =jilulist[x][1];
				local info2 ="["..date("%H:%M",jilulist[x][2]).."] ";
				local info3 =jilulist[x][3];
				local info4_jiluxiaoxineirong =jilulist[x][4];
				local info5 =jilulist[x][5];
				local info4_jiluxiaoxineirong = TihuanBiaoqing(info4_jiluxiaoxineirong)
				local textCHATINFO,wjname=""," ";
				local FGname, fuwuqi = strsplit("-", info3)
				if fuwuqi==Pig_OptionsUI.Realm then
					wjname=FGname
				else
					wjname=info3
				end
				if Event=="CHAT_MSG_PARTY_LEADER" then
					textCHATINFO=info2.."|Hchannel:PARTY|h|cff89D2FF["..JXname[1].."]|r|h |Hplayer:"..info3..":000:PARTY:|h|cff89D2FF[|r|c"..info5..wjname.."|r|cff89D2FF]|h："..info4_jiluxiaoxineirong.."|r";
				elseif Event=="CHAT_MSG_PARTY" then							
					textCHATINFO=info2.."|Hchannel:PARTY|h|cffAAAAFF["..JJM[3].."]|r|h |Hplayer:"..info3..":000:PARTY:|h|cffAAAAFF[|r|c"..info5..wjname.."|r|cffAAAAFF]|h："..info4_jiluxiaoxineirong.."\124r";
				elseif Event=="CHAT_MSG_RAID_LEADER" then							
					textCHATINFO=info2.."|Hchannel:RAID|h\124cffFF4809["..JXname[2].."]\124r|h |Hplayer:"..info3..":000:RAID:|h\124cffFF4809[\124r|c"..info5..wjname.."|r\124cffFF4809]|h："..info4_jiluxiaoxineirong.."\124r";
				elseif Event=="CHAT_MSG_RAID" then
					textCHATINFO=info2.."|Hchannel:RAID|h\124cffFF7F00["..JJM[5].."]\124r|h |Hplayer:"..info3..":000:RAID:|h\124cffFF7F00[\124r|c"..info5..wjname.."|r\124cffFF7F00]|h："..info4_jiluxiaoxineirong.."\124r";						
				elseif Event=="CHAT_MSG_RAID_WARNING" then	
					textCHATINFO=info2.."\124cffFF4800["..JJM[6].."]\124r |Hplayer:"..info3..":000:RAID:|h\124cffFF4800[\124r|c"..info5..wjname.."|r\124cffFF4800]|h："..info4_jiluxiaoxineirong.."\124r";
				elseif Event=="CHAT_MSG_GUILD" then	
					textCHATINFO=info2.."\124cff40FF40["..JJM[4].."]\124r |Hplayer:"..info3..":000:GUILD:|h\124cff40FF40[\124r|c"..info5..wjname.."|r\124cff40FF40]|h："..info4_jiluxiaoxineirong.."\124r";
				end
				_G["CHatjilu_Msg_Scroll"..id]:Show()
				_G["CHatjilu_Msg_Scroll"..id]:AddMessage(textCHATINFO, nil, nil, nil, nil, true);	
			end
			local xianshiriqishuju=date("%Y-%m-%d",laiyuan[1][ShowID]*86400)
			PindaolistF.Msg.Scroll.allhang:SetText(xianshiriqishuju.."|cff"..pindaoColorCFF[jilupindaoID[id]].."[".._G[jilupindaoID[id]].."]|r聊天消息总数:|cffffffff"..#jilulist.."|r");
		end
		---根据启用注册事件
		ChatjiluMianban.shijianzhucequxiao(id,PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]["kaiguan"],PindaolistF)
		PindaolistF:HookScript("OnEvent", function (self,event,arg1,arg2,arg3,arg4,arg5,_,_,_,_,_,_,arg12)
			if arg1:match("!Pig:") then return end
			for jj=1,#jilupindaoEvent[jilupindaoID[id]] do
				if event==jilupindaoEvent[jilupindaoID[id]][jj] then
							--print(event,arg1,arg2,arg3,arg4,arg5,arg12)
							local xiaoxiTime=GetServerTime()
							local YYDAY=floor(xiaoxiTime/60/60/24)
							local localizedClass, englishClass = GetPlayerInfoByGUID(arg12)
							local color = PIG_CLASS_COLORS[englishClass];
							local shujuyuanPR=PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]["neirong"]
							if #shujuyuanPR>0 then
								self.yijingcunzairiqi=false
								for f=#shujuyuanPR[1], 1, -1 do
									if shujuyuanPR[1][f]==YYDAY then
										table.insert(shujuyuanPR[2][f], {event,xiaoxiTime,arg2,arg1,color.colorStr});
										self.yijingcunzairiqi=true;
										break
									end
								end
								if self.yijingcunzairiqi==false then
									table.insert(shujuyuanPR[1], YYDAY);
									table.insert(shujuyuanPR[2], {{event,xiaoxiTime,arg2,arg1,color.colorStr}});
								end
							else
								PIGA["Chatjilu"]["jiluinfo"][jilupindaoID[id]]["neirong"]={
									{YYDAY},{{{event,xiaoxiTime,arg2,arg1,color.colorStr}}}
								}
							end
				end
			end
		end)
	end
end