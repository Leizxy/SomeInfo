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

local function hideFrame(tb)
	for i = 1, #tb do
		if tb[i]:IsShown() then
			-- PlaySound("AchievementMenuClose");
			tb[i]:Hide()
		end
	end
end

local function showOrHideFrame(tb)
	for i = 1, #tb do
		if tb[i]:IsShown() then
			-- PlaySound("AchievementMenuClose");
			tb[i]:Hide()
		else
			-- PlaySound("AchievementMenuOpen");
			tb[i]:Show()
		end
	end
end

local function markLoot(tb)
	for i = 1, #tb do
		if GetLootSpecialization() == specIds[i] then
			tb[i].texture:Show()
		else
			tb[i].texture:Hide()
		end
	end
end

local function child_frame_setSize(frames)
	for i = 1, #frames do
		frames[i]:SetWidth(64)
		frames[i]:SetHeight(20)
		frames[i]:SetPoint("TOP",loot_Text,"BOTTOM",0,-5-((i-1)*21))
	end
end
local function specTexture(fs)
	for i = 1, #fs do
		local j = i
		fs[i]:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="",tile=false,edgeSize=1})
		fs[i]:SetBackdropColor(0,0,0,.4)
		-- fs[i]:SetBackdropBorderColor(playerColor.r,playerColor.g,playerColor.b,.9)
		fs[i].texture = fs[i]:CreateTexture(nil,"ARTWORK")
		fs[i].texture:SetSize(12,12)
		fs[i].texture:SetPoint("LEFT",fs[i],"LEFT",4,0)
		fs[i].text = fs[i]:CreateFontString(nil,"OVERLAY")
		fs[i].text:SetFont(unpack(info.Font))
		fs[i].text:SetPoint("LEFT",fs[i].texture,"RIGHT",8,0)
		if i >= GetSpecialization() then
			-- fs[i].texture:SetTexture(select(4,GetSpecializationInfo(i+1)))
			-- fs[i].text:SetText(select(2,GetSpecializationInfo(i+1)))
			j = i + 1
		end
		fs[i].texture:SetTexture(select(4,GetSpecializationInfo(j)))
		fs[i].text:SetText(unitColorStr..select(2,GetSpecializationInfo(j)).."|r")
		fs[i]:SetScript("OnMouseDown", function(self,button)
			if button == "LeftButton" then
				PlaySoundFile("Interface\\AddOns\\SomeInfo\\Sound\\yuanshi.mp3")
				SetSpecialization(j)
				showOrHideFrame(fs)
			end
		end)
		-- 	显示超过7秒就隐藏
		fs[i]:SetScript("OnShow", function(self)
			C_Timer.After(7,function() 
				PlaySound("AchievementMenuClose");
				self:Hide()
			end)
		end)
		fs[i]:SetScript("OnEnter", function()
			fs[i]:SetBackdropColor(1,1,1,.5)
		end)
		fs[i]:SetScript("OnLeave", function()
			fs[i]:SetBackdropColor(0,0,0,.4)
		end)
	end
end
local function child_frame_setTexture(tb,child)
	local fs = tb[child]
	if child == "Loot" then 
		for i = 1, #fs do 
			fs[i]:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="",tile=false,edgeSize=1})
			fs[i]:SetBackdropColor(0,0,0,.4)
			-- fs[i]:SetBackdropBorderColor(playerColor.r,playerColor.g,playerColor.b,.9)
			fs[i].texture = fs[i]:CreateTexture(nil,"ARTWORK")
			fs[i].texture:SetTexture("Interface\\GROUPFRAME\\UI-Group-MasterLooter")
			fs[i].texture:SetSize(12,12)
			fs[i].texture:SetPoint("LEFT",fs[i],"LEFT",4,0)
			fs[i].text = fs[i]:CreateFontString(nil,"OVERLAY")
			fs[i].text:SetFont(unpack(info.Font))
			fs[i].text:SetText(i==1 and "当前" or unitColorStr..select(2,GetSpecializationInfo(i-1)).."|r")
			fs[i].text:SetPoint("LEFT",fs[i].texture,"RIGHT",8,0)
			fs[i]:SetScript("OnMouseDown", function(self,button)
				if button == "LeftButton" then
					PlaySoundFile("Interface\\AddOns\\SomeInfo\\Sound\\yuanshi.mp3")
					SetLootSpecialization(specIds[i])
					markLoot(fs)
					showOrHideFrame(fs)
				end
			end)
			-- 	显示超过7秒就隐藏
			fs[i]:SetScript("OnShow", function(self)
				C_Timer.After(7,function() 
					PlaySound("AchievementMenuClose");
					self:Hide()
				end)
			end)
			fs[i]:SetScript("OnEnter", function()
				fs[i]:SetBackdropColor(1,1,1,.5)
			end)
			fs[i]:SetScript("OnLeave", function()
				fs[i]:SetBackdropColor(0,0,0,.4)
			end)
		end
	elseif child == "Spec" then
		-- GetSpecialization()  -- 1,2,3,4
		specTexture(fs)
	end
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
	-- if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LOOT_SPEC_UPDATED" then
	local specId = GetLootSpecialization() --== 0 and select(1,GetSpecializationInfo(GetSpecialization())) or GetLootSpecialization()
	-- end
	local specName 
	-- = GetSpecializationNameForSpecID(specId ~= 0 and specId or select(1,GetSpecializationInfo(GetSpecialization()))) --select(2,GetSpecializationInfoByID(specId))
	if specId == 0 then
		specName = GetSpecializationNameForSpecID(select(1,GetSpecializationInfo(GetSpecialization())))
	else
		specName = GetSpecializationNameForSpecID(specId)
	end
	for i = 1, GetNumSpecializations(false,false) do
		specIds[i+1] = select(1,GetSpecializationInfo(i))
		-- tinsert(specIds,select(1,GetSpecializationInfo(i)))
	end
	loot_Text:SetText("Loot:"..unitColorStr..specName.."|r")
	-- if event == "ACTIVE_TALENT_GROUP_CHANGED" then
		if child_frames["Spec"] then
			specTexture(child_frames["Spec"])
		end
	-- end
end)

info.ScriptOfFrame(loot, "OnMouseDown", function(self,button)
	if button == "LeftButton" then
		-- print("left")
		-- 切天赋
		if child_frames["Loot"] then
			hideFrame(child_frames["Loot"])
		end
		if not child_frames["Spec"] then
			createChildFrames("Spec")
		else
			specTexture(child_frames["Spec"])
			showOrHideFrame(child_frames["Spec"])
		end
	elseif button == "RightButton" then
		-- 切换专精拾取
		-- print(unpack(specIds))
		if child_frames["Spec"] then
			hideFrame(child_frames["Spec"])
		end
		if not child_frames["Loot"] then
			createChildFrames("Loot")
			markLoot(child_frames["Loot"])
		else
			showOrHideFrame(child_frames["Loot"])
			markLoot(child_frames["Loot"])
		end
		
	end
end)

loot:RegisterEvent("PLAYER_LOGIN")
loot:RegisterEvent("PLAYER_ENTERING_WORLD")
loot:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
loot:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
