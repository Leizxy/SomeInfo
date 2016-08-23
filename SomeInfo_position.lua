local SomeInfo, info = ...
-- print("position")
-- print(info.Frames[1])

local step = 8

info.Frames["system"]:SetPoint("TOP",UIParent,"TOP", 0,-4)

-- [exp-4]{system-2}[bag-1][money-3]

info.Frames["bag"]:SetPoint("LEFT",info.Frames["system"], "RIGHT",step,0)
info.Frames["money"]:SetPoint("LEFT",info.Frames["bag"], "RIGHT",step,0)
info.Frames["experience"]:SetPoint("RIGHT",info.Frames["system"], "LEFT",-step,0)