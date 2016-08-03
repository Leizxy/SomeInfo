setfenv(1, select(2, ...))

local system = Create("Frame")
system:EnableMouse(true)
local system_Text = system:CreateFontString(nil,"OVERLAY")
system_Text:SetFont(unpack(someInfo.Font))
system_Text:SetPoint(unpack(someInfo.System_position))
system:SetAllPoints(system_Text)
system:SetScript("OnUpdate",onUpdate)

local function onUpdate(self,t)
	logonchat(t)
	
	system_Text:SetText("|cffD809090".."|rFps ".."|cff0CD809".."|rMs")
end
