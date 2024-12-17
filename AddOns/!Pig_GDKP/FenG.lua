local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
-----
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGSlider = Create.PIGSlider
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList_RF=Create.PIGOptionsList_RF
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGQuickBut=Create.PIGQuickBut
local Show_TabBut_R=Create.Show_TabBut_R
local PIGFontString=Create.PIGFontString
local PIGSetFont=Create.PIGSetFont
----------
local GDKPInfo=addonTable.GDKPInfo
function GDKPInfo.ADD_fenG(RaidR)
	local GnName,GnUI,GnIcon,FrameLevel = unpack(GDKPInfo.uidata)
	local iconWH,hang_Height,hang_NUM,lineTOP  =  GDKPInfo.iconWH,GDKPInfo.hang_Height,GDKPInfo.hang_NUM,GDKPInfo.lineTOP
	local RaidR=_G[GnUI]
	local fujiF=PIGOptionsList_R(RaidR.F,"分G助手",80)
	fujiF.tishidongjie = PIGFontString(fujiF,{"CENTER",fujiF,"CENTER",0,40},"请先冻结人员信息", "OUTLINE",20);
	fujiF.tishidongjie:SetTextColor(1, 1, 0, 1);
	fujiF.nr = PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",0,0});  
	fujiF.nr:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,0);
	fujiF.nr:Hide()
	function RaidR.Update_FenG_NOdongjie()
		if PIGA["GDKP"]["Dongjie"] then
			fujiF.tishidongjie:Hide();
			fujiF.nr:Show();
			fujiF:RegisterEvent("CHAT_MSG_WHISPER");	
		else
			fujiF.tishidongjie:Show();
			fujiF.nr:Hide();
			fujiF:UnregisterEvent("CHAT_MSG_WHISPER");
		end
	end
	local function SendMailInfo(Name,jinbiV)
		local gold = floor(jinbiV / 1e4)
		local silver = floor(jinbiV / 100 % 100)
		local copper = jinbiV % 100
		SendMailNameEditBox:SetText(Name);
		SendMailSubjectEditBox:SetText(date("%Y-%m-%d",PIGA["GDKP"]["instanceName"][1]).."<"..PIGA["GDKP"]["instanceName"][2]..PIGA["GDKP"]["instanceName"][3]..">");
		SendMailMoneyGold:SetText(gold);
		SendMailMoneySilver:SetText(silver);
		SendMailMoneyCopper:SetText(copper);
		MailEditBox:SetText("这是你在"..date("%Y-%m-%d",PIGA["GDKP"]["instanceName"][1]).."参加".."<"..PIGA["GDKP"]["instanceName"][2]..PIGA["GDKP"]["instanceName"][3]..">活动薪水，请查收");
	end
	--创建队伍角色框架===================
	local zhizeIcon=Data.zhizeIcon
	local fenGbiliIcon=GDKPInfo.fenGbiliIcon
	local LeftmenuV=GDKPInfo.LeftmenuV
	local RightmenuV=GDKPInfo.RightmenuV
	local buzhuzhize=GDKPInfo.buzhuzhize

	local duiwu_Width,duiwu_Height=190,26;
	local jiangeW,jiangeH,PjiangeH=10,0,2;
	for p=1,8 do
		local duiwuF = PIGFrame(fujiF.nr,nil,{duiwu_Width,duiwu_Height*5+PjiangeH*4+1},"RRfenGList_"..p);
		duiwuF:PIGSetBackdrop(0,1)
		if p==1 then
			duiwuF:SetPoint("TOPLEFT",fujiF.nr,"TOPLEFT",8,-26);
		end
		if p>1 and p<5 then
			duiwuF:SetPoint("LEFT",_G["RRfenGList_"..(p-1)],"RIGHT",jiangeW,jiangeH);
		end
		if p==5 then
			duiwuF:SetPoint("TOP",_G["RRfenGList_1"],"BOTTOM",0,-44);
		end
		if p>5 then
			duiwuF:SetPoint("LEFT",_G["RRfenGList_"..(p-1)],"RIGHT",jiangeW,jiangeH);
		end
		---
		duiwuF.tongzhi = CreateFrame("Button",nil,duiwuF);  
		duiwuF.tongzhi:SetSize(iconWH,iconWH);
		duiwuF.tongzhi:SetPoint("BOTTOM",duiwuF,"TOP",-30,0);
		duiwuF.tongzhi:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		duiwuF.tongzhi.Tex = duiwuF.tongzhi:CreateTexture(nil, "BORDER");
		duiwuF.tongzhi.Tex:SetTexture(130979);
		duiwuF.tongzhi.Tex:SetPoint("CENTER",4,0);
		duiwuF.tongzhi.Tex:SetSize(iconWH,iconWH);
		PIGEnter(duiwuF.tongzhi,"通报"..p.."队明细并通知分G人领取小队金额")
		duiwuF.tongzhi:SetScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",2.5,-1.5);
		end);
		duiwuF.tongzhi:SetScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER",4,0);
		end);
		duiwuF.tongzhi:SetScript("OnClick", function(self)	
			local biaojiName={"{rt1}","{rt2}","{rt3}","{rt4}","{rt5}","{rt6}","{rt7}","{rt8}"};
			duiwuF.tongzhi.fenGren=0
			for pp=1,5 do
				if _G["RRfenGList_"..p.."_"..pp].fenGren:GetChecked() then
					duiwuF.tongzhi.fenGren=pp
					break
				end
			end
			if duiwuF.tongzhi.fenGren==0 then
				PIGinfotip:TryDisplayMessage("请先选择分G人");
				return
			end
			local fenGrenFF = _G["RRfenGList_"..p.."_"..duiwuF.tongzhi.fenGren]
			local fenGrenname=fenGrenFF.Name.t:GetText()
			if UnitIsConnected(fenGrenname) then
				PIGSendChatRaidParty("======【"..p.."队】=========");
				local MSGFENGXINXI="小队分G数: "..GetCoinText(duiwuF.jiaoyiG_V)..",分G人员【"..fenGrenname.."】标记为{rt"..p.."}";
				SetRaidTarget(fenGrenname, p);
				PIGSendChatRaidParty(MSGFENGXINXI);
				local msnfenG="明细: ";
				for kk=1,5 do
					local zuwanjiaF = _G["RRfenGList_"..p.."_"..kk]
					local zuwanjiaName = zuwanjiaF.Name.t:GetText()
					if zuwanjiaF:IsShown() then
						msnfenG=msnfenG..zuwanjiaName..":"..GetCoinText(zuwanjiaF.fenGV_V).."，"
					end
				end
				PIGSendChatRaidParty(msnfenG);
				self.Tex:SetDesaturated(true);
			else
				PIGinfotip:TryDisplayMessage("当前分G人已离线，请选择其他未离线成员");
			end	
		end);
		duiwuF.biaoti = PIGFontString(duiwuF,{"LEFT", duiwuF.tongzhi, "RIGHT", 0,1},"\124cff00FF00"..p.."队\124r", "OUTLINE",15);
		duiwuF.jiaoyi = PIGFontString(duiwuF,{"TOPLEFT",duiwuF,"BOTTOMLEFT",2,-1},p.."队总", "OUTLINE");
		duiwuF.jiaoyiG = PIGFontString(duiwuF,{"LEFT",duiwuF.jiaoyi,"RIGHT",0,0},0, "OUTLINE",15);
		duiwuF.jiaoyiG:SetTextColor(1, 1, 1, 1)
		duiwuF.jiaoyi:Hide()
		duiwuF.jiaoyiG:Hide()
		for pp=1,5 do
			local player = CreateFrame("Frame", "RRfenGList_"..p.."_"..pp, duiwuF);
			player:SetSize(duiwu_Width,duiwu_Height);
			if pp==1 then
				player:SetPoint("TOP",duiwuF,"TOP",0,-1);
			else
				player:SetPoint("TOP",_G["RRfenGList_"..p.."_"..(pp-1)],"BOTTOM",0,-PjiangeH);
			end
			if pp~=5 then PIGLine(player,"BOT",-1,nil,nil,{0.3,0.3,0.3,0.3}) end
			-------------
			player.fenGren = CreateFrame("CheckButton", nil, player, "UIRadioButtonTemplate");
			player.fenGren:SetSize(duiwu_Height-10,duiwu_Height-9);
			player.fenGren:SetHitRectInsets(0,0,-2,-2);
			player.fenGren:SetPoint("LEFT",player,"LEFT",1,0);
			PIGEnter(player.fenGren,"设置为"..p.."队分G人员")
			player.fenGren:SetScript("OnClick", function (self)
				for qq=1,5 do
					_G["RRfenGList_"..p.."_"..qq].fenGren:SetChecked(false);
				end
				self:SetChecked(true);
			end)	
			-------------
			player.Name = CreateFrame("Frame", nil, player);
			player.Name:SetPoint("LEFT",player.fenGren,"RIGHT",1,0);
			player.Name:SetSize(duiwu_Width-72,duiwu_Height);
			player.Name.t = PIGFontString(player.Name,{"LEFT",player.Name,"LEFT",0,0},"","OUTLINE");
			player.Name:SetScript("OnMouseUp", function (self)
				if ( MailFrame:IsVisible() and MailFrame.selectedTab == 2 ) then
					SendMailInfo(player.AllName,player.fenGV_V,99,99)
				else
					PIGinfotip:TryDisplayMessage("请先打开邮箱发件页面");
				end
			end);
			-------------
			player.buzhu = player:CreateTexture(nil, "ARTWORK");
			player.buzhu:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
			player.buzhu:SetSize(duiwu_Height-10,duiwu_Height-8);
			player.buzhu:SetPoint("LEFT", player.Name, "RIGHT", 0,0);
			player.fenGbili = player:CreateTexture(nil, "ARTWORK");
			player.fenGbili:SetSize(duiwu_Height-10,duiwu_Height-8);
			player.fenGbili:SetPoint("LEFT", player.buzhu, "RIGHT", 0,0);
			-- ------
			player.mail = CreateFrame("Button",nil,player, "TruncatedButtonTemplate",pp);
			player.mail:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp")
			player.mail:SetSize(duiwu_Height-9,duiwu_Height-8);
			player.mail:SetPoint("LEFT", player.fenGbili, "RIGHT", 2,0);
			player.mail.Tex = player.mail:CreateTexture(nil, "BORDER");
			player.mail.Tex:SetTexture("interface/cursor/mail.blp");
			player.mail.Tex:SetSize(duiwu_Height-9,duiwu_Height-8);
			player.mail.Tex:SetPoint("CENTER");
			player.mail:SetScript("OnMouseDown", function (self)
				self.Tex:SetPoint("CENTER",-1.5,-1.5);
			end);
			player.mail:SetScript("OnMouseUp", function (self)
				self.Tex:SetPoint("CENTER");
			end);
			player.mail:SetScript("OnClick", function (self)
				if ( MailFrame:IsVisible() and MailFrame.selectedTab == 2 ) then
					SendMailInfo(player.AllName,player.fenGV_V)
					PIGA["GDKP"]["Raidinfo"][p][pp][8]=1;
					RaidR.Update_FenG()
				else
					PIGinfotip:TryDisplayMessage("请先打开邮箱发件页面");
				end
			end);
			player.fenG = CreateFrame("Frame", nil, player);
			player.fenG:SetSize(10,duiwu_Height);
			player.fenG:SetPoint("RIGHT",player.Name,"RIGHT",0,0);
			player.fenG:SetFrameLevel(FrameLevel+20)
			player.fenGV = PIGFontString(player.fenG,{"RIGHT",player.fenG,"RIGHT",0,0},0,"OUTLINE");
			player.fenGV:Hide();
		end
	end

	fujiF.nr.yedibuF = PIGLine(fujiF.nr,"BOT",96)
	--分G人数设置
	fujiF.nr.rensh_ALL = PIGFontString(fujiF.nr,{"TOPLEFT",fujiF.nr.yedibuF,"BOTTOMLEFT",10,-10},"\124cff00FF00总人数:\124r", "OUTLINE");
	fujiF.nr.rensh_ALL_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.rensh_ALL,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.rensh_ALL_V:SetTextColor(1, 1, 1, 1);

	--分G比例
	fujiF.nr.fenGbili_1_icon = fujiF.nr:CreateTexture(nil, "ARTWORK");
	fujiF.nr.fenGbili_1_icon:SetTexture(fenGbiliIcon[1]);
	fujiF.nr.fenGbili_1_icon:SetSize(duiwu_Height-8,duiwu_Height-8);
	fujiF.nr.fenGbili_1_icon:SetPoint("LEFT", fujiF.nr.rensh_ALL, "RIGHT", 100,0);
	fujiF.nr.fenGbili_1 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.fenGbili_1_icon,"RIGHT",0,0},"|cff00ff00双倍:|r", "OUTLINE");
	fujiF.nr.fenGbili_1_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.fenGbili_1,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.fenGbili_1_V:SetTextColor(1, 1, 1, 1);

	fujiF.nr.fenGbili_2_icon = fujiF.nr:CreateTexture(nil, "ARTWORK");
	fujiF.nr.fenGbili_2_icon:SetTexture(fenGbiliIcon[2]);
	fujiF.nr.fenGbili_2_icon:SetSize(duiwu_Height-8,duiwu_Height-8);
	fujiF.nr.fenGbili_2_icon:SetPoint("LEFT", fujiF.nr.fenGbili_1_icon, "RIGHT", 70,0);
	fujiF.nr.fenGbili_2 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.fenGbili_2_icon,"RIGHT",0,0},"|cff00ff000.5倍:|r", "OUTLINE");
	fujiF.nr.fenGbili_2_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.fenGbili_2,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.fenGbili_2_V:SetTextColor(1, 1, 1, 1);

	fujiF.nr.fenGbili_3_icon = fujiF.nr:CreateTexture(nil, "ARTWORK");
	fujiF.nr.fenGbili_3_icon:SetTexture(fenGbiliIcon[3]);
	fujiF.nr.fenGbili_3_icon:SetSize(duiwu_Height-8,duiwu_Height-8);
	fujiF.nr.fenGbili_3_icon:SetPoint("LEFT", fujiF.nr.fenGbili_2_icon, "RIGHT", 70,0);
	fujiF.nr.fenGbili_3 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.fenGbili_3_icon,"RIGHT",0,0},"|cff00ff00不分:|r", "OUTLINE");
	fujiF.nr.fenGbili_3_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.fenGbili_3,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.fenGbili_3_V:SetTextColor(1, 1, 1, 1);

	--补助
	fujiF.nr.buzhu_1_icon = fujiF.nr:CreateTexture(nil, "ARTWORK");
	fujiF.nr.buzhu_1_icon:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
	fujiF.nr.buzhu_1_icon:SetTexCoord(zhizeIcon[1][1],zhizeIcon[1][2],zhizeIcon[1][3],zhizeIcon[1][4]);
	fujiF.nr.buzhu_1_icon:SetSize(duiwu_Height-8,duiwu_Height-8);
	fujiF.nr.buzhu_1_icon:SetPoint("LEFT", fujiF.nr.fenGbili_3_icon, "RIGHT", 160,0);
	fujiF.nr.buzhu_1 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.buzhu_1_icon,"RIGHT",0,0},"|cff00ff00"..buzhuzhize[1].."|r", "OUTLINE");
	fujiF.nr.buzhu_1_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.buzhu_1,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.buzhu_1_V:SetTextColor(1, 1, 1, 1);
	fujiF.nr.buzhu_2_icon = fujiF.nr:CreateTexture(nil, "ARTWORK");
	fujiF.nr.buzhu_2_icon:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
	fujiF.nr.buzhu_2_icon:SetTexCoord(zhizeIcon[2][1],zhizeIcon[2][2],zhizeIcon[2][3],zhizeIcon[2][4]);
	fujiF.nr.buzhu_2_icon:SetSize(duiwu_Height-8,duiwu_Height-8);
	fujiF.nr.buzhu_2_icon:SetPoint("LEFT", fujiF.nr.buzhu_1_icon, "RIGHT", 70,0);
	fujiF.nr.buzhu_2 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.buzhu_2_icon,"RIGHT",0,0},"|cff00ff00"..buzhuzhize[2].."|r", "OUTLINE");
	fujiF.nr.buzhu_2_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.buzhu_2,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.buzhu_2_V:SetTextColor(1, 1, 1, 1);
	fujiF.nr.buzhu_3_icon = fujiF.nr:CreateTexture(nil, "ARTWORK");
	fujiF.nr.buzhu_3_icon:SetTexture("interface/lfgframe/ui-lfg-icon-roles.blp");
	fujiF.nr.buzhu_3_icon:SetTexCoord(zhizeIcon[3][1],zhizeIcon[3][2],zhizeIcon[3][3],zhizeIcon[3][4]);
	fujiF.nr.buzhu_3_icon:SetSize(duiwu_Height-8,duiwu_Height-8);
	fujiF.nr.buzhu_3_icon:SetPoint("LEFT", fujiF.nr.buzhu_2_icon, "RIGHT", 70,0);
	fujiF.nr.buzhu_3 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.buzhu_3_icon,"RIGHT",0,0},"|cff00ff00"..buzhuzhize[3].."|r", "OUTLINE");
	fujiF.nr.buzhu_3_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.buzhu_3,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.buzhu_3_V:SetTextColor(1, 1, 1, 1);

	--=========================
	fujiF.nr.yedibuF2 = PIGLine(fujiF.nr,"BOT",62)
	fujiF.nr.yedibuF2_1 = PIGLine(fujiF.nr,"R",-220,nil,{-407,0})
	--人均
	fujiF.nr.shouru = PIGFontString(fujiF.nr,{"TOPLEFT",fujiF.nr.yedibuF2,"BOTTOMLEFT",10,-6},"人均:", "OUTLINE");

	fujiF.nr.shouru1 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.shouru,"RIGHT",6,0},"", "OUTLINE");
	fujiF.nr.shouru1:SetTextColor(0, 1, 0, 1);
	fujiF.nr.shouru1_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.shouru1,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.shouru1_V:SetTextColor(1, 1, 1, 1);

	fujiF.nr.shouru2 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.shouru1_V,"RIGHT",30,0},"", "OUTLINE");
	fujiF.nr.shouru2:SetTextColor(0, 1, 0, 1);
	fujiF.nr.shouru2_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.shouru2,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.shouru2_V:SetTextColor(1, 1, 1, 1);

	fujiF.nr.shouru3 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.shouru2_V,"RIGHT",30,0},"", "OUTLINE");
	fujiF.nr.shouru3:SetTextColor(0, 1, 0, 1);
	fujiF.nr.shouru3_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.shouru3,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.shouru3_V:SetTextColor(1, 1, 1, 1);
	local ewaishuomingTip = ""
	for i=1,#RaidR.ewaishuoming do
		ewaishuomingTip=ewaishuomingTip..RaidR.ewaishuoming[i].."\n"
	end
	PIGEnter(fujiF.nr.shouru3,ewaishuomingTip,nil,nil,nil,nil,"not")
	PIGEnter(fujiF.nr.shouru3_V,ewaishuomingTip,nil,nil,nil,nil,"not")
	---广播分配信息=================================
	fujiF.nr.guangbo = PIGButton(fujiF.nr,{"TOPLEFT",fujiF.nr.yedibuF2,"BOTTOMLEFT",10,-30},{118,24},"·发送到");
	fujiF.nr.guangbo.Text:SetPoint("LEFT",fujiF.nr.guangbo,"LEFT",21,0);
	fujiF.nr.guangbo.Tex = fujiF.nr.guangbo:CreateTexture(nil, "BORDER");
	fujiF.nr.guangbo.Tex:SetTexture("interface/common/voicechat-speaker.blp");
	fujiF.nr.guangbo.Tex:SetPoint("LEFT",6,0);
	fujiF.nr.guangbo.Tex:SetSize(22,22);
	fujiF.nr.guangbo:HookScript("OnMouseDown", function (self)
		self.Tex:SetPoint("LEFT",10,-1);
		self.Text:SetPoint("LEFT",self,"LEFT",22,-1);
		fujiF.nr.guangbo_dow.Text:SetPoint("RIGHT",fujiF.nr.guangbo_dow.Button,"LEFT",1,-1);
	end);
	fujiF.nr.guangbo:HookScript("OnMouseUp", function (self)
		self.Tex:SetPoint("LEFT",8,0);
		self.Text:SetPoint("LEFT",self,"LEFT",21,0);
		fujiF.nr.guangbo_dow.Text:SetPoint("RIGHT",fujiF.nr.guangbo_dow.Button,"LEFT",0,0);
	end);
	local function bobaoxini(idx,ZongSR,SendCD)
    	local dataX = PIGA["GDKP"]["Raidinfo"]
		for p=1,#dataX do
			for pp=1,#dataX[p] do
				if dataX[p][pp][4] then
					if dataX[p][pp][4]==LeftmenuV[idx] then
						SendCD=SendCD+0.01
						C_Timer.After(SendCD,function()
							if dataX[p][pp][5] then--百分比补助
								local baifenbishouru=ZongSR*(dataX[p][pp][6]*0.01)
								SendChatMessage("["..buzhuzhize[idx].."补助]支出"..baifenbishouru.."G("..dataX[p][pp][6].."%)<"..dataX[p][pp][1]..">", RaidR.ChatTypes)
							else
								SendChatMessage("["..buzhuzhize[idx].."补助]支出"..dataX[p][pp][6].."G<"..dataX[p][pp][1]..">", RaidR.ChatTypes)
							end
						end)
					end
				end
			end
		end
		return SendCD
	end
	local function geshihuaMSG(ryg,renshu,biaoti)
		if renshu>0 then
			if ryg>0 then
				return biaoti..GetCoinText(ryg).."(人数"..renshu.."); ";
			else
				return biaoti.."0(人数"..renshu.."); ";
			end
		end
		return ""
	end
	local function fasongrenjunMSG(ryg,renshu1,renshu2,renshu05)
		local renshu1=tonumber(renshu1)
		local renshu2=tonumber(renshu2)
		local renshu05=tonumber(renshu05)
		local msg = "人均:"
		if renshu2==0 and renshu05==0 then
			msg=msg..geshihuaMSG(ryg[2],renshu1,"")
		else
			if renshu2>0 and renshu05>0 then
				msg=msg..geshihuaMSG(ryg[2],renshu1,"全工:")
				msg=msg..geshihuaMSG(ryg[3],renshu2,"双工:")
				msg=msg..geshihuaMSG(ryg[4],renshu05,"半工:")
			elseif renshu05>0 then
				msg=msg..geshihuaMSG(ryg[2],renshu1,"全工:")
				msg=msg..geshihuaMSG(ryg[4],renshu05,"半工:")
			elseif renshu2>0 then
				msg=msg..geshihuaMSG(ryg[2],renshu1,"全工:")
				msg=msg..geshihuaMSG(ryg[3],renshu2,"双工:")
			end
		end
		return msg
	end
	fujiF.nr.guangbo:SetScript("OnClick", function (self)
		self.SendCD=0
		self.liupaichupin={};
		SendChatMessage("=====收支明细=====", RaidR.ChatTypes)
		self.SendCD=self.SendCD+0.2
		C_Timer.After(self.SendCD,function()
			local ItemSLsit = PIGA["GDKP"]["ItemList"];
			for id=1,#ItemSLsit do
				local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(ItemSLsit[id][2]))
				if ItemSLsit[id][9]>0 or ItemSLsit[id][14]>0 then
					self.SendCD=self.SendCD+0.02
					if ItemSLsit[id][14]>0 then
						SendChatMessage(itemLink.."x"..ItemSLsit[id][3].." 收入:"..ItemSLsit[id][9]+ItemSLsit[id][14].."G(买方<"..ItemSLsit[id][8]..">尚欠"..ItemSLsit[id][14]..")", RaidR.ChatTypes);
					else
						SendChatMessage(itemLink.."x"..ItemSLsit[id][3].." 收入:"..ItemSLsit[id][9].."G(买方<"..ItemSLsit[id][8]..">)", RaidR.ChatTypes);
					end
				else
					if PIGA["GDKP"]["Rsetting"]["liupaibobao"] then
						table.insert(self.liupaichupin,itemLink);
					end
				end
			end
		end)
		if PIGA["GDKP"]["Rsetting"]["liupaibobao"] then
			self.SendCD=self.SendCD+0.3
			C_Timer.After(self.SendCD,function() SendChatMessage("-----流拍物品-----：", RaidR.ChatTypes);end)	
			self.SendCD=self.SendCD+0.2
			C_Timer.After(self.SendCD,function()
				if #self.liupaichupin>0 then	
					local LPnum = 3--流派每行物品数
					for l=1,math.ceil(#self.liupaichupin/LPnum) do
						self.SendCD=self.SendCD+0.02
						if l==1 then
							local textmsgIiem="";
							for ll=1,l*LPnum do
								if self.liupaichupin[ll]~=nil then
									textmsgIiem=textmsgIiem..self.liupaichupin[ll];
								end
							end
							SendChatMessage(textmsgIiem, RaidR.ChatTypes);
						else
							local textmsgIiem1="";
							for ll=(l-1)*LPnum+1,l*LPnum do
								if self.liupaichupin[ll]~=nil then
									textmsgIiem1=textmsgIiem1..self.liupaichupin[ll];
								end
							end
							SendChatMessage(textmsgIiem1, RaidR.ChatTypes);
						end
						textmsgIiem=nil;textmsgIiem1=nil;
					end
				end
			end)
		end
		local ZongSR=RaidR.xiafangF.ZongSR_V:GetText();
		--补助		
		if PIGA["GDKP"]["Rsetting"]["bobaomingxi"] then
			self.SendCD=self.SendCD+0.3
			local dataX = PIGA["GDKP"]["fakuan"]
	    	for p=1,#dataX do
				if dataX[p][3]~="N/A" then
					self.SendCD=self.SendCD+0.02
					C_Timer.After(self.SendCD,function()
						if dataX[p][4]>0 then
							SendChatMessage("["..dataX[p][1].."]收入"..dataX[p][2].."G<"..dataX[p][3]..">尚欠"..dataX[p][4].."G",RaidR.ChatTypes)
						else
							SendChatMessage("["..dataX[p][1].."]收入"..dataX[p][2].."G<"..dataX[p][3]..">",RaidR.ChatTypes)
						end
					end)
				end
			end
			self.SendCD=self.SendCD+0.3
			self.SendCD=bobaoxini(1,ZongSR,self.SendCD)
			self.SendCD=bobaoxini(2,ZongSR,self.SendCD)
			self.SendCD=bobaoxini(3,ZongSR,self.SendCD)
			local dataX = PIGA["GDKP"]["jiangli"]
	    	for p=1,#dataX do
				if dataX[p][3]~="N/A" then
					self.SendCD=self.SendCD+0.02
					C_Timer.After(self.SendCD,function()
						if dataX[p][4] then--百分比补助
							local baifenbishouru=ZongSR*(dataX[p][2]*0.01);
							SendChatMessage("["..dataX[p][1].."]支出"..baifenbishouru.."G("..dataX[p][2].."%)<"..dataX[p][3]..">",RaidR.ChatTypes)
						else
							SendChatMessage("["..dataX[p][1].."]支出"..dataX[p][2].."G<"..dataX[p][3]..">",RaidR.ChatTypes)
						end
					end)
				end
			end
		end

		local Wupin_SR=RaidR.xiafangF.Wupin_SR_V:GetText()
		local fakuan_SR=RaidR.xiafangF.fakuan_SR_V:GetText();
		local buzhu_ZC=RaidR.xiafangF.buzhu_SR_V:GetText();
		local jiangli_ZC=RaidR.xiafangF.jiangli_SR_V:GetText();
		local Jing_RS=RaidR.xiafangF.Jing_RS_V:GetText();
		local hejifayanxianMSG="合计:";
		hejifayanxianMSG=hejifayanxianMSG.."物品收入:"..Wupin_SR.."G,";	
		if tonumber(fakuan_SR)>0 then
			hejifayanxianMSG=hejifayanxianMSG.."罚款/其他收入:"..fakuan_SR.."G,";
		end
		hejifayanxianMSG=hejifayanxianMSG.."总收入:"..ZongSR.."G,";
		if tonumber(buzhu_ZC)>0 then
			hejifayanxianMSG=hejifayanxianMSG.."补助支出:"..buzhu_ZC.."G,";
		end
		if tonumber(jiangli_ZC)>0 then
			hejifayanxianMSG=hejifayanxianMSG.."奖励支出:"..jiangli_ZC.."G,";
		end
		hejifayanxianMSG=hejifayanxianMSG.."净收入:"..Jing_RS.."G,";
		self.SendCD=self.SendCD+0.3
		C_Timer.After(self.SendCD,function() SendChatMessage(hejifayanxianMSG, RaidR.ChatTypes);end)
		--
		local zongrenshu=fujiF.nr.rensh_ALL_V:GetText();
		local renshu2=fujiF.nr.fenGbili_1_V:GetText();
		local renshu05=fujiF.nr.fenGbili_2_V:GetText();
		local renshu0=fujiF.nr.fenGbili_3_V:GetText();
		local renshu1=zongrenshu-renshu0
		local shourumingxi=fasongrenjunMSG(fujiF.shourubili_info, renshu1, renshu2, renshu05)
		self.SendCD=self.SendCD+0.3
		C_Timer.After(self.SendCD,function() SendChatMessage(shourumingxi, RaidR.ChatTypes);end)
		self.SendCD=self.SendCD+0.3
		C_Timer.After(self.SendCD,function() SendChatMessage("==<!Pig金团助手为你服务>==",RaidR.ChatTypes);end)
	end);
	local pindaoName = {["RAID"]="|cffFF7F00"..RAID.."|r",["SAY"]="|cffFFFFFF"..SAY.."|r",["PARTY"]="|cffAAAAFF"..PARTY.."|r",["GUILD"]="|cff40FF40"..GUILD.."|r"};
	local pindaoID = {"RAID","PARTY","GUILD"};
	fujiF.nr.guangbo_dow=PIGDownMenu(fujiF.nr,{"LEFT",fujiF.nr.guangbo,"RIGHT", -40,0},{62,24})
	fujiF.nr.guangbo_dow:SetBackdrop(nil)
	RaidR.ChatTypes="RAID"
	function fujiF.nr.guangbo_dow:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#pindaoID,1 do
			info.notCheckable=true
		    info.text, info.arg1, info.arg2 = pindaoName[pindaoID[i]], pindaoID[i], pindaoID[i]
			fujiF.nr.guangbo_dow:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.nr.guangbo_dow:PIGDownMenu_SetValue(value,arg1,arg2)
		fujiF.nr.guangbo_dow:PIGDownMenu_SetText(value)
		RaidR.ChatTypes=arg1
		PIGCloseDropDownMenus()
	end
	fujiF.nr.guangbo_dow:PIGDownMenu_SetText(pindaoName[RaidR.ChatTypes])
	--
	fujiF.nr.liupaibobao = PIGCheckbutton(fujiF.nr,{"LEFT",fujiF.nr.guangbo,"RIGHT",40,0},{"流拍物品","发送拍卖结果时会播报流拍物品"})
	fujiF.nr.liupaibobao:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["liupaibobao"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["liupaibobao"]=false;
		end
	end);
	--
	fujiF.nr.bobaomingxi = PIGCheckbutton(fujiF.nr,{"LEFT",fujiF.nr.liupaibobao.Text,"RIGHT",20,0},{"奖罚明细","发送拍卖结果时会播报补助/奖励/罚款明细"})
	fujiF.nr.bobaomingxi:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["GDKP"]["Rsetting"]["bobaomingxi"]=true;
		else
			PIGA["GDKP"]["Rsetting"]["bobaomingxi"]=false;
		end
	end);
	--理论人均
	fujiF.nr.shouru0 = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.bobaomingxi.Text,"RIGHT",20,0},"理论人均:", "OUTLINE");
	fujiF.nr.shouru0:SetTextColor(0.5, 0.5, 0.5, 0.5);
	fujiF.nr.shouru0_V = PIGFontString(fujiF.nr,{"LEFT",fujiF.nr.shouru0,"RIGHT",0,0},0, "OUTLINE",15);
	fujiF.nr.shouru0_V:SetTextColor(0.5, 0.5, 0.5, 0.5);
	local jiusanguizeTip = ""
	for i=1,#RaidR.jisuanguize do
		jiusanguizeTip=jiusanguizeTip..RaidR.jisuanguize[i].."\n"
	end
	PIGEnter(fujiF.nr.shouru0,jiusanguizeTip,nil,nil,nil,nil,"not")
	PIGEnter(fujiF.nr.shouru0_V,jiusanguizeTip,nil,nil,nil,nil,"not")
	--精确到金币/银币
	local JBdanweiList = {{1,10000},{100,100},{10000,1}};
	local JBdanweiID = {GOLD_AMOUNT_SYMBOL,SILVER_AMOUNT_SYMBOL,COPPER_AMOUNT_SYMBOL};
	fujiF.nr.JBdanwei=PIGDownMenu(fujiF.nr,{"TOPLEFT",fujiF.nr.yedibuF2_1,"TOPRIGHT",66,-6},{50,24})
	fujiF.nr.JBdanwei.Text:SetPoint("RIGHT",fujiF.nr.JBdanwei.Button,"LEFT",-2,0);
	fujiF.nr.JBdanwei.biaoti = PIGFontString(fujiF.nr.JBdanwei,{"RIGHT",fujiF.nr.JBdanwei,"LEFT",0,0},"分G单位", "OUTLINE");
	function fujiF.nr.JBdanwei:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#JBdanweiID,1 do
			info.notCheckable=true
		    info.text, info.arg1= JBdanweiID[i], i
			fujiF.nr.JBdanwei:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.nr.JBdanwei:PIGDownMenu_SetValue(value,arg1)
		fujiF.nr.JBdanwei:PIGDownMenu_SetText(value)
		PIGA["GDKP"]["Rsetting"]["danwei"]=arg1
		fujiF.danwei=JBdanweiList[arg1]
		PIGCloseDropDownMenus()
		RaidR.Update_FenG()
	end
	fujiF.nr.JBdanwei:PIGDownMenu_SetText(JBdanweiID[PIGA["GDKP"]["Rsetting"]["danwei"]])
	fujiF.danwei=JBdanweiList[PIGA["GDKP"]["Rsetting"]["danwei"]] or JBdanweiList[1]
	--显示玩家分G数-----
	fujiF.nr.XianshifenGV = PIGButton(fujiF.nr,{"LEFT",fujiF.nr.JBdanwei,"RIGHT",30,0},{70,24},"显示金额") 	
	fujiF.nr.XianshifenGV:SetScript("OnClick", function (self)
		if self.yixianshi then
			for p=1,8 do
				_G["RRfenGList_"..p].jiaoyi:Hide()
				_G["RRfenGList_"..p].jiaoyiG:Hide()
				for pp=1,5 do
					_G["RRfenGList_"..p.."_"..pp].fenGV:Hide()
				end
			end
			self.Text:SetText("显示金额")
			self.yixianshi=false
		else
			for p=1,8 do
				local pui = _G["RRfenGList_"..p]
				if pui.jiaoyiG_V and pui.jiaoyiG_V>0 then
					pui.jiaoyi:Show()
					pui.jiaoyiG:Show()
				end
				for pp=1,5 do
					_G["RRfenGList_"..p.."_"..pp].fenGV:Show()
				end
			end
			self.Text:SetText("隐藏金额")
			self.yixianshi=true
		end	
	end);

	--计算分G-----------
	local function quxiaoshuweiFun(money)
		local money = floor(money*fujiF.danwei[1])
		local money = floor(money*fujiF.danwei[2])
		return GetMoneyString(money),money
	end
	local function chuliShowHide(fenGbilirenshu)
		fujiF.nr.shouru0:Hide()
		fujiF.nr.shouru0_V:Hide()
		fujiF.nr.shouru1:SetText("")
		fujiF.nr.shouru1:Hide()
		fujiF.nr.shouru1_V:Hide()
		fujiF.nr.shouru2:SetText("")
		fujiF.nr.shouru2:Hide()
		fujiF.nr.shouru2_V:Hide()
		fujiF.nr.shouru3:SetText("")
		fujiF.nr.shouru3:Hide()
		fujiF.nr.shouru3_V:Hide()
		fujiF.nr.shouru0_V:SetText(0)
		fujiF.nr.shouru1_V:SetText(0)
		fujiF.nr.shouru2_V:SetText(0)
		fujiF.nr.shouru3_V:SetText(0)
		if fenGbilirenshu[2]==0 and fenGbilirenshu[1]==0 then
			fujiF.nr.shouru1:Show()
			fujiF.nr.shouru1:SetText("")
			fujiF.nr.shouru1_V:Show()
		else
			fujiF.nr.shouru1:SetText("全工:")
			fujiF.nr.shouru2:SetText("双工:")
			fujiF.nr.shouru3:SetText("半工:")
			if fenGbilirenshu[2]>0 and fenGbilirenshu[1]>0 then
				fujiF.nr.shouru0:Show()
				fujiF.nr.shouru0_V:Show()
				fujiF.nr.shouru1:Show()
				fujiF.nr.shouru1_V:Show()
				fujiF.nr.shouru2:Show()
				fujiF.nr.shouru2_V:Show()
				fujiF.nr.shouru3:Show()
				fujiF.nr.shouru3_V:Show()
			elseif fenGbilirenshu[2]>0 then
				fujiF.nr.shouru0:Show()
				fujiF.nr.shouru0_V:Show()
				fujiF.nr.shouru1:Show()
				fujiF.nr.shouru1_V:Show()
				fujiF.nr.shouru3:Show()
				fujiF.nr.shouru3_V:Show()
			elseif fenGbilirenshu[1]>0 then
				fujiF.nr.shouru1:Show()
				fujiF.nr.shouru1_V:Show()
				fujiF.nr.shouru2:Show()
				fujiF.nr.shouru2_V:Show()
			end
		end
	end
	function RaidR.Update_FenG()
		if not fujiF.nr:IsShown() then return end
		for p=1,8 do
			local duiwuF = _G["RRfenGList_"..p]
			duiwuF.tongzhi:Hide()
			for pp=1,5 do
				_G["RRfenGList_"..p.."_"..pp]:Hide()
			end
		end
		local renyuanxinxi = {
			["renshu"]=0,
			["buzhurenshu"]={},
			["fenGbili"]={},
		}
		for g=1,#LeftmenuV do
			renyuanxinxi.buzhurenshu[g]= 0
		end
		for g=1,#RightmenuV do
			renyuanxinxi.fenGbili[g]= 0
		end
		local infoData = PIGA["GDKP"]["Raidinfo"]
		for p=1,8 do
			local duinum = #infoData[p]
			if duinum>0 then
				local duiwuF = _G["RRfenGList_"..p]
				duiwuF.tongzhi:Show()
				renyuanxinxi.renshu=renyuanxinxi.renshu+duinum
				for pp=1,duinum do
					local renyF = _G["RRfenGList_"..p.."_"..pp]
					renyF:Show()
					local AllName = infoData[p][pp][1]
					renyF.AllName=AllName
					local name,server = strsplit("-", AllName);
					if server then
						renyF.Name.t:SetText(name.."(*)")
					else
						renyF.Name.t:SetText(name)
					end
					local zhiye = infoData[p][pp][2]
					local color = RAID_CLASS_COLORS[zhiye]
					--renyF.color=color
					renyF.Name.t:SetTextColor(color.r, color.g, color.b,1);
					--补助类型
					local buzhuLEI = infoData[p][pp][4]
					if buzhuLEI then
						renyF.buzhu:Show()
						for g=1,#LeftmenuV do
							if buzhuLEI==LeftmenuV[g] then
								renyuanxinxi.buzhurenshu[g]=renyuanxinxi.buzhurenshu[g]+1
								renyF.buzhu:SetTexCoord(zhizeIcon[g][1],zhizeIcon[g][2],zhizeIcon[g][3],zhizeIcon[g][4]);
							end
						end
					else
						renyF.buzhu:Hide()
					end
					--分G比例
					local fenGLEI = infoData[p][pp][3]
					if fenGLEI==1 then
						renyF.fenGbili:Hide()
					else
						renyF.fenGbili:Show()
						for g=1,#RightmenuV do
							if fenGLEI==RightmenuV[g] then
								renyuanxinxi.fenGbili[g]=renyuanxinxi.fenGbili[g]+1
								renyF.fenGbili:SetTexture(fenGbiliIcon[g]);
							end
						end
					end
					--邮寄图标
					if infoData[p][pp][7] then--需邮寄
						renyF.mail:Show()
						local yiyouji = infoData[p][pp][8]
						if yiyouji then
							renyF.mail.Tex:SetTexture("interface/cursor/unablemail.blp");
						else
							renyF.mail.Tex:SetTexture("interface/cursor/mail.blp");
						end
					else
						renyF.mail:Hide()
					end
				end
			end
		end

		fujiF.nr.rensh_ALL_V:SetText(renyuanxinxi.renshu);
		fujiF.nr.fenGbili_1_V:SetText(renyuanxinxi.fenGbili[1]);
		fujiF.nr.fenGbili_2_V:SetText(renyuanxinxi.fenGbili[2]);
		fujiF.nr.fenGbili_3_V:SetText(renyuanxinxi.fenGbili[3]);
		fujiF.nr.buzhu_1_V:SetText(renyuanxinxi.buzhurenshu[1]);
		fujiF.nr.buzhu_2_V:SetText(renyuanxinxi.buzhurenshu[2]);
		fujiF.nr.buzhu_3_V:SetText(renyuanxinxi.buzhurenshu[3]);
		---
		fujiF.shourubili_info = {0,0,0,0}
		local zongshouru=tonumber(RaidR.xiafangF.ZongSR_V:GetText());
		local jingshouru=tonumber(RaidR.xiafangF.Jing_RS_V:GetText());
		if PIGA["GDKP"]["Rsetting"]["danwei"]==3 and zongshouru>100000 then
			fujiF.nr.shouru2:SetPoint("LEFT",fujiF.nr.shouru1_V,"RIGHT",20,0)
			fujiF.nr.shouru3:SetPoint("LEFT",fujiF.nr.shouru2_V,"RIGHT",20,0)
		else
			fujiF.nr.shouru2:SetPoint("LEFT",fujiF.nr.shouru1_V,"RIGHT",30,0)
			fujiF.nr.shouru3:SetPoint("LEFT",fujiF.nr.shouru2_V,"RIGHT",30,0)
		end
		chuliShowHide(renyuanxinxi.fenGbili)
		if jingshouru>0 and renyuanxinxi.renshu>0 then
			local pingjunshouru=jingshouru/(renyuanxinxi.renshu-renyuanxinxi.fenGbili[3]+renyuanxinxi.fenGbili[1]);--没人应得数
			local pingjunG,pingjunV=quxiaoshuweiFun(pingjunshouru)
			fujiF.shourubili_info[1]=pingjunV
			fujiF.nr.shouru0_V:SetText(pingjunG);
			local pingjunG_3,pingjunV_3=quxiaoshuweiFun(pingjunshouru*0.5)
			fujiF.shourubili_info[4]=pingjunV_3
			fujiF.nr.shouru3_V:SetText(pingjunG_3);
			
			if renyuanxinxi.fenGbili[2]==0 then--没有0.5倍
				local pingjunG_1,pingjunV_1=quxiaoshuweiFun(pingjunshouru)
				local pingjunG_2,pingjunV_2=quxiaoshuweiFun(pingjunshouru*2)
				fujiF.shourubili_info[2]=pingjunV_1
				fujiF.shourubili_info[3]=pingjunV_2
				fujiF.nr.shouru1_V:SetText(pingjunG_1);
				fujiF.nr.shouru2_V:SetText(pingjunG_2);
			else
				local bangongkouchu = pingjunshouru*0.5*renyuanxinxi.fenGbili[2]--半工扣除金额
				local quchubangongrenshu = renyuanxinxi.renshu-renyuanxinxi.fenGbili[3]+renyuanxinxi.fenGbili[1]-renyuanxinxi.fenGbili[2]--去掉半工人数剩余人数
				if quchubangongrenshu>0 then
					local Qrenjunshouru=(pingjunshouru*quchubangongrenshu+bangongkouchu)/quchubangongrenshu;--半工扣除平均分给其他人
					local QrenjunG_1,QrenjunV_1=quxiaoshuweiFun(Qrenjunshouru)
					local QrenjunG_2,QrenjunV_2=quxiaoshuweiFun(Qrenjunshouru*2)
					fujiF.shourubili_info[2]=QrenjunV_1
					fujiF.shourubili_info[3]=QrenjunV_2
					fujiF.nr.shouru1_V:SetText(QrenjunG_1);
					fujiF.nr.shouru2_V:SetText(QrenjunG_2);
				else
					local pingjunG_1,pingjunV_1=quxiaoshuweiFun(pingjunshouru)
					local pingjunG_2,pingjunV_2=quxiaoshuweiFun(pingjunshouru*2)
					fujiF.shourubili_info[2]=pingjunV_1
					fujiF.shourubili_info[3]=pingjunV_2
					fujiF.nr.shouru1_V:SetText(pingjunG_1);
					fujiF.nr.shouru2_V:SetText(pingjunG_2);
				end
			end
		end
		--个人分G数和小队金额
		local fenGshujuID={fujiF.shourubili_info[3],fujiF.shourubili_info[4],0,fujiF.shourubili_info[2]}
		for p=1,8 do
			local duiwufenGshu={
				["duiwuG"]=0,
				["renwu"]={0,0,0,0,0},
			};	
			if #infoData[p]>0 then	
				for pp=1,#infoData[p] do
						local gerenData = infoData[p][pp]
						--按分G比例计算分G数	
						for g=1,#RightmenuV do
							if gerenData[3]==RightmenuV[g] then
								duiwufenGshu.renwu[pp]=duiwufenGshu.renwu[pp]+fenGshujuID[g];
								if not gerenData[7] then--不需邮寄
									duiwufenGshu.duiwuG=duiwufenGshu.duiwuG+fenGshujuID[g];
								end
							end
						end
						--补助金额
						for g=1,#LeftmenuV do
							if gerenData[4]==LeftmenuV[g] then
								if gerenData[5] then
									local bili = gerenData[6]*0.01
									local biliG = zongshouru*bili
									duiwufenGshu.renwu[pp]=duiwufenGshu.renwu[pp]+biliG;
									if not gerenData[7] then--不需邮寄
										duiwufenGshu.duiwuG=duiwufenGshu.duiwuG+biliG;
									end
								else
									duiwufenGshu.renwu[pp]=duiwufenGshu.renwu[pp]+gerenData[6]*10000;
									if not gerenData[7] then--不需邮寄
										duiwufenGshu.duiwuG=duiwufenGshu.duiwuG+gerenData[6]*10000;
									end
								end
							end
						end
						--奖励人员
						local dataX = PIGA["GDKP"]["jiangli"]
				    	for g=1,#dataX do
							if dataX[g][3]~="N/A" then
								if gerenData[1]==dataX[g][3] then
									if dataX[g][4] then
										local bili = dataX[g][2]*0.01
										local biliG = zongshouru*bili
										duiwufenGshu.renwu[pp]=duiwufenGshu.renwu[pp]+biliG;
										if not gerenData[7] then--不需邮寄
											duiwufenGshu.duiwuG=duiwufenGshu.duiwuG+biliG;
										end
									else
										duiwufenGshu.renwu[pp]=duiwufenGshu.renwu[pp]+dataX[g][2]*10000;
										if not gerenData[7] then--不需邮寄
											duiwufenGshu.duiwuG=duiwufenGshu.duiwuG+dataX[g][2]*10000;
										end
									end
								end
							end
						end
						--减去有罚款欠款人的欠款金额
						local dataX = PIGA["GDKP"]["fakuan"]
						for g=1,#dataX do
							if dataX[g][3]~="N/A" then
								if gerenData[1]==dataX[g][3] then
									duiwufenGshu.renwu[pp]=duiwufenGshu.renwu[pp]-dataX[g][4]*10000;
									if not gerenData[7] then--不需邮寄
										duiwufenGshu.duiwuG=duiwufenGshu.duiwuG-dataX[g][4]*10000;
									end
								end
							end
						end
						_G["RRfenGList_"..p.."_"..pp].fenGV_V=duiwufenGshu.renwu[pp]
						_G["RRfenGList_"..p.."_"..pp].fenGV:SetText(GetMoneyString(duiwufenGshu.renwu[pp]))
				end
				_G["RRfenGList_"..p].jiaoyiG_V=duiwufenGshu.duiwuG
				_G["RRfenGList_"..p].jiaoyiG:SetText(GetMoneyString(duiwufenGshu.duiwuG))
			end
		end
	end
	fujiF.nr:SetScript("OnShow", function (self)
		self.liupaibobao:SetChecked(PIGA["GDKP"]["Rsetting"]["liupaibobao"]);
		self.bobaomingxi:SetChecked(PIGA["GDKP"]["Rsetting"]["bobaomingxi"]);
		RaidR.Update_FenG()
	end)
	
	--密语激活邮寄图标
	fujiF:SetScript("OnEvent",function (self,event,arg1,arg2,arg3,arg4,arg5)
		if event=="CHAT_MSG_WHISPER" then
			if arg1:match("邮寄") then
				if arg1:match("工资") or arg1:match("薪水") then
					local xianyoushuju = PIGA["GDKP"]["Raidinfo"]
					for p=1,8 do
						for pp=1,#xianyoushuju[p] do
								if arg5 == xianyoushuju[p][pp][1] then
									if xianyoushuju[p][pp][7] then
										SendChatMessage("你已登记，请勿重复发送！", "WHISPER", nil, arg5);
									else
										xianyoushuju[p][pp][7]=true
										SendChatMessage("已登记，工资将通过邮件送达,请注意查收！", "WHISPER", nil, arg5);
										RaidR.Update_FenG()
									end
								end
						end
					end
				end
			end
		end
	end)
end