local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create = addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGFontString=Create.PIGFontString
local PIGDiyBut = Create.PIGDiyBut
--
--角色界面
function Create.ADD_BlizzardBG(self,texname,Point)
	local Point = Point or {14,-13,-3,5}
	if NDui then
		self.Bg = self:CreateTexture(texname.."Bg", "BACKGROUND");
		self.Bg:SetTexture("interface/chatframe/chatframebackground.blp");
		self.Bg:SetPoint("TOPLEFT", self, "TOPLEFT",Point[1], Point[2]);
		self.Bg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", Point[3], Point[4]);
		self.Bg:SetDrawLayer("BACKGROUND", -1)
		self.Bg:SetColorTexture(unpack(Create.BackdropColor))
		BankPortraitTexture:Hide()
		BankCloseButton:Hide()
		self.PigClose = PIGDiyBut(self,{"TOPRIGHT", self, "TOPRIGHT",-1,-10},{26})
		self.PigClose:HookScript("OnClick", function ()
			CloseBankFrame();
		end);
	else
		self.Bg = self:CreateTexture(texname.."Bg", "BACKGROUND");
		self.Bg:SetTexture("interface/framegeneral/ui-background-rock.blp");
		self.Bg:SetPoint("TOPLEFT", self, "TOPLEFT",Point[1], Point[2]);
		self.Bg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", Point[3], Point[4]);
		self.Bg:SetDrawLayer("BACKGROUND", -1)

		self.topbg = self:CreateTexture(texname.."topbg", "BACKGROUND");
		self.topbg:SetTexture(374157);
		self.topbg:SetPoint("TOPLEFT", self, "TOPLEFT",68, -13);
		self.topbg:SetPoint("TOPRIGHT", self, "TOPRIGHT",-24, -13);
		self.topbg:SetTexCoord(0,0.2890625,0,0.421875,1.359809994697571,0.2890625,1.359809994697571,0.421875);
		self.topbg:SetHeight(20);
		self.TOPLEFT = self:CreateTexture(texname.."TOPLEFT", "BORDER");
		self.TOPLEFT:SetTexture("interface/framegeneral/ui-frame.blp");
		self.TOPLEFT:SetPoint("TOPLEFT", self, "TOPLEFT",0, 0);
		self.TOPLEFT:SetTexCoord(0.0078125,0.0078125,0.0078125,0.6171875,0.6171875,0.0078125,0.6171875,0.6171875);
		self.TOPLEFT:SetSize(78,78);
		self.TOPRIGHT = self:CreateTexture(texname.."TOPRIGHT", "BORDER");
		self.TOPRIGHT:SetTexture(374156);
		self.TOPRIGHT:SetPoint("TOPRIGHT", self, "TOPRIGHT",0, -10);
		self.TOPRIGHT:SetTexCoord(0.6328125,0.0078125,0.6328125,0.265625,0.890625,0.0078125,0.890625,0.265625);
		self.TOPRIGHT:SetSize(33,33);
		self.TOP = self:CreateTexture(texname.."TOP", "BORDER");
		self.TOP:SetTexture(374157);
		self.TOP:SetPoint("TOPLEFT", self.TOPLEFT, "TOPRIGHT",0, -10);
		self.TOP:SetPoint("BOTTOMRIGHT", self.TOPRIGHT, "BOTTOMLEFT", 0, 5);
		self.TOP:SetTexCoord(0,0.4375,0,0.65625,1.08637285232544,0.4375,1.08637285232544,0.65625);
		self.BOTTOMLEFT = self:CreateTexture(texname.."BOTTOMLEFT", "BORDER");
		self.BOTTOMLEFT:SetTexture(374156);
		self.BOTTOMLEFT:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT",8, 0);
		self.BOTTOMLEFT:SetTexCoord(0.0078125,0.6328125,0.0078125,0.7421875,0.1171875,0.6328125,0.1171875,0.7421875);
		self.BOTTOMLEFT:SetSize(14,14);

		self.BOTTOMRIGHT = self:CreateTexture(texname.."BOTTOMRIGHT", "BORDER");
		self.BOTTOMRIGHT:SetTexture(374156);
		self.BOTTOMRIGHT:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT",0, 0);
		self.BOTTOMRIGHT:SetTexCoord(0.1328125,0.8984375,0.1328125,0.984375,0.21875,0.8984375,0.21875,0.984375);
		self.BOTTOMRIGHT:SetSize(11,11);

		self.LEFT = self:CreateTexture(texname.."LEFT", "BORDER");
		self.LEFT:SetTexture(374153);
		self.LEFT:SetTexCoord(0.359375,0,0.359375,1.42187488079071,0.609375,0,0.609375,1.42187488079071);
		self.LEFT:SetPoint("TOPLEFT", self.TOPLEFT, "BOTTOMLEFT",8, 0);
		self.LEFT:SetPoint("BOTTOMLEFT", self.BOTTOMLEFT, "TOPLEFT", 0, 0);
		self.LEFT:SetWidth(16);

		self.RIGHT = self:CreateTexture(texname.."RIGHT", "BORDER");
		self.RIGHT:SetTexture(374153);
		self.RIGHT:SetTexCoord(0.171875,0,0.171875,1.5703125,0.328125,0,0.328125,1.5703125);
		self.RIGHT:SetPoint("TOPRIGHT", self.TOPRIGHT, "BOTTOMRIGHT",0.8, 0);
		self.RIGHT:SetPoint("BOTTOMRIGHT", self.BOTTOMRIGHT, "TOPRIGHT", 0, 0);
		self.RIGHT:SetWidth(10);

		self.BOTTOM = self:CreateTexture(texname.."BOTTOM", "BORDER");
		self.BOTTOM:SetTexture(374157);
		self.BOTTOM:SetTexCoord(0,0.203125,0,0.2734375,1.425781607627869,0.203125,1.425781607627869,0.2734375);
		self.BOTTOM:SetPoint("BOTTOMLEFT", self.BOTTOMLEFT, "BOTTOMRIGHT",0, -0);
		self.BOTTOM:SetPoint("BOTTOMRIGHT", self.BOTTOMRIGHT, "BOTTOMLEFT", 0, 0);
		self.BOTTOM:SetHeight(9);
	end
