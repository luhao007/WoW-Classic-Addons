local _, addonTable = ...;
local L=addonTable.locale
--------
local Create=addonTable.Create
local PIGFrame=Create.PIGFrame
local PIGEnter=Create.PIGEnter
local PIGDiyBut=Create.PIGDiyBut
local PIGCheckbutton_R=Create.PIGCheckbutton
local PIGCheckbutton_R=Create.PIGCheckbutton_R
local PIGOptionsList_R=Create.PIGOptionsList_R
local PIGFontString=Create.PIGFontString
--
local bagData=addonTable.Data.bagData
local GetContainerNumSlots = GetContainerNumSlots or C_Container and C_Container.GetContainerNumSlots
local GetContainerNumFreeSlots = GetContainerNumFreeSlots or C_Container and C_Container.GetContainerNumFreeSlots
local GetContainerItemID=GetContainerItemID or C_Container and C_Container.GetContainerItemID
local GetContainerItemLink=GetContainerItemLink or C_Container and C_Container.GetContainerItemLink
local GetItemInfoInstant=GetItemInfoInstant or C_Item and C_Item.GetItemInfoInstant
local CombatPlusfun=addonTable.CombatPlusfun
-----------------------
if PIG_MaxTocversion(20000,true) then function CombatPlusfun.BabySitter() end return end
local CombatPlusF,CombatPlusBut =PIGOptionsList_R(CombatPlusfun.RTabFrame,L["COMBAT_TABNAME4"],90)
---
local function ammotipsFun(ly)
	if not PIGA["CombatPlus"]["ammotips"] then return end
	if CombatPlusF.ammotipsOpen then return end
	local _, classId = UnitClassBase("player");
	--职业编号1战士/2圣骑士/3猎人/4盗贼/5牧师/6死亡骑士/7萨满祭司/8法师/9术士/10武僧/11德鲁伊/12恶魔猎手
	if not classId and classId~=1 and classId~=3 and classId~=4 then return end
	local ammotips=CreateFrame("Button", nil, UIParent)
	CombatPlusF.ammotipsOpen=true
	ammotips:SetSize(30,30);
	ammotips:SetPoint("TOP",UIParent,"TOP",-80,-200);
	ammotips:Hide();
	ammotips:SetFrameStrata("LOW")
	ammotips.t = PIGFontString(ammotips,{"LEFT",ammotips,"RIGHT", 0, 0},"","OUTLINE",24)
	ammotips.t:SetTextColor(1, 0, 0, 1);
	--
	local function event_Script()
		local resting = IsResting()
		if resting then
			ammotips.tipsShow=false
			local itemId= GetInventoryItemID("player", 18)
			if itemId then
				local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(itemId) 
				if classID==2 then--武器
					if subclassID==16 then--投掷
						local xxxx = GetInventoryItemCount("player", 18)
						if xxxx<50 then
							ammotips:SetNormalTexture(135426)--投掷刀
							ammotips.t:SetText(ACTION_SPELL_ENERGIZE..INVTYPE_THROWN..WEAPON)
							ammotips:Show()
						end
					elseif subclassID==2 or subclassID==3 or subclassID==18 then--弓/枪/弩
						ammotips.tipsShowicon=132382
						ammotips.tipsammonum=50
						local xxxx = GetInventoryItemCount("player", 0)
						if ammotips.classId==3 then
							for bag=1,#bagData["bagID"] do
								local numFreeSlots, bagType = GetContainerNumFreeSlots(bagData["bagID"][bag])
								if bagType==1 or bagType==2 then
									local numSlots = GetContainerNumSlots(bagData["bagID"][bag])
									ammotips.tipsammonum=(numSlots*0.5)*200
									break
								end
							end
						end
						if xxxx<ammotips.tipsammonum then
							ammotips.tipsShow=true
						end
						if subclassID==3 then
							ammotips.tipsShowicon=132384
						end
						if ammotips.tipsShow then
							ammotips:SetNormalTexture(ammotips.tipsShowicon)
							ammotips.t:SetText(ACTION_SPELL_ENERGIZE..AMMOSLOT)
							ammotips:Show()
						end
					end	
				end
			else
				ammotips.tipsShowicon=135426
				if ammotips.classId==3 then
					ammotips.tipsShow,ammotips.tipsShowicon=true,136520
				elseif ammotips.classId==4 then
					ammotips.tipsShow=true
				elseif ammotips.classId==1 and ammotips.touzhiOK then
					ammotips.tipsShow=true
				end
				if ammotips.tipsShow then
					ammotips:SetNormalTexture(ammotips.tipsShowicon)
					ammotips.t:SetText("没有"..ITEM_SPELL_TRIGGER_ONEQUIP..INVTYPE_RANGED..WEAPON)--INVTYPE_THROWN
					ammotips:Show()
				end
			end
		end
	end
	local function Class_Load()
		local _, classId = UnitClassBase("player");
		ammotips.classId=classId
		local numSkills = GetNumSkillLines();
		for x=1,numSkills do
			local skillName = GetSkillLineInfo(x);
			if skillName==INVTYPE_THROWN..WEAPON then
				ammotips.touzhiOK=true
				break
			end
		end
		event_Script()
	end	
	if ly then Class_Load() end
	ammotips:RegisterEvent("PLAYER_ENTERING_WORLD")
	ammotips:RegisterEvent("PLAYER_UPDATE_RESTING");
	ammotips:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	ammotips:RegisterEvent("UNIT_INVENTORY_CHANGED","player");
	ammotips:HookScript("OnEvent", function(self,event,arg1,arg2,arg3)
		self:Hide()
		if event=="PLAYER_ENTERING_WORLD" then
			Class_Load()
		elseif event=="PLAYER_UPDATE_RESTING" or event=="UNIT_INVENTORY_CHANGED" then
			C_Timer.After(0.4,event_Script)
		elseif event=="PLAYER_EQUIPMENT_CHANGED" then
			if arg1==18 or arg1==0 then 
				C_Timer.After(0.4,event_Script)
			end
		end
	end)
