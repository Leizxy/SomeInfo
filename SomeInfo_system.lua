local SomeInfo, info = ...

local system = CreateFrame("Frame",nil,UIParent)
system:EnableMouse(true)
local system_Text = system:CreateFontString(nil,"OVERLAY")
system_Text:SetFont(unpack(info.Font))
-- system_Text:SetPoint(unpack(info.System_position))
info.Frames["system"] = system_Text


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
	
	TODO：添加各插件内存和CPU占用（据需求而定吧）
]]

local function getAddonsInformation()
	UpdateAddOnMemoryUsage()
	local totalMem = 0
	local totalAddOns = 0
	local loadedAddons = {}
	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			tinsert(loadedAddons,{select(2,GetAddOnInfo(i)),GetAddOnMemoryUsage(i)})
			totalMem = totalMem + GetAddOnMemoryUsage(i)
			totalAddOns = totalAddOns + 1
		end
	end

	return totalMem,totalAddOns,loadedAddons
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

-- print(for)
local func = function(self)
	-- getMemory()
	print("func")
	if info.System_gttShow then
		local totalMem,totalAddOns,loadedAddons = getAddonsInformation()
		sort(loadedAddons,function(a,b)
			if a and b then
				return a[2] > b[2]
			end
		end)
		GameTooltip:SetOwner(system,"ANCHOR_BOTTOM",0,-5)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint(unpack(info.System_gttposi))
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(format("%s("..info.SetColorText(4,totalAddOns).."):",ADDONS),formatMemory(totalMem),1,1,1,1,1,1)
		GameTooltip:AddLine' '
		for i = 1, #loadedAddons do
			GameTooltip:AddDoubleLine(loadedAddons[i][1],formatMemory(loadedAddons[i][2]),1,1,1,1,1,1)
		end
		-- GameTooltip:Show()
	end
	
end

local step = 0.8
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
		-- func(system)
	end	
end

info.ShowGameToolTip(system,func)

system:SetAllPoints(system_Text)

system:SetScript("OnUpdate",Update)
Update(system,20)
