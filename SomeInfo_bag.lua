local SomeInfo, info = ...

local bag = CreateFrame("Frame",nil,UIParent)--frame
bag:EnableMouse(true)
local bag_text = bag:CreateFontString(nil,"OVERLAY")
bag_text:SetFont(unpack(info.Font))
-- bag_text:SetPoint(unpack(info.Bag_position))

info.Frames["bag"] = bag_text

-- print(bag_text)
-- local width,height = bag_text:GetWidth(),bag_text:GetHeight()

local function OnEvent(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		--print("infight")
		info.Bag_gttShow = false
	elseif event == "PLAYER_REGEN_ENABLED" then
		--print("outfight")
		info.Bag_gttShow = true
	elseif event == "PLAYER_LOGIN" then
		-- print("bag"..bag_text:GetWidth())
	end
	--背包空间计算逻辑
	local free, total, used = 0,0,0
	for i = 0,NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free
	
	bag_text:SetText("背包:"..free)
	self:SetAllPoints(bag_text)

	local func = function()
		if info.Bag_gttShow then
			GameTooltip:SetOwner(self,"ANCHOR_BOTTOMLEFT",-bag_text:GetWidth(),-5)
			GameTooltip:ClearAllPoints()
			-- GameTooltip:SetPoint(unpack(info.Bag_gttPosition))
			-- GameTooltip:SetPoint("BOTTOM",self,"TOPLEFT",0,5)
			GameTooltip:ClearLines()
			GameTooltip:AddLine''
			GameTooltip:AddLine("背包",0,.6,1)
			GameTooltip:AddLine("    ")
			GameTooltip:AddDoubleLine("总计"..":",info.SetColorText(4,total),.6,.8,1,1,1,1)
			GameTooltip:AddDoubleLine("使用"..":",info.SetColorText(4,used),.6,.8,1,1,1,1)
			GameTooltip:AddDoubleLine("")
			GameTooltip:Show()
		end
	end
	info.ShowGameToolTip(bag,func)
	
end
bag:SetScript("OnEvent",OnEvent)
bag:SetScript("OnMouseDown", function(self,button)
	if info.Bag_gttShow then
		if button == "RightButton" then
			print("click rb")
		else
			ToggleAllBags()
		end
	end
end)

bag:RegisterEvent("PLAYER_LOGIN")
bag:RegisterEvent("BAG_UPDATE")
bag:RegisterEvent("PLAYER_REGEN_DISABLED")
bag:RegisterEvent("PLAYER_REGEN_ENABLED")

--自动卖垃圾
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
	--if diminfo.AutoSell == true then
	local c = 0
	for b = 0, 4 do --b是背包选项0~4,0为默认背包
		for s = 1, GetContainerNumSlots(b) do --s是对应背包各物品栏编号
			local l = GetContainerItemLink(b, s)--l 获取某个背包某个编号位置的物品的物品id？
			if l and GetItemInfo(l) ~= nil then
				local p = select(11, GetItemInfo(l)) * select(2, GetContainerItemInfo(b, s))--p=卖价*数量
				if select(3, GetItemInfo(l)) == 0 and p > 0 then
					UseContainerItem(b, s)
					PickupMerchantItem()
					c = c + p
				end
			end
		end
	end
	if c > 0 then
		--print(format("|cff99CCFF"..infoL["Your vendor trash has been sold and you earned"].."|r|cffFFFFFF%.1f|r|cffffd700%s|r", c * 0.0001,GOLD_AMOUNT_SYMBOL))
		local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100 
		-- DEFAULT_CHAT_FRAME:AddMessage("卖垃圾卖了".." |cffffffff"..g.."|cffffc125g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,255)
		DEFAULT_CHAT_FRAME:AddMessage("卖垃圾卖了"..g.."|TInterface\\MONEYFRAME\\UI-GoldIcon:12|t"..s.."|TInterface\\MONEYFRAME\\UI-SilverIcon:12|t"..c.."|TInterface\\MONEYFRAME\\UI-CopperIcon:12|t"..".",255,255,255)
	end
	--end
end)
f:RegisterEvent("MERCHANT_SHOW")


-- 命令卖物品
SLASH_JUSTSELL1 = "/justsell"
SLASH_JUSTSELL2 = "/js"

function SlashCmdList.JUSTSELL(msg,editbox)
	if msg == "" then
		print("|cff0CD809Please write down a number after /justsell or /js (like /justsell 10).")
		print("|cffE8DA0FThis command is to sell something conveniently!")
		print("|cff0CD809请在/justsell或者/js命令后面加上数字（例如：/justsell 10）。")
		print("|cffE8DA0F这个命令是为了方便售卖物品。")
	else
		local sell = false
		-- print(type(msg))
		local number = tonumber(msg)
		-- print(type(number))
		-- print(type(type(number)))
		if type(number) == "number" then
			if number>=1 and number<=12 then
			print("sell "..number)
				sell = true
				local f = CreateFrame("Frame")
				f:SetScript("OnEvent",function()
					-- print("merchant_show")
					for i = 1, number do
						local itemLink = GetContainerItemLink(0,i)
						if itemLink and GetItemInfo(itemLink) ~= nil then
							if select(11,GetItemInfo(itemLink)) >= 0 and sell then
								UseContainerItem(0,i)
								PickupMerchantItem()
							end
						end
					end
					sell = false
				end)
				f:RegisterEvent("MERCHANT_SHOW")
			else
				print("|cff0CD809Please write the number between 1~12")
			end
		else
			print("|cff0CD809Please write down a number after /justsell(like /justsell 10).")
			print("|cffD80909请在/justsell命令后面加上数字（例如：/justsell 10）。")
		end
	end
end

--[自动修理] 
local AutoRepair = true 
local g = CreateFrame("Frame") 
g:RegisterEvent("MERCHANT_SHOW") 
g:SetScript("OnEvent", function()     
   if(AutoRepair==true and CanMerchantRepair()) then 
           local cost = GetRepairAllCost() 
      if cost > 0 then 
         local money = GetMoney() 
         if IsInGuild() then 
            local guildMoney = GetGuildBankWithdrawMoney() 
            if guildMoney > GetGuildBankMoney() then 
               guildMoney = GetGuildBankMoney() 
            end 
            if guildMoney > cost and CanGuildBankRepair() then 
               RepairAllItems(1) 
               print(format("|cfff07100工会修理花费: %.1fg|r", cost * 0.0001)) 
               return 
            end 
         end 
         if money > cost then 
               RepairAllItems() 
               print(format("|cffead000修理花费: %.1fg|r", cost * 0.0001)) 
         else 
            print("Go farm newbie.") 
         end 
      end 
	end 
end)
