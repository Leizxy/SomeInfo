local SomeInfo, info = ...

local loot = CreateFrame("Frame",nil,UIParent)
loot:EnableMouse(true)
local loot_Text = loot:CreateFontString(nil,"OVERLAY")
loot_Text:SetFont(unpack(info.Font))
loot:SetAllPoints(loot_Text)
info.Frames["loot"] = loot_Text

-- "|c"..RAID_CLASS_COLORS[select(2,UnitClass("player"))].colorStr
local playerColor = RAID_CLASS_COLORS[select(2,UnitClass("player"))]
local unitColorStr = "|c"..playerColor.colorStr
local classId = select(3,UnitClass("player"))
local child_frames = {}
local specIds = {0}



local function child_frame_setSize(frames)
	for i = 1, #frames do
		frames[i]:SetWidth(50)
		frames[i]:SetHeight(25)
		frames[i]:SetPoint("TOP",loot_Text,"BOTTOM",0,-5-((i-1)*25))
	end
end

local function child_frame_setTexture(tb,child)
	if child == "Loot" then 
		local fs = tb[child]
		for i = 1, #fs do 
			fs[i]:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="",tile=false,edgeSize=1})
			fs[i]:SetBackdropColor(0,0,0,.5)
			fs[i]:SetBackdropBorderColor(playerColor.r,playerColor.g,playerColor.b,.9)
			fs[i].texture = fs[i]:CreateTexture(nil,"ARTWORK")
			fs[i].texture:SetTexture("Interface\\GROUPFRAME\\UI-Group-MasterLooter")
			fs[i].texture:SetSize(12,12)
			fs[i].texture:SetPoint("LEFT",fs[i],"LEFT",1,0)
			--	TODO
			fs[i].texture:Hide()
			-- specIds[i] == GetLootSpecialization() and fs[i].texture:Show() or fs[i].texture:Hide()
			fs[i].text = fs[i]:CreateFontString(nil,"OVERLAY")
			fs[i].text:SetFont(unpack(info.Font))
			fs[i].text:SetText(i==1 and "当前" or unitColorStr..select(2,GetSpecializationInfo(i-1)).."|r")
			fs[i].text:SetPoint("LEFT",fs[i].texture,"RIGHT",2,0)
		end
	elseif child == "Spec" then
	
	end
	-- for i = 1, #frames do
		-- frames[i].texture = frames[i]:CreateTexture(nil,"ARTWORK")
		-- frames[i].texture:SetTexture()
	-- end
end
--	child frame
local function createChildFrames(child)
	child_frames[child] = {}
	if classId == 11 then 	-- druid
		child_frames[child][1] = CreateFrame("Frame", child.."child_frame1", UIParent) -- default
		child_frames[child][2] = CreateFrame("Frame", child.."child_frame2", UIParent)
		child_frames[child][3] = CreateFrame("Frame", child.."child_frame3", UIParent)
		if child == "Loot" then
			child_frames[child][4] = CreateFrame("Frame", child.."child_frame4", UIParent)
			child_frames[child][5] = CreateFrame("Frame", child.."child_frame5", UIParent)		
		end
	elseif classId == 12 then	-- demonhunter
		child_frames[child][1] = CreateFrame("Frame", child.."child_frame1", UIParent) -- default
		if child == "Loot" then
			child_frames[child][2] = CreateFrame("Frame", child.."child_frame2", UIParent)
			child_frames[child][3] = CreateFrame("Frame", child.."child_frame3", UIParent)
		end
	else
		child_frames[child][1] = CreateFrame("Frame", child.."child_frame1", UIParent) -- default
		child_frames[child][2] = CreateFrame("Frame", child.."child_frame2", UIParent)
		if child == "Loot" then
			child_frames[child][3] = CreateFrame("Frame", child.."child_frame3", UIParent)
			child_frames[child][4] = CreateFrame("Frame", child.."child_frame4", UIParent)
		end
	end
	child_frame_setSize(child_frames[child])
	child_frame_setTexture(child_frames,child)
end


info.ScriptOfFrame(loot,"OnEvent",function()
	local specId = GetLootSpecialization() --== 0 and select(1,GetSpecializationInfo(GetSpecialization())) or GetLootSpecialization()
	local specName = GetSpecializationNameForSpecID(specId ~= 0 and specId or select(1,GetSpecializationInfo(GetSpecialization()))) --select(2,GetSpecializationInfoByID(specId))
	for i = 1, GetNumSpecializations(false,false) do
	-- specIds[i] = select(1,GetSpecializationInfo(i))
		tinsert(specIds,{select(1,GetSpecializationInfo(i))})
	end
	loot_Text:SetText("Loot:"..unitColorStr..specName.."|r")
end)

info.ScriptOfFrame(loot, "OnMouseDown", function(self,button)
	if button == "LeftButton" then
		print("left")
		-- 切天赋
		-- createChildFrames("Spec")
	elseif button == "RightButton" then
		-- 切换专精拾取
		print("right")
		createChildFrames("Loot")
		
		print(#specIds)
	end
end)



-- PLAYER_LOOT_SPEC_UPDATED
loot:RegisterEvent("PLAYER_LOGIN")
loot:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
