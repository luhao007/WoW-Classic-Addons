local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
local L=addonTable.locale
local Create=addonTable.Create
local PIGButton=Create.PIGButton
--------------
local FramePlusfun=addonTable.FramePlusfun
function FramePlusfun.Loot()
	if not PIGA["FramePlus"]["Loot"] then return end
	if FramePlusfun.Lootyikaiqi then return end
	FramePlusfun.Lootyikaiqi=true
	if tocversion<50000 then
		LootFrame.piglootbut={}
		local pindaoList = {{L["CHAT_QUKBUTNAME"][5],{1, 0.498, 0},"RAID"},{L["CHAT_QUKBUTNAME"][3],{0.6667, 0.6667, 1},"PARTY"},{L["CHAT_QUKBUTNAME"][7],{1, 0.498, 0},"INSTANCE_CHAT"},{L["CHAT_QUKBUTNAME"][4],{0.25, 1, 0.25},"GUILD"}}
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
		local function AddlootBut(i)
			local But = CreateFrame("Button","LootButton"..i,LootFrame, "LootButtonTemplate",i);
			But:ClearAllPoints();
			But:SetPoint("TOPLEFT",LootFrame,"TOPLEFT",9,-(68+(i-1)*41));
			LootFrame.piglootbut[i]=But
		end
		local function PIG_Update_UI()
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
		end
		local function PIG_LootFrame_UpdateButton(index)
			local numLootItems = LootFrame.numLootItems
			if not numLootItems then return end
			if not _G["LootButton"..index] then AddlootBut(index) end
			local button = _G["LootButton"..index];
			local slot = index;
			if ( slot <= numLootItems ) then
				if LootSlotHasItem(slot) or (LootFrame.AutoLootTable and LootFrame.AutoLootTable[slot]) then
					local texture, item, quantity, currencyID, quality, locked, isQuestItem, questId, isActive;
					if(LootFrame.AutoLootTable)then
						local entry = LootFrame.AutoLootTable[slot];
						if( entry.hide ) then
							button:Hide();
							return;
						else
							texture = entry.texture;
							item = entry.item;
							quantity = entry.quantity;
							quality = entry.quality;
							locked = entry.locked;
							isQuestItem = entry.isQuestItem;
							questId = entry.questId;
							isActive = entry.isActive;
						end
					else
						texture, item, quantity, currencyID, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(slot);
					end
					if ( currencyID ) then 
						item, texture, quantity, quality = CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, quantity, item, texture, quality);
					end
					local text = _G["LootButton"..index.."Text"];
					if ( texture ) then
						local color = ITEM_QUALITY_COLORS[quality];
						_G["LootButton"..index.."IconTexture"]:SetTexture(texture);
						text:SetText(item);
						if( locked ) then
							SetItemButtonNameFrameVertexColor(button, 1.0, 0, 0);
							SetItemButtonTextureVertexColor(button, 0.9, 0, 0);
							SetItemButtonNormalTextureVertexColor(button, 0.9, 0, 0);
						else
							SetItemButtonNameFrameVertexColor(button, 0.5, 0.5, 0.5);
							SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0);
							SetItemButtonNormalTextureVertexColor(button, 1.0, 1.0, 1.0);
						end
						text:SetVertexColor(color.r, color.g, color.b);
						local countString = _G["LootButton"..index.."Count"];
						if ( quantity > 1 ) then
							countString:SetText(quantity);
							countString:Show();
						else
							countString:Hide();
						end
						button.slot = slot;
						button.quality = quality;
						button:Enable();
					else
						text:SetText("");
						_G["LootButton"..index.."IconTexture"]:SetTexture(nil);
						SetItemButtonNormalTextureVertexColor(button, 1.0, 1.0, 1.0);
						LootFrame:SetScript("OnUpdate", LootFrame_OnUpdate);
						button:Disable();
					end
					button:Show();
				else
					button:Hide();
				end
			else
				button:Hide();
			end
		end
		local function PIG_LootFrame_Update(self)
			PIG_Update_UI()
			for index=1,self.numLootItems do
				if not _G["LootButton"..index] then AddlootBut(index) end
				PIG_LootFrame_UpdateButton(index)
			end
		end
		local function PIG_LootFrame_Show(self)
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
			if self.numLootItems>4 then
				self:SetHeight(self.numLootItems*41+74)
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
			PIG_LootFrame_Update(self)
		end
		hooksecurefunc("LootFrame_Show", function(self)
			PIG_LootFrame_Show(self)
		end)
		hooksecurefunc("LootFrame_Update", function()
			PIG_LootFrame_Update(LootFrame)
		end)
		LootFrame:HookScript("OnEvent", function(self, event, arg1) 
			if event == "LOOT_SLOT_CHANGED" or event == "LOOT_SLOT_CLEARED" then
				PIG_LootFrame_UpdateButton(arg1)
			end
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
