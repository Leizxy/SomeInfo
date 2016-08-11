local AddonName = ...

local textures = {
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



local mouseIndex_frame = CreateFrame("Frame","index",UIParent)
mouseIndex_frame:SetSize(4,20)
mouseIndex_frame:SetPoint("LEFT",UIParent,"LEFT",0,0)
mouseIndex_frame:MouseEnable(true)

local class_Frame = CreateFrame("Frame","class_Frame",UIParent)
local class_Frame_Texture = class_Frame:CreateTexture(nil,"ARTWORK")
class_Frame_Texture:SetPoint("LEFT",mouseIndex_frame,"RIGHT",2,0)
class_Frame:MouseEnable(true)
class_Frame:Hide() --调试用
local function class_OnEvent(self, event, ...)
	local classId = select(3,UnitClass("player"))
	if event == "PLAYER_LOGIN" then
		class_Frame_Texture:SetTexture(textures[classId])
		class_Frame:SetAllPoints(class_Frame_Texture)
	end
end


mouseIndex_frame:SetScript("OnEnter",function()
	print(self:GetName().." OnEnter")
	class_Frame:Show()
end)
mouseIndex_frame:SetScript("OnLeave",function()
	print(self:GetName().." OnLeave")
	-- class_Frame:Hide()
end)
class_Frame:SetScript("OnEvent",class_OnEvent)
class_Frame:SetScript("OnEnter",function()
	print(self:GetName().." OnEnter")
end)
class_Frame:SetScript("OnLeave",function()
	print(self:GetName().." OnLeave")
end)
mouseIndex_frame:RegisterEvent("PLAYER_LOGIN")	
class_Frame:RegisterEvent("PLAYER_LOGIN")
class_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")