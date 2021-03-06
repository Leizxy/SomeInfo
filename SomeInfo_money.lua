﻿local SomeInfo, info = ...

local money = CreateFrame("Frame",nil,UIParent)
money:EnableMouse(true)
local money_Text = money:CreateFontString(nil,"OVERLAY")
money_Text:SetFont(unpack(info.Font))
-- money_Text:SetPoint(unpack(info.Money_position))
money:SetAllPoints(money_Text)
money_Text.texture = money:CreateTexture(nil,"ARTWORK")
money_Text.texture:SetTexture("Interface\\MONEYFRAME\\UI-GoldIcon")
money_Text.texture:SetPoint("LEFT",money_Text,"RIGHT",1,0)
-- print(money)
-- print(money_Text)
-- print(info.Frames)
info.Frames["money"] = money_Text
-- print(info.Frames[1])
-- info.Frames[1]:Hide()
-- local gold_frame = CreateFrame("Frame",nil,UIParent)
-- gold_frame:SetWidth(15)
-- gold_frame:SetHeight(15)
-- gold_frame:SetScale(.8)
-- gold_frame:SetPoint("LEFT",money,"RIGHT",1,0)
-- gold_frame.texture = gold_frame:CreateTexture(nil,"ARTWORK")
-- gold_frame.texture:SetTexture("Interface\\MONEYFRAME\\UI-GoldIcon")
-- gold_frame.texture:SetPoint("CENTER",gold_frame,"CENTER",0,0)

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
		local temp = mod(gold,1000)
		if temp < 100 and temp >= 10 then
			temp = "0"..temp
		elseif temp < 10 then
			temp = "00"..temp
		end
		return floor(gold/1000)..","..temp
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
-- 需要显示的货币list
local currencyList = {1101,944,824,823,1129,994,241,1166,1191}
table.sort(currencyList,function(a,b) return a>b end)


info.ScriptOfFrame(money,"OnEvent",function()
	-- print(GOLD_AMOUNT_SYMBOL)
	local allmoney = GetMoney()
	money_Text:SetText(formatTextMoney(allmoney))
	
	local func = function()
		if info.Money_gttShow then
			GameTooltip:SetOwner(money,"ANCHOR_BOTTOMRIGHT",-money_Text:GetWidth(),-5)
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(unpack(info.Money_gttposi))
			GameTooltip:ClearLines()
			-- GameTooltip:SetFont("Fonts\\ARHei.ttf",14,"OUTLINE")
			GameTooltip:AddLine(CURRENCY,0,.6,1)
			GameTooltip:AddLine' '
			-- 文字+图标
			local tb = {}
			if GetBackpackCurrencyInfo(1) ~= nil then
				GameTooltip:AddLine'— — — — —  back  — — — — —'
				for i = 1, GetNumWatchedTokens() do
					local cname, count, icon, cId = GetBackpackCurrencyInfo(i)
					tb[i] = cId
					GameTooltip:AddDoubleLine(("\124T%s:15\124t"):format(icon).." "..cname,count,1,1,1,1,1,1)
				end
				
			end
			for i = 1,#currencyList do
				if currencyList[i] == tb[1] then
					table.remove(currencyList,i)
				elseif currencyList[i] == tb[2] then
					table.remove(currencyList,i)
				elseif currencyList[i] == tb[3] then
					table.remove(currencyList,i)
				end	
			end
			-- GameTooltip:AddLine' '
			GameTooltip:AddLine'— — — — — others — — — — —'
			
			for i = 1, #currencyList do
				local cId = currencyList[i]
				local cname,count,icon,_,_,_,_,_ = GetCurrencyInfo(cId)
				if count > 0 then
					GameTooltip:AddDoubleLine(("\124T%s:15\124t"):format(icon).." "..cname,count,1,1,1,1,1,1)
				end
			end
			GameTooltip:Show()
		end
	end
	info.ShowGameToolTip(money,func)
end)
info.ScriptOfFrame(money,"OnMouseDown",function(self,button)
	if info.Experience_ggtShow then
		if button == "RightButton" then
		else
			ToggleCharacter("TokenFrame")
		end
	end
end)

money:RegisterEvent("PLAYER_LOGIN")
money:RegisterEvent("PLAYER_MONEY")
money:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
money:RegisterEvent("SEND_MAIL_COD_CHANGED")
money:RegisterEvent("PLAYER_TRADE_MONEY")
money:RegisterEvent("TRADE_MONEY_CHANGED")