end
CombatPlusF.ammotips = PIGCheckbutton_R(CombatPlusF,{L["LIB_TIPS"]..ACTION_SPELL_ENERGIZE..AMMOSLOT.."/"..INVTYPE_THROWN..WEAPON})
CombatPlusF.ammotips:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["ammotips"]=true;
		ammotipsFun(true)
	else
		PIGA["CombatPlus"]["ammotips"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end)
----------
local function SubmergedFun(ly)
	local warnUI = CreateFrame("Frame", nil, UIParent);
	warnUI:SetAllPoints(UIParent)
	warnUI.alltex = warnUI:CreateTexture(nil, "BACKGROUND");
	warnUI.alltex:SetTexture("Interface/FullScreenTextures/LowHealth");
	warnUI.alltex:SetBlendMode("ADD")
	warnUI.alltex:SetAllPoints(warnUI)
	warnUI:Hide()
	warnUI.pulseAnim = warnUI:CreateAnimationGroup()
	warnUI.pulseAnim.AlphaAnim = warnUI.pulseAnim:CreateAnimation("Alpha")
	warnUI.pulseAnim.AlphaAnim:SetFromAlpha(1)
	warnUI.pulseAnim.AlphaAnim:SetToAlpha(0.2)
	warnUI.pulseAnim.AlphaAnim:SetDuration(0.5236)
	warnUI.t = PIGFontString(warnUI,{"CENTER",warnUI,"CENTER", 0, 40},"","OUTLINE",28)
	warnUI.t:SetTextColor(1, 1, 0, 1);
	for index=1, MIRRORTIMER_NUMTIMERS do
		_G["MirrorTimer"..index]:HookScript("OnHide", function(self)
			warnUI:Hide()
		end)
		_G["MirrorTimer"..index]:HookScript("OnUpdate", function(self,elapsed)
			if self.timer=="BREATH" then
				if self.value<10 then
					warnUI:Show()
					warnUI.pulseAnim:Play()
					warnUI.t:SetText("↑快往上游↑")
				else
					warnUI:Hide()
					warnUI.pulseAnim:Stop()
				end
			elseif self.timer=="EXHAUSTION" then
				if self.value<10 then
					warnUI:Show()
					warnUI.pulseAnim:Play()
					warnUI.t:SetText("↑快回陆地↑")
				else
					warnUI:Hide()
					warnUI.pulseAnim:Stop()
				end
			end
		end)
	end
end
CombatPlusF.Submerged = PIGCheckbutton_R(CombatPlusF,{L["LIB_TIPS"]..STRING_ENVIRONMENTAL_DAMAGE_DROWNING.."/疲劳"})
CombatPlusF.Submerged:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["Submerged"]=true;
		SubmergedFun(true)
	else
		PIGA["CombatPlus"]["Submerged"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end)
