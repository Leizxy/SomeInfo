setfenv(1, setmetatable(select(2, ...), { __index = function(self,  key) local v = _G[key]; rawset(self, key, v); return v end })) 

--提供一些插件的变量
someInfo = {}
--背包需要的变量
--someInfo.Bag = 
someInfo.Bag_gttShow = true
someInfo.Bag_position = {"TOP", UIParent, "TOP", 0, 2}
someInfo.Bag_gttPosition = {"BOTTOM",self,"TOP",0,1}

--system
someInfo.System_gttShow = true
someInfo.System_position = {"TOP",UIParent,-50,2}
someInfo.System_gttposi = {"BOTTOM",self,"TOP",0,1}

--Font
someInfo.Font = {"Fonts\\ARHei.ttf",12,"THINOUTLINE"}


--log
function logonchat(str)
	DEFAULT_CHAT_FRAME:AddMessage("|cffff0000"..str)
end


--setfenv(1, setmetatable(select(2, ...), { __index = function(self,  key) local v = _G[key]; rawset(self, key, v); return v end })) 
