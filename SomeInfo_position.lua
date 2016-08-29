local SomeInfo, info = ...

local step = 8

info.Frames["system"]:SetPoint("TOP",UIParent,"TOP", 0,-4)

------------
--	[coords][exp][system][bag][money]
------------

info.Frames["bag"]:SetPoint("LEFT",info.Frames["system"], "RIGHT",step,0)
info.Frames["money"]:SetPoint("LEFT",info.Frames["bag"], "RIGHT",step,0)
info.Frames["experience"]:SetPoint("RIGHT",info.Frames["system"], "LEFT",-step,0)
info.Frames["coords"]:SetPoint("RIGHT",info.Frames["experience"], "LEFT",-step,0)


--[[	breathcolor   ]]

local color = {
	red = {1,0,0},
	orange = {1,0.5,0},
	yellow = {1,1,0},
	green = {0,1,0},
	cyan = {0,1,1},
	blue = {0,0,1},
	purple = {0.5,0,1}
}
local function breathcolor()
end