---
local function DangerWarningFun()
	local DangerWarningUI = CreateFrame("Frame", nil, UIParent,"BackdropTemplate");
	DangerWarningUI:SetBackdrop({bgFile = "interface/chatframe/chatframebackground.blp"});
	--DangerWarningUI:SetBackdropColor(1, 0, 0, 0.5);
	DangerWarningUI:SetSize(130,30);
	DangerWarningUI:SetPoint("CENTER",UIParent,"CENTER",300,-150);
	DangerWarningUI:Hide()
	DangerWarningUI.t = PIGFontString(DangerWarningUI,{"CENTER",DangerWarningUI,"CENTER", 0, 0},"111","OUTLINE",28)
	DangerWarningUI.t:SetTextColor(1, 1, 0, 1);
	DangerWarningUI:RegisterEvent("PLAYER_TARGET_CHANGED")
	DangerWarningUI:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	DangerWarningUI:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	if C_EventUtils.IsEventValid("VIGNETTE_MINIMAP_UPDATED") then
		DangerWarningUI:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
		DangerWarningUI:RegisterEvent("VIGNETTES_UPDATED")
	end
	if PIG_MaxTocversion() then
		SetCVar("nameplateMaxDistance", "41")
	else
	    SetCVar("nameplateMaxDistance", "100")
	end
	-- DangerWarningUI:UnregisterEvent("ZONE_CHANGED")
	-- DangerWarningUI:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	-- DangerWarningUI:UnregisterEvent("ZONE_CHANGED_INDOORS")
	-- DangerWarningUI:UnregisterEvent("PLAYER_ENTERING_WORLD")
	-- DangerWarningUI:UnregisterEvent("UNIT_FACTION")
	-- DangerWarningUI:UnregisterEvent("PLAYER_TARGET_CHANGED")
	-- DangerWarningUI:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	-- DangerWarningUI:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	-- DangerWarningUI:UnregisterEvent("PLAYER_REGEN_ENABLED")
	-- DangerWarningUI:UnregisterEvent("PLAYER_DEAD")
	-- DangerWarningUI:UnregisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	-- DangerWarningUI:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
	-- DangerWarningUI:UnregisterEvent("NAME_PLATE_UNIT_REMOVED")
	function DangerWarningUI:TrackCurrentShard(guid)
		if not guid then return end
		self.t:SetText(guid)
		--local guidType, _, serverID, instanceID, zoneUID, id, spawnUID = strsplit("-", guid)
		--if not (guidType and valid_types[guidType]) then return end
		
		--return tonumber(zoneUID), tonumber(id)
	end
	DangerWarningUI:HookScript("OnEvent",  function (self,event,arg1)
		if event=="PLAYER_TARGET_CHANGED" then
			self:TrackCurrentShard(UnitGUID("target"))
		elseif event=="UPDATE_MOUSEOVER_UNIT" then
			self:TrackCurrentShard(UnitGUID("mouseover"))
		elseif event=="NAME_PLATE_UNIT_ADDED" then
			self:TrackCurrentShard(UnitGUID(arg1))
		elseif event=="VIGNETTE_MINIMAP_UPDATED" then
			self:TrackCurrentShard(arg1)
		elseif event=="VIGNETTES_UPDATED" then
			local VignettesList = C_VignetteInfo.GetVignettes()
			for i=1, #VignettesList do
				self:TrackCurrentShard(VignettesList[i])
			end
		end
	end);
end
CombatPlusF.DangerWarning = PIGCheckbutton_R(CombatPlusF,{"危险警告！！！"})
CombatPlusF.DangerWarning:SetScript("OnClick", function (self)
	if self:GetChecked() then
		PIGA["CombatPlus"]["DangerWarning"]=true;
		DangerWarningFun(true)
	else
		PIGA["CombatPlus"]["DangerWarning"]=false;
		PIG_OptionsUI.RLUI:Show()
	end
end)
CombatPlusF.DangerWarning:Disable();


