local SomeInfo, info = ...
--local info = addon.info

local system = CreateFrame("Frame")
system:EnableMouse(true)
local system_Text = system:CreateFontString(nil,"OVERLAY")
system_Text:SetFont(unpack(info.Font))
system_Text:SetPoint(unpack(info.System_position))

local width,height = system_Text:GetWidth(),system_Text:GetHeight()
info.test("system_Text:"..width..", "..height)

local function setColor(arg)
	if arg < 300 then
		return "|cff0CD809"..arg
	elseif ( arg >= 300 and arg < 500 ) then 
		return "|cffE8DA0F"..arg
	else
		return "|cffD80909"..arg
	end
end
local step = 1
local function Update(self,t)--参数t是秒单位。所以t的值一般都是几ms
	--print(t)
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
	--test
	local func = function()
		GameTooltip:SetOwner(self,"ANCHOR_BOTTOM",0,0)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint(unpack(info.System_gttposi))
		GameTooltip:ClearLines()
		GameTooltip:AddLine(ms.."MS",1,1,1)
		GameTooltip:AddLine("待定",1,1,1)
		GameTooltip:Show()
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
