local addonName, addonTable = ...;
local L =addonTable.locale
-----------------
local bencierrinfo={}
--------------------------------
local WWW,HHH = 600,380
local biaotiW = 25
local GNNameE="PIG_BugcollectUI"
local Backdropinfo={bgFile = "interface/chatframe/chatframebackground.blp",
	edgeFile = "Interface/AddOns/!Pig/libs/Pig_Border.blp", edgeSize = 6.6,}
local function PIGSetBackdrop(self,but)
	self:SetBackdrop(Backdropinfo)
	if but then
		self:SetBackdropColor(0.2, 0.2, 0.2, 1);
	else
		self:SetBackdropColor(0.08, 0.08, 0.08, 0.9);
	end
	self:SetBackdropBorderColor(0, 0, 0, 1);
end
local function ADD_Button(Text,fuF,WH,Point)
	local But = CreateFrame("Button", nil, fuF,"BackdropTemplate");
	PIGSetBackdrop(But,true)
	But:SetSize(WH[1],WH[2]);
	But:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
	But.Text = But:CreateFontString();
	But.Text:SetPoint("CENTER", 0, 0);
	But.Text:SetFontObject(ChatFontNormal);
	But.Text:SetTextColor(1, 0.843, 0, 1);
	But.Text:SetText(Text);
	hooksecurefunc(But, "Enable", function(self)
		self.Text:SetTextColor(1, 0.843, 0, 1);
	end)
	hooksecurefunc(But, "Disable", function(self)
		self.Text:SetTextColor(0.5, 0.5, 0.5, 1);
	end)
	But:HookScript("OnEnter", function(self)
		if self:IsEnabled() then
			self:SetBackdropBorderColor(0,0.8,1, 0.9);
		end
	end);
	But:HookScript("OnLeave", function(self)
		if self:IsEnabled() then
			self:SetBackdropBorderColor(0, 0, 0, 1);
		end
	end);
	But:HookScript("OnMouseDown", function(self)
		if self:IsEnabled() then
			self.Text:SetPoint("CENTER", 1.5, -1.5);
		end
	end);
	But:HookScript("OnMouseUp", function(self)
		if self:IsEnabled() then
			self.Text:SetPoint("CENTER", 0, 0);
		end
	end);
	But:HookScript("PostClick", function (self)
		PlaySound(SOUNDKIT.IG_CHAT_EMOTE_BUTTON);
	end)
	return But
end

local function ADD_TabBut(Text,fuF,WH,Point,id)
	local But = CreateFrame("Button", nil, fuF,"BackdropTemplate",id);
	But.Show=false;
	PIGSetBackdrop(But,true)
	But:SetSize(WH[1],WH[2]);
	But:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
	hooksecurefunc(But, "Enable", function(self)
		self.Text:SetTextColor(1, 0.843, 0, 1);
	end)
	hooksecurefunc(But, "Disable", function(self)
		self.Text:SetTextColor(0.5, 0.5, 0.5, 1);
	end)
	But:HookScript("OnEnter", function(self)
		if self:IsEnabled() and not self.Show then
			self:SetBackdropBorderColor(0,0.8,1, 1);
		end
	end);
	But:HookScript("OnLeave", function(self)
		if self:IsEnabled() and not self.Show then
			self:SetBackdropBorderColor(0, 0, 0, 1);
		end
	end);
	But:HookScript("OnMouseDown", function(self)
		if self:IsEnabled() and not self.Show then
			self.Text:SetPoint("CENTER", 1.5, -1.5);
		end
	end);
	But:HookScript("OnMouseUp", function(self)
		if self:IsEnabled() and not self.Show then
			self.Text:SetPoint("CENTER", 0, 0);
		end
	end);
	But.Text = But:CreateFontString();
	But.Text:SetPoint("CENTER", 0, 0);
	But.Text:SetFontObject(ChatFontNormal);
	But.Text:SetTextColor(1, 0.843, 0, 1);
	But.Text:SetText(Text);
	function But:selected()
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
		self.Show=true;
		self.Text:SetTextColor(1, 1, 1, 1);
		self:SetBackdropColor(0.3098,0.262745,0.0353, 1);
		self:SetBackdropBorderColor(1, 1, 0, 1);	
	end
	return But
end
----
local Bugcollect = CreateFrame("Frame", GNNameE, UIParent,"BackdropTemplate");
PIGSetBackdrop(Bugcollect)
Bugcollect:SetSize(WWW,HHH);
Bugcollect:SetPoint("CENTER",0,0);
Bugcollect:EnableMouse(true)
Bugcollect:SetMovable(true)
Bugcollect:SetClampedToScreen(true)
Bugcollect:SetFrameStrata("HIGH")
Bugcollect:Hide()
tinsert(UISpecialFrames,GNNameE);

