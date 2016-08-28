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

local class, classFileName = UnitClass("player")
local color = RAID_CLASS_COLORS[classFileName]
-- ChatFrame1:AddMessage(class, color.r, color.g, color.b)
local red = color.r*255<16 and "0"..string.sub(string.format("%#x",color.r*255),3,4) or string.sub(string.format("%#x",color.r*255),3,4)
local green = color.g*255<16 and "0"..string.sub(string.format("%#x",color.g*255),3,4) or string.sub(string.format("%#x",color.g*255),3,4)
local blue = color.b*255<16 and "0"..string.sub(string.format("%#x",color.b*255),3,4) or string.sub(string.format("%#x",color.b*255),3,4)
-- print(red..","..green..","..blue..","..string.format("%#x",color.b*255))

local classId = select(3,UnitClass("player"))
-- print("2nd/Interface\\AddOns\\SomeInfo\\Textures\\demonhunter")
-- print(textures[classId])

local mouseIndex_frame = CreateFrame("Frame","mouseIndex_frame",UIParent)
mouseIndex_frame:SetWidth(4)
mouseIndex_frame:SetHeight(40)
mouseIndex_frame:SetPoint("LEFT",UIParent,"LEFT",0,0)
mouseIndex_frame:EnableMouse(true)

local class_Frame = CreateFrame("Frame","class_Frame",UIParent)
class_Frame:SetWidth(30)
class_Frame:SetHeight(30)
class_Frame:SetPoint("LEFT",mouseIndex_frame,"RIGHT",0,0)
class_Frame.Texture = class_Frame:CreateTexture(nil,"ARTWORK")
class_Frame.Texture:SetTexture(textures[classId])
class_Frame.Texture:SetAllPoints(class_Frame)
-- GetSpecialization()当前专精编号
-- GetSpecializationInfo(GetSpecialization()) id, name, description, icon, background, role("DAMAGER",""TANK","HEALER")
-- GetNumSpecializations(false,false)几个专精
local spec_frame1 = nil
local spec_frame2 = nil
local spec_frame3 = nil
local specID = GetSpecialization()
local step = 3
local countDownStart = false
-- 隐藏
local function hideFrame(...)
	local arg = {...}
	for i = 1, #arg do
		if arg[i] ~= nil then
			-- print(arg[i]:GetName().."hide")
			arg[i]:Hide()
			-- UIFrameFadeIn(arg[i],1,1,0)
		end
	end
end
-- 显示
local function showFrame(...)
	local arg = {...}
	for i = 1, #arg do
		if arg[i] ~= nil then
		-- print(arg[i]:GetName().."show")
			arg[i]:Show()
			-- UIFrameFadeIn(arg[i],1,0,1)
		end
	end
end
-- 
local function addClickScript(frame,i,currentSpec,totalSpec)
	frame:SetScript("OnMouseDown",function(self,button)
		if button == "LeftButton" then
			SetSpecialization(i)
			-- print("left")
			if totalSpec == 2 then
				hideFrame(class_Frame,spec_frame2,spec_frame3)
			elseif totalSpec == 3 then
				if i == 1 then
					hideFrame(class_Frame,spec_frame2,spec_frame3)
				elseif i == 2 then
					if currentSpec == 3 then
						hideFrame(class_Frame,spec_frame1,spec_frame3)
					else
						hideFrame(class_Frame,spec_frame2,spec_frame3)
					end
				elseif i == 3 then 
					hideFrame(class_Frame,spec_frame1,spec_frame3)
				end
			elseif totalSpec == 4 then
				if i == 1 then
					hideFrame(class_Frame,spec_frame2,spec_frame3)
				elseif i == 2 then
					if currentSpec == 1 then
						hideFrame(class_Frame,spec_frame2,spec_frame3)
					else
						hideFrame(class_Frame,spec_frame1,spec_frame3)
					end
				elseif i == 3 then
					if currentSpec == 4 then
						hideFrame(class_Frame,spec_frame1,spec_frame2)
					else
						hideFrame(class_Frame,spec_frame1,spec_frame3)
					end
				elseif i == 4 then
					hideFrame(class_Frame,spec_frame1,spec_frame2)
				end
			end
			-- print("正在切换到|cff"..red..green..blue..select(2,GetSpecializationInfo(i)).."|r专精")
			print("正在切换到|c"..RAID_CLASS_COLORS[select(2,UnitClass("player"))].colorStr..select(2,GetSpecializationInfo(i)).."|r专精")
			-- ChatFrame1:AddMessage("正在切换到"..select(2,GetSpecializationInfo(i)).."专精", color.r, color.g, color.b)
			countDownStart = true
		else
			hideFrame(class_Frame,spec_frame1,spec_frame2,spec_frame3)
		end
	end)
	
	frame:SetScript("OnLeave",function()
		countDownStart = true
	end)
end
local function spec_frames_setsize(...)
	local arg = {...}
	-- print(#arg)
	for i = 1, #arg do
		arg[i]:SetWidth(30)
		arg[i]:SetHeight(30)
		if #arg == 2 then
			arg[i]:SetPoint("LEFT",class_Frame,"RIGHT",0,45-i*30)
		elseif #arg == 1 then
			arg[i]:SetPoint("LEFT",class_Frame,"RIGHT",0,0)
		elseif #arg == 3 then
			arg[i]:SetPoint("LEFT",class_Frame,"RIGHT",0,60-i*30)
		end
	end
end

local function init_frames_textures(currentSpec,totalSpec)
	-- local arg = {...}
	-- local currentSpec = arg[1]
	-- local totalSpec = arg[2]
	-- print(currentSpec.."/"..totalSpec)
	if totalSpec == 2 then
		for i = 1, totalSpec do
			if i == currentSpec then
			else
				spec_frame1.texture = spec_frame1:CreateTexture(nil,"ARTWORK")
				spec_frame1.texture:SetTexture(select(4,GetSpecializationInfo(i)))
				spec_frame1.texture:SetAllPoints(spec_frame1)
				addClickScript(spec_frame1,i,currentSpec,totalSpec)
			end
		end
	elseif totalSpec == 3 then
		for i = 1, totalSpec do
			if i == currentSpec then
			else
				if spec_frame1.texture == nil then
					spec_frame1.texture = spec_frame1:CreateTexture(nil,"ARTWORK")
					spec_frame1.texture:SetTexture(select(4,GetSpecializationInfo(i)))
					spec_frame1.texture:SetAllPoints(spec_frame1)
					addClickScript(spec_frame1,i,currentSpec,totalSpec)
				else
					spec_frame2.texture = spec_frame2:CreateTexture(nil,"ARTWORK")
					spec_frame2.texture:SetTexture(select(4,GetSpecializationInfo(i)))
					spec_frame2.texture:SetAllPoints(spec_frame2)
					addClickScript(spec_frame2,i,currentSpec,totalSpec)
				end
			end
		end
	elseif totalSpec == 4 then
		for i = 1, totalSpec do
			if i == currentSpec then
			else
				if spec_frame1.texture == nil then
					spec_frame1.texture = spec_frame1:CreateTexture(nil,"ARTWORK")
					spec_frame1.texture:SetTexture(select(4,GetSpecializationInfo(i)))
					spec_frame1.texture:SetAllPoints(spec_frame1)
					addClickScript(spec_frame1,i,currentSpec,totalSpec)
				else
					if spec_frame2.texture == nil then
						spec_frame2.texture = spec_frame2:CreateTexture(nil,"ARTWORK")
						spec_frame2.texture:SetTexture(select(4,GetSpecializationInfo(i)))
						spec_frame2.texture:SetAllPoints(spec_frame2)
						addClickScript(spec_frame2,i,currentSpec,totalSpec)
					else
						spec_frame3.texture = spec_frame3:CreateTexture(nil,"ARTWORK")
						spec_frame3.texture:SetTexture(select(4,GetSpecializationInfo(i)))
						spec_frame3.texture:SetAllPoints(spec_frame3)
						addClickScript(spec_frame3,i,currentSpec,totalSpec)
					end
				end
			end
		end
	end
end

local function init_frames()
	if classId == 11 then	-- druid
		spec_frame1 = CreateFrame("Frame","spec_frame1",UIParent)
		spec_frame2 = CreateFrame("Frame","spec_frame2",UIParent)
		spec_frame3 = CreateFrame("Frame","spec_frame3",UIParent)
		spec_frames_setsize(spec_frame1,spec_frame2,spec_frame3)
		init_frames_textures(GetSpecialization(),GetNumSpecializations(false,false))
	elseif classId == 12 then	-- demonhunter
		spec_frame1 = CreateFrame("Frame","spec_frame1",UIParent)
		spec_frames_setsize(spec_frame1)
		init_frames_textures(GetSpecialization(),GetNumSpecializations(false,false))
	else	-- other class
		spec_frame1 = CreateFrame("Frame","spec_frame1",UIParent)
		spec_frame2 = CreateFrame("Frame","spec_frame2",UIParent)
		-- print("other")
		spec_frames_setsize(spec_frame1,spec_frame2)
		
		init_frames_textures(GetSpecialization(),GetNumSpecializations(false,false))
	end
	-- init_frames_textures(GetSpecialization(),GetNumSpecializations(false,false))
	-- spec_frame1:Hide()
	-- spec_frame2:Hide()
	-- spec_frame3:Hide()
	hideFrame(spec_frame1,spec_frame2,spec_frame3)
end


-- class_Frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="", tile = false, edgeSize=1})
-- class_Frame:SetBackdropColor(.5,.5,.5,.5)
-- class_Frame:SetBackdropBorderColor(1,0,1,1)
-- class_Frame.Texture:SetTexture("Interface\\AddOns\\SomeInfo\\Textures\\Alert")
-- class_Frame.Texture:SetPoint("CENTER",class_Frame,"CENTER",0,0)
-- class_Frame:EnableMouse(true)


