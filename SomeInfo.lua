--setfenv(1, setmetatable(select(2, ...), { __index = function(self,  key) local v = _G[key]; rawset(self, key, v); return v end })) 
local SomeInfo, info = ...


--print(SomeInfo.." is Loaded")
--提供一些插件的变量
--info = {}
--背包需要的变量
--info.Bag = 
info.Bag_gttShow = true
info.Bag_position = {"TOP", UIParent, "TOP", 14, -2}
info.Bag_gttPosition = {"BOTTOM",self,"TOP",0,1}

-- system
info.System_gttShow = true
info.System_position = {"TOP",UIParent,"TOP",-50,-2}
info.System_gttposi = {"BOTTOM",self,"TOP",0,1}

--Font
info.Font = {"Fonts\\ARHei.ttf",10,"THINOUTLINE"}

--addon.info = info

