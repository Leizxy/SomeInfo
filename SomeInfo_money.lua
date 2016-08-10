local SomeInfo, info = ...

local money = CreateFrame("Frame")
money:EnableMouse(true)
local money_Text = money:CreateFontString(nil,"OVERLAY")
money_Text:SetFont(unpack(info.Font))
money_Text:SetPoint(unpack(info.Money_position))
money:SetAllPoints(money_Text)

local gold_frame = CreateFrame("Frame")
gold_frame:SetWidth(15)
gold_frame:SetHeight(15)
gold_frame:SetScale(.8)
gold_frame:SetPoint("LEFT",money,"RIGHT",1,0)
gold_frame.texture = gold_frame:CreateTexture(nil,"ARTWORK")
gold_frame.texture:SetTexture("Interface\\MONEYFRAME\\UI-GoldIcon")
gold_frame.texture:SetPoint("CENTER",gold_frame,"CENTER",0,0)

-- money 格式化
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
	local gold = floor(money/10000)
	if gold < 1000 then
		return gold
	elseif gold >= 1000 and gold <1000000 then
		return floor(gold/1000)..","..mod(gold,1000)
	else
		return floor(gold/1000000).."M"
	end
	-- return format("%.0f|cffffd700|r", money * 0.0001)
end
--[[
local function FormatTooltipMoney(money)
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ""
	cash = format("%d".."|cffffd700g|r".." %d".."|cffc7c7cfs|r".." %d".."|cffeda55fc|r", gold, silver, copper)		
	return cash
end	
]]
--[[
	TODO
	将多种货币显示在这儿，好运币，等等，据需求而定。
]]

info.ScriptOfFrame(money,"OnEvent",function()
	-- print(GOLD_AMOUNT_SYMBOL)
	local money = GetMoney()
	money_Text:SetText(formatTextMoney(money))
	
	local func = function()
		if info.Money_gttShow then
			GameTooltip:SetOwner(self,"ANCHOR_BOTTOM",0,0)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(unpack(info.Money_gttposi))
			GameTooltip:ClearLines()
			GameTooltip:AddLine(CURRENCY,0,.6,1)
			GameTooltip:AddLine("  ")
			-- GameTooltip:
			-- GameTooltip:
			
		end
	end
	info.ShowGameToolTip(money,func)
	
end)


money:RegisterEvent("PLAYER_LOGIN")
money:RegisterEvent("PLAYER_MONEY")
money:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
money:RegisterEvent("SEND_MAIL_COD_CHANGED")
money:RegisterEvent("PLAYER_TRADE_MONEY")
money:RegisterEvent("TRADE_MONEY_CHANGED")