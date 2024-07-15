local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGButton=Create.PIGButton
---BUFF/DEBUFF框架精确时间========
local FramePlusfun=addonTable.FramePlusfun
function FramePlusfun.Loot()
	if not PIGA["FramePlus"]["Loot"] then return end
	if _G["LootButton5"] then return end
	local pindaoList = {{L["CHAT_QUKBUTNAME"][5],{1, 0.498, 0},"RAID"},{L["CHAT_QUKBUTNAME"][3],{0.6667, 0.6667, 1},"PARTY"},{L["CHAT_QUKBUTNAME"][4],{0.25, 1, 0.25},"GUILD"}}
	if tocversion<50000 then
		table.insert(pindaoList,3,{L["CHAT_QUKBUTNAME"][1],{1, 1, 1},"SAY"})
	end
	for i=1,#pindaoList do
		local pBut = PIGButton(LootFrame,nil,{22,22},pindaoList[i][1])
		if tocversion>50000 then
			pBut:SetPoint("BOTTOMLEFT",LootFrame,"TOPLEFT",10+(i-1)*27,0);
		else
			pBut:SetPoint("TOPLEFT",LootFrame,"TOPLEFT",58+(i-1)*27,-30);
		end
		pBut.Text:SetTextColor(unpack(pindaoList[i][2]))
		pBut.pinname=pindaoList[i][3]
		pBut:SetScript("OnClick", function(self)
			local lootNum = GetNumLootItems()
			if lootNum>0 then
				SendChatMessage(LootFrame.lootName.." "..LOOT..":", self.pinname);
				self.kaishijishi=0
				self.xilieID=0
				for x = 1, lootNum do
					local link = GetLootSlotLink(x)
					if link then
						self.kaishijishi=self.kaishijishi+0.6
						C_Timer.After(self.kaishijishi,function()
							self.xilieID=self.xilieID+1
							SendChatMessage(self.xilieID..". "..link, self.pinname);
						end)
					end
				end
			end
		end)
	end
	if tocversion<50000 then
		local function AddlootBut(i)
			local But = CreateFrame("Button","LootButton"..i,LootFrame, "LootButtonTemplate",i);
			But:ClearAllPoints();
			But:SetPoint("TOPLEFT",LootFrame,"TOPLEFT",9,-(68+(i-1)*41));
			LootFrame.piglootbut[i]=But
		end
		LootFrame.piglootbut={}
		hooksecurefunc("LootFrame_Show", function(self)
			local lootName = UnitName("target") or UNKNOWNOBJECT
			self.lootName=lootName
			local regions = {LootFrame:GetRegions()}
			for _,v in pairs(regions) do
				if not v:GetName() then
					v:ClearAllPoints();
					v:SetPoint("TOP",LootFrame,"TOP",10,-4);
				end
			end
			for _,v in pairs(LootFrame.piglootbut) do
				v:Hide()
			end
			--self.numLootItems=12
			if self.numLootItems>4 then
				self:SetHeight(self.numLootItems*41+74)
				for i=5,self.numLootItems do
					if not _G["LootButton"..i] then AddlootBut(i) end
					_G["LootButton"..i]:Show()
					LootFrame_UpdateButton(i)
				end
				if ( GetCVar("lootUnderMouse") == "1" and self.numLootItems>6 ) then
					local _,_,_,xpos,ypos=self:GetPoint()
					local pignypos = ypos
					if ( self.numLootItems>14 ) then
						pignypos = ypos+(self.numLootItems-7)*41
					elseif ( self.numLootItems>10 ) then
						pignypos = ypos+(self.numLootItems-6)*41
					else
						pignypos = ypos+(self.numLootItems-6)*41
					end
					self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", xpos, pignypos);
				end
			else
				self:SetHeight(240)
			end
		end)
		hooksecurefunc("LootFrame_Update", function(self)
			LootFrameUpButton:Hide()
			LootFrameUpButton:ClearAllPoints();
			LootFrameUpButton:SetPoint("RIGHT",LootFrame,"LEFT",0,0);
			LootFrameDownButton:Hide()
			LootFrameDownButton:ClearAllPoints();
			LootFrameDownButton:SetPoint("TOP",LootFrameUpButton,"BOTTOM",0,0);
			LootFramePrev:Hide()
			LootFramePrev:ClearAllPoints();
			LootFramePrev:SetPoint("RIGHT",LootFrameUpButton,"LEFT",0,0);
			LootFrameNext:Hide()
			LootFrameNext:ClearAllPoints();
			LootFrameNext:SetPoint("RIGHT",LootFrameDownButton,"LEFT",0,0);
		end)
	else
		hooksecurefunc(LootFrame, "Open", function(self)
			local lootName = UnitName("target") or UNKNOWNOBJECT
			self.lootName=lootName
			local lootNum = GetNumLootItems()
			if lootNum>4 then
				self:SetHeight(37+lootNum*48);
			end
		end)
	end
end
