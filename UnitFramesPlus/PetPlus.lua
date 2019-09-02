--宠物头像内战斗信息
function UnitFramesPlus_PetPortraitIndicator()
    local petregistered = PetFrame:IsEventRegistered("UNIT_COMBAT");
    if UnitFramesPlusDB["pet"]["indicator"] == 1 then
        if not petregistered then
            PetFrame:RegisterUnitEvent("UNIT_COMBAT", "player", "vehicle");
        end
    else
        if petregistered then
            PetFrame:UnregisterEvent("UNIT_COMBAT");
        end
    end
end

--鼠标移过时才显示数值
function UnitFramesPlus_PetBarTextMouseShow()
    if UnitFramesPlusDB["pet"]["mouseshow"] == 1 then
        PetFrameHealthBarText:SetAlpha(0);
        PetFrameHealthBarTextLeft:SetAlpha(0);
        PetFrameHealthBarTextRight:SetAlpha(0);
        PetFrameHealthBar:SetScript("OnEnter",function(self)
            PetFrameHealthBarText:SetAlpha(1);
            PetFrameHealthBarTextLeft:SetAlpha(1);
            PetFrameHealthBarTextRight:SetAlpha(1);
        end);
        PetFrameHealthBar:SetScript("OnLeave",function()
            PetFrameHealthBarText:SetAlpha(0);
            PetFrameHealthBarTextLeft:SetAlpha(0);
            PetFrameHealthBarTextRight:SetAlpha(0);
        end);
        PetFrameManaBarText:SetAlpha(0);
        PetFrameManaBarTextLeft:SetAlpha(0);
        PetFrameManaBarTextRight:SetAlpha(0);
        PetFrameManaBar:SetScript("OnEnter",function(self)
            PetFrameManaBarText:SetAlpha(1);
            PetFrameManaBarTextLeft:SetAlpha(1);
            PetFrameManaBarTextRight:SetAlpha(1);
        end);
        PetFrameManaBar:SetScript("OnLeave",function()
            PetFrameManaBarText:SetAlpha(0);
            PetFrameManaBarTextLeft:SetAlpha(0);
            PetFrameManaBarTextRight:SetAlpha(0);
        end);
    else
        PetFrameHealthBarText:SetAlpha(1);
        PetFrameHealthBarTextLeft:SetAlpha(1);
        PetFrameHealthBarTextRight:SetAlpha(1);
        PetFrameHealthBar:SetScript("OnEnter",nil);
        PetFrameHealthBar:SetScript("OnLeave",nil);
        PetFrameManaBarText:SetAlpha(1);
        PetFrameManaBarTextLeft:SetAlpha(1);
        PetFrameManaBarTextRight:SetAlpha(1);
        PetFrameManaBar:SetScript("OnEnter",nil);
        PetFrameManaBar:SetScript("OnLeave",nil);
    end
end

--模块初始化
function UnitFramesPlus_PetInit()
    UnitFramesPlus_PetPortraitIndicator();
    UnitFramesPlus_PetBarTextMouseShow();
end
