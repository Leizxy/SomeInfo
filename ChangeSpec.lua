local AddonName = ...

local textures = {
--Interface\AddOns\SomeInfo\Textures
	"Interface\\AddOns\\"..AddonName.."\\Textures\\warrior",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\paladin",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\hunter",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\rogue",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\priest",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\deathknight",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\shaman",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\mage",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\warlock",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\monk",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\druid",
	"Interface\\AddOns\\"..AddonName.."\\Textures\\demonhunter.png"
}

local classId = select(3,UnitClass("player"))
print("2nd/Interface\\AddOns\\SomeInfo\\Textures\\demonhunter")
print(textures[classId])

local mouseIndex_frame = CreateFrame("Frame","frame1",UIParent)
mouseIndex_frame:SetWidth(20)
mouseIndex_frame:SetHeight(20)
mouseIndex_frame:SetPoint("LEFT",UIParent,"LEFT",0,0)
mouseIndex_frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="", tile = false, edgeSize=1})
mouseIndex_frame:SetBackdropColor(.5,.5,.5,.5)
mouseIndex_frame:SetBackdropBorderColor(1,0,1,1)

mouseIndex_frame.texture = mouseIndex_frame:CreateTexture(nil,"ARTWORK")
mouseIndex_frame.texture:SetTexture("Interface\\AddOns\\SomeInfo\\Textures\\demonhunter")
mouseIndex_frame.texture:SetPoint("CENTER",mouseIndex_frame,"CENTER",0,0)
-- mouseIndex_frame.texture:SetAllPoints(mouseIndex_frame)

mouseIndex_frame:EnableMouse(true)
print("mouseIndex_frame")
local class_Frame = CreateFrame("Frame","frame2",UIParent)
class_Frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="", tile = false, edgeSize=1})
class_Frame:SetBackdropColor(.5,.5,.5,.5)
class_Frame:SetBackdropBorderColor(1,0,1,1)
class_Frame:SetWidth(30)
class_Frame:SetHeight(30)
class_Frame:SetPoint("LEFT",mouseIndex_frame,"RIGHT",0,0)
class_Frame.Texture = class_Frame:CreateTexture(nil,"ARTWORK")
class_Frame.Texture:SetTexture(textures[classId])
-- class_Frame.Texture:SetTexture("Interface\\AddOns\\SomeInfo\\Textures\\Alert")
-- class_Frame.Texture:SetPoint("CENTER",class_Frame,"CENTER",0,0)
class_Frame.Texture:SetAllPoints(class_Frame)
-- class_Frame:EnableMouse(true)


-- class_Frame:Hide() --调试用



-- local function class_OnEvent(self, event, ...)
	-- if event == "PLAYER_LOGIN" then
	-- end
-- end


-- mouseIndex_frame:SetScript("OnEnter",function()
	-- print(mouseIndex_frame:GetName().." OnEnter")
	-- class_Frame:Show()
-- end)
-- mouseIndex_frame:SetScript("OnLeave",function()
	-- print(mouseIndex_frame:GetName().." OnLeave")
	-- class_Frame:Hide()
-- end)
-- class_Frame:SetScript("OnEvent",class_OnEvent)
-- class_Frame:SetScript("OnEnter",function()
	-- print(class_Frame:GetName().." OnEnter")
-- end)
-- class_Frame:SetScript("OnLeave",function()
	-- print(class_Frame:GetName().." OnLeave")
-- end)
-- mouseIndex_frame:RegisterEvent("PLAYER_LOGIN")	
-- class_Frame:RegisterEvent("PLAYER_LOGIN")
-- class_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")