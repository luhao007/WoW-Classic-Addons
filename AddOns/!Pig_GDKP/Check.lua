local addonName, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local Create, Data, Fun, L, Default, Default_Per= unpack(PIG)
-----
local PIGFrame=Create.PIGFrame
local PIGButton = Create.PIGButton
-- local PIGDownMenu=Create.PIGDownMenu
-- local PIGLine=Create.PIGLine
-- local PIGEnter=Create.PIGEnter
-- local PIGSlider = Create.PIGSlider
-- local PIGCloseBut=Create.PIGCloseBut
local PIGCheckbutton=Create.PIGCheckbutton
-- local PIGOptionsList_RF=Create.PIGOptionsList_RF
-- local PIGOptionsList_R=Create.PIGOptionsList_R
-- local PIGQuickBut=Create.PIGQuickBut
-- local Show_TabBut_R=Create.Show_TabBut_R
local PIGFontString=Create.PIGFontString
-- local PIGCloseBut=Create.PIGCloseBut
-- local PIGSetFont=Create.PIGSetFont
----------
local GDKPInfo=addonTable.GDKPInfo
-- -------
function GDKPInfo.ADD_Check()
	local GnName,GnUI,GnIcon,FrameLevel = unpack(GDKPInfo.uidata)
	-- local LeftmenuV=GDKPInfo.LeftmenuV
	-- local buzhuzhize=GDKPInfo.buzhuzhize
	local RaidR=_G[GnUI]
	local Check=PIGButton(RaidR,{"TOPRIGHT",RaidR,"TOPRIGHT",-30,-25},{60,22},"查账")
	Check:SetScript("OnClick", function (self)
		if self.Box:IsShown() then
			self.Box:Hide()
		else
			self.Box:ShowFun()
		end
	end);
	-------------
	Check.xuanzhongID=1;
	Check.Box=PIGFrame(Check,{"TOP",RaidR,"TOP",0,-100},{300,200})
	Check.Box:PIGSetBackdrop(1)
	Check.Box:PIGClose()
	Check.Box:SetFrameLevel(FrameLevel+33)
	Check.Box:Hide()
	Check.Box.tongbu_1 = PIGCheckbutton(Check.Box,{"TOPLEFT",Check.Box,"TOPLEFT",20,-20},{"团长:",nil})
	Check.Box.tongbu_1:SetScript("OnClick", function (self)
		self:SetChecked(true)
		Check.xuanzhongID=1;
		Check.Box:tongburen()
	end);
	Check.Box.tongbu_2 = PIGFontString(Check.Box,{"LEFT",Check.Box.tongbu_1.Text,"RIGHT",0,0},NONE,"OUTLINE");

	Check.Box.tongbu_3 = PIGCheckbutton(Check.Box,{"TOPLEFT",Check.Box,"TOPLEFT",20,-50},{"战利品分配者:",nil})
	Check.Box.tongbu_3:SetScript("OnClick", function (self)
		self:SetChecked(true)
		Check.xuanzhongID=2;
		Check.Box:tongburen()
	end);
	Check.Box.tongbu_4 = PIGFontString(Check.Box,{"LEFT",Check.Box.tongbu_3.Text,"RIGHT",0,0},NONE,"OUTLINE");

	local txt1 = "同步上方选定人员的账本到本地\n以供查账，当前已有的记录将被\124cffff0000覆盖\124r"
	Check.Box.biaoti_9 = PIGFontString(Check.Box,{"TOPLEFT",Check.Box,"TOPLEFT",20,-80},txt1,"OUTLINE");
	Check.Box.biaoti_9:SetJustifyH("LEFT")

	Check.Box.save = PIGButton(Check.Box,{"TOP",Check.Box,"TOP",0,-140},{80,24},"同步账本");
	Check.Box.save:HookScript("OnClick",function (self)
		--Check.Box.qiankuan_InfoSave()
	end)
	Check.Box.save:Disable()
	function Check.Box:tongburen()
		Check.Box.tongbu_1:SetChecked(false)
		Check.Box.tongbu_3:SetChecked(false)
		if Check.xuanzhongID==1 then
			Check.Box.tongbu_1:SetChecked(true)
		elseif Check.xuanzhongID==2 then
			Check.Box.tongbu_3:SetChecked(true)
		end
	end
	local function Get_Leader_Loot()
		local Leader,Loot = nil,nil
		for raidIndex=1,40 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(raidIndex)
			if rank==2 then
				Leader=name
			end
			if isML then
				Loot=name
			end
		end
		return Leader,Loot
	end
	function Check.Box:ShowFun()
		self:tongburen()
		self:Show()
		Check.Box.tongbu_1:Disable()
		Check.Box.tongbu_3:Disable()
		Check.Box.tongbu_2:SetText(NONE)
		Check.Box.tongbu_4:SetText(NONE)
		if IsInGroup(LE_PARTY_CATEGORY_HOME) then
			local Leader,Loot = Get_Leader_Loot()
			if Leader then
				Check.Box.tongbu_1:Enable()
				Check.Box.tongbu_2:SetText(Leader)
			end
			if Loot then
				Check.Box.tongbu_3:Enable()
				Check.Box.tongbu_4:SetText(Loot)
			end
		end 
	end
end