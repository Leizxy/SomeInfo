local SomeInfo, info = ...

local system = CreateFrame("Frame",nil,UIParent)
system:EnableMouse(true)
local system_Text = system:CreateFontString(nil,"OVERLAY")
system_Text:SetFont(unpack(info.Font))
system_Text:SetPoint(unpack(info.System_position))

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
local totalMem = 0
local function getMemory()
	UpdateAddOnMemoryUsage()
	for i = 1, GetNumAddOns() do
		totalMem = totalMem + GetAddOnMemoryUsage(i)
	end
	print(totalMem==gcinfo())
end
local function formatMemory(memory)
	if memory > 999 then
		local mem = memory/1024
		return string.format("%.1fmb",mem)
	else
		local mem = floor(memory)
		return mem.."kb"
	end
end



local step = 1
local function Update(self,t)--参数t是秒单位。所以t的值一般都是几ms
	-- 帧数和延迟
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
		system_Text:SetText(fps.."|rFps "..ms.."|rMs")
	end
	
	-- GameTooltip
	local func = function()
		getMemory()
		if info.System_gttShow then
			GameTooltip:SetOwner(self,"ANCHOR_BOTTOM",0,0)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(unpack(info.System_gttposi))
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(format("%s:",ADDONS),formatMemory(totalMem),1,1,1,1,1,1)
			-- GameTooltip:AddLine(ms.."MS",1,1,1)
			-- GameTooltip:AddLine("待定",1,1,1)
			GameTooltip:Show()
		end
	end
	info.ShowGameToolTip(system,func)
	--[[
	system:SetScript("OnEnter",function()
		GameTooltip:SetOwner(self,"ANCHOR_BOTTOM",0,0)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint(unpack(info.System_gttposi))
		GameTooltip:ClearLines()
		GameTooltip:AddLine(ms.."MS",1,1,1)
		GameTooltip:AddLine("待定",1,1,1)
		GameTooltip:Show()
	end)
	system:SetScript("OnLeave",function() GameTooltip:Hide() end)
	]]
end
system:SetAllPoints(system_Text)
system:SetScript("OnUpdate",Update)
