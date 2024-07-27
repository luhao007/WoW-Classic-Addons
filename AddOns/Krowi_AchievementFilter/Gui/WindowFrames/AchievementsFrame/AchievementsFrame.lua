local _, addon = ...;
addon.Gui.AchievementsFrame = {};
local achievementsFrame = addon.Gui.AchievementsFrame;

function achievementsFrame:Load()
	local frame = CreateFrame("Frame", "KrowiAF_AchievementsFrame", AchievementFrame, "KrowiAF_AchievementsFrame_Template");
	frame:SetPoint("TOPLEFT", KrowiAF_CategoriesFrame, "TOPRIGHT", 0, 0);
	frame:SetPoint("BOTTOM", 0, 20);
	frame:SetPoint("RIGHT", -20, 0);
	tinsert(addon.Gui.SubFrames, frame);
	addon.Gui.AchievementsFrame = nil;
end