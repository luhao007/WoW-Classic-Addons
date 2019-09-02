--宠物目标
local ToPetFrame = CreateFrame("Button", "UFP_ToPetFrame", PetFrame, "SecureUnitButtonTemplate, SecureHandlerAttributeTemplate");
ToPetFrame:SetFrameLevel(8);
ToPetFrame:SetWidth(96);
ToPetFrame:SetHeight(48);
ToPetFrame:ClearAllPoints();
ToPetFrame:SetPoint("LEFT", PetFrame, "RIGHT", 0, -10);

ToPetFrame:SetAttribute("unit", "pettarget");
RegisterUnitWatch(ToPetFrame);
ToPetFrame:SetAttribute("*type1", "target");
ToPetFrame:RegisterForClicks("AnyUp");

ToPetFrame.Portrait = ToPetFrame:CreateTexture("UFP_ToPetFramePortrait", "BORDER");
ToPetFrame.Portrait:SetWidth(27);
ToPetFrame.Portrait:SetHeight(27);
ToPetFrame.Portrait:ClearAllPoints();
ToPetFrame.Portrait:SetPoint("TOPLEFT", ToPetFrame, "TOPLEFT", 6, -5);

ToPetFrame.Texture = ToPetFrame:CreateTexture("UFP_ToPetFrameTexture", "ARTWORK");
ToPetFrame.Texture:SetTexture("Interface\\TargetingFrame\\UI-PartyFrame");
ToPetFrame.Texture:SetWidth(96);
ToPetFrame.Texture:SetHeight(48);
ToPetFrame.Texture:ClearAllPoints();
ToPetFrame.Texture:SetPoint("TOPLEFT", ToPetFrame, "TOPLEFT", 0, -2);

ToPetFrame.Name = ToPetFrame:CreateFontString("UFP_ToPetFrameName", "ARTWORK", "GameFontNormalSmall");
ToPetFrame.Name:ClearAllPoints();
ToPetFrame.Name:SetPoint("BOTTOMLEFT", ToPetFrame, "BOTTOMLEFT", 33, 39);

ToPetFrame.HealthBar = CreateFrame("StatusBar", "UFP_ToPetFrameHealthBar", ToPetFrame);
ToPetFrame.HealthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
ToPetFrame.HealthBar:SetFrameLevel(2);
ToPetFrame.HealthBar:SetMinMaxValues(0, 100);
ToPetFrame.HealthBar:SetValue(0);
ToPetFrame.HealthBar:SetWidth(53);
ToPetFrame.HealthBar:SetHeight(6);
ToPetFrame.HealthBar:ClearAllPoints();
ToPetFrame.HealthBar:SetPoint("TOPLEFT", ToPetFrame, "TOPLEFT", 35, -9);
ToPetFrame.HealthBar:SetStatusBarColor(0, 1, 0);

ToPetFrame.HPPct = ToPetFrame:CreateFontString("UFP_ToPetFrameHPPct", "ARTWORK", "TextStatusBarText");
ToPetFrame.HPPct:SetFont(GameFontNormal:GetFont(), 10, "OUTLINE");
ToPetFrame.HPPct:SetTextColor(1, 0.75, 0);
ToPetFrame.HPPct:SetJustifyH("LEFT");
ToPetFrame.HPPct:ClearAllPoints();
ToPetFrame.HPPct:SetPoint("LEFT", ToPetFrame.HealthBar, "RIGHT", 2, -4);

ToPetFrame.PowerBar = CreateFrame("StatusBar", "UFP_ToPetFramePowerBar", ToPetFrame);
ToPetFrame.PowerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
ToPetFrame.PowerBar:SetFrameLevel(2);
ToPetFrame.PowerBar:SetMinMaxValues(0, 100);
ToPetFrame.PowerBar:SetValue(0);
ToPetFrame.PowerBar:SetWidth(53);
ToPetFrame.PowerBar:SetHeight(6);
ToPetFrame.PowerBar:ClearAllPoints();
ToPetFrame.PowerBar:SetPoint("TOPLEFT", ToPetFrame, "TOPLEFT", 35, -16);
ToPetFrame.PowerBar:SetStatusBarColor(0, 0, 1);

