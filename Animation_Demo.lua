local AddonName = ...
-- 魔兽提供的动画并非属性动画

local frame = CreateFrame("Frame","frame",UIParent)
frame:SetSize(40,40)
frame:SetPoint("CENTER",UIParent,"LEFT",500,0)
frame:SetBackdrop({bgFile="", edgeFile="Interface\\Buttons\\WHITE8X8", tile = false, edgeSize=1})
-- frame:SetBackdropColor(.5,.5,.5,.5)
frame:SetBackdropBorderColor(1,1,1,.8)
frame.texture = frame:CreateTexture(nil,"ARTWORK")
frame.texture:SetTexture("Interface\\AddOns\\"..AddonName.."\\Textures\\priest")
frame.texture:SetAllPoints(frame)


local animationGroup = frame:CreateAnimationGroup("frameAnimGroup",nil)
local translation_animation = animationGroup:CreateAnimation("Translation","anim1",nil)

translation_animation:SetDuration(5)
translation_animation:SetOffset(100,100)--translation x与y偏移值
-- translation_animation:SetStartDelay(1)	--延迟开始
-- translation_animation:SetEndDelay(2)	--结束后延迟
translation_animation:SetTarget(frame.texture)
-- translation_animation:SetSmoothing("OUT") -- IN、IN_OUT、NONE、OUT
-- translation_animation:Play()
animationGroup:SetLooping("BOUNCE")
frame:SetScript("OnMouseDown",function(self,button)
	print("click")
end)
frame:SetScript("OnEnter",function()
	animationGroup:Play()
end)
frame:SetScript("OnUpdate",function(self,t)
	if animationGroup:IsPlaying() then
		elap = translation_animation:GetElapsed()
		
	end
		-- print(translation_animation:IsDone())
	
end)