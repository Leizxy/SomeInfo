local SomeInfo, info = ...

local SPACE = 8
local border = CreateFrame("Frame",nil,UIParent)
border:SetSize(20,20)
border:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", tile = false, edgeSize=2})
border:SetBackdropColor(0,0,0,1)
border:SetPoint("TOP",info.Frames["system"],"BOTTOM",0,-2)

------------
--	[durability][loot][exp]{[system]}[bag][money][coords]
------------
-- /dump print(C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0))
-- /dump _G["OrderHallCommandBar"]:GetHeight()
-- /dump _G["LE_GARRISON_TYPE_7_0"]
-- print(C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0))


-- if _G["OrderHallCommandBar"]:IsShown() then
	-- info.Frames["system"]:SetPoint("TOP",OrderHallCommandBar,"BOTTOM", 0,-4)
-- else
-- end
-- info.Frames["system"]:SetPoint("TOP", inGarrison and UIParent or _G["OrderHallCommandBar"],"TOP", 0,-4)
info.Frames["system"]:SetPoint("TOP", UIParent,"TOP", 0, -4)
local f = CreateFrame("Frame",nil,UIParent)
local step = 0.5
local count = 1
local update = false
f:SetScript("OnEvent",function(self,event,...)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LOGIN" or event == "ZONE_CHANGED_NEW_AREA" then
		-- print("enter")
		update = true
	end
end)
f:SetScript("OnUpdate",function(self,t) 
	-- if update then 
		local inGarrison = C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0)
		info.Frames["system"]:SetPoint("TOP", UIParent,"TOP", 0,inGarrison and -30 or -4)
		-- count = count + 1
		-- if count >= 5 then
			-- update = false
			-- count = 1
		-- end
	-- end
end)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("PLAYER_LOGIN")
info.Frames["bag"]:SetPoint("LEFT",info.Frames["system"], "RIGHT",SPACE,0)
info.Frames["money"]:SetPoint("LEFT",info.Frames["bag"], "RIGHT",SPACE,0)
info.Frames["coords"]:SetPoint("LEFT",info.Frames["money"].texture, "RIGHT",SPACE,0)
info.Frames["experience"]:SetPoint("RIGHT",info.Frames["system"], "LEFT",-SPACE,0)
info.Frames["loot"]:SetPoint("RIGHT",info.Frames["experience"], "LEFT",-SPACE,0)
info.Frames["durability"]:SetPoint("RIGHT",info.Frames["loot"],"LEFT",-SPACE,0)

--[[	breathcolor   ]]

local COLOR = {
	-- red = 
	{1,0,0},
	-- orange = 
	{1,0.5,0},
	-- yellow = 
	{1,1,0},
	-- green = 
	{0,1,0},
	-- cyan = 
	{0,1,1},
	-- blue = 
	{0,0,1},
	-- purple = 
	{0.5,0,1}
}
local turn = false
local index = 1
local r,g,b = 0,0,0

local function breathcolor(step)
	-- while index <= #COLOR do 
		r = r < COLOR[index][1] and 
			((r + step) <= COLOR[index][1] and (r + step) or COLOR[index][1]) or
			((r - step) >= COLOR[index][1] and (r - step) or COLOR[index][1])
		g = g < COLOR[index][2] and  
			((g + step) <= COLOR[index][2] and (g + step) or COLOR[index][2]) or
			((g - step) >= COLOR[index][2] and (g - step) or COLOR[index][2])
		b = b < COLOR[index][3] and  
			((b + step) <= COLOR[index][3] and (b + step) or COLOR[index][3]) or
			((b - step) >= COLOR[index][3] and (b - step) or COLOR[index][3])
	
		if r == COLOR[index][1] and g == COLOR[index][2] and b == COLOR[index][3] then
			index = index == #COLOR and 1 or index + 1
			-- 
		end
	-- end
end

-- border:SetScript("OnUpdate",function(self,t)
	-- local step = t/3
	-- breathcolor(step)
	
	-- border:SetBackdropBorderColor(r,g,b,1)
-- end)

border:Hide()