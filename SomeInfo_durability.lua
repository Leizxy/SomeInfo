local SomeInfo, info = ...

local durability = CreateFrame("Frame",nil,UIParent)
durability:EnableMouse(true)
local durability_Text = durability:CreateFontString(nil,"OVERLAY")
durability_Text:SetFont(unpack(info.Font))
durability:SetAllPoints(durability_Text)
info.Frames["durability"] = durability_Text

local durability_slots = {
	{1 ,"头", 1},
	{3 ,"肩", 1},
	{5 ,"胸", 1},
	{6 ,"腰", 1},
	{9 ,"腕", 1},
	{10,"手", 1},
	{7 ,"腿", 1},
	{8 ,"脚", 1},
	{16,"主", 1},
	{17,"副", 1}
}
durability:SetScript("OnEvent",function(self,event,...)
	local totalDurable, totalMax = 0,0
	for i = 1, #durability_slots do
		if GetInventoryItemLink("player",durability_slots[i][1]) ~= nil then
			local current,max = GetInventoryItemDurability(durability_slots[i][1])
			if current then
				durability_slots[i][3] = current/max
				totalDurable = totalDurable + current
				totalMax = totalMax + max
			end
		end
	end
	if totalDurable and totalMax then
		local per = floor(totalDurable/totalMax*100)
		local color = "|cffffffff"
		if per > 66 then
			color = "|cff0CD809"
		elseif per < 33 then
			color = "|cffE8DA0F"
		else
			color = "|cffD80909"
		end
		durability_Text:SetText(color..floor(totalDurable/totalMax*100).."%|r")
	else
		durability_Text:SetText("")
	end
end)
durability:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		ToggleCharacter("PaperDollFrame")
	end
end)
durability:RegisterEvent("MERCHANT_SHOW")
durability:RegisterEvent("PLAYER_ENTERING_WORLD")
durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")