class_Frame:Hide() --先隐藏




local classFrame_show = false



mouseIndex_frame:SetScript("OnEvent",function(self,event,...)
	if event == "PLAYER_LOGIN" then
		classFrame_show = true
		init_frames()
	elseif event == "PLAYER_REGEN_ENABLED" then
		classFrame_show = true
	elseif event == "PLAYER_REGEN_DISABLED" then
		classFrame_show = false
	elseif event == "PET_BATTLE_OPENING_START" then
		classFrame_show = false
	elseif event == "PET_BATTLE_CLOSE" then
		classFrame_show = true
	elseif event == "UNIT_ENTERED_VEHICLE" then
		classFrame_show = false
	elseif event == "UNIT_EXITED_VEHICLE" then
		classFrame_show = true
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		hideFrame(class_Frame,spec_frame1,spec_frame2,spec_frame3)
		init_frames()
	end
end)
-- 点击区域隐藏
mouseIndex_frame:SetScript("OnMouseDown",function(self,button)
	if button == "RightButton" then
		hideFrame(class_Frame,spec_frame1,spec_frame2,spec_frame3)
	else
		print("left click")
	end
end)
-- 鼠标移到该区域以控制显示
mouseIndex_frame:SetScript("OnEnter",function()
	-- print(mouseIndex_frame:GetName().." OnEnter")
		-- print (classFrame_show)
		-- print (class_Frame:IsShown())
	if classFrame_show then
		if class_Frame:IsShown() then
		else
			class_Frame:Show()
			UIFrameFadeIn(class_Frame,1,0,1.0)
		end
	end
end)
mouseIndex_frame:SetScript("OnLeave",function()
	-- print(mouseIndex_frame:GetName().." OnLeave")
	-- class_Frame:Hide()
end)
mouseIndex_frame:SetScript("OnUpdate",function(self,t)
	if countDownStart then
		step = step - t
	end
	
	if step < 0 then
		hideFrame(class_Frame,spec_frame1,spec_frame2,spec_frame3)
		countDownStart = false
		step = 3
	end
	
end)

-- class_Frame:SetScript("OnEvent",class_OnEvent)
class_Frame:SetScript("OnEnter",function()
	-- print(class_Frame:GetName().." OnEnter :"..tostring(spec_frame1:IsShown()))
	-- print(class_Frame:GetName().." OnEnter :"..tostring(spec_frame1==nil))
	-- hideFrame(spec_frame1,spec_frame2,spec_frame2)	
	showFrame(spec_frame1,spec_frame2,spec_frame3)	
	-- init_frames()
end)
class_Frame:SetScript("OnLeave",function()
	countDownStart = true
end)



mouseIndex_frame:RegisterEvent("PLAYER_LOGIN")	
mouseIndex_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
mouseIndex_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
mouseIndex_frame:RegisterEvent("PLAYER_REGEN_DISABLED")
mouseIndex_frame:RegisterEvent("PET_BATTLE_OPENING_START")
mouseIndex_frame:RegisterEvent("PET_BATTLE_CLOSE")
mouseIndex_frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
mouseIndex_frame:RegisterEvent("UNIT_EXITED_VEHICLE")
mouseIndex_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
class_Frame:RegisterEvent("PLAYER_LOGIN")
