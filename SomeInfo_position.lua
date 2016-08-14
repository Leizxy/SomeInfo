local SomeInfo, info = ...
-- print("position")
-- print(info.Frames[1])

local step = 6
info.Frames[2]:SetPoint("TOP",UIParent,"TOP", 0,-4)

-- print(info.Frames[1])

info.Frames[1]:SetPoint("LEFT",info.Frames[2], "RIGHT",step,0)
info.Frames[3]:SetPoint("LEFT",info.Frames[1], "RIGHT",step,0)