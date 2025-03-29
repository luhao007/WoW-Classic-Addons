local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGLine=Create.PIGLine
local PIGEnter=Create.PIGEnter
local PIGButton = Create.PIGButton
local PIGDownMenu=Create.PIGDownMenu
local PIGCheckbutton=Create.PIGCheckbutton
local PIGOptionsList=Create.PIGOptionsList
local PIGFontString=Create.PIGFontString
local PIGModCheckbutton=Create.PIGModCheckbutton
local PIGQuickBut=Create.PIGQuickBut
------
local IsAddOnLoaded=IsAddOnLoaded or C_AddOns and C_AddOns.IsAddOnLoaded
local BusinessInfo=addonTable.BusinessInfo
local fuFrame,fuFrameBut = BusinessInfo.fuFrame,BusinessInfo.fuFrameBut

local GnName,GnUI,GnIcon,FrameLevel = INFO..STATISTICS,"StatsInfo_UI",133734,10
BusinessInfo.StatsInfoData={GnName,GnUI,GnIcon,FrameLevel}
------------
function BusinessInfo.StatsInfoOptions()
	fuFrame.StatsInfo_line = PIGLine(fuFrame,"TOP",-(fuFrame.dangeH*fuFrame.GNNUM))
	fuFrame.GNNUM=fuFrame.GNNUM+3
	local Tooltip = "显示副本CD/专业CD/物品/货币信息/交易/离线拍卖等各种信息记录";
	fuFrame.StatsInfo = PIGModCheckbutton(fuFrame,{GnName,Tooltip},{"TOPLEFT",fuFrame.StatsInfo_line,"TOPLEFT",20,-30})
	fuFrame.StatsInfo:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["StatsInfo"]["Open"]=true;
			BusinessInfo.StatsInfo_ADDUI()
			fuFrame.ADD_lixianBUT()
		else
			PIGA["StatsInfo"]["Open"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
		fuFrame.CheckbutShow()
		QuickButUI.ButList[8]()
	end);
	fuFrame.StatsInfo.QKBut:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["StatsInfo"]["AddBut"]=true
			QuickButUI.ButList[8]()
		else
			PIGA["StatsInfo"]["AddBut"]=false
			Pig_Options_RLtishi_UI:Show();
		end
	end);
	local GnTooltip = KEY_BUTTON1.."-|cff00FFFF打开"..GnName.."|r\n"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."|r"
	QuickButUI.ButList[8]=function()
		if PIGA["QuickBut"]["Open"] and PIGA["StatsInfo"]["Open"] and PIGA["StatsInfo"]["AddBut"] then
			local QkButUI = "QkBut_Skill"
			if _G[QkButUI] then return end	
			local QkBut=PIGQuickBut(QkButUI,GnTooltip,GnIcon,GnUI,FrameLevel)
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
	---
	fuFrame.StatsInfo.CZ = PIGButton(fuFrame,{"LEFT",fuFrame.StatsInfo.QKBut,"RIGHT",260,0},{60,22},"重置");  
	fuFrame.StatsInfo.CZ:SetScript("OnClick", function ()
		StaticPopup_Show ("INFO_CZQIANGKONGINFO");
	end);
	PIGEnter(fuFrame.StatsInfo.CZ,"|cffFF0000重置|r"..GnName.."所有配置")
	StaticPopupDialogs["INFO_CZQIANGKONGINFO"] = {
		text = "此操作将\124cffff0000重置\124r"..GnName.."所有配置，需重载界面。\n确定重置?",
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			PIGA["StatsInfo"]=addonTable.Default["StatsInfo"];
			PIGA["StatsInfo"]["Open"] = true;
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	--鼠标提示其他角色数量
	local Tooltip = {"鼠标提示其他角色数量","在物品的鼠标提示显示其他角色数量\n注意:为了节省性能开销，战斗中无效"}
	fuFrame.Qita_Num = PIGCheckbutton(fuFrame,{"TOPLEFT",fuFrame.StatsInfo,"BOTTOMLEFT",0,-20},Tooltip)
	fuFrame.Qita_Num:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["StatsInfo"]["Qita_Num"]=true;
		else
			PIGA["StatsInfo"]["Qita_Num"]=false;
		end
	end);
	local greenTexture = "interface/common/indicator-green.blp"
	if tocversion<100000 then
		local CreateIcons = "Interface/Glues/CharacterCreate/CharacterCreateIcons"
		local Texwidth,Texheight = 500,500
		GameTooltip:HookScript("OnTooltipSetItem", function(self)
			if InCombatLockdown() then return end
			if not PIGA["StatsInfo"]["Open"] or not PIGA["StatsInfo"]["Qita_Num"] then return end
			local _, link = self:GetItem()
			if link then
				local itemID = GetItemInfoInstant(link)
				if itemID==6948 then return end
				local qitaDataNum={}
				local itemjihe = PIGA["StatsInfo"]["Items"]
				qitaDataNum.itemziji={}
				local itemzijibag = itemjihe[Pig_OptionsUI.AllName]["BAG"]
				for it=1,#itemzijibag do
					if itemID==itemzijibag[it][3] then
						if qitaDataNum.itemziji[BAGSLOT] then
							qitaDataNum.itemziji[BAGSLOT]=qitaDataNum.itemziji[BAGSLOT]+itemzijibag[it][2]
						else
							qitaDataNum.itemziji[BAGSLOT]=itemzijibag[it][2]
						end
					end
				end
				local itemzijibank = itemjihe[Pig_OptionsUI.AllName]["BANK"]
				for it=1,#itemzijibank do
					if itemID==itemzijibank[it][3] then
						if qitaDataNum.itemziji[BANK] then
							qitaDataNum.itemziji[BANK]=qitaDataNum.itemziji[BANK]+itemzijibank[it][2]
						else
							qitaDataNum.itemziji[BANK]=itemzijibank[it][2]
						end
					end
				end
				local itemzijimail = itemjihe[Pig_OptionsUI.AllName]["MAIL"]
				for it=1,#itemzijimail do
					if itemID==itemzijimail[it][3] then
						if qitaDataNum.itemziji[MINIMAP_TRACKING_MAILBOX] then
							qitaDataNum.itemziji[MINIMAP_TRACKING_MAILBOX]=qitaDataNum.itemziji[MINIMAP_TRACKING_MAILBOX]+itemzijimail[it][2]
						else
							qitaDataNum.itemziji[MINIMAP_TRACKING_MAILBOX]=itemzijimail[it][2]
						end
					end
				end
				local hejishuliang = 0
				local tishneirzj = ""
				for k,v in pairs(qitaDataNum.itemziji) do
					if v>0 then
						hejishuliang=hejishuliang+v
						if tishneirzj=="" then
							tishneirzj=tishneirzj..k.."|cffFFFFFF"..v.."|r"
						else
							tishneirzj=tishneirzj.." "..k.."|cffFFFFFF"..v.."|r"
						end
					end	
				end
				if IsInGuild() then
					local itemzijiGuild = itemjihe[Pig_OptionsUI.AllName]["GUILD"]
					for it=1,#itemzijiGuild do
						if itemID==itemzijiGuild[it][3] then
							if qitaDataNum.itemziji[GUILD] then
								qitaDataNum.itemziji[GUILD]=qitaDataNum.itemziji[GUILD]+itemzijiGuild[it][2]
							else
								qitaDataNum.itemziji[GUILD]=itemzijiGuild[it][2]
							end
						end
					end
				else
					itemjihe[Pig_OptionsUI.AllName]["GUILD"]={}
				end
				local hejishuliang = 0
				local tishneirzj = ""
				for k,v in pairs(qitaDataNum.itemziji) do
					if v>0 then
						hejishuliang=hejishuliang+v
						if tishneirzj=="" then
							tishneirzj=tishneirzj..k.."|cffFFFFFF"..v.."|r"
						else
							tishneirzj=tishneirzj.." "..k.."|cffFFFFFF"..v.."|r"
						end
					end	
				end
				if tishneirzj~="" then
					local pxinxiinfo = PIGA["StatsInfo"]["Players"][Pig_OptionsUI.AllName]
					local _, classFile = PIGGetClassInfo(pxinxiinfo[4])
					local color = PIG_CLASS_COLORS[classFile];
					local Texinfo = C_Texture.GetAtlasInfo(pxinxiinfo[3])
					--local width,height = Texinfo.width,Texinfo.height
					local left=Texinfo.leftTexCoord*Texwidth+0.308
					local right=Texinfo.rightTexCoord*Texwidth+0.5
					local top=Texinfo.topTexCoord*Texheight+0.2
					local bottom=Texinfo.bottomTexCoord*Texheight+0.1
					local ttgghh = "|T"..CreateIcons..":14:14:0:0:"..Texwidth..":"..Texheight..":"..left..":"..right..":"..top..":"..bottom.."|t"
					local ttgghh=ttgghh.." |c"..color.colorStr..Pig_OptionsUI.Name.."|r|T"..greenTexture..":14:14:0:0:16:16:0:14:0:14|t"
					self:AddLine(" ")
					self:AddDoubleLine(ttgghh,tishneirzj)
				end
				---
				qitaDataNum.itemqita={}
				for k,v in pairs(itemjihe) do
					if k~=Pig_OptionsUI.AllName then
						local qitabag = itemjihe[k]["BAG"]
						for it=1,#qitabag do
							if itemID==qitabag[it][3] then
								if qitaDataNum.itemqita[k] then
									qitaDataNum.itemqita[k][2]=qitaDataNum.itemqita[k][2]+qitabag[it][2]
								else
									qitaDataNum.itemqita[k]={BAGSLOT,qitabag[it][2]}
								end
							end
						end
						local qitabank = itemjihe[k]["BANK"]
						for it=1,#qitabank do
							if itemID==qitabank[it][3] then
								if qitaDataNum.itemqita[k] then
									if qitaDataNum.itemqita[k][3] then
										qitaDataNum.itemqita[k][4]=qitaDataNum.itemqita[k][4]+qitabank[it][2]
									else
										qitaDataNum.itemqita[k][3]=BANK
										qitaDataNum.itemqita[k][4]=qitabank[it][2]
									end
								else
									qitaDataNum.itemqita[k]={BANK,qitabank[it][2]}
								end
							end
						end
						local qitamail = itemjihe[k]["MAIL"] or {}
						for it=1,#qitamail do
							if itemID==qitamail[it][3] then
								if qitaDataNum.itemqita[k] then
									if qitaDataNum.itemqita[k][3] then
										qitaDataNum.itemqita[k][4]=qitaDataNum.itemqita[k][4]+qitamail[it][2]
									else
										qitaDataNum.itemqita[k][3]=MINIMAP_TRACKING_MAILBOX
										qitaDataNum.itemqita[k][4]=qitamail[it][2]
									end
								else
									qitaDataNum.itemqita[k]={MINIMAP_TRACKING_MAILBOX,qitamail[it][2]}
								end
							end
						end
					end
				end
				for k,v in pairs(qitaDataNum.itemqita) do
					local danjueseshuliang=0
					local tishneir = ""
					if v[2]>0 then
						danjueseshuliang=danjueseshuliang+v[2]
						tishneir=v[1].."|cffFFFFFF"..v[2].."|r"
					end
					if v[4] and v[4]>0 then
						danjueseshuliang=danjueseshuliang+v[4]
						tishneir=tishneir.." "..v[3].."|cffFFFFFF"..v[4].."|r"
					end
					local pxinxiinfo = PIGA["StatsInfo"]["Players"][k]
					local _, classFile = PIGGetClassInfo(pxinxiinfo[4])
					local color = PIG_CLASS_COLORS[classFile];
					local Texinfo = C_Texture.GetAtlasInfo(pxinxiinfo[3])
					if classFile and color.colorStr and Texinfo then
						--local width,height = Texinfo.width,Texinfo.height
						local left=Texinfo.leftTexCoord*Texwidth+0.308
						local right=Texinfo.rightTexCoord*Texwidth+0.5
						local top=Texinfo.topTexCoord*Texheight+0.2
						local bottom=Texinfo.bottomTexCoord*Texheight+0.1
						local ttgghh = "|T"..CreateIcons..":14:14:0:0:"..Texwidth..":"..Texheight..":"..left..":"..right..":"..top..":"..bottom.."|t"
						local ttgghh=ttgghh.." |c"..color.colorStr..k.."|r"
						self:AddDoubleLine(ttgghh,tishneir)
						hejishuliang=hejishuliang+danjueseshuliang
					end
				end
				if hejishuliang>0 then
					self:AddDoubleLine("合计","|cffFFFFFF"..hejishuliang.."|r")
				end
			end
		end)
	else
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
			if InCombatLockdown() then return end
			if not PIGA["StatsInfo"]["Open"] or not PIGA["StatsInfo"]["Qita_Num"] then return end
			if tooltip == GameTooltip then
				local itemID = data["id"]
				if itemID then	
					if itemID==6948 then return end
					local qitaDataNum={}
					local itemjihe = PIGA["StatsInfo"]["Items"]
					qitaDataNum.itemziji={}
					local itemzijibag = itemjihe[Pig_OptionsUI.AllName]["BAG"]
					for it=1,#itemzijibag do
						if itemID==itemzijibag[it][3] then
							if qitaDataNum.itemziji[BAGSLOT] then
								qitaDataNum.itemziji[BAGSLOT]=qitaDataNum.itemziji[BAGSLOT]+itemzijibag[it][2]
							else
								qitaDataNum.itemziji[BAGSLOT]=itemzijibag[it][2]
							end
						end
					end
					local itemzijibank = itemjihe[Pig_OptionsUI.AllName]["BANK"]
					for it=1,#itemzijibank do
						if itemID==itemzijibank[it][3] then
							if qitaDataNum.itemziji[BANK] then
								qitaDataNum.itemziji[BANK]=qitaDataNum.itemziji[BANK]+itemzijibank[it][2]
							else
								qitaDataNum.itemziji[BANK]=itemzijibank[it][2]
							end
						end
					end
					local itemzijimail = itemjihe[Pig_OptionsUI.AllName]["MAIL"]
					for it=1,#itemzijimail do
						if itemID==itemzijimail[it][3] then
							if qitaDataNum.itemziji[MINIMAP_TRACKING_MAILBOX] then
								qitaDataNum.itemziji[MINIMAP_TRACKING_MAILBOX]=qitaDataNum.itemziji[MINIMAP_TRACKING_MAILBOX]+itemzijimail[it][2]
							else
								qitaDataNum.itemziji[MINIMAP_TRACKING_MAILBOX]=itemzijimail[it][2]
							end
						end
					end
					local tishneirzj = ""
					for k,v in pairs(qitaDataNum.itemziji) do
						if v>0 then
							tishneirzj=tishneirzj..k..":|cffFFFFFF"..v.."|r"
						end	
					end
					if tishneirzj~="" then
						local pxinxiinfo = PIGA["StatsInfo"]["Players"][Pig_OptionsUI.AllName]
						local _, classFile = PIGGetClassInfo(pxinxiinfo[4])
						local color = PIG_CLASS_COLORS[classFile];
						tooltip:AddDoubleLine("|c"..color.colorStr..Pig_OptionsUI.Name.."|r|T"..greenTexture..":14:14:0:0:16:16:0:14:0:14|t",tishneirzj)
						tooltip:AddTexture(pxinxiinfo[3], {width = 16, height = 16,verticalOffset=0.8,margin = { left = 0, right = 2, top = 0, bottom = 0 }})
					end
					---
					qitaDataNum.itemqita={}
					for k,v in pairs(itemjihe) do
						if k~=Pig_OptionsUI.AllName then
							local qitabag = itemjihe[k]["BAG"]
							for it=1,#qitabag do
								if itemID==qitabag[it][3] then
									if qitaDataNum.itemqita[k] then
										qitaDataNum.itemqita[k][2]=qitaDataNum.itemqita[k][2]+qitabag[it][2]
									else
										qitaDataNum.itemqita[k]={BAGSLOT,qitabag[it][2]}
									end
								end
							end
							local qitabank = itemjihe[k]["BANK"]
							for it=1,#qitabank do
								if itemID==qitabank[it][3] then
									if qitaDataNum.itemqita[k] then
										if qitaDataNum.itemqita[k][3] then
											qitaDataNum.itemqita[k][4]=qitaDataNum.itemqita[k][4]+qitabank[it][2]
										else
											qitaDataNum.itemqita[k][3]=BANK
											qitaDataNum.itemqita[k][4]=qitabank[it][2]
										end
									else
										qitaDataNum.itemqita[k]={BANK,qitabank[it][2]}
									end
								end
							end
							local qitamail = itemjihe[k]["MAIL"] or {}
							for it=1,#qitamail do
								if itemID==qitamail[it][3] then
									if qitaDataNum.itemqita[k] then
										if qitaDataNum.itemqita[k][3] then
											qitaDataNum.itemqita[k][4]=qitaDataNum.itemqita[k][4]+qitamail[it][2]
										else
											qitaDataNum.itemqita[k][3]=MINIMAP_TRACKING_MAILBOX
											qitaDataNum.itemqita[k][4]=qitamail[it][2]
										end
									else
										qitaDataNum.itemqita[k]={MINIMAP_TRACKING_MAILBOX,qitamail[it][2]}
									end
								end
							end
						end
					end
					for k,v in pairs(qitaDataNum.itemqita) do
						local tishneir = ""
						if v[2]>0 then
							tishneir=v[1]..":|cffFFFFFF"..v[2].."|r"
						end
						if v[4] and v[4]>0 then
							tishneir=tishneir..v[3]..":|cffFFFFFF"..v[4].."|r"
						end
						local pxinxiinfo = PIGA["StatsInfo"]["Players"][k]
						local _, classFile = PIGGetClassInfo(pxinxiinfo[4])
						local color = PIG_CLASS_COLORS[classFile];
						tooltip:AddDoubleLine("|c"..color.colorStr..k.."|r",tishneir)
						tooltip:AddTexture(pxinxiinfo[3], {width = 16, height = 16,verticalOffset=0.8,margin = { left = 0, right = 2, top = 0, bottom = 0 }})
					end
				end
			end
		end)
	end
	local Tooltip = {"背包增加离线银行按钮","在背包增加一个离线银行按钮，也可以查看其他角色物品数量"}
	fuFrame.lixianBank = PIGCheckbutton(fuFrame,{"LEFT",fuFrame.Qita_Num,"RIGHT",220,0},Tooltip)
	fuFrame.lixianBank:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["StatsInfo"]["lixianBank"]=true;
			fuFrame.ADD_lixianBUT()
		else
			PIGA["StatsInfo"]["lixianBank"]=false;
			Pig_Options_RLtishi_UI:Show()
		end
	end);
	local wwc,hhc = 24,24
	local function add_lixianBut(bagfuji,wwc,hhc)
		if not bagfuji or bagfuji.lixianBut then return end
		bagfuji.lixianBut = CreateFrame("Button",nil,bagfuji, "TruncatedButtonTemplate"); 
		bagfuji.lixianBut:SetNormalTexture(136453); 
		bagfuji.lixianBut:SetHighlightTexture(130718);
		bagfuji.lixianBut:SetSize(wwc-4,hhc-4);
		if bagfuji==ContainerFrameCombinedBags then
			bagfuji.lixianBut:SetPoint("TOPLEFT",bagfuji,"TOPLEFT",210,-38)
		elseif bagfuji==BAGheji_UI then
			if NDui or ElvUI then
				bagfuji.lixianBut:SetPoint("TOPLEFT",bagfuji,"TOPLEFT",210,-31)
			else
				bagfuji.lixianBut:SetPoint("TOPLEFT",bagfuji,"TOPLEFT",210,-39)
			end
		elseif bagfuji==ElvUI_ContainerFrame then
			bagfuji.lixianBut:SetPoint("TOPLEFT",bagfuji,"TOPLEFT",11,-6)
		else
			bagfuji.lixianBut:SetPoint("TOPLEFT",bagfuji,"TOPLEFT",160,-6)
		end
		bagfuji.lixianBut.Down = bagfuji.lixianBut:CreateTexture(nil, "OVERLAY");
		bagfuji.lixianBut.Down:SetTexture(130839);
		bagfuji.lixianBut.Down:SetAllPoints(bagfuji.lixianBut)
		bagfuji.lixianBut.Down:Hide();
		bagfuji.lixianBut:SetScript("OnMouseDown", function (self)
			self.Down:Show();
		end);
		bagfuji.lixianBut:SetScript("OnMouseUp", function (self)
			self.Down:Hide();
		end);
		PIGEnter(bagfuji.lixianBut,"查看离线银行或其他角色物品")
		bagfuji.lixianBut:SetScript("OnClick",  function (self,button)
			PlaySoundFile(567463, "Master")
			StatsInfo_UI:BagLixian()
		end)
	end
	function fuFrame.ADD_lixianBUT()
		if not PIGA["StatsInfo"]["Open"] or not PIGA["StatsInfo"]["lixianBank"] then return end
		if Pig_OptionsUI.IsOpen_ElvUI() and ElvUI_ContainerFrame then
			add_lixianBut(ElvUI_ContainerFrame,wwc,hhc)
			return
		end
		if Pig_OptionsUI.IsOpen_NDui("Bags") then
			local B, C = unpack(NDui)
			local anniushuS = NDui_BackpackBag.widgetButtons
			local function CreatelixianBut(self)
				local bu = B.CreateButton(self, 22, 22, true, 136453)
				bu:SetPoint("RIGHT", anniushuS[#anniushuS], "LEFT", -3, 0)
				bu:SetScript("OnClick", function()
					PlaySoundFile(567463, "Master")
					StatsInfo_UI:BagLixian()
				end)
				bu.title =  "查看离线银行或其他角色物品"
				B.AddTooltip(bu, "ANCHOR_TOP")
				self.lixianBut = bu
				if C.db["Bags"]["HideWidgets"] then bu:Hide() end
				return bu
			end
			anniushuS[#anniushuS+1] = CreatelixianBut(NDui_BackpackBag)
			local function ToggleWidgetButtons(self)
				if C.db["Bags"]["HideWidgets"] then
					self:SetPoint("RIGHT", anniushuS[2], "LEFT", -1, 0)
					B.SetupArrow(self.__texture, "left")
					self.tag:Show()
				else
					self:SetPoint("RIGHT", anniushuS[#anniushuS], "LEFT", -1, 0)
					B.SetupArrow(self.__texture, "right")
					self.tag:Hide()
				end
				self:SetFrameLevel(self:GetFrameLevel()+2)
			end
			ToggleWidgetButtons(NDui_BackpackBag.widgetArrow)
		end
		if ContainerFrameCombinedBags then
			if ContainerFrameCombinedBags then add_lixianBut(ContainerFrameCombinedBags,wwc,hhc) end
		else
			if BAGheji_UI then add_lixianBut(BAGheji_UI,wwc,hhc) end
		end
	end	
	local BAGhejiElvUINDui = CreateFrame("Frame")
	BAGhejiElvUINDui:RegisterEvent("PLAYER_ENTERING_WORLD");
	BAGhejiElvUINDui:HookScript("OnEvent", function(self,event,arg1,arg2)
		if event=="PLAYER_ENTERING_WORLD" then
			if arg1 or arg2 then
				fuFrame.ADD_lixianBUT()
			end
		end
	end)
	---交易
	local Tooltip = {"交易通告","通告交易记录(不通告与好友的交易)"};
	fuFrame.TradeTongGao = PIGCheckbutton(fuFrame,{"TOPLEFT",fuFrame.Qita_Num,"BOTTOMLEFT",0,-20},Tooltip)
	fuFrame.TradeTongGao:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["StatsInfo"]["TradeTongGao"]=true;
		else
			PIGA["StatsInfo"]["TradeTongGao"]=false;
		end
	end);
	local pindaoName = {
		["WHISPER"]="|cffFF80FF"..WHISPER.."|r",
		["PARTY_RAID_INSTANCE_CHAT"]="|cffAAAAFF"..PARTY.."|r/|cffFF7F00"..RAID.."|r/|cffFF7F00"..INSTANCE_CHAT.."|r"};
	local pindaoID = {"WHISPER","PARTY_RAID_INSTANCE_CHAT"};
	fuFrame.TradeTongGao.guangbo_dow=PIGDownMenu(fuFrame.TradeTongGao,{"LEFT",fuFrame.TradeTongGao.Text,"RIGHT", 2,-1},{140})
	function fuFrame.TradeTongGao.guangbo_dow:PIGDownMenu_Update_But()
		local info = {}
		info.func = self.PIGDownMenu_SetValue
		for i=1,#pindaoID,1 do
			info.notCheckable=true
		    info.text, info.arg1, info.arg2 = pindaoName[pindaoID[i]], pindaoID[i], pindaoID[i]
			self:PIGDownMenu_AddButton(info)
		end 
	end
	function fuFrame.TradeTongGao.guangbo_dow:PIGDownMenu_SetValue(value,arg1,arg2)
		self:PIGDownMenu_SetText(value)
		PIGA["StatsInfo"]["TradeTongGaoChannel"]=arg1
		PIGCloseDropDownMenus()
	end
	fuFrame.TradeTongGao.guangbo_dow:PIGDownMenu_SetText(pindaoName[PIGA["StatsInfo"]["TradeTongGaoChannel"]])
	---
	fuFrame.TradeClassLV = PIGCheckbutton(fuFrame,{"LEFT",fuFrame.TradeTongGao,"RIGHT",220,0},{"交易界面显示职业等级","在交易界面显示对方职业和等级"})
	fuFrame.TradeClassLV:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["StatsInfo"]["TradeClassLV"]=true
			BusinessInfo.StatsInfo_TradeClassLV()
		else
			PIGA["StatsInfo"]["TradeClassLV"]=false
			Pig_Options_RLtishi_UI:Show();
		end
	end);
	function BusinessInfo.StatsInfo_TradeClassLV()
		if not PIGA["StatsInfo"]["TradeClassLV"] then return end
		if TradeFrame.zhiye then return end
		local www,hhh=28,28
		TradeFrame.zhiye = CreateFrame("Button", nil, TradeFrame);
		TradeFrame.zhiye:SetSize(www,hhh);
		TradeFrame.zhiye:SetPoint("TOP", TradeFrame, "TOP", 6, 18);
		TradeFrame.zhiye.Border = TradeFrame.zhiye:CreateTexture(nil, "BORDER");
		if tocversion>90000 then TradeFrame.zhiye:SetFrameLevel(555) end
		TradeFrame.zhiye.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
		TradeFrame.zhiye.Border:SetSize(www+24,hhh+24);
		TradeFrame.zhiye.Border:ClearAllPoints();
		TradeFrame.zhiye.Border:SetPoint("CENTER", 10, -12);
		TradeFrame.zhiye.Icon = TradeFrame.zhiye:CreateTexture(nil, "ARTWORK");
		TradeFrame.zhiye.Icon:SetSize(www-9,hhh-9);
		TradeFrame.zhiye.Icon:ClearAllPoints();
		TradeFrame.zhiye.Icon:SetPoint("CENTER");
		TradeFrame.zhiye.Icon:SetTexture("Interface/TargetingFrame/UI-Classes-Circles");
		TradeFrame.dengji = CreateFrame("Button", nil, TradeFrame);
		TradeFrame.dengji:SetSize(www+2,hhh);
		TradeFrame.dengji:SetPoint("TOP", TradeFrame, "TOP", 48, -34);
		if tocversion>90000 then TradeFrame.dengji:SetFrameLevel(555) end
		TradeFrame.dengji.Border = TradeFrame.dengji:CreateTexture(nil, "ARTWORK");
		TradeFrame.dengji.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");
		TradeFrame.dengji.Border:SetSize(www+28,hhh+24);
		TradeFrame.dengji.Border:ClearAllPoints();
		if tocversion<90000 then
			TradeFrame.dengji.Border:SetPoint("CENTER", 11, -12);
		else
			TradeFrame.dengji.Border:SetPoint("CENTER", 10, -12);
		end
		TradeFrame.dengji.Text = PIGFontString(TradeFrame.dengji,{"CENTER", TradeFrame.dengji, "CENTER", 0, 0})
		hooksecurefunc("TradeFrame_OnShow", function(self)
			if(UnitExists("NPC"))then
				local IconCoord = CLASS_ICON_TCOORDS[select(2,UnitClass("NPC"))];
				TradeFrame.zhiye.Icon:SetTexCoord(unpack(IconCoord));--切出子区域
				local jibie = UnitLevel("NPC")
				TradeFrame.dengji.Text:SetText(jibie)
				if jibie<10 then
					TradeFrame.dengji.Text:SetTextColor(1, 0, 0);
				else
					TradeFrame.dengji.Text:SetTextColor(1, 0.82, 0);
				end
			end 
		end);
	end
	------
	function fuFrame.CheckbutShow()
		fuFrame.TradeTongGao.guangbo_dow:SetEnabled(PIGA["StatsInfo"]["Open"])
		if PIGA["StatsInfo"]["Open"] then
			fuFrame.StatsInfo.QKBut:Enable()
			fuFrame.Qita_Num:Enable()
			fuFrame.lixianBank:Enable()
			fuFrame.TradeTongGao:Enable()
			fuFrame.TradeClassLV:Enable()

		else
			fuFrame.StatsInfo.QKBut:Disable();
			fuFrame.Qita_Num:Disable()
			fuFrame.lixianBank:Disable()
			fuFrame.TradeTongGao:Disable()
			fuFrame.TradeClassLV:Disable()
		end
	end
	--------
	fuFrame:HookScript("OnShow", function (self)
		self.StatsInfo:SetChecked(PIGA["StatsInfo"]["Open"])
		self.StatsInfo.QKBut:SetChecked(PIGA["StatsInfo"]["AddBut"])
		self.Qita_Num:SetChecked(PIGA["StatsInfo"]["Qita_Num"])
		self.lixianBank:SetChecked(PIGA["StatsInfo"]["lixianBank"])
		self.TradeTongGao:SetChecked(PIGA["StatsInfo"]["TradeTongGao"])
		self.TradeClassLV:SetChecked(PIGA["StatsInfo"]["TradeClassLV"])
		fuFrame.CheckbutShow()
	end);
	BusinessInfo.StatsInfo_ADDUI()
	BusinessInfo.StatsInfo_TradeClassLV()
end
