local addonName, addonTable = ...;
-- local fmod=math.fmod
local match = _G.string.match
local Fun=addonTable.Fun
--
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGTabBut=Create.PIGTabBut
local PIGDiyBut=Create.PIGDiyBut
------
local BusinessInfo=addonTable.BusinessInfo
function BusinessInfo.AH(StatsInfo)
	local fujiF,fujiTabBut=PIGOptionsList_R(StatsInfo.F,"拍\n卖",StatsInfo.butW,"Left")
	---
	local hang_Height,hang_NUM  = 23, 16;
	fujiF.ItemSelect=1

	fujiF.L=PIGFrame(fujiF)
	fujiF.L:PIGSetBackdrop(0)
	fujiF.L:SetWidth(540)
	fujiF.L:SetPoint("TOPLEFT",fujiF,"TOPLEFT",0,0);
	fujiF.L:SetPoint("BOTTOMLEFT",fujiF,"BOTTOMLEFT",0,0);
	--
	fujiF.L.NR=PIGFrame(fujiF.L)
	fujiF.L.NR:SetPoint("TOPLEFT",fujiF.L,"TOPLEFT",4,-30);
	fujiF.L.NR:SetPoint("BOTTOMRIGHT",fujiF.L,"BOTTOMRIGHT",-4,4);
	fujiF.L.NR:PIGSetBackdrop(0)
	fujiF.toptabButList={}
	local toptablist = {{"Attention","关注"},{"History","搜索"}}
	for ibut=1,#toptablist do
		local TabBut = PIGTabBut(fujiF.L.NR,nil,{60,22},toptablist[ibut][2])
		fujiF.toptabButList[ibut]=TabBut
		if ibut==1 then
			TabBut:SetPoint("BOTTOMLEFT",fujiF.L.NR,"TOPLEFT",20,0);
		else
			TabBut:SetPoint("LEFT",fujiF.toptabButList[ibut-1],"RIGHT",20,0);
		end
		TabBut:HookScript("OnClick", function(self)
			fujiF.ItemSelect=ibut
			fujiF:Show_Tab()
		end)
	end
	fujiF.L.NR.err = PIGFontString(fujiF.L.NR,{"CENTER", 0,60},"请先缓存拍卖行物品价格","OUTLINE")
	fujiF.L.NR.err:SetTextColor(0, 1, 0, 1);
	fujiF.L.NR.biaoti = PIGFontString(fujiF.L.NR,{"TOPLEFT",fujiF.L.NR,"TOPLEFT",10,-4},"点击关注按钮可取消关注","OUTLINE")
	fujiF.L.NR.biaoti:SetTextColor(0, 1, 0, 1);
	fujiF.L.NR.Search = CreateFrame("EditBox", nil, fujiF.L.NR, "SearchBoxTemplate");
	fujiF.L.NR.Search:SetSize(260,24);
	fujiF.L.NR.Search:SetPoint("LEFT",fujiF.L.NR.biaoti, "RIGHT",8,0);
	fujiF.L.NR.Search:Hide()
	fujiF.L.NR.Search:SetScript("OnTextChanged", function(self)
		SearchBoxTemplate_OnTextChanged(self);
		fujiF.SearchName=self:GetText()
		fujiF.Update_List();
	end)
	fujiF.L.NR.Search:SetScript("OnEnterPressed", function(self) 
		SearchBoxTemplate_OnTextChanged(self);
		fujiF.SearchName=self:GetText()
		fujiF.Update_List();
	end)
	function fujiF:Show_Tab()
		for ibut=1,#toptablist do
			self.toptabButList[ibut]:NotSelected()
		end
		self.toptabButList[self.ItemSelect]:Selected()
		if self.ItemSelect==1 then
			self.L.NR.biaoti:SetText("点击关注按钮可取消关注")
			self.L.NR.Search:Hide()
		elseif self.ItemSelect==2 then
			self.L.NR.biaoti:SetText("点击关注按钮加入关注")
			self.L.NR.Search:Show()
		end
		self.Update_List();
	end
	function fujiF.SetTipsTxt(uixx,highTex,highSelect)
		uixx:HookScript("OnEnter", function ()
			if not highSelect:IsShown() then
				highTex:Show();
			end
		end);
		uixx:HookScript("OnLeave", function ()
			highTex:Hide();
		end);
	end
	fujiF.L.NR.BOTTOM=PIGFrame(fujiF.L.NR)
	fujiF.L.NR.BOTTOM:SetPoint("TOPLEFT",fujiF.L.NR,"TOPLEFT",0,-42);
	fujiF.L.NR.BOTTOM:SetPoint("BOTTOMRIGHT",fujiF.L.NR,"BOTTOMRIGHT",0,0);
	fujiF.L.NR.BOTTOM:PIGSetBackdrop(0)
	-----
	local biaotiList = {{"关注",2},{"物品名",54},{"缓存单价",-160},{"缓存时间",-34}}
	for i=1,#biaotiList do
		local biaotiname = PIGFontString(fujiF.L.NR.BOTTOM,nil,biaotiList[i][1],"OUTLINE")
		if i>(#biaotiList-2) then
			biaotiname:SetPoint("BOTTOMRIGHT",fujiF.L.NR.BOTTOM,"TOPRIGHT",biaotiList[i][2],2);
		else
			biaotiname:SetPoint("BOTTOMLEFT", fujiF.L.NR.BOTTOM, "TOPLEFT",biaotiList[i][2], 2);
		end
		biaotiname:SetTextColor(1, 1, 0.8, 0.9); 
	end
	fujiF.L.NR.BOTTOM.Scroll = CreateFrame("ScrollFrame",nil,fujiF.L.NR.BOTTOM, "FauxScrollFrameTemplate");  
	fujiF.L.NR.BOTTOM.Scroll:SetPoint("TOPLEFT",fujiF.L.NR.BOTTOM,"TOPLEFT",0,-2);
	fujiF.L.NR.BOTTOM.Scroll:SetPoint("BOTTOMRIGHT",fujiF.L.NR.BOTTOM,"BOTTOMRIGHT",-19,1);
	fujiF.L.NR.BOTTOM.Scroll.ScrollBar:SetScale(0.8)
	fujiF.L.NR.BOTTOM.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.Update_List)
	end)
	fujiF.L.NR.BOTTOM.ButLsit={}
	for id = 1, hang_NUM, 1 do
		local hang = CreateFrame("Button", nil, fujiF.L.NR.BOTTOM);
		fujiF.L.NR.BOTTOM.ButLsit[id]=hang
		hang:SetSize(fujiF.L.NR.BOTTOM:GetWidth()-4,hang_Height+2);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.L.NR.BOTTOM, "TOPLEFT", 0, 0);
		else
			hang:SetPoint("TOPLEFT",fujiF.L.NR.BOTTOM.ButLsit[id-1], "BOTTOMLEFT", 0, -2);
		end
		hang.highlight = hang:CreateTexture(nil,"HIGHLIGHT");
		hang.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		hang.highlight:SetBlendMode("ADD")
		hang.highlight:SetPoint("TOPLEFT", hang, "TOPLEFT", 1,-1);
		hang.highlight:SetPoint("BOTTOMRIGHT", hang, "BOTTOMRIGHT", -10,1);
		hang.highlight:SetAlpha(0.4);
		hang.highlight:SetDrawLayer("BORDER", -2)
		hang.highlight:Hide()
		hang.highlight1 = hang:CreateTexture();
		hang.highlight1:SetTexture("interface/buttons/ui-listbox-highlight.blp");
		hang.highlight1:SetDrawLayer("BORDER", -1)
		hang.highlight1:SetPoint("TOPLEFT", hang, "TOPLEFT", 1,-1);
		hang.highlight1:SetPoint("BOTTOMRIGHT", hang, "BOTTOMRIGHT", -10,1);
		hang.highlight1:SetAlpha(0.8);
		hang.highlight1:Hide();
		hang.attention = PIGDiyBut(hang,{"LEFT", hang, "LEFT", 0,0},{hang_Height,hang_Height,hang_Height+3,hang_Height+3,604882,nil,0,-2})
		fujiF.SetTipsTxt(hang.attention,hang.highlight,hang.highlight1)
		hang.attention:SetScript("OnClick", function (self)
			local collname = self:GetParent().collname
			if collname then
				if PIGA["StatsInfo"]["AHData"][collname] then
					PIGA["StatsInfo"]["AHData"][collname]=nil
				else
					PIGA["StatsInfo"]["AHData"][collname]=true
				end
			end
			fujiF.Update_List()
		end)
		hang.icon = PIGDiyBut(hang,{"LEFT", hang.attention, "RIGHT", 2, 0},{hang_Height-2,hang_Height-2,hang_Height-2,hang_Height-2})
		hang.icon:SetScript("OnEnter", function (self)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
			GameTooltip:SetHyperlink(self.itemLink);
			GameTooltip:Show();
		end);
		hang.icon:SetScript("OnLeave", function ()
			GameTooltip:ClearLines();
			GameTooltip:Hide() 
		end);
		fujiF.SetTipsTxt(hang.icon,hang.highlight,hang.highlight1)
		hang.name = PIGFontString(hang,{"LEFT", hang.icon, "RIGHT", 2, 0},nil,"OUTLINE")
		hang.itemG = PIGFontString(hang,{"RIGHT", hang, "RIGHT", biaotiList[3][2], 0},nil,"OUTLINE")
		hang.itemG:SetTextColor(0, 1, 1, 1); 
		hang.time = PIGFontString(hang,{"RIGHT", hang, "RIGHT", biaotiList[4][2], 0},nil,"OUTLINE")
		hang.time:SetTextColor(0.8, 0.8, 0.8, 0.9); 
		fujiF.SetTipsTxt(hang,hang.highlight,hang.highlight1)
		hang:SetScript("OnClick", function (self)
			fujiF.SelectHang(self)
		end)
		function hang:ShowInfoFun(itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture)
			self.icon.itemLink=itemLink
			self.icon.icon:SetTexture(itemTexture)
			self.name:SetText(itemLink)
		end
	end
	fujiF:HookScript("OnShow", function(self)
		self:Show_Tab()
	end)
	function fujiF.SelectHang(hangfuji)
		PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
		for v=1,hang_NUM do
			local fujix = fujiF.L.NR.BOTTOM.ButLsit[v]
			fujix.highlight1:Hide();
		end
		hangfuji.highlight1:Show();
		fujiF.R.SelectItem=hangfuji.collname
		fujiF.R.itemicon:SetTexture(hangfuji.icon.icon:GetTexture())
		fujiF.R.itemName:SetText(hangfuji.icon.itemLink)
		fujiF.Update_Trend()
	end
	function fujiF.Update_List()
		if not fujiF.L.NR:IsVisible() then return end
		fujiF.L.NR.err:Show()
		for id = 1, hang_NUM, 1 do
			local hang = fujiF.L.NR.BOTTOM.ButLsit[id]
			hang:Hide();
			hang.highlight1:Hide();
		end
		fujiF.DQShowData = {{},{},{}}
		fujiF.DQShowData[1]= BusinessInfo.GetCacheDataG()
		fujiF.DQShowData[2]= PIGA["StatsInfo"]["AHData"]
		if next(fujiF.DQShowData[1]) == nil then return end
		fujiF.L.NR.err:Hide()
		for k,v in pairs(fujiF.DQShowData[1]) do
			fujiF.Isadddata=false
			if fujiF.ItemSelect==1 then
				if fujiF.DQShowData[2][k] then
					fujiF.Isadddata=true
				end
			elseif fujiF.ItemSelect==2 then
				if fujiF.SearchName and fujiF.SearchName~="" and fujiF.SearchName~=" " then
					--local msglenS = #fujiF.SearchName
					--if msglenS>3 then--输入字符数大于
					if k:match(fujiF.SearchName) then
						fujiF.Isadddata=true
					end
				end
			end
			if fujiF.Isadddata then
				local MaxNum = #v[2]
				table.insert(fujiF.DQShowData[3],{k,v[3],v[1],v[2][MaxNum][1],v[2][MaxNum][2]})
			end
		end
		local ItemsNum = #fujiF.DQShowData[3];
		local ScrollUI=fujiF.L.NR.BOTTOM.Scroll
	    FauxScrollFrame_Update(ScrollUI, ItemsNum, hang_NUM, hang_Height);
	    local offset = FauxScrollFrame_GetOffset(ScrollUI);
	    for id = 1, hang_NUM do
			local dangqian = id+offset;
			if fujiF.DQShowData[3][dangqian] then
				local hang = fujiF.L.NR.BOTTOM.ButLsit[id]
				hang:Show();
				hang.collname=fujiF.DQShowData[3][dangqian][1]
				hang.itemG:SetText(GetMoneyString(fujiF.DQShowData[3][dangqian][4]))
				local jiluTime = date("%m-%d %H:%M",fujiF.DQShowData[3][dangqian][5])
				hang.time:SetText(jiluTime)
				if fujiF.DQShowData[2][fujiF.DQShowData[3][dangqian][1]] then
					hang.attention.icon:SetDesaturated(false)
				else
					hang.attention.icon:SetDesaturated(true)
				end
				hang.itemID=fujiF.DQShowData[3][dangqian][2]
				Fun.HY_ShowItemLink(hang,fujiF.DQShowData[3][dangqian][2],fujiF.DQShowData[3][dangqian][3])
				
			end
		end
	end
	--
	local hang_NUMLS=8
	fujiF.R=PIGFrame(fujiF)
	fujiF.R:PIGSetBackdrop(0)
	fujiF.R:SetPoint("TOPLEFT",fujiF.L,"TOPRIGHT",-1,0);
	fujiF.R:SetPoint("BOTTOMRIGHT",fujiF,"BOTTOMRIGHT",0,0);
	fujiF.R.itemicon = fujiF.R:CreateTexture();
	fujiF.R.itemicon:SetPoint("TOPLEFT",fujiF.R,"TOPLEFT",6,-2);
	fujiF.R.itemicon:SetSize(hang_Height-4,hang_Height-4);
	fujiF.R.itemName = PIGFontString(fujiF.R,{"LEFT",fujiF.R.itemicon,"RIGHT",0,0})
	fujiF.R.itemNamels = PIGFontString(fujiF.R,{"LEFT",fujiF.R.itemName,"RIGHT",10,0},"历史价格")
	fujiF.R.TOP=PIGFrame(fujiF.R)
	fujiF.R.TOP:PIGSetBackdrop(0)
	fujiF.R.TOP:SetPoint("TOPLEFT",fujiF.R,"TOPLEFT",0,-40);
	fujiF.R.TOP:SetPoint("TOPRIGHT",fujiF.R,"TOPRIGHT",0,0);
	fujiF.R.TOP:SetHeight((hang_Height+2)*hang_NUMLS)
	local biaotiListLS = {{"缓存单价",-170},{"缓存时间",-36}}
	for i=1,#biaotiListLS do
		local biaotiname = PIGFontString(fujiF.R.TOP,nil,biaotiListLS[i][1],"OUTLINE")
		biaotiname:SetPoint("BOTTOMRIGHT", fujiF.R.TOP, "TOPRIGHT",biaotiListLS[i][2]-4, 1);
		biaotiname:SetTextColor(1, 1, 0.8, 0.9); 
	end
	fujiF.R.TOP.Scroll = CreateFrame("ScrollFrame",nil,fujiF.R.TOP, "FauxScrollFrameTemplate");  
	fujiF.R.TOP.Scroll:SetPoint("TOPLEFT",fujiF.R.TOP,"TOPLEFT",2,-2);
	fujiF.R.TOP.Scroll:SetPoint("BOTTOMRIGHT",fujiF.R.TOP,"BOTTOMRIGHT",-19,2);
	fujiF.R.TOP.Scroll.ScrollBar:SetScale(0.8)
	fujiF.R.TOP.Scroll:SetScript("OnVerticalScroll", function(self, offset)
	    FauxScrollFrame_OnVerticalScroll(self, offset, hang_Height, fujiF.Update_Trend)
	end)
	fujiF.R.TOP.ButList={}
	for id = 1, hang_NUMLS, 1 do
		local hang = CreateFrame("Button", nil, fujiF.R.TOP);
		fujiF.R.TOP.ButList[id]=hang
		hang:SetSize(fujiF.R.TOP:GetWidth()-4,hang_Height);
		if id==1 then
			hang:SetPoint("TOPLEFT", fujiF.R.TOP, "TOPLEFT", 0, 0);
		else
			hang:SetPoint("TOPLEFT", fujiF.R.TOP.ButList[id-1], "BOTTOMLEFT", 0, -2);
		end
		hang.highlight = hang:CreateTexture();
		hang.highlight:SetTexture("interface/buttons/ui-listbox-highlight2.blp");
		hang.highlight:SetBlendMode("ADD")
		hang.highlight:SetPoint("TOPLEFT", hang, "TOPLEFT", 0,0);
		hang.highlight:SetPoint("BOTTOMRIGHT", hang, "BOTTOMRIGHT", 0,0);
		hang.highlight:SetAlpha(0.4);
		hang.highlight:SetDrawLayer("BORDER", -2)
		hang.highlight:Hide();
		hang.itemG = PIGFontString(hang,{"RIGHT", hang, "RIGHT", biaotiListLS[1][2], 0},nil,"OUTLINE")
		hang.itemG:SetTextColor(0, 1, 1, 1); 
		hang.time = PIGFontString(hang,{"RIGHT", hang, "RIGHT", biaotiListLS[2][2], 0},nil,"OUTLINE")
		hang.time:SetTextColor(0.8, 0.8, 0.8, 0.9);
	end
	function fujiF.Update_Trend()
		if not fujiF.R.TOP:IsVisible() then return end
		for id = 1, hang_NUMLS, 1 do
			local fujix = fujiF.R.TOP.ButList[id]:Hide()
		end
		local itemData=BusinessInfo.GetCacheDataG(fujiF.R.SelectItem)
		local ItemsNum = #itemData;
		local ScrollUI=fujiF.R.TOP.Scroll
	    FauxScrollFrame_Update(ScrollUI, ItemsNum, hang_NUMLS, hang_Height);
	    local offset = FauxScrollFrame_GetOffset(ScrollUI);
	    for id = 1, hang_NUMLS do
	    	local dangqian = (ItemsNum+1)-id-offset;
			if itemData[dangqian] then
				local fujix = fujiF.R.TOP.ButList[id]
				fujix:Show();
				fujix.itemG:SetText(GetMoneyString(itemData[dangqian][1]))
				local jiluTime = date("%m-%d %H:%M",itemData[dangqian][2])
				fujix.time:SetText(jiluTime)
			end
		end
		fujiF.R.BOTTOM.qushiF.qushitu(itemData)
	end
	--趋势
	fujiF.R.BOTTOM=PIGFrame(fujiF.R)
	fujiF.R.BOTTOM:SetPoint("TOPLEFT",fujiF.R.TOP,"BOTTOMLEFT",0,0);
	fujiF.R.BOTTOM:SetPoint("BOTTOMRIGHT",fujiF.R,"BOTTOMRIGHT",0,0);
	fujiF.R.BOTTOM.qushiF=BusinessInfo.ADD_qushi(fujiF.R.BOTTOM)
end
