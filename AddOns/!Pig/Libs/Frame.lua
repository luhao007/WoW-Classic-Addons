local addonName, addonTable = ...;
local _G = _G
local CreateFrame = CreateFrame
local CreateTexture=CreateTexture
---------------------------
local Fun=addonTable.Fun
local Create = {}
local FontUrl = "Fonts/ARHei.ttf"
Create.FontUrl=FontUrl
function Create.PIGSetFont(fuji,zihao,Miaobian)
	local zihao = zihao or 14
	fuji:SetFont(FontUrl,zihao,Miaobian)
end
function Create.PIGFontString(fuF,Point,Text,Miaobian,Zihao,UIName,Level)
	local Text = Text or ""
	local Font = fuF:CreateFontString(UIName,Level);
	if Point then Font:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]); end	
	Create.PIGSetFont(Font,Zihao,Miaobian)
	Font:SetTextColor(1, 0.843, 0, 1);
	Font:SetText(Text);
	return Font
end
function Create.PIGFontStringBG(fuF,Point,Text,WH,Zihao,UIName)
	local Zihao = Zihao or 14
	local FontF =Create.PIGFrame(fuF,{Point[1],Point[2],Point[3],Point[4],Point[5]},{WH[1],WH[2]})
	FontF:PIGSetBackdrop(0.4,0.2)
	local Font = FontF:CreateFontString(UIName);
	Font:SetPoint("CENTER", FontF, "CENTER", 0,0);
	Font:SetSize(WH[1],WH[2])
	Font:SetFont(FontUrl,Zihao)
	Font:SetTextColor(1, 0.843, 0, 1);
	Font:SetText(Text);
	return Font