local pettarget = CreateFrame("Frame");
function UnitFramesPlus_PetTarget()
    UnitFramesPlus_PetTargetAttribute();
    if UnitFramesPlusDB["pet"]["target"] == 1 then
        pettarget:SetScript("OnUpdate", function(self, elapsed)
            self.timer = (self.timer or 0) + elapsed;
            if self.timer >= 0.2 then
                if UnitExists("pettarget") then
                    ToPetFrame.Name:SetText(UnitName("pettarget"));

                    local ToPetNameColor = PowerBarColor[UnitPowerType("pettarget")] or PowerBarColor["MANA"];
                    ToPetFrame.PowerBar:SetStatusBarColor(ToPetNameColor.r, ToPetNameColor.g, ToPetNameColor.b);

                    SetPortraitTexture(ToPetFrame.Portrait, "pettarget");

                    if UnitHealthMax("pettarget") > 0 then
                        ToPetFrame.HealthBar:SetValue(UnitHealth("pettarget") / UnitHealthMax("pettarget") * 100);
                        local ToPetPctText = "";
                        if UnitFramesPlusDB["pet"]["hppct"] == 1 then
                            ToPetPctText = math.floor(UnitHealth("pettarget") / UnitHealthMax("pettarget") * 100).."%";
                        end
                        ToPetFrame.HPPct:SetText(ToPetPctText);
                    else
                        ToPetFrame.HealthBar:SetValue(0);
                        ToPetFrame.HPPct:SetText("");
                    end

                    if UnitPowerMax("pettarget") > 0 then
                        ToPetFrame.PowerBar:SetValue(UnitPower("pettarget") / UnitPowerMax("pettarget") * 100);
                    else
                        ToPetFrame.PowerBar:SetValue(0);
                    end
                else
                    -- ToPetFrame.HealthBar:SetValue(0);
                    -- ToPetFrame.PowerBar:SetValue(0);
                    ToPetFrame.HPPct:SetText("");
                end
                self.timer = 0;
            end
        end);
    else
        -- ToPetFrame.HealthBar:SetValue(0);
        -- ToPetFrame.PowerBar:SetValue(0);
        ToPetFrame.HPPct:SetText("");
        pettarget:SetScript("OnUpdate", nil);
    end
end

function UnitFramesPlus_PetTargetAttributeSet()
    if UnitFramesPlusDB["pet"]["target"] == 1 then
        ToPetFrame:SetAttribute("unit", "pettarget");
    else
        ToPetFrame:SetAttribute("unit", nil);
    end
end

function UnitFramesPlus_PetTargetAttribute()
    if not InCombatLockdown() then
        UnitFramesPlus_PetTargetAttributeSet();
    else
        local func = {};
        func.name = "UnitFramesPlus_PetTargetAttributeSet";
        func.callback = function()
            UnitFramesPlus_PetTargetAttributeSet();            
        end;
        UnitFramesPlus_WaitforCall(func);
    end
end

--宠物目标缩放
function UnitFramesPlus_PetTargetScaleSet(newscale)
    -- local oldscale = oldscale or UnitFramesPlusDB["pet"]["scale"];
    local oldscale = ToPetFrame:GetScale();
    local newscale = newscale or UnitFramesPlusDB["pet"]["scale"];
    if UnitFramesPlusDB["pet"]["target"] == 1 then
        local point, relativeTo, relativePoint, offsetX, offsetY = ToPetFrame:GetPoint();
        ToPetFrame:SetScale(newscale);
        ToPetFrame:ClearAllPoints();
        ToPetFrame:SetPoint(point, relativeTo, relativePoint, offsetX*oldscale/newscale, offsetY*oldscale/newscale);
    end
end

function UnitFramesPlus_PetTargetScale(newscale)
    if not InCombatLockdown() then
        UnitFramesPlus_PetTargetScaleSet(newscale);
    else
        local func = {};
        func.name = "UnitFramesPlus_PetTargetScaleSet";
        func.callback = function()
            UnitFramesPlus_PetTargetScaleSet(newscale);            
        end;
        UnitFramesPlus_WaitforCall(func);
    end
end

--模块初始化
function UnitFramesPlus_PetTargetInit()
    UnitFramesPlus_PetTarget();
end

function UnitFramesPlus_PetTargetLayout()
    UnitFramesPlus_PetTargetScale();
end
