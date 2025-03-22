local addonName, addonTable = ...;
local L=addonTable.locale
local Create = addonTable.Create
local FontUrl=Create.FontUrl
local PIGSetFont=Create.PIGSetFont
-------------------
local match = _G.string.match
----------
local function countDecimalPlaces(num)
    local str = tostring(num)
    local str = select(2, str:match("^(-?%d+)%.(%d+)$")) or ""
    local str = "1" .. string.rep("0", #str)
    return tonumber(str)
end
local function PIGformatter(labelType,danwei,weishu)
	local formatter = function (arg1)
		local arg1 = floor(arg1*weishu+0.5)/weishu
		if danwei and danwei~="" and danwei~=" " then
			if type(danwei)=="function" then
				return danwei(arg1)
			elseif danwei:match("%%s") then
				return format(danwei, arg1)
			elseif danwei:match("%%") and danwei=="%" then
				local arg1 = arg1*100
				return arg1.."%"
			else
				return format(danwei, arg1)
			end
		else
			return arg1
		end
	end
	return formatter;
end
local function SliderPIGInit(self,minValue, maxValue, steps, weizhi)
	local value=value or minValue
	if not self.formatters then
		self.formatters = {};
	end
	local weishu=countDecimalPlaces(steps)
	local weizhiindo={["Left"]=minValue,["Right"]=maxValue,["Top"]=value,["Min"]=minValue,["Max"]=maxValue}
	if weizhi then
		for kv,vv in pairs(weizhi) do
			self.formatters[self.Label[kv]] =  PIGformatter(kv,vv,weishu);
		end
	else
		self.formatters[self.Label["Right"]] =  PIGformatter("Right","",weishu);
	end
	local newsteps =1
	local chazhiV=maxValue - minValue
	if chazhiV<=0 then
	else
		newsteps = chazhiV / steps
	end
	self:Init(value, minValue, maxValue, newsteps,self.formatters)
end
function Create.PIGSlider(fuF,Point,data,WH,UIName)--,{["Right"]="%"}
	local WH=WH or 140
	local SliderF = CreateFrame("Slider", UIName, fuF, "MinimalSliderWithSteppersTemplate")--"OptionsSliderTemplate"
	SliderF:SetWidth(WH);
	SliderF:SetPoint(Point[1],Point[2],Point[3],Point[4],Point[5]);
	SliderF:SetObeyStepOnDrag(true);
	SliderF.Slider:HookScript("OnEnter", function (self)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,0);
		local fujii=self:GetParent()
		if fujii.tooltipFunc then
			fujii.tooltipFunc();
		elseif fujii.tooltipText then
			GameTooltip:AddLine(fujii.tooltipText, 1, 1, 1, 1, true);
			if fujii.tooltipText1 then
				GameTooltip:AddLine(fujii.tooltipText1, nil, nil, nil, nil, true);
			end
		else
			GameTooltip:AddLine("拖动滑块调整数值", 1, 1, 1, 1, true);
		end
		GameTooltip:Show();
	end);
	SliderF.Slider:HookScript("OnLeave",function () 
		GameTooltip:ClearLines();
		GameTooltip:Hide()
	end);
	function SliderF:SliderPIGInit(data)
		SliderPIGInit(self,unpack(data))
	end
	SliderF:SliderPIGInit(data)
	if SliderF.SetEnabled_ then
		hooksecurefunc(SliderF, "SetEnabled", function(self,enabled)
			self:SetEnabled_(enabled)
			self.Slider:SetEnabled(enabled)
		end)
	end
	function SliderF:PIGSetValue(value)
		local OLD_OnValueChanged=self.Slider:GetScript("OnValueChanged")
		self.Slider:SetScript("OnValueChanged", function() end)
		self:FormatValue(value);
		self.Slider:SetValue(value);
		self.Slider:HookScript("OnValueChanged", OLD_OnValueChanged)
	end
	function SliderF:PIGSetValueMinMax(value,min,max,steps)
		local steps=steps or 1
		self.Slider:SetValueStep(steps);
		self.Slider:SetMinMaxValues(min,max);
		self:PIGSetValue(value)
	end
	SliderF.Slider:HookScript("OnValueChanged", function(self, arg1)
		self:GetParent().Value=arg1
	end)
	function SliderF:GetValue()
		return self.Value or 0
	end
	return SliderF
end