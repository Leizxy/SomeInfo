--setfenv(1, setmetatable(select(2, ...), { __index = function(self,  key) local v = _G[key]; rawset(self, key, v); return v end })) 
local SomeInfo, info = ...


--print(SomeInfo.." is Loaded")
--提供一些插件的变量
--info = {}
--背包需要的变量
--info.Bag = 
info.Bag_gttShow = true
info.Bag_position = {"TOP", UIParent, "TOP", 64, -2}
info.Bag_gttPosition = {"BOTTOM",self,"TOP",0,1}

-- system
info.System_gttShow = true
info.System_position = {"TOP",UIParent,"TOP",0,-2}
info.System_gttposi = {"BOTTOM",self,"TOP",0,1}

--Font
info.Font = {"Fonts\\ARHei.ttf",10,"THINOUTLINE"}

--addon.info = info

info.test = function(str)
	print("|cffff0000"..str)
end

-- 设置颜色
info.SetColorText = function(num,str)
	if num == 1 then
		return "|cffff0000"..str.."|r"
	elseif num == 2 then
		return "|cff00ff00"..str.."|r"
	elseif num == 3 then
		return "|cff0000ff"..str.."|r"
	elseif num == 4 then
		return "|cff0CD809"..str.."|r"
	elseif num == 5 then
		return "|cffE8DA0F"..str.."|r"
	elseif num == 6 then
		return "|cffD80909"..str.."|r"
	else
		return str
	end
end