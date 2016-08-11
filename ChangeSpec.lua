local AddonName = ...

local textures = {
--Interface\AddOns\SomeInfo\icons
	"Interface\\AddOns\\"..AddonName.."\\icons\\warrior",
	"Interface\\AddOns\\"..AddonName.."\\icons\\paladin",
	"Interface\\AddOns\\"..AddonName.."\\icons\\hunter",
	"Interface\\AddOns\\"..AddonName.."\\icons\\rogue",
	"Interface\\AddOns\\"..AddonName.."\\icons\\priest",
	"Interface\\AddOns\\"..AddonName.."\\icons\\deathknight",
	"Interface\\AddOns\\"..AddonName.."\\icons\\shaman",
	"Interface\\AddOns\\"..AddonName.."\\icons\\mage",
	"Interface\\AddOns\\"..AddonName.."\\icons\\warlock",
	"Interface\\AddOns\\"..AddonName.."\\icons\\monk",
	"Interface\\AddOns\\"..AddonName.."\\icons\\druid",
	"Interface\\AddOns\\"..AddonName.."\\icons\\demonhunter"
}

local classId = select(3,UnitClass("player"))
print(textures[classId])


local mouseIndex_frame = CreateFrame("Frame","index",UIParent)
mouseIndex_frame:SetWidth(20)
mouseIndex_frame:SetHeight(20)
mouseIndex_frame:SetPoint("LEFT",UIParent,"LEFT",0,0)
mouseIndex_frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="", tile = false, edgeSize=1})
mouseIndex_frame:SetBackdropColor(.5,.5,.5,.5)
mouseIndex_frame:SetBackdropBorderColor(1,0,1,1)
mouseIndex_frame:EnableMouse(true)

local class_Frame = CreateFrame("Frame","class_Frame",UIParent)
class_Frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="", tile = false, edgeSize=1})
class_Frame:SetBackdropColor(.5,.5,.5,.5)
class_Frame:SetBackdropBorderColor(1,0,1,1)
class_Frame:SetWidth(30)
class_Frame:SetHeight(30)
class_Frame:SetPoint("LEFT",mouseIndex_frame,"RIGHT",0,0)
class_Frame.Texture = class_Frame:CreateTexture(nil,"ARTWORK")
class_Frame.Texture:SetTexture(textures[classId])
-- class_Frame.Texture:SetTexture("Interface\\MONEYFRAME\\UI-GoldIcon")
class_Frame.Texture:SetPoint("CENTER",class_Frame,"CENTER",0,0)
-- class_Frame_Texture:SetAllPoints(class_Frame)
-- class_Frame:EnableMouse(true)
-- class_Frame:Hide() --调试用
local function class_OnEvent(self, event, ...)
	if event == "PLAYER_LOGIN" then
	end
end


mouseIndex_frame:SetScript("OnEnter",function()
	print(mouseIndex_frame:GetName().." OnEnter")
	-- class_Frame:Show()
end)
mouseIndex_frame:SetScript("OnLeave",function()
	print(mouseIndex_frame:GetName().." OnLeave")
	-- class_Frame:Hide()
end)
class_Frame:SetScript("OnEvent",class_OnEvent)
class_Frame:SetScript("OnEnter",function()
	print(class_Frame:GetName().." OnEnter")
end)
class_Frame:SetScript("OnLeave",function()
	print(class_Frame:GetName().." OnLeave")
end)
mouseIndex_frame:RegisterEvent("PLAYER_LOGIN")	
class_Frame:RegisterEvent("PLAYER_LOGIN")
class_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")