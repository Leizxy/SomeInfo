local SomeInfo, info = ...

local system = CreateFrame("Frame",nil,UIParent)
system:EnableMouse(true)
local system_Text = system:CreateFontString(nil,"OVERLAY")
system_Text:SetFont(unpack(info.Font))
-- system_Text:SetPoint(unpack(info.System_position))
info.Frames["system"] = system_Text

local step = 0.5 -- update间隔

local function setColor(arg)
	if arg < 300 then
		return "|cff0CD809"..arg
	elseif ( arg >= 300 and arg < 500 ) then 
		return "|cffE8DA0F"..arg
	else
		return "|cffD80909"..arg
	end
end
-- 插件内存
--[[
	UpdateAddOnMemoryUsage() // 扫描每个插件并更新他们各自使用的内存
	GetNumAddOns() // 获取加载了多少个插件
	GetAddOnMemoryUsage(int) // 获取某个插件所使用的内存
]]



local function getAddonsInformation()
	UpdateAddOnMemoryUsage()
	UpdateAddOnCPUUsage()
	local totalMem = 0
	local totalAddOns = 0
	local totalCPU = 0
	local loadedAddons = {}
	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			tinsert(loadedAddons,{select(2,GetAddOnInfo(i)),GetAddOnMemoryUsage(i),GetAddOnCPUUsage(i)})
			totalMem = totalMem + GetAddOnMemoryUsage(i)
			totalCPU = totalCPU + GetAddOnCPUUsage(i)
			totalAddOns = totalAddOns + 1
		end
	end

	return totalMem,totalCPU,totalAddOns,loadedAddons
end

local function formatMemory(memory)
	if memory > 999 then
		local mem = memory/1024
		return string.format("%.2fmb",mem)
	else
		local mem = floor(memory)
		return mem.."kb"
	end
end


local func = function(self)
	if info.System_gttShow then
		local totalMem,totalCPU,totalAddOns,loadedAddons = getAddonsInformation()
		local maxAddons = 5
		sort(loadedAddons,function(a,b)
			if a and b then
				return a[2] > b[2]
			end
		end)
		GameTooltip:SetOwner(self,"ANCHOR_BOTTOM",0,-5)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint(unpack(info.System_gttposi))
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(format("%s("..info.SetColorText(4,totalAddOns).."):",ADDONS),formatMemory(totalMem),1,1,1,1,1,1)
		GameTooltip:AddLine' '
		if IsShiftKeyDown() then
			-- step = 0
			maxAddons = #loadedAddons
			-- Update(self,20)
		else
			maxAddons = math.min(maxAddons, #loadedAddons)
		end
		-- color
		for i = 1, maxAddons do
			local color = loadedAddons[i][2] <= 102.4 and {0,1} -- 0 - 100
			or loadedAddons[i][2] <= 512 and {0.75,1} -- 100 - 512
			or loadedAddons[i][2] <= 1024 and {1,1} -- 512 - 1mb
			or loadedAddons[i][2] <= 2560 and {1,0.75} -- 1mb - 2.5mb
			or loadedAddons[i][2] <= 5120 and {1,0.5} -- 2.5mb - 5mb
			or {1,0.1} -- 5mb +
			GameTooltip:AddDoubleLine(loadedAddons[i][1], formatMemory(loadedAddons[i][2]), 1, 1, 1, color[1], color[2], 0)						
		end
		GameTooltip:Show()
	end
	
end


local function Update(self,t)--参数t是秒单位。所以t的值一般都是几ms
	-- 帧数和延迟
		-- GameTooltip
	step = step - t 
	local fps = ""
	local ms = ""
	if step < 0 then
		local down, up, lagHome, lagWorld = GetNetStats()
		ms = setColor(lagHome).."/"..setColor(lagWorld)
		if floor(GetFramerate()) >=30 then
			fps = "|cff0CD809"..floor(GetFramerate())
		elseif (floor(GetFramerate()) > 15 and floor(GetFramerate()) <30) then
			fps = "|cffE8DA0F"..floor(GetFramerate())
		else
			fps = "|cffD80909"..floor(GetFramerate())
		end
		step = 1
		-- print(system_Text:GetSize())
		system_Text:SetText(fps.."|rFps "..ms.."|rMs")
		if self:IsMouseOver() then
			func(system)
		end
		
	end	
end

info.ShowGameToolTip(system,func)

system:SetAllPoints(system_Text)

system:SetScript("OnUpdate",Update)
info.ScriptOfFrame(system,"OnMouseDown",function(self,button)
	if button == "LeftButton" then
		-- 内存清理
		
		local before = gcinfo()
		collectgarbage("collect")
		
		print(format("|cff66C6FF%s:|r %s","清理了",formatMemory(before - gcinfo())))
	else		
	end
end)
info.ScriptOfFrame(system,"OnEvent",function(self,event)
	
	collectgarbage("collect")
	if event == "GUILD_ROSTER_UPDATE" then
		-- *************************************************
		-- ****				公会界面优化				****
		-- *************************************************
		-- local allMembers = select(3,GetNumGuildMembers())
		-- print(allMembers)
		-- if _G["GuildRosterFrame"] ~= nil then
			-- /run _G["GuildRosterContainerButton1String1"]:SetWidth(30)
			-- /run for i = 1, 15 do _G["GuildRosterContainerButton"..i.."String1"]:SetWidth(30) end
		-- end
		-- print("GUILD_ROSTER_UPDATE")
		-- _G["GUILD_ROSTER_STRING_WIDTH_ADJ"]
		-- _G["GuildRosterContainer"].buttons[i]["string1"]:SetWidth(30)
	end
	
end)
system:RegisterEvent("PLAYER_REGEN_ENABLED")
system:RegisterEvent("GUILD_ROSTER_UPDATE")
-- Update(system,20)