--宠物喂食
local function PetHappinessFun()
	if PIG_MaxTocversion(30000,true) then return end
	local _, classId = UnitClassBase("player");
	if classId~=3 then return end
	local function ADD_PetButFun()
		if not PIGA["CombatPlus"]["PetHappiness"] then return end
		if PetFrameHappiness.Action_l then return end
		local FoodIndex = {["肉"]=1,["鱼"]=2,["水果"]=3,["蘑菇"]=4,["面包"]=5,["奶酪"]=6}
		local Foodtype = {[1]="魔法食物",[2]="常规",[3]="BUFF食物",[4]="任务食物"}
		local FoodList = {
			[1] = {
				[117] = 2,
				[2287] = 2,
				[2679] = 2,
				[2681] = 2,
				[2685] = 2,
				[3770] = 2,
				[3771] = 2,
				[4599] = 2,
				[5478] = 2,
				[6890] = 2,
				[7097] = 2,
				[8952] = 2,
				[9681] = 2,
				[11444] = 2,
				[17119] = 2,
				[17407] = 2,
				[19223] = 2,
				[19224] = 2,
				[19304] = 2,
				[19305] = 2,
				[19306] = 2,
				[19995] = 2,
				[21235] = 2,
				[23495] = 2,
				[27854] = 2,
				[29451] = 2,
				[30610] = 2,
				[32685] = 2,
				[32686] = 2,
				[33254] = 2,
				[33454] = 2,
				[34747] = 2,
				[35953] = 2,
				[38427] = 2,
				[38428] = 2,
				[40202] = 2,
				[40358] = 2,
				[40359] = 2,
				[41729] = 2,
				[44072] = 2,
				[1017] = 3,
				[2680] = 3,
				[2684] = 3,
				[2687] = 3,
				[2888] = 3,
				[3220] = 3,
				[3662] = 3,
				[3726] = 3,
				[3727] = 3,
				[3728] = 3,
				[3729] = 3,
				[4457] = 3,
				[5472] = 3,
				[5474] = 3,
				[5477] = 3,
				[5479] = 3,
				[5480] = 3,
				[12209] = 3,
				[12210] = 3,
				[12213] = 3,
				[12224] = 3,
				[13851] = 3,
				[17222] = 3,
				[18045] = 3,
				[20074] = 3,
				[21023] = 3,
				[24105] = 3,
				[27635] = 3,
				[27636] = 3,
				[27651] = 3,
				[27655] = 3,
				[27657] = 3,
				[27658] = 3,
				[27659] = 3,
				[27660] = 3,
				[29292] = 3,
				[31672] = 3,
				[31673] = 3,
				[33872] = 3,
				[34125] = 3,
				[34410] = 3,
				[34748] = 3,
				[34749] = 3,
				[34750] = 3,
				[34751] = 3,
				[34752] = 3,
				[34754] = 3,
				[34755] = 3,
				[34756] = 3,
				[34757] = 3,
				[34758] = 3,
				[35563] = 3,
				[35565] = 3,
				[42779] = 3,
				[42994] = 3,
				[42995] = 3,
				[42997] = 3,
				[43001] = 3,
				[43488] = 3,
				[723] = 4,
				[729] = 4,
				[769] = 4,
				[1015] = 4,
				[1080] = 4,
				[1081] = 4,
				[2672] = 4,
				[2673] = 4,
				[2677] = 4,
				[2886] = 4,
				[2924] = 4,
				[3173] = 4,
				[3404] = 4,
				[3667] = 4,
				[3712] = 4,
				[3730] = 4,
				[3731] = 4,
				[4739] = 4,
				[5051] = 4,
				[5465] = 4,
				[5467] = 4,
				[5469] = 4,
				[5470] = 4,
				[5471] = 4,
				[12037] = 4,
				[12184] = 4,
				[12202] = 4,
				[12203] = 4,
				[12204] = 4,
				[12205] = 4,
				[12208] = 4,
				[12223] = 4,
				[20424] = 4,
				[21024] = 4,
				[22644] = 4,
				[23676] = 4,
				[27668] = 4,
				[27669] = 4,
				[27671] = 4,
				[27674] = 4,
				[27677] = 4,
				[27678] = 4,
				[27681] = 4,
				[27682] = 4,
				[31670] = 4,
				[31671] = 4,
				[33120] = 4,
				[34736] = 4,
				[35562] = 4,
				[35794] = 4,
				[43009] = 4,
				[43010] = 4,
				[43011] = 4,
				[43012] = 4,
				[43013] = 4,
			},
			[2] = {
				[787] = 2,
				[1326] = 2,
				[2682] = 2,
				[4592] = 2,
				[4593] = 2,
				[4594] = 2,
				[5095] = 2,
				[6290] = 2,
				[6316] = 2,
				[6887] = 2,
				[8364] = 2,
				[8957] = 2,
				[8959] = 2,
				[12238] = 2,
				[13546] = 2,
				[13930] = 2,
				[13933] = 2,
				[13935] = 2,
				[16766] = 2,
				[19996] = 2,
				[21071] = 2,
				[21153] = 2,
				[21552] = 2,
				[27661] = 2,
				[27858] = 2,
				[29452] = 2,
				[33004] = 2,
				[33048] = 2,
				[33053] = 2,
				[33451] = 2,
				[34759] = 2,
				[34760] = 2,
				[34761] = 2,
				[35285] = 2,
				[35951] = 2,
				[43571] = 2,
				[43646] = 2,
				[43647] = 2,
				[44049] = 2,
				[44071] = 2,
				[45932] = 2,
				[5476] = 3,
				[5527] = 3,
				[6038] = 3,
				[12216] = 3,
				[13927] = 3,
				[13928] = 3,
				[13929] = 3,
				[13932] = 3,
				[13934] = 3,
				[16971] = 3,
				[21072] = 3,
				[21217] = 3,
				[27662] = 3,
				[27663] = 3,
				[27664] = 3,
				[27665] = 3,
				[27666] = 3,
				[27667] = 3,
				[30155] = 3,
				[33052] = 3,
				[33867] = 3,
				[34762] = 3,
				[34763] = 3,
				[34764] = 3,
				[34765] = 3,
				[34766] = 3,
				[34767] = 3,
				[34768] = 3,
				[34769] = 3,
				[37452] = 3,
				[39691] = 3,
				[42942] = 3,
				[42993] = 3,
				[42996] = 3,
				[42998] = 3,
				[42999] = 3,
				[43000] = 3,
				[43268] = 3,
				[43491] = 3,
				[43492] = 3,
				[43572] = 3,
				[43652] = 3,
				[2674] = 4,
				[2675] = 4,
				[4603] = 4,
				[4655] = 4,
				[5468] = 4,
				[5503] = 4,
				[5504] = 4,
				[6289] = 4,
				[6291] = 4,
				[6303] = 4,
				[6308] = 4,
				[6317] = 4,
				[6361] = 4,
				[6362] = 4,
				--[6889] = 4,--小蛋不能吃
				[7974] = 4,
				[8365] = 4,
				[12206] = 4,
				--[12207] = 4,--巨蛋不能吃
				[13754] = 4,
				[13755] = 4,
				[13756] = 4,
				[13758] = 4,
				[13759] = 4,
				[13760] = 4,
				[13888] = 4,
				[13889] = 4,
				[13890] = 4,
				[13893] = 4,
				[15924] = 4,
				[24477] = 4,
				[27422] = 4,
				[27425] = 4,
				[27429] = 4,
				[27435] = 4,
				[27437] = 4,
				[27438] = 4,
				[27439] = 4,
				[27515] = 4,
				[27516] = 4,
				[33823] = 4,
				[33824] = 4,
				[36782] = 4,
				[40199] = 4,
				[41800] = 4,
				[41801] = 4,
				[41802] = 4,
				[41803] = 4,
				[41805] = 4,
				[41806] = 4,
				[41807] = 4,
				[41808] = 4,
				[41809] = 4,
				[41810] = 4,
				[41812] = 4,
				[41813] = 4,
				[41814] = 4,
			},
			[3] = {
				[4536] = 2,
				[4537] = 2,
				[4538] = 2,
				[4539] = 2,
				[4602] = 2,
				[8953] = 2,
				[16168] = 2,
				[19994] = 2,
				[20031] = 2,
				[21030] = 2,
				[21031] = 2,
				[21033] = 2,
				[22324] = 2,
				[27856] = 2,
				[28112] = 2,
				[29393] = 2,
				[29450] = 2,
				[35948] = 2,
				[35949] = 2,
				[37252] = 2,
				[40356] = 2,
				[43087] = 2,
				[11950] = 3,
				[13810] = 3,
				[20516] = 3,
				[24009] = 3,
				[32721] = 3,
			},
			[4] = {
				[3448] = 2,
				[4604] = 2,
				[4605] = 2,
				[4606] = 2,
				[4607] = 2,
				[4608] = 2,
				[8948] = 2,
				[27859] = 2,
				[29453] = 2,
				[30355] = 2,
				[33452] = 2,
				[35947] = 2,
				[41751] = 2,
				[24539] = 3,
				[24008] = 3,
				[27676] = 4,
			},
			[5] = {
				[34062] = 1,
				[43518] = 1,
				[43523] = 1,
				[8076] = 1,
				[4540] = 2,
				[4541] = 2,
				[4542] = 2,
				[4544] = 2,
				[4601] = 2,
				[8950] = 2,
				[13724] = 2,
				[16169] = 2,
				[19301] = 2,
				[19696] = 2,
				[20857] = 2,
				[23160] = 2,
				[24072] = 2,
				[27855] = 2,
				[28486] = 2,
				[29394] = 2,
				[29449] = 2,
				[30816] = 2,
				[33449] = 2,
				[34780] = 2,
				[35950] = 2,
				[42428] = 2,
				[42429] = 2,
				[42430] = 2,
				[42431] = 2,
				[42432] = 2,
				[42433] = 2,
				[42434] = 2,
				[42778] = 2,
				[44609] = 2,
				[2683] = 3,
				[3666] = 3,
				[17197] = 3,
				[43490] = 3,
				[33924] = 3,
			},
			[6] = {
				[414] = 2,
				[422] = 2,
				[1707] = 2,
				[2070] = 2,
				[3927] = 2,
				[8932] = 2,
				[17406] = 2,
				[27857] = 2,
				[29448] = 2,
				[30458] = 2,
				[33443] = 2,
				[35952] = 2,
				[44607] = 2,
				[44608] = 2,
				[44749] = 2,
				[3665] = 3,
				[12218] = 3,
			},
		};
		if PIG_MaxTocversion(20000) then
			local Bread_60 = {[1113] = 1,[1114] = 1,[1487] = 1,[5349] = 1,[8075] = 1,[22895] = 1}
			for k,v in pairs(Bread_60) do
				FoodList[5][k]=v
			end
		end
		local Tooltip = KEY_BUTTON1.."-|cff00FFFF一键喂食宠物|r\r|r"..KEY_BUTTON2.."-|cff00FFFF"..SETTINGS.."食物|r"
		local butW = PetFrameHappiness:GetWidth()
		local Action_l=PIGDiyBut(PetFrameHappiness,{"LEFT", PetFrameHappiness, "RIGHT", 1, 0},{butW,butW,nil,nil,132165},nil,"SecureActionButtonTemplate")
		PetFrameHappiness.Action_l=Action_l
		Action_l:SetAttribute("type1", "spell");
		PIGEnter(Action_l,Tooltip)
		Action_l.Count = PIGFontString(Action_l,{"BOTTOMRIGHT", Action_l, "BOTTOMRIGHT", 0, 1},nil,"OUTLINE")
		Action_l.Count:SetTextColor(1, 1, 1, 1);
		---
		Action_l.Bar = CreateFrame("StatusBar", nil, Action_l);
		Action_l.Bar:SetStatusBarTexture("interface/chatframe/chatframebackground.blp")
		Action_l.Bar:SetStatusBarColor(0, 1, 0 ,0.5);
		Action_l.Bar:SetSize(102,20);
		Action_l.Bar:SetPoint("TOPRIGHT",Action_l,"BOTTOMRIGHT",-3,-1);
		Action_l.Bar:SetMinMaxValues(0, 20)
		Action_l.Bar:Hide()
		Action_l.Bar.bg = Action_l.Bar:CreateTexture(nil, "BACKGROUND");
		Action_l.Bar.bg:SetTexture("interface/characterframe/ui-party-background.blp");
		Action_l.Bar.bg:SetPoint("TOPLEFT",Action_l.Bar,"TOPLEFT",0,0);
		Action_l.Bar.bg:SetPoint("BOTTOMRIGHT",Action_l.Bar,"BOTTOMRIGHT",0,0);
		Action_l.Bar.bg:SetAlpha(0.6)
		Action_l.Bar.txt = PIGFontString(Action_l.Bar,{"CENTER",Action_l.Bar,"CENTER", 0, 0},"","OUTLINE")
		Action_l.Bar.txt:SetTextColor(1, 1, 1 ,0.9);
		Action_l.Bar.spellicon = Action_l.Bar:CreateTexture();
		Action_l.Bar.spellicon:SetSize(20,20);
		Action_l.Bar.spellicon:SetPoint("RIGHT",Action_l.Bar,"LEFT",-0.6, 0);
		Action_l.Bar.spellicon:SetTexture(132165);
		Action_l.Bar.oldtime=0
		Action_l.Bar:HookScript("OnUpdate",  function (self,sss)
			self.oldtime=self.oldtime+sss
			if self.oldtime>0.1 then
				self.oldtime=0
				local time=self.expirationTime-GetTime()
				if time>0 then
					self.txt:SetText(floor(time).."/20")
					self:SetValue(time);
				else
					self:Hide()
				end
			end
		end);
		Action_l.Bar:RegisterUnitEvent("UNIT_AURA","pet");
		Action_l.Bar:HookScript("OnEvent",  function (self,event)
			for j = 1, 4, 1 do
				local name, _, _, _, _, expirationTime, source, isStealable, nameplateShowPersonal,spellId= UnitBuff("pet", j);
				if spellId==1539 then
					self.txt:SetText(name)
					self.expirationTime=expirationTime
					self:Show()
					return
				end
			end
			self:Hide()
		end);
		--
		local butNum = {5,10,butW*1.6}
		Action_l.SeleceFoodF = PIGFrame(Action_l,{"TOPLEFT",Action_l, "TOPRIGHT", 0, 0},{butNum[3]*11+20,butNum[3]*butNum[1]})
		Action_l.SeleceFoodF:PIGSetBackdrop()
		Action_l.SeleceFoodF:Hide()
		Action_l.SeleceFoodF:PIGClose(butW*1.2,butW*1.2)
		Action_l.SeleceFoodF.Close:SetPoint("TOPLEFT", Action_l.SeleceFoodF, "TOPRIGHT",butW,0);
		Action_l.SeleceFoodF.ButLsit={}
		for i=1,butNum[1] do
			local butx=PIGDiyBut(Action_l.SeleceFoodF,{"TOPLEFT", Action_l.SeleceFoodF, "TOPLEFT", 20, -(i-1)*butNum[3]},{butNum[3],butNum[3],nil,nil,132165})
			Action_l.SeleceFoodF.ButLsit[i]=butx
			butx.index = PIGFontString(butx,{"RIGHT", butx, "LEFT", 0, 0},i,"OUTLINE",24)
			butx.Count = PIGFontString(butx,{"BOTTOMRIGHT", butx, "BOTTOMRIGHT", 0, 1},0,"OUTLINE")
			butx.Count:SetTextColor(1, 1, 1, 1);
			butx.liv = PIGFontString(butx,{"TOPLEFT", butx, "TOPLEFT", 1, 0},0,"OUTLINE")
			butx.liv:SetTextColor(1, 1, 1, 1);
			butx:HookScript("OnClick", function(self)
				PIGA_Per["CombatPlus"]["PetFoodList"][i]=nil
				Action_l.SeleceFoodF:ShowItemList()
			end); 
			Action_l.SeleceFoodF.ButLsit[i].ButLsit={}
			for ix=1,butNum[2] do
				local butxx=PIGDiyBut(Action_l.SeleceFoodF,{"LEFT", butx, "LEFT", ix*butNum[3], 0},{butNum[3],butNum[3],nil,nil,132165})
				Action_l.SeleceFoodF.ButLsit[i].ButLsit[ix]=butxx
				butxx.Count = PIGFontString(butxx,{"BOTTOMRIGHT", butxx, "BOTTOMRIGHT", 0, 1},0,"OUTLINE")
				butxx.Count:SetTextColor(1, 1, 1, 1);
				butxx.liv = PIGFontString(butxx,{"TOPLEFT", butxx, "TOPLEFT", 1, 0},0,"OUTLINE")
				butxx.liv:SetTextColor(1, 1, 1, 1);
				butxx.selectz = butxx:CreateTexture("OVERLAY");
				butxx.selectz:SetDrawLayer("OVERLAY", 3)
				butxx.selectz:SetTexture(136814);
				butxx.selectz:SetPoint("TOPLEFT", butxx, "TOPLEFT",butW*0.16,-butW*0.16);
				butxx.selectz:SetPoint("BOTTOMRIGHT", butxx, "BOTTOMRIGHT",-butW*0.16,butW*0.16);
				butxx:HookScript("OnEnter", function(self)
					if self.bag and self.slot then
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(self, "ANCHOR_NONE");
						GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT",0,0);
						GameTooltip:SetBagItem(self.bag,self.slot);
						GameTooltip:Show();
					end
				end);
				butxx:HookScript("OnLeave", function ()
					GameTooltip:ClearLines();
					GameTooltip:Hide() 
				end);	
				butxx:HookScript("OnClick", function(self)
					PIGA_Per["CombatPlus"]["PetFoodList"][i]=self.itemID
					Action_l.SeleceFoodF:ShowItemList()
				end); 
			end
		end
		function Action_l.SeleceFoodF:ShowItemList()
			self:Show()
			for i=1,butNum[1] do
				local butx=self.ButLsit[i]
				butx:Disable()
				butx.icon:SetTexture(132165)
				butx.Count:SetText("")
				butx.liv:SetText("")
				for ix=1,butNum[2] do
					self.ButLsit[i].ButLsit[ix].selectz:Hide()
					self.ButLsit[i].ButLsit[ix]:Hide()
				end
			end
			Action_l:GetBagItemData()
			local cfitem=PIGA_Per["CombatPlus"]["PetFoodList"]
			for i=1,butNum[1] do
				if cfitem[i] then
					local butx=self.ButLsit[i]
					butx:Enable()
					local itemID, itemType, itemSubType, itemEquipLoc, icon= GetItemInfoInstant(cfitem[i]) 
					butx.icon:SetTexture(icon)
					local effectiveILvl, isPreview, baseILvl = GetDetailedItemLevelInfo(cfitem[i])
					butx.liv:SetText(effectiveILvl)
					local ItemCount = C_Item.GetItemCount(cfitem[i])
					if ItemCount>0 then
						butx.Count:SetText(ItemCount)
					else
						butx.Count:SetText("|cffff00000|r")
					end
				end
				local bagnumx = #Action_l.BagItmes
				self:SetWidth((bagnumx+1)*butNum[3]+20)
				for ix=1,bagnumx do
					local butxx=self.ButLsit[i].ButLsit[ix]
					butxx:Show()
					local itemID, itemLink, icon, stackCount, quality=PIGGetContainerItemInfo(Action_l.BagItmes[ix][1],Action_l.BagItmes[ix][2])
					butxx.icon:SetTexture(icon)
					butxx.Count:SetText(stackCount)
					local effectiveILvl, isPreview, baseILvl = GetDetailedItemLevelInfo(itemID)
					butxx.liv:SetText(effectiveILvl)
					butxx.itemID=itemID
					butxx.bag=Action_l.BagItmes[ix][1]
					butxx.slot=Action_l.BagItmes[ix][2]
					if itemID==cfitem[i] then
						butxx.selectz:Show()
					end
				end
			end
			Action_l:PIGSetActionItemID()
		end
		--
		local function GetFoodType()
			local list = {}
			local PetFoodList = {GetStablePetFoodTypes(0)}
			for k,v in pairs(PetFoodList) do
				for kk,vv in pairs(FoodList[FoodIndex[v]]) do
					list[kk]=vv
				end
			end
			return list
		end
		local function IsFoodType(itemID)
			local FoodData=GetFoodType()
			for k,v in pairs(FoodData) do
				if k==itemID then
					return itemID,v
				end
			end
			return false
		end
		local function IsItemOK(itemID,duibidata)
			for i=1,#duibidata do
				if itemID==duibidata[i][3] then
					return true
				end
			end
			return false
		end
		Action_l.BagItmes={}
		function Action_l:GetBagItemData()
			wipe(self.BagItmes)
			for bag=1,#bagData["bagID"] do
				for slot=1,GetContainerNumSlots(bagData["bagID"][bag]) do
					local itemID = GetContainerItemID(bagData["bagID"][bag],slot)
					if itemID then
						local IsFood,TypeID=IsFoodType(itemID)
						if IsFood and not IsItemOK(itemID,self.BagItmes) then
							table.insert(self.BagItmes,{bagData["bagID"][bag],slot,itemID})
						end
					end
				end
			end
		end
		function Action_l:PIGResetAction()
			self.itemID=nil
			self.slotID=nil
			self.itemID=nil
			self.icon:SetTexture(132165);
			self.icon:SetVertexColor(0.5, 0.5, 0.5) 
			self.Count:SetText("|cffff00000|r");
		end
		function Action_l:PIGSetIconCount()
			self.icon:SetVertexColor(0.5, 0.5, 0.5) 
			if self.itemID then
				if C_Item and C_Item.GetItemIconByID then
					local icon = C_Item.GetItemIconByID(self.itemID)
					self.icon:SetTexture(icon)
				end
				local ItemCount = C_Item.GetItemCount(self.itemID)
				self.Count:SetText(ItemCount or 0)
				local usable, noMana = IsUsableSpell(6991)	
				if usable then self.icon:SetVertexColor(1, 1, 1) end
			end	
		end
		function Action_l:PIGSetActionItemID()
			self:PIGResetAction()
			if self:IsSetFoodList() then
				self:GetBagItemData()
				local cfitem=PIGA_Per["CombatPlus"]["PetFoodList"]
				for i=1,butNum[1] do
					if cfitem[i] then
						for ix=1,#Action_l.BagItmes do
							if cfitem[i]==Action_l.BagItmes[ix][3] then
								self.bagID=Action_l.BagItmes[ix][1]
								self.slotID=Action_l.BagItmes[ix][2]
								self.itemID=Action_l.BagItmes[ix][3]
								self:PIGSetIconCount()
								return
							end
						end
					end
				end
			end
		end
		function Action_l:PIGSetSpellName()
			if IsPlayerSpell(6991) then
				local SpellName = GetSpellInfo(6991);
				self.SpellName=SpellName
				self:SetAttribute("spell1", self.SpellName);
				return true
			end
			return false
		end
		function Action_l:IsSetFoodList()
			local cfitem=PIGA_Per["CombatPlus"]["PetFoodList"]
			for i=1,butNum[1] do
				if cfitem[i] then
					return true
				end
			end
			return false
		end
		-- print(GetPetLoyalty())
		-- print(GetPetHappiness())
		-- print(GetPetFoodTypes())
		Action_l:HookScript("PreClick",  function (self,button)
			if InCombatLockdown() then return end
			if button=="LeftButton" then
				if not self:PIGSetSpellName() then
					PIG_OptionsUI:ErrorMsg("<"..self.SpellName..">"..SPELL_FAILED_SKILL_LINE_NOT_KNOWN)
					return
				end
				if not self:IsSetFoodList() then
					PIG_OptionsUI:ErrorMsg("没有设置食物,右键设置")
					return
				end
				self:PIGSetActionItemID()
				if self.itemID then
					self:SetAttribute("target-bag", self.bagID);
					self:SetAttribute("target-slot", self.slotID);
				else
					PIG_OptionsUI:ErrorMsg("设置食物已耗尽")
					return
				end
			end
		end);
		Action_l:SetScript("PostClick",  function (self)
			self:SetAttribute("target-bag", nil);
			self:SetAttribute("target-slot", nil);
		end);
		Action_l:HookScript("OnClick", function(self,button)
			if button=="RightButton" then
				if self.SeleceFoodF:IsShown() then
					self.SeleceFoodF:Hide()
				else
					self.SeleceFoodF:ShowItemList()
				end
			end
		end); 
		Action_l:RegisterEvent("PLAYER_ENTERING_WORLD")
		Action_l:RegisterEvent("PLAYER_REGEN_DISABLED")
		Action_l:RegisterEvent("PLAYER_REGEN_ENABLED")
		Action_l:RegisterEvent("UNIT_PET")
		Action_l:HookScript("OnEvent",  function (self,event)
			if event=="PLAYER_ENTERING_WORLD" then
				self:RegisterEvent("BAG_UPDATE");
			end
			self:PIGSetActionItemID()
		end);
	end
	ADD_PetButFun()
	CombatPlusF.PetHappiness = PIGCheckbutton_R(CombatPlusF,{PET.."喂食助手","在宠物快乐度图标后增加一键喂食按钮"})
	CombatPlusF.PetHappiness:SetScript("OnClick", function (self)
		if self:GetChecked() then
			PIGA["CombatPlus"]["PetHappiness"]=true;
			ADD_PetButFun()
		else
			PIGA["CombatPlus"]["PetHappiness"]=false;
			PIG_OptionsUI.RLUI:Show()
		end
	end)
end
---
CombatPlusF:HookScript("OnShow", function(self)
	CombatPlusF.ammotips:SetChecked(PIGA["CombatPlus"]["ammotips"])
	CombatPlusF.Submerged:SetChecked(PIGA["CombatPlus"]["Submerged"])
	if CombatPlusF.PetHappiness then CombatPlusF.PetHappiness:SetChecked(PIGA["CombatPlus"]["PetHappiness"]) end
end); 
-----------------
function CombatPlusfun.BabySitter()
	ammotipsFun()
	SubmergedFun()
	PetHappinessFun()
end
