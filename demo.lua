--local bagFrame = CreateFrame("Frame",nil,UIParent)
local bagFrame = CreateFrame("Frame")
bagFrame:EnableMouse(true)
local bagText = bagFrame:CreateFontString(nil,"OVERLAY")
bagText:SetFont("Fonts\\ARHei.ttf",12,"THINOUTLINE")
bagText:SetPoint("TOP",UIParent,"TOP",0,0)
local function OnEvent(self, event, ...)
	local free, total, used = 0,0,0
	for i = 0,NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free
	bagText:SetText("backpack:"..free)
	self:SetAllPoint(bagText)
	bagFrame:SetScript("OnEnter", function()
		--GameTooltip位于self的哪个位置
		GameTooltip:SetOwner(self,"ANCHOR_TOP",0,6)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM",self,"TOP",0,1)
		GameTooltip:ClearLines()
		GameTooltip:AddLine("backpack",0,.6,1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Total:",total,0.6,.8,1,1,1,1)
		GameTooltip:AddDoubleLine("Used:",used,.6,.8,1,1,1,1)
		GameTooltip:Show()
	end)
	bagFrame:SetScript("OnLeave",function() GameTooltip:Hide() end)
end
bagFrame:RegisterEvent("PLAYER_LOGIN")
bagFrame:RegisterEvent("BAG_UPDATE")
bagFrame:SetScript("OnEvent",OnEvent)
bagFrame:SetScript("OnMouseDown",function(self,button)
	if button == "RightButton" then
		DEFAULT_CHAT_FRAME:AddMessage("click rb")
	else
		ToggleAllBags()
	end
end)