Bugcollect.Moving = CreateFrame("Frame", nil, Bugcollect);
Bugcollect.Moving:SetSize(WWW,biaotiW);
Bugcollect.Moving:SetPoint("TOP",Bugcollect,"TOP",0,0);
Bugcollect.Moving:EnableMouse(true)
Bugcollect.Moving:RegisterForDrag("LeftButton")
Bugcollect.Moving:SetScript("OnDragStart",function()
    Bugcollect:StartMoving();
end)
Bugcollect.Moving:SetScript("OnDragStop",function()
    Bugcollect:StopMovingOrSizing()
end)

Bugcollect.Moving.Time = Bugcollect.Moving:CreateFontString();
Bugcollect.Moving.Time:SetPoint("TOPLEFT",Bugcollect.Moving,"TOPLEFT",10,-6);
Bugcollect.Moving.Time:SetFontObject(ChatFontNormal);
Bugcollect.Moving.Time:SetTextColor(1,0.843,0)

Bugcollect.Moving.Close = CreateFrame("Button",nil,Bugcollect.Moving);
Bugcollect.Moving.Close:SetHighlightTexture("interface/buttons/ui-common-mousehilight.blp")
Bugcollect.Moving.Close:SetSize(24,24);
Bugcollect.Moving.Close:SetPoint("TOPRIGHT",Bugcollect.Moving,"TOPRIGHT",0,0);
Bugcollect.Moving.Close.Tex = Bugcollect.Moving.Close:CreateTexture(nil, "BORDER");
Bugcollect.Moving.Close.Tex:SetTexture("interface/common/voicechat-muted.blp");
Bugcollect.Moving.Close.Tex:SetSize(Bugcollect.Moving.Close:GetWidth()-8,Bugcollect.Moving.Close:GetHeight()-8);
Bugcollect.Moving.Close.Tex:SetPoint("CENTER",0,0);
Bugcollect.Moving.Close:SetScript("OnMouseDown", function (self)
	self.Tex:SetPoint("CENTER",-1.5,-1.5);
end);
Bugcollect.Moving.Close:SetScript("OnMouseUp", function (self)
	self.Tex:SetPoint("CENTER");
end);
Bugcollect.Moving.Close:SetScript("OnClick", function (self)
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
	Bugcollect:Hide()
end);

Bugcollect.Moving.qingkong = ADD_Button(L["ERROR_CLEAR"],Bugcollect.Moving,{60,20},{"TOPRIGHT",Bugcollect.Moving,"TOPRIGHT",-50,-2.8})
Bugcollect.Moving.qingkong:SetScript("OnClick", function (self)
	PIGA["Error"]["ErrorDB"]={}
	bencierrinfo={}
	Bugcollect:qingkongERR()
end);
--
Bugcollect.Moving.tishiCK = CreateFrame("CheckButton", nil, Bugcollect.Moving, "ChatConfigCheckButtonTemplate");
Bugcollect.Moving.tishiCK:SetMotionScriptsWhileDisabled(true)
Bugcollect.Moving.tishiCK:SetHitRectInsets(0,-20,0,0)
Bugcollect.Moving.tishiCK:SetPoint("RIGHT",Bugcollect.Moving.qingkong,"LEFT",-60,-2)
Bugcollect.Moving.tishiCK:SetSize(24,24)
Bugcollect.Moving.tishiCK.Text:SetText(L["DEBUG_ERRORCHECK"]);
Bugcollect.Moving.tishiCK.Text:SetFont("Fonts/ARHei.ttf",13)
Bugcollect.Moving.tishiCK.tooltip = L["DEBUG_ERRORTOOLTIP"]
Bugcollect.Moving.tishiCK:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["Error"]["ErrorTishi"] = true
	else
		PIGA["Error"]["ErrorTishi"] = false
	end
end);
---显示区域
Bugcollect.NR = CreateFrame("Frame", nil, Bugcollect,"BackdropTemplate");
Bugcollect.NR:SetBackdrop(Backdropinfo)
Bugcollect.NR:SetBackdropColor(0.14, 0.14, 0.14, 0.8);
Bugcollect.NR:SetBackdropBorderColor(0, 0, 0, 1);
Bugcollect.NR:SetSize(WWW,HHH-biaotiW*2);
Bugcollect.NR:SetPoint("TOP",Bugcollect,"TOP",0,-biaotiW);
----------
Bugcollect.NR.scroll = CreateFrame("ScrollFrame", nil, Bugcollect.NR, "UIPanelScrollFrameTemplate")
Bugcollect.NR.scroll:SetPoint("TOPLEFT", Bugcollect.NR, "TOPLEFT", 6, -2)
Bugcollect.NR.scroll:SetPoint("BOTTOMRIGHT", Bugcollect.NR, "BOTTOMRIGHT", -24, 6)