end
------
Create.bgFile = "interface/chatframe/chatframebackground.blp"
--Create.edgeFile = "Interface/Buttons/WHITE8X8"
Create.edgeFile = "Interface/AddOns/"..addonName.."/Libs/Pig_Border.blp"
Create.Backdropinfo={bgFile = Create.bgFile,edgeFile = Create.edgeFile, edgeSize = 6,}
Create.BackdropColor={0.08, 0.08, 0.08, 0.5}
Create.BackdropBorderColor={0, 0, 0, 1}
function Create.PIGFrame(Parent,Point,WH,UIName,ESCOFF,Template)
	--if UIName then print(UIName) end
	local Template=Template or "BackdropTemplate"
	local frameX = CreateFrame("Frame", UIName, Parent,Template)
	if WH then
		frameX:SetSize(WH[1],WH[2]);
	end
	if Point then
		frameX:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
	end
	frameX:EnableMouse(true)
	if ESCOFF then
		frameX:Hide()
		tinsert(UISpecialFrames,UIName);
	end
	function frameX:PIGSetBackdrop(BGAlpha,BorderAlpha,Color,BorderColor,Angle)--nil,nil,nil,nil,0
		self.Angle=Angle
		if Angle==0 then
			if ElvUI or NDui then
				self:SetBackdrop(Create.Backdropinfo)
				local BackdropColor=Color or Create.BackdropColor
				local BackdropBorderColor=BorderColor or Create.BackdropBorderColor
				local BGAlpha = BGAlpha or BackdropColor[4]
				self:SetBackdropColor(BackdropColor[1], BackdropColor[2], BackdropColor[3], BGAlpha);
				local BorderAlpha = BorderAlpha or BackdropBorderColor[4]
				self:SetBackdropBorderColor(BackdropBorderColor[1], BackdropBorderColor[2], BackdropBorderColor[3], BorderAlpha);
			else
				self:SetBackdrop( { bgFile = Create.bgFile,
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false, tileSize = 0, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
				self:SetBackdropColor(0, 0, 0, 0.8);
				self:SetBackdropBorderColor(0.6, 0.6, 0.6, 1);
			end
		elseif Angle==1 then
			self:SetBackdrop( { bgFile = Create.bgFile,
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 0, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
			self:SetBackdropColor(0, 0, 0, 0.8);
			self:SetBackdropBorderColor(0.6, 0.6, 0.6, 1);
		else
			self:SetBackdrop(Create.Backdropinfo)
			local BackdropColor=Color or Create.BackdropColor
			local BackdropBorderColor=BorderColor or Create.BackdropBorderColor
			local BGAlpha = BGAlpha or BackdropColor[4]
			self:SetBackdropColor(BackdropColor[1], BackdropColor[2], BackdropColor[3], BGAlpha);
			local BorderAlpha = BorderAlpha or BackdropBorderColor[4]
			self:SetBackdropBorderColor(BackdropBorderColor[1], BackdropBorderColor[2], BackdropBorderColor[3], BorderAlpha);
		end
	end
	function frameX:PIGSetMovable(MovableUI,KeyDown,Per,CombatLock)
		Create.PIGSetMovable(self,MovableUI,KeyDown,Per,CombatLock)
	end
	function frameX:PIGSetMovableNoSave(MovableUI,KeyDown)
		Create.PIGSetMovableNoSave(self,MovableUI,KeyDown)
	end
	function frameX:PIGClose(Ww,Hh,CloseUI)
		local WwHH = {22,22}
		if PIG_MaxTocversion(100000,true) then
			WwHH[1]=21;WwHH[2]=21;
		end
		local Ww = Ww or WwHH[1]
		local Hh = Hh or WwHH[2]
		local CloseUI=CloseUI or self
		if self.Angle==0 then
			if ElvUI or NDui then
				Create.add_CloseUI(false,self,Ww,Hh,CloseUI)
			else
				Create.add_CloseUI(true,self,Ww,Hh,CloseUI)
			end
		elseif self.Angle==1 then
			Create.add_CloseUI(true,self,Ww,Hh,CloseUI)
		else
			Create.add_CloseUI(false,self,Ww,Hh,CloseUI)
		end
	end
	function frameX:SetObject(object,Point)
		local Point=Point or {0,0,0,0}
		local left=Point[1]
	    local right = Point[2]
	    local top = Point[3]
	    local bottom = Point[4]
	    object:SetParent(self)
	    object:ClearAllPoints()
	    object:SetPoint('TOPLEFT', self, 'TOPLEFT', left, top)
	    object:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', right, bottom)
	    object:Show()
	    self.Object = object
	end
	function frameX:PIG_ResPoint(UIname)
		Create.PIG_ResPoint(UIname)
	end
	return frameX
end
function Create.PIGSetMovableNoSave(LeftUI,MovableUI,KeyDown)
	local MovableUI=MovableUI or LeftUI
	MovableUI:SetMovable(true)
	MovableUI:SetUserPlaced(false)
	LeftUI:EnableMouse(true)
	LeftUI:RegisterForDrag("LeftButton")
	LeftUI:SetScript("OnDragStart",function(self)
		if KeyDown and not IsModifiedClick(KeyDown) then return end
		MovableUI:StartMoving()
	end)
	LeftUI:SetScript("OnDragStop",function(self)
		MovableUI:StopMovingOrSizing()
		MovableUI:SetUserPlaced(false)
	end)
	MovableUI:SetClampedToScreen(true)
end
function Create.PIGSetMovable(LeftUI,MovableUI,KeyDown,Per,CombatLock)
	if MovableUI and MovableUI:GetName()=="Pig_FarmUI" and Fun.is_slist() then
		LeftUI:Hide()
		MovableUI:SetPoint("CENTER");
	end
	local MovableUI=MovableUI or LeftUI
	MovableUI:SetMovable(true)
	MovableUI:SetUserPlaced(false)
	LeftUI:EnableMouse(true)
	LeftUI:RegisterForDrag("LeftButton")
	LeftUI:SetScript("OnDragStart",function(self)
		if CombatLock and InCombatLockdown() then PIG_OptionsUI:ErrorMsg(ERR_NOT_IN_COMBAT) return end
		if KeyDown and not IsModifiedClick(KeyDown) then return end
		MovableUI:StartMoving()
	end)
	MovableUI.Per=Per
	LeftUI:SetScript("OnDragStop",function(self)
		if CombatLock and InCombatLockdown() then return end
		MovableUI:StopMovingOrSizing()
		local uiname = MovableUI:GetName()
		if uiname then
			local point, _, relativePoint, offsetX, offsetY = MovableUI:GetPoint()
			local offsetX = floor(offsetX*100+0.5)*0.01
			local offsetY = floor(offsetY*100+0.5)*0.01
			if MovableUI.Per then
				PIGA_Per["Pig_UI"][uiname]={point, relativePoint, offsetX, offsetY}
			else
				PIGA["Pig_UI"][uiname]={point, relativePoint, offsetX, offsetY}
			end
		end
		MovableUI:SetUserPlaced(false)
	end)
	MovableUI:SetClampedToScreen(true)
end
function Create.add_CloseUI(MODE,self,Ww,Hh,CloseUI)
	local Ww = Ww or 22
	local Hh = Hh or 22
	local CloseUI=CloseUI or self
	if MODE then
		self.Close = CreateFrame("Button",nil,self, "UIPanelCloseButton");
		self.Close:SetSize(Ww+6,Hh+6);
		self.Close:SetPoint("TOPRIGHT",self,"TOPRIGHT",0,0);
	else
		self.Close = CreateFrame("Button",nil,self);
		self.Close:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp")
		self.Close:SetSize(Ww,Hh);
		self.Close:SetPoint("TOPRIGHT",self,"TOPRIGHT",0,0);
		self.Close.Tex = self.Close:CreateTexture(nil, "BORDER");
		--self.Close.Tex:SetTexture("interface/common/voicechat-muted.blp");
		self.Close.Tex:SetAtlas("common-icon-redx")
		self.Close.Tex:SetSize(self.Close:GetWidth()-6,self.Close:GetHeight()-6);
		self.Close.Tex:SetPoint("CENTER",0,0);
		self.Close:HookScript("OnMouseDown", function (self)
			self.Tex:SetPoint("CENTER",-1.5,-1.5);
		end);
		self.Close:HookScript("OnMouseUp", function (self)
			self.Tex:SetPoint("CENTER");
		end);
		self.Close:HookScript("OnClick", function (self)
			PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
			CloseUI:Hide()
		end);
	end
end
function Create.PIGLine(Parent,Point,Y,H,LR,Color,UIName)
	local Y = Y or 0
	local H = H or 1
	local LR = LR or {0,0}
	if ElvUI or NDui then
		LR[1] = LR[1]
		LR[2] = LR[2]
	else
		LR[1] = LR[1]+3
		LR[2] = LR[2]-3
	end
	local Color = Color or Create.BackdropBorderColor
	frameX = Parent:CreateLine(UIName)
	frameX:SetColorTexture(Color[1], Color[2], Color[3], Color[4])
	frameX:SetThickness(H);
	-- local frameX = Parent:CreateTexture(UIName, "BORDER");
	-- frameX:SetTexture("Interface/AddOns/"..addonName.."/Libs/line.blp");
	-- frameX:SetColorTexture(Color[1], Color[2], Color[3], Color[4])
	-- frameX:SetHeight(H);
	if Point=="TOP" then
		frameX:SetStartPoint("TOPLEFT",LR[1],Y)
		frameX:SetEndPoint("TOPRIGHT",LR[2],Y)
		-- frameX:SetPoint("TOPLEFT",Parent,"TOPLEFT",LR[1],Y);
		-- frameX:SetPoint("TOPRIGHT",Parent,"TOPRIGHT",LR[2],Y);
	elseif Point=="BOT" then
		frameX:SetStartPoint("BOTTOMLEFT",LR[1],Y)
		frameX:SetEndPoint("BOTTOMRIGHT",LR[2],Y)
		-- frameX:SetPoint("BOTTOMLEFT",Parent,"BOTTOMLEFT",LR[1],Y);
		-- frameX:SetPoint("BOTTOMRIGHT",Parent,"BOTTOMRIGHT",LR[2],Y);
	elseif Point=="L" then
		frameX:SetStartPoint("TOPLEFT",Y,LR[1])
		frameX:SetEndPoint("BOTTOMLEFT",Y,LR[2])
		-- frameX:SetPoint("TOPLEFT",Parent,"TOPLEFT",Y,LR[1]);
		-- frameX:SetPoint("BOTTOMLEFT",Parent,"BOTTOMLEFT",Y,LR[2]);
	elseif Point=="R" then
		frameX:SetStartPoint("TOPRIGHT",Y,LR[1])
		frameX:SetEndPoint("BOTTOMRIGHT",Y,LR[2])
		-- frameX:SetPoint("TOPRIGHT",Parent,"TOPRIGHT",Y,LR[1]);
		-- frameX:SetPoint("BOTTOMRIGHT",Parent,"BOTTOMRIGHT",Y,LR[2]);
	elseif Point=="C" then
		frameX:SetStartPoint("TOP",Y,LR[1])
		frameX:SetEndPoint("BOTTOM",Y,LR[2])
		-- frameX:SetPoint("TOP",Parent,"TOP",Y,LR[1]);
		-- frameX:SetPoint("BOTTOM",Parent,"BOTTOM",Y,LR[2]);
	end
	return frameX
end
function Create.PIGEnter(Parent,text,text1,text2,Xpianyi,Ypianyi,huanhang)
	local Xpianyi,Ypianyi=Xpianyi or 16,Ypianyi or 0
	local huanhangYN = true
	if huanhang=="not" then
		huanhangYN =  false
	end
	Parent:HookScript("OnEnter", function(self)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",Xpianyi,Ypianyi);
		GameTooltip:AddLine(text, nil, nil, nil, huanhangYN)
		if text1 then
			GameTooltip:AddLine(text1, nil, nil, nil, huanhangYN)
		end
		if text2 then
			GameTooltip:AddLine(text2, nil, nil, nil, huanhangYN)
		end
		GameTooltip:Show();
	end);
	Parent:HookScript("OnLeave", function()
		GameTooltip:ClearLines();
		GameTooltip:Hide() 
	end);
end
--设置UI位置
local UILayout = {}
addonTable.Data.UILayout=UILayout
function Create.PIG_ResPoint(UIname)
	PIGA["Pig_UI"][UIname]=nil
	if _G[UIname] then
		local point, relativePoint, offsetX, offsetY, World=unpack(UILayout[UIname])
		_G[UIname]:ClearAllPoints();
		if World then
			_G[MovUIName]:SetPoint(point or "CENTER", WorldFrame, relativePoint or "CENTER", offsetX or 0, offsetY or 0);
		else
			_G[UIname]:SetPoint(point or "CENTER",UIParent,relativePoint or "CENTER", offsetX or 0, offsetY or 0)
		end
	end
end
local function PIG_SetPoint_1(MovUIName,Blizzard,PointX,World)
	local point, relativePoint, offsetX, offsetY=unpack(PointX)
	_G[MovUIName]:ClearAllPoints();
	if World then
		_G[MovUIName]:SetPoint(point or "CENTER", WorldFrame, relativePoint or "CENTER", offsetX or 0, offsetY or 0);
	else
		_G[MovUIName]:SetPoint(point or "CENTER", UIParent, relativePoint or "CENTER", offsetX or 0, offsetY or 0);
	end
	if _G[MovUIName].updatePoint then _G[MovingUIName].updatePoint() end
end
local function FormatXY(offsetX,offsetY)
	return floor(offsetX*100+0.5)*0.01,floor(offsetY*100+0.5)*0.01
end
local function PIG_SetPoint(k,Blizzard)
	if not _G[k] then return end
	if Blizzard then
		local uixy=PIGA["Blizzard_UI"][k]["Point"]
		if uixy and uixy[1] and uixy[2] and uixy[3] and uixy[4] and not uixy[5] then
			uixy[3],uixy[4]=FormatXY(uixy[3],uixy[4])
			PIG_SetPoint_1(k,Blizzard,uixy)
		else
			PIGA["Blizzard_UI"][k]["Point"]=nil
		end
	else
		local World= UILayout[k] and UILayout[k][5]
		PIG_SetPoint_1(k,nil,UILayout[k],World)
		local uixy=PIGA["Pig_UI"][k]
		if uixy and uixy[1] and uixy[2] and uixy[3] and uixy[4] and not uixy[5] then
			uixy[3],uixy[4]=FormatXY(uixy[3],uixy[4])
			PIG_SetPoint_1(k,nil,uixy,World)
		else
			PIGA["Pig_UI"][k]=nil
		end
		local uixy=PIGA_Per["Pig_UI"][k]
		if uixy and uixy[1] and uixy[2] and uixy[3] and uixy[4] and not uixy[5] then
			uixy[3],uixy[4]=FormatXY(uixy[3],uixy[4])
			PIG_SetPoint_1(k,nil,uixy,World)
		else
			PIGA_Per["Pig_UI"][k]=nil
		end
	end
end
Create.PIG_SetPoint=PIG_SetPoint
function Create.PIG_SetPointALL()
	for k,v in pairs(UILayout) do
		if _G[k] then
			PIG_SetPoint(k)
		end
	end
end
---
addonTable.Create=Create