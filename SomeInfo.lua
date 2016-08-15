--setfenv(1, setmetatable(select(2, ...), { __index = function(self,  key) local v = _G[key]; rawset(self, key, v); return v end })) 
local SomeInfo, info = ...


--print(SomeInfo.." is Loaded")
--提供一些插件的变量
--info = {}
--背包需要的变量
--info.Bag = 
-- frames
info.Frames = {}

-- bag
info.Bag_gttShow = true
-- info.Bag_position = {"TOP", UIParent, "TOP", 24, -2}
info.Bag_gttPosition = {"BOTTOM",self,"TOP",0,5}

-- system
info.System_gttShow = true
-- info.System_position = {"TOP",UIParent,"TOP",-40,-2}
info.System_gttposi = {"BOTTOM",self,"TOP",0,5}

-- money
info.Money_gttShow = true
-- info.Money_position = {"TOP",UIParent,"TOP", 64,-2}
info.Money_gttposi = {"BOTTOM",self,"TOP",0,5}

-- exp
info.Experience_ggtShow = true
info.Experience_ggtposi = {"BOTTOM",self,"TOP",0,5}

--Font
info.Font = {"Fonts\\ARHei.ttf",13,"OUTLINE"}

--addon.info = info

info.test = function(str)
	print("|cffE8DA0F"..str)
end

-- 设置颜色
info.SetColorText = function(num,str)
	if num == 1 then
		return "|cffff0000"..str.."|r"
	elseif num == 2 then
		return "|cff00ff00"..str.."|r"
	elseif num == 3 then
		return "|cff0000ff"..str.."|r"
	elseif num == 4 then --绿
		return "|cff0CD809"..str.."|r"
	elseif num == 5 then --黄？
		return "|cffE8DA0F"..str.."|r"
	elseif num == 6 then --红
		return "|cffD80909"..str.."|r"
	else
		return str
	end
end
-- 职业颜色
local info.change_color = function(color)
	local red = color.r*255<16 and "0"..string.sub(string.format("%#x",color.r*255),3,4) or string.sub(string.format("%#x",color.r*255),3,4)
	local green = color.g*255<16 and "0"..string.sub(string.format("%#x",color.g*255),3,4) or string.sub(string.format("%#x",color.g*255),3,4)
	local blue = color.b*255<16 and "0"..string.sub(string.format("%#x",color.b*255),3,4) or string.sub(string.format("%#x",color.b*255),3,4)
	return "|cff"..red..green..blue
end
local color = RAID_CLASS_COLORS[select(2,UnitClass("player"))]
info.playerClassColor = change_color(color)


-- GTT的一些抽取方法
info.ShowGameToolTip = function(...)
	local frame = select(1,...)
	local func = select(2,...)
	frame:SetScript("OnEnter",function()
		--info.GameTooltip = function() end
		func()
		-- GameTooltip:Show()
	end)
	frame:SetScript("OnLeave",function() GameTooltip:Hide() end)
end

-- 抽取的方法
info.ScriptOfFrame = function(...)
	local frame = select(1,...)
	local event = select(2,...)
	local func = select(3,...)
	frame:SetScript(event,func)
end