Bugcollect.NR.textArea = CreateFrame("EditBox", nil, Bugcollect.NR.scroll)
Bugcollect.NR.textArea:SetWidth(WWW-30)
Bugcollect.NR.textArea:SetFontObject(ChatFontNormal);
Bugcollect.NR.textArea:SetTextColor(0.9, 0.9, 0.9, 1)
Bugcollect.NR.textArea:SetAutoFocus(false)
Bugcollect.NR.textArea:SetMultiLine(true)
Bugcollect.NR.textArea:SetMaxLetters(9999)
Bugcollect.NR.textArea:EnableMouse(true)
Bugcollect.NR.textArea:SetScript("OnEscapePressed", Bugcollect.NR.textArea.ClearFocus)
Bugcollect.NR.scroll:SetScrollChild(Bugcollect.NR.textArea)
--------------
Bugcollect.prevZ = ADD_Button("《 ",Bugcollect,{30,20},{"BOTTOMLEFT",Bugcollect,"BOTTOMLEFT",10,3})
Bugcollect.prevZ:Disable()
Bugcollect.prev = ADD_Button(L["ERROR_PREVIOUS"],Bugcollect,{90,20},{"BOTTOM",Bugcollect,"BOTTOM",-130,3})
Bugcollect.prev:Disable()
Bugcollect.next = ADD_Button(L["ERROR_NEXT"],Bugcollect,{90,20},{"BOTTOM",Bugcollect,"BOTTOM",130,3})
Bugcollect.next:Disable()
Bugcollect.nextZ = ADD_Button(" 》",Bugcollect,{30,20},{"BOTTOMRIGHT",Bugcollect,"BOTTOMRIGHT",-10,3})
Bugcollect.nextZ:Disable()
Bugcollect.biaoti = Bugcollect:CreateFontString();
Bugcollect.biaoti:SetPoint("BOTTOM",Bugcollect,"BOTTOM",0,6);
Bugcollect.biaoti:SetFontObject(ChatFontNormal);
Bugcollect.biaoti:SetTextColor(1,0.843,0)
------------
function Bugcollect:qingkongERR()
	Bugcollect.prev:Disable()
	Bugcollect.next:Disable()
	Bugcollect.prevZ:Disable()
	Bugcollect.nextZ:Disable()
	Bugcollect.Moving.Time:SetText(L["ERROR_EMPTY"]);
	Bugcollect.biaoti:SetText("");
	Bugcollect.NR.textArea:SetText("")
end
----------------------
local function xianshixinxi(id)
	if Bugcollect:IsShown() then
		Bugcollect:qingkongERR()
		local shujuyuan = {}
		if Bugcollect.ButList[1].Show then
			shujuyuan.ly=bencierrinfo
			shujuyuan.num=#shujuyuan.ly
		elseif Bugcollect.ButList[2].Show then
			shujuyuan.ly=PIGA["Error"]["ErrorDB"]
			shujuyuan.num=#shujuyuan.ly
		end
		if shujuyuan.num==0 then return end
		local msg=shujuyuan.ly[id].msg
		local time=shujuyuan.ly[id].time
		local cuowushu=shujuyuan.ly[id].counter
		local stack=shujuyuan.ly[id].stack
		local logrizhi=shujuyuan.ly[id].logrizhi
		Bugcollect.Moving.Time:SetText(date("%Y/%m/%d %H:%M:%S",time));
		Bugcollect.biaoti:SetText(id.."/"..shujuyuan.num);
		--print(msg)
		if cuowushu>1 then
			Bugcollect.NR.textArea:SetText(cuowushu.."× "..msg.."\r")
		else
			Bugcollect.NR.textArea:SetText(msg.."\r")
		end
		Bugcollect.NR.textArea:Insert(stack.."\r");
		Bugcollect.NR.textArea:Insert(logrizhi);
		local NEWTXT = Bugcollect.NR.textArea:GetText()
		if #NEWTXT<2 then
			ChatFrame1:AddMessage("错误无法正常显示，改为聊天框输出:");
			ChatFrame1:AddMessage(msg);
		end
		Bugcollect.prev.id=id
		Bugcollect.next.id=id
		if shujuyuan.num>1 then
			if id==1 then
				Bugcollect.prevZ:Disable()
				Bugcollect.prev:Disable()
				Bugcollect.next:Enable()
				Bugcollect.nextZ:Enable()
			elseif shujuyuan.num==id then
				Bugcollect.next:Disable()
				Bugcollect.nextZ:Disable()
				Bugcollect.prev:Enable()
				Bugcollect.prevZ:Enable()
			else
				Bugcollect.prev:Enable()
				Bugcollect.next:Enable()
				Bugcollect.prevZ:Enable()
				Bugcollect.nextZ:Enable()
			end
		else	
			Bugcollect.prev:Disable()
			Bugcollect.next:Disable()
			Bugcollect.prevZ:Disable()
			Bugcollect.nextZ:Disable()
		end
	end
