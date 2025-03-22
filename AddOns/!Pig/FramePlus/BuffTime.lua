local _, addonTable = ...;
local _, _, _, tocversion = GetBuildInfo()
---BUFF/DEBUFF框架精确时间========
local FramePlusfun=addonTable.FramePlusfun
function FramePlusfun.BuffTime()
	if not PIGA["FramePlus"]["BuffTime"] then return end
	local function Buff_UpdateTime(seconds)
		local d, h, m, s = ChatFrame_TimeBreakDown(seconds);
		if( d > 1 ) then
			return "%dd", d
		elseif d == 1 then
			return "%dd%d", d,h
		elseif( h > 9 ) then
			return "%dh", h
		elseif( h > 0 ) then
			return "%dh%d", h,m
		elseif( m > 9 ) then
			return "%dm", m
		elseif( m > 0 ) then
			return "%dm" ,m
		else
			return "%ds", s
		end
	end
	--local shangcishuaxinTime = 0
	if tocversion<100000 then
		hooksecurefunc("AuraButton_UpdateDuration", function(auraButton, timeLeft)
			auraButton.duration:SetFormattedText(Buff_UpdateTime(timeLeft));
		end);
		hooksecurefunc("AuraButton_Update",function(buttonName, index, filter)
			if filter == "HELPFUL" then
				local buff = _G[buttonName..index]
				if buff and buff:IsShown() then
					buff.duration:SetFormattedText("|cff00ff00N/A|r");
					buff.duration:Show()
				end
			end
		end);
	else
		-- SECONDS_PER_DAY--86400
		-- SECONDS_PER_HOUR--3600
		-- SECONDS_PER_MIN--60
		-- DAY_ONELETTER_ABBR--%d d
		-- HOUR_ONELETTER_ABBR--%d h
		-- MINUTE_ONELETTER_ABBR--%d m
		-- SECOND_ONELETTER_ABBR--%d s
		local auras={BuffFrame.AuraContainer:GetChildren()}
		for i=1,#auras do
			local aurasUI=auras[i]
			hooksecurefunc(aurasUI, "Update", function(self)
				local buttonInfo=self.buttonInfo
				if buttonInfo.expirationTime and buttonInfo.expirationTime == 0 then
			        self.Duration:SetFormattedText("N/A");
					self.Duration:SetVertexColor(0, 1, 0);
					self.Duration:Show()
				end	
			end)
			hooksecurefunc(aurasUI, "UpdateDuration", function(self,timeLeft)
				self.Duration:SetFormattedText(Buff_UpdateTime(timeLeft));
				if timeLeft < 30 then
					self.Duration:SetVertexColor(1, 0.5, 0.3137);
				elseif timeLeft < 600 then
					self.Duration:SetVertexColor(1, 0.686, 0.37647);
				else
					self.Duration:SetVertexColor(0, 1, 0)
				end
			end)
			-- hooksecurefunc(auras[i], "OnUpdate", function(self)
			-- 	self.Duration:SetFontObject(DEFAULT_AURA_DURATION_FONT);
			-- 	self.Duration:ClearAllPoints();
			-- 	self.Duration:SetPoint("TOP", self.Icon, "BOTTOM");
			-- end)
		end
		--
		-- local auras={DebuffFrame.AuraContainer:GetChildren()}
		-- for i=1,#auras do
		-- 	local aurasUI=auras[i]
			-- hooksecurefunc(aurasUI, "Update", function(self)
			-- 	local buttonInfo=self.buttonInfo
			-- 	if buttonInfo.expirationTime and buttonInfo.expirationTime == 0 then
			--         self.Duration:SetFormattedText("N/A");
			-- 		self.Duration:SetVertexColor(0, 1, 0);
			-- 		self.Duration:Show()
			-- 	end	
			-- end)
			-- hooksecurefunc(aurasUI, "UpdateDuration", function(self,timeLeft)
			-- 	self.Duration:SetFormattedText(Buff_UpdateTime(timeLeft));
			-- 	if timeLeft < 30 then
			-- 		self.Duration:SetVertexColor(1, 0.5, 0.3137);
			-- 	elseif timeLeft < 600 then
			-- 		self.Duration:SetVertexColor(1, 0.686, 0.37647);
			-- 	else
			-- 		self.Duration:SetVertexColor(0, 1, 0)
			-- 	end
			-- end)
		-- 	hooksecurefunc(auras[i], "OnUpdate", function(self)
		-- 		self.Duration:SetFontObject(DEFAULT_AURA_DURATION_FONT);
		-- 		self.Duration:ClearAllPoints();
		-- 		self.Duration:SetPoint("TOP", self.Icon, "BOTTOM");
		-- 	end)
		-- end
	end
end