end
--背包银行界面
function Create.BagBankBG(self,texname)
	if ElvUI then
	else
		Create.ADD_BlizzardBG(self,texname)		
		self.portrait = self:CreateTexture(nil,"BACKGROUND");
		self.portrait:SetSize(60,60);
		self.portrait:SetPoint("TOPLEFT",self,"TOPLEFT",8.5,-4);
		local Mkuandu,Mgaodu = 8,22
		self.moneyframe = CreateFrame("Frame", nil, self);
		self.moneyframe:SetSize(160,Mgaodu);
		self.moneyframe:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -8, 7)
		self.moneyframe_R = self:CreateTexture(texname.."moneyframe_R", "BORDER");
		self.moneyframe_R:SetTexture("interface/common/moneyframe.blp");
		self.moneyframe_R:SetTexCoord(0,0.05,0,0.31);
		self.moneyframe_R:SetSize(Mkuandu,Mgaodu);
		self.moneyframe_R:SetPoint("RIGHT", self.moneyframe, "RIGHT", 0, 0)
		self.moneyframe_l = self:CreateTexture(texname.."moneyframe_L", "BORDER");
		self.moneyframe_l:SetTexture("interface/common/moneyframe.blp");
		self.moneyframe_l:SetTexCoord(0.95,1,0,0.31);
		self.moneyframe_l:SetSize(Mkuandu,Mgaodu);
		self.moneyframe_l:SetPoint("LEFT", self.moneyframe, "LEFT", 0, 0)
		self.moneyframe_C = self:CreateTexture(texname.."moneyframe_C", "BORDER");
		self.moneyframe_C:SetTexture("interface/common/moneyframe.blp");
		self.moneyframe_C:SetTexCoord(0.1,0.9,0.314,0.621);
		self.moneyframe_C:SetPoint("TOPLEFT", self.moneyframe_l, "TOPRIGHT", 0, 0)
		self.moneyframe_C:SetPoint("BOTTOMRIGHT", self.moneyframe_R, "BOTTOMLEFT", 0, 0)
	end
