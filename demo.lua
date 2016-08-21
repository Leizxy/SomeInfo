-- local bagFrame = CreateFrame("Frame",nil,UIParent)
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
	self:SetAllPoints(bagText)
	bagFrame:SetScript("OnEnter", function()
		-- GameTooltip位于self的哪个位置
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

--[[

/run print(select(1,GetSpecializationInfo(GetSpecialization())))
/run print(GetSpecializationInfo(GetSpecialization()))
/run print(GetSpecialization())
/run print(GetActiveSpecGroup())
/run print(select(2,UnitClass("player")))
/run print(UnitSelectionColor("player"))
/run print(GetNumSpecializationsForClassID(select(3,UnitClass("player")))

GetBackpackCurrencyInfo()1,2,3 --行囊上显示的货币
GetCurrencyInfo(id) -- 根据货币id获取货币信息

GetSelectedFaction()(number)获取显示在经验条上的声望id
GetWatchedFactionInfo()获取显示的声望信息

UnitXP("unit")获取当前经验值
UnitXPMax("unit")经验最大值

UnitGetTotalAbsorbs("player")吸收盾
UnitGetTotalHealAbsorbs("player")

GetCVarInfo("scriptProfile")
UseEquipmentSet("heal")--换装方案

frame:GetSize() --在update里面获取
-- /run SetActiveSpecGroup(263)
-- /run SetSpecialization()

_G["FACTION_STANDING_LABEL".."1"]

]]