end
local function kaishiShow()
	if Bugcollect.ButList[1].Show then
		local tablenum = #bencierrinfo
		xianshixinxi(tablenum)
	elseif Bugcollect.ButList[2].Show then
		local tablenum = #PIGA["Error"]["ErrorDB"]
		xianshixinxi(tablenum)
	end
end
-----
local TabWidth,TabHeight = 110,24;
local TabName = {L["ERROR_CURRENT"],L["ERROR_OLD"]};
Bugcollect.ButList={}
for id=1,#TabName do
	local Point = {"TOPLEFT", Bugcollect, "BOTTOMLEFT", 30,0}
	if id>1 then
		Point = {"LEFT", Bugcollect.ButList[id-1], "RIGHT", 20,0}
	end
	local Tablist = ADD_TabBut(TabName[id],Bugcollect,{TabWidth,TabHeight},Point,id)
	Bugcollect.ButList[id]=Tablist
	Tablist:SetScript("OnClick", function (self)
		for x=1,#TabName do
			local fagg=Bugcollect.ButList[x]
			fagg.Show=false;
			fagg.Text:SetTextColor(1, 0.843, 0, 1);
			fagg:SetBackdropColor(0.2, 0.2, 0.2, 1);
			fagg:SetBackdropBorderColor(0, 0, 0, 1);
		end
		self:selected()
		kaishiShow()
	end);
	---
	if id==1 then
		Tablist:selected()
	end
