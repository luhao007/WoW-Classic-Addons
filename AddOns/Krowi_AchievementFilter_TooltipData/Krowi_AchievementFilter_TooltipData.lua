local _, addon = ...;

for k1, v1 in next, KrowiAF.AdditionalTooltipData do
    for k2, v2 in next, v1 do
        if not addon.Util.IsFunction(v2[1]) then
            tinsert(KrowiAF.AdditionalTooltipData[k1][k2], 1, KrowiAF.AddTooltipData);
        end
    end
end