end
function Create.BagBankFrame(fuji,Point,UIName,data,FrameLevel)
	local WH={data["meihang"]*(data["ButW"])+8,200}
	local frameX
	if ElvUI or NDui then
		frameX = PIGFrame(fuji,Point,WH,UIName,true)
		frameX:PIGSetBackdrop()
		frameX:PIGSetMovable()
		frameX:PIGClose()
		local TitleText = PIGFontString(frameX,{"TOP", frameX, "TOP",0, -6},nil,nil,nil,UIName.."TitleText")
		TitleText:SetTextColor(1, 1, 1, 1)
		frameX.moneyframe = CreateFrame("Frame", nil, frameX);
		frameX.moneyframe:SetSize(160,22);
		frameX.moneyframe:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -8, 7)
	else
		if tocversion<100000 then
			frameX = CreateFrame("Frame", UIName, fuji,"BackdropTemplate")
			Create.BagBankBG(frameX,UIName)
			frameX.Close = CreateFrame("Button",nil,frameX, "UIPanelCloseButton");  
			frameX.Close:SetSize(32,32);
			frameX.Close:SetPoint("TOPRIGHT", frameX, "TOPRIGHT", 4.8, -6);
		else
			frameX = CreateFrame("Frame", UIName, fuji,"PortraitFrameFlatTemplate")
		end
		frameX:Hide()
		tinsert(UISpecialFrames,UIName);
		if WH then
			frameX:SetSize(WH[1],WH[2]);
		end
		if Point then
			frameX:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
		end
		Create.PIGSetMovable(frameX)
		--
		frameX.portrait=frameX.portrait or frameX.PortraitContainer and frameX.PortraitContainer.portrait
		SetPortraitToTexture(frameX.portrait, 130899)
	end
	frameX:SetScale(data["suofang"])
	frameX.wupin = CreateFrame("Frame", nil, frameX,"BackdropTemplate")
	if tocversion<100000 then
		frameX.wupin:SetBackdrop( { bgFile = "interface/framegeneral/ui-background-marble.blp" });
		if ElvUI or NDui then
			frameX.wupin:SetBackdropColor(0, 0, 0, 0.3);
			frameX.wupin:SetPoint("TOPLEFT", frameX, "TOPLEFT",6, -56);
			frameX.wupin:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -6, 29);
		else
			frameX.wupin:SetPoint("TOPLEFT", frameX, "TOPLEFT",17, -66);
			frameX.wupin:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -5, 29);
		end
	else
		frameX.wupin:SetPoint("TOPLEFT", frameX, "TOPLEFT",6, -56);
		frameX.wupin:SetPoint("BOTTOMRIGHT", frameX, "BOTTOMRIGHT", -6, 29);
	end
	frameX.wupin:EnableMouse(true)
	frameX:SetUserPlaced(false)
	if FrameLevel then
		frameX:SetFrameLevel(FrameLevel)
	end
	frameX.meihang=data["meihang"]
	frameX.suofang=data["suofang"]
	return frameX
end
--暴雪浏览界面标题
function Create.PIGBrowseBiaoti(fuji)
	local TexC = fuji:CreateTexture(nil, "BORDER");
	TexC:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
	TexC:SetTexCoord(0.08,0.00,0.08,0.59,0.91,0.00,0.91,0.59);
	TexC:SetPoint("TOPLEFT",fuji,"TOPLEFT",5,0);
	TexC:SetPoint("BOTTOMRIGHT",fuji,"BOTTOMRIGHT",-5,0);
	local TexL = fuji:CreateTexture(nil, "BORDER");
	TexL:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
	TexL:SetTexCoord(0.00,0.00,0.00,0.59,0.08,0.00,0.08,0.59);
	TexL:SetPoint("TOPRIGHT",TexC,"TOPLEFT",0,0);
	TexL:SetPoint("BOTTOMRIGHT",TexC,"BOTTOMLEFT",0,0);
	TexL:SetWidth(5)
	local TexR = fuji:CreateTexture(nil, "BORDER");
	TexR:SetTexture("interface/friendsframe/whoframe-columntabs.blp");
	TexR:SetTexCoord(0.91,0.00,0.91,0.59,0.97,0.00,0.97,0.59);
	TexR:SetPoint("TOPLEFT",TexC,"TOPRIGHT",0,0);
	TexR:SetPoint("BOTTOMLEFT",TexC,"BOTTOMRIGHT",0,0);
	TexR:SetWidth(5)
	return TexC,TexL,TexR
end