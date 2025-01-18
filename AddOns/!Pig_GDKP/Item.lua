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
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
local PIGDiyBut=Create.PIGDiyBut
local PIGSetFont=Create.PIGSetFont
--
local GDKPInfo=addonTable.GDKPInfo
function GDKPInfo.ADD_Item(RaidR)
	local gsub = _G.string.gsub 
	local match = _G.string.match
	local find = _G.string.find
	local sub = _G.string.sub
	local floor = floor
	local GetContainerNumSlots = C_Container.GetContainerNumSlots
	local GetContainerItemID = C_Container.GetContainerItemID
	local UseContainerItem = C_Container.UseContainerItem
	------
	local GDKP_Auc=Data.GDKP_Auc
	local biaotou,auc_start,auc_end,auc_daoshu,auc_chujia=GDKP_Auc[1],GDKP_Auc[2],GDKP_Auc[3],GDKP_Auc[4],GDKP_Auc[5]
	------
	local GnName,GnUI,GnIcon,FrameLevel = unpack(GDKPInfo.uidata)
	local iconWH,hang_Height,hang_NUM,lineTOP  =  GDKPInfo.iconWH,GDKPInfo.hang_Height,GDKPInfo.hang_NUM,GDKPInfo.lineTOP
	local tishixx = "|cff00FFff"..KEY_BUTTON1.."长按：|r|cff00FF00预览物品属性|r\n"..
			"|cff00FFff"..KEY_BUTTON2.."：|r|cff00FF00设置拾取过滤此物品,交易面板打开状态下为摆放物品到交易窗口|r\n"..
			"|cff00FFffShift+"..KEY_BUTTON1.."：|r|cff00ff00发送物品到聊天栏|r\n"..
			"|cff00FFffShift+"..KEY_BUTTON2.."：|r|cff00ff00添加到关注|r\n"..
			"|cff00FFffCtrl+"..KEY_BUTTON1.."：|r|cff00ff00合并目录内当前物品|r\n"..
			"|cff00FFffCtrl+"..KEY_BUTTON2.."：|r|cff00ff00拆分当前物品|r"
	---
	local RaidR=_G[GnUI]
	local fujiF,fujiTabBut=PIGOptionsList_R(RaidR.F,"拾取记录",80)
	fujiF:Show()
	fujiTabBut:Selected()

	--local guolvlist = {"全部","已成交","未成交","有欠款","可使用","关注"}
	local guolvlist = {"全部","已成交","未成交","有欠款"}
	fujiF.guolvlist = guolvlist[1]
	local xuqiulv=LEVEL_REQUIRED:sub(1,-3)
	local function GetguolvData(ItemS)
		local data = {}
		if fujiF.guolvlist == guolvlist[2] then
			for x = 1, #ItemS do
				if ItemS[x][9]~=0 or ItemS[x][14]~=0 then
					table.insert(data,x);
				end	
			end
		elseif fujiF.guolvlist == guolvlist[3] then
			for x = 1, #ItemS do
				if ItemS[x][9]==0 and ItemS[x][14]==0 then
					table.insert(data,x);
				end	
			end
		elseif fujiF.guolvlist == guolvlist[4] then
			for x = 1, #ItemS do
				if ItemS[x][14]~=0 then
					table.insert(data,x);
				end	
			end
		elseif fujiF.guolvlist == guolvlist[5] then
			for x = 1, #ItemS do
				local kezhuangbeipig = true
				local link = ItemS[x][2]
				Plisttip_UI:ClearLines();
				Plisttip_UI:SetOwner(UIParent, "ANCHOR_NONE")
				--Plisttip_UI:SetOwner(UIParent, "TOPLEFT")
				Plisttip_UI:SetHyperlink(link)
				local txtNumx = Plisttip_UI:NumLines() 
			    if txtNumx then
			    	for g = 2, txtNumx do
			    		local hangui = _G["Plisttip_UITextLeft"..g]
					    local hangtext = hangui:GetText()
					    if hangtext and hangtext~="" and hangtext~=" " then
				    		local r, g, b = hangui:GetTextColor()
				    		local r, g, b = floor(r*100000), floor(g*100000), floor(b*100000)				    		
				    		if r==100000 and g==12549 and b==12549 then
				    			if not hangtext:match(xuqiulv) then
				    				kezhuangbeipig=false
				    				break
				    			end
				    		end
					    end
					    local hangui_r = _G["Plisttip_UITextRight"..g]
					    local hangtext_r = hangui_r:GetText()
			    		if hangtext_r and hangtext_r~="" and hangtext_r~=" " then
							local rR, gR, bR = hangui_r:GetTextColor()
							local rR, gR, bR = floor(rR*100000), floor(gR*100000), floor(bR*100000)				    		
				    		if rR==100000 and gR==12549 and bR==12549 then
				    			if not hangtext:match(xuqiulv) then
				    				kezhuangbeipig=false
				    				break
				    			end
				    		end
						end
				    end
				end
				if kezhuangbeipig then
					table.insert(data,x);
				end
			end
		elseif fujiF.guolvlist == guolvlist[6] then
			for x = 1, #ItemS do
				if ItemS[x][15] then
					table.insert(data,x);
				end	
			end
		else
			for x = 1, #ItemS do
				table.insert(data,x);
			end
		end
		return data
	end
	--标题
	local biaotiList = {{"时间",-220},{"拾取者",-120},{"物品",60},{"出价",300},{"出价者",400},{"已收到/G",500},{"欠款/G",600},{"成交人",680}}
	for id = 1, #biaotiList, 1 do
		local biaoti = PIGFontString(fujiF,{"TOPLEFT", fujiF, "TOPLEFT", biaotiList[id][2],-7},biaotiList[id][1],"OUTLINE",nil,"rritem_biaoti_"..id);
		biaoti:SetTextColor(0.6, 1, 0, 1);
		if id==1 or id==2 or id==4 or id==5 then
			biaoti:Hide()
		end
	end
	--显示物品时间-----
	local xianshiWH = 18
	fujiF.XianshiTime = CreateFrame("Button",nil,fujiF, "TruncatedButtonTemplate"); 
	fujiF.XianshiTime:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	fujiF.XianshiTime:SetSize(xianshiWH,xianshiWH);
	fujiF.XianshiTime:SetPoint("TOPLEFT",fujiF,"TOPLEFT",2,-7);
	fujiF.XianshiTime.tex = fujiF.XianshiTime:CreateTexture(nil, "OVERLAY");
	fujiF.XianshiTime.tex:SetAtlas("common-icon-backarrow")
	fujiF.XianshiTime.tex:SetSize(xianshiWH*1.2,xianshiWH);
	fujiF.XianshiTime.tex:SetPoint("CENTER",-2,0);
	fujiF.XianshiTime:SetScript("OnMouseDown", function (self)
		self.tex:SetPoint("CENTER",-3.2,-1.2);
	end);
	fujiF.XianshiTime:SetScript("OnMouseUp", function (self)
		self.tex:SetPoint("CENTER",-2,0);
	end);
	fujiF.XianshiTime:SetScript("OnClick", function (self)
		if self.yixianshi then
			self.tex:SetRotation(0, {x=0.5, y=0.5})
			rritem_biaoti_1:Hide()
			rritem_biaoti_2:Hide()
			for p=1,hang_NUM do
				local hang = _G["PIG_GDKPItem_"..p]
				hang.time:Hide()
				hang.Shiquzhe:Hide()
				hang.del:Hide()
			end
			self.yixianshi=false
		else
			self.tex:SetRotation(-3.1415926, {x=0.58, y=0.5})
			rritem_biaoti_1:Show()
			rritem_biaoti_2:Show()
			for p=1,hang_NUM do
				local hang = _G["PIG_GDKPItem_"..p]
				hang.time:Show()
				hang.Shiquzhe:Show()
				hang.del:Show()
			end
			self.yixianshi=true
		end
	end);
	--发送目录--------
	fujiF.bobaoItem = CreateFrame("Button",nil,fujiF);  
	fujiF.bobaoItem:SetSize(iconWH,iconWH);
	fujiF.bobaoItem:SetPoint("RIGHT", rritem_biaoti_3, "LEFT", 0,-0.8);
	fujiF.bobaoItem:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
	fujiF.bobaoItem.Tex = fujiF.bobaoItem:CreateTexture(nil, "BORDER");
	fujiF.bobaoItem.Tex:SetTexture(130979);
	fujiF.bobaoItem.Tex:SetPoint("CENTER",4,0);
	fujiF.bobaoItem.Tex:SetSize(iconWH,iconWH);
	PIGEnter(fujiF.bobaoItem,"播报当前显示的物品详情")
	fujiF.bobaoItem:SetScript("OnMouseDown", function (self)
		self.Tex:SetPoint("CENTER",2.5,-1.5);
	end);
	fujiF.bobaoItem:SetScript("OnMouseUp", function (self)
		self.Tex:SetPoint("CENTER",4,0);
	end);
	fujiF.bobaoItem:SetScript("OnClick", function()
		local ItemS = PIGA["GDKP"]["ItemList"];
		local ItemsNum = #ItemS;
	    if ItemsNum>0 then
	    	local ItemsNum_bobaoNR=GetguolvData(ItemS)
			for id=1,#ItemsNum_bobaoNR do
				local iinfo = ItemS[ItemsNum_bobaoNR[id]]
				local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(iinfo[2]))
				if iinfo[14]>0 then
					PIGSendChatRaidParty(itemLink.."x"..iinfo[3].." 收入"..iinfo[9]+iinfo[14].."G 买方<"..iinfo[8]..">尚欠"..iinfo[14])
				else
					PIGSendChatRaidParty(itemLink.."x"..iinfo[3].." 收入"..iinfo[9].."G 买方"..iinfo[8])
				end
			end
		end
	end)
	--显示过滤--------
	for i=1,#guolvlist do
		local ckbut = PIGCheckbutton(fujiF,nil,{guolvlist[i],nil},nil,"RRguolv_CK"..i,i)
		if i==1 then
			ckbut:SetPoint("LEFT", rritem_biaoti_3, "RIGHT", 2,-0.8)
			ckbut:SetChecked(true)
		else
			ckbut:SetPoint("LEFT",_G["RRguolv_CK"..(i-1)].Text,"RIGHT",8,0)
		end
		ckbut:HookScript("OnClick", function (self)
			local bjID = self:GetID()
			if bjID==1 then
				for ix=1,#guolvlist do
					_G["RRguolv_CK"..ix]:SetChecked(false)
				end
				self:SetChecked(true)
				fujiF.guolvlist=guolvlist[bjID]
			else
				if fujiF.guolvlist==guolvlist[bjID] then
					for ix=1,#guolvlist do
						_G["RRguolv_CK"..ix]:SetChecked(false)
					end
					RRguolv_CK1:SetChecked(true)
					fujiF.guolvlist=guolvlist[1]
				else
					for ix=1,#guolvlist do
						_G["RRguolv_CK"..ix]:SetChecked(false)
					end
					self:SetChecked(true)
					fujiF.guolvlist=guolvlist[bjID]
				end
			end
			RaidR.Update_Item();
		end)
	end
	---------
	fujiF.biaotiline = PIGLine(fujiF,"TOP",-lineTOP)
	fujiF.yedibuF = PIGLine(fujiF,"BOT",lineTOP)
	--物品显示目录======
	local function shiqujiaodian(self,bianji)
		if bianji then
			self.G:Hide();
			self.bianji:Hide();
			self.baocun:Show();
			self.E:Show();
		else
			self.G:Show();
			self.bianji:Show();
			self.baocun:Hide();
			self.E:Hide();
		end
	end
	function RaidR.Update_Item()
		local gundongF = fujiF.ItemNR.Scroll
		if not fujiF:IsVisible() then return end
		for x = 1, hang_NUM do
			_G["PIG_GDKPItem_"..x]:Hide();
	    end
		local ItemS = PIGA["GDKP"]["ItemList"];
		local ItemsNum_GL=GetguolvData(ItemS)
		local ItemsNum = #ItemsNum_GL;
		FauxScrollFrame_Update(gundongF, ItemsNum, hang_NUM, hang_Height);
	    if ItemsNum>0 then
			local offset = FauxScrollFrame_GetOffset(gundongF);
			for x = 1, hang_NUM do
				local LOOT_dangqian = x+offset;
				if fujiF.guolvlist ~= guolvlist[1] then
				    LOOT_dangqian = ItemsNum_GL[LOOT_dangqian];
				end
				if ItemS[LOOT_dangqian] then
					local Itemf = _G["PIG_GDKPItem_"..x]
					Itemf:Show();
					Itemf.del:SetID(LOOT_dangqian);
					Itemf.paimai:SetID(LOOT_dangqian);
					Itemf.paimai.Tex:SetDesaturated(ItemS[LOOT_dangqian][7]);
					Itemf.item:SetID(LOOT_dangqian);
					Itemf.item.icon:SetTexture(ItemS[LOOT_dangqian][6]);
					Itemf.item.itemID=ItemS[LOOT_dangqian][11]
					Fun.HY_ShowItemLink(Itemf.item,ItemS[LOOT_dangqian][2],ItemS[LOOT_dangqian][11])	
					Itemf.item.NO:SetText(ItemS[LOOT_dangqian][3]);
					Itemf.item.guanzhu:SetShown(ItemS[LOOT_dangqian][15])
					local item_daojishi=GetServerTime()-ItemS[LOOT_dangqian][1];
					if item_daojishi>6600 and item_daojishi<7200 then
						Itemf.item.daojishiF:Show();
					else
						Itemf.item.daojishiF:Hide();
					end
					local shiquname, fuwiqiName = strsplit("-", ItemS[LOOT_dangqian][4]);
					Itemf.Shiquzhe:SetText(shiquname);

					Itemf.chengjiao.E:SetID(LOOT_dangqian);
					Itemf.chengjiao.bianji:SetID(LOOT_dangqian);
					Itemf.chengjiao.baocun:SetID(LOOT_dangqian);
					Itemf.chengjiao.G:SetText(ItemS[LOOT_dangqian][9]);
					shiqujiaodian(Itemf.chengjiao)

					Itemf.Qiankuan.E:SetID(LOOT_dangqian);
					Itemf.Qiankuan.bianji:SetID(LOOT_dangqian);
					Itemf.Qiankuan.baocun:SetID(LOOT_dangqian);
					Itemf.Qiankuan.G:SetText(ItemS[LOOT_dangqian][14]);
					shiqujiaodian(Itemf.Qiankuan)

					Itemf.ChengjiaoRen:SetID(LOOT_dangqian);
					local AllName = ItemS[LOOT_dangqian][8]
					Itemf.ChengjiaoRen.AllName=AllName
					if AllName=="N/A" then
						Itemf.ChengjiaoRen:SetText("\124cffff0000        "..NONE.."\124r");
					else
				   		local wanjiaName, fuwiqiName = strsplit("-", AllName);
				   		if fuwiqiName then
							Itemf.ChengjiaoRen:SetText(wanjiaName.."(*)");
						else
							Itemf.ChengjiaoRen:SetText(wanjiaName);
						end
					end
					-- local color = RAID_CLASS_COLORS[zhiyecc]
					-- Itemf.ChengjiaoRen:SetTextColor(color.r, color.g, color.b,1);
					Itemf.time:SetText("\124cff00ffFF"..LOOT_dangqian.."\124r  "..date("%m-%d %H:%M",ItemS[LOOT_dangqian][1]));
				end
			end
		end
		RaidR:UpdateGinfo()
	end
	----创建滚动区域
	fujiF.ItemNR = PIGFrame(fujiF,{"TOPLEFT",fujiF.biaotiline,"BOTTOMLEFT",0,0});  
	fujiF.ItemNR:SetPoint("BOTTOMRIGHT",fujiF.yedibuF,"TOPRIGHT",0,0);
	fujiF.ItemNR:PIGSetBackdrop(0.6,0)
	fujiF.ItemNR.Scroll = CreateFrame("ScrollFrame",nil,fujiF.ItemNR, "FauxScrollFrameTemplate");  
	fujiF.ItemNR.Scroll:SetPoint("TOPLEFT",fujiF.ItemNR,"TOPLEFT",1,-1);
	fujiF.ItemNR.Scroll:SetPoint("BOTTOMRIGHT",fujiF.ItemNR,"BOTTOMRIGHT",-22,1);
	fujiF.ItemNR.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, RaidR.Update_Item)
	end)
	fujiF.ItemNR.Scroll.ScrollBar:SetScale(0.9);
	--创建行
	for id = 1, hang_NUM do
		local hang = CreateFrame("Frame", "PIG_GDKPItem_"..id, fujiF.ItemNR.Scroll:GetParent());
		hang:SetSize(fujiF.ItemNR:GetWidth()-24, hang_Height);
		if id==1 then
			hang:SetPoint("TOP",fujiF.ItemNR.Scroll,"TOP",0,0);
		else
			hang:SetPoint("TOP",_G["PIG_GDKPItem_"..(id-1)],"BOTTOM",0,-0);
		end
		if id~=hang_NUM then PIGLine(hang,"BOT",nil,nil,nil,{0.3,0.3,0.3,0.3}) end
		--拾取时间
		hang.time = PIGFontString(hang,{"LEFT",hang,"LEFT",biaotiList[1][2]-10,0},nil, "OUTLINE");
		hang.time:Hide()
		hang.Shiquzhe = PIGFontString(hang,{"LEFT",hang,"LEFT",biaotiList[2][2]-4,0},nil, "OUTLINE");
		hang.Shiquzhe:SetTextColor(1, 1, 1, 0.8);
		hang.Shiquzhe:SetSize(94,hang_Height);
		hang.Shiquzhe:SetJustifyH("LEFT");
		hang.Shiquzhe:Hide()
		-----------
		hang.del = PIGDiyBut(hang,{"RIGHT", hang, "LEFT", -16,0},{hang_Height-10})
		hang.del:SetScript("OnClick", function (self)
			fujiF.tishiUI:Showtishi("del",self:GetID())	
		end);
		hang.del:Hide()
		---
		hang.paimai = CreateFrame("Button",nil,hang, "TruncatedButtonTemplate");
		hang.paimai:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		hang.paimai:SetSize(hang_Height-4,hang_Height-4);
		hang.paimai:SetPoint("LEFT", hang, "LEFT", 2,0);
		hang.paimai.Tex = hang.paimai:CreateTexture(nil, "BORDER");
		hang.paimai.Tex:SetTexture("interface/gossipframe/bankergossipicon.blp");
		hang.paimai.Tex:SetPoint("CENTER");
		hang.paimai.Tex:SetSize(hang_Height-12,hang_Height-12);
		hang.paimai:SetScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",-1.5,-1.5);
		end);
		hang.paimai:SetScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER");
		end);
		hang.paimai:SetScript("OnClick", function (self)
			fujiF.tishiUI:Showtishi("auc",self:GetID())	
		end);

		hang.item = CreateFrame("Button", nil, hang);
		hang.item:SetSize(260,hang_Height);
		hang.item:SetPoint("LEFT",hang,"LEFT",biaotiList[3][2]-26,0);
		hang.item:RegisterForClicks("LeftButtonUp","RightButtonUp")
		hang.item.icon = hang.item:CreateTexture(nil, "BORDER");
		hang.item.icon:SetSize(hang_Height-6,hang_Height-6);
		hang.item.icon:SetPoint("LEFT", hang.item, "LEFT", 0,0);
		hang.item.guanzhu = hang.item:CreateTexture(nil, "ARTWORK");
		hang.item.guanzhu:SetTexture("interface/glues/characterselect/glues-addon-icons.blp");
		hang.item.guanzhu:SetTexCoord(0.75,1,0,1);
		hang.item.guanzhu:SetSize(hang_Height-14,hang_Height-14);
		hang.item.guanzhu:SetPoint("TOPRIGHT", hang.item.icon, "TOPRIGHT", 4,4);
		hang.item.link = PIGFontString(hang.item,{"LEFT", hang.item.icon, "RIGHT", 2,0});
		hang.item.NO = PIGFontString(hang.item,{"BOTTOMRIGHT", hang.item.icon, "BOTTOMRIGHT", -1,1},nil,"OUTLINE",12);
		hang.item.NO:SetTextColor(1, 1, 1, 1)
		hang.item.daojishiF = CreateFrame("Frame", nil, hang.item);
		hang.item.daojishiF:SetSize(22,22);
		hang.item.daojishiF:SetPoint("LEFT", hang.item.link, "RIGHT", 0,0);
		hang.item.daojishiF:Hide();
		hang.item.daojishi = hang.item.daojishiF:CreateTexture(nil, "BORDER");
		hang.item.daojishi:SetTexture("interface/helpframe/helpicon-reportlag.blp");
		hang.item.daojishi:SetSize(28,28);
		hang.item.daojishi:SetPoint("CENTER", 0,0);
		PIGEnter(hang.item.daojishiF,"请注意：","|cffFFff00可交易时间不足10分钟|r")
		function hang.item:SetFun(itemNameD,itemLinkD)
			self.link:SetText(itemLinkD);
			self.itemLink=itemLinkD
		end
		hang.item:SetScript("OnMouseDown", function (self,button)
			if button=="LeftButton" then
				if not IsShiftKeyDown() and not IsControlKeyDown() then
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(self.link, "ANCHOR_CURSOR");
					GameTooltip:SetHyperlink(self.itemLink);
				end
			end
		end);
		hang.item:SetScript("OnMouseUp", function (self,button)
			GameTooltip:ClearLines();GameTooltip:Hide()
		end);
		hang.item:SetScript("OnClick", function (self,button)
			local bianjiData = PIGA["GDKP"]["ItemList"][self:GetID()]
			if button=="LeftButton" then
		 		if IsShiftKeyDown() then
					local editBox = ChatEdit_ChooseBoxForSend();
					local hasText = editBox:GetText()..self.itemLink
					if editBox:HasFocus() then
						editBox:SetText(hasText);
					else
						ChatEdit_ActivateChat(editBox)
						editBox:SetText(hasText);
					end
				elseif IsControlKeyDown() then
					fujiF.tishiUI:Showtishi("he",self:GetID())	
				end 
			elseif button=="RightButton" then
				if IsControlKeyDown() then
					local zonliag = bianjiData[3]
					if zonliag>1 then
						fujiF.tishiUI:Showtishi("chai",self:GetID())
					end
				elseif IsShiftKeyDown() then--关注
					if bianjiData[15] then
						bianjiData[15]=false
						PIGinfotip:TryDisplayMessage(self.itemLink.."已取消关注");
					else
						bianjiData[15]=true
						PIGinfotip:TryDisplayMessage(self.itemLink.."已加入关注");
					end
					RaidR.Update_Item();
				else
					if TradeFrame:IsShown() then
						for i=0,4 do
							local xx=GetContainerNumSlots(i) 
							for j=1,xx do
								if GetContainerItemID(i,j)==bianjiData[11] then
									UseContainerItem(i, j);
									break;
								end
							end 
						end
					else
						fujiF.tishiUI:Showtishi("hei",self:GetID())	
					end
				end
			end		
		end);
		---------
		hang.chengjiao = CreateFrame("Frame", nil, hang);
		hang.chengjiao:SetSize(70, hang_Height);
		hang.chengjiao:SetPoint("LEFT", hang, "LEFT", biaotiList[6][2]-26,0);
		hang.chengjiao.G = PIGFontString(hang.chengjiao,{"RIGHT", hang.chengjiao, "RIGHT", 0,0});
		hang.chengjiao.G:SetTextColor(0, 1, 1, 1);
		hang.chengjiao.E = CreateFrame("EditBox", nil, hang.chengjiao, "InputBoxInstructionsTemplate");
		hang.chengjiao.E:SetSize(60,hang_Height);
		hang.chengjiao.E:SetPoint("RIGHT",hang.chengjiao,"RIGHT",0,0);
		PIGSetFont(hang.chengjiao.E,14,"OUTLINE")
		hang.chengjiao.E:SetMaxLetters(7)
		hang.chengjiao.E:SetNumeric(true)
		hang.chengjiao.E:SetScript("OnEscapePressed", function(self) 
			shiqujiaodian(self:GetParent())
		end);
		hang.chengjiao.E:SetScript("OnEnterPressed", function(self)
	 		local NWEdanjiaV=self:GetNumber();
			PIGA["GDKP"]["ItemList"][self:GetID()][9]=NWEdanjiaV;
			RaidR.Update_Item();
		end);
		hang.chengjiao.bianji = CreateFrame("Button",nil,hang.chengjiao, "TruncatedButtonTemplate");
		hang.chengjiao.bianji:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		hang.chengjiao.bianji:SetSize(hang_Height-7,hang_Height-7);
		hang.chengjiao.bianji:SetPoint("LEFT", hang.chengjiao, "RIGHT", -1,0);
		hang.chengjiao.bianji.Tex = hang.chengjiao.bianji:CreateTexture(nil, "BORDER");
		hang.chengjiao.bianji.Tex:SetTexture("interface/buttons/ui-guildbutton-publicnote-up.blp");
		hang.chengjiao.bianji.Tex:SetPoint("CENTER");
		hang.chengjiao.bianji.Tex:SetSize(hang_Height-12,hang_Height-10);
		hang.chengjiao.bianji:SetScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",-1.5,-1.5);
		end);
		hang.chengjiao.bianji:SetScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER");
		end);
		hang.chengjiao.bianji:SetScript("OnClick", function (self)
			local NewSELF=self:GetParent()
			for qq=1,hang_NUM do
				shiqujiaodian(_G["PIG_GDKPItem_"..qq].chengjiao)
				shiqujiaodian(_G["PIG_GDKPItem_"..qq].Qiankuan)
			end
			shiqujiaodian(NewSELF,true)
	 		NewSELF.E:SetText(PIGA["GDKP"]["ItemList"][self:GetID()][9]);
		end);
		hang.chengjiao.baocun = PIGButton(hang.chengjiao,{"LEFT", hang.chengjiao, "RIGHT", 2,0},{hang_Height,hang_Height-12},"保存");
		hang.chengjiao.baocun:Hide();
		hang.chengjiao.baocun:SetScale(0.9)
		hang.chengjiao.baocun:SetScript("OnClick", function (self)
			local NewSELF=self:GetParent()
	 		local NWEdanjiaV=NewSELF.E:GetNumber();
			PIGA["GDKP"]["ItemList"][self:GetID()][9]=NWEdanjiaV;
			RaidR.Update_Item();
		end);

		---欠款-----
		hang.Qiankuan = CreateFrame("Frame", nil, hang);
		hang.Qiankuan:SetSize(70, hang_Height);
		hang.Qiankuan:SetPoint("LEFT", hang, "LEFT", biaotiList[7][2]-26,0);
		hang.Qiankuan.G = PIGFontString(hang.Qiankuan,{"RIGHT", hang.Qiankuan, "RIGHT", 0,0});
		hang.Qiankuan.G:SetTextColor(0.988, 0.27, 0, 1);
		hang.Qiankuan.E = CreateFrame("EditBox", nil, hang.Qiankuan, "InputBoxInstructionsTemplate");
		hang.Qiankuan.E:SetSize(60,hang_Height);
		hang.Qiankuan.E:SetPoint("RIGHT",hang.Qiankuan,"RIGHT",0,0);
		PIGSetFont(hang.Qiankuan.E,14,"OUTLINE")
		hang.Qiankuan.E:SetMaxLetters(7)
		hang.Qiankuan.E:SetNumeric(true)
		--hang.Qiankuan.E:SetAutoFocus(false)
		hang.Qiankuan.E:SetScript("OnEscapePressed", function(self) 
			shiqujiaodian(self:GetParent())
		end);
		hang.Qiankuan.E:SetScript("OnEnterPressed", function(self) 
			PIGA["GDKP"]["ItemList"][self:GetID()][14]=self:GetNumber();
			RaidR.Update_Item();
		end);
		hang.Qiankuan.bianji = CreateFrame("Button",nil,hang.Qiankuan, "TruncatedButtonTemplate");
		hang.Qiankuan.bianji:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp");
		hang.Qiankuan.bianji:SetSize(hang_Height-7,hang_Height-7);
		hang.Qiankuan.bianji:SetPoint("LEFT", hang.Qiankuan, "RIGHT", -1,0);
		hang.Qiankuan.bianji.Tex = hang.Qiankuan.bianji:CreateTexture(nil, "BORDER");
		hang.Qiankuan.bianji.Tex:SetTexture("interface/buttons/ui-guildbutton-publicnote-up.blp");
		hang.Qiankuan.bianji.Tex:SetPoint("CENTER");
		hang.Qiankuan.bianji.Tex:SetSize(hang_Height-12,hang_Height-10);
		hang.Qiankuan.bianji:SetScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",-1.5,-1.5);
		end);
		hang.Qiankuan.bianji:SetScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER");
		end);
		hang.Qiankuan.bianji:SetScript("OnClick", function (self)
			local NewSELF=self:GetParent()
			for qq=1,hang_NUM do
				shiqujiaodian(_G["PIG_GDKPItem_"..qq].chengjiao)
				shiqujiaodian(_G["PIG_GDKPItem_"..qq].Qiankuan)
			end
			shiqujiaodian(NewSELF,true)
	 		NewSELF.E:SetText(PIGA["GDKP"]["ItemList"][self:GetID()][14]);
		end);
		hang.Qiankuan.baocun = PIGButton(hang.Qiankuan,{"LEFT", hang.Qiankuan, "RIGHT", 2,0},{hang_Height,hang_Height-12},"保存");
		hang.Qiankuan.baocun:Hide();
		hang.Qiankuan.baocun:SetScale(0.9)
		hang.Qiankuan.baocun:SetScript("OnClick", function (self)
			local NewSELF=self:GetParent()
			local NWEdanjiaV=NewSELF.E:GetNumber();
			PIGA["GDKP"]["ItemList"][self:GetID()][14]=NWEdanjiaV;
			RaidR.Update_Item();
		end);

		hang.ChengjiaoRen = CreateFrame("Button", nil, hang, "TruncatedButtonTemplate");
		hang.ChengjiaoRen:SetHighlightTexture("interface/paperdollinfoframe/ui-character-tab-highlight.blp");
		hang.ChengjiaoRen:SetSize(118,hang_Height);
		hang.ChengjiaoRen:SetPoint("LEFT", hang, "LEFT", biaotiList[8][2]-6,0);
		PIGSetFont(hang.ChengjiaoRen.Text,14,"OUTLINE")
		hang.ChengjiaoRen.Text:SetJustifyH("LEFT")
		hang.ChengjiaoRen.Text:SetTextColor(0,1,0, 1);
		hang.ChengjiaoRen:SetScript("OnClick", function (self)
			if RaidR.PlayerList:IsShown() then
				RaidR.PlayerList:Hide() 
			else
				RaidR.PlayerList:Showtishi("ChengjiaoRen",self:GetID())
			end
		end);
		hang.ChengjiaoRen:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		hang.ChengjiaoRen:SetScript("OnEnter", function (self)
			if self.AllName~="N/A" then
				GameTooltip:ClearLines();
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,0);
				local pgdkp_qiankuanheji = {0,0}
				local RRItemList = PIGA["GDKP"]["ItemList"]
				GameTooltip:AddLine("此玩家消费/欠款物品如下:")
				for x=1,#RRItemList do
					if RRItemList[x][8]==self.AllName then
						if RRItemList[x][9]>0 then
							pgdkp_qiankuanheji[1]=pgdkp_qiankuanheji[1]+RRItemList[x][9]
							local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(RRItemList[x][2]))
							GameTooltip:AddDoubleLine(itemLink,"|cff00FF00收:|r"..GetMoneyString(RRItemList[x][9]*10000))
						end
					end
				end
				GameTooltip:AddDoubleLine(" ","|cff00FF00消费合计:|r"..GetMoneyString(pgdkp_qiankuanheji[1]*10000))
				for x=1,#RRItemList do
					if RRItemList[x][8]==self.AllName then
						if RRItemList[x][14]>0 then
							pgdkp_qiankuanheji[2]=pgdkp_qiankuanheji[2]+RRItemList[x][14]
							local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(RRItemList[x][2]))
							GameTooltip:AddDoubleLine(itemLink,"|cffFF0000欠:|r"..GetMoneyString(RRItemList[x][14]*10000))
						end
					end
				end
				GameTooltip:AddDoubleLine(" ","|cffFF0000欠款合计:|r"..GetMoneyString(pgdkp_qiankuanheji[2]*10000))
				pgdkp_qiankuanheji = nil
				GameTooltip:Show();
			end
		end);
	end
	--弹窗提示=========================
	fujiF.tishiUI = PIGFrame(fujiF,{"TOPLEFT",fujiF,"TOPLEFT",0,0});
	fujiF.tishiUI:SetPoint("BOTTOMRIGHT", fujiF, "BOTTOMRIGHT", 0,0);
	fujiF.tishiUI:EnableMouse(true);
	fujiF.tishiUI:SetFrameLevel(FrameLevel+10);
	fujiF.tishiUI:Hide();
	fujiF.tishiUI.nr = PIGFrame(fujiF.tishiUI,{"TOP",fujiF.tishiUI,"TOP",0,-20},{300,200});
	fujiF.tishiUI.nr:PIGSetBackdrop(1)
	fujiF.tishiUI.nr:PIGClose(nil,nil,fujiF.tishiUI)
	fujiF.tishiUI.nr.t = PIGFontString(fujiF.tishiUI.nr,{"TOP", fujiF.tishiUI.nr, "TOP", 0,-28});

	fujiF.tishiUI.nr.Slider=PIGSlider(fujiF.tishiUI.nr,{"TOP",fujiF.tishiUI.nr.t,"BOTTOM",0,-20},{1,1,1,{["Top"]=""}})
	--拍卖
	fujiF.tishiUI.nr.auc = PIGFrame(fujiF.tishiUI.nr,{"TOPLEFT",fujiF.tishiUI.nr,"TOPLEFT",1,-60});
	fujiF.tishiUI.nr.auc:PIGSetBackdrop(1,0)
	fujiF.tishiUI.nr.auc:SetPoint("BOTTOMRIGHT", fujiF.tishiUI.nr, "BOTTOMRIGHT", -1,1);
	fujiF.tishiUI.nr.auc:SetFrameLevel(fujiF.tishiUI.nr.auc:GetFrameLevel()+10)
	fujiF.tishiUI.nr.auc.qpt = PIGFontString(fujiF.tishiUI.nr.auc,{"TOPLEFT", fujiF.tishiUI.nr.auc, "TOPLEFT", 44,-10},"起拍价:",16);
	---起拍价
	local jiagelist = {1,2,3,4,5,6,7,8,9}
	fujiF.tishiUI.nr.auc.qipaijia0=PIGDownMenu(fujiF.tishiUI.nr.auc,{"LEFT",fujiF.tishiUI.nr.auc.qpt,"RIGHT", 2,0},{70,22})
	fujiF.tishiUI.nr.auc.qipaijia0.morenqiV=1
	function fujiF.tishiUI.nr.auc.qipaijia0:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#jiagelist,1 do
		    info.text, info.arg1 = jiagelist[i], jiagelist[i]
		    info.checked = jiagelist[i]==self.morenqiV
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.tishiUI.nr.auc.qipaijia0:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		self.morenqiV=arg1
		PIGCloseDropDownMenus()
	end
	
	--起拍单位
	local danweiV ={"0","00","000","0000","00000","000000"}
	local danweiName ={["0"]="十",["00"]="百",["000"]="千",["0000"]="万",["00000"]="十万",["000000"]="百万"}
	fujiF.tishiUI.nr.auc.qipaijia1=PIGDownMenu(fujiF.tishiUI.nr.auc,{"LEFT",fujiF.tishiUI.nr.auc.qipaijia0,"RIGHT", 0,0},{80,22})
	fujiF.tishiUI.nr.auc.qipaijia1.value="0000"
	function fujiF.tishiUI.nr.auc.qipaijia1:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#danweiV,1 do
		    info.text, info.arg1 = danweiName[danweiV[i]], danweiV[i]
		    info.checked = danweiV[i]==self.value
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.tishiUI.nr.auc.qipaijia1:PIGDownMenu_SetValue(value,arg1,arg2)
		fujiF.tishiUI.nr.auc.qipaijia1:PIGDownMenu_SetText(value)
		self.value=arg1
		PIGCloseDropDownMenus()
	end
	--单次加价----------------------------------------
	fujiF.tishiUI.nr.auc.dct = PIGFontString(fujiF.tishiUI.nr.auc,{"TOPLEFT", fujiF.tishiUI.nr.auc, "TOPLEFT", 29,-38},"最低加价:",16);
	fujiF.tishiUI.nr.auc.dancijia0=PIGDownMenu(fujiF.tishiUI.nr.auc,{"LEFT",fujiF.tishiUI.nr.auc.dct,"RIGHT", 2,0},{70,22})
	fujiF.tishiUI.nr.auc.dancijia0.morenqiV=1
	function fujiF.tishiUI.nr.auc.dancijia0:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#jiagelist,1 do
		    info.text, info.arg1 = jiagelist[i], jiagelist[i]
		    info.checked = jiagelist[i]==self.morenqiV
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.tishiUI.nr.auc.dancijia0:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		self.morenqiV=arg1
		PIGCloseDropDownMenus()
	end
	--选择单次加价单位
	fujiF.tishiUI.nr.auc.dancijia1=PIGDownMenu(fujiF.tishiUI.nr.auc,{"LEFT",fujiF.tishiUI.nr.auc.dancijia0,"RIGHT", 0,0},{80,22})
	fujiF.tishiUI.nr.auc.dancijia1.value="000"
	function fujiF.tishiUI.nr.auc.dancijia1:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#danweiV,1 do
		    info.text, info.arg1 = danweiName[danweiV[i]], danweiV[i]
		    info.checked = danweiV[i]==self.value
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.tishiUI.nr.auc.dancijia1:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		self.value=arg1
		PIGCloseDropDownMenus()
	end
	---
	fujiF.tishiUI.nr.auc.CStime=5
	fujiF.tishiUI.nr.auc.DJtime=fujiF.tishiUI.nr.auc.CStime
	fujiF.tishiUI.nr.auc.zanting=false
	fujiF.tishiUI.nr.auc.aucend=nil
	--初始按钮
	local function daojishi_Show()
		local fujikk = fujiF.tishiUI.nr.auc
		fujikk.aucend=nil
		fujikk.zanting=false
		fujikk.DJtime=fujikk.CStime
		fujikk.daojishi:SetText("启动倒数")
		fujikk.daojishi:Disable();
		fujikk.daojishi.t:SetText("")
		fujikk.YES:SetText("开始拍卖")
		fujikk.YES:Enable();
	end
	local function daojishi_End()
		local fujikk = fujiF.tishiUI.nr.auc
		fujikk.DJtime=fujikk.CStime
		fujikk.daojishi:SetText("倒数结束")
		fujikk.daojishi:Disable();
		fujikk.YES:SetText("拍卖完成")
		fujikk.YES:Enable();
	end
	--倒数
	local function daojishikaiguai()
		local fujikk = fujiF.tishiUI.nr.auc
		if fujikk.aucend==nil then return end
		if fujikk.zanting then return end		
		if fujikk.DJtime>0 then
			fujikk.daojishi.t:SetText(fujikk.DJtime);
			PIGSendChatRaidParty("拍卖结束倒数:"..fujikk.DJtime.."秒")
			fujikk.DJtime=fujikk.DJtime-1
			C_Timer.After(1,daojishikaiguai)
		else
			PIGSendAddonMessage(biaotou,auc_daoshu.."&0")
			local hejishuju = PIGA["GDKP"]["ItemList"][fujiF.tishiUI.bianjiID]
			local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(hejishuju[2]))
			PIGSendChatRaidParty(itemLink.."拍卖结束")
			daojishi_End()
		end
	end
	--开始拍卖
	fujiF.tishiUI.nr.auc.YES = PIGButton(fujiF.tishiUI.nr.auc,{"TOP",fujiF.tishiUI.nr.auc,"TOP",0,-68},{90,24},"开始拍卖");  
	fujiF.tishiUI.nr.auc.YES:SetScript("OnClick", function (self)
		local hejishuju = PIGA["GDKP"]["ItemList"][fujiF.tishiUI.bianjiID]
		local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(hejishuju[2]))
		if self:GetText()=="开始拍卖" then
			fujiF.tishiUI.nr.auc.aucend=false
			self:Disable();
			fujiF.tishiUI.nr.auc.daojishi:Enable()
			local qipaishuV=fujiF.tishiUI.nr.auc.qipaijia0:PIGDownMenu_GetText()
			local qipaidanweiV=fujiF.tishiUI.nr.auc.qipaijia1:PIGDownMenu_GetValue()
			local dancishuV=fujiF.tishiUI.nr.auc.dancijia0:PIGDownMenu_GetText()
			local dancidanweiV=fujiF.tishiUI.nr.auc.dancijia1:PIGDownMenu_GetValue()
			local paimaiwupinxinxi="开始拍卖:"..itemLink..",数量:"..hejishuju[3]..",起拍:"..qipaishuV..qipaidanweiV.."G,最低加价："..dancishuV..dancidanweiV.."G";
			PIGSendChatRaidParty(paimaiwupinxinxi)
			PIGSendAddonMessage(biaotou,auc_start.."&"..itemLink.."#"..hejishuju[3].."#"..qipaishuV..qipaidanweiV.."#"..dancishuV..dancidanweiV)
		elseif self:GetText()=="拍卖完成" then
			fujiF.tishiUI.nr.auc.aucend=true
			fujiF.tishiUI:Hide()
			hejishuju[7]=true
			RaidR.Update_Item();
			PIGSendAddonMessage(biaotou,auc_end)
		end
	end);
	fujiF.tishiUI.nr.auc.daojishiCZ = PIGButton(fujiF.tishiUI.nr.auc,{"LEFT",fujiF.tishiUI.nr.auc.YES,"RIGHT",30,0},{54,24},"重置");  
	fujiF.tishiUI.nr.auc.daojishiCZ:Hide();
	fujiF.tishiUI.nr.auc.daojishiCZ:SetScript("OnClick", function (self)
		fujiF.tishiUI.nr.auc.zanting=true
		fujiF.tishiUI.nr.auc.daojishi.t:SetText(fujiF.tishiUI.nr.auc.CStime)
		fujiF.tishiUI.nr.auc.daojishi:SetText("启动倒数")
		fujiF.tishiUI.nr.auc.daojishi:Enable()
		self:Hide();
	end);
	--倒数按钮
	fujiF.tishiUI.nr.auc.daojishi = PIGButton(fujiF.tishiUI.nr.auc,{"TOP",fujiF.tishiUI.nr.auc.YES,"BOTTOM",0,-8},{100,24},"启动倒数");  
	fujiF.tishiUI.nr.auc.daojishi:Disable();
	fujiF.tishiUI.nr.auc.daojishi.t = PIGFontString(fujiF.tishiUI.nr.auc,{"RIGHT", fujiF.tishiUI.nr.auc.daojishi, "LEFT", -26,15},"","OUTLINE",52);
	fujiF.tishiUI.nr.auc.daojishi:SetScript("OnClick", function (self)
		if self:GetText()=="启动倒数" then
			self:SetText("暂停倒数")
			fujiF.tishiUI.nr.auc.zanting=false
			fujiF.tishiUI.nr.auc.DJtime = fujiF.tishiUI.nr.auc.CStime
			daojishikaiguai()
		elseif self:GetText()=="暂停倒数" then
			fujiF.tishiUI.nr.auc.daojishiCZ:Show();
			self:SetText("继续倒数")
			fujiF.tishiUI.nr.auc.zanting=true
			PIGSendChatRaidParty("拍卖倒数已暂停")
		elseif self:GetText()=="继续倒数" then
			self:SetText("暂停倒数")
			fujiF.tishiUI.nr.auc.zanting=false
			PIGSendChatRaidParty("拍卖倒数已恢复")
			C_Timer.After(1,daojishikaiguai)
		end
	end);
	local daojishitimeList = {3,5,10,15,20}
	fujiF.tishiUI.nr.auc.daojishi.time=PIGDownMenu(fujiF.tishiUI.nr.auc,{"LEFT",fujiF.tishiUI.nr.auc.daojishi,"RIGHT", 16,0},{66,22})
	function fujiF.tishiUI.nr.auc.daojishi.time:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#daojishitimeList,1 do
		    info.text, info.arg1 = daojishitimeList[i].."秒", daojishitimeList[i]
		    info.checked = daojishitimeList[i]==fujiF.tishiUI.nr.auc.CStime
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.tishiUI.nr.auc.daojishi.time:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		fujiF.tishiUI.nr.auc.CStime=arg1
		PIGCloseDropDownMenus()
	end
	--关闭
	fujiF.tishiUI.nr.Close:HookScript("OnClick", function (self)
		local fujikk = fujiF.tishiUI.nr.auc
		if fujikk.aucend==false then
			fujikk.aucend=nil
			local bianjiID=fujiF.tishiUI.bianjiID
			local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(PIGA["GDKP"]["ItemList"][bianjiID][2]))
			PIGSendChatRaidParty(itemLink.."拍卖非正常终止")
			PIGSendAddonMessage(biaotou,auc_end)
		end
	end);
	---
	fujiF.tishiUI.nr.YES = PIGButton(fujiF.tishiUI.nr,{"TOP",fujiF.tishiUI.nr,"TOP",-50,-144},{60,28},"确定"); 
	fujiF.tishiUI.nr.YES:SetScript("OnClick", function(self)
		local bianjiID=fujiF.tishiUI.bianjiID
		local GNNn=fujiF.tishiUI.GNNn
		local hejishuju = PIGA["GDKP"]["ItemList"]
		local ItemIDx = hejishuju[bianjiID][11]
		if GNNn=="del" then
			table.remove(hejishuju,bianjiID);
		elseif GNNn=="hei" then
			local paichumulu = PIGA["GDKP"]["Rsetting"]["PaichuList"]
			for j=1,#paichumulu do
				if ItemIDx==paichumulu[j] then
					PIGinfotip:TryDisplayMessage("物品已在目录内");
					return
				end
			end
			table.insert(paichumulu, ItemIDx);
			for j=#hejishuju,1,-1 do
				if ItemIDx==hejishuju[j][11] then
					table.remove(hejishuju, j);
				end
			end
		elseif GNNn=="he" then
			--统计数量
			local hebingwupinzongshuliang = {0,0}
			for i=1,#hejishuju do
				if ItemIDx==hejishuju[i][11] then
					hebingwupinzongshuliang[1]=hebingwupinzongshuliang[1]+hejishuju[i][3]
					if hebingwupinzongshuliang[2]==0 then
						hebingwupinzongshuliang[2]=i
					end
				end
			end
			--删除除第一个之外的所有相同
			for i=#hejishuju,1,-1 do
				if ItemIDx==hejishuju[i][11] then
					if hebingwupinzongshuliang[2]~=i then
						table.remove(hejishuju,i);
					end
				end
			end
			hejishuju[hebingwupinzongshuliang[2]][3]=hebingwupinzongshuliang[1]
		elseif GNNn=="chai" then
			local fengeNUM=fujiF.tishiUI.nr.Slider.Slider:GetValue()
			if hejishuju[bianjiID][3]>1 then
				hejishuju[bianjiID][3]=hejishuju[bianjiID][3]-fengeNUM
				local item1=hejishuju[bianjiID][1]
				local item2=hejishuju[bianjiID][2]
				local item4=hejishuju[bianjiID][4]
				local item5=hejishuju[bianjiID][5]
				local item6=hejishuju[bianjiID][6]
				local item11=hejishuju[bianjiID][11]
				print(fengeNUM)
				local iteminfo={item1,item2,fengeNUM,item4,item5,item6,false,"N/A",0,0,item11,true,true,0,false};
				table.insert(hejishuju,bianjiID+1,iteminfo)
			end
		end
		fujiF.tishiUI:Hide();
		RaidR.Update_Item();	
	end);
	fujiF.tishiUI.nr.NO = PIGButton(fujiF.tishiUI.nr,{"TOP",fujiF.tishiUI.nr,"TOP",50,-144},{60,28},"取消");  
	fujiF.tishiUI.nr.NO:SetScript("OnClick", function()
		fujiF.tishiUI:Hide();
	end);
	function fujiF.tishiUI:Showtishi(GNNn,id)
		self:Show();
		self.nr.Slider:Hide()
		self.nr.auc:Hide()
		self.bianjiID=id
		self.GNNn=GNNn
		local biajidata = PIGA["GDKP"]["ItemList"][id]
		local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(biajidata[2]))
		if GNNn=="del" then
			self.nr.t:SetText("确定要\124cffff0000删除\124r\n"..itemLink.."\n".."的拾取记录吗?")
		elseif GNNn=="hei" then
			self.nr.t:SetText("确定要把\n"..itemLink.."\n加入到\124cff66FF00拾取忽略目录\124r吗?\n\n\124cff00FF00后续拾取此物品将不会记录,\n可在设置内管理\124r")
		elseif GNNn=="he" then
			self.nr.t:SetText("确定要合并列表中的所有\n"..itemLink.."\n".."到一条记录吗？")
		elseif GNNn=="chai" then
			self.nr.Slider:Show()
			self.nr.t:SetText("拆分\n"..itemLink.."\n".."拆分数量")
			self.nr.Slider.LeftText:SetText(1)
			self.nr.Slider.LeftText:Show()
			self.nr.Slider.RightText:SetText(biajidata[3]-1)
			self.nr.Slider.RightText:Show()
			self.nr.Slider:PIGSetValueMinMax(1,1,biajidata[3]-1)
		elseif GNNn=="auc" then
			daojishi_Show()
			self.nr.auc:Show()
			self.nr.t:SetText("拍卖物品：\n"..itemLink.."\124cffffFF00x\124r"..biajidata[3])
			self.nr.auc.qipaijia0:PIGDownMenu_SetText(self.nr.auc.qipaijia0.morenqiV)
			self.nr.auc.qipaijia1:PIGDownMenu_SetText(danweiName[self.nr.auc.qipaijia1.value])
			self.nr.auc.dancijia0:PIGDownMenu_SetText(self.nr.auc.dancijia0.morenqiV)
			self.nr.auc.dancijia1:PIGDownMenu_SetText(danweiName[self.nr.auc.dancijia1.value])
			self.nr.auc.daojishi.time:PIGDownMenu_SetText(self.nr.auc.CStime.."秒")
		end
	end
	fujiF.tishiUI.nr.auc:RegisterEvent("CHAT_MSG_ADDON");            
	fujiF.tishiUI.nr.auc:SetScript("OnEvent",function(self, event, arg1, arg2, arg3, arg4, arg5)
		if event=="CHAT_MSG_ADDON" and arg1 == biaotou then
			local kaishijieshu, neirong = strsplit("&", arg2);
			if kaishijieshu==auc_chujia then--收到其他玩家拍卖出价
				if self.daojishi:GetText()=="暂停倒数" then
					self.daojishi:SetText("继续倒数")
					self.zanting=true
					self.daojishiCZ:Show();
					PIGSendChatRaidParty("有新出价,拍卖倒数已暂停")
				end
			end
		end
	end)

	--目录下方
	fujiF.tishi = CreateFrame("Frame", nil, fujiF);
	fujiF.tishi:SetSize(iconWH,iconWH);
	fujiF.tishi:SetPoint("TOPLEFT",fujiF.yedibuF,"BOTTOMLEFT",4,-5);
	fujiF.tishi.Tex = fujiF.tishi:CreateTexture(nil, "BORDER");
	fujiF.tishi.Tex:SetTexture("interface/common/help-i.blp");
	fujiF.tishi.Tex:SetSize(iconWH+8,iconWH+8);
	fujiF.tishi.Tex:SetPoint("CENTER");
	PIGEnter(fujiF.tishi,"物品名点击提示：",tishixx)
	fujiF.DqNameT = PIGFontString(fujiF,{"LEFT",fujiF.tishi,"RIGHT", 10,0},"当前账本: ");
	fujiF.DqNameT:SetTextColor(0, 1, 0, 1);
	fujiF.DqNameV = PIGFontString(fujiF,{"LEFT",fujiF.DqNameT,"RIGHT",2,0});
	function RaidR.Update_DqName()
		local fubenN = PIGA["GDKP"]["instanceName"][2] or ""
		local fubennandu = PIGA["GDKP"]["instanceName"][3] or ""
		fujiF.DqNameV:SetText(fubenN.."-"..fubennandu);
	end
	--最低拾取品质
	local Quality=Data.Quality
	fujiF.D=PIGDownMenu(fujiF,{"TOPRIGHT",fujiF.yedibuF,"BOTTOMRIGHT",-10,-2},{80,24})
	fujiF.D.txt = PIGFontString(fujiF.D,{"RIGHT",fujiF.D,"LEFT", -2,0},"\124cff00FF00记录品质\124r");
	function fujiF.D:PIGDownMenu_Update_But(self)
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,7,1 do
		    info.text, info.arg1 = Quality[i]["Name"], i
		    info.checked = i==PIGA["GDKP"]["LootQuality"]
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fujiF.D:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		PIGA["GDKP"]["LootQuality"]=arg1
		PIGCloseDropDownMenus()
	end
	------
	fujiF:HookScript("OnShow", function (self)
		RaidR.Update_DqName()
		self.D:PIGDownMenu_SetText(Quality[PIGA["GDKP"]["LootQuality"]]["Name"])
		RaidR.Update_Item();
	end)

	--物品交易倒计时
	local function ItemJiaoyiTime()
		if not InCombatLockdown() and IsInRaid() and UnitIsGroupLeader("player") then
			if PIGA["GDKP"]["Open"] and PIGA["GDKP"]["Rsetting"]["jiaoyidaojishi"] then
				if PIGA["GDKP"]["instanceName"][1] then
					local dangtianT = GetServerTime()
					if dangtianT-PIGA["GDKP"]["instanceName"][1]<43200 then
						local ItemL = PIGA["GDKP"]["ItemList"]
						local Itemnum = #ItemL
						if Itemnum>0 then
							for i=1,Itemnum,1 do
								if ItemL[i][13] then
									if ItemL[i][8]~="N/A" or ItemL[i][9]>0 or ItemL[i][14]>0 then--已有成交人/收款/欠款
										ItemL[i][13]=false;
									else
										local yijingguoqu=dangtianT-ItemL[i][1];
										if yijingguoqu>7200 then
											ItemL[i][13]=false;	
										elseif yijingguoqu>6600 then
											if ItemL[i][12] then
												local _,itemLink = GetItemInfo(Fun.HY_ItemLinkJJ(ItemL[i][2]))
												PIGSendChatRaidParty("提示：未成交物品"..itemLink.."可交易时间不足10分钟，请确认物品归属(预估时间仅供参考)！")
												ItemL[i][12]=false;
											end
										end	
									end
								end
							end
						end
					end
				end	
			end
		end
		C_Timer.After(30,ItemJiaoyiTime);
	end
	C_Timer.After(5,ItemJiaoyiTime);
	--======================================================
	local function zhixingtianjia(itemLink,LOOT_itemNO,shiquname,itemQuality,itemTexture,itemID)
		if #PIGA["GDKP"]["ItemList"]==0 then
			local FBname, instanceType, difficultyID, difficultyName = GetInstanceInfo()
			PIGA["GDKP"]["instanceName"]={GetServerTime(),FBname,difficultyName}
			RaidR.Update_DqName()
		end
		local itemLink=Fun.GetItemLinkJJ(itemLink)
		local iteminfo={
			GetServerTime(),--1时间
			itemLink,--2物品
			LOOT_itemNO,--3数量
			shiquname,--4拾取人
			itemQuality,--5品质
			itemTexture,--6icon
			false,--7已拍卖
			"N/A",--8成交人
			0,--9成交价
			0,--10成交时间
			itemID,--11
			true,--12已提醒交易倒计时
			true,--13通报已结束
			0,--14欠款
			false,--15关注
		};
		table.insert(PIGA["GDKP"]["ItemList"],iteminfo);
		RaidR.Update_Item();
	end
	--手动添加物品
	hooksecurefunc("ChatFrame_OnHyperlinkShow",function(chatFrame, link, text, button)
		if RaidR:IsShown() and fujiF:IsShown() then
			local aShiftKeyIsDown = IsShiftKeyDown();
			if aShiftKeyIsDown then
				if PIGA["GDKP"]["Rsetting"]["shoudongloot"] then
					if link:match("item") then
						local itemID = GetItemInfoInstant(link);
						local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,itemEquipLoc, itemTexture=GetItemInfo(link);
						if itemLink~=nil and itemQuality~=nil and itemTexture~=nil then
							local LOOT_itemNO,shiquname=1,"手动添加";
							zhixingtianjia(itemLink,LOOT_itemNO,shiquname,itemQuality,itemTexture,itemID)
						end
					end
				else
					PIGinfotip:TryDisplayMessage("未开启手动添加物品，请在设置中开启");
				end
			end
		end
	end)
	--=====================================================
	--拾取记录添加到数组
	local function AddItem(MSGINFO,shiquname)
		local _, itemLink, itemQuality, _, _, _, _, _, _, itemTexture =GetItemInfo(MSGINFO);
		if itemQuality>=PIGA["GDKP"]["LootQuality"] then
			local itemID = GetItemInfoInstant(itemLink);
			local LOOT_itemNO = 1;
			local Nkaishi=MSGINFO:find("x",1)
			if Nkaishi then
				local NewitemNO=MSGINFO:sub(Nkaishi+1)
				local NewitemNO=NewitemNO:gsub(" ","")
				local NewitemNO=NewitemNO:gsub(",","")
				local NewitemNO=NewitemNO:gsub("，","")
				local NewitemNO=NewitemNO:gsub("%.","")
				local NewitemNO=NewitemNO:gsub("。","")
				local NewitemNO=NewitemNO:gsub("!","")
				local NewitemNO=NewitemNO:gsub("！","")
				local NewitemNO=tonumber(NewitemNO)
				if NewitemNO>1 then LOOT_itemNO = NewitemNO end
			end
			--过滤副本临时武器/公正徽章
			local renwuwupin = {29434,22736,30311,30312,30313,30314,30316,30317,30318,30319,30320}
			for id=1,#renwuwupin do--任务物品
				if itemID==renwuwupin[id] then
					return;
				end
			end
			--过滤排除目录物品
			for id=1,#PIGA["GDKP"]["Rsetting"]["PaichuList"] do 
				if itemID==PIGA["GDKP"]["Rsetting"]["PaichuList"][id] then
					return;
				end
			end
			zhixingtianjia(itemLink,LOOT_itemNO,shiquname,itemQuality,itemTexture,itemID)
		end
	end
	---注册事件
	local function geshihuazifu(text)
		local text = text:gsub("%%","")
		local text = text:gsub("s","")
		local text = text:gsub("x","")
		local text = text:gsub("d","")
		local text = text:gsub("。","")
		local text = text:gsub(": ","")
		local text = text:gsub("：","")
		local text = text:gsub("%.","")
		local text = text:gsub("。","")
		return text
	end			
	local bendiT_1 = LOOT_ITEM_SELF--自身单个物品
	local bendiT_2 = LOOT_ITEM_SELF_MULTIPLE--自身叠加物品
	local bendiT_3 = LOOT_ITEM--他人单个物品
	local bendiT_4 = LOOT_ITEM_MULTIPLE--他人叠加物品
	local bendiT_1 = geshihuazifu(bendiT_1)
	local bendiT_2 = geshihuazifu(bendiT_2)
	local bendiT_3 = geshihuazifu(bendiT_3)
	local bendiT_4 = geshihuazifu(bendiT_4)
	fujiF:RegisterEvent("CHAT_MSG_LOOT");
	fujiF:SetScript("OnEvent",function (self,event,arg1,arg2,arg3,arg4,arg5)
		if _G[GnUI].shiqulinshiStop then return end
		if not arg1:match(bendiT_1) and not arg1:match(bendiT_2) and not arg1:match(bendiT_3) and not arg1:match(bendiT_4) then return end
		local name, instanceType, difficultyID, difficultyName, maxPlayers = GetInstanceInfo()
		if instanceType=="raid" or maxPlayers>5 then
			AddItem(arg1,arg5)
		elseif instanceType=="party" then
			if PIGA["GDKP"]["Rsetting"]["wurenben"] then
				AddItem(arg1,arg5)
			end
		elseif instanceType=="none" then
			if PIGA["GDKP"]["Rsetting"]["fubenwai"] then
				AddItem(arg1,arg5)
			end
		end
	end);
end