end
-------
Bugcollect.prevZ:SetScript("OnClick", function(self, button)
	local newid = 1
	xianshixinxi(newid)
end)
Bugcollect.prev:SetScript("OnClick", function(self, button)
	local newid = self.id-1
	xianshixinxi(newid)
end)
Bugcollect.next:SetScript("OnClick", function(self, button)
	local newid = self.id+1
	xianshixinxi(newid)
end)
Bugcollect.nextZ:SetScript("OnClick", function(self, button)
	for x=1,#TabName do
		if Bugcollect.ButList[x].Show then
			if x==1 then
				xianshixinxi(#bencierrinfo)
			elseif x==2 then
				xianshixinxi(#PIGA["Error"]["ErrorDB"])
			end
		end
	end
end)
----------------
Bugcollect:SetScript("OnShow", function(self)
	self:SetFrameLevel(99)
	self.Moving.tishiCK:SetChecked(PIGA["Error"]["ErrorTishi"])
	kaishiShow()
end)
----错误处理FUN
local linshicuowuxinxi = {}
local function errottishi()
	if PIGA and PIGA["Error"]["ErrorTishi"] then
		if #linshicuowuxinxi>0 then	
			if PIG_OptionsUI.MiniMapBut then
				PIG_OptionsUI.MiniMapBut.error:Show();
			end
			for i=1,#linshicuowuxinxi do
				print(linshicuowuxinxi[i])
			end
			linshicuowuxinxi = {}
		end
	end
end
---
local function SaveErrorInfo(databc, Newmsg)
	for i, err in next, databc do
		if err.msg == Newmsg then
			err.counter = err.counter + 1
			err.time = GetServerTime()
			return true
		end
	end
	return false
end
----
local PIGerrotFUN=function() end
local PIG_ERR_OR_NUM,PIG_ERR_OR_SSS = 6,3--错误阈值/冷却
local PIG_LAST_TIME = 0
local HAVE_PASSED_NUM = 0
function PIGerrotFUN(event,msg1,msg2)
	--print(event,msg1,msg2)
	if GetTime()-PIG_LAST_TIME>PIG_ERR_OR_SSS then
		HAVE_PASSED_NUM=HAVE_PASSED_NUM+1
		if HAVE_PASSED_NUM>PIG_ERR_OR_NUM then
			PIG_LAST_TIME=GetTime()
		end
	else
		HAVE_PASSED_NUM=1
		return
	end
	if event=="LUA_WARNING" then
		--
	elseif event=="ADDON_ACTION_FORBIDDEN" or event=="ADDON_ACTION_BLOCKED" then
		local msg1 = tostring(msg1)
		local msg2 = tostring(msg2)
		local newmsg = "["..event.."] "..L["ERROR_ADDON"].."< "..msg1.." >"..L["ERROR_ERROR1"].."< "..msg2.." >"
		local cunzai = SaveErrorInfo(bencierrinfo, newmsg)
		if not cunzai then
			local time = GetServerTime()
			local stack = debugstack(3) or "null"
			local logrizhi = debuglocals(3) or "null"
			local errorindo = {
				msg = newmsg,
				time = time,
				counter = 1,
				stack = stack,
				logrizhi=logrizhi,
			}
			bencierrinfo[#bencierrinfo + 1] = errorindo	
		end
	elseif event=="MACRO_ACTION_FORBIDDEN" or event=="MACRO_ACTION_BLOCKED" then
		local newmsg = "["..event.."] "..L["ERROR_ERROR2"].."<"..msg1..">"
		local cunzai = SaveErrorInfo(bencierrinfo, newmsg)
		if not cunzai then
			local time = GetServerTime()
			local stack = debugstack(3) or "null"
			local logrizhi = debuglocals(3) or "null"
			local errorindo = {
				msg = msg,
				time = time,
				counter = 1,
				stack = stack,
				logrizhi=logrizhi,
			}
			bencierrinfo[#bencierrinfo + 1] = errorindo	
		end
	else
		local newmsg = tostring(event)
		table.insert(linshicuowuxinxi,newmsg)
		errottishi()
		local cunzai = SaveErrorInfo(bencierrinfo, newmsg)
		if not cunzai then
			local time = GetServerTime()
			local stack = debugstack(3) or "null"
			local logrizhi = debuglocals(3) or "null"
			local errorindo = {
				msg = newmsg,
				time = time,
				counter = 1,
				stack = stack,
				logrizhi=logrizhi,
			}
			bencierrinfo[#bencierrinfo + 1] = errorindo	
		end
	end
	xianshixinxi(#bencierrinfo)
end
UIParent:UnregisterEvent("LUA_WARNING")
local Pig_seterrorhandler=seterrorhandler
Pig_seterrorhandler(PIGerrotFUN);
function seterrorhandler() end
--========================================================
local function del_ErrorInfo()			
	PIGA["Error"]=PIGA["Error"] or addonTable.Default["Error"]
	local cuowuNum = #PIGA["Error"]["ErrorDB"]
	if cuowuNum>0 then
		if cuowuNum>10 then
			for i=(cuowuNum-10),1,-1 do
				table.remove(PIGA["Error"]["ErrorDB"],i)
			end
		end
	end
end
--
Bugcollect:RegisterEvent("LUA_WARNING")
Bugcollect:RegisterEvent("ADDON_ACTION_FORBIDDEN");
Bugcollect:RegisterEvent("ADDON_ACTION_BLOCKED");
Bugcollect:RegisterEvent("MACRO_ACTION_FORBIDDEN");
Bugcollect:RegisterEvent("MACRO_ACTION_BLOCKED");
Bugcollect:RegisterEvent("PLAYER_ENTERING_WORLD")
Bugcollect:RegisterEvent("PLAYER_LOGOUT");
Bugcollect:RegisterEvent("ADDON_LOADED")
Bugcollect:SetScript("OnEvent", function(self,event,arg1,arg2)
	if event=="ADDON_LOADED" then
		C_Timer.After(3,del_ErrorInfo)
		Bugcollect:UnregisterEvent("ADDON_LOADED")
	elseif event=="PLAYER_ENTERING_WORLD" then
		Bugcollect.yijiazai=true
		errottishi()
	elseif event=="PLAYER_LOGOUT" then
		local hejishu=#bencierrinfo
		for i=1,hejishu do
			table.insert(PIGA["Error"]["ErrorDB"], bencierrinfo[i]);
		end
	elseif event=="ADDON_ACTION_FORBIDDEN" or event=="ADDON_ACTION_BLOCKED" then
		PIGerrotFUN(event,arg1,arg2)
	elseif event=="MACRO_ACTION_FORBIDDEN" or event=="MACRO_ACTION_BLOCKED" then
		PIGerrotFUN(event,arg1)
	elseif event=="LUA_WARNING" then
		PIGerrotFUN(arg2)
	end
end)
--==================================
SLASH_PER1 = "/per"
SLASH_PER2 = "/Per"
SLASH_PER3 = "/PER"
SlashCmdList["PER"] = function()
	Bugcollect:Show();
end