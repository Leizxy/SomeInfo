local SomeInfo, info = ...

local money = CreateFrame("Frame")
money:EnableMouse(true)
local money_Text = money:CreateFontString(nil,"OVERLAY")
money_Text:SetFont(unpack(info.Font))
money_Text:SetPoint(unpack(info.Money_position))
money:SetAllPoints(money_Text)

local gold_frame = CreateFrame("Frame")
gold_frame:SetPoint("LEFT",money,"RIGHT",1,0)
gold_frame.texture = gold_frame:CreateTexture(nil,"ARTWORK")
gold_frame.texture:SetTexture("Interface\MoneyFrame\UI-GoldIcon")
gold_frame.texture:SetPoint("CENTER",gold_frame,0,0)

-- money ∏Ò ΩªØ
--[[
local function formatMoney(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)
	if gold ~= 0 then
		return format("%s".."|cffffd700g|r".." %s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", gold, silver, copper)
	elseif silver ~= 0 then
		return format("%s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", silver, copper)
	else
		return format("%s".."|cffeda55fc|r", copper)
	end
end
]]

local function formatTextMoney(money)
	return format("%.0f|cffffd700%s|r", money * 0.0001, GOLD_AMOUNT_SYMBOL)
end
--[[
local function FormatTooltipMoney(money)
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ""
	cash = format("%d".."|cffffd700g|r".." %d".."|cffc7c7cfs|r".." %d".."|cffeda55fc|r", gold, silver, copper)		
	return cash
end	
]]


info.ScriptOfFrame(money,"OnEvent",function()
	-- print(GOLD_AMOUNT_SYMBOL)
	local money = GetMoney()
	money_Text:SetText(formatTextMoney(money))
end)


money:RegisterEvent("PLAYER_LOGIN")
money:RegisterEvent("PLAYER_MONEY")
money:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
money:RegisterEvent("SEND_MAIL_COD_CHANGED")
money:RegisterEvent("PLAYER_TRADE_MONEY")
money:RegisterEvent("TRADE_MONEY_CHANGED")